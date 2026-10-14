package tr.velzon.hivelzon.catalog;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.FileTime;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.beans.factory.annotation.Autowired;

import tools.jackson.databind.JsonNode;
import tr.velzon.hivelzon.common.config.HivelzonProperties;
import tr.velzon.hivelzon.support.IntegrationTest;
import tr.velzon.hivelzon.support.MutableClock;

/**
 * Editör onayı (H-041): durum veritabanında, geçiş kuralları, onay koşulları (lint + çeviri + kontrol listesi),
 * iyimser kilit, denetim kaydı, katalog görünürlüğü (zamanlanmış içerik tam zamanında), yeniden içe aktarmanın
 * durumu bozmaması, yeni sürümün eski yayımlanmış sürümü gizlememesi, editör ekranının sunulması.
 */
class EditorialTest extends IntegrationTest {

    private static final String IMPORT = "/api/v1/admin/catalog/import";
    private static final String ITEMS = "/api/v1/admin/content/items";

    @TempDir
    Path root;

    @Autowired
    HivelzonProperties properties;

    @Autowired
    EditorialService editorial;

    private String originalRoot;
    private String editor;

    @BeforeEach
    void fixtures() throws IOException {
        originalRoot = properties.getCatalog().getImportRoot();
        properties.getCatalog().setImportRoot(root.toString());
        episode("A1-001-a-strange-message", 1, 1, 0, "APPROVED");   // lint temiz → IN_REVIEW
        episode("A1-002-the-new-neighbour", 2, 1, 3, "APPROVED");   // lint hatalı → DRAFT
        episode("A1-003-find-the-station", 3, 1, null, "APPROVED"); // lint raporu yok → DRAFT
        episode("A1-004-the-note", 4, 1, 0, "DRAFT");               // çeviri onaysız → IN_REVIEW
        editor = loginWithRole("editor@example.com", "EDITOR");
        importNow();
    }

    @AfterEach
    void restore() {
        properties.getCatalog().setImportRoot(originalRoot);
    }

    @Test
    void endpointsNeedEditorRoleCheckedAgainstDatabase() {
        assertThat(call("GET", ITEMS, null, null).status()).isEqualTo(401);
        String user = login("ogrenci@example.com").text("accessToken");
        Response denied = get(ITEMS, user);
        assertThat(denied.status()).isEqualTo(403);
        assertThat(problemCode(denied)).isEqualTo("FORBIDDEN");
        assertThat(transition(user, "A1-001", 1, "APPROVE", Map.of("checklist", FULL_CHECKLIST)).status())
                .isEqualTo(403);

        // Rolü geri alınan editörün belirteci hâlâ EDITOR diyor; veritabanı denetimi reddeder.
        String demoted = loginWithRole("eski-editor@example.com", "EDITOR");
        jdbc.update("UPDATE users SET role = 'USER' WHERE email = 'eski-editor@example.com'");
        assertThat(problemCode(get(ITEMS, demoted))).isEqualTo("FORBIDDEN");

        String admin = loginWithRole("admin@example.com", "ADMIN");
        Response list = get(ITEMS + "?season=1", admin);
        assertThat(list.status()).isEqualTo(200);
        assertThat(list.body().size()).isEqualTo(4);
        assertThat(get(ITEMS + "/A1-009/versions/1", admin).status()).isEqualTo(404);
        assertThat(get(ITEMS + "/bozuk/versions/1", admin).status()).isEqualTo(404);
    }

    @Test
    void importStartsInReviewOrDraftAndListShowsLint() {
        Response list = get(ITEMS, editor);
        Map<String, JsonNode> byId = new java.util.HashMap<>();
        list.body().forEach(i -> byId.put(i.path("contentId").asString(), i));
        assertThat(byId.get("A1-001").path("status").asString()).isEqualTo("IN_REVIEW");
        assertThat(byId.get("A1-001").path("lintErrors").asInt()).isZero();
        assertThat(byId.get("A1-001").path("lintWarnings").asInt()).isEqualTo(1);
        assertThat(byId.get("A1-001").path("visible").asBoolean()).isFalse();
        assertThat(names(byId.get("A1-001").path("allowedActions"))).containsExactly("APPROVE", "WITHDRAW");
        assertThat(byId.get("A1-002").path("status").asString()).isEqualTo("DRAFT");
        assertThat(byId.get("A1-002").path("lintErrors").asInt()).isEqualTo(3);
        assertThat(byId.get("A1-003").path("status").asString()).isEqualTo("DRAFT");
        assertThat(byId.get("A1-003").path("lintErrors").isNull()).isTrue();
        assertThat(byId.get("A1-004").path("translationStatus").asString()).isEqualTo("DRAFT");
        // Onaysız hiçbir şey katalogda yok.
        assertThat(catalogIds()).isEmpty();
    }

    @Test
    void approvalNeedsCleanLintApprovedTranslationAndFullChecklist() {
        // Kontrol listesi eksik.
        Response partial = transition(editor, "A1-001", 1, "APPROVE",
                Map.of("checklist", Map.of("canonChecked", true, "levelChecked", true)));
        assertThat(partial.status()).isEqualTo(422);
        assertThat(problemCode(partial)).isEqualTo("APPROVAL_REQUIREMENTS_NOT_MET");
        assertThat(names(partial.body().path("missing")))
                .containsExactly("translationApproved", "mediaChecked", "rightsAndAiDisclosureChecked");
        assertThat(problemCode(transition(editor, "A1-001", 1, "APPROVE", Map.of())))
                .isEqualTo("APPROVAL_REQUIREMENTS_NOT_MET");

        // Lint hatası ve rapor yokluğu.
        expectOk(transition(editor, "A1-002", 1, "SUBMIT", Map.of()));
        Response lintErrors = transition(editor, "A1-002", 1, "APPROVE", Map.of("checklist", FULL_CHECKLIST));
        assertThat(names(lintErrors.body().path("missing"))).containsExactly("lintErrors");
        expectOk(transition(editor, "A1-003", 1, "SUBMIT", Map.of()));
        Response noLint = transition(editor, "A1-003", 1, "APPROVE", Map.of("checklist", FULL_CHECKLIST));
        assertThat(names(noLint.body().path("missing"))).containsExactly("lintReport");
        // ceviri.tr.json onaysız.
        Response translation = transition(editor, "A1-004", 1, "APPROVE", Map.of("checklist", FULL_CHECKLIST));
        assertThat(names(translation.body().path("missing"))).containsExactly("translationFileApproved");

        // Tam: onay kaydı sürüme ve pakete bağlanır.
        Response ok = expectOk(transition(editor, "A1-001", 1, "APPROVE", Map.of("checklist", FULL_CHECKLIST)));
        JsonNode item = ok.body().path("item");
        assertThat(item.path("status").asString()).isEqualTo("APPROVED");
        assertThat(item.path("checklistSha256").asString()).hasSize(64);
        assertThat(item.path("approvedAt").asString()).isEqualTo("2026-10-13T10:00:00Z");
        assertThat(item.path("visible").asBoolean()).isFalse();
        assertThat(count("SELECT count(*) FROM content_items WHERE content_id = 'A1-001' "
                + "AND approved_manifest_sha256 = manifest_sha256 AND approved_by IS NOT NULL")).isEqualTo(1);
        // Onaylı ama yayın zamanı yok: katalogda görünmez.
        assertThat(catalogIds()).isEmpty();
    }

    @Test
    void scheduledBecomesVisibleExactlyWhenTimeComes() {
        approve(editor, "A1-001", 1);
        // Geçmiş zaman reddedilir.
        Response past = transition(editor, "A1-001", 1, "SCHEDULE", Map.of("publishAt", "2026-10-13T09:00:00Z"));
        assertThat(past.status()).isEqualTo(400);
        assertThat(past.body().path("field").asString()).isEqualTo("publishAt");
        assertThat(problemCode(transition(editor, "A1-001", 1, "SCHEDULE", Map.of("publishAtLocal", "dün"))))
                .isEqualTo("VALIDATION_FAILED");

        // Ekran Türkiye saatiyle gönderir: 14 Ekim 12:00 (UTC+3) → 09:00 UTC.
        Response scheduled = expectOk(transition(editor, "A1-001", 1, "SCHEDULE",
                Map.of("publishAtLocal", "2026-10-14T12:00")));
        assertThat(scheduled.body().path("item").path("publishAt").asString()).isEqualTo("2026-10-14T09:00:00Z");
        assertThat(scheduled.body().path("item").path("status").asString()).isEqualTo("SCHEDULED");
        assertThat(catalogIds()).isEmpty();

        // Yayına girmemiş zamanlama değiştirilebilir.
        expectOk(transition(editor, "A1-001", 1, "SCHEDULE", Map.of("publishAt", "2026-10-14T09:00:00+00:00")));

        clock.advance(Duration.between(MutableClock.START, Instant.parse("2026-10-14T08:59:59Z")));
        assertThat(catalogIds()).isEmpty();
        clock.advance(Duration.ofSeconds(1));
        assertThat(catalogIds()).containsExactly("A1-001");

        // Yayına girmiş zamanlama artık ertelenemez; elle "Yayınla" yayın zamanını korur.
        editor = loginWithRole("editor@example.com", "EDITOR"); // saat ilerledi, eski belirteç doldu
        Response late = transition(editor, "A1-001", 1, "SCHEDULE", Map.of("publishAt", "2026-12-01T09:00:00Z"));
        assertThat(late.status()).isEqualTo(409);
        assertThat(problemCode(late)).isEqualTo("INVALID_TRANSITION");
        Response published = expectOk(transition(editor, "A1-001", 1, "PUBLISH", Map.of()));
        assertThat(published.body().path("item").path("publishAt").asString()).isEqualTo("2026-10-14T09:00:00Z");
        assertThat(catalogIds()).containsExactly("A1-001");
    }

    @Test
    void invalidTransitionsAreRejected() {
        Response publishDraft = transition(editor, "A1-002", 1, "PUBLISH", Map.of());
        assertThat(publishDraft.status()).isEqualTo(409);
        assertThat(problemCode(publishDraft)).isEqualTo("INVALID_TRANSITION");
        assertThat(publishDraft.body().path("from").asString()).isEqualTo("DRAFT");
        assertThat(problemCode(transition(editor, "A1-002", 1, "APPROVE", Map.of("checklist", FULL_CHECKLIST))))
                .isEqualTo("INVALID_TRANSITION");
        assertThat(problemCode(transition(editor, "A1-001", 1, "SUBMIT", Map.of()))).isEqualTo("INVALID_TRANSITION");
        assertThat(problemCode(transition(editor, "A1-001", 1, "ARCHIVE", Map.of()))).isEqualTo("INVALID_TRANSITION");
        assertThat(problemCode(transition(editor, "A1-001", 1, "SCHEDULE",
                Map.of("publishAt", "2026-11-01T09:00:00Z")))).isEqualTo("INVALID_TRANSITION");
        assertThat(problemCode(transition(editor, "A1-001", 1, "YAYINLA", Map.of()))).isEqualTo("VALIDATION_FAILED");

        publish(editor, "A1-001", 1);
        assertThat(problemCode(transition(editor, "A1-001", 1, "PUBLISH", Map.of()))).isEqualTo("INVALID_TRANSITION");
        expectOk(transition(editor, "A1-001", 1, "ARCHIVE", Map.of()));
        assertThat(catalogIds()).isEmpty();
        assertThat(problemCode(transition(editor, "A1-001", 1, "PUBLISH", Map.of()))).isEqualTo("INVALID_TRANSITION");
        // Arşivden de kaldırılabilir; kaldırılmış son durumdur.
        expectOk(transition(editor, "A1-001", 1, "WITHDRAW", Map.of("reason", "OTHER")));
        for (String action : List.of("SUBMIT", "APPROVE", "SCHEDULE", "PUBLISH", "ARCHIVE", "WITHDRAW")) {
            assertThat(problemCode(transition(editor, "A1-001", 1, action, Map.of("reason", "OTHER"))))
                    .as(action).isEqualTo("INVALID_TRANSITION");
        }
        // Hiçbir başarısız geçiş satırı ya da denetim kaydını değiştirmedi.
        // Başarılı olanlar: APPROVE, PUBLISH, ARCHIVE, WITHDRAW.
        assertThat(count("SELECT count(*) FROM audit_log WHERE action LIKE 'CONTENT\\_%'")).isEqualTo(4);
    }

    @Test
    void optimisticLockRejectsStaleWrites() {
        long lock = editorItem(editor, "A1-001", 1).body().path("item").path("lockVersion").asLong();
        String path = ITEMS + "/A1-001/versions/1/transitions";
        Response first = call("POST", path, Map.of("action", "APPROVE", "expectedLockVersion", lock,
                "checklist", FULL_CHECKLIST), editor);
        assertThat(first.status()).isEqualTo(200);
        assertThat(first.body().path("item").path("lockVersion").asLong()).isEqualTo(lock + 1);
        // İkinci sekme eski sürümle yayınlamaya çalışır.
        Response stale = call("POST", path, Map.of("action", "PUBLISH", "expectedLockVersion", lock), editor);
        assertThat(stale.status()).isEqualTo(409);
        assertThat(problemCode(stale)).isEqualTo("CONCURRENT_MODIFICATION");
        assertThat(stale.body().path("currentLockVersion").asLong()).isEqualTo(lock + 1);
        assertThat(problemCode(call("POST", path, Map.of("action", "PUBLISH"), editor))).isEqualTo("VALIDATION_FAILED");
        assertThat(catalogIds()).isEmpty();
    }

    @Test
    void withdrawnDisappearsAndReasonIsACode() {
        publish(editor, "A1-001", 1);
        assertThat(catalogIds()).containsExactly("A1-001");
        Response noReason = transition(editor, "A1-001", 1, "WITHDRAW", Map.of());
        assertThat(noReason.status()).isEqualTo(400);
        assertThat(noReason.body().path("field").asString()).isEqualTo("reason");
        assertThat(problemCode(transition(editor, "A1-001", 1, "WITHDRAW", Map.of("reason", "çünkü öyle"))))
                .isEqualTo("VALIDATION_FAILED");
        Response withdrawn = expectOk(transition(editor, "A1-001", 1, "WITHDRAW", Map.of("reason", "COPYRIGHT")));
        assertThat(withdrawn.body().path("item").path("withdrawReason").asString()).isEqualTo("COPYRIGHT");
        assertThat(catalogIds()).isEmpty();
        // Taslak da kaldırılabilir (ör. hiç yayımlanmayacak).
        expectOk(transition(editor, "A1-002", 1, "WITHDRAW", Map.of("reason", "CONTENT_ERROR")));
    }

    @Test
    void transitionsAreAuditedWithoutPersonalData() {
        schedule(editor, "A1-001", 1, "2026-10-15T09:00:00Z");
        expectOk(transition(editor, "A1-001", 1, "PUBLISH", Map.of()));
        expectOk(transition(editor, "A1-001", 1, "WITHDRAW", Map.of("reason", "SAFETY")));

        List<String> details = jdbc.queryForList(
                "SELECT action || ' ' || detail FROM audit_log WHERE action LIKE 'CONTENT\\_%' ORDER BY id", String.class);
        assertThat(details).hasSize(4);
        assertThat(details.get(0)).matches("CONTENT_APPROVED A1-001:v1:IN_REVIEW>APPROVED:c=[0-9a-f]{12}");
        assertThat(details.get(1)).isEqualTo("CONTENT_SCHEDULED A1-001:v1:APPROVED>SCHEDULED:20261015T090000Z");
        assertThat(details.get(2)).isEqualTo("CONTENT_PUBLISHED A1-001:v1:SCHEDULED>PUBLISHED");
        assertThat(details.get(3)).isEqualTo("CONTENT_WITHDRAWN A1-001:v1:PUBLISHED>WITHDRAWN:SAFETY");
        assertThat(count("SELECT count(*) FROM audit_log WHERE action LIKE 'CONTENT\\_%' AND (detail LIKE '%@%' "
                + "OR actor_user_id IS NULL)")).isZero();

        // Ayrıntı sayfasındaki geçmiş: kim (maskeli), ne zaman, ne.
        JsonNode history = editorItem(editor, "A1-001", 1).body().path("history");
        assertThat(history.size()).isEqualTo(4);
        assertThat(history.get(0).path("action").asString()).isEqualTo("CONTENT_APPROVED");
        assertThat(history.get(0).path("actor").asString()).isEqualTo("e***@example.com");
        assertThat(history.get(3).path("detail").asString()).endsWith(":SAFETY");
        // Başka sürümün geçmişi karışmaz.
        assertThat(editorItem(editor, "A1-004", 1).body().path("history").size()).isZero();

        // Kalıcı hesap silmede editör kimliği içerik satırından silinir.
        UUID editorId = jdbc.queryForObject("SELECT id FROM users WHERE email = 'editor@example.com'", UUID.class);
        editorial.purgeUserData(editorId);
        assertThat(count("SELECT count(*) FROM content_items WHERE approved_by IS NOT NULL "
                + "OR status_changed_by IS NOT NULL")).isZero();
    }

    @Test
    void reimportNeverChangesEditorialStatus() throws IOException {
        publish(editor, "A1-001", 1);
        String sha = jdbc.queryForObject("SELECT manifest_sha256 FROM content_items WHERE content_id = 'A1-001'",
                String.class);

        // Aynı paket: değişiklik yok.
        Response again = importNow();
        assertThat(again.body().path("unchanged").asInt()).isEqualTo(4);
        assertThat(statusOf("A1-001", 1)).isEqualTo("PUBLISHED");

        // Yayımlanmış sürümün paketi değişti: donmuş, atlanır; durum ve paket özeti aynı kalır.
        Path manifest = root.resolve("A1-001-a-strange-message/_build/package/manifest.json");
        Files.writeString(manifest, manifest("A1-001", 1, 4242));
        CatalogTest.lintReport(root.resolve("A1-001-a-strange-message"), "A1-001", 5);
        Response changed = importNow();
        JsonNode r = changed.body().path("items").get(0);
        assertThat(r.path("result").asString()).isEqualTo("SKIPPED");
        assertThat(r.path("status").asString()).isEqualTo("PUBLISHED");
        assertThat(r.toString()).contains("contentVersion artırılmalı");
        assertThat(statusOf("A1-001", 1)).isEqualTo("PUBLISHED");
        assertThat(jdbc.queryForObject("SELECT manifest_sha256 FROM content_items WHERE content_id = 'A1-001'",
                String.class)).isEqualTo(sha);
        assertThat(count("SELECT lint_errors FROM content_items WHERE content_id = 'A1-001'")).isZero();
        assertThat(catalogIds()).containsExactly("A1-001");

        // Taslak içerikte lint düzeldi: özet güncellenir, durum (DRAFT) kendiliğinden değişmez.
        CatalogTest.lintReport(root.resolve("A1-002-the-new-neighbour"), "A1-002", 0);
        Response fixed = importNow();
        assertThat(fixed.body().path("items").get(1).path("result").asString()).isEqualTo("UPDATED");
        assertThat(statusOf("A1-002", 1)).isEqualTo("DRAFT");
        assertThat(count("SELECT lint_errors FROM content_items WHERE content_id = 'A1-002'")).isZero();
    }

    @Test
    void newVersionStaysDraftWhilePublishedVersionRemainsVisible() throws IOException {
        publish(editor, "A1-001", 1);
        // 2. sürüm: lint hatalı → DRAFT.
        episode("A1-001-a-strange-message", 1, 2, 1, "APPROVED");
        Response imported = importNow();
        assertThat(imported.body().path("created").asInt()).isEqualTo(1);
        assertThat(statusOf("A1-001", 2)).isEqualTo("DRAFT");
        assertThat(statusOf("A1-001", 1)).isEqualTo("PUBLISHED");
        Response items = get("/api/v1/catalog/items", null);
        assertThat(items.body().path("items").get(0).path("contentVersion").asInt()).isEqualTo(1);

        // Editör listesinde iki sürüm de var (yeni sürüm önce).
        List<String> versions = new ArrayList<>();
        get(ITEMS + "?season=1", editor).body().forEach(i -> {
            if (i.path("contentId").asString().equals("A1-001")) {
                versions.add(i.path("contentVersion").asInt() + ":" + i.path("status").asString());
            }
        });
        assertThat(versions).containsExactly("2:DRAFT", "1:PUBLISHED");
    }

    @Test
    void adminScreenIsServedWithStrictHeaders() throws Exception {
        HttpClient http = HttpClient.newHttpClient();
        HttpResponse<String> page = http.send(HttpRequest.newBuilder(
                URI.create("http://localhost:" + port + "/admin/index.html")).build(), HttpResponse.BodyHandlers.ofString());
        assertThat(page.statusCode()).isEqualTo(200);
        assertThat(page.body()).contains("Editör onayı").contains("Onayla").contains("Zamanla").contains("Kaldır")
                .doesNotContain("<script>");
        String csp = page.headers().firstValue("Content-Security-Policy").orElse("");
        assertThat(csp).contains("script-src 'self'").contains("frame-ancestors 'none'").doesNotContain("unsafe");
        assertThat(page.headers().firstValue("X-Frame-Options").orElse("")).isEqualTo("DENY");

        HttpResponse<String> js = http.send(HttpRequest.newBuilder(
                URI.create("http://localhost:" + port + "/admin/admin.js")).build(), HttpResponse.BodyHandlers.ofString());
        assertThat(js.statusCode()).isEqualTo(200);
        assertThat(js.body()).doesNotContain(".innerHTML").doesNotContain("eval(");

        HttpResponse<String> redirect = http.send(HttpRequest.newBuilder(
                URI.create("http://localhost:" + port + "/admin")).build(), HttpResponse.BodyHandlers.ofString());
        assertThat(redirect.statusCode()).isEqualTo(302);
        assertThat(redirect.headers().firstValue("Location").orElse("")).endsWith("/admin/index.html");

        // Ekranın dışındaki statik yollar kapalı kalır.
        HttpResponse<String> other = http.send(HttpRequest.newBuilder(
                URI.create("http://localhost:" + port + "/admin/../application.yml")).build(),
                HttpResponse.BodyHandlers.ofString());
        assertThat(other.statusCode()).isIn(400, 401, 403, 404);
    }

    // ------------------------------------------------------------------ yardımcılar

    private Response importNow() {
        Response r = call("POST", IMPORT, null, editor);
        assertThat(r.status()).as(r.raw()).isEqualTo(200);
        return r;
    }

    private List<String> catalogIds() {
        List<String> out = new ArrayList<>();
        get("/api/v1/catalog/items", null).body().path("items").forEach(i -> out.add(i.path("contentId").asString()));
        return out;
    }

    private String statusOf(String contentId, int version) {
        return jdbc.queryForObject("SELECT status FROM content_items WHERE content_id = ? AND content_version = ?",
                String.class, contentId, version);
    }

    private static List<String> names(JsonNode array) {
        List<String> out = new ArrayList<>();
        array.forEach(n -> out.add(n.asString()));
        return out;
    }

    private void episode(String folder, int number, int version, Integer lintErrors, String ceviriStatus)
            throws IOException {
        String id = folder.substring(0, 6);
        Path dir = root.resolve(folder);
        Path pkg = dir.resolve("_build/package");
        Files.createDirectories(pkg);
        Path manifest = pkg.resolve("manifest.json");
        Files.writeString(manifest, manifest(id, version, 1000 + number + version));
        Files.setLastModifiedTime(manifest, FileTime.from(Instant.now().minusSeconds(60)));
        Files.writeString(pkg.resolve("scenes.json"), """
                {"schemaVersion": 2, "episode": {"id": "%s", "slug": "%s", "level": "A1", "season": 1,
                 "number": %d, "title": "Episode %d", "contentVersion": %d, "estimatedMinutes": 6}, "nodes": []}"""
                .formatted(id, folder.substring(7), number, number, version));
        // content.json'daki durum (AI üretir) hiçbir zaman onay sayılmaz.
        Files.writeString(dir.resolve("content.json"), """
                {"contentId": "%s", "version": %d, "status": "PUBLISHED", "humanReviewed": true,
                 "publishAt": "2026-10-13T00:00:00Z"}""".formatted(id, version));
        Files.writeString(dir.resolve("ceviri.tr.json"),
                "{\"contentId\": \"" + id + "\", \"status\": \"" + ceviriStatus + "\", \"lines\": []}");
        Files.deleteIfExists(dir.resolve("_build/lint.json"));
        if (lintErrors != null) {
            CatalogTest.lintReport(dir, id, lintErrors);
        }
    }

    private static String manifest(String id, int version, long totalBytes) {
        return """
                {"schemaVersion": 1, "contentId": "%s", "contentVersion": %d, "renditions": ["720p"],
                 "files": [], "totalBytes": %d, "renditionBytes": {"720p": 10}}""".formatted(id, version, totalBytes);
    }
}
