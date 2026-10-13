package tr.velzon.hivelzon.learning;

import java.time.Clock;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.UUID;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import tools.jackson.databind.node.ObjectNode;
import tr.velzon.hivelzon.auth.RateLimiter;
import tr.velzon.hivelzon.common.config.HivelzonProperties;
import tr.velzon.hivelzon.common.crypto.Uuids;
import tr.velzon.hivelzon.common.web.ApiException;
import tr.velzon.hivelzon.common.web.ErrorCode;
import tr.velzon.hivelzon.fsrs.FsrsCard;
import tr.velzon.hivelzon.fsrs.FsrsRating;
import tr.velzon.hivelzon.fsrs.FsrsScheduler;
import tr.velzon.hivelzon.fsrs.FsrsState;
import tr.velzon.hivelzon.sync.SyncDtos.Conflict;
import tr.velzon.hivelzon.sync.SyncPushHook;
import tr.velzon.hivelzon.sync.SyncRow;
import tr.velzon.hivelzon.sync.SyncRowCodec;
import tr.velzon.hivelzon.sync.SyncService;
import tr.velzon.hivelzon.sync.SyncTable;
import tr.velzon.hivelzon.sync.UserSyncLock;
import tr.velzon.hivelzon.user.UserService;

/**
 * Sunucu tarafı FSRS (K-04). <b>Yetkili kaynak cevaplardır (review_logs):</b> bir kartın FSRS durumu, o kartın
 * bütün cevapları ({@code reviewed_at}, sonra {@code client_id} sırasıyla) yeni karttan başlayarak yeniden
 * oynatılarak hesaplanır. Böylece iki cihazda çevrimdışı yapılan tekrarlar birleşir. Mobil, çevrimdışı önce
 * kendi hesabını yapar (aynı algoritma, aynı sonuç); itmede gönderdiği kart durumu sunucunun hesabından
 * farklıysa sunucu kazanır ve {@code SERVER_RECOMPUTED} çatışması döner. Cevabı olmayan (yeni) kart için
 * gönderilen satır olduğu gibi kalır.
 */
@Service
public class ReviewService implements SyncPushHook {

    private static final double REL_TOL = 1e-9;

    public record RateRequest(UUID cardClientId, Integer rating, Instant reviewedAt, UUID clientId, String taskType,
            Boolean correct, Boolean dontKnow, Integer durationMs, Boolean wasNew) {
    }

    public record RateResponse(UUID logClientId, boolean duplicate, ObjectNode card) {
    }

    /** Kartın FSRS alanları (karşılaştırma için). */
    record CardState(int state, Integer step, Double stability, Double difficulty, Instant due, int reps, int lapses,
            Instant lastReview) {

        boolean sameAs(CardState o) {
            return state == o.state && Objects.equals(step, o.step) && close(stability, o.stability)
                    && close(difficulty, o.difficulty) && Objects.equals(due, o.due) && reps == o.reps
                    && lapses == o.lapses && Objects.equals(lastReview, o.lastReview);
        }

        private static boolean close(Double a, Double b) {
            if (a == null || b == null) {
                return a == null && b == null;
            }
            return Math.abs(a - b) <= Math.max(Math.abs(a), Math.abs(b)) * REL_TOL;
        }
    }

    private final JdbcTemplate jdbc;
    private final UserService users;
    private final RateLimiter rateLimiter;
    private final UserSyncLock lock;
    private final HivelzonProperties properties;
    private final Clock clock;
    private final SyncTable cardsTable;
    private final FsrsScheduler scheduler = FsrsScheduler.hivelzon();

    public ReviewService(JdbcTemplate jdbc, UserService users, RateLimiter rateLimiter, UserSyncLock lock,
            HivelzonProperties properties, Clock clock, LearningSyncTables tables) {
        this.jdbc = jdbc;
        this.users = users;
        this.rateLimiter = rateLimiter;
        this.lock = lock;
        this.properties = properties;
        this.clock = clock;
        this.cardsTable = tables.syncTables().stream()
                .filter(t -> t.name().equals(LearningSyncTables.REVIEW_CARDS)).findFirst().orElseThrow();
    }

    /** Çevrimiçi tekrar notu: cevabı kaydeder (idempotent), kartı yeniden hesaplar, yeni durumu döner. */
    @Transactional
    public RateResponse rate(UUID userId, RateRequest req) {
        users.requireActive(userId);
        rateLimiter.acquire("review-rate:" + userId, properties.getSync().getRatePerHour());
        Instant now = clock.instant();
        if (req == null || req.cardClientId() == null || req.rating() == null || req.rating() < 1
                || req.rating() > 4 || req.reviewedAt() == null
                || req.reviewedAt().isAfter(now.plus(properties.getSync().getMaxClockSkew()))
                || (req.taskType() != null && !List.of(LearningSyncTables.TASK_TYPES).contains(req.taskType()))
                || (req.durationMs() != null && (req.durationMs() < 0 || req.durationMs() > 86_400_000))) {
            throw new ApiException(ErrorCode.VALIDATION_FAILED);
        }
        lock.lock(userId);
        Integer exists = jdbc.queryForObject("""
                SELECT count(*) FROM review_cards WHERE user_id = ? AND client_id = ? AND NOT deleted""",
                Integer.class, userId, req.cardClientId());
        if (exists == null || exists == 0) {
            throw new ApiException(ErrorCode.NOT_FOUND);
        }
        UUID logId = req.clientId() != null ? req.clientId()
                : Uuids.v5(Uuids.SYNC_NAMESPACE, "review_logs:" + req.cardClientId() + "|" + req.reviewedAt() + "|"
                        + req.rating());
        boolean wasNew = req.wasNew() != null ? req.wasNew() : Boolean.FALSE.equals(jdbc.queryForObject(
                "SELECT EXISTS (SELECT 1 FROM review_logs WHERE user_id = ? AND card_client_id = ?)", Boolean.class,
                userId, req.cardClientId()));
        OffsetDateTime serverNow = now.atOffset(ZoneOffset.UTC);
        boolean inserted = !jdbc.query("""
                INSERT INTO review_logs (user_id, client_id, seq, server_updated_at, card_client_id, rating,
                    reviewed_at, task_type, correct, dont_know, duration_ms, was_new)
                VALUES (?, ?, nextval('sync_seq'), ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ON CONFLICT (user_id, client_id) DO NOTHING RETURNING 1""", (rs, i) -> 1,
                userId, logId, serverNow, req.cardClientId(), req.rating(), req.reviewedAt().atOffset(ZoneOffset.UTC),
                req.taskType(), req.correct(), Boolean.TRUE.equals(req.dontKnow()), req.durationMs(), wasNew).isEmpty();
        recompute(userId, List.of(req.cardClientId()), serverNow);
        ObjectNode card = selectCards(userId, List.of(req.cardClientId())).get(req.cardClientId());
        return new RateResponse(logId, !inserted, card);
    }

    /** İtmeden sonra: gönderilen kartlar ve cevabı gelen kartlar yeniden hesaplanır. */
    @Override
    public List<Conflict> afterPush(UUID userId, Map<String, List<SyncRow>> rowsByTable) {
        Map<UUID, CardState> pushed = new HashMap<>();
        Set<UUID> affected = new LinkedHashSet<>();
        for (SyncRow row : rowsByTable.getOrDefault(LearningSyncTables.REVIEW_CARDS, List.of())) {
            if (!row.deleted()) {
                pushed.put(row.clientId(), fromValues(row.values()));
                affected.add(row.clientId());
            }
        }
        for (SyncRow row : rowsByTable.getOrDefault(LearningSyncTables.REVIEW_LOGS, List.of())) {
            affected.add((UUID) row.values().get("card_client_id"));
        }
        if (affected.isEmpty()) {
            return List.of();
        }
        Set<UUID> changed = recompute(userId, affected, clock.instant().atOffset(ZoneOffset.UTC));
        Map<UUID, ObjectNode> current = selectCards(userId, affected);
        List<Conflict> conflicts = new ArrayList<>();
        for (UUID id : affected) {
            ObjectNode serverRow = current.get(id);
            if (serverRow == null || serverRow.path("deleted").asBoolean()) {
                continue;
            }
            CardState mine = pushed.get(id);
            boolean differs = mine != null ? !mine.sameAs(fromJson(serverRow)) : changed.contains(id);
            if (differs) {
                conflicts.add(new Conflict(LearningSyncTables.REVIEW_CARDS, id, "SERVER_RECOMPUTED", serverRow));
            }
        }
        return conflicts;
    }

    /**
     * Kartları cevaplarından yeniden hesaplar; değişenleri yazar (yeni {@code seq}). Sabit sayıda okuma (kartlar
     * + cevaplar), yalnızca değişen kart başına bir güncelleme.
     *
     * @return durumu değişen kartlar
     */
    Set<UUID> recompute(UUID userId, Collection<UUID> cardIds, OffsetDateTime serverNow) {
        UUID[] ids = cardIds.toArray(UUID[]::new);
        Map<UUID, CardState> stored = new LinkedHashMap<>();
        jdbc.query("""
                SELECT client_id, state, step, stability, difficulty, due, reps, lapses, last_review
                  FROM review_cards WHERE user_id = ? AND client_id = ANY(?) AND NOT deleted""", rs -> {
            stored.put(rs.getObject("client_id", UUID.class), new CardState(rs.getInt("state"),
                    (Integer) rs.getObject("step"), (Double) rs.getObject("stability"),
                    (Double) rs.getObject("difficulty"), instant(rs.getObject("due", OffsetDateTime.class)),
                    rs.getInt("reps"), rs.getInt("lapses"),
                    instant(rs.getObject("last_review", OffsetDateTime.class))));
        }, userId, ids);
        Map<UUID, List<Object[]>> logs = new HashMap<>();
        jdbc.query("""
                SELECT card_client_id, rating, reviewed_at FROM review_logs
                 WHERE user_id = ? AND card_client_id = ANY(?)
                 ORDER BY card_client_id, reviewed_at, client_id""", rs -> {
            logs.computeIfAbsent(rs.getObject("card_client_id", UUID.class), k -> new ArrayList<>())
                    .add(new Object[] {rs.getInt("rating"), rs.getObject("reviewed_at", OffsetDateTime.class).toInstant()});
        }, userId, ids);
        Set<UUID> changed = new LinkedHashSet<>();
        for (Map.Entry<UUID, CardState> e : stored.entrySet()) {
            List<Object[]> cardLogs = logs.get(e.getKey());
            if (cardLogs == null || cardLogs.isEmpty()) {
                continue; // yeni kart: istemcinin satırı geçerli
            }
            CardState next = replay(cardLogs, e.getValue().due());
            if (next.sameAs(e.getValue())) {
                continue;
            }
            jdbc.update("""
                    UPDATE review_cards SET state = ?, step = ?, stability = ?, difficulty = ?, due = ?, reps = ?,
                           lapses = ?, last_review = ?, updated_at = GREATEST(updated_at, ?),
                           seq = nextval('sync_seq'), server_updated_at = ?
                     WHERE user_id = ? AND client_id = ?""",
                    next.state(), next.step(), next.stability(), next.difficulty(), utc(next.due()), next.reps(),
                    next.lapses(), utc(next.lastReview()), utc(next.lastReview()), serverNow, userId, e.getKey());
            changed.add(e.getKey());
        }
        return changed;
    }

    /** Yeni karttan başlayıp cevapları sırayla uygular (mobil ReviewSession ile aynı reps/lapses kuralı). */
    CardState replay(List<Object[]> logs, Instant initialDue) {
        FsrsCard card = FsrsCard.newCard(initialDue == null ? (Instant) logs.get(0)[1] : initialDue);
        int reps = 0;
        int lapses = 0;
        for (Object[] log : logs) {
            FsrsRating rating = FsrsRating.fromValue((Integer) log[0]);
            boolean lapse = card.state() == FsrsState.REVIEW && rating == FsrsRating.AGAIN;
            card = scheduler.review(card, rating, (Instant) log[1]);
            reps++;
            if (lapse) {
                lapses++;
            }
        }
        return new CardState(card.state().value(), card.step(), card.stability(), card.difficulty(), card.due(), reps,
                lapses, card.lastReview());
    }

    private Map<UUID, ObjectNode> selectCards(UUID userId, Collection<UUID> ids) {
        Map<UUID, ObjectNode> out = new HashMap<>();
        jdbc.query(SyncService.selectSql(cardsTable) + " WHERE user_id = ? AND client_id = ANY(?)", rs -> {
            out.put(rs.getObject("client_id", UUID.class), SyncRowCodec.encode(cardsTable, rs));
        }, userId, ids.toArray(UUID[]::new));
        return out;
    }

    private static CardState fromValues(Map<String, Object> v) {
        return new CardState((Integer) v.get("state"), (Integer) v.get("step"), (Double) v.get("stability"),
                (Double) v.get("difficulty"), instant((OffsetDateTime) v.get("due")), (Integer) v.get("reps"),
                (Integer) v.get("lapses"), instant((OffsetDateTime) v.get("last_review")));
    }

    private static CardState fromJson(ObjectNode n) {
        return new CardState(n.path("state").asInt(), n.path("step").isNull() ? null : n.path("step").asInt(),
                n.path("stability").isNull() ? null : n.path("stability").asDouble(),
                n.path("difficulty").isNull() ? null : n.path("difficulty").asDouble(),
                n.path("due").isNull() ? null : Instant.parse(n.path("due").asString()), n.path("reps").asInt(),
                n.path("lapses").asInt(),
                n.path("lastReview").isNull() ? null : Instant.parse(n.path("lastReview").asString()));
    }

    private static Instant instant(OffsetDateTime t) {
        return t == null ? null : t.toInstant();
    }

    private static OffsetDateTime utc(Instant i) {
        return i == null ? null : i.atOffset(ZoneOffset.UTC);
    }
}
