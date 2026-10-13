package tr.velzon.hivelzon.auth;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import tr.velzon.hivelzon.common.config.HivelzonProperties;

/** Süresi geçmiş kodları, eski hız sayaçlarını ve süresi dolmuş yenileme belirteçlerini ve penceresi geçmiş hoşgörü sırlarını (H-056) temizler (idempotent). */
@Component
public class AuthMaintenanceJob {

    private final OtpService otp;
    private final RateLimiter rateLimiter;
    private final TokenService tokens;
    private final HivelzonProperties properties;
    private final Clock clock;

    public AuthMaintenanceJob(OtpService otp, RateLimiter rateLimiter, TokenService tokens,
            HivelzonProperties properties, Clock clock) {
        this.otp = otp;
        this.rateLimiter = rateLimiter;
        this.tokens = tokens;
        this.properties = properties;
        this.clock = clock;
    }

    @Scheduled(cron = "${hivelzon.jobs.cleanup-cron:0 */15 * * * *}", zone = "UTC")
    public void run() {
        Instant now = clock.instant();
        otp.deleteExpiredChallenges(now);
        rateLimiter.deleteOlderThan(now.minus(properties.getRateLimit().getWindow().multipliedBy(2)));
        tokens.deleteExpired(now.minus(Duration.ofDays(7)));
        tokens.purgeGraceSecrets(now);
    }
}
