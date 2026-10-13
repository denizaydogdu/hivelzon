package tr.velzon.hivelzon.auth;

import java.util.Locale;
import java.util.regex.Pattern;

import tr.velzon.hivelzon.common.web.ApiException;
import tr.velzon.hivelzon.common.web.ErrorCode;

/** E-posta biçimi: kırpılır, küçük harfe çevrilir (Locale.ROOT; Türkçe İ/ı sorunu olmasın). */
public final class EmailAddresses {

    private static final Pattern SHAPE =
            Pattern.compile("^[A-Za-z0-9._%+'-]{1,64}@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*\\.[A-Za-z]{2,63}$");

    private EmailAddresses() {
    }

    public static String normalise(String raw) {
        if (raw == null) {
            throw new ApiException(ErrorCode.VALIDATION_FAILED);
        }
        String value = raw.trim().toLowerCase(Locale.ROOT);
        if (value.length() > 254 || !SHAPE.matcher(value).matches()) {
            throw new ApiException(ErrorCode.VALIDATION_FAILED);
        }
        return value;
    }
}
