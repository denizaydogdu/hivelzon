package tr.velzon.hivelzon.user;

import java.time.Clock;
import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import tr.velzon.hivelzon.audit.AuditAction;
import tr.velzon.hivelzon.audit.AuditService;
import tr.velzon.hivelzon.common.config.HivelzonProperties;
import tr.velzon.hivelzon.common.security.CurrentUser;
import tr.velzon.hivelzon.common.web.ApiException;
import tr.velzon.hivelzon.common.web.ErrorCode;
import tr.velzon.hivelzon.common.web.RequestContext;

@Service
public class UserService {

    private final UserRepository users;
    private final Ages ages;
    private final AuditService audit;
    private final ApplicationEventPublisher events;
    private final HivelzonProperties properties;
    private final Clock clock;

    public UserService(UserRepository users, Ages ages, AuditService audit, ApplicationEventPublisher events,
            HivelzonProperties properties, Clock clock) {
        this.users = users;
        this.ages = ages;
        this.audit = audit;
        this.events = events;
        this.properties = properties;
        this.clock = clock;
    }

    @Transactional(readOnly = true)
    public Optional<User> findByEmail(String normalisedEmail) {
        return users.findByEmail(normalisedEmail);
    }

    /** Yeni kullanıcı. Yaş kontrolü çağıran tarafta, kayıttan önce yapılır. */
    @Transactional
    public User create(String normalisedEmail, String displayName, int birthYear) {
        Instant now = clock.instant();
        User user = new User(UUID.randomUUID(), normalisedEmail, displayName, birthYear, now);
        user.markLogin(now);
        return users.save(user);
    }

    @Transactional
    public void markLogin(UUID userId) {
        users.findById(userId).ifPresent(u -> u.markLogin(clock.instant()));
    }

    @Transactional(readOnly = true)
    public MeResponse me(CurrentUser current) {
        return toResponse(load(current.id()));
    }

    /** Etkin hesap ister; silinmek üzere olan hesapta {@code ACCOUNT_PENDING_DELETION}. */
    @Transactional(readOnly = true)
    public User requireActive(UUID userId) {
        User user = load(userId);
        if (user.getStatus() == UserStatus.PENDING_DELETION) {
            throw new ApiException(ErrorCode.ACCOUNT_PENDING_DELETION);
        }
        if (user.getStatus() != UserStatus.ACTIVE) {
            throw new ApiException(ErrorCode.FORBIDDEN);
        }
        return user;
    }

    /** Hesap silme isteği: 30 gün geri alınabilir. Tekrar çağrı aynı tarihi döner (idempotent). */
    @Transactional
    public DeletionResponse requestDeletion(CurrentUser current, RequestContext ctx) {
        User user = loadForUpdate(current.id());
        if (user.getStatus() != UserStatus.PENDING_DELETION) {
            Instant now = clock.instant();
            user.requestDeletion(now, now.plus(properties.getAccount().getDeletionGracePeriod()));
            events.publishEvent(new AccountDeletionRequestedEvent(user.getId()));
            audit.record(AuditAction.ACCOUNT_DELETION_REQUESTED, user.getId(), ctx);
        }
        return new DeletionResponse(user.getStatus(), user.getScheduledPurgeAt());
    }

    /**
     * Silme penceresinde hesabı geri alır. Silme isteğinden <b>sonra</b> kodla yapılmış giriş gerekir
     * (silmeden önce alınmış belirteçle geri alınamaz).
     */
    @Transactional
    public MeResponse restore(CurrentUser current, RequestContext ctx) {
        User user = loadForUpdate(current.id());
        if (user.getStatus() == UserStatus.ACTIVE) {
            return toResponse(user);
        }
        if (user.getStatus() != UserStatus.PENDING_DELETION) {
            throw new ApiException(ErrorCode.FORBIDDEN);
        }
        if (current.authTime() == null || !current.authTime().isAfter(user.getDeletionRequestedAt())) {
            throw new ApiException(ErrorCode.REAUTH_REQUIRED);
        }
        user.restore(clock.instant());
        audit.record(AuditAction.ACCOUNT_RESTORED, user.getId(), ctx);
        return toResponse(user);
    }

    private User loadForUpdate(UUID id) {
        return users.findForUpdate(id).orElseThrow(() -> new ApiException(ErrorCode.UNAUTHORIZED));
    }

    private User load(UUID id) {
        return users.findById(id).orElseThrow(() -> new ApiException(ErrorCode.UNAUTHORIZED));
    }

    public MeResponse toResponse(User u) {
        return new MeResponse(u.getId(), u.getEmail(), u.getDisplayName(), u.getBirthYear(),
                ages.band(u.getBirthYear()), u.getRole(), u.getStatus(), u.getCreatedAt(), u.getScheduledPurgeAt());
    }
}
