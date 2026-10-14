package tr.velzon.hivelzon.catalog;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.FileTime;
import java.time.Instant;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;

import tools.jackson.databind.JsonNode;
import tr.velzon.hivelzon.common.config.HivelzonProperties;
import tr.velzon.hivelzon.support.IntegrationTest;

/**
 * Kitaplık arka ucu (H-070): {@code BOOK} içerik türü, C2 seviyesi, {@code <SEVİYE>-K<2 hane>} kimliği,
 * {@code book.json} içe aktarması, aynı K-05 onay akışı (kitapta kanon maddesi yok), kitap kataloğu (ETag),
 * bölüm kataloğunun kitaplardan etkilenmemesi ve veritabanı kısıtları.
 */
class BookCatalogTest extends IntegrationTest {

    private static final String IMPORT = "/api/v1/admin/catalog/import";
    private static final String ITEMS = "/api/v1/admin/content/items";
    private static final String BOOKS = "/api/v1/catalog/books";
    private static final Map<String, Object> BOOK_CHECKLIST = Map.of("levelChecked", true,
            "translationApproved", true, "mediaChecked", true, "rightsAndAiDisclosureChecked", true);

    @TempDir
    Path root;

    @Autowired
    HivelzonProperties properties;

    private String originalRoot;
    private String originalBooksRoot;
    private String editor;

    @BeforeEach
    void fixtures() throws IOException {
        originalRoot = properties.getCatalog().getImportRoot();
        originalBooksRoot = properties.getCatalog().getBooksImportRoot();
        Path episodes = Files.createDirectories(root.resolve("icerik"));
        Path books = Files.createDirectories(root.resolve("kitaplar"));
        properties.getCatalog().setImportRoot(episodes.toString());
        properties.getCatalog().setBooksImportRoot(books.toString());

        book("A1-K01-the-blue-door", "A1", "mystery", 1, 0, "APPROVED");          // lint temiz → IN_REVIEW
        book("A2-K03-the-parrot-who-told-everything", "A2", "humor", 1, 2, "APPROVED"); // lint hatalı → DRAFT
        book("C2-K01-the-missing-entries", "C2", "mystery", 1, 0, "APPROVED");    // C2 yalnızca kitapta
        // Kitap olmayan klasörler ve paketsiz kitap atlanır.
        Files.createDirectories(books.resolve("_maliyet"));
        Files.createDirectories(books.resolve("B1-K01-the-backwards-clock"));
        editor = loginWithRole("editor@example.com", "EDITOR");
    }

    @AfterEach
    void restore() {
        properties.getCatalog().setImportRoot(originalRoot);
        properties.getCatalog().setBooksImportRoot(originalBooksRoot);
    }

    @Test
    void sampleBookIsImportedApprovedAndListedInBookCatalog() {
        Response first = importNow();
        assertThat(first.body().path("created").asInt()).isEqualTo(3);
        Map<String, JsonNode> results = new HashMap<>();
        first.body().path("items").forEach(i -> results.put(i.path("contentId").asString(), i));
        assertThat(results.keySet()).containsExactlyInAnyOrder("A1-K01", "A2-K03", "C2-K01");
        assertThat(results.get("A1-K01").path("status").asString()).isEqualTo("IN_REVIEW");
        assertThat(results.get("A2-K03").path("status").asString()).isEqualTo("DRAFT");
        // book.json'daki durum (AI üretir) onay sayılmaz.
        assertThat(results.get("A1-K01").toString()).contains("book.json durumu yok sayıldı");

        // İdempotent.
        Response again = importNow();
        assertThat(again.body().path("unchanged").asInt()).isEqualTo(3);
        assertThat(again.body().path("created").asInt()).isZero();

        // Satır: tür, sezonsuz, K numarası, paket yeri, tanım (bölüm/sayfa listesi yok).
        Map<String, Object> row = jdbc.queryForMap("SELECT content_type, season, number, level, genre, "
                + "package_base_path, estimated_minutes, descriptor::text AS d FROM content_items "
                + "WHERE content_id = 'A1-K01'");
        assertThat(row.get("content_type")).isEqualTo("BOOK");
        assertThat(row.get("season")).isNull();
        assertThat(row.get("number")).isEqualTo(1);
        assertThat(row.get("genre")).isEqualTo("mystery");
        assertThat(row.get("package_base_path")).isEqualTo("_books/A1-K01");
        assertThat(row.get("estimated_minutes")).isEqualTo(8); // 7.3 yukarı yuvarlanır
        assertThat((String) row.get("d")).contains("\"chapterCount\": 2").doesNotContain("\"pages\"")
                .doesNotContain("narration").doesNotContain("\"status\"");

        // Onaysız kitap katalogda yok; bölüm kataloğu kitap göstermez.
        assertThat(bookIds(null)).isEmpty();

        // Kitapta kanon maddesi istenmez; kalan maddeler zorunlu.
        Response partial = transition(editor, "A1-K01", 1, "APPROVE",
                Map.of("checklist", Map.of("levelChecked", true)));
        assertThat(partial.status()).isEqualTo(422);
        assertThat(names(partial.body().path("missing")))
                .containsExactly("translationApproved", "mediaChecked", "rightsAndAiDisclosureChecked");
        Response approved = expectOk(transition(editor, "A1-K01", 1, "APPROVE", Map.of("checklist", BOOK_CHECKLIST)));
        JsonNode item = approved.body().path("item");
        assertThat(item.path("status").asString()).isEqualTo("APPROVED");
        assertThat(item.path("contentType").asString()).isEqualTo("BOOK");
        assertThat(item.path("season").isNull()).isTrue();
        assertThat(jdbc.queryForObject("SELECT approval_checklist::text FROM content_items WHERE content_id = 'A1-K01'",
                String.class)).doesNotContain("canonChecked");
        assertThat(bookIds(null)).isEmpty(); // onaylı ama yayın zamanı yok

        expectOk(transition(editor, "A1-K01", 1, "PUBLISH", Map.of()));
        Response catalog = get(BOOKS, null);
        assertThat(catalog.status()).isEqualTo(200);
        JsonNode card = catalog.body().path("items").get(0);
        assertThat(card.path("contentId").asString()).isEqualTo("A1-K01");
        assertThat(card.path("level").asString()).isEqualTo("A1");
        assertThat(card.path("genre").asString()).isEqualTo("mystery");
        assertThat(card.path("title").asString()).isEqualTo("The Blue Door");
        assertThat(card.path("titleTr").asString()).isEqualTo("Mavi Kapı");
        assertThat(card.path("palette").path("accent").asString()).isEqualTo("#D94F3D");
        assertThat(card.path("chapterCount").asInt()).isEqualTo(2);
        assertThat(card.path("pageCount").asInt()).isEqualTo(3);
        assertThat(card.path("packageBaseUrl").asString()).endsWith("/packages/_books/A1-K01/");
        assertThat(card.path("bookUrl").asString()).endsWith("/packages/_books/A1-K01/book.json");
        assertThat(card.path("pagesUrl").asString()).endsWith("/_books/A1-K01/pages.json");
        assertThat(card.path("coverUrl").asString()).endsWith("/_books/A1-K01/images/cover.webp");
        assertThat(card.path("manifestSha256").asString()).hasSize(64);
        // Bölüm kataloğu kitaplardan etkilenmez.
        assertThat(get("/api/v1/catalog/items", null).body().path("items").size()).isZero();

        // ETag / 304.
        String etag = catalog.headers().get("etag");
        assertThat(etag).isNotBlank();
        Response notModified = call("GET", BOOKS, null, null, Map.of("If-None-Match", etag));
        assertThat(notModified.status()).isEqualTo(304);

        // Geçişler denetim kaydında (APPROVE, PUBLISH).
        assertThat(count("SELECT count(*) FROM audit_log WHERE detail LIKE 'A1-K01:v1:%'")).isEqualTo(2);
    }

    @Test
    void levelFilterAndC2() {
        importNow();
        publishBook("A1-K01");
        publishBook("C2-K01");
        assertThat(bookIds(null)).containsExactly("A1-K01", "C2-K01");
        assertThat(bookIds("C2")).containsExactly("C2-K01");
        assertThat(bookIds("A2")).isEmpty();
        Response bad = get(BOOKS + "?level=D1", null);
        assertThat(bad.status()).isEqualTo(400);
        assertThat(problemCode(bad)).isEqualTo("VALIDATION_FAILED");
    }

    @Test
    void adminListFiltersByTypeAndDraftBookFollowsSameStateMachine() {
        importNow();
        Response all = get(ITEMS, editor);
        assertThat(all.body().size()).isEqualTo(3);
        Response books = get(ITEMS + "?type=BOOK", editor);
        assertThat(books.body().size()).isEqualTo(3);
        assertThat(books.body().get(0).path("contentId").asString()).isEqualTo("A1-K01");
        assertThat(get(ITEMS + "?type=EPISODE", editor).body().size()).isZero();
        assertThat(problemCode(get(ITEMS + "?type=KITAP", editor))).isEqualTo("VALIDATION_FAILED");

        // Lint hatalı kitap: SUBMIT olur, APPROVE lint hatası yüzünden reddedilir (K-05 aynen).
        expectOk(transition(editor, "A2-K03", 1, "SUBMIT", Map.of()));
        Response rejected = transition(editor, "A2-K03", 1, "APPROVE", Map.of("checklist", BOOK_CHECKLIST));
        assertThat(rejected.status()).isEqualTo(422);
        assertThat(names(rejected.body().path("missing"))).containsExactly("lintErrors");
        assertThat(problemCode(transition(editor, "A2-K03", 1, "PUBLISH", Map.of()))).isEqualTo("INVALID_TRANSITION");
        assertThat(get(ITEMS + "/A2-K03/versions/1", editor).status()).isEqualTo(200);
        assertThat(get(ITEMS + "/A2-K3/versions/1", editor).status()).isEqualTo(404);
    }

    @Test
    void inconsistentBookPackageIsSkipped() throws IOException {
        // book.json kimliği klasörle uyuşmuyor; manifest türü BOOK değil.
        Path dir = book("B2-K02-the-singing-hill", "B2", "adventure", 1, 0, "APPROVED");
        Files.writeString(dir.resolve("_build/package/book.json"),
                Files.readString(dir.resolve("_build/package/book.json")).replace("\"B2-K02\"", "\"B2-K09\""));
        Path other = book("B2-K03-please-dont-translate-that", "B2", "humor", 1, 0, "APPROVED");
        Files.writeString(other.resolve("_build/package/manifest.json"),
                manifest("B2-K03", 1, 1).replace("\"BOOK\"", "\"EPISODE\""));
        book("B2-K04-the-last-gardener-on-mars", "B2", "romance", 1, 0, "APPROVED"); // bilinmeyen tür
        Response r = importNow();
        assertThat(r.body().path("skipped").asInt()).isEqualTo(3);
        assertThat(count("SELECT count(*) FROM content_items WHERE level = 'B2'")).isZero();
    }

    @Test
    void databaseConstraintsKeepTypesApart() {
        String insert = """
                INSERT INTO content_items (content_type, content_id, content_version, season, number, level, title,
                    genre, descriptor, package_base_path, manifest_sha256, imported_at, updated_at)
                VALUES (?, ?, 1, ?, ?, ?, 't', ?, ?::jsonb, 'p', repeat('a', 64), now(), now())""";
        // C2 bölüm yok; kitap kimliği bölüm türüyle olmaz; kitap sezonsuz ve türlüdür; önek = seviye.
        assertThatThrownBy(() -> jdbc.update(insert, "EPISODE", "C1-001", 1, 1, "C2", null, null))
                .isInstanceOf(DataIntegrityViolationException.class);
        assertThatThrownBy(() -> jdbc.update(insert, "EPISODE", "A1-K01", 1, 1, "A1", null, null))
                .isInstanceOf(DataIntegrityViolationException.class);
        assertThatThrownBy(() -> jdbc.update(insert, "BOOK", "A1-001", null, 1, "A1", "mystery", "{}"))
                .isInstanceOf(DataIntegrityViolationException.class);
        assertThatThrownBy(() -> jdbc.update(insert, "BOOK", "A1-K01", 1, 1, "A1", "mystery", "{}"))
                .isInstanceOf(DataIntegrityViolationException.class);
        assertThatThrownBy(() -> jdbc.update(insert, "BOOK", "A1-K01", null, 1, "A1", null, "{}"))
                .isInstanceOf(DataIntegrityViolationException.class);
        assertThatThrownBy(() -> jdbc.update(insert, "BOOK", "A1-K01", null, 1, "A2", "mystery", "{}"))
                .isInstanceOf(DataIntegrityViolationException.class);
        assertThatThrownBy(() -> jdbc.update(insert, "BOOK", "A1-K01", null, 1, "A1", "romance", "{}"))
                .isInstanceOf(DataIntegrityViolationException.class);
        assertThat(jdbc.update(insert, "BOOK", "C2-K05", null, 5, "C2", "everyday", "{}")).isEqualTo(1);
        assertThat(jdbc.update(insert, "EPISODE", "C1-001", 3, 1, "C1", null, null)).isEqualTo(1);
    }

    // ------------------------------------------------------------------ yardımcılar

    private Response importNow() {
        Response r = call("POST", IMPORT, null, editor);
        assertThat(r.status()).as(r.raw()).isEqualTo(200);
        return r;
    }

    private void publishBook(String id) {
        expectOk(transition(editor, id, 1, "APPROVE", Map.of("checklist", BOOK_CHECKLIST)));
        expectOk(transition(editor, id, 1, "PUBLISH", Map.of()));
    }

    private List<String> bookIds(String level) {
        List<String> out = new ArrayList<>();
        get(BOOKS + (level == null ? "" : "?level=" + level), null).body().path("items")
                .forEach(i -> out.add(i.path("contentId").asString()));
        return out;
    }

    private static List<String> names(JsonNode array) {
        List<String> out = new ArrayList<>();
        array.forEach(n -> out.add(n.asString()));
        return out;
    }

    /** {@code export_book.py} paketi ({@code docs/KITAPLIK.md} §6.3) + {@code book_lint.py --write-reports}. */
    private Path book(String folder, String level, String genre, int version, Integer lintErrors, String ceviriStatus)
            throws IOException {
        String id = folder.substring(0, 6);
        Path dir = root.resolve("kitaplar").resolve(folder);
        Path pkg = Files.createDirectories(dir.resolve("_build/package"));
        Path manifest = pkg.resolve("manifest.json");
        Files.writeString(manifest, manifest(id, version, 5000 + version));
        Files.setLastModifiedTime(manifest, FileTime.from(Instant.now().minusSeconds(60)));
        Files.writeString(pkg.resolve("book.json"), """
                {"schemaVersion": 1, "id": "%s", "slug": "%s", "level": "%s", "genre": "%s",
                 "title": "The Blue Door", "titleTr": "Mavi Kapı", "blurbTr": "Tanıtım.", "hookEn": "A light.",
                 "contentVersion": %d, "status": "APPROVED", "aiGenerated": true,
                 "palette": {"background": "#FFF8EC", "text": "#1F2A48", "accent": "#D94F3D"},
                 "grammarTopics": ["G-A1-01-to-be"], "cover": "images/cover.webp", "wordCount": 766,
                 "pageCount": 3, "estimatedMinutes": 7.3,
                 "chapters": [
                   {"id": "c1", "title": "One", "titleTr": "Bir", "audio": "audio/c1.m4a", "duration": 10.0,
                    "pages": [{"id": "p01", "image": "images/p01.webp"}, {"id": "p02", "image": null}]},
                   {"id": "c2", "title": "Two", "titleTr": "İki", "audio": null, "duration": null,
                    "pages": [{"id": "p03", "image": null}]}]}"""
                .formatted(id, folder, level, genre, version));
        Files.writeString(dir.resolve("ceviri.tr.json"),
                "{\"contentId\": \"" + id + "\", \"status\": \"" + ceviriStatus + "\"}");
        if (lintErrors != null) {
            StringBuilder errs = new StringBuilder();
            for (int i = 0; i < lintErrors; i++) {
                errs.append(i == 0 ? "" : ",").append("\"HATA [book-words] örnek\"");
            }
            Path file = dir.resolve("_build/lint.json");
            Files.writeString(file, """
                    {"tool": "book-lint", "schemaVersion": 1, "contentId": "%s", "level": "%s",
                     "generatedAt": "2026-10-13T09:00:00Z", "errors": [%s], "warnings": []}"""
                    .formatted(id, level, errs));
            Files.setLastModifiedTime(file, FileTime.from(Instant.now()));
        }
        return dir;
    }

    private static String manifest(String id, int version, long totalBytes) {
        return """
                {"schemaVersion": 1, "contentId": "%s", "contentType": "BOOK", "contentVersion": %d,
                 "files": [], "missing": [], "totalBytes": %d}""".formatted(id, version, totalBytes);
    }
}
