package tr.velzon.hivelzon.sync;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import tools.jackson.databind.node.ObjectNode;

/** Eşitleme cevapları. */
public final class SyncDtos {

    private SyncDtos() {
    }

    /** Kabul edilen satır. {@code result}: CREATED, UPDATED, UNCHANGED (aynı veri), DUPLICATE (yalnız eklenen). */
    public record Accepted(String table, UUID clientId, String result) {
    }

    /**
     * Sunucudaki satır kazandı. {@code reason}: STALE (sunucudaki updatedAt daha yeni), SERVER_RECOMPUTED
     * (FSRS kartı cevaplardan yeniden hesaplandı) ya da MERGED (alan bazlı birleştirme; ör. bölüm ilerlemesinde
     * "bitti her zaman kazanır", H-056). Her durumda istemci {@code serverRow}'u olduğu gibi almalıdır.
     */
    public record Conflict(String table, UUID clientId, String reason, ObjectNode serverRow) {
    }

    public record PushResponse(List<Accepted> accepted, List<Conflict> conflicts, Instant serverTime) {
    }

    /**
     * Çekme: {@code changes} tablo → satırlar (sunucu sırasıyla). Sonraki çağrı {@code since=nextSince} ile;
     * {@code hasMore} false olana kadar.
     */
    public record PullResponse(Map<String, List<ObjectNode>> changes, long nextSince, boolean hasMore,
            Instant serverTime) {
    }
}
