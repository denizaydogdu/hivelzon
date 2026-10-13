package tr.velzon.hivelzon.consent;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.time.Duration;
import java.util.Map;

import org.junit.jupiter.api.Test;
import org.springframework.dao.DataAccessException;

import tr.velzon.hivelzon.support.IntegrationTest;

/** Rızalar: yalnızca ekleme (uygulama ve veritabanı düzeyinde), güncel durum, geçmiş, denetim. */
class ConsentFlowTest extends IntegrationTest {

    private static final String EMAIL = "riza@example.com";

    @Test
    void signupRecordsThreeConsentsWithMarketingOffByDefault() {
        String access = login(EMAIL).text("accessToken");
        Response current = get("/api/v1/me/consents", access);
        assertThat(current.status()).isEqualTo(200);
        assertThat(current.body().size()).isEqualTo(3);
        current.body().forEach(c -> {
            assertThat(c.path("version").asString()).isEqualTo("taslak-1");
            assertThat(c.path("upToDate").asBoolean()).isTrue();
            assertThat(c.path("granted").asBoolean()).isEqualTo(!"MARKETING".equals(c.path("type").asString()));
        });
        // IP ve port her satırda.
        assertThat(count("SELECT count(*) FROM consents WHERE ip IS NOT NULL AND port IS NOT NULL")).isEqualTo(3);
    }

    @Test
    void changingMarketingAppendsRowAndAudits() {
        String access = login(EMAIL).text("accessToken");
        clock.advance(Duration.ofMinutes(5));
        Response granted = call("POST", "/api/v1/me/consents",
                Map.of("type", "MARKETING", "version", "taslak-1", "granted", true), access);
        assertThat(granted.status()).isEqualTo(201);
        clock.advance(Duration.ofMinutes(5));
        Response withdrawn = call("POST", "/api/v1/me/consents",
                Map.of("type", "MARKETING", "version", "taslak-1", "granted", false), access);
        assertThat(withdrawn.status()).isEqualTo(201);

        assertThat(count("SELECT count(*) FROM consents WHERE consent_type = 'MARKETING'")).isEqualTo(3);
        Response current = get("/api/v1/me/consents", access);
        current.body().forEach(c -> {
            if ("MARKETING".equals(c.path("type").asString())) {
                assertThat(c.path("granted").asBoolean()).isFalse();
                assertThat(c.path("at").asString()).isEqualTo("2026-10-13T10:10:00Z");
            }
        });
        Response history = get("/api/v1/me/consents/history?size=2", access);
        assertThat(history.body().path("totalItems").asInt()).isEqualTo(5);
        assertThat(history.body().path("items").size()).isEqualTo(2);
        assertThat(history.body().path("items").get(0).path("granted").asBoolean()).isFalse();
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'CONSENT_CHANGE'")).isEqualTo(2);
    }

    @Test
    void termsCannotBeWithdrawnAndOutdatedVersionRejected() {
        String access = login(EMAIL).text("accessToken");
        Response withdraw = call("POST", "/api/v1/me/consents",
                Map.of("type", "TERMS", "version", "taslak-1", "granted", false), access);
        assertThat(withdraw.status()).isEqualTo(400);
        assertThat(problemCode(withdraw)).isEqualTo("VALIDATION_FAILED");

        Response outdated = call("POST", "/api/v1/me/consents",
                Map.of("type", "MARKETING", "version", "eski-0", "granted", true), access);
        assertThat(outdated.status()).isEqualTo(409);
        assertThat(problemCode(outdated)).isEqualTo("CONSENT_VERSION_OUTDATED");

        Response unknownType = call("POST", "/api/v1/me/consents",
                Map.of("type", "NEWSLETTER", "version", "taslak-1", "granted", true), access);
        assertThat(problemCode(unknownType)).isEqualTo("VALIDATION_FAILED");
        assertThat(count("SELECT count(*) FROM consents")).isEqualTo(3);
    }

    @Test
    void databaseRejectsUpdateDeleteAndTruncate() {
        login(EMAIL);
        assertThatThrownBy(() -> jdbc.update("UPDATE consents SET granted = NOT granted"))
                .isInstanceOf(DataAccessException.class).hasMessageContaining("append-only");
        assertThatThrownBy(() -> jdbc.update("DELETE FROM consents"))
                .isInstanceOf(DataAccessException.class).hasMessageContaining("append-only");
        assertThatThrownBy(() -> jdbc.execute("TRUNCATE consents CASCADE"))
                .isInstanceOf(DataAccessException.class).hasMessageContaining("append-only");
        assertThat(count("SELECT count(*) FROM consents")).isEqualTo(3);
    }
}
