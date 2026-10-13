package tr.velzon.hivelzon.user;

import java.time.Clock;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.PageRequest;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.support.TransactionTemplate;

import tr.velzon.hivelzon.audit.AuditAction;
import tr.velzon.hivelzon.audit.AuditService;
import tr.velzon.hivelzon.common.web.RequestContext;

/**
 * 30 günlük pencere dolan hesapları kalıcı siler. Her hesap kendi işleminde silinir; yarıda kalan iş bir
 * sonraki çalışmada kaldığı yerden devam eder (idempotent). Kişisel veri silinir, denetim satırları
 * anonimleştirilerek kalır.
 */
@Service
public class AccountPurgeService {

    private static final Logger log = LoggerFactory.getLogger(AccountPurgeService.class);
    private static final int BATCH = 100;

    private final UserRepository users;
    private final List<UserDataPurger> purgers;
    private final AuditService audit;
    private final TransactionTemplate tx;
    private final Clock clock;

    public AccountPurgeService(UserRepository users, List<UserDataPurger> purgers, AuditService audit,
            TransactionTemplate tx, Clock clock) {
        this.users = users;
        this.purgers = purgers;
        this.audit = audit;
        this.tx = tx;
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
        audit.anonymiseActor(id);
        users.delete(user);
        users.flush();
        audit.record(AuditAction.ACCOUNT_PURGED, null, RequestContext.SYSTEM);
        return true;
    }
}
