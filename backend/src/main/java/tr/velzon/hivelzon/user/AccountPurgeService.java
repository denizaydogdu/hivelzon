package tr.velzon.hivelzon.user;

import java.sql.Timestamp;
import java.time.Clock;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.PageRequest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.support.TransactionTemplate;

import tr.velzon.hivelzon.audit.AuditAction;
import tr.velzon.hivelzon.audit.AuditService;
import tr.velzon.hivelzon.common.web.RequestContext;

/**
 * 30 günlük pencere dolan hesapları kalıcı siler. Her hesap kendi işleminde silinir; yarıda kalan iş bir
 * sonraki çalışmada kaldığı yerden devam eder (idempotent). Kişisel veri silinir. Rıza kayıtları ve denetim
 * satırları (IP, port, saat) ispat için kalır (hukukçu cevabı 2026-10-21, H-095): hesabın eski kimliği
 * {@code account_tombstones}'a yazılır; süre dolunca {@link RecordRetentionJob} siler.
 */
@Service
public class AccountPurgeService {

    private static final Logger log = LoggerFactory.getLogger(AccountPurgeService.class);
    private static final int BATCH = 100;

    private final UserRepository users;
    private final List<UserDataPurger> purgers;
    private final AuditService audit;
    private final TransactionTemplate tx;
    private final JdbcTemplate jdbc;
    private final Clock clock;

    public AccountPurgeService(UserRepository users, List<UserDataPurger> purgers, AuditService audit,
            TransactionTemplate tx, JdbcTemplate jdbc, Clock clock) {
        this.users = users;
        this.purgers = purgers;
        this.audit = audit;
        this.tx = tx;
        this.jdbc = jdbc;
        this.clock = clock;
    }

    @Scheduled(cron = "${hivelzon.jobs.purge-cron:0 17 * * * *}", zone = "UTC")
    public void scheduledPurge() {
        int purged = purgeDue();
        if (purged > 0) {
            log.info("Kalıcı silinen hesap sayısı: {}", purged);
        }
    }

    public int purgeDue() {
        Instant now = clock.instant();
        int total = 0;
        while (true) {
            List<UUID> due = users.findPurgeDue(now, PageRequest.of(0, BATCH));
            if (due.isEmpty()) {
                return total;
            }
            for (UUID id : due) {
                if (Boolean.TRUE.equals(tx.execute(status -> purgeOne(id, now)))) {
                    total++;
                }
            }
            if (due.size() < BATCH) {
                return total;
            }
        }
    }

    private boolean purgeOne(UUID id, Instant now) {
        // Kilitle ve koşulu yeniden doğrula: bu arada geri alınmış olabilir.
        User user = users.findForUpdate(id).orElse(null);
        if (user == null || user.getStatus() != UserStatus.PENDING_DELETION
                || user.getScheduledPurgeAt().isAfter(now)) {
            return false;
        }
        purgers.forEach(p -> p.purgeUserData(id));
        // Rızalar ve denetim satırları silinmez: saklama süresi bu andan sayılır (H-095).
        jdbc.update("INSERT INTO account_tombstones (user_id, purged_at) VALUES (?, ?) ON CONFLICT DO NOTHING",
                id, Timestamp.from(now));
        users.delete(user);
        users.flush();
        audit.record(AuditAction.ACCOUNT_PURGED, null, RequestContext.SYSTEM);
        return true;
    }
}
