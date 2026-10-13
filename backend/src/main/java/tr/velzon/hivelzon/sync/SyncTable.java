package tr.velzon.hivelzon.sync;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * Eşitlenen bir tablonun tanımı. Alan adları mobil Drift sınıflarındaki adlarla aynıdır (camelCase JSON);
 * kolonlar snake_case.
 *
 * @param name       tablo adı (mobil ve sunucuda aynı)
 * @param order      itme sırasında uygulanma sırası (küçük önce: notebook_items → review_cards → review_logs)
 * @param kind       değişebilir (son yazan kazanır) ya da yalnız eklenen
 * @param keyFields  doğal anahtar; boşsa istemci kimliği (clientId, UUID) zorunludur. Doluysa clientId
 *                   anahtardan türetilir (UUIDv5), gönderilirse eşleşmesi gerekir.
 * @param lwwField   son yazan kazanır zamanı (yalnızca değişebilir tablolarda)
 * @param dataFields diğer alanlar
 * @param merger     isteğe bağlı birleştirme kuralı (ör. "bitti her zaman kazanır", H-056); yoksa düz LWW
 */
public record SyncTable(String name, int order, Kind kind, List<SyncField> keyFields, SyncField lwwField,
        List<SyncField> dataFields, SyncMerger merger) {

    public enum Kind {
        /** Son yazan kazanır ({@code lwwField}); silme işareti ({@code deleted}) desteklenir. */
        MUTABLE,
        /** Bir kez eklenir; aynı kimlikle tekrar gelirse yok sayılır. */
        APPEND_ONLY
    }

    public SyncTable {
        keyFields = List.copyOf(keyFields);
        dataFields = List.copyOf(dataFields);
        if (kind == Kind.MUTABLE && lwwField == null) {
            throw new IllegalArgumentException(name + ": mutable table needs lwwField");
        }
        if (merger != null && kind != Kind.MUTABLE) {
            throw new IllegalArgumentException(name + ": merger only for mutable tables");
        }
    }

    public SyncTable(String name, int order, Kind kind, List<SyncField> keyFields, SyncField lwwField,
            List<SyncField> dataFields) {
        this(name, order, kind, keyFields, lwwField, dataFields, null);
    }

    public boolean mutable() {
        return kind == Kind.MUTABLE;
    }

    public boolean naturalKey() {
        return !keyFields.isEmpty();
    }

    /** Anahtar + zaman + veri alanları (clientId ve deleted hariç), yazma sırasıyla. */
    public List<SyncField> allFields() {
        List<SyncField> all = new ArrayList<>(keyFields);
        if (lwwField != null) {
            all.add(lwwField);
        }
        all.addAll(dataFields);
        return all;
    }

    public Set<String> reservedNames() {
        return mutable() ? Set.of("clientId", "deleted") : Set.of("clientId");
    }
}
