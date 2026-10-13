package tr.velzon.hivelzon.common.crypto;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.Map;

import org.junit.jupiter.api.Test;

/**
 * UUIDv5 test vektörleri. Aynı girdiler ve beklenen değerler mobil testte de vardır
 * ({@code mobile/test/shared/sync/sync_ids_test.dart}); iki taraf aynı kimliği üretmelidir (H-038).
 */
class UuidsTest {

    static final Map<String, String> VECTORS = Map.of(
            "user_story_flags:A1-002|greet_tone", "8cc37cb7-98a0-52ff-b79e-6260d302a489",
            "user_story_progress:A1-001", "aed2a1d8-95cf-52de-bcc2-5fb2bf6860f0",
            "season_state:1", "d3147e52-35d9-5898-8ddc-ab9721b00660",
            "notebook_items:phrase|can you hear me?", "bba85315-8783-545b-b4fa-5150fa6bd4ca",
            "review_cards:phrase|can you hear me?", "cbe4a0d5-f3a8-57c9-ae03-0ccba42ae872",
            "hi_records:hi_reset|all", "9ada9723-770e-51a4-80a7-64290f2b3853",
            "gate_progress:A1-001|activeTask|t-kanit", "016b2cb0-a692-568f-a69d-3090ec5db262",
            "review_logs:cbe4a0d5-f3a8-57c9-ae03-0ccba42ae872|2026-10-13T09:05:00Z|3",
            "815799ab-b9c7-5461-9431-881f4908fde9",
            "notebook_items:word|çay", "9ed87269-6fbc-5124-a567-3d4b4f243d52");

    @Test
    void sameIdsAsMobile() {
        VECTORS.forEach((name, expected) -> assertThat(Uuids.v5(Uuids.SYNC_NAMESPACE, name).toString())
                .as(name).isEqualTo(expected));
    }
}
