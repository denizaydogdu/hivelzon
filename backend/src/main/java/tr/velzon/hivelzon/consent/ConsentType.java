package tr.velzon.hivelzon.consent;

/**
 * Rıza türleri. {@code PRIVACY_NOTICE}: KVKK aydınlatma metninin okunduğunun kaydı (rıza değil, bilgilendirme).
 * {@code MARKETING}: ticari ileti izni; varsayılan yok.
 */
public enum ConsentType {
    TERMS,
    PRIVACY_NOTICE,
    MARKETING
}
