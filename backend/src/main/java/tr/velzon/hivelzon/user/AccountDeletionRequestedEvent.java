package tr.velzon.hivelzon.user;

import java.util.UUID;

/** Hesap silme istendi: diğer modüller (ör. oturumlar) aynı işlem içinde tepki verir. */
public record AccountDeletionRequestedEvent(UUID userId) {
}
