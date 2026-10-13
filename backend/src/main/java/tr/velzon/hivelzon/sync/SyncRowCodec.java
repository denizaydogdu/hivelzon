package tr.velzon.hivelzon.sync;

import java.nio.charset.StandardCharsets;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeParseException;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.StringJoiner;
import java.util.UUID;

import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;
import tools.jackson.databind.node.ObjectNode;
import tr.velzon.hivelzon.common.crypto.Uuids;
import tr.velzon.hivelzon.common.web.ApiException;
import tr.velzon.hivelzon.common.web.ErrorCode;

/**
 * JSON satır ↔ veritabanı satırı. Doğrulama sıkıdır: bilinmeyen alan reddedilir (veri en aza indirme);
 * ses ya da tanıma yazısı gibi görünen alanlar ayrı bir kodla ({@code TRANSCRIPT_NOT_ALLOWED}) reddedilir.
 * Hata cevabında yalnızca yer (tablo, sıra, alan adı) döner, değer dönmez.
 */
public final class SyncRowCodec {

    /** Hiçbir tabloda kabul edilmeyen, ses ya da konuşma yazısı taşıyabilecek alan adları (H-055). */
    static final Set<String> TRANSCRIPT_FIELDS = Set.of("transcript", "transcription", "recognizedtext",
            "recognized", "recognizedwords", "spokentext", "utterance", "audio", "audiodata", "audiobase64",
            "audiobytes", "rawaudio", "recording", "recordingpath", "voice", "speechtext", "asrtext", "hypothesis",
            "alternatives", "confidence");

    private static final JsonMapper JSON = JsonMapper.builder().build();

    private SyncRowCodec() {
    }

    static SyncRow decode(SyncTable table, JsonNode node, int index, Instant now, java.time.Duration maxSkew) {
        if (!(node instanceof ObjectNode row)) {
            throw invalid(table, index, null);
        }
        for (String name : row.propertyNames()) {
            if (TRANSCRIPT_FIELDS.contains(name.toLowerCase(Locale.ROOT).replace("_", ""))) {
                throw new ApiException(ErrorCode.TRANSCRIPT_NOT_ALLOWED,
                        Map.of("table", table.name(), "index", index, "field", name));
            }
            boolean known = table.reservedNames().contains(name)
                    || table.allFields().stream().anyMatch(f -> f.json().equals(name));
            if (!known) {
                throw new ApiException(ErrorCode.SYNC_FIELD_NOT_ALLOWED,
                        Map.of("table", table.name(), "index", index, "field", name));
            }
        }
        boolean deleted = false;
        if (row.has("deleted")) {
            JsonNode d = row.get("deleted");
            if (!d.isBoolean()) {
                throw invalid(table, index, "deleted");
            }
            deleted = d.asBoolean();
        }
        Map<String, Object> values = new LinkedHashMap<>();
        for (SyncField f : table.keyFields()) {
            values.put(f.column(), value(table, f, row.get(f.json()), true, index));
        }
        if (table.lwwField() != null) {
            OffsetDateTime lww = (OffsetDateTime) value(table, table.lwwField(), row.get(table.lwwField().json()), true,
                    index);
            // İleri tarihli istemci saati sonsuza kadar kazanmasın: sunucu saatine çekilir.
            if (lww.toInstant().isAfter(now.plus(maxSkew))) {
                lww = now.atOffset(ZoneOffset.UTC);
            }
            values.put(table.lwwField().column(), lww);
        }
        for (SyncField f : table.dataFields()) {
            // Silme işaretli satırda veri tutulmaz (en aza indirme).
            values.put(f.column(), deleted ? null : value(table, f, row.get(f.json()), f.required(), index));
        }

        UUID clientId = null;
        JsonNode cid = row.get("clientId");
        if (cid != null && !cid.isNull()) {
            try {
                clientId = UUID.fromString(cid.asString());
            } catch (IllegalArgumentException e) {
                throw invalid(table, index, "clientId");
            }
        }
        if (table.naturalKey()) {
            UUID derived = naturalClientId(table, values);
            if (clientId != null && !clientId.equals(derived)) {
                throw invalid(table, index, "clientId");
            }
            clientId = derived;
        } else if (clientId == null) {
            throw invalid(table, index, "clientId");
        }
        return new SyncRow(clientId, deleted, values);
    }

    /** {@code UUIDv5(SYNC_NAMESPACE, "<tablo>:<anahtar1>|<anahtar2>")}. */
    static UUID naturalClientId(SyncTable table, Map<String, Object> values) {
        StringJoiner name = new StringJoiner("|", table.name() + ":", "");
        for (SyncField f : table.keyFields()) {
            name.add(String.valueOf(values.get(f.column())));
        }
        return Uuids.v5(Uuids.SYNC_NAMESPACE, name.toString());
    }

    private static Object value(SyncTable table, SyncField f, JsonNode v, boolean required, int index) {
        if (v == null || v.isNull()) {
            if (required) {
                throw invalid(table, index, f.json());
            }
            return null;
        }
        try {
            return switch (f.type()) {
                case STRING -> {
                    if (!v.isString()) {
                        throw invalid(table, index, f.json());
                    }
                    String s = v.asString();
                    if (s.length() > f.maxLen() || (!f.allowed().isEmpty() && !f.allowed().contains(s))
                            || (required && s.isBlank())) {
                        throw invalid(table, index, f.json());
                    }
                    yield s;
                }
                case INT -> {
                    if (!v.isIntegralNumber() || !v.canConvertToLong()) {
                        throw invalid(table, index, f.json());
                    }
                    long n = v.asLong();
                    if (n < f.min() || n > f.max()) {
                        throw invalid(table, index, f.json());
                    }
                    yield (int) n;
                }
                case DOUBLE -> {
                    if (!v.isNumber() || !Double.isFinite(v.asDouble())) {
                        throw invalid(table, index, f.json());
                    }
                    yield v.asDouble();
                }
                case BOOL -> {
                    if (!v.isBoolean()) {
                        throw invalid(table, index, f.json());
                    }
                    yield v.asBoolean();
                }
                case INSTANT -> {
                    if (!v.isString()) {
                        throw invalid(table, index, f.json());
                    }
                    yield parseInstant(v.asString()).atOffset(ZoneOffset.UTC);
                }
                case UUID -> {
                    if (!v.isString()) {
                        throw invalid(table, index, f.json());
                    }
                    yield UUID.fromString(v.asString());
                }
                case JSON_OBJECT, JSON_ARRAY -> {
                    // Mobil bu alanları JSON metni olarak saklar; metin ya da doğrudan JSON kabul edilir.
                    JsonNode parsed = v.isString() ? JSON.readTree(v.asString()) : v;
                    boolean ok = f.type() == SyncField.Type.JSON_OBJECT ? parsed.isObject() : parsed.isArray();
                    String text = JSON.writeValueAsString(parsed);
                    if (!ok || text.getBytes(StandardCharsets.UTF_8).length > f.maxLen()) {
                        throw invalid(table, index, f.json());
                    }
                    yield text;
                }
            };
        } catch (ApiException e) {
            throw e;
        } catch (RuntimeException e) {
            throw invalid(table, index, f.json());
        }
    }

    /** ISO-8601; saat dilimi yoksa UTC kabul edilir (Drift UTC yazar). */
    static Instant parseInstant(String s) {
        try {
            return OffsetDateTime.parse(s).toInstant();
        } catch (DateTimeParseException e) {
            return java.time.LocalDateTime.parse(s).toInstant(ZoneOffset.UTC);
        }
    }

    static ApiException invalid(SyncTable table, int index, String field) {
        Map<String, Object> props = new LinkedHashMap<>();
        props.put("table", table.name());
        props.put("index", index);
        if (field != null) {
            props.put("field", field);
        }
        return new ApiException(ErrorCode.SYNC_ROW_INVALID, props);
    }

    /** Veritabanı satırı → JSON (mobil alan adlarıyla). */
    public static ObjectNode encode(SyncTable table, ResultSet rs) throws SQLException {
        ObjectNode out = JSON.createObjectNode();
        out.put("clientId", rs.getObject("client_id", UUID.class).toString());
        if (table.mutable()) {
            out.put("deleted", rs.getBoolean("deleted"));
        }
        for (SyncField f : table.allFields()) {
            String c = f.column();
            switch (f.type()) {
                case STRING -> out.put(f.json(), rs.getString(c));
                case INT -> {
                    Object o = rs.getObject(c);
                    if (o == null) {
                        out.putNull(f.json());
                    } else {
                        out.put(f.json(), ((Number) o).longValue());
                    }
                }
                case DOUBLE -> {
                    Object o = rs.getObject(c);
                    if (o == null) {
                        out.putNull(f.json());
                    } else {
                        out.put(f.json(), ((Number) o).doubleValue());
                    }
                }
                case BOOL -> {
                    Object o = rs.getObject(c);
                    if (o == null) {
                        out.putNull(f.json());
                    } else {
                        out.put(f.json(), (Boolean) o);
                    }
                }
                case INSTANT -> {
                    OffsetDateTime t = rs.getObject(c, OffsetDateTime.class);
                    out.put(f.json(), t == null ? null : t.toInstant().toString());
                }
                case UUID -> {
                    UUID u = rs.getObject(c, UUID.class);
                    out.put(f.json(), u == null ? null : u.toString());
                }
                case JSON_OBJECT, JSON_ARRAY -> {
                    String text = rs.getString(c);
                    if (text == null) {
                        out.putNull(f.json());
                    } else {
                        out.set(f.json(), JSON.readTree(text));
                    }
                }
            }
        }
        return out;
    }
}
