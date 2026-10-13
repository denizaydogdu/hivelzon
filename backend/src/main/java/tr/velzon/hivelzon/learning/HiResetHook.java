package tr.velzon.hivelzon.learning;

import java.time.Clock;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import tr.velzon.hivelzon.sync.SyncDtos.Conflict;
import tr.velzon.hivelzon.sync.SyncPushHook;
import tr.velzon.hivelzon.sync.SyncRow;

/**
 * "Hi'nin kayıtlarını sil" bütün cihazlarda (H-038, kullanıcı kararı): istemci {@code hi_records} tablosuna
 * {@code kind = hi_reset} işaretini iter ({@code updatedAt} = silme anı T). Aynı işlem ve kullanıcı kilidi
 * içinde sunucu:
 * <ul>
 * <li>T'ye kadarki öğrenme olaylarını ve "Söyle" sonuçlarını kalıcı siler (yalnız eklenen tablolar);</li>
 * <li>T'ye kadarki yan görev ve not kayıtlarını ({@code bridge_task}, {@code note_read}) silme işaretiyle
 * kapatır (yeni sıra alır, çekmeyle öteki cihazlara gider).</li>
 * </ul>
 * İşaretin kendisi değişebilir satırdır; çekmeyle öteki cihazlara gider ve onlar da T'ye kadarki yerel
 * kayıtlarını siler. İdempotent: aynı işaret yeniden gelirse silinecek bir şey kalmamıştır.
 */
@Component
class HiResetHook implements SyncPushHook {

    private final JdbcTemplate jdbc;
    private final Clock clock;

    HiResetHook(JdbcTemplate jdbc, Clock clock) {
        this.jdbc = jdbc;
        this.clock = clock;
    }

    @Override
    public List<Conflict> afterPush(UUID userId, Map<String, List<SyncRow>> rowsByTable) {
        OffsetDateTime resetAt = null;
        for (SyncRow row : rowsByTable.getOrDefault(LearningSyncTables.HI_RECORDS, List.of())) {
            if (row.deleted() || !LearningSyncTables.HI_RESET.equals(row.values().get("kind"))) {
                continue;
            }
            OffsetDateTime at = (OffsetDateTime) row.values().get("updated_at");
            if (resetAt == null || at.isAfter(resetAt)) {
                resetAt = at;
            }
        }
        if (resetAt != null) {
            reset(userId, resetAt);
        }
        return List.of();
    }

    /** T'ye kadarki Hi kayıtları (kullanıcı kilidi altında çağrılır). */
    void reset(UUID userId, OffsetDateTime resetAt) {
        jdbc.update("DELETE FROM learning_events WHERE user_id = ? AND at <= ?", userId, resetAt);
        jdbc.update("DELETE FROM speech_attempts WHERE user_id = ? AND at <= ?", userId, resetAt);
        jdbc.update("""
                UPDATE hi_records SET deleted = true, status = NULL, updated_at = ?, seq = nextval('sync_seq'),
                       server_updated_at = ?
                 WHERE user_id = ? AND kind IN ('bridge_task', 'note_read') AND NOT deleted AND updated_at <= ?""",
                resetAt, clock.instant().atOffset(ZoneOffset.UTC), userId, resetAt);
    }
}
