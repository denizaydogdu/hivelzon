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
 * Öğrenme kanıtı basamakları (H-089): ifade + basamak başına tek satır, yalnız eklenir (ilk gelen kalır). Metin,
 * ses ya da tanıma yazısı alanı yoktur; bilinmeyen basamak ve fazladan alan reddedilir.
 */
class ExpressionEvidenceSyncTest extends IntegrationTest {

    static final String TABLE = "expression_evidence";

    static Map<String, Object> evidence(String stage, String at) {
        return row("itemKey", "phrase|where is…", "stage", stage, "at", at);
    }

    @Test
    void stagesAreAppendOnlyAndFirstArrivalWins() {
        String token = login("a@example.com").text("accessToken");
        Response first = call("POST", PUSH, push(TABLE, evidence("helped", "2026-10-13T09:00:00Z"),
                evidence("recalled_later", "2026-10-16T09:00:00Z")), token);
        assertThat(first.status()).as(first.raw()).isEqualTo(200);
        assertThat(first.body().path("accepted")).hasSize(2);

        // Öteki cihaz aynı basamağı daha sonra gönderir: satır değişmez.
        call("POST", PUSH, push(TABLE, evidence("helped", "2026-10-14T09:00:00Z")), token);
        assertThat(count("SELECT count(*) FROM expression_evidence")).isEqualTo(2);
        assertThat(jdbc.queryForObject("SELECT to_char(at AT TIME ZONE 'UTC', 'YYYY-MM-DD') FROM expression_evidence "
                + "WHERE stage = 'helped'", String.class)).isEqualTo("2026-10-13");

        JsonNode pulled = get("/api/v1/sync/pull?since=0", token).body().path("changes").path(TABLE);
        assertThat(pulled).hasSize(2);
        assertThat(pulled.get(0).path("itemKey").asString()).isEqualTo("phrase|where is…");
    }

    @Test
    void unknownStageAndExtraFieldsAreRejected() {
        String token = login("a@example.com").text("accessToken");
        Response badStage = call("POST", PUSH, push(TABLE, evidence("mastered", "2026-10-13T09:00:00Z")), token);
        assertThat(badStage.status()).isEqualTo(400);
        Map<String, Object> withText = row("itemKey", "phrase|where is…", "stage", "own_use", "at",
                "2026-10-13T09:00:00Z", "transcript", "where is the station");
        assertThat(call("POST", PUSH, push(TABLE, withText), token).status()).isEqualTo(400);
        assertThat(count("SELECT count(*) FROM expression_evidence")).isZero();
    }
}
