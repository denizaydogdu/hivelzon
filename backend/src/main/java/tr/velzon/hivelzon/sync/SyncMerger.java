package tr.velzon.hivelzon.sync;

/**
 * Değişebilir tabloda düz "son yazan kazanır" yerine alan bazlı birleştirme (H-056). Kullanıcı kilidi altında,
 * sunucuda satır varken çağrılır.
 */
@FunctionalInterface
public interface SyncMerger {

    /**
     * @return yazılacak birleşik satır; {@code null}: varsayılan son yazan kazanır kuralı uygulanır
     */
    SyncRow merge(SyncRow stored, SyncRow incoming, String lwwColumn);
}
