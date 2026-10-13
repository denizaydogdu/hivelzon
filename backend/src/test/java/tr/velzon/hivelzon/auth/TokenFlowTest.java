package tr.velzon.hivelzon.auth;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.Duration;
import java.util.Map;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import tr.velzon.hivelzon.common.config.HivelzonProperties;
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
    // ------------------------------------------------------------ hoşgörü penceresi (H-056)

    @Autowired
    HivelzonProperties properties;

    @Autowired
    AuthMaintenanceJob maintenance;

    @AfterEach
    void restoreGrace() {
        properties.getSecurity().setRefreshGrace(Duration.ofSeconds(30));
    }

    @Test
    void replayWithinGraceReturnsSameSuccessor() {
        String r1 = login(EMAIL).text("refreshToken");
        Response first = refresh(r1);
        String r2 = first.text("refreshToken");
        clock.advance(Duration.ofSeconds(20));

        Response replay = refresh(r1);
        assertThat(replay.status()).as(replay.raw()).isEqualTo(200);
        assertThat(replay.text("refreshToken")).isEqualTo(r2);
        assertThat(get("/api/v1/me", replay.text("accessToken")).status()).isEqualTo(200);
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'REFRESH_GRACE_REPLAY'")).isEqualTo(1);
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'TOKEN_REUSE_DETECTED'")).isZero();
        // Şifreli halef düz metin değildir.
        assertThat(jdbc.queryForList("SELECT successor_token_enc FROM refresh_tokens "
                + "WHERE successor_token_enc IS NOT NULL", String.class)).hasSize(1).doesNotContain(r2);
        // Halef normal çalışır ve döner.
        Response next = refresh(r2);
        assertThat(next.status()).isEqualTo(200);
        assertThat(next.text("refreshToken")).isNotEqualTo(r2);
    }

    @Test
    void replayAfterGraceIsReuse() {
        String r1 = login(EMAIL).text("refreshToken");
        String r2 = refresh(r1).text("refreshToken");
        clock.advance(Duration.ofSeconds(31));

        Response reuse = refresh(r1);
        assertThat(reuse.status()).isEqualTo(401);
        assertThat(problemCode(reuse)).isEqualTo("TOKEN_REUSED");
        assertThat(problemCode(refresh(r2))).isEqualTo("REFRESH_TOKEN_INVALID");
        assertThat(count("SELECT count(*) FROM refresh_tokens WHERE successor_token_enc IS NOT NULL")).isZero();
    }

    @Test
    void graceDoesNotSurviveLogout() {
        String r1 = login(EMAIL).text("refreshToken");
        String r2 = refresh(r1).text("refreshToken");
        assertThat(post("/api/v1/auth/logout", Map.of("refreshToken", r2)).status()).isEqualTo(204);
        assertThat(count("SELECT count(*) FROM refresh_tokens WHERE successor_token_enc IS NOT NULL")).isZero();

        Response replay = refresh(r1);
        assertThat(replay.status()).isEqualTo(401);
        assertThat(problemCode(refresh(r2))).isEqualTo("REFRESH_TOKEN_INVALID");
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'REFRESH_GRACE_REPLAY'")).isZero();
    }

    @Test
    void replayAfterSuccessorRotatedIsReuse() {
        String r1 = login(EMAIL).text("refreshToken");
        String r2 = refresh(r1).text("refreshToken");
        String r3 = refresh(r2).text("refreshToken");

        Response reuse = refresh(r1);
        assertThat(problemCode(reuse)).isEqualTo("TOKEN_REUSED");
        assertThat(problemCode(refresh(r3))).isEqualTo("REFRESH_TOKEN_INVALID");
    }

    @Test
    void zeroWindowKeepsStrictReuseDetection() {
        properties.getSecurity().setRefreshGrace(Duration.ZERO);
        String r1 = login(EMAIL).text("refreshToken");
        String r2 = refresh(r1).text("refreshToken");
        assertThat(count("SELECT count(*) FROM refresh_tokens WHERE successor_token_enc IS NOT NULL")).isZero();

        assertThat(problemCode(refresh(r1))).isEqualTo("TOKEN_REUSED");
        assertThat(problemCode(refresh(r2))).isEqualTo("REFRESH_TOKEN_INVALID");
    }

    @Test
    void maintenancePurgesExpiredGraceSecrets() {
        String r1 = login(EMAIL).text("refreshToken");
        refresh(r1);
        maintenance.run();
        assertThat(count("SELECT count(*) FROM refresh_tokens WHERE successor_token_enc IS NOT NULL")).isEqualTo(1);
        clock.advance(Duration.ofSeconds(31));
        maintenance.run();
        assertThat(count("SELECT count(*) FROM refresh_tokens WHERE successor_token_enc IS NOT NULL")).isZero();
    }
}
