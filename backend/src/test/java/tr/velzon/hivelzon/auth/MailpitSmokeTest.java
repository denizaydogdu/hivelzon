package tr.velzon.hivelzon.auth;

import static org.assertj.core.api.Assertions.assertThat;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.wait.strategy.Wait;
import org.testcontainers.utility.DockerImageName;

import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;
import tr.velzon.hivelzon.common.config.HivelzonProperties;

/** SMTP bağdaştırıcısı gerçek bir Mailpit'e Türkçe, düz metin giriş kodu e-postası gönderir. */
class MailpitSmokeTest {

    private static final GenericContainer<?> MAILPIT =
            new GenericContainer<>(DockerImageName.parse("axllent/mailpit:v1.27"))
                    .withExposedPorts(1025, 8025)
                    .waitingFor(Wait.forHttp("/readyz").forPort(8025));

    @BeforeAll
    static void start() {
        MAILPIT.start();
    }

    @AfterAll
    static void stop() {
        MAILPIT.stop();
    }

    @Test
    void sendsPlainTurkishLoginCode() throws Exception {
        JavaMailSenderImpl sender = new JavaMailSenderImpl();
        sender.setHost(MAILPIT.getHost());
        sender.setPort(MAILPIT.getMappedPort(1025));
        sender.setDefaultEncoding("UTF-8");
        new SmtpMailAdapter(sender, new HivelzonProperties())
                .sendLoginCode("smoke@example.com", "482913", Duration.ofMinutes(10));

        String api = "http://" + MAILPIT.getHost() + ":" + MAILPIT.getMappedPort(8025);
        HttpClient http = HttpClient.newHttpClient();
        JsonMapper json = JsonMapper.builder().build();
        JsonNode list = json.readTree(http.send(HttpRequest.newBuilder(URI.create(api + "/api/v1/messages")).build(),
                HttpResponse.BodyHandlers.ofString()).body());
        assertThat(list.path("total").asInt()).isEqualTo(1);
        JsonNode summary = list.path("messages").get(0);
        assertThat(summary.path("Subject").asString()).isEqualTo("hiVelzon giriş kodun").doesNotContain("482913");

        JsonNode message = json.readTree(http.send(HttpRequest.newBuilder(
                URI.create(api + "/api/v1/message/" + summary.path("ID").asString())).build(),
                HttpResponse.BodyHandlers.ofString()).body());
        String text = message.path("Text").asString();
        assertThat(text).contains("hiVelzon giriş kodun: 482913").contains("10 dakika geçerli");
        assertThat(message.path("HTML").asString()).isEmpty();
        assertThat(message.path("From").path("Address").asString()).isEqualTo("no-reply@hi.velzon.tr");
    }
}
