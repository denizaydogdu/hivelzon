package tr.velzon.hivelzon.user;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "users")
public class User {

    @Id
    private UUID id;

    @Column(nullable = false, length = 254)
    private String email;

    @Column(name = "display_name", length = 40)
    private String displayName;

    @Column(name = "birth_year", nullable = false)
    private Integer birthYear;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 16)
    private Role role;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 24)
    private UserStatus status;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @Column(name = "last_login_at")
    private Instant lastLoginAt;

    @Column(name = "deletion_requested_at")
    private Instant deletionRequestedAt;

    @Column(name = "scheduled_purge_at")
    private Instant scheduledPurgeAt;

    protected User() {
    }

    public User(UUID id, String email, String displayName, int birthYear, Instant now) {
        this.id = id;
        this.email = email;
        this.displayName = displayName;
        this.birthYear = birthYear;
        this.role = Role.USER;
        this.status = UserStatus.ACTIVE;
        this.createdAt = now;
        this.updatedAt = now;
    }

    public void markLogin(Instant now) {
        this.lastLoginAt = now;
        this.updatedAt = now;
    }

    public void requestDeletion(Instant now, Instant purgeAt) {
        this.status = UserStatus.PENDING_DELETION;
        this.deletionRequestedAt = now;
        this.scheduledPurgeAt = purgeAt;
        this.updatedAt = now;
    }

    public void restore(Instant now) {
        this.status = UserStatus.ACTIVE;
        this.deletionRequestedAt = null;
        this.scheduledPurgeAt = null;
        this.updatedAt = now;
    }

    public UUID getId() { return id; }
    public String getEmail() { return email; }
    public String getDisplayName() { return displayName; }
    public int getBirthYear() { return birthYear; }
    public Role getRole() { return role; }
    public UserStatus getStatus() { return status; }
    public Instant getCreatedAt() { return createdAt; }
    public Instant getUpdatedAt() { return updatedAt; }
    public Instant getLastLoginAt() { return lastLoginAt; }
    public Instant getDeletionRequestedAt() { return deletionRequestedAt; }
    public Instant getScheduledPurgeAt() { return scheduledPurgeAt; }
}
