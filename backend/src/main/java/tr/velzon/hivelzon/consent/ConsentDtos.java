package tr.velzon.hivelzon.consent;

import java.time.Instant;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public final class ConsentDtos {

    private ConsentDtos() {
    }

    public record ConsentRequest(
            @NotNull ConsentType type,
            @NotBlank @Size(max = 32) String version,
            @NotNull Boolean granted) {
    }

    /** Türün güncel durumu. {@code upToDate}: onaylanan sürüm güncel sürümle aynı mı. */
    public record ConsentState(ConsentType type, String version, boolean granted, Instant at,
            String currentVersion, boolean upToDate) {
    }

    public record ConsentHistoryItem(ConsentType type, String version, boolean granted, Instant at) {
    }
}
