package tr.velzon.hivelzon.support;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.LinkedHashMap;
import java.util.Map;

import org.junit.jupiter.api.BeforeEach;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.context.annotation.Import;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;
import tr.velzon.hivelzon.TestcontainersConfiguration;

/**
 * Ortak entegrasyon testi tabanı: tek Spring bağlamı + tek PostgreSQL konteyneri (Testcontainers).
 * Her testten önce tablolar boşaltılır, saat ve sahte posta sıfırlanır.
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT, properties = {
        "hivelzon.jobs.enabled=false",
        // Kitaplık kökü testte boş (yok): gerçek kitaplar/ paketleri sayımlara karışmaz; kitap testleri ayarlar.
        "hivelzon.catalog.books-import-root=target/test-no-books",
        // Reel kökü de boş (yok): gerçek reeller/ paketleri sayımlara karışmaz; reel testleri ayarlar.
        "hivelzon.catalog.reels-import-root=target/test-no-reels",
        "spring.jpa.properties.hibernate.generate_statistics=true",
        "logging.level.org.hibernate.engine.internal.StatisticalLoggingSessionEventListener=WARN",
        // Yalnızca test anahtarları (rastgele üretilmiş, hiçbir ortamda kullanılmaz).
        "hivelzon.security.jwt-secret=dGVzdC1vbmx5LWp3dC1rZXktaGl2ZWx6b24tMDAwMDAwMDAwMDAw",
        "hivelzon.security.otp-pepper=dGVzdC1vbmx5LW90cC1wZXBwZXItaGl2ZWx6b24tMTExMTExMTExMTE="
})
@Import({TestcontainersConfiguration.class, TestBeans.class})
public abstract class IntegrationTest {

    protected static final JsonMapper JSON = JsonMapper.builder().build();
    private static final HttpClient HTTP = HttpClient.newHttpClient();

    @LocalServerPort
    protected int port;

    @Autowired
    protected JdbcTemplate jdbc;

    @Autowired
    protected TransactionTemplate tx;

    @Autowired
    protected MutableClock clock;

    @Autowired
    protected FakeMailPort mail;

    @BeforeEach
    void resetState() {
        tx.executeWithoutResult(s -> {
            jdbc.queryForObject("SELECT set_config('hivelzon.allow_consent_purge', 'on', true)", String.class);
            jdbc.execute("TRUNCATE consents, refresh_tokens, users, otp_challenges, rate_limit_buckets, audit_log, "
                    + "content_items, catalog_seasons, user_story_progress, user_story_flags, gate_progress, "
                    + "season_state, clues, story_links, notebook_items, review_cards, review_logs, learning_events, "
                    + "hi_records, speech_attempts, user_book_progress, user_grammar_progress, daily_activity, "
                    + "user_book_comprehension, expression_evidence, user_talk_progress, account_tombstones");
        });
        clock.reset();
        mail.clear();
    }

    public record Response(int status, JsonNode body, Map<String, String> headers, String raw) {
        public String text(String field) {
            JsonNode node = body.path(field);
            return node.isMissingNode() || node.isNull() ? null : node.asString();
        }
    }

    protected Response call(String method, String path, Object body, String bearer) {
        try {
            HttpRequest.Builder builder = HttpRequest.newBuilder(URI.create("http://localhost:" + port + path))
                    .header("Accept", "application/json");
            if (bearer != null) {
                builder.header("Authorization", "Bearer " + bearer);
            }
            if (body != null) {
                builder.header("Content-Type", "application/json")
                        .method(method, HttpRequest.BodyPublishers.ofString(
                                body instanceof String s ? s : JSON.writeValueAsString(body)));
            } else {
                builder.method(method, HttpRequest.BodyPublishers.noBody());
            }
            HttpResponse<String> response = HTTP.send(builder.build(), HttpResponse.BodyHandlers.ofString());
            Map<String, String> headers = new LinkedHashMap<>();
            response.headers().map().forEach((k, v) -> headers.put(k.toLowerCase(), String.join(",", v)));
            String raw = response.body();
            JsonNode json = raw == null || raw.isBlank() ? JSON.createObjectNode() : JSON.readTree(raw);
            return new Response(response.statusCode(), json, headers, raw);
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }

    /** İstek başlıklarıyla çağrı (ör. If-None-Match). */
    protected Response call(String method, String path, Object body, String bearer, Map<String, String> extra) {
        try {
            HttpRequest.Builder builder = HttpRequest.newBuilder(URI.create("http://localhost:" + port + path))
                    .header("Accept", "application/json");
            if (bearer != null) {
                builder.header("Authorization", "Bearer " + bearer);
            }
            extra.forEach(builder::header);
            if (body != null) {
                builder.header("Content-Type", "application/json")
                        .method(method, HttpRequest.BodyPublishers.ofString(
                                body instanceof String s ? s : JSON.writeValueAsString(body)));
            } else {
                builder.method(method, HttpRequest.BodyPublishers.noBody());
            }
            HttpResponse<String> response = HTTP.send(builder.build(), HttpResponse.BodyHandlers.ofString());
            Map<String, String> headers = new LinkedHashMap<>();
            response.headers().map().forEach((k, v) -> headers.put(k.toLowerCase(), String.join(",", v)));
            String raw = response.body();
            JsonNode json = raw == null || raw.isBlank() ? JSON.createObjectNode() : JSON.readTree(raw);
            return new Response(response.statusCode(), json, headers, raw);
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }

    /** Hesap açar, rolünü verir ve rolü taşıyan yeni belirteci döner. */
    protected String loginWithRole(String email, String role) {
        login(email);
        jdbc.update("UPDATE users SET role = ? WHERE email = ?", role, email);
        return login(email).text("accessToken");
    }

    protected Response post(String path, Object body) {
        return call("POST", path, body, null);
    }

    protected Response startOtp(String email) {
        return post("/api/v1/auth/email/start", Map.of("email", email));
    }

    protected static Map<String, Object> signup(int birthYear) {
        Map<String, Object> signup = new LinkedHashMap<>();
        signup.put("birthYear", birthYear);
        signup.put("termsVersion", "taslak-2");
        signup.put("privacyNoticeVersion", "taslak-2");
        return signup;
    }

    protected Response verify(String email, String code, Map<String, Object> signup) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("email", email);
        body.put("code", code);
        body.put("deviceName", "Test iPhone");
        if (signup != null) {
            body.putAll(signup);
        }
        return post("/api/v1/auth/email/verify", body);
    }

    /** Yeni hesap açar ya da giriş yapar; token cevabını döner. */
    protected Response login(String email) {
        Response start = startOtp(email);
        if (start.status() != 202) {
            throw new AssertionError("start " + start.status() + " " + start.raw());
        }
        String code = mail.lastCodeFor(email.trim().toLowerCase());
        Response verified = verify(email, code, null);
        if (verified.status() == 422) {
            verified = verify(email, code, signup(2000));
        }
        if (verified.status() != 200) {
            throw new AssertionError("verify " + verified.status() + " " + verified.raw());
        }
        return verified;
    }

    protected Response get(String path, String bearer) {
        return call("GET", path, null, bearer);
    }

    protected Response refresh(String refreshToken) {
        return post("/api/v1/auth/refresh", Map.of("refreshToken", refreshToken));
    }

    /** Problem cevabının ortak biçimini doğrular ve kodu döner. */
    protected static String problemCode(Response response) {
        if (!response.headers().getOrDefault("content-type", "").startsWith("application/problem+json")) {
            throw new AssertionError("ProblemDetail değil: " + response.headers() + " " + response.raw());
        }
        if (response.raw().contains("trace") || response.raw().contains("exception")) {
            throw new AssertionError("İç ayrıntı sızdı: " + response.raw());
        }
        return response.text("code");
    }

    // ------------------------------------------------------------------ editör geçişleri (H-041)

    protected static final Map<String, Object> FULL_CHECKLIST = Map.of("canonChecked", true, "levelChecked", true,
            "translationApproved", true, "mediaChecked", true, "rightsAndAiDisclosureChecked", true);

    protected Response editorItem(String token, String contentId, int version) {
        return get("/api/v1/admin/content/items/" + contentId + "/versions/" + version, token);
    }

    /** Güncel kilit sürümünü okuyup geçişi uygular. {@code extra}: checklist, publishAt, reason … */
    protected Response transition(String token, String contentId, int version, String action,
            Map<String, Object> extra) {
        long lock = editorItem(token, contentId, version).body().path("item").path("lockVersion").asLong();
        Map<String, Object> body = new LinkedHashMap<>(extra);
        body.put("action", action);
        body.put("expectedLockVersion", lock);
        return call("POST", "/api/v1/admin/content/items/" + contentId + "/versions/" + version + "/transitions",
                body, token);
    }

    /** DRAFT/IN_REVIEW sürümü onaylar (gerekirse önce incelemeye gönderir). */
    protected void approve(String token, String contentId, int version) {
        String status = editorItem(token, contentId, version).body().path("item").path("status").asString();
        if ("DRAFT".equals(status)) {
            expectOk(transition(token, contentId, version, "SUBMIT", Map.of()));
        }
        expectOk(transition(token, contentId, version, "APPROVE", Map.of("checklist", FULL_CHECKLIST)));
    }

    protected void publish(String token, String contentId, int version) {
        approve(token, contentId, version);
        expectOk(transition(token, contentId, version, "PUBLISH", Map.of()));
    }

    protected void schedule(String token, String contentId, int version, String publishAtIso) {
        approve(token, contentId, version);
        expectOk(transition(token, contentId, version, "SCHEDULE", Map.of("publishAt", publishAtIso)));
    }

    protected static Response expectOk(Response r) {
        if (r.status() != 200) {
            throw new AssertionError("geçiş " + r.status() + " " + r.raw());
        }
        return r;
    }

    protected int count(String sql, Object... args) {
        Integer n = jdbc.queryForObject(sql, Integer.class, args);
        return n == null ? 0 : n;
    }
}
