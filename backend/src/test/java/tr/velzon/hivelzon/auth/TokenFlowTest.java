package tr.velzon.hivelzon.auth;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.Duration;
import java.util.Map;

import org.junit.jupiter.api.Test;

import tr.velzon.hivelzon.support.IntegrationTest;

/** Erişim ve yenileme belirteçleri: dönme, yeniden kullanım tespiti, çıkış, süre. */
class TokenFlowTest extends IntegrationTest {

    private static final String EMAIL = "token@example.com";

    @Test
    void refreshRotatesToken() {
        Response session = login(EMAIL);
        String r1 = session.text("refreshToken");
        clock.advance(Duration.ofMinutes(1));

        Response rotated = refresh(r1);
        assertThat(rotated.status()).isEqualTo(200);
        String r2 = rotated.text("refreshToken");
        assertThat(r2).isNotEqualTo(r1);
        assertThat(rotated.text("accessToken")).isNotEqualTo(session.text("accessToken"));
        assertThat(get("/api/v1/me", rotated.text("accessToken")).status()).isEqualTo(200);
        // Belirteç düz metin saklanmaz.
        assertThat(jdbc.queryForList("SELECT token_hash FROM refresh_tokens", String.class))
                .doesNotContain(r1, r2).allMatch(h -> h.length() == 64);
        assertThat(refresh(r2).status()).isEqualTo(200);
    }

    @Test
    void reusedRefreshTokenRevokesWholeFamily() {
        Response session = login(EMAIL);
        String r1 = session.text("refreshToken");
        String r2 = refresh(r1).text("refreshToken");

        // Başka cihazdaki oturum (ayrı aile) etkilenmemeli.
        clock.advance(Duration.ofMinutes(1));
        String otherDevice = login(EMAIL).text("refreshToken");

        Response reuse = refresh(r1);
        assertThat(reuse.status()).isEqualTo(401);
        assertThat(problemCode(reuse)).isEqualTo("TOKEN_REUSED");
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'TOKEN_REUSE_DETECTED'")).isEqualTo(1);

        Response afterReuse = refresh(r2);
        assertThat(afterReuse.status()).isEqualTo(401);
        assertThat(problemCode(afterReuse)).isEqualTo("REFRESH_TOKEN_INVALID");

        assertThat(refresh(otherDevice).status()).isEqualTo(200);
    }

    @Test
    void logoutRevokesSessionAndIsIdempotent() {
        Response session = login(EMAIL);
        String r1 = session.text("refreshToken");
        Response out = post("/api/v1/auth/logout", Map.of("refreshToken", r1));
        assertThat(out.status()).isEqualTo(204);
        assertThat(post("/api/v1/auth/logout", Map.of("refreshToken", r1)).status()).isEqualTo(204);
        assertThat(post("/api/v1/auth/logout", Map.of("refreshToken", "bilinmeyen")).status()).isEqualTo(204);
        assertThat(problemCode(refresh(r1))).isEqualTo("REFRESH_TOKEN_INVALID");
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'LOGOUT'")).isEqualTo(1);
    }

    @Test
    void refreshTokenExpiresAfterThirtyDays() {
        String r1 = login(EMAIL).text("refreshToken");
        clock.advance(Duration.ofDays(30).plusSeconds(1));
        assertThat(problemCode(refresh(r1))).isEqualTo("REFRESH_TOKEN_INVALID");
    }

    @Test
    void accessTokenExpiresAfterFifteenMinutes() {
        Response session = login(EMAIL);
        String access = session.text("accessToken");
        clock.advance(Duration.ofMinutes(14));
        assertThat(get("/api/v1/me", access).status()).isEqualTo(200);
        clock.advance(Duration.ofMinutes(2));
        Response expired = get("/api/v1/me", access);
        assertThat(expired.status()).isEqualTo(401);
        assertThat(problemCode(expired)).isEqualTo("UNAUTHORIZED");

        // Süresi dolmuş erişim belirteci başlıkta olsa da yenileme çalışır.
        Response refreshed = call("POST", "/api/v1/auth/refresh",
                Map.of("refreshToken", session.text("refreshToken")), access);
        assertThat(refreshed.status()).isEqualTo(200);
    }

    @Test
    void protectedEndpointsNeedValidToken() {
        Response none = get("/api/v1/me", null);
        assertThat(none.status()).isEqualTo(401);
        assertThat(problemCode(none)).isEqualTo("UNAUTHORIZED");

        String access = login(EMAIL).text("accessToken");
        String tampered = access.substring(0, access.length() - 4) + "AAAA";
        assertThat(get("/api/v1/me", tampered).status()).isEqualTo(401);
        assertThat(get("/api/v1/me", "abc.def.ghi").status()).isEqualTo(401);
        assertThat(get("/api/v1/me/consents", null).status()).isEqualTo(401);
    }

    @Test
    void refreshIsRateLimitedPerIp() {
        // Ayar: 120/saat. Geçersiz belirteçler de sayılır (tahmin saldırısı).
        for (int i = 0; i < 120; i++) {
            assertThat(refresh("yok-" + i).status()).isEqualTo(401);
        }
        Response limited = refresh("yok-son");
        assertThat(limited.status()).isEqualTo(429);
        assertThat(problemCode(limited)).isEqualTo("RATE_LIMITED");
    }
}
