package tr.velzon.hivelzon.auth;

import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

import jakarta.persistence.LockModeType;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

public interface RefreshTokenRepository extends JpaRepository<RefreshToken, UUID> {

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select t from RefreshToken t where t.tokenHash = :hash")
    Optional<RefreshToken> findForUpdate(String hash);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("select t from RefreshToken t where t.id = :id")
    Optional<RefreshToken> findByIdForUpdate(UUID id);

    @Modifying(flushAutomatically = true, clearAutomatically = true)
    @Query("update RefreshToken t set t.revokedAt = :now where t.familyId = :familyId and t.revokedAt is null")
    int revokeFamily(UUID familyId, Instant now);

    /** Ailenin bütün hoşgörü sırlarını siler (iptal, yeniden kullanım). */
    @Modifying(flushAutomatically = true, clearAutomatically = true)
    @Query("update RefreshToken t set t.successorTokenEnc = null where t.familyId = :familyId "
            + "and t.successorTokenEnc is not null")
    int clearGraceSecrets(UUID familyId);

    /** Penceresi geçmiş hoşgörü sırları (bakım işi). */
    @Modifying
    @Query("update RefreshToken t set t.successorTokenEnc = null where t.successorTokenEnc is not null "
            + "and t.usedAt < :cutoff")
    int clearGraceSecretsUsedBefore(Instant cutoff);

    @Modifying(flushAutomatically = true, clearAutomatically = true)
    @Query("update RefreshToken t set t.revokedAt = :now, t.successorTokenEnc = null "
            + "where t.userId = :userId and t.revokedAt is null")
    int revokeAllForUser(UUID userId, Instant now);

    @Modifying
    @Query("delete from RefreshToken t where t.userId = :userId")
    int deleteByUser(UUID userId);

    @Modifying
    @Query("delete from RefreshToken t where t.expiresAt < :cutoff")
    int deleteExpiredBefore(Instant cutoff);
}
