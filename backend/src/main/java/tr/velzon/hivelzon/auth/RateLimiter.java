package tr.velzon.hivelzon.auth;

import java.sql.Timestamp;
import java.time.Clock;
import java.time.Duration;
import java.time.Instant;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import tr.velzon.hivelzon.common.config.HivelzonProperties;
import tr.velzon.hivelzon.common.web.ApiException;
import tr.velzon.hivelzon.common.web.ErrorCode;

/**
 * Veritabanında sabit pencereli sayaç (birden çok sunucuda da doğru çalışır). Sayaç tek SQL ifadesiyle
 * atomik artar; işlem kendi başına kaydedilir (çağıranın işlemi geri alınsa da sayaç kalır).
 */
@Component
public class RateLimiter {

    private final JdbcTemplate jdbc;
    private final Clock clock;
    private final Duration window;

    public RateLimiter(JdbcTemplate jdbc, Clock clock, HivelzonProperties properties) {
        this.jdbc = jdbc;
        this.clock = clock;
        this.window = properties.getRateLimit().getWindow();
    }

    /** Sınır aşıldıysa {@code RATE_LIMITED} (Retry-After ile) fırlatır. */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void acquire(String bucketKey, int limit) {
        Instant now = clock.instant();
        long windowSeconds = window.toSeconds();
        Instant windowStart = Instant.ofEpochSecond(Math.floorDiv(now.getEpochSecond(), windowSeconds) * windowSeconds);
        Integer hits = jdbc.queryForObject("""
                INSERT INTO rate_limit_buckets (bucket_key, window_start, hits) VALUES (?, ?, 1)
                ON CONFLICT (bucket_key, window_start) DO UPDATE SET hits = rate_limit_buckets.hits + 1
                RETURNING hits""", Integer.class, bucketKey, Timestamp.from(windowStart));
        if (hits != null && hits > limit) {
            throw new ApiException(ErrorCode.RATE_LIMITED, Duration.between(now, windowStart.plus(window)));
        }
    }

    @Transactional
    public int deleteOlderThan(Instant cutoff) {
        return jdbc.update("DELETE FROM rate_limit_buckets WHERE window_start < ?", Timestamp.from(cutoff));
    }
}
