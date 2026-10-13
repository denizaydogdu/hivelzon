package tr.velzon.hivelzon.sync;

import static org.assertj.core.api.Assertions.assertThat;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import tools.jackson.databind.JsonNode;
import tr.velzon.hivelzon.common.config.HivelzonProperties;
import tr.velzon.hivelzon.common.crypto.Uuids;
import tr.velzon.hivelzon.support.IntegrationTest;
import tr.velzon.hivelzon.support.QueryCounter;
import tr.velzon.hivelzon.user.AccountPurgeService;

/**
 * Öğrenen verisi eşitleme: idempotent itme, son yazan kazanır, yalnız eklenen tablolar, çekme imleci ve
 * sayfalama, kullanıcı ayrımı, boyut ve hız sınırları, transkript reddi, kalıcı silmede temizlik, N+1.
 */
class SyncTest extends IntegrationTest {

    static final String PUSH = "/api/v1/sync/push";
    static final String[] TABLES = {"user_story_progress", "user_story_flags", "gate_progress", "season_state",
            "clues", "story_links", "notebook_items", "review_cards", "review_logs", "learning_events", "hi_records",
            "speech_attempts"};

    @Autowired
    HivelzonProperties properties;

    @Autowired
    AccountPurgeService purge;

    static Map<String, Object> push(String table, Object... rows) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("deviceId", "ios-test-1");
        body.put("changes", Map.of(table, List.of(rows)));
        return body;
    }

    static Map<String, Object> row(Object... kv) {
        Map<String, Object> m = new LinkedHashMap<>();
        for (int i = 0; i < kv.length; i += 2) {
            m.put((String) kv[i], kv[i + 1]);
        }
        return m;
    }

    static Map<String, Object> progress(String contentId, String status, String updatedAt) {
        return row("contentId", contentId, "status", status, "lastCheckpointNodeId", "s02",
                "checkpointSnapshot", "{\"flags\":{},\"visited\":[\"title\",\"s02\"],\"contentVersion\":1}",
                "startedAt", "2026-10-13T09:00:00Z", "completedAt", null, "updatedAt", updatedAt);
    }

    static Map<String, Object> event(UUID id, String target) {
        return row("clientId", id.toString(), "contentId", "A1-001", "sourceId", "s04-05", "target", target,
                "at", "2026-10-13T09:10:00Z", "errorType", "be-omission", "errorTaxonomyVersion", 1);
    }

    static Map<String, Object> speech(UUID id) {
        return row("clientId", id.toString(), "place", "decision", "contentId", "A1-001", "itemRef", "k1#a",
                "matchLevel", "close", "missingCount", 1, "errorNoteId", null, "at", "2026-10-13T09:11:00Z");
    }

    @Test
    void pushIsIdempotent() {
        String token = login("a@example.com").text("accessToken");
        UUID id = UUID.randomUUID();
        Response first = call("POST", PUSH, push("learning_events", event(id, "Can you hear me?")), token);
        assertThat(first.status()).as(first.raw()).isEqualTo(200);
        assertThat(first.body().path("accepted").get(0).path("result").asString()).isEqualTo("CREATED");
        Response again = call("POST", PUSH, push("learning_events", event(id, "Can you hear me?")), token);
        assertThat(again.body().path("accepted").get(0).path("result").asString()).isEqualTo("DUPLICATE");
        assertThat(count("SELECT count(*) FROM learning_events")).isEqualTo(1);

        // Doğal anahtarlı tablo: aynı satır iki kez → bir satır, ikincisi değişiklik yapmaz (sıra artmaz).
        call("POST", PUSH, push("user_story_progress", progress("A1-001", "IN_PROGRESS", "2026-10-13T09:20:00Z")), token);
        long seq = jdbc.queryForObject("SELECT seq FROM user_story_progress", Long.class);
        Response same = call("POST", PUSH,
                push("user_story_progress", progress("A1-001", "IN_PROGRESS", "2026-10-13T09:20:00Z")), token);
        assertThat(same.body().path("accepted").get(0).path("result").asString()).isEqualTo("UNCHANGED");
        assertThat(jdbc.queryForObject("SELECT seq FROM user_story_progress", Long.class)).isEqualTo(seq);
        assertThat(count("SELECT count(*) FROM user_story_progress")).isEqualTo(1);
    }

    @Test
    void naturalKeyGivesSameClientIdOnEveryDevice() {
        String token = login("a@example.com").text("accessToken");
        UUID expected = Uuids.v5(Uuids.SYNC_NAMESPACE, "user_story_flags:A1-002|greet_tone");
        Response r = call("POST", PUSH, push("user_story_flags", row("contentId", "A1-002", "flag", "greet_tone",
                "value", "formal", "updatedAt", "2026-10-13T09:00:00Z")), token);
        assertThat(r.body().path("accepted").get(0).path("clientId").asString()).isEqualTo(expected.toString());
        // Aynı kimlikle gönderilebilir; farklı kimlik reddedilir.
        Response ok = call("POST", PUSH, push("user_story_flags", row("clientId", expected.toString(),
                "contentId", "A1-002", "flag", "greet_tone", "value", "casual", "updatedAt", "2026-10-13T09:05:00Z")),
                token);
        assertThat(ok.body().path("accepted").get(0).path("result").asString()).isEqualTo("UPDATED");
        Response wrong = call("POST", PUSH, push("user_story_flags", row("clientId", UUID.randomUUID().toString(),
                "contentId", "A1-002", "flag", "greet_tone", "value", "casual", "updatedAt", "2026-10-13T09:06:00Z")),
                token);
        assertThat(wrong.status()).isEqualTo(400);
        assertThat(problemCode(wrong)).isEqualTo("SYNC_ROW_INVALID");
        assertThat(wrong.text("field")).isEqualTo("clientId");
        assertThat(count("SELECT count(*) FROM user_story_flags")).isEqualTo(1);
    }

    @Test
    void lastWriterWinsWithServerArrivalTieBreak() {
        // Düz LWW kuralı (birleştirme kuralı olmayan tablo). Bölüm ilerlemesindeki "bitti her zaman kazanır"
        // birleştirmesi ProgressMergeTest'te.
        String token = login("a@example.com").text("accessToken");
        call("POST", PUSH, push("user_story_flags", flag("formal", "2026-10-13T09:30:00Z")), token);

        // Daha eski yazma: sunucudaki kalır, çatışma ve sunucu satırı döner.
        Response stale = call("POST", PUSH, push("user_story_flags", flag("casual", "2026-10-13T09:10:00Z")), token);
        assertThat(stale.body().path("accepted").size()).isZero();
        JsonNode conflict = stale.body().path("conflicts").get(0);
        assertThat(conflict.path("reason").asString()).isEqualTo("STALE");
        assertThat(conflict.path("serverRow").path("value").asString()).isEqualTo("formal");
        assertThat(flagValue()).isEqualTo("formal");

        // Aynı zaman, farklı veri: sonra gelen kazanır.
        Response tie = call("POST", PUSH, push("user_story_flags", flag("casual", "2026-10-13T09:30:00Z")), token);
        assertThat(tie.body().path("accepted").get(0).path("result").asString()).isEqualTo("UPDATED");
        assertThat(flagValue()).isEqualTo("casual");

        // Daha yeni yazma kazanır.
        Response newer = call("POST", PUSH, push("user_story_flags", flag("rude", "2026-10-13T09:45:00Z")), token);
        assertThat(newer.body().path("accepted").get(0).path("result").asString()).isEqualTo("UPDATED");
        assertThat(flagValue()).isEqualTo("rude");

        // İleri tarihli istemci saati sunucu saatine çekilir (sonsuza kadar kazanamaz).
        call("POST", PUSH, push("user_story_flags", flag("formal", "2099-01-01T00:00:00Z")), token);
        assertThat(jdbc.queryForObject("SELECT updated_at = ?::timestamptz FROM user_story_flags", Boolean.class,
                "2026-10-13T10:00:00Z")).isTrue();
    }

    static Map<String, Object> flag(String value, String updatedAt) {
        return row("contentId", "A1-002", "flag", "greet_tone", "value", value, "updatedAt", updatedAt);
    }

    String flagValue() {
        return jdbc.queryForObject("SELECT value FROM user_story_flags", String.class);
    }

    @Test
    void tombstoneClearsDataAndPropagates() {
        String token = login("a@example.com").text("accessToken");
        call("POST", PUSH, push("hi_records", row("kind", "bridge_task", "refId", "order-coffee", "status", "done",
                "updatedAt", "2026-10-13T09:00:00Z")), token);
        Response del = call("POST", PUSH, push("hi_records", row("kind", "bridge_task", "refId", "order-coffee",
                "deleted", true, "updatedAt", "2026-10-13T09:01:00Z")), token);
        assertThat(del.body().path("accepted").get(0).path("result").asString()).isEqualTo("UPDATED");
        assertThat(count("SELECT count(*) FROM hi_records WHERE deleted AND status IS NULL")).isEqualTo(1);
        JsonNode pulled = get("/api/v1/sync/pull?since=0", token).body().path("changes").path("hi_records").get(0);
        assertThat(pulled.path("deleted").asBoolean()).isTrue();
        assertThat(pulled.path("status").isNull()).isTrue();
    }

    @Test
    void appendOnlyRowsAreNeverOverwritten() {
        String token = login("a@example.com").text("accessToken");
        UUID id = UUID.randomUUID();
        call("POST", PUSH, push("speech_attempts", speech(id)), token);
        Map<String, Object> changed = speech(id);
        changed.put("matchLevel", "full");
        Response again = call("POST", PUSH, push("speech_attempts", changed), token);
        assertThat(again.body().path("accepted").get(0).path("result").asString()).isEqualTo("DUPLICATE");
        assertThat(jdbc.queryForObject("SELECT match_level FROM speech_attempts", String.class)).isEqualTo("close");
        // Bölüm kapısı ve ipucu da yalnız eklenir.
        Map<String, Object> gate = row("contentId", "A1-001", "itemKind", "activeTask", "nodeId", "t-kanit",
                "recordedAt", "2026-10-13T09:00:00Z");
        call("POST", PUSH, push("gate_progress", gate), token);
        assertThat(call("POST", PUSH, push("gate_progress", gate), token).body().path("accepted").get(0)
                .path("result").asString()).isEqualTo("DUPLICATE");
    }

    @Test
    void transcriptAndUnknownFieldsRejectedAtomically() {
        String token = login("a@example.com").text("accessToken");
        Map<String, Object> withTranscript = speech(UUID.randomUUID());
        withTranscript.put("transcript", "can you hear me");
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("changes", Map.of("learning_events", List.of(event(UUID.randomUUID(), "Listen.")),
                "speech_attempts", List.of(speech(UUID.randomUUID()), withTranscript)));
        Response r = call("POST", PUSH, body, token);
        assertThat(r.status()).isEqualTo(400);
        assertThat(problemCode(r)).isEqualTo("TRANSCRIPT_NOT_ALLOWED");
        assertThat(r.text("table")).isEqualTo("speech_attempts");
        assertThat(r.body().path("index").asInt()).isEqualTo(1);
        assertThat(r.raw()).doesNotContain("can you hear me");
        // Hiçbir satır yazılmadı.
        assertThat(count("SELECT count(*) FROM speech_attempts") + count("SELECT count(*) FROM learning_events")).isZero();

        for (String field : new String[] {"audioBase64", "recognized_text", "confidence"}) {
            Map<String, Object> bad = speech(UUID.randomUUID());
            bad.put(field, "x");
            assertThat(problemCode(call("POST", PUSH, push("speech_attempts", bad), token)))
                    .as(field).isEqualTo("TRANSCRIPT_NOT_ALLOWED");
        }
        Map<String, Object> unknown = event(UUID.randomUUID(), "Listen.");
        unknown.put("email", "a@example.com");
        Response u = call("POST", PUSH, push("learning_events", unknown), token);
        assertThat(problemCode(u)).isEqualTo("SYNC_FIELD_NOT_ALLOWED");
        assertThat(u.text("field")).isEqualTo("email");

        Response badEnum = call("POST", PUSH, push("speech_attempts",
                row("clientId", UUID.randomUUID().toString(), "place", "elsewhere", "itemRef", "x", "matchLevel",
                        "full", "missingCount", 0, "at", "2026-10-13T09:00:00Z")), token);
        assertThat(problemCode(badEnum)).isEqualTo("SYNC_ROW_INVALID");
        assertThat(badEnum.text("field")).isEqualTo("place");
        Response unknownTable = call("POST", PUSH, push("app_meta", row("key", "x", "value", "y")), token);
        assertThat(problemCode(unknownTable)).isEqualTo("SYNC_ROW_INVALID");
        assertThat(count("SELECT count(*) FROM speech_attempts")).isZero();
    }

    @Test
    void pullPagesThroughChangesInServerOrder() {
        String token = login("a@example.com").text("accessToken");
        List<Object> events = new ArrayList<>();
        for (int i = 0; i < 18; i++) {
            events.add(event(UUID.randomUUID(), "t" + i));
        }
        Map<String, Object> body = Map.of("changes", Map.of(
                "learning_events", events,
                "user_story_progress", List.of(progress("A1-001", "COMPLETED", "2026-10-13T09:00:00Z"),
                        progress("A1-002", "IN_PROGRESS", "2026-10-13T09:00:00Z")),
                "season_state", List.of(row("seasonId", 1, "introSeen", true, "introSeenAt", "2026-10-13T08:00:00Z",
                        "updatedAt", "2026-10-13T08:00:00Z"))));
        assertThat(call("POST", PUSH, body, token).status()).isEqualTo(200);

        Set<String> seen = new HashSet<>();
        long since = 0;
        int pages = 0;
        long lastSeq = 0;
        while (true) {
            Response page = get("/api/v1/sync/pull?since=" + since + "&limit=8", token);
            assertThat(page.status()).isEqualTo(200);
            int n = 0;
            for (var tables = page.body().path("changes").properties().iterator(); tables.hasNext();) {
                var e = tables.next();
                for (JsonNode r : e.getValue()) {
                    assertThat(seen.add(e.getKey() + ":" + r.path("clientId").asString())).isTrue();
                    n++;
                }
            }
            pages++;
            long next = page.body().path("nextSince").asLong();
            assertThat(next).isGreaterThanOrEqualTo(lastSeq);
            lastSeq = next;
            if (!page.body().path("hasMore").asBoolean()) {
                assertThat(n).isLessThanOrEqualTo(8);
                break;
            }
            assertThat(n).isEqualTo(8);
            since = next;
        }
        assertThat(seen).hasSize(21);
        assertThat(pages).isEqualTo(3);
        Response empty = get("/api/v1/sync/pull?since=" + lastSeq, token);
        assertThat(empty.body().path("changes").size()).isZero();
        assertThat(empty.body().path("hasMore").asBoolean()).isFalse();
        assertThat(empty.body().path("nextSince").asLong()).isEqualTo(lastSeq);

        // Güncellenen satır yeni sırayla yeniden gelir.
        call("POST", PUSH, push("user_story_progress", progress("A1-002", "COMPLETED", "2026-10-13T09:30:00Z")), token);
        JsonNode delta = get("/api/v1/sync/pull?since=" + lastSeq, token).body().path("changes");
        assertThat(delta.path("user_story_progress").size()).isEqualTo(1);
        assertThat(delta.path("user_story_progress").get(0).path("contentId").asString()).isEqualTo("A1-002");
    }

    @Test
    void usersNeverSeeEachOthersData() {
        String a = login("a@example.com").text("accessToken");
        String b = login("b@example.com").text("accessToken");
        call("POST", PUSH, push("user_story_progress", progress("A1-001", "COMPLETED", "2026-10-13T09:00:00Z")), a);
        call("POST", PUSH, push("learning_events", event(UUID.randomUUID(), "secret")), a);
        Response pullB = get("/api/v1/sync/pull?since=0", b);
        assertThat(pullB.body().path("changes").size()).isZero();

        // B'nin aynı doğal anahtarı kendi satırıdır; A'nınkine dokunmaz.
        call("POST", PUSH, push("user_story_progress", progress("A1-001", "NOT_STARTED", "2026-10-13T11:00:00Z")), b);
        assertThat(count("SELECT count(*) FROM user_story_progress")).isEqualTo(2);
        assertThat(get("/api/v1/sync/pull?since=0", a).body().path("changes").path("user_story_progress").get(0)
                .path("status").asString()).isEqualTo("COMPLETED");
        // Belirteçsiz erişim yok.
        assertThat(get("/api/v1/sync/pull?since=0", null).status()).isEqualTo(401);
        assertThat(call("POST", PUSH, push("learning_events", event(UUID.randomUUID(), "x")), null).status())
                .isEqualTo(401);
    }

    @Test
    void payloadLimits() throws Exception {
        String token = login("a@example.com").text("accessToken");
        List<Object> many = new ArrayList<>();
        for (int i = 0; i < 501; i++) {
            many.add(event(UUID.randomUUID(), "t"));
        }
        Response tooMany = call("POST", PUSH, Map.of("changes", Map.of("learning_events", many)), token);
        assertThat(tooMany.status()).isEqualTo(413);
        assertThat(problemCode(tooMany)).isEqualTo("PAYLOAD_TOO_LARGE");
        assertThat(count("SELECT count(*) FROM learning_events")).isZero();

        String huge = "{\"changes\":{\"learning_events\":[]},\"pad\":\"" + "x".repeat(1_100_000) + "\"}";
        Response tooBig = call("POST", PUSH, huge, token);
        assertThat(tooBig.status()).isEqualTo(413);
        assertThat(problemCode(tooBig)).isEqualTo("PAYLOAD_TOO_LARGE");

        // Boyut bildirilmeden (parçalı aktarım) gelen büyük gövde de 413.
        HttpRequest chunked = HttpRequest.newBuilder(URI.create("http://localhost:" + port + PUSH))
                .header("Authorization", "Bearer " + token).header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofInputStream(() -> new java.io.ByteArrayInputStream(
                        huge.getBytes(java.nio.charset.StandardCharsets.UTF_8))))
                .build();
        HttpResponse<String> res = HttpClient.newHttpClient().send(chunked, HttpResponse.BodyHandlers.ofString());
        assertThat(res.statusCode()).isEqualTo(413);
        assertThat(res.body()).contains("PAYLOAD_TOO_LARGE");

        // Diğer uçların sınırı daha küçük (64 KiB).
        Response rate = call("POST", "/api/v1/review/rate", "{\"pad\":\"" + "x".repeat(70_000) + "\"}", token);
        assertThat(rate.status()).isEqualTo(413);
    }

    @Test
    void pushIsRateLimitedPerUser() {
        int original = properties.getSync().getPushPerHour();
        properties.getSync().setPushPerHour(2);
        try {
            String a = login("a@example.com").text("accessToken");
            String b = login("b@example.com").text("accessToken");
            for (int i = 0; i < 2; i++) {
                assertThat(call("POST", PUSH, push("learning_events", event(UUID.randomUUID(), "x")), a).status())
                        .isEqualTo(200);
            }
            Response limited = call("POST", PUSH, push("learning_events", event(UUID.randomUUID(), "x")), a);
            assertThat(limited.status()).isEqualTo(429);
            assertThat(problemCode(limited)).isEqualTo("RATE_LIMITED");
            assertThat(limited.headers()).containsKey("retry-after");
            // Sınır kullanıcı başına.
            assertThat(call("POST", PUSH, push("learning_events", event(UUID.randomUUID(), "x")), b).status())
                    .isEqualTo(200);
        } finally {
            properties.getSync().setPushPerHour(original);
        }
    }

    @Test
    void pendingDeletionBlocksSyncAndPurgeRemovesEverything() {
        String a = login("a@example.com").text("accessToken");
        String b = login("b@example.com").text("accessToken");
        Map<String, Object> all = fullPush();
        assertThat(call("POST", PUSH, all, a).status()).isEqualTo(200);
        assertThat(call("POST", PUSH, fullPush(), b).status()).isEqualTo(200);
        for (String t : TABLES) {
            assertThat(count("SELECT count(*) FROM " + t)).as(t).isEqualTo(2);
        }
        String userA = get("/api/v1/me", a).text("id");

        call("DELETE", "/api/v1/me", null, a);
        Response blocked = call("POST", PUSH, fullPush(), a);
        assertThat(blocked.status()).isEqualTo(403);
        assertThat(problemCode(blocked)).isEqualTo("ACCOUNT_PENDING_DELETION");

        clock.advance(Duration.ofDays(30));
        assertThat(purge.purgeDue()).isEqualTo(1);
        for (String t : TABLES) {
            assertThat(count("SELECT count(*) FROM " + t + " WHERE user_id = ?::uuid", userA)).as(t).isZero();
            assertThat(count("SELECT count(*) FROM " + t)).as(t + " (diğer kullanıcı)").isEqualTo(1);
        }
    }

    @Test
    void speechAttemptsCanBeCleared() {
        String a = login("a@example.com").text("accessToken");
        call("POST", PUSH, push("speech_attempts", speech(UUID.randomUUID()), speech(UUID.randomUUID())), a);
        assertThat(call("DELETE", "/api/v1/sync/speech-attempts", null, a).status()).isEqualTo(204);
        assertThat(call("DELETE", "/api/v1/sync/speech-attempts", null, a).status()).isEqualTo(204);
        assertThat(count("SELECT count(*) FROM speech_attempts")).isZero();
    }

    @Test
    void hiResetMarkerClearsHiRecordsOnServerAndPropagates() {
        String a = login("a@example.com").text("accessToken");
        UUID before = UUID.randomUUID();
        UUID after = UUID.randomUUID();
        Map<String, Object> laterEvent = event(after, "Later.");
        laterEvent.put("at", "2026-10-13T09:40:00Z");
        Map<String, Object> changes = new LinkedHashMap<>();
        changes.put("learning_events", List.of(event(before, "Can you hear me?"), laterEvent));
        changes.put("speech_attempts", List.of(speech(UUID.randomUUID())));
        changes.put("hi_records", List.of(
                row("kind", "bridge_task", "refId", "order-coffee", "status", "done", "updatedAt",
                        "2026-10-13T09:00:00Z"),
                row("kind", "topic_intro", "refId", "can_questions", "status", "seen", "updatedAt",
                        "2026-10-13T09:00:00Z"),
                row("kind", "hunt_done", "refId", "maya-shop", "status", "done", "updatedAt",
                        "2026-10-13T09:00:00Z")));
        assertThat(call("POST", PUSH, Map.of("changes", changes), a).status()).isEqualTo(200);
        long cursor = get("/api/v1/sync/pull?since=0&limit=500", a).body().path("nextSince").asLong();

        UUID marker = Uuids.v5(Uuids.SYNC_NAMESPACE, "hi_records:hi_reset|all");
        Response reset = call("POST", PUSH, push("hi_records", row("kind", "hi_reset", "refId", "all",
                "status", "cleared", "updatedAt", "2026-10-13T09:30:00Z")), a);
        assertThat(reset.status()).as(reset.raw()).isEqualTo(200);
        assertThat(reset.body().path("accepted").get(0).path("clientId").asString()).isEqualTo(marker.toString());
        // T'ye kadarki olay ve "Söyle" sonucu silindi; sonraki olay kaldı. Konu tanıtımı ve sahne avı kalır.
        assertThat(count("SELECT count(*) FROM learning_events")).isEqualTo(1);
        assertThat(count("SELECT count(*) FROM learning_events WHERE client_id = ?::uuid", after.toString()))
                .isEqualTo(1);
        assertThat(count("SELECT count(*) FROM speech_attempts")).isZero();
        assertThat(count("SELECT count(*) FROM hi_records WHERE kind = 'bridge_task' AND deleted")).isEqualTo(1);
        assertThat(count("SELECT count(*) FROM hi_records WHERE kind IN ('topic_intro', 'hunt_done') AND NOT deleted"))
                .isEqualTo(2);

        // Öteki cihaz: çekme işareti ve yan görevin silme işaretini getirir.
        JsonNode pulled = get("/api/v1/sync/pull?since=" + cursor, a).body().path("changes").path("hi_records");
        Set<String> kinds = new HashSet<>();
        pulled.forEach(r -> kinds.add(r.path("kind").asString() + ":" + r.path("deleted").asBoolean()));
        assertThat(kinds).containsExactlyInAnyOrder("hi_reset:false", "bridge_task:true");

        // İdempotent: aynı işaret yeniden gelirse değişiklik yok.
        Response again = call("POST", PUSH, push("hi_records", row("kind", "hi_reset", "refId", "all",
                "status", "cleared", "updatedAt", "2026-10-13T09:30:00Z")), a);
        assertThat(again.body().path("accepted").get(0).path("result").asString()).isEqualTo("UNCHANGED");
        assertThat(count("SELECT count(*) FROM learning_events")).isEqualTo(1);
    }

    @Test
    void mobileTopicSetSourceIsAccepted() {
        String a = login("a@example.com").text("accessToken");
        Response r = call("POST", PUSH, push("notebook_items", row("itemKey", "word|lamp", "kind", "word",
                "textEn", "lamp", "source", "topic_set", "createdAt", "2026-10-13T09:00:00Z",
                "updatedAt", "2026-10-13T09:00:00Z")), a);
        assertThat(r.status()).as(r.raw()).isEqualTo(200);
        assertThat(count("SELECT count(*) FROM notebook_items WHERE source = 'topic_set'")).isEqualTo(1);
    }

    @Test
    void pullUsesConstantStatementCount() {
        String a = login("a@example.com").text("accessToken");
        call("POST", PUSH, fullPush(), a);
        QueryCounter.reset();
        get("/api/v1/sync/pull?since=0&limit=500", a);
        long small = QueryCounter.count();

        List<Object> events = new ArrayList<>();
        for (int i = 0; i < 300; i++) {
            events.add(event(UUID.randomUUID(), "t" + i));
        }
        call("POST", PUSH, Map.of("changes", Map.of("learning_events", events)), a);
        QueryCounter.reset();
        Response big = get("/api/v1/sync/pull?since=0&limit=500", a);
        assertThat(big.body().path("changes").path("learning_events").size()).isEqualTo(301);
        assertThat(QueryCounter.count()).isEqualTo(small).isLessThanOrEqualTo(TABLES.length + 3);
    }

    @Test
    void migrationsAndSyncIndexesExist() {
        assertThat(count("SELECT count(*) FROM flyway_schema_history WHERE version IN ('3', '4', '5') AND success"))
                .isEqualTo(3);
        for (String index : new String[] {"usp_user_seq_ix", "rl_user_card_ix", "sa_user_seq_ix",
                "content_items_id_version_uk", "content_items_visible_ix", "le_user_seq_ix"}) {
            assertThat(count("SELECT count(*) FROM pg_indexes WHERE indexname = ?", index)).as(index).isEqualTo(1);
        }
        // Transkript kolonu hiçbir eşitleme tablosunda yok.
        assertThat(count("SELECT count(*) FROM information_schema.columns WHERE table_name = 'speech_attempts' "
                + "AND column_name ~ '(transcript|audio|text|confidence)'")).isZero();
    }

    /** Mobil Drift şema 4'teki 12 eşitlenen tablonun her birinden bir satır. */
    static Map<String, Object> fullPush() {
        UUID card = Uuids.v5(Uuids.SYNC_NAMESPACE, "review_cards:phrase|can you hear me?");
        Map<String, Object> changes = new LinkedHashMap<>();
        changes.put("user_story_progress", List.of(progress("A1-001", "COMPLETED", "2026-10-13T09:00:00Z")));
        changes.put("user_story_flags", List.of(row("contentId", "A1-002", "flag", "greet_tone", "value", "formal",
                "updatedAt", "2026-10-13T09:00:00Z")));
        changes.put("gate_progress", List.of(row("contentId", "A1-001", "itemKind", "comprehension", "nodeId",
                "t-gorev", "recordedAt", "2026-10-13T09:00:00Z")));
        changes.put("season_state", List.of(row("seasonId", 1, "introSeen", true, "introSeenAt",
                "2026-10-13T08:00:00Z", "updatedAt", "2026-10-13T08:00:00Z")));
        changes.put("clues", List.of(row("contentId", "A1-001", "clueId", "C1", "textTr", "Mesajdaki harf: E.",
                "textEn", null, "unlockedAt", "2026-10-13T09:00:00Z")));
        changes.put("story_links", List.of(row("contentId", "A1-001", "number", 1, "openQuestionId", "Q1",
                "openQuestionTr", "Mesajı kim gönderdi?", "answers", "[]", "partialNotes", "{}",
                "recordedAt", "2026-10-13T09:00:00Z")));
        changes.put("notebook_items", List.of(row("itemKey", "phrase|can you hear me?", "kind", "phrase",
                "textEn", "Can you hear me?", "textTr", "Beni duyabiliyor musun?", "contentId", "A1-001",
                "cueId", "s02-04", "audioPath", "segments/s02.mp4", "audioStart", 3.2, "audioEnd", 4.4,
                "source", "auto_target_phrase", "createdAt", "2026-10-13T09:00:00Z",
                "updatedAt", "2026-10-13T09:00:00Z")));
        changes.put("review_cards", List.of(row("itemKey", "phrase|can you hear me?", "state", 1, "step", null,
                "stability", null, "difficulty", null, "due", "2026-10-13T09:00:00Z", "reps", 0, "lapses", 0,
                "lastReview", null, "updatedAt", "2026-10-13T09:00:00Z")));
        changes.put("review_logs", List.of());
        changes.put("learning_events", List.of(event(UUID.randomUUID(), "Can you hear me?")));
        changes.put("hi_records", List.of(row("kind", "topic_intro", "refId", "can_questions", "status", "seen",
                "updatedAt", "2026-10-13T09:00:00Z")));
        changes.put("speech_attempts", List.of(speech(UUID.randomUUID())));
        // Bir de cevap (kartı yeniden hesaplatır).
        changes.put("review_logs", List.of(row("clientId", UUID.randomUUID().toString(), "cardClientId",
                card.toString(), "rating", 3, "reviewedAt", "2026-10-13T09:05:00Z", "taskType", "picture_choice",
                "correct", true, "dontKnow", false, "durationMs", 4200, "wasNew", true)));
        return Map.of("deviceId", "ios-test-1", "changes", changes);
    }

    private String statusA1() {
        return jdbc.queryForObject("SELECT status FROM user_story_progress WHERE content_id = 'A1-001'", String.class);
    }
}
