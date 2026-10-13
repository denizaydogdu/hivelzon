package tr.velzon.hivelzon.auth;

import java.time.Duration;

/** Giriş kodu e-postası gönderir. Uygulamalar adresi ya da kodu loglamaz. */
public interface MailPort {

    void sendLoginCode(String to, String code, Duration validity);
}
