package tr.velzon.hivelzon.sync;

import java.time.Clock;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import tools.jackson.databind.JsonNode;
import tools.jackson.databind.node.ObjectNode;
import tr.velzon.hivelzon.auth.RateLimiter;
import tr.velzon.hivelzon.common.config.HivelzonProperties;
import tr.velzon.hivelzon.common.web.ApiException;
import tr.velzon.hivelzon.common.web.ErrorCode;
import tr.velzon.hivelzon.sync.SyncDtos.Accepted;
import tr.velzon.hivelzon.sync.SyncDtos.Conflict;
import tr.velzon.hivelzon.sync.SyncDtos.PullResponse;
import tr.velzon.hivelzon.sync.SyncDtos.PushResponse;
import tr.velzon.hivelzon.user.UserDataPurger;
import tr.velzon.hivelzon.user.UserService;

/**
 * Öğrenen verisi eşitleme.
 * <ul>
 * <li><b>İtme</b> tek işlemdir ve kullanıcı başına danışma kilidiyle (pg_advisory_xact_lock) sıralanır: aynı
 * kullanıcının iki itmesi aynı anda gelirse biri ötekini bekler. Önce bütün satırlar doğrulanır (biri bozuksa hiçbiri yazılmaz),
 * sonra tablolar {@link SyncTable#order()} sırasıyla uygulanır.</li>
 * <li><b>Değişebilir</b> tablo: (user_id, client_id) ile ekle-ya-da-güncelle. Gelen zaman sunucudakinden yeniyse
 * yazılır; eşitse ve veri farklıysa sonra gelen (sunucu varış sırası) kazanır; eskiyse {@code STALE} çatışması
 * ve sunucudaki satır döner. Aynı veri tekrar gelirse hiçbir şey değişmez ({@code UNCHANGED}).</li>
 * <li><b>Yalnız eklenen</b> tablo: yoksa eklenir, varsa {@code DUPLICATE} (ilk yazılan kalır).</li>
 * <li>Her yazma {@code sync_seq}'ten yeni sıra alır. Kullanıcının bütün yazmaları aynı kilit altında olduğundan
 * kullanıcının satırlarında sıra = işleme (commit) sırası; çekme imleci satır kaçırmaz.</li>
 * </ul>
 */
@Service
public class SyncService implements UserDataPurger {

    private final JdbcTemplate jdbc;
    private final UserService users;
    private final RateLimiter rateLimiter;
    private final HivelzonProperties properties;
    private final Clock clock;
    private final List<SyncTable> tables;
    private final Map<String, SyncTable> byName;
    private final List<SyncPushHook> hooks;
    private final UserSyncLock lock;

    public SyncService(JdbcTemplate jdbc, UserService users, RateLimiter rateLimiter, HivelzonProperties properties,
            Clock clock, List<SyncTableProvider> providers, List<SyncPushHook> hooks, UserSyncLock lock) {
        this.lock = lock;
        this.jdbc = jdbc;
        this.users = users;
        this.rateLimiter = rateLimiter;
        this.properties = properties;
        this.clock = clock;
        this.tables = providers.stream().flatMap(p -> p.syncTables().stream())
                .sorted(Comparator.comparingInt(SyncTable::order)).toList();
        this.byName = tables.stream().collect(Collectors.toMap(SyncTable::name, t -> t, (a, b) -> {
            throw new IllegalStateException("duplicate sync table " + a.name());
        }, LinkedHashMap::new));
        this.hooks = List.copyOf(hooks);
    }

    public List<SyncTable> tables() {
        return tables;
    }

    public SyncTable table(String name) {
        return byName.get(name);
    }

    private void lockUser(UUID userId) {
        lock.lock(userId);
    }

    @Transactional
    public PushResponse push(UUID userId, JsonNode body) {
        users.requireActive(userId);
        rateLimiter.acquire("sync-push:" + userId, properties.getSync().getPushPerHour());
        if (body == null || !body.isObject()) {
            throw new ApiException(ErrorCode.VALIDATION_FAILED);
        }
        for (String name : body.propertyNames()) {
            if (!List.of("deviceId", "since", "changes").contains(name)) {
                throw new ApiException(ErrorCode.SYNC_FIELD_NOT_ALLOWED, Map.of("field", name));
            }
        }
        JsonNode deviceId = body.get("deviceId");
        if (deviceId != null && !deviceId.isNull()
                && (!deviceId.isString() || !deviceId.asString().matches("[A-Za-z0-9-]{1,64}"))) {
            throw new ApiException(ErrorCode.VALIDATION_FAILED);
        }
        JsonNode changes = body.get("changes");
        if (changes == null || !changes.isObject()) {
            throw new ApiException(ErrorCode.VALIDATION_FAILED);
        }

        // 1) Doğrula (hepsi ya da hiçbiri).
        Instant now = clock.instant();
        int total = 0;
        Map<String, List<SyncRow>> decoded = new HashMap<>();
        for (String name : changes.propertyNames()) {
            SyncTable table = byName.get(name);
            if (table == null) {
                throw new ApiException(ErrorCode.SYNC_ROW_INVALID, Map.of("table", name));
            }
            JsonNode rows = changes.get(name);
            if (!rows.isArray()) {
                throw new ApiException(ErrorCode.SYNC_ROW_INVALID, Map.of("table", name));
            }
            total += rows.size();
            if (total > properties.getSync().getMaxRowsPerPush()) {
                throw new ApiException(ErrorCode.PAYLOAD_TOO_LARGE);
            }
            List<SyncRow> list = new ArrayList<>();
            int i = 0;
            for (JsonNode row : rows) {
                list.add(SyncRowCodec.decode(table, row, i++, now, properties.getSync().getMaxClockSkew()));
            }
            decoded.put(name, list);
        }

        // 2) Uygula.
        lockUser(userId);
        OffsetDateTime serverNow = now.atOffset(ZoneOffset.UTC);
        List<Accepted> accepted = new ArrayList<>();
        List<Conflict> conflicts = new ArrayList<>();
        for (SyncTable table : tables) {
            List<SyncRow> rows = decoded.get(table.name());
            if (rows == null) {
                continue;
            }
            for (SyncRow row : rows) {
                if (table.mutable()) {
                    applyMutable(userId, table, row, serverNow, accepted, conflicts);
                } else {
                    boolean inserted = insertAppendOnly(userId, table, row, serverNow);
                    accepted.add(new Accepted(table.name(), row.clientId(), inserted ? "CREATED" : "DUPLICATE"));
                }
            }
        }
        for (SyncPushHook hook : hooks) {
            for (Conflict c : hook.afterPush(userId, decoded)) {
                conflicts.removeIf(old -> old.table().equals(c.table()) && old.clientId().equals(c.clientId()));
                conflicts.add(c);
            }
        }
        return new PushResponse(accepted, conflicts, now);
    }

    private void applyMutable(UUID userId, SyncTable table, SyncRow row, OffsetDateTime serverNow,
            List<Accepted> accepted, List<Conflict> conflicts) {
        List<SyncField> fields = table.allFields();
        List<String> cols = new ArrayList<>();
        List<String> placeholders = new ArrayList<>();
        List<Object> args = new ArrayList<>(List.of(userId, row.clientId(), serverNow));
        for (SyncField f : fields) {
            cols.add(f.column());
            placeholders.add(f.isJson() ? "?::jsonb" : "?");
            args.add(row.values().get(f.column()));
        }
        cols.add("deleted");
        placeholders.add("?");
        args.add(row.deleted());
        String lww = table.lwwField().column();
        List<String> compared = new ArrayList<>(List.of("deleted"));
        table.dataFields().forEach(f -> compared.add(f.column()));
        String sql = "INSERT INTO " + table.name() + " (user_id, client_id, seq, server_updated_at, "
                + String.join(", ", cols) + ") VALUES (?, ?, nextval('sync_seq'), ?, "
                + String.join(", ", placeholders) + ") ON CONFLICT (user_id, client_id) DO UPDATE SET "
                + "seq = EXCLUDED.seq, server_updated_at = EXCLUDED.server_updated_at, " + lww + " = EXCLUDED." + lww
                + ", " + compared.stream().map(c -> c + " = EXCLUDED." + c).collect(Collectors.joining(", "))
                + " WHERE EXCLUDED." + lww + " > " + table.name() + "." + lww + " OR (EXCLUDED." + lww + " = "
                + table.name() + "." + lww + " AND ("
                + compared.stream().map(c -> table.name() + "." + c).collect(Collectors.joining(", "))
                + ") IS DISTINCT FROM ("
                + compared.stream().map(c -> "EXCLUDED." + c).collect(Collectors.joining(", "))
                + ")) RETURNING (xmax = 0)";
        List<Boolean> result = jdbc.query(sql, (rs, i) -> rs.getBoolean(1), args.toArray());
        if (!result.isEmpty()) {
            accepted.add(new Accepted(table.name(), row.clientId(), result.get(0) ? "CREATED" : "UPDATED"));
            return;
        }
        // Yazılmadı: aynı veri mi, yoksa sunucudaki daha yeni mi?
        List<ObjectNode> current = selectRows(userId, table, List.of(row.clientId()));
        OffsetDateTime incoming = (OffsetDateTime) row.values().get(lww);
        OffsetDateTime stored = current.isEmpty() ? null
                : OffsetDateTime.parse(current.get(0).path(table.lwwField().json()).asString());
        if (stored != null && stored.isAfter(incoming)) {
            conflicts.add(new Conflict(table.name(), row.clientId(), "STALE", current.get(0)));
        } else {
            accepted.add(new Accepted(table.name(), row.clientId(), "UNCHANGED"));
        }
    }

    private boolean insertAppendOnly(UUID userId, SyncTable table, SyncRow row, OffsetDateTime serverNow) {
        List<SyncField> fields = table.allFields();
        List<Object> args = new ArrayList<>(List.of(userId, row.clientId(), serverNow));
        fields.forEach(f -> args.add(row.values().get(f.column())));
        String sql = "INSERT INTO " + table.name() + " (user_id, client_id, seq, server_updated_at, "
                + fields.stream().map(SyncField::column).collect(Collectors.joining(", "))
                + ") VALUES (?, ?, nextval('sync_seq'), ?, "
                + fields.stream().map(f -> f.isJson() ? "?::jsonb" : "?").collect(Collectors.joining(", "))
                + ") ON CONFLICT (user_id, client_id) DO NOTHING RETURNING 1";
        return !jdbc.query(sql, (rs, i) -> 1, args.toArray()).isEmpty();
    }

    /** Verilen kimliklerdeki satırlar (tek sorgu). */
    public List<ObjectNode> selectRows(UUID userId, SyncTable table, List<UUID> clientIds) {
        if (clientIds.isEmpty()) {
            return List.of();
        }
        return jdbc.query(selectSql(table) + " WHERE user_id = ? AND client_id = ANY(?)",
                (rs, i) -> SyncRowCodec.encode(table, rs), userId, clientIds.toArray(UUID[]::new));
    }

    public static String selectSql(SyncTable table) {
        StringBuilder sb = new StringBuilder("SELECT seq, client_id");
        if (table.mutable()) {
            sb.append(", deleted");
        }
        for (SyncField f : table.allFields()) {
            sb.append(", ").append(f.isJson() ? f.column() + "::text AS " + f.column() : f.column());
        }
        return sb.append(" FROM ").append(table.name()).toString();
    }

    /**
     * {@code since}'ten sonraki değişiklikler, sunucu sırasıyla. Tablo sayısı kadar sabit sorgu (satır sayısından
     * bağımsız): her tablodan en çok {@code limit + 1} satır okunur, sırayla birleştirilir.
     */
    @Transactional(readOnly = true)
    public PullResponse pull(UUID userId, Long since, Integer limit) {
        users.requireActive(userId);
        rateLimiter.acquire("sync-pull:" + userId, properties.getSync().getPullPerHour());
        long from = since == null || since < 0 ? 0 : since;
        int max = properties.getSync().getPullMaxLimit();
        int n = limit == null || limit < 1 ? properties.getSync().getPullDefaultLimit() : Math.min(limit, max);
        record Item(long seq, String table, ObjectNode row) {
        }
        List<Item> all = new ArrayList<>();
        for (SyncTable table : tables) {
            all.addAll(jdbc.query(selectSql(table) + " WHERE user_id = ? AND seq > ? ORDER BY seq LIMIT ?",
                    (rs, i) -> new Item(rs.getLong("seq"), table.name(), SyncRowCodec.encode(table, rs)),
                    userId, from, n + 1));
        }
        all.sort(Comparator.comparingLong(Item::seq));
        boolean hasMore = all.size() > n;
        List<Item> page = hasMore ? all.subList(0, n) : all;
        Map<String, List<ObjectNode>> changes = new LinkedHashMap<>();
        for (Item item : page) {
            changes.computeIfAbsent(item.table(), k -> new ArrayList<>()).add(item.row());
        }
        long next = page.isEmpty() ? from : page.get(page.size() - 1).seq();
        return new PullResponse(changes, next, hasMore, clock.instant());
    }

    /**
     * "Hi'nin kayıtlarını sil" (H-055) sunucu karşılığı: "Söyle" sonuçları kalıcı silinir. (hi_records satırları
     * istemcinin itmesiyle silme işareti alır.) İdempotent.
     */
    @Transactional
    public int clearSpeechAttempts(UUID userId) {
        users.requireActive(userId);
        lockUser(userId);
        return jdbc.update("DELETE FROM speech_attempts WHERE user_id = ?", userId);
    }

    /** Kalıcı hesap silme: bütün eşitlenen satırlar (aynı işlem, idempotent). */
    @Override
    @Transactional
    public void purgeUserData(UUID userId) {
        for (SyncTable table : tables) {
            jdbc.update("DELETE FROM " + table.name() + " WHERE user_id = ?", userId);
        }
    }
}
