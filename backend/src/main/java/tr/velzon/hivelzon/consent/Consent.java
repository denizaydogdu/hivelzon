package tr.velzon.hivelzon.consent;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import org.hibernate.annotations.Immutable;

/** Rıza satırı: yalnızca eklenir (veritabanı tetikleyicisi güncellemeyi ve silmeyi de engeller). */
@Entity
@Immutable
@Table(name = "consents")
public class Consent {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @Enumerated(EnumType.STRING)
    @Column(name = "consent_type", nullable = false, length = 32)
    private ConsentType type;

    @Column(name = "document_version", nullable = false, length = 32)
    private String documentVersion;

    @Column(nullable = false)
    private boolean granted;

    @Column(name = "created_at", nullable = false)
    private Instant createdAt;

    @Column(length = 45)
    private String ip;

    private Integer port;

    protected Consent() {
    }

    public Consent(UUID userId, ConsentType type, String documentVersion, boolean granted, Instant createdAt,
            String ip, Integer port) {
        this.userId = userId;
        this.type = type;
        this.documentVersion = documentVersion;
        this.granted = granted;
        this.createdAt = createdAt;
        this.ip = ip;
        this.port = port;
    }

    public Long getId() { return id; }
    public UUID getUserId() { return userId; }
    public ConsentType getType() { return type; }
    public String getDocumentVersion() { return documentVersion; }
    public boolean isGranted() { return granted; }
    public Instant getCreatedAt() { return createdAt; }
}
