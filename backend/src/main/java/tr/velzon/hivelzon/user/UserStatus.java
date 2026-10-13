package tr.velzon.hivelzon.user;

/** Hesap durumu. Silinen hesap satırı kalıcı silmede tamamen kaldırılır (DELETED durumu yoktur). */
public enum UserStatus {
    ACTIVE,
    PENDING_DELETION,
    SUSPENDED
}
