package tr.velzon.hivelzon.common.web;

import java.time.Duration;
import java.util.Map;

/** İstemciye {@link ErrorCode} ile dönen beklenen hata. Mesajında kişisel veri olmaz. */
public class ApiException extends RuntimeException {

    private final ErrorCode code;
    private final Duration retryAfter;
    private final Map<String, Object> properties;

    public ApiException(ErrorCode code) {
        this(code, (Duration) null);
    }

    public ApiException(ErrorCode code, Duration retryAfter) {
        this(code, retryAfter, Map.of());
    }

    /**
     * Ek problem alanlarıyla (ör. eşitlemede {@code table}, {@code index}, {@code field}). Alanlarda kişisel veri
     * ya da istemcinin gönderdiği değer olmaz; yalnızca yerini gösteren adlar.
     */
    public ApiException(ErrorCode code, Map<String, Object> properties) {
        this(code, null, properties);
    }

    private ApiException(ErrorCode code, Duration retryAfter, Map<String, Object> properties) {
        super(code.name(), null, false, false);
        this.code = code;
        this.retryAfter = retryAfter;
        this.properties = Map.copyOf(properties);
    }

    public Map<String, Object> properties() {
        return properties;
    }

    public ErrorCode code() {
        return code;
    }

    public Duration retryAfter() {
        return retryAfter;
    }
}
