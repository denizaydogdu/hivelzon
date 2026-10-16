package tr.velzon.hivelzon.sync;

import static org.assertj.core.api.Assertions.assertThat;
import static tr.velzon.hivelzon.sync.SyncTest.PUSH;
import static tr.velzon.hivelzon.sync.SyncTest.push;
import static tr.velzon.hivelzon.sync.SyncTest.row;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.junit.jupiter.api.Test;

import tools.jackson.databind.JsonNode;
import tr.velzon.hivelzon.support.IntegrationTest;

/**
 * Konuş görevleri (H-090): görev başına yalnız kimlik ve zamanlar; düz son yazan kazanır. Yazılan mesaj gibi
 * tanımsız alan reddedilir. Konuş sahnesindeki "Söyle" sonucu {@code place = talk} ile kabul edilir.
 */
class TalkProgressSyncTest extends IntegrationTest {

    static final String TABLE = "user_talk_progress";

    static Map<String, Object> done(String lastDoneAt) {
        return row("taskId", "cafe-rosa", "completedAt", "2026-10-13T09:00:00Z", "lastDoneAt", lastDoneAt,
                "updatedAt", lastDoneAt);
    }

    @Test
    void lastWriterWins() {
        String token = login("a@example.com").text("accessToken");
        Response first = call("POST", PUSH, push(TABLE, done("2026-10-13T09:00:00Z")), token);
        assertThat(first.status()).as(first.raw()).isEqualTo(200);
        assertThat(first.body().path("accepted")).hasSize(1);
        Response newer = call("POST", PUSH, push(TABLE, done("2026-10-14T09:00:00Z")), token);
        assertThat(newer.body().path("accepted")).as(newer.raw()).hasSize(1);
        Response older = call("POST", PUSH, push(TABLE, done("2026-10-12T09:00:00Z")), token);
        assertThat(older.body().path("conflicts")).as(older.raw()).hasSize(1);

        assertThat(count("SELECT count(*) FROM user_talk_progress")).isEqualTo(1);
        JsonNode pulled = get("/api/v1/sync/pull?since=0", token).body().path("changes").path(TABLE);
        assertThat(pulled).hasSize(1);
        assertThat(pulled.get(0).path("taskId").asString()).isEqualTo("cafe-rosa");
        assertThat(pulled.get(0).path("lastDoneAt").asString()).startsWith("2026-10-14T09:00");
    }

    @Test
    void typedMessageIsNeverAccepted() {
        String token = login("a@example.com").text("accessToken");
        Map<String, Object> withText = new HashMap<>(done("2026-10-13T09:00:00Z"));
        withText.put("message", "Sorry, Maya. I'm late.");
        Response r = call("POST", PUSH, push(TABLE, withText), token);
        assertThat(r.status()).isEqualTo(400);
        assertThat(count("SELECT count(*) FROM user_talk_progress")).isZero();
    }

    @Test
    void talkSpeechAttemptIsAccepted() {
        String token = login("a@example.com").text("accessToken");
        Map<String, Object> attempt = row("clientId", UUID.randomUUID().toString(), "place", "talk",
                "contentId", "cafe-rosa", "itemRef", "Can I have a tea, please?", "matchLevel", "full",
                "missingCount", 0, "errorNoteId", null, "at", "2026-10-13T09:00:00Z");
        Response r = call("POST", PUSH, push("speech_attempts", attempt), token);
        assertThat(r.status()).as(r.raw()).isEqualTo(200);
        assertThat(count("SELECT count(*) FROM speech_attempts WHERE place = 'talk'")).isEqualTo(1);
    }
}
