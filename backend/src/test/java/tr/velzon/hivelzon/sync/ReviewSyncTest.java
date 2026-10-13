package tr.velzon.hivelzon.sync;

import static org.assertj.core.api.Assertions.assertThat;
import static tr.velzon.hivelzon.sync.SyncTest.PUSH;
import static tr.velzon.hivelzon.sync.SyncTest.push;
import static tr.velzon.hivelzon.sync.SyncTest.row;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.junit.jupiter.api.Test;

import tools.jackson.databind.JsonNode;
import tr.velzon.hivelzon.common.crypto.Uuids;
import tr.velzon.hivelzon.fsrs.FsrsCard;
import tr.velzon.hivelzon.fsrs.FsrsRating;
import tr.velzon.hivelzon.fsrs.FsrsScheduler;
import tr.velzon.hivelzon.support.IntegrationTest;

/**
 * Sunucu tarafı FSRS: çevrimiçi not ({@code /review/rate}), itmede yeniden hesaplama (cevaplar yetkili), iki
 * cihazın çevrimdışı tekrarlarının birleşmesi.
 */
class ReviewSyncTest extends IntegrationTest {

    static final String KEY = "phrase|can you hear me?";
    static final UUID CARD = Uuids.v5(Uuids.SYNC_NAMESPACE, "review_cards:" + KEY);
    static final Instant T0 = Instant.parse("2026-10-13T09:00:00Z");

    private String setup(String email) {
        String token = login(email).text("accessToken");
        Map<String, Object> changes = new LinkedHashMap<>();
        changes.put("notebook_items", List.of(row("itemKey", KEY, "kind", "phrase", "textEn", "Can you hear me?",
                "source", "auto_target_phrase", "createdAt", T0.toString(), "updatedAt", T0.toString())));
        changes.put("review_cards", List.of(newCard()));
        Response r = call("POST", PUSH, Map.of("changes", changes), token);
        assertThat(r.status()).as(r.raw()).isEqualTo(200);
        return token;
    }

    private static Map<String, Object> newCard() {
        return row("itemKey", KEY, "state", 1, "step", null, "stability", null, "difficulty", null,
                "due", T0.toString(), "reps", 0, "lapses", 0, "lastReview", null, "updatedAt", T0.toString());
    }

    private static Map<String, Object> log(UUID id, int rating, Instant at) {
        return row("clientId", id.toString(), "cardClientId", CARD.toString(), "rating", rating,
                "reviewedAt", at.toString(), "taskType", "picture_choice", "correct", rating > 1, "dontKnow",
                rating == 1, "durationMs", 3000, "wasNew", false);
    }

    @Test
    void rateComputesNextStateLikeTheReferenceAndIsIdempotent() {
        String token = setup("r@example.com");
        UUID logId = UUID.randomUUID();
        Map<String, Object> req = row("cardClientId", CARD.toString(), "rating", 1, "reviewedAt", T0.toString(),
                "clientId", logId.toString(), "taskType", "listen_choice", "correct", false, "dontKnow", true,
                "durationMs", 5100);
        Response first = call("POST", "/api/v1/review/rate", req, token);
        assertThat(first.status()).as(first.raw()).isEqualTo(200);
        assertThat(first.body().path("duplicate").asBoolean()).isFalse();

        FsrsScheduler s = FsrsScheduler.hivelzon();
        FsrsCard expected = s.review(FsrsCard.newCard(T0), FsrsRating.AGAIN, T0);
        JsonNode card = first.body().path("card");
        assertThat(card.path("state").asInt()).isEqualTo(expected.state().value());
        assertThat(card.path("step").asInt()).isEqualTo(expected.step());
        assertThat(card.path("stability").asDouble()).isEqualTo(expected.stability());
        assertThat(card.path("difficulty").asDouble()).isEqualTo(expected.difficulty());
        assertThat(Instant.parse(card.path("due").asString())).isEqualTo(expected.due());
        assertThat(card.path("reps").asInt()).isEqualTo(1);
        assertThat(jdbc.queryForObject("SELECT was_new FROM review_logs", Boolean.class)).isTrue();

        // Aynı istek tekrar: çift kayıt yok, kart değişmez.
        Response again = call("POST", "/api/v1/review/rate", req, token);
        assertThat(again.body().path("duplicate").asBoolean()).isTrue();
        assertThat(again.body().path("card")).isEqualTo(card);
        assertThat(count("SELECT count(*) FROM review_logs")).isEqualTo(1);

        // Oturum sonunda doğru (10 dk sonra) → ertesi güne.
        Instant t1 = expected.due();
        Response good = call("POST", "/api/v1/review/rate", row("cardClientId", CARD.toString(), "rating", 3,
                "reviewedAt", t1.toString()), token);
        FsrsCard expected2 = s.review(expected, FsrsRating.GOOD, t1);
        assertThat(Instant.parse(good.body().path("card").path("due").asString())).isEqualTo(expected2.due());
        assertThat(good.body().path("card").path("state").asInt()).isEqualTo(2);
        assertThat(good.body().path("card").path("step").isNull()).isTrue();
        assertThat(good.body().path("card").path("reps").asInt()).isEqualTo(2);
    }

    @Test
    void rateValidatesAndIsUserScoped() {
        String a = setup("a@example.com");
        String b = login("b@example.com").text("accessToken");
        Response other = call("POST", "/api/v1/review/rate", row("cardClientId", CARD.toString(), "rating", 3,
                "reviewedAt", T0.toString()), b);
        assertThat(other.status()).isEqualTo(404);
        assertThat(problemCode(other)).isEqualTo("NOT_FOUND");
        Response bad = call("POST", "/api/v1/review/rate", row("cardClientId", CARD.toString(), "rating", 5,
                "reviewedAt", T0.toString()), a);
        assertThat(problemCode(bad)).isEqualTo("VALIDATION_FAILED");
        Response future = call("POST", "/api/v1/review/rate", row("cardClientId", CARD.toString(), "rating", 3,
                "reviewedAt", "2030-01-01T00:00:00Z"), a);
        assertThat(problemCode(future)).isEqualTo("VALIDATION_FAILED");
        assertThat(count("SELECT count(*) FROM review_logs")).isZero();
    }

    @Test
    void pushRecomputesCardFromLogsAndReportsConflict() {
        String token = setup("r@example.com");
        Instant t1 = T0.plusSeconds(600);
        Map<String, Object> wrong = newCard();
        wrong.put("state", 2);
        wrong.put("stability", 99.0);
        wrong.put("difficulty", 5.0);
        wrong.put("reps", 2);
        wrong.put("lastReview", t1.toString());
        wrong.put("updatedAt", t1.toString());
        Map<String, Object> changes = new LinkedHashMap<>();
        changes.put("review_cards", List.of(wrong));
        changes.put("review_logs", List.of(log(UUID.randomUUID(), 1, T0), log(UUID.randomUUID(), 3, t1)));
        Response r = call("POST", PUSH, Map.of("changes", changes), token);
        assertThat(r.status()).as(r.raw()).isEqualTo(200);
        JsonNode conflict = r.body().path("conflicts").get(0);
        assertThat(conflict.path("table").asString()).isEqualTo("review_cards");
        assertThat(conflict.path("reason").asString()).isEqualTo("SERVER_RECOMPUTED");

        FsrsScheduler s = FsrsScheduler.hivelzon();
        FsrsCard c = s.review(s.review(FsrsCard.newCard(T0), FsrsRating.AGAIN, T0), FsrsRating.GOOD, t1);
        JsonNode server = conflict.path("serverRow");
        assertThat(server.path("stability").asDouble()).isEqualTo(c.stability());
        assertThat(Instant.parse(server.path("due").asString())).isEqualTo(c.due());
        assertThat(server.path("reps").asInt()).isEqualTo(2);

        // Doğru hesaplanmış durum gönderilirse çatışma yok.
        Map<String, Object> right = newCard();
        right.put("state", c.state().value());
        right.put("step", c.step());
        right.put("stability", c.stability());
        right.put("difficulty", c.difficulty());
        right.put("due", c.due().toString());
        right.put("reps", 2);
        right.put("lastReview", c.lastReview().toString());
        right.put("updatedAt", t1.plusSeconds(1).toString());
        Response ok = call("POST", PUSH, push("review_cards", right), token);
        assertThat(ok.body().path("conflicts").size()).isZero();
    }

    @Test
    void offlineReviewsFromTwoDevicesMerge() {
        String token = setup("r@example.com");
        FsrsScheduler s = FsrsScheduler.hivelzon();
        // Cihaz A: T0'da Good → kart review'a geçer.
        FsrsCard a = s.review(FsrsCard.newCard(T0), FsrsRating.GOOD, T0);
        call("POST", PUSH, push("review_logs", log(UUID.randomUUID(), 3, T0)), token);
        // Cihaz B (çevrimdışıydı): vadesinde Again; sunucu iki cevabı sırayla oynatır.
        Instant t2 = a.due();
        Response r = call("POST", PUSH, push("review_logs", log(UUID.randomUUID(), 1, t2)), token);
        FsrsCard merged = s.review(a, FsrsRating.AGAIN, t2);
        JsonNode server = r.body().path("conflicts").get(0).path("serverRow");
        assertThat(server.path("state").asInt()).isEqualTo(3); // relearning
        assertThat(server.path("reps").asInt()).isEqualTo(2);
        assertThat(server.path("lapses").asInt()).isEqualTo(1);
        assertThat(server.path("stability").asDouble()).isEqualTo(merged.stability());
        assertThat(Instant.parse(server.path("due").asString())).isEqualTo(merged.due());
        // Çekmede de güncel kart gelir.
        JsonNode pulled = get("/api/v1/sync/pull?since=0", token).body().path("changes").path("review_cards").get(0);
        assertThat(pulled.path("lapses").asInt()).isEqualTo(1);
    }
}
