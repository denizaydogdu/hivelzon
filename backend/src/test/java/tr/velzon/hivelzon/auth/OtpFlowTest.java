package tr.velzon.hivelzon.auth;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.Duration;
import java.util.LinkedHashMap;
import java.util.Map;

import org.junit.jupiter.api.Test;

import tr.velzon.hivelzon.support.IntegrationTest;

/** E-posta koduyla kayıt ve giriş, kod güvenliği, hız sınırı, 13 yaş altı. */
class OtpFlowTest extends IntegrationTest {

    private static final String EMAIL = "deniz@example.com";

    @Test
    void signupCreatesUserWithMinimalDataAndConsents() {
        assertThat(startOtp("  Deniz@Example.COM ").status()).isEqualTo(202);
        String code = mail.lastCodeFor(EMAIL);
        assertThat(code).matches("\\d{6}");

        // Hesap yok ve kayıt bilgisi gönderilmedi: kod harcanmaz.
        Response missing = verify(EMAIL, code, null);
        assertThat(missing.status()).isEqualTo(422);
        assertThat(problemCode(missing)).isEqualTo("SIGNUP_DETAILS_REQUIRED");

        Map<String, Object> signup = signup(2000);
        signup.put("displayName", "Deniz");
        Response ok = verify(EMAIL, code, signup);
        assertThat(ok.status()).isEqualTo(200);
        assertThat(ok.body().path("newUser").asBoolean()).isTrue();
        assertThat(ok.text("tokenType")).isEqualTo("Bearer");
        assertThat(ok.body().path("expiresIn").asLong()).isEqualTo(900);
        assertThat(ok.body().path("refreshExpiresIn").asLong()).isEqualTo(30L * 24 * 3600);
        assertThat(ok.text("accountStatus")).isEqualTo("ACTIVE");

        Response me = get("/api/v1/me", ok.text("accessToken"));
        assertThat(me.status()).isEqualTo(200);
        assertThat(me.text("email")).isEqualTo(EMAIL);
        assertThat(me.text("displayName")).isEqualTo("Deniz");
        assertThat(me.body().path("birthYear").asInt()).isEqualTo(2000);
        assertThat(me.text("ageBand")).isEqualTo("ADULT_18_PLUS");
        assertThat(me.text("role")).isEqualTo("USER");

        // Kod tek kullanımlık.
        assertThat(count("SELECT count(*) FROM otp_challenges")).isZero();
        assertThat(problemCode(verify(EMAIL, code, null))).isEqualTo("OTP_INVALID");
        // Rızalar: koşullar, aydınlatma, ticari ileti (varsayılan false).
        assertThat(count("SELECT count(*) FROM consents WHERE granted")).isEqualTo(2);
        assertThat(count("SELECT count(*) FROM consents WHERE consent_type = 'MARKETING' AND NOT granted"))
                .isEqualTo(1);
    }

    @Test
    void teenGetsTeenAgeBandAndDisplayNameIsOptional() {
        startOtp(EMAIL);
        Response ok = verify(EMAIL, mail.lastCodeFor(EMAIL), signup(2013)); // bu yıl 13
        assertThat(ok.status()).isEqualTo(200);
        Response me = get("/api/v1/me", ok.text("accessToken"));
        assertThat(me.text("ageBand")).isEqualTo("TEEN_13_17");
        assertThat(me.text("displayName")).isNull();
    }

    @Test
    void existingUserLogsInWithoutSignupDetails() {
        String firstId = get("/api/v1/me", login(EMAIL).text("accessToken")).text("id");
        clock.advance(Duration.ofMinutes(1));

        startOtp(EMAIL.toUpperCase());
        Response ok = verify(EMAIL, mail.lastCodeFor(EMAIL), null);
        assertThat(ok.status()).isEqualTo(200);
        assertThat(ok.body().path("newUser").asBoolean()).isFalse();
        assertThat(get("/api/v1/me", ok.text("accessToken")).text("id")).isEqualTo(firstId);
        assertThat(count("SELECT count(*) FROM users")).isEqualTo(1);
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'LOGIN'")).isEqualTo(1);
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'SIGNUP'")).isEqualTo(1);
    }

    @Test
    void startDoesNotRevealWhetherAccountExists() {
        login(EMAIL);
        Response known = startOtp(EMAIL);
        Response unknown = startOtp("yeni@example.com");
        assertThat(known.status()).isEqualTo(202);
        assertThat(unknown.status()).isEqualTo(202);
        assertThat(known.body()).isEqualTo(unknown.body());
        assertThat(known.body().path("codeValidSeconds").asInt()).isEqualTo(600);
        assertThat(mail.sent()).hasSize(3); // login + iki istek: ikisine de kod gider
    }

    @Test
    void challengeStoresNoPlainEmailOrCode() {
        startOtp(EMAIL);
        String code = mail.lastCodeFor(EMAIL);
        Map<String, Object> row = jdbc.queryForMap("SELECT * FROM otp_challenges");
        assertThat(row.toString()).doesNotContain(EMAIL).doesNotContain(code);
        assertThat((String) row.get("code_hash")).hasSize(64);
    }

    @Test
    void wrongCodeLocksAfterFiveAttempts() {
        login(EMAIL);
        startOtp(EMAIL);
        String code = mail.lastCodeFor(EMAIL);
        String wrong = code.equals("000000") ? "111111" : "000000";
        for (int i = 1; i <= 4; i++) {
            Response r = verify(EMAIL, wrong, null);
            assertThat(r.status()).isEqualTo(400);
            assertThat(problemCode(r)).as("deneme %d", i).isEqualTo("OTP_INVALID");
        }
        Response fifth = verify(EMAIL, wrong, null);
        assertThat(problemCode(fifth)).isEqualTo("OTP_TOO_MANY_ATTEMPTS");
        // Kilitten sonra doğru kod da işe yaramaz; yeni kod gerekir.
        assertThat(verify(EMAIL, code, null).status()).isEqualTo(400);
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'OTP_LOCKED'")).isEqualTo(1);

        startOtp(EMAIL);
        assertThat(verify(EMAIL, mail.lastCodeFor(EMAIL), null).status()).isEqualTo(200);
    }

    @Test
    void newCodeReplacesOldOne() {
        login(EMAIL);
        startOtp(EMAIL);
        String first = mail.lastCodeFor(EMAIL);
        startOtp(EMAIL);
        String second = mail.lastCodeFor(EMAIL);
        if (!first.equals(second)) {
            assertThat(problemCode(verify(EMAIL, first, null))).isEqualTo("OTP_INVALID");
        }
        assertThat(verify(EMAIL, second, null).status()).isEqualTo(200);
    }

    @Test
    void codeExpiresAfterTenMinutes() {
        login(EMAIL);
        startOtp(EMAIL);
        String code = mail.lastCodeFor(EMAIL);
        clock.advance(Duration.ofMinutes(10).plusSeconds(1));
        Response r = verify(EMAIL, code, null);
        assertThat(r.status()).isEqualTo(400);
        assertThat(problemCode(r)).isEqualTo("OTP_EXPIRED");
    }

    @Test
    void codeStillValidJustBeforeExpiry() {
        login(EMAIL);
        startOtp(EMAIL);
        String code = mail.lastCodeFor(EMAIL);
        clock.advance(Duration.ofMinutes(9).plusSeconds(59));
        assertThat(verify(EMAIL, code, null).status()).isEqualTo(200);
    }

    @Test
    void perEmailRateLimit() {
        for (int i = 0; i < 5; i++) {
            assertThat(startOtp(EMAIL).status()).isEqualTo(202);
        }
        Response limited = startOtp(EMAIL);
        assertThat(limited.status()).isEqualTo(429);
        assertThat(problemCode(limited)).isEqualTo("RATE_LIMITED");
        assertThat(Long.parseLong(limited.headers().get("retry-after"))).isBetween(1L, 3600L);
        assertThat(mail.sent()).hasSize(5);
        // Başka adres etkilenmez.
        assertThat(startOtp("baska@example.com").status()).isEqualTo(202);
        // Pencere geçince yeniden açılır.
        clock.advance(Duration.ofHours(1));
        assertThat(startOtp(EMAIL).status()).isEqualTo(202);
    }

    @Test
    void perIpRateLimit() {
        for (int i = 0; i < 20; i++) {
            assertThat(startOtp("kisi" + i + "@example.com").status()).isEqualTo(202);
        }
        Response limited = startOtp("kisi99@example.com");
        assertThat(limited.status()).isEqualTo(429);
        assertThat(problemCode(limited)).isEqualTo("RATE_LIMITED");
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'RATE_LIMITED'")).isEqualTo(1);
        // Sayaç anahtarları da düz IP/e-posta içermez.
        assertThat(jdbc.queryForList("SELECT bucket_key FROM rate_limit_buckets", String.class))
                .noneMatch(k -> k.contains("@") || k.contains("127.0.0.1"));
    }

    @Test
    void underThirteenIsRejectedAndNothingIsStored() {
        startOtp(EMAIL);
        int auditBefore = count("SELECT count(*) FROM audit_log");
        Response r = verify(EMAIL, mail.lastCodeFor(EMAIL), signup(2014)); // bu yıl 12
        assertThat(r.status()).isEqualTo(403);
        assertThat(problemCode(r)).isEqualTo("AGE_NOT_ALLOWED");
        assertThat(r.text("detail")).contains("13");
        assertThat(count("SELECT count(*) FROM users")).isZero();
        assertThat(count("SELECT count(*) FROM consents")).isZero();
        assertThat(count("SELECT count(*) FROM otp_challenges")).isZero();
        assertThat(count("SELECT count(*) FROM refresh_tokens")).isZero();
        assertThat(count("SELECT count(*) FROM audit_log")).isEqualTo(auditBefore);
    }

    @Test
    void invalidInputGivesValidationFailed() {
        Response badEmail = startOtp("not-an-email");
        assertThat(badEmail.status()).isEqualTo(400);
        assertThat(problemCode(badEmail)).isEqualTo("VALIDATION_FAILED");

        Response badJson = post("/api/v1/auth/email/start", "{nope");
        assertThat(problemCode(badJson)).isEqualTo("VALIDATION_FAILED");

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("email", EMAIL);
        body.put("code", "12ab56");
        assertThat(problemCode(post("/api/v1/auth/email/verify", body))).isEqualTo("VALIDATION_FAILED");

        startOtp(EMAIL);
        assertThat(problemCode(verify(EMAIL, mail.lastCodeFor(EMAIL), signup(1850)))).isEqualTo("VALIDATION_FAILED");
    }

    @Test
    void olderTermsVersionIsAcceptedAndRecorded() {
        // H-095: metin sürümü değişince yeniden onay yok; uygulamanın gösterdiği sürüm kaydedilir.
        startOtp(EMAIL);
        Map<String, Object> signup = signup(2000);
        signup.put("termsVersion", "eski-0");
        Response r = verify(EMAIL, mail.lastCodeFor(EMAIL), signup);
        assertThat(r.status()).isEqualTo(200);
        assertThat(count("SELECT count(*) FROM users")).isEqualTo(1);
        assertThat(count("SELECT count(*) FROM consents WHERE consent_type = 'TERMS' AND document_version = 'eski-0'"))
                .isEqualTo(1);
        assertThat(count("SELECT count(*) FROM consents WHERE consent_type = 'PRIVACY_NOTICE' "
                + "AND document_version = 'taslak-2'")).isEqualTo(1);
    }
}
