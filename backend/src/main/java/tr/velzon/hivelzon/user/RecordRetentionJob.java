package tr.velzon.hivelzon.user;

import java.time.Clock;
import java.time.Instant;
import java.time.Period;
import java.time.ZoneOffset;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import tr.velzon.hivelzon.audit.AuditService;
import tr.velzon.hivelzon.common.config.HivelzonProperties;
import tr.velzon.hivelzon.consent.ConsentService;

/**
 * Saklama süresi dolan rıza ve denetim kayıtlarını siler (H-095; hukukçu cevabı 2026-10-21: 2 yıl).
 * <ul>
 * <li>Rızalar: hesap kalıcı silindikten {@code hivelzon.retention.records} sonra (mezar taşıyla birlikte).
 * Etkin hesabın rızası güncel ispattır, silinmez.</li>
 * <li>Denetim satırları: olay tarihinden aynı süre sonra ({@link AuditService#applyRetention(Instant)}).</li>
 * </ul>
 * Süre takvimle sayılır (UTC; artık yıl dahil). İş idempotenttir; tekrar çalışması bir şey değiştirmez.
 */
@Component
public class RecordRetentionJob {

    private static final Logger log = LoggerFactory.getLogger(RecordRetentionJob.class);

    private final ConsentService consents;
    private final AuditService audit;
    private final HivelzonProperties properties;
    private final Clock clock;

    public RecordRetentionJob(ConsentService consents, AuditService audit, HivelzonProperties properties,
            Clock clock) {
        this.consents = consents;
        this.audit = audit;
        this.properties = properties;
        this.clock = clock;
    }

    @Scheduled(cron = "${hivelzon.jobs.retention-cron:0 41 3 * * *}", zone = "UTC")
    public void scheduledRun() {
        Result r = run();
        if (r.consents() > 0 || r.auditRows() > 0) {
            log.info("Saklama süresi dolan kayıtlar silindi: rıza {}, denetim {}", r.consents(), r.auditRows());
        }
    }

    public Result run() {
        Period keep = properties.getRetention().getRecords();
        if (keep == null || keep.isZero() || keep.isNegative()) {
            // Yanlış ayar her şeyi silmesin.
            log.warn("hivelzon.retention.records tanımsız ya da pozitif değil; temizlik atlandı");
            return new Result(0, 0);
        }
        Instant cutoff = clock.instant().atOffset(ZoneOffset.UTC).minus(keep).toInstant();
        int deletedConsents = consents.deleteRetainedBefore(cutoff);
        int deletedAudit = audit.applyRetention(cutoff);
        return new Result(deletedConsents, deletedAudit);
    }

    public record Result(int consents, int auditRows) {
    }
}
