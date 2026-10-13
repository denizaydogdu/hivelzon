package tr.velzon.hivelzon.user;

import java.time.Instant;

public record DeletionResponse(UserStatus status, Instant scheduledPurgeAt) {
}
