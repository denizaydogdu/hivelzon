package tr.velzon.hivelzon.consent;

import java.time.Clock;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Sort;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import tr.velzon.hivelzon.audit.AuditAction;
import tr.velzon.hivelzon.audit.AuditService;
import tr.velzon.hivelzon.common.config.HivelzonProperties;
import tr.velzon.hivelzon.common.web.ApiException;
import tr.velzon.hivelzon.common.web.ErrorCode;
import tr.velzon.hivelzon.common.web.PageParams;
import tr.velzon.hivelzon.common.web.PageResponse;
import tr.velzon.hivelzon.common.web.RequestContext;
import tr.velzon.hivelzon.consent.ConsentDtos.ConsentHistoryItem;
import tr.velzon.hivelzon.consent.ConsentDtos.ConsentRequest;
import tr.velzon.hivelzon.consent.ConsentDtos.ConsentState;
import tr.velzon.hivelzon.user.UserDataPurger;
import tr.velzon.hivelzon.user.UserService;

@Service
public class ConsentService implements UserDataPurger {

    private final ConsentRepository consents;
    private final UserService users;
    private final AuditService audit;
    private final HivelzonProperties properties;
    private final JdbcTemplate jdbc;
    private final Clock clock;

    public ConsentService(ConsentRepository consents, UserService users, AuditService audit,
            HivelzonProperties properties, JdbcTemplate jdbc, Clock clock) {
        this.consents = consents;
        this.users = users;
        this.audit = audit;
        this.properties = properties;
        this.jdbc = jdbc;
        this.clock = clock;
    }

    public String currentVersion(ConsentType type) {
        HivelzonProperties.Consent c = properties.getConsent();
        return switch (type) {
            case TERMS -> c.getTermsVersion();
            case PRIVACY_NOTICE -> c.getPrivacyNoticeVersion();
            case MARKETING -> c.getMarketingVersion();
        };
    }

    /** Kayıt anındaki rızalar (aynı işlem içinde). Sürümler önceden doğrulanmış olmalı. */
    @Transactional
    public void recordSignup(UUID userId, String termsVersion, String privacyVersion, Boolean marketing,
            RequestContext ctx) {
        Instant now = clock.instant();
        consents.save(new Consent(userId, ConsentType.TERMS, termsVersion, true, now, ctx.ip(), ctx.port()));
        consents.save(new Consent(userId, ConsentType.PRIVACY_NOTICE, privacyVersion, true, now, ctx.ip(),
                ctx.port()));
        // Ticari ileti izni varsayılan olarak verilmemiştir; açıkça "evet" denmedikçe false kaydedilir.
        consents.save(new Consent(userId, ConsentType.MARKETING, currentVersion(ConsentType.MARKETING),
                Boolean.TRUE.equals(marketing), now, ctx.ip(), ctx.port()));
    }

    @Transactional
    public List<ConsentState> record(UUID userId, ConsentRequest request, RequestContext ctx) {
        users.requireActive(userId);
        boolean granted = request.granted();
        if (!granted && request.type() != ConsentType.MARKETING) {
            // Kullanım koşulları ve aydınlatma geri çekilemez; bunun yolu hesap silmedir.
            throw new ApiException(ErrorCode.VALIDATION_FAILED);
        }
        String current = currentVersion(request.type());
        if (granted && !current.equals(request.version())) {
            throw new ApiException(ErrorCode.CONSENT_VERSION_OUTDATED);
        }
        consents.save(new Consent(userId, request.type(), current, granted, clock.instant(), ctx.ip(),
                ctx.port()));
        audit.record(AuditAction.CONSENT_CHANGE, userId, ctx, request.type().name() + (granted ? ":1" : ":0"));
        return currentState(userId);
    }

    @Transactional(readOnly = true)
    public List<ConsentState> current(UUID userId) {
        users.requireActive(userId);
        return currentState(userId);
    }

    private List<ConsentState> currentState(UUID userId) {
        List<ConsentState> result = new ArrayList<>();
        for (Consent c : consents.findLatestPerType(userId)) {
            String currentVersion = currentVersion(c.getType());
            result.add(new ConsentState(c.getType(), c.getDocumentVersion(), c.isGranted(), c.getCreatedAt(),
                    currentVersion, currentVersion.equals(c.getDocumentVersion())));
        }
        return result;
    }

    @Transactional(readOnly = true)
    public PageResponse<ConsentHistoryItem> history(UUID userId, Integer page, Integer size) {
        users.requireActive(userId);
        var pageable = PageParams.of(page, size, Sort.by(Sort.Order.desc("createdAt"), Sort.Order.desc("id")));
        return PageResponse.of(consents.findByUserId(userId, pageable),
                c -> new ConsentHistoryItem(c.getType(), c.getDocumentVersion(), c.isGranted(), c.getCreatedAt()));
    }

    /** Kalıcı silme: tetikleyici yalnızca bu işlem içinde silmeye izin verir. */
    @Override
    @Transactional
    public void purgeUserData(UUID userId) {
        jdbc.queryForObject("SELECT set_config('hivelzon.allow_consent_purge', 'on', true)", String.class);
        jdbc.update("DELETE FROM consents WHERE user_id = ?", userId);
        jdbc.queryForObject("SELECT set_config('hivelzon.allow_consent_purge', 'off', true)", String.class);
    }
}
