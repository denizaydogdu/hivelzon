package tr.velzon.hivelzon.auth;

import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.UUID;

import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.stereotype.Component;

import tr.velzon.hivelzon.common.crypto.Hashing;

/**
 * Hoşgörü penceresi (H-056) için halef yenileme belirtecinin şifrelenmesi: AES-256-GCM, her şifrelemede rastgele
 * 96 bit nonce; ek doğrulanan veri (AAD) eski belirtecin kimliğidir (şifreli değer başka satıra taşınamaz).
 * Anahtar {@code HIVELZON_OTP_PEPPER}'dan alan ayrımlı türetilir ({@link Hashing#deriveKey}); ayrı bir sır
 * gerekmez, prod'da pepper zaten zorunludur. Değer hiçbir yerde loglanmaz.
 */
@Component
class GraceSecretCipher {

    private static final SecureRandom RANDOM = new SecureRandom();
    private static final int NONCE_BYTES = 12;
    private static final int TAG_BITS = 128;

    private final SecretKeySpec key;

    GraceSecretCipher(Hashing hashing) {
        this.key = new SecretKeySpec(hashing.deriveKey("refresh-grace"), "AES");
    }

    String encrypt(UUID boundTo, String plain) {
        try {
            byte[] nonce = new byte[NONCE_BYTES];
            RANDOM.nextBytes(nonce);
            Cipher c = Cipher.getInstance("AES/GCM/NoPadding");
            c.init(Cipher.ENCRYPT_MODE, key, new GCMParameterSpec(TAG_BITS, nonce));
            c.updateAAD(boundTo.toString().getBytes(StandardCharsets.UTF_8));
            byte[] ct = c.doFinal(plain.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(ByteBuffer.allocate(nonce.length + ct.length).put(nonce)
                    .put(ct).array());
        } catch (GeneralSecurityException e) {
            throw new IllegalStateException("şifrelenemedi", e);
        }
    }

    /** Çözülemezse (anahtar değişti, bozuk) {@code null}. */
    String decrypt(UUID boundTo, String encoded) {
        try {
            byte[] all = Base64.getDecoder().decode(encoded);
            if (all.length <= NONCE_BYTES) {
                return null;
            }
            Cipher c = Cipher.getInstance("AES/GCM/NoPadding");
            c.init(Cipher.DECRYPT_MODE, key, new GCMParameterSpec(TAG_BITS, all, 0, NONCE_BYTES));
            c.updateAAD(boundTo.toString().getBytes(StandardCharsets.UTF_8));
            return new String(c.doFinal(all, NONCE_BYTES, all.length - NONCE_BYTES), StandardCharsets.UTF_8);
        } catch (GeneralSecurityException | IllegalArgumentException e) {
            return null;
        }
    }
}
