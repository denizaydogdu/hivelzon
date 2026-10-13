package tr.velzon.hivelzon.auth;

import java.time.Duration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

import tr.velzon.hivelzon.common.config.HivelzonProperties;
import tr.velzon.hivelzon.common.web.ApiException;
import tr.velzon.hivelzon.common.web.ErrorCode;

/**
 * SMTP ile düz metin e-posta (HTML yok, bağlantı yok, izleme pikseli yok). Yerelde Mailpit (docker-compose).
 */
@Component
public class SmtpMailAdapter implements MailPort {

    private static final Logger log = LoggerFactory.getLogger(SmtpMailAdapter.class);

    private final JavaMailSender sender;
    private final String from;

    public SmtpMailAdapter(JavaMailSender sender, HivelzonProperties properties) {
        this.sender = sender;
        this.from = properties.getMail().getFrom();
    }

    @Override
    public void sendLoginCode(String to, String code, Duration validity) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(from);
        message.setTo(to);
        message.setSubject(LoginCodeMail.SUBJECT);
        message.setText(LoginCodeMail.body(code, validity));
        try {
            sender.send(message);
            log.info("Giriş kodu e-postası gönderildi.");
        } catch (MailException e) {
            log.warn("Giriş kodu e-postası gönderilemedi: {}", e.getClass().getSimpleName());
            throw new ApiException(ErrorCode.MAIL_UNAVAILABLE);
        }
    }
}
