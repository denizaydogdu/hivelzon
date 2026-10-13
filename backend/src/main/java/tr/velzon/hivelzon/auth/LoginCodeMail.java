package tr.velzon.hivelzon.auth;

import java.time.Duration;

/** Giriş kodu e-postasının metni: kısa, Türkçe, düz metin. Kod konu satırında yer almaz. */
public final class LoginCodeMail {

    public static final String SUBJECT = "hiVelzon giriş kodun";

    private LoginCodeMail() {
    }

    public static String body(String code, Duration validity) {
        return """
                Merhaba,

                hiVelzon giriş kodun: %s

                Kod %d dakika geçerli. Bu kodu kimseyle paylaşma.
                Bu isteği sen yapmadıysan bu e-postayı yok sayabilirsin.

                hiVelzon
                """.formatted(code, validity.toMinutes());
    }
}
