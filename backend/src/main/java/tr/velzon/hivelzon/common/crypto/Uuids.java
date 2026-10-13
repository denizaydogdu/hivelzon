package tr.velzon.hivelzon.common.crypto;

import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.UUID;

/** RFC 9562 UUIDv5 (SHA-1, ad tabanlı): aynı ad her yerde aynı kimliği verir. */
public final class Uuids {

    /**
     * hiVelzon eşitleme ad alanı. Doğal anahtarlı tabloların istemci kimliği:
     * {@code UUIDv5(SYNC_NAMESPACE, "<tablo>:<anahtar1>|<anahtar2>...")} (mobil H-038 aynısını hesaplar).
     */
    public static final UUID SYNC_NAMESPACE = UUID.fromString("6f1b8f1e-3c55-5d7a-9a43-6869566c7a6e");

    private Uuids() {
    }

    public static UUID v5(UUID namespace, String name) {
        try {
            MessageDigest sha1 = MessageDigest.getInstance("SHA-1");
            ByteBuffer ns = ByteBuffer.allocate(16);
            ns.putLong(namespace.getMostSignificantBits()).putLong(namespace.getLeastSignificantBits());
            sha1.update(ns.array());
            sha1.update(name.getBytes(StandardCharsets.UTF_8));
            byte[] hash = sha1.digest();
            hash[6] = (byte) ((hash[6] & 0x0f) | 0x50);
            hash[8] = (byte) ((hash[8] & 0x3f) | 0x80);
            ByteBuffer bb = ByteBuffer.wrap(hash, 0, 16);
            return new UUID(bb.getLong(), bb.getLong());
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException(e);
        }
    }
}
