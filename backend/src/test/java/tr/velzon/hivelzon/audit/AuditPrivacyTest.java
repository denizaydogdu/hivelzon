package tr.velzon.hivelzon.audit;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.logging.LogLevel;
import org.springframework.boot.logging.LoggingSystem;
import org.springframework.boot.test.system.CapturedOutput;
import org.springframework.boot.test.system.OutputCaptureExtension;

import tr.velzon.hivelzon.support.IntegrationTest;
import tr.velzon.hivelzon.user.AccountPurgeService;

/**
 * Bütün kimlik akışı boyunca: denetim kaydı beklenen eylemleri IP/port/saat/istek kimliğiyle tutar; ne denetim
 * kaydında ne de loglarda (DEBUG düzeyinde bile) e-posta, kod ya da belirteç görünür.
 */
@ExtendWith(OutputCaptureExtension.class)
class AuditPrivacyTest extends IntegrationTest {

    private static final String EMAIL = "gizli.kisi@example.com";
    private static final String[] VERBOSE = {"tr.velzon", "org.springframework.web", "org.springframework.security"};

    @Autowired
    AccountPurgeService purge;

    @Autowired
    LoggingSystem logging;

    @BeforeEach
    void verbose() {
        for (String logger : VERBOSE) {
            logging.setLogLevel(logger, LogLevel.DEBUG);
        }
    }

    @AfterEach
    void quiet() {
        for (String logger : VERBOSE) {
            logging.setLogLevel(logger, null);
        }
    }

    @Test
    void fullFlowLeavesNoPersonalDataInAuditOrLogs(CapturedOutput output) {
        List<String> secrets = new ArrayList<>(List.of(EMAIL, "gizli.kisi"));

        startOtp(EMAIL);
        String firstCode = mail.lastCodeFor(EMAIL);
        secrets.add(firstCode);
        String wrong = firstCode.equals("000000") ? "999999" : "000000";
        verify(EMAIL, wrong, null);
        Map<String, Object> signup = signup(2001);
        signup.put("displayName", "Gizem");
        Response session = verify(EMAIL, firstCode, signup);
        assertThat(session.status()).isEqualTo(200);
        String access = session.text("accessToken");
        String refresh1 = session.text("refreshToken");
        secrets.addAll(List.of(access, refresh1, "Gizem"));

        clock.advance(Duration.ofMinutes(1));
        Response rotated = refresh(refresh1);
        secrets.add(rotated.text("refreshToken"));
        secrets.add(rotated.text("accessToken"));
        refresh(refresh1); // hoşgörü penceresinde: aynı halef (H-056)
        clock.advance(Duration.ofSeconds(31));
        refresh(refresh1); // pencere sonrası yeniden kullanım: aile iptal

        Response second = login(EMAIL);
        secrets.add(mail.lastCodeFor(EMAIL));
        secrets.add(second.text("refreshToken"));
        call("POST", "/api/v1/me/consents", Map.of("type", "MARKETING", "version", "taslak-1", "granted", true),
                second.text("accessToken"));
        post("/api/v1/auth/logout", Map.of("refreshToken", second.text("refreshToken")));

        Response third = login(EMAIL);
        secrets.add(mail.lastCodeFor(EMAIL));
        secrets.add(third.text("accessToken"));
        call("DELETE", "/api/v1/me", null, third.text("accessToken"));
        clock.advance(Duration.ofMinutes(1));
        Response fourth = login(EMAIL);
        secrets.add(mail.lastCodeFor(EMAIL));
        call("POST", "/api/v1/me/restore", null, fourth.text("accessToken"));
        call("DELETE", "/api/v1/me", null, fourth.text("accessToken"));
        clock.advance(Duration.ofDays(31));
        assertThat(purge.purgeDue()).isEqualTo(1);

        List<String> actions = jdbc.queryForList("SELECT DISTINCT action FROM audit_log", String.class);
        assertThat(actions).contains("OTP_START", "OTP_VERIFY_FAIL", "OTP_VERIFY_SUCCESS", "SIGNUP", "LOGIN",
                "TOKEN_REUSE_DETECTED", "REFRESH_GRACE_REPLAY", "CONSENT_CHANGE", "LOGOUT", "ACCOUNT_DELETION_REQUESTED",
                "ACCOUNT_RESTORED", "ACCOUNT_PURGED");

        String auditDump = jdbc.queryForList("SELECT * FROM audit_log").toString();
        String otherTables = jdbc.queryForList("SELECT * FROM rate_limit_buckets").toString()
                + jdbc.queryForList("SELECT * FROM otp_challenges").toString();
        String logs = output.getAll();
        assertThat(logs).as("DEBUG loglar yakalandı").contains("DEBUG");
        for (String secret : secrets) {
            assertThat(auditDump).as("audit_log").doesNotContain(secret);
            assertThat(otherTables).as("sayaç/kod tabloları").doesNotContain(secret);
            assertThat(logs).as("loglar").doesNotContain(secret);
        }
        // Kullanıcı-Ajanı düz metin tutulmaz (Java HttpClient varsayılanı).
        assertThat(auditDump).doesNotContain("Java-http-client");
    }

    @Test
    void auditRowsCarryIpPortTimeAndRequestId() {
        Response r = call("POST", "/api/v1/auth/email/start", Map.of("email", EMAIL), null);
        String requestId = r.headers().get("x-request-id");
        assertThat(requestId).isNotBlank();
        Map<String, Object> row = jdbc.queryForMap("SELECT * FROM audit_log WHERE action = 'OTP_START'");
        assertThat(row.get("actor_user_id")).isNull();
        assertThat(row.get("ip")).isEqualTo("127.0.0.1");
        assertThat((Integer) row.get("port")).isPositive();
        assertThat(row.get("request_id")).isEqualTo(requestId);
        assertThat(row.get("at").toString()).startsWith("2026-10-13");
        assertThat((String) row.get("user_agent_hash")).hasSize(64);
    }
}
