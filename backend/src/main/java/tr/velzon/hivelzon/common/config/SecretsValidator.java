package tr.velzon.hivelzon.common.config;

import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Base64;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.env.Environment;
import org.springframework.core.env.Profiles;
import org.springframework.stereotype.Component;

/**
 * Sunucu sırlarını çözer ve doğrular.
 * <ul>
 *   <li>{@code prod} profilinde sır yoksa ya da 32 bayttan kısaysa uygulama <b>başlamaz</b>.</li>
 *   <li>Diğer profillerde sır yoksa her açılışta rastgele, yalnızca geliştirme için geçici bir anahtar üretilir
 *       (yeniden başlatınca eski oturumlar ve kodlar geçersiz olur). Repoda sabit anahtar yoktur.</li>
 * </ul>
 */
@Component
public class SecretsValidator {

    private static final Logger log = LoggerFactory.getLogger(SecretsValidator.class);
    private static final int MIN_BYTES = 32;

    private final byte[] jwtKey;
    private final byte[] pepper;

    public SecretsValidator(HivelzonProperties properties, Environment environment) {
        boolean prod = environment.acceptsProfiles(Profiles.of("prod"));
        this.jwtKey = resolve("HIVELZON_JWT_SECRET", properties.getSecurity().getJwtSecret(), prod);
        this.pepper = resolve("HIVELZON_OTP_PEPPER", properties.getSecurity().getOtpPepper(), prod);
        if (Arrays.equals(jwtKey, pepper)) {
            throw new IllegalStateException("HIVELZON_JWT_SECRET ve HIVELZON_OTP_PEPPER aynı olamaz.");
        }
    }

    private static byte[] resolve(String name, String value, boolean prod) {
        if (value == null || value.isBlank()) {
            if (prod) {
                throw new IllegalStateException(name + " tanımlı değil; prod profilinde uygulama başlatılmaz.");
            }
            log.warn("{} tanımlı değil: YALNIZCA GELİŞTİRME için geçici rastgele anahtar kullanılıyor.", name);
            byte[] random = new byte[MIN_BYTES];
            new SecureRandom().nextBytes(random);
            return random;
        }
        byte[] decoded;
        try {
            decoded = Base64.getDecoder().decode(value.trim());
        } catch (IllegalArgumentException e) {
            throw new IllegalStateException(name + " Base64 olmalı.");
        }
        if (decoded.length < MIN_BYTES) {
            throw new IllegalStateException(name + " en az " + MIN_BYTES + " bayt olmalı.");
        }
        return decoded;
    }

    public byte[] jwtKey() {
        return jwtKey.clone();
    }

    public byte[] pepper() {
        return pepper.clone();
    }
}
