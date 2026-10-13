package tr.velzon.hivelzon.consent;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface ConsentRepository extends JpaRepository<Consent, Long> {

    /** Her türün en son satırı (güncel durum). İndeks: consents_user_type_at_ix. */
    @Query(value = """
            SELECT DISTINCT ON (consent_type) *
              FROM consents
             WHERE user_id = :userId
             ORDER BY consent_type, created_at DESC, id DESC""", nativeQuery = true)
    List<Consent> findLatestPerType(UUID userId);

    Page<Consent> findByUserId(UUID userId, Pageable pageable);
}
