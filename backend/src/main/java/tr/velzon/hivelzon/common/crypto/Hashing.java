package tr.velzon.hivelzon.common.crypto;

import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.util.HexFormat;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.stereotype.Component;

import tr.velzon.hivelzon.common.config.SecretsValidator;

/** HMAC-SHA256 (sunucu anahtarıyla) ve SHA-256 özetleri. Çıktı küçük harfli hex. */
@Component
public class Hashing {

    private final SecretKeySpec pepperKey;

    public Hashing(SecretsValidator secrets) {
        this.pepperKey = new SecretKeySpec(secrets.pepper(), "HmacSHA256");
    }

    /** Alan ayrımlı HMAC: aynı değer farklı amaçlarda farklı özet verir. */
    public String hmac(String domain, String value) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(pepperKey);
            mac.update(domain.getBytes(StandardCharsets.UTF_8));
            mac.update((byte) 0);
            return HexFormat.of().formatHex(mac.doFinal(value.getBytes(StandardCharsets.UTF_8)));
        } catch (GeneralSecurityException e) {
            throw new IllegalStateException("HMAC hesaplanamadı", e);
        }
    }

    /**
     * Alan ayrımlı türetilmiş anahtar (32 bayt): {@code HMAC(pepper, "key:" + domain)}. Aynı sır başka amaçla
     * kullanılan anahtarla çakışmaz.
     */
    public byte[] deriveKey(String domain) {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(pepperKey);
            return mac.doFinal(("key:" + domain).getBytes(StandardCharsets.UTF_8));
        } catch (GeneralSecurityException e) {
            throw new IllegalStateException("Anahtar türetilemedi", e);
        }
    }

    public static String sha256(String value) {
        try {
            return HexFormat.of().formatHex(
                    MessageDigest.getInstance("SHA-256").digest(value.getBytes(StandardCharsets.UTF_8)));
        } catch (GeneralSecurityException e) {
            throw new IllegalStateException("SHA-256 yok", e);
        }
    }

    /** Sabit süreli karşılaştırma. */
    public static boolean constantTimeEquals(String a, String b) {
        return MessageDigest.isEqual(a.getBytes(StandardCharsets.UTF_8), b.getBytes(StandardCharsets.UTF_8));
    }
}
