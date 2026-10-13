package tr.velzon.hivelzon.common;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.Map;

import org.junit.jupiter.api.Test;

import tr.velzon.hivelzon.support.IntegrationTest;

/** RFC 9457 biçimi: application/problem+json, code, Türkçe detail, requestId; iç ayrıntı yok. */
class ProblemDetailTest extends IntegrationTest {

    @Test
    void problemHasStableShape() {
        Response r = post("/api/v1/auth/email/verify", Map.of("email", "yok@example.com", "code", "123456"));
        assertThat(r.status()).isEqualTo(400);
        assertThat(problemCode(r)).isEqualTo("OTP_INVALID");
        assertThat(r.text("type")).isEqualTo("urn:hivelzon:problem:OTP_INVALID");
        assertThat(r.text("title")).isEqualTo("OTP_INVALID");
        assertThat(r.body().path("status").asInt()).isEqualTo(400);
        assertThat(r.text("detail")).isEqualTo("Bu kod eşleşmedi. E-postandaki kodu bir daha kontrol et.");
        assertThat(r.text("instance")).isEqualTo("/api/v1/auth/email/verify");
        assertThat(r.text("requestId")).isEqualTo(r.headers().get("x-request-id"));
        // Detay e-postayı geri yansıtmaz.
        assertThat(r.raw()).doesNotContain("yok@example.com");
    }

    @Test
    void clientRequestIdIsKeptWhenSafe() {
        Response r = call("GET", "/api/v1/me", null, null);
        assertThat(problemCode(r)).isEqualTo("UNAUTHORIZED");
        assertThat(r.text("detail")).isEqualTo("Bu işlem için giriş yapman gerekiyor.");
    }

    @Test
    void unknownPathsAndMethods() {
        String access = login("problem@example.com").text("accessToken");
        Response notFound = get("/api/v1/yok", access);
        assertThat(notFound.status()).isEqualTo(404);
        assertThat(problemCode(notFound)).isEqualTo("NOT_FOUND");

        Response method = call("PUT", "/api/v1/me", Map.of("x", 1), access);
        assertThat(method.status()).isEqualTo(405);
        assertThat(problemCode(method)).isEqualTo("METHOD_NOT_ALLOWED");

        // /api dışı her şey kapalı.
        assertThat(get("/", null).status()).isEqualTo(401);
        // GET ile auth uçları açık değil (yalnızca POST).
        assertThat(get("/api/v1/auth/email/start", null).status()).isEqualTo(401);
    }
}
