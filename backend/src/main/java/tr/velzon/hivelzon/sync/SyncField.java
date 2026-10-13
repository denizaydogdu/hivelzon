package tr.velzon.hivelzon.sync;

import java.util.Set;

/**
 * Eşitlenen bir alan. {@code required}: silinmemiş satırda boş olamaz.
 *
 * @param json    JSON adı (mobil Drift alanı, camelCase)
 * @param column  kolon adı
 * @param maxLen  metin için en çok karakter; JSON için en çok bayt
 * @param allowed metin için izinli değerler (boşsa serbest)
 */
public record SyncField(String json, String column, Type type, boolean required, int maxLen, Set<String> allowed,
        long min, long max) {

    public enum Type {
        STRING, INT, DOUBLE, BOOL, INSTANT, UUID, JSON_OBJECT, JSON_ARRAY
    }

    public static SyncField string(String json, String column, boolean required, int maxLen) {
        return new SyncField(json, column, Type.STRING, required, maxLen, Set.of(), 0, 0);
    }

    public static SyncField oneOf(String json, String column, boolean required, String... values) {
        int max = 0;
        for (String v : values) {
            max = Math.max(max, v.length());
        }
        return new SyncField(json, column, Type.STRING, required, max, Set.of(values), 0, 0);
    }

    public static SyncField integer(String json, String column, boolean required, long min, long max) {
        return new SyncField(json, column, Type.INT, required, 0, Set.of(), min, max);
    }

    public static SyncField decimal(String json, String column, boolean required) {
        return new SyncField(json, column, Type.DOUBLE, required, 0, Set.of(), 0, 0);
    }

    public static SyncField bool(String json, String column, boolean required) {
        return new SyncField(json, column, Type.BOOL, required, 0, Set.of(), 0, 0);
    }

    public static SyncField instant(String json, String column, boolean required) {
        return new SyncField(json, column, Type.INSTANT, required, 0, Set.of(), 0, 0);
    }

    public static SyncField uuid(String json, String column, boolean required) {
        return new SyncField(json, column, Type.UUID, required, 0, Set.of(), 0, 0);
    }

    public static SyncField jsonObject(String json, String column, boolean required, int maxBytes) {
        return new SyncField(json, column, Type.JSON_OBJECT, required, maxBytes, Set.of(), 0, 0);
    }

    public static SyncField jsonArray(String json, String column, boolean required, int maxBytes) {
        return new SyncField(json, column, Type.JSON_ARRAY, required, maxBytes, Set.of(), 0, 0);
    }

    public boolean isJson() {
        return type == Type.JSON_OBJECT || type == Type.JSON_ARRAY;
    }
}
