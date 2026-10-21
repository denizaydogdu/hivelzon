package tr.velzon.hivelzon.user;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.Duration;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import tr.velzon.hivelzon.support.IntegrationTest;

/** Hesap silme: 30 gün PENDING_DELETION, kodla girişten sonra geri alma, süre dolunca kalıcı silme. */
class AccountDeletionTest extends IntegrationTest {

    private static final String EMAIL = "silme@example.com";

    @Autowired
    AccountPurgeService purge;

    @Autowired
    RecordRetentionJob retention;

    @Test
    void deleteMarksPendingRevokesSessionsAndIsIdempotent() {
        Response session = login(EMAIL);
        String access = session.text("accessToken");

        Response deleted = call("DELETE", "/api/v1/me", null, access);
        assertThat(deleted.status()).isEqualTo(202);
        assertThat(deleted.text("status")).isEqualTo("PENDING_DELETION");
        assertThat(deleted.text("scheduledPurgeAt")).isEqualTo("2026-11-12T10:00:00Z");

        clock.advance(Duration.ofMinutes(1));
        Response again = call("DELETE", "/api/v1/me", null, access);
        assertThat(again.status()).isEqualTo(202);
        assertThat(again.text("scheduledPurgeAt")).isEqualTo("2026-11-12T10:00:00Z");
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'ACCOUNT_DELETION_REQUESTED'")).isEqualTo(1);

        // Bütün yenileme belirteçleri iptal.
        assertThat(problemCode(refresh(session.text("refreshToken")))).isEqualTo("REFRESH_TOKEN_INVALID");
        assertThat(count("SELECT count(*) FROM refresh_tokens WHERE revoked_at IS NULL")).isZero();

        // /me durumu gösterir; diğer işlemler kapalı.
        assertThat(get("/api/v1/me", access).text("status")).isEqualTo("PENDING_DELETION");
        Response consents = get("/api/v1/me/consents", access);
        assertThat(consents.status()).isEqualTo(403);
        assertThat(problemCode(consents)).isEqualTo("ACCOUNT_PENDING_DELETION");
    }

    @Test
    void restoreNeedsFreshCodeLogin() {
        String oldAccess = login(EMAIL).text("accessToken");
        call("DELETE", "/api/v1/me", null, oldAccess);

        // Silmeden önce alınmış belirteçle geri alınamaz.
        Response stale = call("POST", "/api/v1/me/restore", null, oldAccess);
        assertThat(stale.status()).isEqualTo(403);
        assertThat(problemCode(stale)).isEqualTo("REAUTH_REQUIRED");

        clock.advance(Duration.ofDays(3));
        startOtp(EMAIL);
        Response relogin = verify(EMAIL, mail.lastCodeFor(EMAIL), null);
        assertThat(relogin.status()).isEqualTo(200);
        assertThat(relogin.text("accountStatus")).isEqualTo("PENDING_DELETION");
        assertThat(relogin.text("scheduledPurgeAt")).isEqualTo("2026-11-12T10:00:00Z");

        Response restored = call("POST", "/api/v1/me/restore", null, relogin.text("accessToken"));
        assertThat(restored.status()).isEqualTo(200);
        assertThat(restored.text("status")).isEqualTo("ACTIVE");
        assertThat(restored.text("scheduledPurgeAt")).isNull();
        assertThat(get("/api/v1/me/consents", relogin.text("accessToken")).status()).isEqualTo(200);
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'ACCOUNT_RESTORED'")).isEqualTo(1);

        // Geri alınmış hesap süre dolunca silinmez.
        clock.advance(Duration.ofDays(40));
        assertThat(purge.purgeDue()).isZero();
        assertThat(count("SELECT count(*) FROM users")).isEqualTo(1);
    }

    @Test
    void purgeAfterThirtyDaysDeletesPersonalDataKeepsConsentAndAuditProof() {
        String access = login(EMAIL).text("accessToken");
        String userId = get("/api/v1/me", access).text("id");
        login("kalan@example.com");
        call("DELETE", "/api/v1/me", null, access);

        clock.advance(Duration.ofDays(30).minusSeconds(1));
        assertThat(purge.purgeDue()).isZero();
        assertThat(count("SELECT count(*) FROM users")).isEqualTo(2);

        clock.advance(Duration.ofSeconds(1));
        assertThat(purge.purgeDue()).isEqualTo(1);
        assertThat(purge.purgeDue()).as("idempotent").isZero();

        assertThat(count("SELECT count(*) FROM users")).isEqualTo(1);
        assertThat(count("SELECT count(*) FROM users WHERE email = ?", EMAIL)).isZero();
        assertThat(count("SELECT count(*) FROM refresh_tokens WHERE user_id = ?::uuid", userId)).isZero();
        // H-095: rıza kayıtları (sürüm, saat, IP, port) ve denetim satırları ispat için kalır; eski kimlik
        // mezar taşıdır (e-posta, ad, doğum yılı silindi).
        assertThat(count("SELECT count(*) FROM consents WHERE user_id = ?::uuid AND document_version IS NOT NULL "
                + "AND created_at IS NOT NULL AND ip IS NOT NULL AND port IS NOT NULL", userId)).isEqualTo(3);
        assertThat(count("SELECT count(*) FROM account_tombstones WHERE user_id = ?::uuid "
                + "AND purged_at = '2026-11-12T10:00:00Z'", userId)).isEqualTo(1);
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'SIGNUP' AND actor_user_id = ?::uuid "
                + "AND ip IS NOT NULL AND port IS NOT NULL", userId)).isEqualTo(1);
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'ACCOUNT_PURGED'")).isEqualTo(1);
        // Diğer hesap etkilenmez.
        assertThat(count("SELECT count(*) FROM users WHERE email = 'kalan@example.com' AND status = 'ACTIVE'"))
                .isEqualTo(1);
        assertThat(count("SELECT count(*) FROM consents")).isEqualTo(6);

        // Eski erişim belirteci artık işe yaramaz; aynı e-posta yeniden kayıt olabilir.
        assertThat(problemCode(get("/api/v1/me", access))).isEqualTo("UNAUTHORIZED");
        startOtp(EMAIL);
        Response again = verify(EMAIL, mail.lastCodeFor(EMAIL), null);
        assertThat(problemCode(again)).isEqualTo("SIGNUP_DETAILS_REQUIRED");
    }

    @Test
    void retentionDeletesConsentsTwoYearsAfterPurgeAndAuditTwoYearsAfterEvent() {
        String access = login(EMAIL).text("accessToken");
        String userId = get("/api/v1/me", access).text("id");
        login("kalan@example.com");
        call("DELETE", "/api/v1/me", null, access);
        clock.advance(Duration.ofDays(30));
        assertThat(purge.purgeDue()).isEqualTo(1); // 2026-11-12T10:00Z
        // Etkin hesapta 2 yıl sonra olacak bir olay (silinmemeli).
        clock.advance(Duration.ofDays(400));
        String keptAccess = login("kalan@example.com").text("accessToken");
        assertThat(call("POST", "/api/v1/me/consents", java.util.Map.of("type", "MARKETING", "version", "taslak-1",
                "granted", true), keptAccess).status()).isEqualTo(201);

        // Silmeden 2 yıl geçmeden: hiçbir rıza silinmez; denetim satırları da olaydan 2 yıl dolmadan kalır.
        moveTo("2028-10-13T09:59:59Z");
        RecordRetentionJob.Result early = retention.run();
        assertThat(early.consents()).isZero();
        assertThat(early.auditRows()).isZero();
        assertThat(count("SELECT count(*) FROM consents WHERE user_id = ?::uuid", userId)).isEqualTo(3);

        // Olaydan 2 yıl sonra: 2026-10-13'teki denetim satırları silinir; silinen hesabın rızaları hâlâ kalır
        // (süre silinme anından, 2026-11-12'den sayılır).
        moveTo("2028-10-13T10:00:01Z");
        assertThat(retention.run().auditRows()).isPositive();
        assertThat(count("SELECT count(*) FROM audit_log WHERE at < '2026-10-14T00:00:00Z'")).isZero();
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'ACCOUNT_PURGED'")).isEqualTo(1);
        assertThat(count("SELECT count(*) FROM consents WHERE user_id = ?::uuid", userId)).isEqualTo(3);

        // Silinmeden 2 yıl sonra: rızalar ve mezar taşı silinir; etkin hesabın rızaları kalır.
        moveTo("2028-11-12T10:00:01Z");
        RecordRetentionJob.Result due = retention.run();
        assertThat(due.consents()).isEqualTo(3);
        assertThat(count("SELECT count(*) FROM consents WHERE user_id = ?::uuid", userId)).isZero();
        assertThat(count("SELECT count(*) FROM account_tombstones")).isZero();
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'ACCOUNT_PURGED'")).isZero();
        assertThat(count("SELECT count(*) FROM consents")).isEqualTo(4);
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'CONSENT_CHANGE'")).isEqualTo(1);

        // İdempotent.
        RecordRetentionJob.Result again = retention.run();
        assertThat(again.consents()).isZero();
        assertThat(again.auditRows()).isZero();
        assertThat(count("SELECT count(*) FROM consents")).isEqualTo(4);
    }

    private void moveTo(String iso) {
        clock.advance(Duration.between(clock.instant(), java.time.Instant.parse(iso)));
    }
}
