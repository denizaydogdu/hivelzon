package tr.velzon.hivelzon.user;

/** Roller. Kayıt her zaman USER verir; EDITOR/ADMIN elle atanır (veritabanında). EDITOR/ADMIN onay ekranını kullanır (H-041). */
public enum Role {
    USER,
    EDITOR,
    ADMIN
}
