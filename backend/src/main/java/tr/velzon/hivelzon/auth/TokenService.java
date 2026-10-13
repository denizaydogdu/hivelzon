package tr.velzon.hivelzon.auth;

import java.security.SecureRandom;
import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.util.Base64;
import java.util.List;
import java.util.UUID;

import org.springframework.context.event.EventListener;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.JwsHeader;
import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;

import tr.velzon.hivelzon.audit.AuditAction;
import tr.velzon.hivelzon.audit.AuditService;
import tr.velzon.hivelzon.auth.AuthDtos.TokenResponse;
import tr.velzon.hivelzon.common.config.HivelzonProperties;
import tr.velzon.hivelzon.common.crypto.Hashing;
import tr.velzon.hivelzon.common.security.CurrentUser;
import tr.velzon.hivelzon.common.web.ApiException;
import tr.velzon.hivelzon.common.web.ErrorCode;
import tr.velzon.hivelzon.common.web.RequestContext;
import tr.velzon.hivelzon.user.AccountDeletionRequestedEvent;
import tr.velzon.hivelzon.user.User;
import tr.velzon.hivelzon.user.UserDataPurger;
import tr.velzon.hivelzon.user.UserRepository;
import tr.velzon.hivelzon.user.UserStatus;

/**
 * Erişim belirteci: HS256 JWT, 15 dk. Yenileme belirteci: opak 256 bit, 30 gün, her kullanımda döner
 * (rotation). Kullanılmış bir yenileme belirteci tekrar gelirse bütün aile (cihaz oturumu) iptal edilir.
 * <p>
 * <b>Hoşgörü penceresi (H-056):</b> dönen belirteç {@code refresh-grace} (varsayılan 30 sn) içinde yeniden gelirse
 * (cevap ağda kayboldu, çift istek) aile iptal edilmez: yeni bir erişim belirteci ve <b>aynı</b> halef yenileme
 * belirteci döner ({@code REFRESH_GRACE_REPLAY} denetim satırı). Koşullar: aile iptal edilmemiş (çıkış, yeniden
 * kullanım), halef hâlâ geçerli (dönmemiş, iptal edilmemiş, süresi dolmamış). Halefin değeri eski satırda
 * {@link GraceSecretCipher} ile şifreli durur; pencere geçince bakım işi, aile iptalinde hemen silinir.
 * Pencere dışında eski davranış: yeniden kullanım tespiti.
 */
@Service
public class TokenService implements UserDataPurger {

    private static final SecureRandom RANDOM = new SecureRandom();

    private final JwtEncoder encoder;
    private final RefreshTokenRepository tokens;
    private final UserRepository users;
    private final AuditService audit;
    private final RateLimiter rateLimiter;
    private final Hashing hashing;
    private final HivelzonProperties properties;
    private final TransactionTemplate tx;
    private final Clock clock;
    private final GraceSecretCipher cipher;

    public TokenService(JwtEncoder encoder, RefreshTokenRepository tokens, UserRepository users, AuditService audit,
            RateLimiter rateLimiter, Hashing hashing, HivelzonProperties properties, TransactionTemplate tx,
            Clock clock, GraceSecretCipher cipher) {
        this.cipher = cipher;
        this.encoder = encoder;
        this.tokens = tokens;
        this.users = users;
        this.audit = audit;
        this.rateLimiter = rateLimiter;
        this.hashing = hashing;
        this.properties = properties;
        this.tx = tx;
        this.clock = clock;
    }

    /** Kodla girişten sonra yeni bir oturum ailesi başlatır. Çağıranın işlemi içinde çalışır. */
    @Transactional
    public TokenResponse issueNewSession(User user, String deviceName, boolean newUser) {
        Instant now = clock.instant();
        return issue(user, UUID.randomUUID(), deviceName, now, now, newUser);
    }

    private TokenResponse issue(User user, UUID familyId, String deviceName, Instant authTime, Instant now,
            boolean newUser) {
        return issueWithId(user, familyId, deviceName, authTime, now, newUser).response();
    }

    private record Issued(UUID refreshId, TokenResponse response) {
    }

    private Issued issueWithId(User user, UUID familyId, String deviceName, Instant authTime, Instant now,
            boolean newUser) {
        String raw = randomToken();
        Instant refreshExpires = now.plus(properties.getSecurity().getRefreshTokenTtl());
        RefreshToken saved = tokens.save(new RefreshToken(user.getId(), familyId, Hashing.sha256(raw), deviceName,
                authTime, now, refreshExpires));
        return new Issued(saved.getId(), response(user, familyId, authTime, now, raw, newUser));
    }

    /** Erişim belirteci + verilen yenileme belirteci. */
    private TokenResponse response(User user, UUID familyId, Instant authTime, Instant now, String raw,
            boolean newUser) {
        Instant accessExpires = now.plus(properties.getSecurity().getAccessTokenTtl());
        JwtClaimsSet claims = JwtClaimsSet.builder()
                .issuer(properties.getSecurity().getIssuer())
                .subject(user.getId().toString())
                .issuedAt(now)
                .expiresAt(accessExpires)
                .id(UUID.randomUUID().toString())
                .claim(CurrentUser.AUTH_TIME_CLAIM, authTime.getEpochSecond())
                .claim("sid", familyId.toString())
                .claim("roles", List.of(user.getRole().name()))
                .build();
        String access = encoder.encode(JwtEncoderParameters.from(JwsHeader.with(MacAlgorithm.HS256).build(), claims))
                .getTokenValue();
        return new TokenResponse("Bearer", access, properties.getSecurity().getAccessTokenTtl().toSeconds(), raw,
                properties.getSecurity().getRefreshTokenTtl().toSeconds(), newUser, user.getStatus(),
                user.getScheduledPurgeAt());
    }

    private sealed interface RefreshOutcome {
        record Issued(TokenResponse response) implements RefreshOutcome { }
        record Failed(ErrorCode code) implements RefreshOutcome { }
    }

    public TokenResponse refresh(String rawToken, RequestContext ctx) {
        rateLimiter.acquire("refresh:ip:" + hashing.hmac("ip", String.valueOf(ctx.ip())),
                properties.getRateLimit().getRefreshPerIp());
        RefreshOutcome outcome = tx.execute(status -> {
            Instant now = clock.instant();
            RefreshToken token = tokens.findForUpdate(Hashing.sha256(rawToken)).orElse(null);
            if (token == null) {
                return new RefreshOutcome.Failed(ErrorCode.REFRESH_TOKEN_INVALID);
            }
            if (token.getUsedAt() != null) {
                TokenResponse replay = graceReplay(token, now, ctx);
                if (replay != null) {
                    return new RefreshOutcome.Issued(replay);
                }
                // Kullanılmış belirteç yeniden geldi: çalınmış olabilir. Bütün aile iptal.
                tokens.revokeFamily(token.getFamilyId(), now);
                tokens.clearGraceSecrets(token.getFamilyId());
                audit.record(AuditAction.TOKEN_REUSE_DETECTED, token.getUserId(), ctx);
                return new RefreshOutcome.Failed(ErrorCode.TOKEN_REUSED);
            }
            if (token.getRevokedAt() != null || !token.getExpiresAt().isAfter(now)) {
                return new RefreshOutcome.Failed(ErrorCode.REFRESH_TOKEN_INVALID);
            }
            User user = users.findById(token.getUserId()).orElse(null);
            if (user == null || user.getStatus() == UserStatus.SUSPENDED) {
                return new RefreshOutcome.Failed(ErrorCode.REFRESH_TOKEN_INVALID);
            }
            Issued next = issueWithId(user, token.getFamilyId(), token.getDeviceName(), token.getAuthTime(), now,
                    false);
            // Halef yalnızca pencere açıksa saklanır (şifreli).
            String enc = !graceWindow().isZero()
                    ? cipher.encrypt(token.getId(), next.response().refreshToken()) : null;
            token.markRotated(now, next.refreshId(), enc);
            return new RefreshOutcome.Issued(next.response());
        });
        if (outcome instanceof RefreshOutcome.Issued issued) {
            return issued.response();
        }
        throw new ApiException(((RefreshOutcome.Failed) outcome).code());
    }

    private Duration graceWindow() {
        Duration d = properties.getSecurity().getRefreshGrace();
        return d == null || d.isNegative() ? Duration.ZERO : d;
    }

    /**
     * Hoşgörü: dönen belirteç pencere içinde yeniden geldiyse ve halef hâlâ geçerliyse aynı halef + yeni erişim
     * belirteci. Koşul sağlanmazsa {@code null} (çağıran yeniden kullanım tespitine geçer).
     */
    private TokenResponse graceReplay(RefreshToken token, Instant now, RequestContext ctx) {
        Duration window = graceWindow();
        if (window.isZero() || token.getRevokedAt() != null || token.getSuccessorTokenEnc() == null
                || token.getSuccessorId() == null || now.isAfter(token.getUsedAt().plus(window))) {
            return null;
        }
        RefreshToken successor = tokens.findByIdForUpdate(token.getSuccessorId()).orElse(null);
        if (successor == null || successor.getUsedAt() != null || successor.getRevokedAt() != null
                || !successor.getExpiresAt().isAfter(now)) {
            return null;
        }
        String raw = cipher.decrypt(token.getId(), token.getSuccessorTokenEnc());
        if (raw == null || !Hashing.constantTimeEquals(Hashing.sha256(raw), successor.getTokenHash())) {
            return null;
        }
        User user = users.findById(token.getUserId()).orElse(null);
        if (user == null || user.getStatus() == UserStatus.SUSPENDED) {
            return null;
        }
        audit.record(AuditAction.REFRESH_GRACE_REPLAY, token.getUserId(), ctx);
        return response(user, token.getFamilyId(), token.getAuthTime(), now, raw, false);
    }

    /** Bu cihaz oturumunu kapatır. Bilinmeyen belirteçte de sessizce başarılı döner (idempotent). */
    @Transactional
    public void logout(String rawToken, RequestContext ctx) {
        tokens.findForUpdate(Hashing.sha256(rawToken)).ifPresent(token -> {
            // Zaten kapalı oturumda tekrar çağrı: denetim satırı da tekrarlanmaz.
            tokens.clearGraceSecrets(token.getFamilyId());
            if (tokens.revokeFamily(token.getFamilyId(), clock.instant()) > 0) {
                audit.record(AuditAction.LOGOUT, token.getUserId(), ctx);
            }
        });
    }

    @EventListener
    public void onDeletionRequested(AccountDeletionRequestedEvent event) {
        tokens.revokeAllForUser(event.userId(), clock.instant());
    }

    @Override
    @Transactional
    public void purgeUserData(UUID userId) {
        tokens.deleteByUser(userId);
    }

    @Transactional
    public int deleteExpired(Instant cutoff) {
        return tokens.deleteExpiredBefore(cutoff);
    }

    /** Penceresi geçmiş hoşgörü sırlarını siler (bakım işi; idempotent). */
    @Transactional
    public int purgeGraceSecrets(Instant now) {
        return tokens.clearGraceSecretsUsedBefore(now.minus(graceWindow()));
    }

    private static String randomToken() {
        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
