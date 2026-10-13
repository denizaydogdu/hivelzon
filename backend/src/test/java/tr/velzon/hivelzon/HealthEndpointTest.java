package tr.velzon.hivelzon;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

import tr.velzon.hivelzon.support.IntegrationTest;

class HealthEndpointTest extends IntegrationTest {

    @Test
    void healthIsPublicAndUp() {
        Response response = call("GET", "/actuator/health", null, null);
        assertThat(response.status()).isEqualTo(200);
        assertThat(response.text("status")).isEqualTo("UP");
        assertThat(response.body().has("components")).isFalse();
    }

    @Test
    void otherActuatorEndpointsAreClosed() {
        for (String path : new String[] {"/actuator", "/actuator/env", "/actuator/beans", "/actuator/info"}) {
            Response response = call("GET", path, null, null);
            assertThat(response.status()).as(path).isEqualTo(401);
            assertThat(response.text("code")).isEqualTo("UNAUTHORIZED");
        }
    }

    @Test
    void flywayMigrationsApplied() {
        assertThat(count("SELECT count(*) FROM flyway_schema_history WHERE success")).isGreaterThanOrEqualTo(2);
        assertThat(count("SELECT count(*) FROM flyway_schema_history WHERE version = '2' AND success")).isEqualTo(1);
    }

    @Test
    void identityIndexesExist() {
        for (String index : new String[] {"users_email_uk", "refresh_tokens_hash_uk", "audit_log_at_ix",
                "consents_user_type_at_ix", "users_purge_due_ix", "otp_challenges_expires_ix"}) {
            assertThat(count("SELECT count(*) FROM pg_indexes WHERE indexname = ?", index)).as(index).isEqualTo(1);
        }
    }
}
