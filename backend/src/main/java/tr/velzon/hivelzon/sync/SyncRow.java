package tr.velzon.hivelzon.sync;

import java.util.Map;
import java.util.UUID;

/**
 * Doğrulanmış satır. {@code values}: kolon adı → bağlanacak değer (String, Integer, Long, Double, Boolean,
 * OffsetDateTime, UUID; JSON kolonları metin).
 */
public record SyncRow(UUID clientId, boolean deleted, Map<String, Object> values) {
}
