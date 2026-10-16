package tr.velzon.hivelzon.sync;

import static org.assertj.core.api.Assertions.assertThat;
import static tr.velzon.hivelzon.sync.SyncTest.PUSH;
import static tr.velzon.hivelzon.sync.SyncTest.push;
import static tr.velzon.hivelzon.sync.SyncTest.row;

import java.util.HashMap;
import java.util.Map;

import org.junit.jupiter.api.Test;

import tools.jackson.databind.JsonNode;
import tr.velzon.hivelzon.support.IntegrationTest;

/**
 * Kitap sonu anlama (H-091): kitap başına yalnız sayılar ve öz değerlendirme; düz son yazan kazanır. Bilinmeyen
 * alan (ör. yeniden anlatma metni) ve sınır dışı değer reddedilir.
 */
class BookComprehensionSyncTest extends IntegrationTest {

    static final String TABLE = "user_book_comprehension";

    static Map<String, Object> result(int firstTry, String selfCheck, String updatedAt) {
        return row("bookId", "A1-K01", "contentVersion", 1, "answered", 2, "firstTryCorrect", firstTry,
                "retellDone", selfCheck != null, "selfCheck", selfCheck, "completedAt", updatedAt,
                "updatedAt", updatedAt);
    }

    @Test
    void lastWriterWins() {
        String token = login("a@example.com").text("accessToken");
        Response first = call("POST", PUSH, push(TABLE, result(1, "some", "2026-10-13T09:00:00Z")), token);
        assertThat(first.status()).as(first.raw()).isEqualTo(200);
        assertThat(first.body().path("accepted")).hasSize(1);
        Response newer = call("POST", PUSH, push(TABLE, result(2, "all", "2026-10-13T10:00:00Z")), token);
        assertThat(newer.body().path("accepted")).as(newer.raw()).hasSize(1);
        Response older = call("POST", PUSH, push(TABLE, result(0, null, "2026-10-13T08:00:00Z")), token);
        assertThat(older.body().path("conflicts")).as(older.raw()).hasSize(1);
        assertThat(older.body().path("conflicts").get(0).path("reason").asString()).isEqualTo("STALE");

        assertThat(count("SELECT count(*) FROM user_book_comprehension")).isEqualTo(1);
        assertThat(jdbc.queryForObject("SELECT self_check FROM user_book_comprehension", String.class))
                .isEqualTo("all");
        JsonNode pulled = get("/api/v1/sync/pull?since=0", token).body().path("changes").path(TABLE);
        assertThat(pulled).hasSize(1);
        assertThat(pulled.get(0).path("firstTryCorrect").asInt()).isEqualTo(2);
        assertThat(pulled.get(0).path("retellDone").asBoolean()).isTrue();
    }

    @Test
    void invalidRowsAreRejected() {
        String token = login("a@example.com").text("accessToken");
        Response tooMany = call("POST", PUSH, push(TABLE, row("bookId", "A1-K01", "contentVersion", 1, "answered", 3,
                "firstTryCorrect", 0, "retellDone", false, "selfCheck", null, "completedAt", "2026-10-13T09:00:00Z",
                "updatedAt", "2026-10-13T09:00:00Z")), token);
        assertThat(tooMany.status()).isEqualTo(400);
        Response badCheck = call("POST", PUSH, push(TABLE, result(1, "great", "2026-10-13T09:00:00Z")), token);
        assertThat(badCheck.status()).isEqualTo(400);
        Map<String, Object> withText = new HashMap<>(result(1, "some", "2026-10-13T09:00:00Z"));
        withText.put("retellText", "Ece finds a key.");
        Response text = call("POST", PUSH, push(TABLE, withText), token);
        assertThat(text.status()).isEqualTo(400);
        assertThat(count("SELECT count(*) FROM user_book_comprehension")).isZero();
    }
}
