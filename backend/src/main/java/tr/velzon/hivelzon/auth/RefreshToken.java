package tr.velzon.hivelzon.auth;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/** Opak yenileme belirteci; yalnızca SHA-256 özeti tutulur. */
@Entity
@Table(name = "refresh_tokens")
public class RefreshToken {

    @Id
    private UUID id;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Column(name = "family_id", nullable = false)
    private UUID familyId;

    @Column(name = "token_hash", nullable = false, length = 64)
    private String tokenHash;

    @Column(name = "device_name", length = 64)
    private String deviceName;

    @Column(name = "auth_time", nullable = false)
    private Instant authTime;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @Column(name = "expires_at", nullable = false)
    private Instant expiresAt;

    @Column(name = "used_at")
    private Instant usedAt;

    @Column(name = "revoked_at")
    private Instant revokedAt;

    /** Dönmede üretilen halefin kimliği (H-056 hoşgörü penceresi). */
    @Column(name = "successor_id")
    private UUID successorId;

    /** Halef belirtecin şifreli değeri (AES-GCM, Base64); yalnızca hoşgörü penceresi boyunca dolu. */
    @Column(name = "successor_token_enc", length = 256)
    private String successorTokenEnc;

    protected RefreshToken() {
    }

    public RefreshToken(UUID userId, UUID familyId, String tokenHash, String deviceName, Instant authTime,
            Instant createdAt, Instant expiresAt) {
        this.id = UUID.randomUUID();
        this.userId = userId;
        this.familyId = familyId;
        this.tokenHash = tokenHash;
        this.deviceName = deviceName;
        this.authTime = authTime;
        this.createdAt = createdAt;
        this.expiresAt = expiresAt;
    }

    public void markUsed(Instant now) {
        this.usedAt = now;
    }

    /** Döndü: halef kaydedilir (hoşgörü penceresinde aynı halef yeniden verilebilsin). */
    public void markRotated(Instant now, UUID successorId, String successorTokenEnc) {
        this.usedAt = now;
        this.successorId = successorId;
        this.successorTokenEnc = successorTokenEnc;
    }

    public void clearSuccessorSecret() {
        this.successorTokenEnc = null;
    }

    public UUID getId() { return id; }
    public UUID getUserId() { return userId; }
    public UUID getFamilyId() { return familyId; }
    public String getDeviceName() { return deviceName; }
    public String getTokenHash() { return tokenHash; }
    public Instant getAuthTime() { return authTime; }
    public Instant getExpiresAt() { return expiresAt; }
    public Instant getUsedAt() { return usedAt; }
    public Instant getRevokedAt() { return revokedAt; }
    public UUID getSuccessorId() { return successorId; }
    public String getSuccessorTokenEnc() { return successorTokenEnc; }
}
