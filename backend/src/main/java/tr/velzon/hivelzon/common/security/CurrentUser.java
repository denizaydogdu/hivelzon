package tr.velzon.hivelzon.common.security;

import java.time.Instant;
import java.util.UUID;

import org.springframework.security.oauth2.jwt.Jwt;

import tr.velzon.hivelzon.common.web.ApiException;
import tr.velzon.hivelzon.common.web.ErrorCode;

/**
 * Erişim belirtecinden çıkan kimlik. {@code authTime}: kodla girişin yapıldığı an; yenilemede değişmez.
 */
public record CurrentUser(UUID id, Instant authTime) {

    public static final String AUTH_TIME_CLAIM = "auth_time";

    public static CurrentUser from(Jwt jwt) {
        if (jwt == null) {
            throw new ApiException(ErrorCode.UNAUTHORIZED);
        }
        try {
            Object authTime = jwt.getClaim(AUTH_TIME_CLAIM);
            Instant at = authTime instanceof Number n ? Instant.ofEpochSecond(n.longValue())
                    : authTime instanceof Instant i ? i : null;
            return new CurrentUser(UUID.fromString(jwt.getSubject()), at);
        } catch (IllegalArgumentException e) {
            throw new ApiException(ErrorCode.UNAUTHORIZED);
        }
    }
}
