package tr.velzon.hivelzon.catalog;

import java.time.Instant;

/**
 * İçerik durumları (K-05). Durum veritabanında yaşar ve yalnızca editör geçişleriyle değişir
 * ({@link EditorialService}); {@code APPROVED} denetimi backend'dedir, AI'ın yayın yetkisi yoktur.
 */
public enum ContentStatus {
    DRAFT,
    IN_REVIEW,
    APPROVED,
    SCHEDULED,
    PUBLISHED,
    ARCHIVED,
    WITHDRAWN;

    /** Editör onayından geçmiş durumlar (onay kaydı zorunlu). */
    public boolean requiresApproval() {
        return this == APPROVED || this == SCHEDULED || this == PUBLISHED;
    }

    /** İçe aktarma paketi ve lint özetini yalnızca bu durumlarda günceller; sonrası donmuştur. */
    public boolean isEditable() {
        return this == DRAFT || this == IN_REVIEW;
    }

    /** Açık katalogda görünür mü: PUBLISHED ya da (APPROVED/SCHEDULED ve yayın zamanı gelmiş). */
    public boolean isVisible(Instant publishAt, Instant now) {
        return this == PUBLISHED
                || ((this == APPROVED || this == SCHEDULED) && publishAt != null && !publishAt.isAfter(now));
    }
}
