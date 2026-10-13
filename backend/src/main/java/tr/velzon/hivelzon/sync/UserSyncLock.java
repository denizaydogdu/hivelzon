package tr.velzon.hivelzon.sync;

import java.util.UUID;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/**
 * Kullanıcı başına işlem kilidi (pg_advisory_xact_lock). Eşitleme satırlarına yazan her işlem (itme, tekrar
 * notu, "Söyle" silme) önce bunu alır; böylece bir kullanıcının satırlarında {@code seq} sırası işleme (commit)
 * sırasıyla aynıdır ve çekme imleci satır kaçırmaz. Kilit işlem bitince kendiliğinden bırakılır.
 */
@Component
public class UserSyncLock {

    private final JdbcTemplate jdbc;

    public UserSyncLock(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public void lock(UUID userId) {
        jdbc.query("SELECT pg_advisory_xact_lock(?)", rs -> null,
                userId.getMostSignificantBits() ^ userId.getLeastSignificantBits());
    }
}
