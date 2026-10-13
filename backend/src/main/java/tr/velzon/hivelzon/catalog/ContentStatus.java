package tr.velzon.hivelzon.catalog;

import java.time.Instant;

/** İçerik durumları (K-05). {@code APPROVED} denetimi backend'dedir; AI'ın yayın yetkisi yoktur. */
public enum ContentStatus {
    DRAFT,
    IN_REVIEW,
    APPROVED,
    SCHEDULED,
    PUBLISHED,
    ARCHIVED,
    WITHDRAWN;

    /** Editör onayı gerektiren durumlar (içe aktarmada onay kanıtı aranır). */
    public boolean requiresApproval() {
        return this == APPROVED || this == SCHEDULED || this == PUBLISHED;
    }

    /** Açık katalogda görünür mü: PUBLISHED ya da (APPROVED/SCHEDULED ve yayın zamanı gelmiş). */
    public boolean isVisible(Instant publishAt, Instant now) {
        return this == PUBLISHED
                || ((this == APPROVED || this == SCHEDULED) && publishAt != null && !publishAt.isAfter(now));
    }
}
