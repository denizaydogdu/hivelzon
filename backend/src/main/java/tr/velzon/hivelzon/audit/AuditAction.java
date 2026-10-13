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
    LOGOUT,
    CONSENT_CHANGE,
    ACCOUNT_DELETION_REQUESTED,
    ACCOUNT_RESTORED,
    ACCOUNT_PURGED
}
