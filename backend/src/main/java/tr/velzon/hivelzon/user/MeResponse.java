package tr.velzon.hivelzon.user;

import java.time.Instant;
import java.util.UUID;

public record MeResponse(
        UUID id,
        String email,
        String displayName,
        int birthYear,
        AgeBand ageBand,
        Role role,
        UserStatus status,
        Instant createdAt,
        Instant scheduledPurgeAt) {

    /** E-posta loglara düşmesin (ör. DEBUG düzeyinde cevap yazımı). */
    @Override
    public String toString() {
        return "MeResponse[id=" + id + ", status=" + status + "]";
    }
}
