package tr.velzon.hivelzon.common;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.util.Base64;

import org.junit.jupiter.api.Test;
import org.springframework.mock.env.MockEnvironment;

import tr.velzon.hivelzon.common.config.HivelzonProperties;
import tr.velzon.hivelzon.common.config.SecretsValidator;

/** prod profilinde sır yoksa uygulama başlamaz; geliştirmede geçici anahtar üretilir. */
class SecretsValidatorTest {

    private static final String KEY_A = Base64.getEncoder().encodeToString(new byte[32]);
    private static final String KEY_B = Base64.getEncoder().encodeToString("b".repeat(32).getBytes());

    private static HivelzonProperties props(String jwt, String pepper) {
        HivelzonProperties p = new HivelzonProperties();
        p.getSecurity().setJwtSecret(jwt);
        p.getSecurity().setOtpPepper(pepper);
        return p;
    }

    private static MockEnvironment env(String... profiles) {
        MockEnvironment env = new MockEnvironment();
        env.setActiveProfiles(profiles);
        return env;
    }

    @Test
    void prodRefusesMissingSecrets() {
        assertThatThrownBy(() -> new SecretsValidator(props("", KEY_B), env("prod")))
                .isInstanceOf(IllegalStateException.class).hasMessageContaining("HIVELZON_JWT_SECRET");
        assertThatThrownBy(() -> new SecretsValidator(props(KEY_A, ""), env("prod")))
                .isInstanceOf(IllegalStateException.class).hasMessageContaining("HIVELZON_OTP_PEPPER");
    }

    @Test
    void shortOrInvalidOrEqualSecretsAreRejected() {
        String shortKey = Base64.getEncoder().encodeToString(new byte[16]);
        assertThatThrownBy(() -> new SecretsValidator(props(shortKey, KEY_B), env("prod")))
                .hasMessageContaining("32");
        assertThatThrownBy(() -> new SecretsValidator(props("%%%", KEY_B), env()))
                .hasMessageContaining("Base64");
        assertThatThrownBy(() -> new SecretsValidator(props(KEY_A, KEY_A), env("prod")))
                .hasMessageContaining("aynı olamaz");
    }

    @Test
    void devFallbackIsRandomPerStart() {
        SecretsValidator a = new SecretsValidator(props("", ""), env());
        SecretsValidator b = new SecretsValidator(props("", ""), env());
        assertThat(a.jwtKey()).hasSize(32).isNotEqualTo(b.jwtKey());
        assertThat(new SecretsValidator(props(KEY_A, KEY_B), env("prod")).jwtKey()).hasSize(32);
    }
}
