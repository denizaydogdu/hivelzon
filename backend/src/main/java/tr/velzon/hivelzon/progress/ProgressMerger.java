package tr.velzon.hivelzon.progress;

import java.time.OffsetDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import tr.velzon.hivelzon.sync.SyncMerger;
import tr.velzon.hivelzon.sync.SyncRow;

/**
 * "Bitti her zaman kazanır" (H-056, kullanıcı kararı): bölüm ilerlemesinin durumu hiçbir eşitlemeyle geri gitmez.
 * Sıra: NOT_STARTED &lt; IN_PROGRESS &lt; COMPLETED.
 * <ul>
 * <li>Gelen satır aynı zamanlı ve durumu daha düşükse: sunucudaki aynen kalır ({@code MERGED} + sunucu satırı).</li>
 * <li>Gelen satır daha yeni ama durumu daha düşükse: gelen yazılır, durum ve {@code completedAt} sunucudakinden
 * korunur; sunucudaki COMPLETED ise kayıt noktası ({@code lastCheckpointNodeId}, {@code checkpointSnapshot}) da
 * korunur.</li>
 * <li>Gelen satır daha eski (ya da aynı zamanlı) ama durumu daha yüksekse: sunucudaki korunur, durum ve {@code completedAt} gelenden
 * alınır (gelen COMPLETED ise ya da sunucuda kayıt noktası yoksa kayıt noktası da). {@code updatedAt} sunucudakinin
 * 1 ms sonrasıdır: satır yeni sıra alır ve öteki cihazlar (aynı zamanı "kendi itmesi" sayıp atlamadan) alır.</li>
 * <li>{@code startedAt}: ikisinden erken olanı.</li>
 * <li>Aynı durum ya da silme işareti: düz son yazan kazanır (mobil ilerlemeyi silmez; yalnızca hesapsızken yerel
 * silme yapar, o da gönderilmez).</li>
 * </ul>
 * Aynı kural kitap ilerlemesine de uygulanır (H-067, {@link #forBooks()}): kayıt noktası orada kalınan bölüm, sayfa,
 * cümle ve ses konumudur.
 */
final class ProgressMerger implements SyncMerger {

    static final String STATUS = "status";
    static final String COMPLETED_AT = "completed_at";
    static final String STARTED_AT = "started_at";
    static final String CHECKPOINT_NODE = "last_checkpoint_node_id";
    static final String CHECKPOINT_SNAPSHOT = "checkpoint_snapshot";

    /** Kalınan yer kolonları; ilki boşsa "kayıt noktası yok" sayılır. */
    private final List<String> place;

    ProgressMerger() {
        this(List.of(CHECKPOINT_NODE, CHECKPOINT_SNAPSHOT));
    }

    ProgressMerger(List<String> place) {
        this.place = List.copyOf(place);
    }

    /** Kitap ilerlemesi (H-067). */
    static ProgressMerger forBooks() {
        return new ProgressMerger(List.of("chapter_id", "page_number", "sentence_index", "position_sec"));
    }

    private boolean hasPlace(Map<String, Object> row) {
        // Hikâyede kayıt noktasının özü anlık görüntüdür; kitapta bölüm.
        String key = place.contains(CHECKPOINT_SNAPSHOT) ? CHECKPOINT_SNAPSHOT : place.get(0);
        return row.get(key) != null;
    }

    private void copyPlace(Map<String, Object> from, Map<String, Object> to) {
        for (String c : place) {
            to.put(c, from.get(c));
        }
    }

    static int rank(Object status) {
        if (status == null) {
            return 0;
        }
        return switch (status.toString()) {
            case "COMPLETED" -> 2;
            case "IN_PROGRESS" -> 1;
            default -> 0;
        };
    }

    @Override
    public SyncRow merge(SyncRow stored, SyncRow incoming, String lww) {
        if (stored.deleted() || incoming.deleted()) {
            return null;
        }
        Map<String, Object> s = stored.values();
        Map<String, Object> in = incoming.values();
        int rs = rank(s.get(STATUS));
        int ri = rank(in.get(STATUS));
        if (rs == ri) {
            return null;
        }
        OffsetDateTime ts = (OffsetDateTime) s.get(lww);
        OffsetDateTime ti = (OffsetDateTime) in.get(lww);
        boolean incomingWins = ti.isAfter(ts);
        Map<String, Object> out;
        if (ti.isEqual(ts) && ri < rs) {
            // Aynı zaman, daha düşük durum: düz LWW'de varış sırası kazanırdı; sunucudaki aynen kalır.
            return stored;
        }
        if (incomingWins && ri < rs) {
            out = new LinkedHashMap<>(in);
            out.put(STATUS, s.get(STATUS));
            out.put(COMPLETED_AT, s.get(COMPLETED_AT));
            if (rs == 2) {
                copyPlace(s, out);
            }
        } else if (!incomingWins && ri > rs) {
            out = new LinkedHashMap<>(s);
            out.put(STATUS, in.get(STATUS));
            out.put(COMPLETED_AT, in.get(COMPLETED_AT));
            if (ri == 2 || !hasPlace(s)) {
                copyPlace(in, out);
            }
            out.put(lww, ts.plusNanos(1_000_000));
        } else {
            return null;
        }
        out.put(STARTED_AT, earliest((OffsetDateTime) s.get(STARTED_AT), (OffsetDateTime) in.get(STARTED_AT)));
        return new SyncRow(incoming.clientId(), false, out);
    }

    private static OffsetDateTime earliest(OffsetDateTime a, OffsetDateTime b) {
        if (a == null) {
            return b;
        }
        if (b == null) {
            return a;
        }
        return a.isBefore(b) ? a : b;
    }
}
