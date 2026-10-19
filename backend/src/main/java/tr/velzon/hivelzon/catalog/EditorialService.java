package tr.velzon.hivelzon.catalog;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Clock;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.HexFormat;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import tr.velzon.hivelzon.audit.AuditAction;
import tr.velzon.hivelzon.audit.AuditService;
import tr.velzon.hivelzon.common.web.ApiException;
import tr.velzon.hivelzon.common.web.ErrorCode;
import tr.velzon.hivelzon.common.web.RequestContext;
import tr.velzon.hivelzon.user.UserDataPurger;

/**
 * Editör geçişleri (H-041, K-05). Durum veritabanında yaşar; yalnızca EDITOR/ADMIN rolündeki bir insan
 * değiştirir (AI'ın yayın yetkisi yok). Geçişler:
 * <pre>
 * SUBMIT    DRAFT → IN_REVIEW
 * APPROVE   IN_REVIEW → APPROVED      (lint 0 hata + çeviri onaylı + kontrol listesinin bütün maddeleri)
 * SCHEDULE  APPROVED → SCHEDULED      (publishAt gelecekte; henüz yayına girmemiş SCHEDULED yeniden zamanlanabilir)
 * PUBLISH   APPROVED | SCHEDULED → PUBLISHED
 * ARCHIVE   PUBLISHED (ya da zamanı gelmiş APPROVED/SCHEDULED) → ARCHIVED
 * WITHDRAW  WITHDRAWN dışındaki her durum → WITHDRAWN (gerekçe kodu zorunlu)
 * </pre>
 * Zamanlanmış içeriğin yayına girmesi için iş gerekmez: katalog görünürlüğü {@code publish_at <= şimdi} ile
 * hesaplanır. Her geçiş iyimser kilitlidir ({@code lock_version}) ve denetim kaydına yazılır (kişisel veri yok).
 */
@Service
public class EditorialService implements UserDataPurger {

    /** Editör ekranında zamanlar bu bölgede gösterilir ve girilir; veritabanında UTC. */
    public static final ZoneId EDITOR_ZONE = ZoneId.of("Europe/Istanbul");
    private static final DateTimeFormatter AUDIT_TIME = DateTimeFormatter.ofPattern("yyyyMMdd'T'HHmmss'Z'")
            .withZone(ZoneOffset.UTC);

    public enum Action {
        SUBMIT, APPROVE, SCHEDULE, PUBLISH, ARCHIVE, WITHDRAW
    }

    public enum WithdrawReason {
        COPYRIGHT, CONTENT_ERROR, SAFETY, OTHER
    }

    /**
     * Onay kontrol listesi (şartname §7.2'nin maddeleri gruplanmış; K-34 kanon kontrolü dahil). Hepsi
     * {@code true} olmalı. Yalnızca sabit anahtarlar ve true/false saklanır. Kitaplar (H-070) hikâye kanonuna
     * bağlı değildir ({@code docs/KITAPLIK.md} §2): kitapta {@code canonChecked} istenmez ve saklanmaz.
     */
    public record Checklist(Boolean canonChecked, Boolean levelChecked, Boolean translationApproved,
            Boolean mediaChecked, Boolean rightsAndAiDisclosureChecked) {

        List<String> missing(ContentType type) {
            List<String> out = new ArrayList<>();
            // Kanon yalnız hikâye bölümüne bağlıdır: kitaplar (H-070) ve bağımsız reeller (H-094)
            // hikâye kanonuna bağlı değildir.
            if (type == ContentType.EPISODE && !Boolean.TRUE.equals(canonChecked)) {
                out.add("canonChecked");
            }
            if (!Boolean.TRUE.equals(levelChecked)) {
                out.add("levelChecked");
            }
            if (!Boolean.TRUE.equals(translationApproved)) {
                out.add("translationApproved");
            }
            if (!Boolean.TRUE.equals(mediaChecked)) {
                out.add("mediaChecked");
            }
            if (!Boolean.TRUE.equals(rightsAndAiDisclosureChecked)) {
                out.add("rightsAndAiDisclosureChecked");
            }
            return out;
        }

        /** Kanonik JSON (sabit sıra): saklanır ve özeti onay kaydına bağlanır. */
        String canonicalJson(ContentType type) {
            return "{" + (type == ContentType.EPISODE ? "\"canonChecked\":true," : "")
                    + "\"levelChecked\":true,\"translationApproved\":true,"
                    + "\"mediaChecked\":true,\"rightsAndAiDisclosureChecked\":true}";
        }
    }

    /**
     * Geçiş isteği. {@code expectedLockVersion} zorunlu (iyimser kilit). Zamanlamada {@code publishAt}
     * (ISO-8601, saat dilimli) ya da {@code publishAtLocal} ({@code 2026-10-15T12:00}, Europe/Istanbul).
     */
    public record TransitionRequest(String action, Long expectedLockVersion, Checklist checklist, String publishAt,
            String publishAtLocal, String reason) {
    }

    public record AdminItem(String contentType, String contentId, int contentVersion, String slug, Integer season,
            int number, String level, String title, String genre, String status, boolean visible, Instant publishAt, Integer lintErrors,
            Integer lintWarnings, Instant lintCheckedAt, String translationStatus, Instant importedAt,
            Instant statusChangedAt, Instant approvedAt, String checklistSha256, String withdrawReason,
            String manifestSha256, long lockVersion, List<String> allowedActions) {
    }

    public record HistoryEntry(String action, Instant at, String detail, String actor) {
    }

    public record AdminItemDetail(AdminItem item, List<HistoryEntry> history) {
    }

    private static final String COLUMNS = """
            content_type, content_id, content_version, slug, season, number, level, title, genre, status, publish_at, lint_errors,
            lint_warnings, lint_checked_at, translation_status, imported_at, status_changed_at, approved_at,
            checklist_sha256, withdraw_reason, manifest_sha256, lock_version
            """;

    private final JdbcTemplate jdbc;
    private final AuditService audit;
    private final Clock clock;

    public EditorialService(JdbcTemplate jdbc, AuditService audit, Clock clock) {
        this.jdbc = jdbc;
        this.audit = audit;
        this.clock = clock;
    }

    @Transactional(readOnly = true)
    public List<AdminItem> list(Integer season, String type) {
        Instant now = clock.instant();
        List<String> where = new ArrayList<>();
        List<Object> args = new ArrayList<>();
        if (type != null && !type.isBlank()) {
            ContentType t;
            try {
                t = ContentType.valueOf(type.trim().toUpperCase(Locale.ROOT));
            } catch (IllegalArgumentException e) {
                throw new ApiException(ErrorCode.VALIDATION_FAILED, Map.of("field", "type"));
            }
            where.add("content_type = ?");
            args.add(t.name());
        }
        if (season != null) {
            where.add("season = ?");
            args.add(season);
        }
        // Bölümler sezon + sıra; kitaplar (sezonsuz) sonra, seviye + K numarası.
        String sql = "SELECT " + COLUMNS + " FROM content_items"
                + (where.isEmpty() ? "" : " WHERE " + String.join(" AND ", where))
                + " ORDER BY content_type DESC, season, level, number, content_id, content_version DESC";
        return jdbc.query(sql, (rs, i) -> map(rs, now), args.toArray());
    }

    @Transactional(readOnly = true)
    public AdminItemDetail detail(String contentId, int version) {
        AdminItem item = load(contentId, version, false);
        return new AdminItemDetail(item, history(contentId, version));
    }

    @Transactional
    public AdminItemDetail transition(UUID actor, RequestContext ctx, String contentId, int version,
            TransitionRequest request) {
        if (request == null || request.action() == null || request.expectedLockVersion() == null) {
            throw new ApiException(ErrorCode.VALIDATION_FAILED);
        }
        Action action;
        try {
            action = Action.valueOf(request.action().trim().toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException e) {
            throw new ApiException(ErrorCode.VALIDATION_FAILED, Map.of("field", "action"));
        }
        Instant now = clock.instant();
        AdminItem item = load(contentId, version, true);
        if (item.lockVersion() != request.expectedLockVersion()) {
            throw new ApiException(ErrorCode.CONCURRENT_MODIFICATION,
                    Map.of("currentLockVersion", item.lockVersion()));
        }
        ContentStatus from = ContentStatus.valueOf(item.status());
        if (!allowed(from, item.publishAt(), now).contains(action)) {
            throw new ApiException(ErrorCode.INVALID_TRANSITION, Map.of("from", from.name(), "action", action.name()));
        }

        String base = "UPDATE content_items SET status = ?, status_changed_at = ?, status_changed_by = ?, "
                + "lock_version = lock_version + 1, updated_at = ?";
        String where = " WHERE content_id = ? AND content_version = ? AND lock_version = ?";
        OffsetDateTime at = utc(now);
        List<Object> args = new ArrayList<>();
        ContentStatus to;
        String extra = null;
        AuditAction auditAction;
        String set = "";
        switch (action) {
            case SUBMIT -> {
                to = ContentStatus.IN_REVIEW;
                auditAction = AuditAction.CONTENT_SUBMITTED;
            }
            case APPROVE -> {
                List<String> missing = new ArrayList<>();
                if (item.lintErrors() == null) {
                    missing.add("lintReport");
                } else if (item.lintErrors() > 0) {
                    missing.add("lintErrors");
                }
                if (item.translationStatus() != null && !"APPROVED".equals(item.translationStatus())) {
                    missing.add("translationFileApproved");
                }
                Checklist checklist = request.checklist();
                ContentType type = ContentType.valueOf(item.contentType());
                missing.addAll(checklist == null ? new Checklist(null, null, null, null, null).missing(type)
                        : checklist.missing(type));
                if (!missing.isEmpty()) {
                    throw new ApiException(ErrorCode.APPROVAL_REQUIREMENTS_NOT_MET, Map.of("missing", missing));
                }
                String json = checklist.canonicalJson(type);
                String sha = sha256(json);
                to = ContentStatus.APPROVED;
                auditAction = AuditAction.CONTENT_APPROVED;
                extra = "c=" + sha.substring(0, 12);
                set = ", approved_at = ?, approved_by = ?, approval_checklist = ?::jsonb, checklist_sha256 = ?, "
                        + "approved_manifest_sha256 = manifest_sha256";
                args.addAll(List.of(at, actor, json, sha));
            }
            case SCHEDULE -> {
                Instant publishAt = parsePublishAt(request);
                if (!publishAt.isAfter(now)) {
                    throw new ApiException(ErrorCode.VALIDATION_FAILED, Map.of("field", "publishAt"));
                }
                to = ContentStatus.SCHEDULED;
                auditAction = AuditAction.CONTENT_SCHEDULED;
                extra = AUDIT_TIME.format(publishAt);
                set = ", publish_at = ?";
                args.add(utc(publishAt));
            }
            case PUBLISH -> {
                to = ContentStatus.PUBLISHED;
                auditAction = AuditAction.CONTENT_PUBLISHED;
                // Zamanı gelmiş yayın tarihi korunur; yoksa ya da gelecekteyse şimdi.
                Instant publishAt = item.publishAt() != null && !item.publishAt().isAfter(now) ? item.publishAt() : now;
                set = ", publish_at = ?";
                args.add(utc(publishAt));
            }
            case ARCHIVE -> {
                to = ContentStatus.ARCHIVED;
                auditAction = AuditAction.CONTENT_ARCHIVED;
            }
            case WITHDRAW -> {
                WithdrawReason reason;
                try {
                    reason = WithdrawReason.valueOf(request.reason() == null ? "" : request.reason().trim()
                            .toUpperCase(Locale.ROOT));
                } catch (IllegalArgumentException e) {
                    throw new ApiException(ErrorCode.VALIDATION_FAILED, Map.of("field", "reason"));
                }
                to = ContentStatus.WITHDRAWN;
                auditAction = AuditAction.CONTENT_WITHDRAWN;
                extra = reason.name();
                set = ", withdraw_reason = ?";
                args.add(reason.name());
            }
            default -> throw new IllegalStateException();
        }
        List<Object> all = new ArrayList<>(List.of(to.name(), at, actor, at));
        all.addAll(args);
        all.addAll(List.of(contentId, version, item.lockVersion()));
        int n = jdbc.update(base + set + where, all.toArray());
        if (n != 1) {
            throw new ApiException(ErrorCode.CONCURRENT_MODIFICATION);
        }
        String detail = contentId + ":v" + version + ":" + from.name() + ">" + to.name()
                + (extra == null ? "" : ":" + extra);
        audit.record(auditAction, actor, ctx, detail);
        return detail(contentId, version);
    }

    /** Durum ve yayın zamanına göre izinli geçişler (ekrandaki düğmeler de buradan gelir). */
    static Set<Action> allowed(ContentStatus status, Instant publishAt, Instant now) {
        boolean due = publishAt != null && !publishAt.isAfter(now);
        EnumSet<Action> out = EnumSet.noneOf(Action.class);
        switch (status) {
            case DRAFT -> out.add(Action.SUBMIT);
            case IN_REVIEW -> out.add(Action.APPROVE);
            case APPROVED -> {
                if (!due) {
                    out.add(Action.SCHEDULE);
                }
                out.add(Action.PUBLISH);
            }
            case SCHEDULED -> {
                if (!due) {
                    out.add(Action.SCHEDULE);
                }
                out.add(Action.PUBLISH);
            }
            case PUBLISHED, ARCHIVED, WITHDRAWN -> {
                // aşağıda
            }
        }
        if (status == ContentStatus.PUBLISHED || ((status == ContentStatus.APPROVED
                || status == ContentStatus.SCHEDULED) && due)) {
            out.add(Action.ARCHIVE);
        }
        if (status != ContentStatus.WITHDRAWN) {
            out.add(Action.WITHDRAW);
        }
        return out;
    }

    /** Kalıcı hesap silmede editör kimliği içerik satırlarından silinir (denetim kaydı ayrıca anonimleşir). */
    @Override
    public void purgeUserData(UUID userId) {
        jdbc.update("UPDATE content_items SET status_changed_by = NULL WHERE status_changed_by = ?", userId);
        jdbc.update("UPDATE content_items SET approved_by = NULL WHERE approved_by = ?", userId);
    }

    // ------------------------------------------------------------------ yardımcılar

    private AdminItem load(String contentId, int version, boolean forUpdate) {
        if (ContentType.ofId(contentId) == null || version < 1) {
            throw new ApiException(ErrorCode.NOT_FOUND);
        }
        Instant now = clock.instant();
        List<AdminItem> rows = jdbc.query("SELECT " + COLUMNS + " FROM content_items WHERE content_id = ? "
                + "AND content_version = ?" + (forUpdate ? " FOR UPDATE" : ""), (rs, i) -> map(rs, now),
                contentId, version);
        if (rows.isEmpty()) {
            throw new ApiException(ErrorCode.NOT_FOUND);
        }
        return rows.get(0);
    }

    private List<HistoryEntry> history(String contentId, int version) {
        // contentId ve sürüm doğrulanmış biçimde: LIKE özel karakteri içermez.
        return jdbc.query("""
                SELECT a.action, a.at, a.detail, u.display_name, u.email
                  FROM audit_log a LEFT JOIN users u ON u.id = a.actor_user_id
                 WHERE a.action LIKE 'CONTENT\\_%' AND a.detail LIKE ?
                 ORDER BY a.at, a.id""",
                (rs, i) -> new HistoryEntry(rs.getString(1), rs.getObject(2, OffsetDateTime.class).toInstant(),
                        rs.getString(3), actorLabel(rs.getString(4), rs.getString(5))),
                contentId + ":v" + version + ":%");
    }

    /** Geçmişte kişi: görünen ad, yoksa maskelenmiş e-posta; silinmiş hesapta "silinmiş hesap". */
    static String actorLabel(String displayName, String email) {
        if (displayName != null && !displayName.isBlank()) {
            return displayName;
        }
        if (email == null) {
            return "silinmiş hesap";
        }
        int at = email.indexOf('@');
        if (at <= 0) {
            return "***";
        }
        return email.charAt(0) + "***" + email.substring(at);
    }

    private AdminItem map(ResultSet rs, Instant now) throws SQLException {
        ContentStatus status = ContentStatus.valueOf(rs.getString("status"));
        Instant publishAt = instant(rs, "publish_at");
        List<String> actions = allowed(status, publishAt, now).stream().map(Enum::name).toList();
        return new AdminItem(rs.getString("content_type"), rs.getString("content_id"), rs.getInt("content_version"),
                rs.getString("slug"), (Integer) rs.getObject("season"), rs.getInt("number"), rs.getString("level"),
                rs.getString("title"), rs.getString("genre"),
                status.name(), status.isVisible(publishAt, now), publishAt, (Integer) rs.getObject("lint_errors"),
                (Integer) rs.getObject("lint_warnings"), instant(rs, "lint_checked_at"),
                rs.getString("translation_status"), instant(rs, "imported_at"), instant(rs, "status_changed_at"),
                instant(rs, "approved_at"), rs.getString("checklist_sha256"), rs.getString("withdraw_reason"),
                rs.getString("manifest_sha256"), rs.getLong("lock_version"), actions);
    }

    private static Instant instant(ResultSet rs, String column) throws SQLException {
        OffsetDateTime t = rs.getObject(column, OffsetDateTime.class);
        return t == null ? null : t.toInstant();
    }

    private static Instant parsePublishAt(TransitionRequest request) {
        try {
            if (request.publishAt() != null && !request.publishAt().isBlank()) {
                return OffsetDateTime.parse(request.publishAt().trim()).toInstant();
            }
            if (request.publishAtLocal() != null && !request.publishAtLocal().isBlank()) {
                return LocalDateTime.parse(request.publishAtLocal().trim()).atZone(EDITOR_ZONE).toInstant();
            }
        } catch (DateTimeParseException e) {
            // aşağıda
        }
        throw new ApiException(ErrorCode.VALIDATION_FAILED, Map.of("field", "publishAt"));
    }

    private static OffsetDateTime utc(Instant i) {
        return i == null ? null : i.atOffset(ZoneOffset.UTC);
    }

    private static String sha256(String s) {
        try {
            return HexFormat.of().formatHex(MessageDigest.getInstance("SHA-256").digest(s.getBytes(StandardCharsets.UTF_8)));
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException(e);
        }
    }
}
