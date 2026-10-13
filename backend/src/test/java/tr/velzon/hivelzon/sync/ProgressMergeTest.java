package tr.velzon.hivelzon.sync;

import static org.assertj.core.api.Assertions.assertThat;
import static tr.velzon.hivelzon.sync.SyncTest.PUSH;
import static tr.velzon.hivelzon.sync.SyncTest.push;
import static tr.velzon.hivelzon.sync.SyncTest.row;

import java.util.Map;

import org.junit.jupiter.api.Test;

import tools.jackson.databind.JsonNode;
import tr.velzon.hivelzon.support.IntegrationTest;

/** "Bitti her zaman kazanır" (H-056): bölüm ilerlemesi hiçbir eşitlemeyle geri gitmez; bölüm kapısı yalnız eklenir. */
class ProgressMergeTest extends IntegrationTest {

    static Map<String, Object> progress(String status, String checkpoint, String completedAt, String startedAt,
            String updatedAt) {
        return row("contentId", "A1-001", "status", status, "lastCheckpointNodeId", checkpoint,
                "checkpointSnapshot", "{\"visited\":[\"" + checkpoint + "\"]}", "startedAt", startedAt,
                "completedAt", completedAt, "updatedAt", updatedAt);
    }

    static Map<String, Object> completed(String updatedAt) {
        return progress("COMPLETED", "end", updatedAt, "2026-10-13T08:00:00Z", updatedAt);
    }

    static Map<String, Object> inProgress(String checkpoint, String startedAt, String updatedAt) {
        return progress("IN_PROGRESS", checkpoint, null, startedAt, updatedAt);
    }

    Map<String, Object> stored() {
        return jdbc.queryForMap("SELECT status, last_checkpoint_node_id, completed_at, started_at, updated_at, seq "
                + "FROM user_story_progress");
    }

    JsonNode pullProgress(String token, long since) {
        return get("/api/v1/sync/pull?since=" + since, token).body().path("changes").path("user_story_progress");
    }

    @Test
    void newerInProgressCannotUndoCompleted() {
        String token = login("a@example.com").text("accessToken");
        call("POST", PUSH, push("user_story_progress", completed("2026-10-13T09:00:00Z")), token);

        Response r = call("POST", PUSH, push("user_story_progress",
                inProgress("s03", "2026-10-13T07:00:00Z", "2026-10-13T09:30:00Z")), token);
        assertThat(r.status()).as(r.raw()).isEqualTo(200);
        assertThat(r.body().path("accepted")).isEmpty();
        JsonNode conflict = r.body().path("conflicts").get(0);
        assertThat(conflict.path("reason").asString()).isEqualTo("MERGED");
        JsonNode server = conflict.path("serverRow");
        assertThat(server.path("status").asString()).isEqualTo("COMPLETED");
        assertThat(server.path("completedAt").asString()).isEqualTo("2026-10-13T09:00:00Z");
        assertThat(server.path("lastCheckpointNodeId").asString()).isEqualTo("end");
        // Daha yeni zaman ve en erken başlangıç alınır.
        assertThat(server.path("updatedAt").asString()).isEqualTo("2026-10-13T09:30:00Z");
        assertThat(server.path("startedAt").asString()).isEqualTo("2026-10-13T07:00:00Z");
        assertThat(stored().get("status")).isEqualTo("COMPLETED");
    }

    @Test
    void olderCompletedRaisesNewerInProgress() {
        String a = login("a@example.com").text("accessToken");
        call("POST", PUSH, push("user_story_progress",
                inProgress("s05", "2026-10-13T08:30:00Z", "2026-10-13T09:30:00Z")), a);
        long seqBefore = (Long) stored().get("seq");

        Response r = call("POST", PUSH, push("user_story_progress", completed("2026-10-13T09:00:00Z")), a);
        JsonNode conflict = r.body().path("conflicts").get(0);
        assertThat(conflict.path("reason").asString()).isEqualTo("MERGED");
        JsonNode server = conflict.path("serverRow");
        assertThat(server.path("status").asString()).isEqualTo("COMPLETED");
        assertThat(server.path("completedAt").asString()).isEqualTo("2026-10-13T09:00:00Z");
        assertThat(server.path("lastCheckpointNodeId").asString()).isEqualTo("end");
        assertThat(server.path("startedAt").asString()).isEqualTo("2026-10-13T08:00:00Z");
        // Sunucudaki zamanın 1 ms sonrası: öteki cihazlar "kendi itmem" sanıp atlamasın.
        assertThat(server.path("updatedAt").asString()).isEqualTo("2026-10-13T09:30:00.001Z");
        assertThat((Long) stored().get("seq")).isGreaterThan(seqBefore);
        // Başka bir imleçten çeken cihaz birleşik satırı alır.
        JsonNode pulled = pullProgress(a, seqBefore);
        assertThat(pulled).hasSize(1);
        assertThat(pulled.get(0).path("status").asString()).isEqualTo("COMPLETED");
    }

    @Test
    void twoDevicesOfflineCompletedWins() {
        String token = login("a@example.com").text("accessToken");
        // İki cihaz da başlamış ve eşitlemiş.
        call("POST", PUSH, push("user_story_progress",
                inProgress("s02", "2026-10-13T08:00:00Z", "2026-10-13T08:10:00Z")), token);
        long cursorB = (Long) stored().get("seq");
        // Çevrimdışı: A t1'de bitirir; B t2 > t1'de devam eder ve önce iter.
        Response pushB = call("POST", PUSH, push("user_story_progress",
                inProgress("s04", "2026-10-13T08:00:00Z", "2026-10-13T09:20:00Z")), token);
        assertThat(pushB.body().path("accepted").get(0).path("result").asString()).isEqualTo("UPDATED");
        Response pushA = call("POST", PUSH, push("user_story_progress", completed("2026-10-13T09:00:00Z")), token);
        assertThat(pushA.body().path("conflicts").get(0).path("reason").asString()).isEqualTo("MERGED");
        assertThat(stored().get("status")).isEqualTo("COMPLETED");
        // B çekince COMPLETED alır.
        JsonNode pulledB = pullProgress(token, cursorB);
        assertThat(pulledB.get(pulledB.size() - 1).path("status").asString()).isEqualTo("COMPLETED");
        // B'nin eski bilgisi yeniden gelse bile geri gitmez.
        Response replayB = call("POST", PUSH, push("user_story_progress",
                inProgress("s04", "2026-10-13T08:00:00Z", "2026-10-13T09:20:00Z")), token);
        assertThat(replayB.body().path("conflicts").get(0).path("serverRow").path("status").asString())
                .isEqualTo("COMPLETED");
        assertThat(stored().get("status")).isEqualTo("COMPLETED");
    }

    @Test
    void equalTimestampLowerRankKeepsCompleted() {
        String token = login("a@example.com").text("accessToken");
        call("POST", PUSH, push("user_story_progress", completed("2026-10-13T09:00:00Z")), token);
        long seq = (Long) stored().get("seq");

        // Düz LWW'de aynı zamanda varış sırası kazanırdı; burada sunucudaki aynen kalır.
        Response r = call("POST", PUSH, push("user_story_progress",
                inProgress("s03", "2026-10-13T07:00:00Z", "2026-10-13T09:00:00Z")), token);
        JsonNode conflict = r.body().path("conflicts").get(0);
        assertThat(conflict.path("reason").asString()).isEqualTo("MERGED");
        assertThat(conflict.path("serverRow").path("status").asString()).isEqualTo("COMPLETED");
        assertThat(conflict.path("serverRow").path("lastCheckpointNodeId").asString()).isEqualTo("end");
        assertThat(conflict.path("serverRow").path("updatedAt").asString()).isEqualTo("2026-10-13T09:00:00Z");
        assertThat((Long) stored().get("seq")).isEqualTo(seq);
        assertThat(stored().get("status")).isEqualTo("COMPLETED");
    }

    @Test
    void equalTimestampHigherRankRaises() {
        String token = login("a@example.com").text("accessToken");
        call("POST", PUSH, push("user_story_progress",
                inProgress("s03", "2026-10-13T08:00:00Z", "2026-10-13T09:00:00Z")), token);
        Response r = call("POST", PUSH, push("user_story_progress", completed("2026-10-13T09:00:00Z")), token);
        JsonNode conflict = r.body().path("conflicts").get(0);
        assertThat(conflict.path("reason").asString()).isEqualTo("MERGED");
        assertThat(conflict.path("serverRow").path("status").asString()).isEqualTo("COMPLETED");
        assertThat(conflict.path("serverRow").path("updatedAt").asString()).isEqualTo("2026-10-13T09:00:00.001Z");
        assertThat(stored().get("status")).isEqualTo("COMPLETED");
    }

    @Test
    void sameRankKeepsLastWriterWins() {
        String token = login("a@example.com").text("accessToken");
        call("POST", PUSH, push("user_story_progress",
                inProgress("s02", "2026-10-13T08:00:00Z", "2026-10-13T09:00:00Z")), token);
        Response newer = call("POST", PUSH, push("user_story_progress",
                inProgress("s03", "2026-10-13T08:00:00Z", "2026-10-13T09:10:00Z")), token);
        assertThat(newer.body().path("accepted").get(0).path("result").asString()).isEqualTo("UPDATED");
        Response older = call("POST", PUSH, push("user_story_progress",
                inProgress("s01", "2026-10-13T08:00:00Z", "2026-10-13T08:50:00Z")), token);
        assertThat(older.body().path("conflicts").get(0).path("reason").asString()).isEqualTo("STALE");
        assertThat(stored().get("last_checkpoint_node_id")).isEqualTo("s03");
        // Bitmiş bölüm yeniden bitince (tekrar oynama) yeni kayıt noktası düz LWW ile alınır.
        call("POST", PUSH, push("user_story_progress", completed("2026-10-13T09:20:00Z")), token);
        Response again = call("POST", PUSH, push("user_story_progress", completed("2026-10-13T09:40:00Z")), token);
        assertThat(again.body().path("accepted").get(0).path("result").asString()).isEqualTo("UPDATED");
        // İlk itme: birleştirme yok, düz ekleme.
        Response fresh = call("POST", PUSH, push("user_story_progress", row("contentId", "A1-002", "status",
                "NOT_STARTED", "updatedAt", "2026-10-13T09:00:00Z")), token);
        assertThat(fresh.body().path("accepted").get(0).path("result").asString()).isEqualTo("CREATED");
    }

    @Test
    void gateProgressIsAppendOnly() {
        String token = login("a@example.com").text("accessToken");
        Map<String, Object> gate = row("contentId", "A1-001", "itemKind", "comprehension", "nodeId", "q1",
                "recordedAt", "2026-10-13T09:00:00Z");
        call("POST", PUSH, push("gate_progress", gate), token);
        // Silme işareti kabul edilmez (yalnız eklenen tabloda "deleted" alanı yok).
        Map<String, Object> tombstone = row("contentId", "A1-001", "itemKind", "comprehension", "nodeId", "q1",
                "recordedAt", "2026-10-13T09:30:00Z", "deleted", true);
        Response del = call("POST", PUSH, push("gate_progress", tombstone), token);
        assertThat(del.status()).isEqualTo(400);
        assertThat(problemCode(del)).isEqualTo("SYNC_FIELD_NOT_ALLOWED");
        // Aynı öğe yeni zamanla gelse de ilk kayıt kalır.
        Map<String, Object> later = row("contentId", "A1-001", "itemKind", "comprehension", "nodeId", "q1",
                "recordedAt", "2026-10-13T09:40:00Z");
        assertThat(call("POST", PUSH, push("gate_progress", later), token).body().path("accepted").get(0)
                .path("result").asString()).isEqualTo("DUPLICATE");
        assertThat(count("SELECT count(*) FROM gate_progress")).isEqualTo(1);
        assertThat(count("SELECT count(*) FROM gate_progress WHERE recorded_at = '2026-10-13T09:00:00Z'"))
                .isEqualTo(1);
    }
}
