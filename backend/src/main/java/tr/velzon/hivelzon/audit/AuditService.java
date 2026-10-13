package tr.velzon.hivelzon.audit;

import java.sql.Timestamp;
import java.time.Clock;
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

    /** Hesap kalıcı silinince: kullanıcıya bağlanan bütün alanlar boşaltılır, eylem ve saat kalır. */
    @Transactional
    public int anonymiseActor(UUID actor) {
        return jdbc.update("""
                UPDATE audit_log SET actor_user_id = NULL, ip = NULL, port = NULL, user_agent_hash = NULL,
                       request_id = NULL
                 WHERE actor_user_id = ?""", actor);
    }
}
