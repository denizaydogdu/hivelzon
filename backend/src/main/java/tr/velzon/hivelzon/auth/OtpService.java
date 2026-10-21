package tr.velzon.hivelzon.auth;

import java.security.SecureRandom;
import java.sql.Timestamp;
import java.time.Clock;
import java.time.Instant;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.support.TransactionTemplate;

import tr.velzon.hivelzon.audit.AuditAction;
import tr.velzon.hivelzon.audit.AuditService;
import tr.velzon.hivelzon.auth.AuthDtos.StartResponse;
import tr.velzon.hivelzon.auth.AuthDtos.TokenResponse;
import tr.velzon.hivelzon.auth.AuthDtos.VerifyRequest;
import tr.velzon.hivelzon.common.config.HivelzonProperties;
import tr.velzon.hivelzon.common.crypto.Hashing;
import tr.velzon.hivelzon.common.web.ApiException;
import tr.velzon.hivelzon.common.web.ErrorCode;
import tr.velzon.hivelzon.common.web.RequestContext;
import tr.velzon.hivelzon.consent.ConsentService;
import tr.velzon.hivelzon.user.Ages;
import tr.velzon.hivelzon.user.User;
import tr.velzon.hivelzon.user.UserService;

/**
 * Parolasız giriş: e-postaya 6 haneli tek kullanımlık kod.
 * <ul>
 *   <li>Kod ve e-posta düz metin saklanmaz (HMAC-SHA256, sunucu anahtarıyla); kod 10 dk geçerli, en çok 5 deneme.</li>
 *   <li>Kod isteği hesabın var olup olmadığına bakmaz; cevap her zaman aynıdır (hesap varlığı sızmaz).</li>
 *   <li>Hız sınırı: e-posta başına ve IP başına (ayarlanabilir).</li>
 * </ul>
 */
@Service
public class OtpService {

    private static final SecureRandom RANDOM = new SecureRandom();

    private final JdbcTemplate jdbc;
    private final TransactionTemplate tx;
    private final Hashing hashing;
    private final RateLimiter rateLimiter;
    private final MailPort mail;
    private final AuditService audit;
    private final UserService users;
    private final ConsentService consents;
    private final TokenService tokens;
    private final Ages ages;
    private final HivelzonProperties properties;
    private final Clock clock;

    public OtpService(JdbcTemplate jdbc, TransactionTemplate tx, Hashing hashing, RateLimiter rateLimiter,
            MailPort mail, AuditService audit, UserService users, ConsentService consents, TokenService tokens,
            Ages ages, HivelzonProperties properties, Clock clock) {
        this.jdbc = jdbc;
        this.tx = tx;
        this.hashing = hashing;
        this.rateLimiter = rateLimiter;
        this.mail = mail;
        this.audit = audit;
        this.users = users;
        this.consents = consents;
        this.tokens = tokens;
        this.ages = ages;
        this.properties = properties;
        this.clock = clock;
    }

    public StartResponse start(String rawEmail, RequestContext ctx) {
        String email = EmailAddresses.normalise(rawEmail);
        String emailKey = hashing.hmac("otp-email", email);
        HivelzonProperties.RateLimit limits = properties.getRateLimit();
        try {
            rateLimiter.acquire("start:ip:" + ipKey(ctx), limits.getOtpStartPerIp());
            rateLimiter.acquire("start:email:" + emailKey, limits.getOtpStartPerEmail());
        } catch (ApiException e) {
            audit.record(AuditAction.RATE_LIMITED, null, ctx, "OTP_START");
            throw e;
        }
        String code = "%06d".formatted(RANDOM.nextInt(1_000_000));
        Instant now = clock.instant();
        Instant expires = now.plus(properties.getOtp().getTtl());
        tx.executeWithoutResult(status -> {
            jdbc.update("""
                    INSERT INTO otp_challenges (email_key, code_hash, attempts, created_at, expires_at)
                    VALUES (?, ?, 0, ?, ?)
                    ON CONFLICT (email_key) DO UPDATE
                       SET code_hash = EXCLUDED.code_hash, attempts = 0,
                           created_at = EXCLUDED.created_at, expires_at = EXCLUDED.expires_at""",
                    emailKey, codeHash(emailKey, code), Timestamp.from(now), Timestamp.from(expires));
            audit.record(AuditAction.OTP_START, null, ctx);
        });
        mail.sendLoginCode(email, code, properties.getOtp().getTtl());
        return new StartResponse((int) properties.getOtp().getTtl().toSeconds());
    }

    private sealed interface Outcome {
        record Success(TokenResponse tokens) implements Outcome { }
        record Failure(ErrorCode code) implements Outcome { }
    }

    private record Challenge(String codeHash, int attempts, Instant expiresAt) {
    }

    public TokenResponse verify(VerifyRequest request, RequestContext ctx) {
        try {
            rateLimiter.acquire("verify:ip:" + ipKey(ctx), properties.getRateLimit().getOtpVerifyPerIp());
        } catch (ApiException e) {
            audit.record(AuditAction.RATE_LIMITED, null, ctx, "OTP_VERIFY");
            throw e;
        }
        String email = EmailAddresses.normalise(request.email());
        String emailKey = hashing.hmac("otp-email", email);
        Outcome outcome = tx.execute(status -> verifyInTx(email, emailKey, request, ctx));
        if (outcome instanceof Outcome.Success success) {
            return success.tokens();
        }
        throw new ApiException(((Outcome.Failure) outcome).code());
    }

    private Outcome verifyInTx(String email, String emailKey, VerifyRequest request, RequestContext ctx) {
        Instant now = clock.instant();
        List<Challenge> rows = jdbc.query(
                "SELECT code_hash, attempts, expires_at FROM otp_challenges WHERE email_key = ? FOR UPDATE",
                (rs, i) -> new Challenge(rs.getString(1), rs.getInt(2), rs.getTimestamp(3).toInstant()),
                emailKey);
        if (rows.isEmpty()) {
            audit.record(AuditAction.OTP_VERIFY_FAIL, null, ctx, "NO_CHALLENGE");
            return new Outcome.Failure(ErrorCode.OTP_INVALID);
        }
        Challenge challenge = rows.get(0);
        int maxAttempts = properties.getOtp().getMaxAttempts();
        if (!challenge.expiresAt().isAfter(now)) {
            deleteChallenge(emailKey);
            audit.record(AuditAction.OTP_VERIFY_FAIL, null, ctx, "EXPIRED");
            return new Outcome.Failure(ErrorCode.OTP_EXPIRED);
        }
        if (challenge.attempts() >= maxAttempts) {
            deleteChallenge(emailKey);
            return new Outcome.Failure(ErrorCode.OTP_TOO_MANY_ATTEMPTS);
        }
        if (!Hashing.constantTimeEquals(challenge.codeHash(), codeHash(emailKey, request.code()))) {
            int attempts = challenge.attempts() + 1;
            if (attempts >= maxAttempts) {
                deleteChallenge(emailKey);
                audit.record(AuditAction.OTP_LOCKED, null, ctx);
                return new Outcome.Failure(ErrorCode.OTP_TOO_MANY_ATTEMPTS);
            }
            jdbc.update("UPDATE otp_challenges SET attempts = ? WHERE email_key = ?", attempts, emailKey);
            audit.record(AuditAction.OTP_VERIFY_FAIL, null, ctx, "WRONG_CODE");
            return new Outcome.Failure(ErrorCode.OTP_INVALID);
        }

        // Kod doğru: e-postanın sahibi kanıtlandı.
        User user = users.findByEmail(email).orElse(null);
        boolean newUser = user == null;
        if (newUser) {
            if (!request.hasSignupDetails()) {
                // Kod harcanmaz; istemci kayıt bilgileriyle aynı kodu yeniden gönderir.
                return new Outcome.Failure(ErrorCode.SIGNUP_DETAILS_REQUIRED);
            }
            int birthYear = request.birthYear();
            if (!ages.isValidBirthYear(birthYear)) {
                return new Outcome.Failure(ErrorCode.VALIDATION_FAILED);
            }
            if (!ages.isAllowed(birthYear)) {
                // 13 yaş altı: hesap açılmaz, kod silinir; denemeye dair hiçbir kayıt tutulmaz
                // (denetim satırı da yok; yalnızca hız sayaçları kalır).
                deleteChallenge(emailKey);
                return new Outcome.Failure(ErrorCode.AGE_NOT_ALLOWED);
            }
            // Onaylanan sürüm, uygulamanın gösterdiği sürümdür; güncelden eski olsa da kayıt durmaz (H-095).
            String displayName = request.displayName() == null ? null : request.displayName().trim();
            user = users.create(email, displayName == null || displayName.isEmpty() ? null : displayName,
                    birthYear);
            consents.recordSignup(user.getId(), request.termsVersion(), request.privacyNoticeVersion(),
                    request.marketing(), ctx);
        } else {
            users.markLogin(user.getId());
        }
        deleteChallenge(emailKey);
        audit.record(AuditAction.OTP_VERIFY_SUCCESS, user.getId(), ctx);
        audit.record(newUser ? AuditAction.SIGNUP : AuditAction.LOGIN, user.getId(), ctx);
        return new Outcome.Success(tokens.issueNewSession(user, blankToNull(request.deviceName()), newUser));
    }

    private void deleteChallenge(String emailKey) {
        jdbc.update("DELETE FROM otp_challenges WHERE email_key = ?", emailKey);
    }

    private String codeHash(String emailKey, String code) {
        return hashing.hmac("otp-code", emailKey + ":" + code);
    }

    private String ipKey(RequestContext ctx) {
        return hashing.hmac("ip", String.valueOf(ctx.ip()));
    }

    private static String blankToNull(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }

    public int deleteExpiredChallenges(Instant now) {
        return jdbc.update("DELETE FROM otp_challenges WHERE expires_at < ?", Timestamp.from(now));
    }
}
