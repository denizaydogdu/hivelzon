package tr.velzon.hivelzon.catalog;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.FileTime;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.beans.factory.annotation.Autowired;

import tools.jackson.databind.JsonNode;
import tr.velzon.hivelzon.common.config.HivelzonProperties;
import tr.velzon.hivelzon.support.IntegrationTest;
import tr.velzon.hivelzon.support.QueryCounter;

/**
 * Katalog: geliştirme içe aktarması (rol, idempotent, durum eşlemesi), görünürlük (yalnız yayımlanmış ya da
 * onaylı ve zamanı gelmiş), ETag/304, sayfalama, N+1 denetimi.
 */
class CatalogTest extends IntegrationTest {

    private static final String IMPORT = "/api/v1/admin/catalog/import";

    @TempDir
    Path root;

    @Autowired
    HivelzonProperties properties;

    private String originalRoot;

    @BeforeEach
    void fixtures() throws IOException {
        originalRoot = properties.getCatalog().getImportRoot();
        properties.getCatalog().setImportRoot(root.toString());
        // A1-001: content.json "PUBLISHED" diyor ama durum veritabanında: lint temiz → IN_REVIEW.
        episode("A1-001-a-strange-message", 1, 1, "PUBLISHED", true, "APPROVED", null, 0);
        // A1-002: lint hatalı → DRAFT.
        episode("A1-002-the-new-neighbour", 2, 1, "APPROVED", false, "APPROVED", null, 2);
        // A1-003: lint temiz → IN_REVIEW (testlerde zamanlanır).
        episode("A1-003-find-the-station", 3, 1, "SCHEDULED", true, "APPROVED", "2026-10-15T09:00:00Z", 0);
        // A1-004: lint raporu yok → DRAFT.
        episode("A1-004-the-note", 4, 1, "APPROVED", true, "DRAFT", null, null);
        // Paketi olmayan bölüm atlanır.
        Files.createDirectories(root.resolve("A1-005-too-late"));
        season();
    }

    @AfterEach
    void restore() {
        properties.getCatalog().setImportRoot(originalRoot);
    }

    @Test
    void importNeedsEditorOrAdmin() {
        assertThat(call("POST", IMPORT, null, null).status()).isEqualTo(401);
        String user = login("ogrenci@example.com").text("accessToken");
        Response denied = call("POST", IMPORT, null, user);
        assertThat(denied.status()).isEqualTo(403);
        assertThat(problemCode(denied)).isEqualTo("FORBIDDEN");
        assertThat(count("SELECT count(*) FROM content_items")).isZero();
    }

    @Test
    void importIsIdempotentAndNeverApproves() throws IOException {
        String editor = loginWithRole("editor@example.com", "EDITOR");
        Response first = call("POST", IMPORT, null, editor);
        assertThat(first.status()).as(first.raw()).isEqualTo(200);
        assertThat(first.body().path("created").asInt()).isEqualTo(4);
        assertThat(first.body().path("seasons").get(0).path("result").asString()).isEqualTo("CREATED");
        // content.json durumu yok sayılır: yeni sürüm lint temizse IN_REVIEW, değilse DRAFT; asla onaylı değil.
        assertThat(statusOf("A1-001")).isEqualTo("IN_REVIEW");
        assertThat(statusOf("A1-002")).isEqualTo("DRAFT");
        assertThat(statusOf("A1-003")).isEqualTo("IN_REVIEW");
        assertThat(statusOf("A1-004")).isEqualTo("DRAFT");
        assertThat(first.raw()).contains("content.json durumu yok sayıldı").contains("lint raporu yok");
        assertThat(first.body().path("items").get(1).path("lintErrors").asInt()).isEqualTo(2);
        assertThat(count("SELECT count(*) FROM content_items WHERE publish_at IS NOT NULL")).isZero();

        Response again = call("POST", IMPORT, null, editor);
        assertThat(again.body().path("created").asInt()).isZero();
        assertThat(again.body().path("updated").asInt()).isZero();
        assertThat(again.body().path("unchanged").asInt()).isEqualTo(4);
        assertThat(again.body().path("seasons").get(0).path("result").asString()).isEqualTo("UNCHANGED");
        assertThat(count("SELECT count(*) FROM content_items")).isEqualTo(4);
        assertThat(count("SELECT count(*) FROM catalog_seasons")).isEqualTo(1);

        // Paket yeniden üretildi (manifest değişti) → incelemedeki sürüm güncellenir, durumu korunur; lint
        // raporu artık paketten eski olduğu için özet boşalır (onay verilemez).
        Path manifest = root.resolve("A1-001-a-strange-message/_build/package/manifest.json");
        Files.writeString(manifest, manifest("A1-001", 1, 999));
        Files.setLastModifiedTime(manifest, FileTime.from(Files.getLastModifiedTime(manifest).toInstant().plusSeconds(10)));
        Response third = call("POST", IMPORT, null, editor);
        assertThat(third.body().path("updated").asInt()).isEqualTo(1);
        assertThat(third.raw()).contains("lint raporu paketten eski");
        assertThat(statusOf("A1-001")).isEqualTo("IN_REVIEW");
        assertThat(count("SELECT count(*) FROM content_items WHERE content_id = 'A1-001' AND lint_errors IS NULL"))
                .isEqualTo(1);
        assertThat(count("SELECT count(*) FROM audit_log WHERE action = 'CATALOG_IMPORT'")).isEqualTo(3);
    }

    @Test
    void onlyPublishedOrApprovedAndDueAreVisible() throws IOException {
        importAsEditor();
        assertThat(ids(get("/api/v1/catalog/items", null))).isEmpty();
        publishFixtures();
        assertThat(ids(get("/api/v1/catalog/items", null))).containsExactly("A1-001");

        clock.advance(Duration.ofDays(2));
        assertThat(ids(get("/api/v1/catalog/items?season=1", null))).containsExactly("A1-001", "A1-003");
        assertThat(ids(get("/api/v1/catalog/items?season=2", null))).isEmpty();

        // Aynı bölümün 2. sürümü: yayımlanana kadar 1. sürüm görünür; sonra yalnızca en yeni görünür sürüm.
        episode("A1-001-a-strange-message", 1, 2, "PUBLISHED", true, "APPROVED", null, 0);
        importAsEditor();
        assertThat(get("/api/v1/catalog/items", null).body().path("items").get(0).path("contentVersion").asInt())
                .isEqualTo(1);
        publish(editorToken(), "A1-001", 2);
        Response items = get("/api/v1/catalog/items", null);
        assertThat(ids(items)).containsExactly("A1-001", "A1-003");
        JsonNode first = items.body().path("items").get(0);
        assertThat(first.path("contentVersion").asInt()).isEqualTo(2);
        assertThat(first.path("packageBaseUrl").asString()).isEqualTo("http://127.0.0.1:8787/packages/A1-001/");
        assertThat(first.path("scenesUrl").asString()).endsWith("/A1-001/scenes.json");
        assertThat(first.path("manifestSha256").asString()).hasSize(64);
        assertThat(first.has("status")).isFalse();
    }

    @Test
    void seasonHasEtagAndAnswers304() {
        importAsEditor();
        publishFixtures();
        Response season = get("/api/v1/catalog/seasons/1", null);
        assertThat(season.status()).isEqualTo(200);
        String etag = season.headers().get("etag");
        assertThat(etag).startsWith("\"").endsWith("\"");
        assertThat(season.headers().get("cache-control")).contains("max-age=60").contains("must-revalidate");
        assertThat(season.body().path("packageBaseUrl").asString())
                .isEqualTo("http://127.0.0.1:8787/packages/_season/S1/");
        JsonNode episodes = season.body().path("episodes");
        assertThat(episodes.size()).isEqualTo(5);
        assertThat(episodes.get(0).path("available").asBoolean()).isTrue();
        assertThat(episodes.get(0).path("item").path("contentId").asString()).isEqualTo("A1-001");
        assertThat(episodes.get(1).path("available").asBoolean()).isFalse();
        assertThat(episodes.get(1).has("item")).isFalse();
        assertThat(episodes.get(1).path("teaserTr").asString()).isNotBlank();
        // Onaysız tanıtım cümlesi gösterilmez.
        assertThat(episodes.get(4).has("teaserTr")).isFalse();
        assertThat(season.body().has("files")).isFalse();

        Response notModified = call("GET", "/api/v1/catalog/seasons/1", null, null, Map.of("If-None-Match", etag));
        assertThat(notModified.status()).isEqualTo(304);
        assertThat(notModified.raw()).isEmpty();
        assertThat(notModified.headers().get("etag")).isEqualTo(etag);

        // Zamanlanmış bölüm görünür olunca ETag değişir.
        clock.advance(Duration.ofDays(2));
        Response changed = call("GET", "/api/v1/catalog/seasons/1", null, null, Map.of("If-None-Match", etag));
        assertThat(changed.status()).isEqualTo(200);
        assertThat(changed.headers().get("etag")).isNotEqualTo(etag);
        assertThat(changed.body().path("episodes").get(2).path("available").asBoolean()).isTrue();

        Response items = get("/api/v1/catalog/items", null);
        assertThat(call("GET", "/api/v1/catalog/items", null, null,
                Map.of("If-None-Match", "W/" + items.headers().get("etag"))).status()).isEqualTo(304);

        Response missing = get("/api/v1/catalog/seasons/9", null);
        assertThat(missing.status()).isEqualTo(404);
        assertThat(problemCode(missing)).isEqualTo("NOT_FOUND");
    }

    @Test
    void catalogIsPublicAndIgnoresStaleTokens() {
        importAsEditor();
        assertThat(call("GET", "/api/v1/catalog/items", null, "bozuk.belirtec.degeri").status()).isEqualTo(200);
        clock.advance(Duration.ofHours(2));
        String expired = login("eski@example.com").text("accessToken");
        clock.advance(Duration.ofHours(1));
        assertThat(get("/api/v1/catalog/seasons/1", expired).status()).isEqualTo(200);
    }

    @Test
    void itemsArePaginated() {
        importAsEditor();
        publishFixtures();
        clock.advance(Duration.ofDays(2));
        Response p0 = get("/api/v1/catalog/items?size=1", null);
        assertThat(p0.body().path("totalItems").asInt()).isEqualTo(2);
        assertThat(p0.body().path("totalPages").asInt()).isEqualTo(2);
        assertThat(ids(p0)).containsExactly("A1-001");
        assertThat(ids(get("/api/v1/catalog/items?size=1&page=1", null))).containsExactly("A1-003");
        assertThat(ids(get("/api/v1/catalog/items?size=1&page=5", null))).isEmpty();
        assertThat(get("/api/v1/catalog/items?size=1000", null).body().path("size").asInt()).isEqualTo(100);
    }

    @Test
    void listsUseConstantStatementCount() throws IOException {
        importAsEditor();
        publishFixtures();
        clock.advance(Duration.ofDays(2));
        QueryCounter.reset();
        get("/api/v1/catalog/items", null);
        long small = QueryCounter.count();
        QueryCounter.reset();
        get("/api/v1/catalog/seasons/1", null);
        long seasonSmall = QueryCounter.count();

        for (int n = 6; n <= 12; n++) {
            episode(String.format("A1-%03d-ep-%d", n, n), n, 1, "PUBLISHED", true, "APPROVED", null, 0);
        }
        importAsEditor();
        for (int n = 6; n <= 12; n++) {
            publish(editorToken(), String.format("A1-%03d", n), 1);
        }
        QueryCounter.reset();
        assertThat(ids(get("/api/v1/catalog/items", null))).hasSize(9);
        assertThat(QueryCounter.count()).isEqualTo(small).isLessThanOrEqualTo(2);
        QueryCounter.reset();
        get("/api/v1/catalog/seasons/1", null);
        assertThat(QueryCounter.count()).isEqualTo(seasonSmall).isLessThanOrEqualTo(2);
    }

    // ------------------------------------------------------------------ yardımcılar

    private String editorToken;
    private java.time.Instant editorTokenAt;

    /** Editör belirteci; test saati ilerleyip süresi dolduysa yeniden girilir. */
    private String editorToken() {
        if (editorToken == null || clock.instant().isAfter(editorTokenAt.plus(Duration.ofMinutes(10)))) {
            editorToken = loginWithRole("editor@example.com", "EDITOR");
            editorTokenAt = clock.instant();
        }
        return editorToken;
    }

    private void importAsEditor() {
        Response r = call("POST", IMPORT, null, editorToken());
        assertThat(r.status()).as(r.raw()).isEqualTo(200);
    }

    /** A1-001 yayımlanır, A1-003 2026-10-15 09:00 UTC'ye zamanlanır (test saati 2026-10-13 10:00 UTC). */
    private void publishFixtures() {
        publish(editorToken(), "A1-001", 1);
        schedule(editorToken(), "A1-003", 1, "2026-10-15T09:00:00Z");
    }

    private String statusOf(String contentId) {
        return jdbc.queryForObject("SELECT status FROM content_items WHERE content_id = ? ORDER BY content_version DESC LIMIT 1",
                String.class, contentId);
    }

    private static List<String> ids(Response r) {
        List<String> out = new ArrayList<>();
        r.body().path("items").forEach(i -> out.add(i.path("contentId").asString()));
        return out;
    }

    private void episode(String folder, int number, int version, String status, boolean humanReviewed,
            String ceviriStatus, String publishAt, Integer lintErrors) throws IOException {
        String id = folder.substring(0, 6);
        Path dir = root.resolve(folder);
        Path pkg = dir.resolve("_build/package");
        Files.createDirectories(pkg);
        Files.writeString(pkg.resolve("manifest.json"), manifest(id, version, 1000 + number));
        Files.writeString(pkg.resolve("scenes.json"), """
                {"schemaVersion": 2, "episode": {"id": "%s", "slug": "%s", "level": "A1", "season": 1,
                 "number": %d, "title": "Episode %d", "contentVersion": %d, "status": "%s", "estimatedMinutes": 6},
                 "nodes": []}""".formatted(id, folder.substring(7), number, number, version, status));
        Files.writeString(dir.resolve("content.json"), """
                {"contentId": "%s", "version": %d, "status": "%s", "humanReviewed": %s, "publishAt": %s}"""
                .formatted(id, version, status, humanReviewed, publishAt == null ? "null" : "\"" + publishAt + "\""));
        Files.writeString(dir.resolve("ceviri.tr.json"), "{\"contentId\": \"" + id + "\", \"status\": \""
                + ceviriStatus + "\", \"lines\": []}");
        if (lintErrors != null) {
            lintReport(dir, id, lintErrors);
        }
    }

    /** {@code content_lint.py --write-reports} biçimi; paketten sonra yazılmış sayılır. */
    static void lintReport(Path dir, String id, int errors) throws IOException {
        StringBuilder errs = new StringBuilder();
        for (int i = 0; i < errors; i++) {
            errs.append(i == 0 ? "" : ",").append("\"HATA [coverage] örnek\"");
        }
        Path file = dir.resolve("_build/lint.json");
        Files.writeString(file, """
                {"tool": "content-lint", "schemaVersion": 1, "contentId": "%s", "generatedAt": "2026-10-13T09:00:00Z",
                 "errors": [%s], "warnings": ["UYARI [coverage] örnek"]}""".formatted(id, errs));
        Path manifest = dir.resolve("_build/package/manifest.json");
        Files.setLastModifiedTime(file, FileTime.from(Files.getLastModifiedTime(manifest).toInstant().plusSeconds(1)));
    }

    private static String manifest(String id, int version, long totalBytes) {
        return """
                {"schemaVersion": 1, "contentId": "%s", "contentVersion": %d, "renditions": ["720p", "1080p"],
                 "files": [], "totalBytes": %d, "renditionBytes": {"720p": 10, "1080p": 20}}"""
                .formatted(id, version, totalBytes);
    }

    private void season() throws IOException {
        Path dir = root.resolve("_evren/_build/season/S1");
        Files.createDirectories(dir);
        StringBuilder eps = new StringBuilder();
        for (int n = 1; n <= 5; n++) {
            if (n > 1) {
                eps.append(',');
            }
            eps.append("""
                    {"number": %d, "contentId": "A1-%03d", "title": "Episode %d", "teaserTr": "Tanıtım %d",
                     "teaserStatus": "%s", "available": true, "mapPos": [0.5, 0.5]}"""
                    .formatted(n, n, n, n, n == 5 ? "DRAFT" : "APPROVED"));
        }
        Files.writeString(dir.resolve("season.json"), """
                {"schemaVersion": 1, "season": 1, "title": "The Missing Signal", "level": "A1",
                 "intro": {"video": "jenerik-tam.mp4"}, "map": {"image": "map.webp", "width": 10, "height": 20},
                 "episodes": [%s], "files": [{"path": "map.webp", "bytes": 1, "sha256": "x"}], "totalBytes": 1}"""
                .formatted(eps));
    }
}
