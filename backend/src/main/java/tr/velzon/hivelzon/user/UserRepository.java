package tr.velzon.hivelzon.user;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;

public interface UserRepository extends JpaRepository<User, UUID> {

    Optional<User> findByEmail(String email);

    /** Satırı kilitleyerek okur (silme, geri alma ve kalıcı silme yarışmasın). */
    @Lock(jakarta.persistence.LockModeType.PESSIMISTIC_WRITE)
    @Query("select u from User u where u.id = :id")
    Optional<User> findForUpdate(UUID id);

    @Query("select u.id from User u where u.status = tr.velzon.hivelzon.user.UserStatus.PENDING_DELETION "
            + "and u.scheduledPurgeAt <= :now order by u.scheduledPurgeAt")
    List<UUID> findPurgeDue(Instant now, Pageable pageable);
}
