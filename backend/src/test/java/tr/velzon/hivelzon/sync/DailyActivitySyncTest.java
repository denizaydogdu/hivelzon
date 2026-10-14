package tr.velzon.hivelzon.sync;

import static org.assertj.core.api.Assertions.assertThat;
import static tr.velzon.hivelzon.sync.SyncTest.PUSH;
import static tr.velzon.hivelzon.sync.SyncTest.push;
import static tr.velzon.hivelzon.sync.SyncTest.row;

import java.util.Map;

import org.junit.jupiter.api.Test;

import tools.jackson.databind.JsonNode;
import tr.velzon.hivelzon.support.IntegrationTest;

/**
 * Günlük ölçülen süre (H-074): (gün, kaynak) başına toplam; her kaynak kendi satırını yazar, aynı satırda son yazan
 * kazanır. İki cihazın süresi ayrı satırdır (günün toplamını istemci hesaplar).
 */
class DailyActivitySyncTest extends IntegrationTest {

    static final String TABLE = "daily_activity";
    static final String PHONE = "5b0e8f0e-5d1c-4a57-9a39-3f7f0f0c2b11";
    static final String TABLET = "0c7d2a44-8b8e-4f4e-9d0c-1e2f3a4b5c6d";

    static Map<String, Object> activity(String source, int seconds, String updatedAt) {
        return row("day", "2026-10-13", "sourceId", source, "activeSeconds", seconds, "updatedAt", updatedAt);
    }

    @Test
    void sourcesAreSeparateRowsAndLastWriterWins() {
        String token = login("a@example.com").text("accessToken");
        Response first = call("POST", PUSH, push(TABLE, activity(PHONE, 120, "2026-10-13T09:00:00Z")), token);
        assertThat(first.status()).as(first.raw()).isEqualTo(200);
        assertThat(first.body().path("accepted")).hasSize(1);
        call("POST", PUSH, push(TABLE, activity(TABLET, 300, "2026-10-13T09:30:00Z")), token);
        call("POST", PUSH, push(TABLE, activity(PHONE, 150, "2026-10-13T09:05:00Z")), token);

        Response older = call("POST", PUSH, push(TABLE, activity(PHONE, 60, "2026-10-13T08:00:00Z")), token);
        assertThat(older.body().path("conflicts")).as(older.raw()).hasSize(1);
        assertThat(older.body().path("conflicts").get(0).path("reason").asString()).isEqualTo("STALE");

        assertThat(count("SELECT count(*) FROM daily_activity")).isEqualTo(2);
        assertThat(jdbc.queryForObject("SELECT sum(active_seconds) FROM daily_activity", Integer.class))
                .isEqualTo(450);

        JsonNode pulled = get("/api/v1/sync/pull?since=0", token).body().path("changes").path(TABLE);
        assertThat(pulled).hasSize(2);
        assertThat(pulled.get(0).path("day").asString()).isEqualTo("2026-10-13");
    }

    @Test
    void invalidRowsAreRejected() {
        String token = login("a@example.com").text("accessToken");
        Response tooLong = call("POST", PUSH, push(TABLE, activity(PHONE, 90_000, "2026-10-13T09:00:00Z")), token);
        assertThat(tooLong.status()).isEqualTo(400);
        Response noDay = call("POST", PUSH, push(TABLE, row("sourceId", PHONE, "activeSeconds", 10, "updatedAt",
                "2026-10-13T09:00:00Z")), token);
        assertThat(noDay.status()).isEqualTo(400);
        assertThat(count("SELECT count(*) FROM daily_activity")).isZero();
    }
}
