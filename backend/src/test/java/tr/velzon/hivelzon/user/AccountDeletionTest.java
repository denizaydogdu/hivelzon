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
    void purgeAfterThirtyDaysDeletesPersonalDataKeepsAnonymisedAudit() {
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
        assertThat(count("SELECT count(*) FROM consents WHERE user_id = ?::uuid", userId)).isZero();
        assertThat(count("SELECT count(*) FROM refresh_tokens WHERE user_id = ?::uuid", userId)).isZero();
        assertThat(count("SELECT count(*) FROM audit_log WHERE actor_user_id = ?::uuid", userId)).isZero();
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'SIGNUP' AND actor_user_id IS NULL "
                + "AND ip IS NULL AND port IS NULL AND user_agent_hash IS NULL")).isEqualTo(1);
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'ACCOUNT_PURGED'")).isEqualTo(1);
        // Diğer hesap etkilenmez.
        assertThat(count("SELECT count(*) FROM users WHERE email = 'kalan@example.com' AND status = 'ACTIVE'"))
                .isEqualTo(1);
        assertThat(count("SELECT count(*) FROM consents")).isEqualTo(3);

        // Eski erişim belirteci artık işe yaramaz; aynı e-posta yeniden kayıt olabilir.
        assertThat(problemCode(get("/api/v1/me", access))).isEqualTo("UNAUTHORIZED");
        startOtp(EMAIL);
        Response again = verify(EMAIL, mail.lastCodeFor(EMAIL), null);
        assertThat(problemCode(again)).isEqualTo("SIGNUP_DETAILS_REQUIRED");
    }
}
