package tr.velzon.hivelzon.common.web;

import java.time.Duration;

/** İstemciye {@link ErrorCode} ile dönen beklenen hata. Mesajında kişisel veri olmaz. */
public class ApiException extends RuntimeException {

    private final ErrorCode code;
    private final Duration retryAfter;

    public ApiException(ErrorCode code) {
        this(code, null);
    }

    public ApiException(ErrorCode code, Duration retryAfter) {
        super(code.name(), null, false, false);
        this.code = code;
        this.retryAfter = retryAfter;
    }

    public ErrorCode code() {
        return code;
    }

    public Duration retryAfter() {
        return retryAfter;
    }
}
