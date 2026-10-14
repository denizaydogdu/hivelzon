package tr.velzon.hivelzon.sync;

import static org.assertj.core.api.Assertions.assertThat;
import static tr.velzon.hivelzon.sync.SyncTest.PUSH;
import static tr.velzon.hivelzon.sync.SyncTest.push;
import static tr.velzon.hivelzon.sync.SyncTest.row;

import java.util.Map;
import java.util.UUID;

import org.junit.jupiter.api.Test;

import tools.jackson.databind.JsonNode;
import tr.velzon.hivelzon.support.IntegrationTest;

/**
 * Dilbilgisi (H-078): ders ilerlemesi eşitlenir; "bitti her zaman kazanır", öteki alanlarda son yazan kazanır.
 * Defterde kural kartı ({@code kind = rule}, {@code source = grammar}) ve uzun ders kimliği kabul edilir; alıştırmada
 * "Söyle" sonucu ({@code place = grammar}).
 */
class GrammarProgressSyncTest extends IntegrationTest {

    static final String TABLE = "user_grammar_progress";
    static final String LESSON = "G-B2-03-reported-questions-commands";

    static Map<String, Object> progress(String status, String card, String completedAt, String updatedAt) {
        return row("lessonId", LESSON, "status", status, "lastCard", card, "startedAt", "2026-10-13T08:00:00Z",
                "completedAt", completedAt, "updatedAt", updatedAt);
    }

    Map<String, Object> stored() {
        return jdbc.queryForMap("SELECT lesson_id, status, last_card, completed_at FROM user_grammar_progress");
    }

    @Test
    void sameStatusIsLastWriterWins() {
        String token = login("a@example.com").text("accessToken");
        Response first = call("POST", PUSH, push(TABLE, progress("IN_PROGRESS", "c02", null, "2026-10-13T09:00:00Z")),
                token);
        assertThat(first.status()).as(first.raw()).isEqualTo(200);
        assertThat(first.body().path("accepted")).hasSize(1);
        assertThat(stored().get("lesson_id")).isEqualTo(LESSON);

        call("POST", PUSH, push(TABLE, progress("IN_PROGRESS", "c05", null, "2026-10-13T09:10:00Z")), token);
        assertThat(stored().get("last_card")).isEqualTo("c05");

        Response older = call("POST", PUSH, push(TABLE, progress("IN_PROGRESS", "c01", null, "2026-10-13T09:05:00Z")),
                token);
        assertThat(older.body().path("conflicts").get(0).path("reason").asString()).isEqualTo("STALE");
        assertThat(stored().get("last_card")).isEqualTo("c05");
    }

    @Test
    void newerInProgressCannotUndoCompleted() {
        String token = login("a@example.com").text("accessToken");
        call("POST", PUSH, push(TABLE, progress("COMPLETED", "c07", "2026-10-13T09:00:00Z", "2026-10-13T09:00:00Z")),
                token);

        Response r = call("POST", PUSH, push(TABLE, progress("IN_PROGRESS", "c02", null, "2026-10-13T09:30:00Z")),
                token);
        assertThat(r.status()).as(r.raw()).isEqualTo(200);
        JsonNode conflict = r.body().path("conflicts").get(0);
        assertThat(conflict.path("reason").asString()).isEqualTo("MERGED");
        JsonNode server = conflict.path("serverRow");
        assertThat(server.path("status").asString()).isEqualTo("COMPLETED");
        assertThat(server.path("completedAt").asString()).isEqualTo("2026-10-13T09:00:00Z");
        assertThat(server.path("lastCard").asString()).isEqualTo("c07");
        assertThat(stored().get("status")).isEqualTo("COMPLETED");
    }

    @Test
    void olderCompletedRaisesNewerInProgress() {
        String token = login("a@example.com").text("accessToken");
        call("POST", PUSH, push(TABLE, progress("IN_PROGRESS", "c03", null, "2026-10-13T09:30:00Z")), token);

        Response r = call("POST", PUSH,
                push(TABLE, progress("COMPLETED", "c07", "2026-10-13T09:00:00Z", "2026-10-13T09:00:00Z")), token);
        JsonNode server = r.body().path("conflicts").get(0).path("serverRow");
        assertThat(server.path("status").asString()).isEqualTo("COMPLETED");
        assertThat(server.path("lastCard").asString()).isEqualTo("c07");
        assertThat(server.path("updatedAt").asString()).isEqualTo("2026-10-13T09:30:00.001Z");
        assertThat(stored().get("status")).isEqualTo("COMPLETED");
    }

    @Test
    void invalidRowsAreRejected() {
        String token = login("a@example.com").text("accessToken");
        Response bad = call("POST", PUSH, push(TABLE, row("lessonId", LESSON, "status", "SEEN", "updatedAt",
                "2026-10-13T09:00:00Z")), token);
        assertThat(bad.status()).isEqualTo(400);
        assertThat(count("SELECT count(*) FROM user_grammar_progress")).isZero();
    }

    @Test
    void notebookAcceptsGrammarRuleCard() {
        String token = login("a@example.com").text("accessToken");
        Response r = call("POST", PUSH, push("notebook_items", row("itemKey", "rule|she goes to school", "kind",
                "rule", "textEn", "She goes to school.", "textTr", "O okula gider.", "exampleTr",
                "Tek kişiden söz ederken fiile ek gelir.", "contentId", LESSON, "cueId", "c07",
                "audioPath", "_grammar/" + LESSON + "/audio/c07-ex1.m4a", "source", "grammar",
                "sourceTitle", "Dolaylı soru ve emir", "createdAt", "2026-10-13T09:00:00Z",
                "updatedAt", "2026-10-13T09:00:00Z")), token);
        assertThat(r.status()).as(r.raw()).isEqualTo(200);
        assertThat(r.body().path("accepted")).hasSize(1);
        JsonNode pulled = get("/api/v1/sync/pull?since=0", token).body().path("changes").path("notebook_items");
        assertThat(pulled.get(0).path("kind").asString()).isEqualTo("rule");
        assertThat(pulled.get(0).path("source").asString()).isEqualTo("grammar");
        assertThat(pulled.get(0).path("contentId").asString()).isEqualTo(LESSON);
    }

    @Test
    void speechAttemptInLessonIsAccepted() {
        String token = login("a@example.com").text("accessToken");
        Response r = call("POST", PUSH, push("speech_attempts", row("clientId", UUID.randomUUID().toString(),
                "place", "grammar", "contentId", LESSON, "itemRef", "She goes to school.", "matchLevel", "full",
                "missingCount", 0, "errorNoteId", null, "at", "2026-10-13T09:00:00Z")), token);
        assertThat(r.status()).as(r.raw()).isEqualTo(200);
        assertThat(r.body().path("accepted")).hasSize(1);
        assertThat(jdbc.queryForObject("SELECT place FROM speech_attempts", String.class)).isEqualTo("grammar");
    }
}
