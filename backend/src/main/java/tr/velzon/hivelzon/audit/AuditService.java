package tr.velzon.hivelzon.audit;

import java.sql.Timestamp;
import java.time.Clock;
import java.time.Instant;
import java.util.UUID;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import tr.velzon.hivelzon.common.web.RequestContext;

/**
 * Denetim kaydı (IP/port/saat). Kayda e-posta, kod, belirteç ya da serbest metin yazılmaz;
 * {@code detail} yalnızca sabit kodlar alır (ör. rıza türü).
 */
@Service
public class AuditService {

    private final JdbcTemplate jdbc;
    private final Clock clock;

    public AuditService(JdbcTemplate jdbc, Clock clock) {
        this.jdbc = jdbc;
        this.clock = clock;
    }

    @Transactional
    public void record(AuditAction action, UUID actor, RequestContext ctx, String detail) {
        RequestContext c = ctx == null ? RequestContext.SYSTEM : ctx;
        jdbc.update("""
                INSERT INTO audit_log (actor_user_id, action, at, ip, port, user_agent_hash, request_id, detail)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)""",
                actor, action.name(), Timestamp.from(clock.instant()), c.ip(), c.port(), c.userAgentHash(),
                c.requestId(), detail);
    }

    public void record(AuditAction action, UUID actor, RequestContext ctx) {
        record(action, actor, ctx, null);
    }

    /**
     * Saklama süresi (olay tarihinden 2 yıl, H-095) dolan satırlar. Hesap silinmiş olsa da satır bu süreye kadar
     * kalır. İçerik onay akışının satırları ({@code CONTENT_*}) editör geçmişi olduğu için silinmez; yalnızca
     * IP, port, tarayıcı özeti ve istek kimliği boşaltılır. Tekrar çağrı zararsızdır (idempotent).
     *
     * @return silinen satır sayısı
     */
    @Transactional
    public int applyRetention(Instant cutoff) {
        Timestamp at = Timestamp.from(cutoff);
        jdbc.update("""
                UPDATE audit_log SET ip = NULL, port = NULL, user_agent_hash = NULL, request_id = NULL
                 WHERE at < ? AND action LIKE 'CONTENT\\_%'
                   AND (ip IS NOT NULL OR port IS NOT NULL OR user_agent_hash IS NOT NULL OR request_id IS NOT NULL)""",
                at);
        return jdbc.update("DELETE FROM audit_log WHERE at < ? AND action NOT LIKE 'CONTENT\\_%'", at);
    }
}
