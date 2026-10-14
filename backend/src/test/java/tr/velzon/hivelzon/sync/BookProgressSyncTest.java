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
 * Kitaplık (H-067): kitap ilerlemesi eşitlenir; "bitti her zaman kazanır", öteki alanlarda son yazan kazanır.
 * Defterde kitaptan eklenen ifade ({@code source = book}, {@code sourceTitle}) kabul edilir.
 */
class BookProgressSyncTest extends IntegrationTest {

    static final String TABLE = "user_book_progress";

    static Map<String, Object> progress(String status, int page, int sentence, String completedAt, String updatedAt) {
        return row("bookId", "A1-K01", "status", status, "chapterId", page > 6 ? "c2" : "c1", "pageNumber", page,
                "sentenceIndex", sentence, "positionSec", 1.5 * page, "startedAt", "2026-10-13T08:00:00Z",
                "completedAt", completedAt, "updatedAt", updatedAt);
    }

    Map<String, Object> stored() {
        return jdbc.queryForMap("SELECT status, chapter_id, page_number, sentence_index, position_sec, completed_at "
                + "FROM user_book_progress");
    }

    @Test
    void sameStatusIsLastWriterWins() {
        String token = login("a@example.com").text("accessToken");
        Response first = call("POST", PUSH, push(TABLE, progress("IN_PROGRESS", 3, 2, null, "2026-10-13T09:00:00Z")),
                token);
        assertThat(first.status()).as(first.raw()).isEqualTo(200);
        assertThat(first.body().path("accepted")).hasSize(1);

        call("POST", PUSH, push(TABLE, progress("IN_PROGRESS", 8, 0, null, "2026-10-13T09:10:00Z")), token);
        assertThat(stored().get("page_number")).isEqualTo(8);
        assertThat(stored().get("chapter_id")).isEqualTo("c2");

        // Daha eski kopya geri getirmez.
        Response older = call("POST", PUSH, push(TABLE, progress("IN_PROGRESS", 2, 0, null, "2026-10-13T09:05:00Z")),
                token);
        assertThat(older.body().path("conflicts").get(0).path("reason").asString()).isEqualTo("STALE");
        assertThat(stored().get("page_number")).isEqualTo(8);
    }

    @Test
    void newerInProgressCannotUndoCompleted() {
        String token = login("a@example.com").text("accessToken");
        call("POST", PUSH, push(TABLE, progress("COMPLETED", 12, 4, "2026-10-13T09:00:00Z", "2026-10-13T09:00:00Z")),
                token);

        Response r = call("POST", PUSH, push(TABLE, progress("IN_PROGRESS", 2, 1, null, "2026-10-13T09:30:00Z")),
                token);
        assertThat(r.status()).as(r.raw()).isEqualTo(200);
        JsonNode conflict = r.body().path("conflicts").get(0);
        assertThat(conflict.path("reason").asString()).isEqualTo("MERGED");
        JsonNode server = conflict.path("serverRow");
        assertThat(server.path("status").asString()).isEqualTo("COMPLETED");
        assertThat(server.path("completedAt").asString()).isEqualTo("2026-10-13T09:00:00Z");
        // Biten kopyanın kalınan yeri korunur.
        assertThat(server.path("pageNumber").asInt()).isEqualTo(12);
        assertThat(server.path("sentenceIndex").asInt()).isEqualTo(4);
        assertThat(stored().get("status")).isEqualTo("COMPLETED");
    }

    @Test
    void olderCompletedRaisesNewerInProgress() {
        String token = login("a@example.com").text("accessToken");
        call("POST", PUSH, push(TABLE, progress("IN_PROGRESS", 5, 0, null, "2026-10-13T09:30:00Z")), token);

        Response r = call("POST", PUSH,
                push(TABLE, progress("COMPLETED", 12, 4, "2026-10-13T09:00:00Z", "2026-10-13T09:00:00Z")), token);
        JsonNode server = r.body().path("conflicts").get(0).path("serverRow");
        assertThat(server.path("status").asString()).isEqualTo("COMPLETED");
        assertThat(server.path("pageNumber").asInt()).isEqualTo(12);
        assertThat(server.path("updatedAt").asString()).isEqualTo("2026-10-13T09:30:00.001Z");
        assertThat(stored().get("status")).isEqualTo("COMPLETED");
    }

    @Test
    void invalidRowsAreRejected() {
        String token = login("a@example.com").text("accessToken");
        Response bad = call("POST", PUSH, push(TABLE, row("bookId", "A1-K01", "status", "READ", "updatedAt",
                "2026-10-13T09:00:00Z")), token);
        assertThat(bad.status()).isEqualTo(400);
        assertThat(count("SELECT count(*) FROM user_book_progress")).isZero();
    }

    @Test
    void notebookAcceptsBookSource() {
        String token = login("a@example.com").text("accessToken");
        Response r = call("POST", PUSH, push("notebook_items", row("itemKey", "word|box", "kind", "word",
                "textEn", "box", "textTr", "kutu", "exampleEn", "Ece has a small box.",
                "exampleTr", "Ece'nin küçük bir kutusu var.", "contentId", "A1-K01", "cueId", "p01-s01",
                "imagePath", "_books/A1-K01/images/p01.webp", "audioPath", "_books/A1-K01/audio/c1.m4a",
                "audioStart", 2.4, "audioEnd", 2.7, "exampleStart", 1.3, "exampleEnd", 2.7, "source", "book",
                "sourceTitle", "The Blue Door", "createdAt", "2026-10-13T09:00:00Z",
                "updatedAt", "2026-10-13T09:00:00Z")), token);
        assertThat(r.status()).as(r.raw()).isEqualTo(200);
        assertThat(r.body().path("accepted")).hasSize(1);
        assertThat(jdbc.queryForObject("SELECT source_title FROM notebook_items", String.class))
                .isEqualTo("The Blue Door");
        JsonNode pulled = get("/api/v1/sync/pull?since=0", token).body().path("changes").path("notebook_items");
        assertThat(pulled.get(0).path("source").asString()).isEqualTo("book");
        assertThat(pulled.get(0).path("sourceTitle").asString()).isEqualTo("The Blue Door");
    }
}
