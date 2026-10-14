package tr.velzon.hivelzon.audit;

/** Denetim kaydındaki eylem kodları. */
public enum AuditAction {
    OTP_START,
    OTP_VERIFY_SUCCESS,
    OTP_VERIFY_FAIL,
    OTP_LOCKED,
    RATE_LIMITED,
    SIGNUP,
    LOGIN,
    TOKEN_REUSE_DETECTED,
    /** Dönen yenileme belirteci hoşgörü penceresinde yeniden geldi; aynı halef verildi (H-056). */
    REFRESH_GRACE_REPLAY,
    LOGOUT,
    CONSENT_CHANGE,
    ACCOUNT_DELETION_REQUESTED,
    ACCOUNT_RESTORED,
    ACCOUNT_PURGED,
    CATALOG_IMPORT,
    /**
     * Editör geçişleri (H-041). {@code detail} = {@code <contentId>:v<sürüm>:<eski>><yeni>[:<ek>]}; ek yalnızca
     * sabit kod (kontrol listesi özetinin ilk 12 hanesi, yayın zamanı, kaldırma gerekçe kodu).
     */
    CONTENT_SUBMITTED,
    CONTENT_APPROVED,
    CONTENT_SCHEDULED,
    CONTENT_PUBLISHED,
    CONTENT_ARCHIVED,
    CONTENT_WITHDRAWN
}
