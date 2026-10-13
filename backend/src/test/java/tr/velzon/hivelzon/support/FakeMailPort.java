package tr.velzon.hivelzon.support;

import java.time.Duration;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import tr.velzon.hivelzon.auth.MailPort;

/** Gönderilen giriş kodlarını bellekte tutar (yalnızca test). */
public class FakeMailPort implements MailPort {

    public record Sent(String to, String code, Duration validity) {
    }

    private final List<Sent> sent = new CopyOnWriteArrayList<>();

    @Override
    public void sendLoginCode(String to, String code, Duration validity) {
        sent.add(new Sent(to, code, validity));
    }

    public List<Sent> sent() {
        return List.copyOf(sent);
    }

    public String lastCodeFor(String to) {
        for (int i = sent.size() - 1; i >= 0; i--) {
            if (sent.get(i).to().equals(to)) {
                return sent.get(i).code();
            }
        }
        throw new AssertionError("Bu adrese kod gönderilmedi");
    }

    public void clear() {
        sent.clear();
    }
}
