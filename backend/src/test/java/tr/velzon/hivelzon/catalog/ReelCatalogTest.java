package tr.velzon.hivelzon.catalog;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Instant;
import java.util.ArrayList;
import java.util.LinkedHashMap;
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
 * Bağımsız reeller (H-094 P4): {@code REEL} içerik türü, {@code <SEVİYE>-R-<KAT>-<NN>} kimliği,
 * {@code reeller/<id>/reel.json} içe aktarması (kaynak ya da üretim paketi), K-05 onay akışı
 * (reelde kanon maddesi yok), yayın süzmesi (geri çekilen görünmez), seviye/kategori süzgeci ve
 * veritabanı kısıtları.
 */
class ReelCatalogTest extends IntegrationTest {

    private static final String IMPORT = "/api/v1/admin/catalog/import";
    private static final String REELS = "/api/v1/catalog/reels";
    private static final Map<String, Object> REEL_CHECKLIST = Map.of("levelChecked", true,
            "translationApproved", true, "mediaChecked", true, "rightsAndAiDisclosureChecked", true);

    @TempDir
    Path root;

    @Autowired
    HivelzonProperties properties;

    private String originalReelsRoot;
    private String originalRoot;
    private String originalBooksRoot;
    private String editor;

    @BeforeEach
    void fixtures() throws IOException {
        originalReelsRoot = properties.getCatalog().getReelsImportRoot();
        originalRoot = properties.getCatalog().getImportRoot();
        originalBooksRoot = properties.getCatalog().getBooksImportRoot();
        // Yalnız reel kökü dolu: bölüm/kitap kökleri boş (gerçek içerik sayımlara karışmaz).
        Files.createDirectories(root.resolve("icerik"));
        Files.createDirectories(root.resolve("kitaplar"));
        properties.getCatalog().setImportRoot(root.resolve("icerik").toString());
        properties.getCatalog().setBooksImportRoot(root.resolve("kitaplar").toString());
        properties.getCatalog().setReelsImportRoot(root.resolve("reeller").toString());
        // A1-R-CIN-01 ve A2-R-SPO-01: lint temiz → IN_REVIEW.
        // A1-R-BOK-01: lint raporu yok → DRAFT (onaylanamaz). B1-R-SPO-01: lint hatalı → DRAFT.
        reel("A1-R-CIN-01-aa", "A1-R-CIN-01", "A1", "CIN", 0);
        reel("A2-R-SPO-01-bb", "A2-R-SPO-01", "A2", "SPO", 0);
        reel("A1-R-BOK-01-cc", "A1-R-BOK-01", "A1", "BOK", null);
        reel("B1-R-SPO-01-dd", "B1-R-SPO-01", "B1", "SPO", 2);
        Files.createDirectories(root.resolve("reeller").resolve("_maliyet"));
        editor = loginWithRole("editor@example.com", "EDITOR");
    }

    @AfterEach
    void restore() {
        properties.getCatalog().setReelsImportRoot(originalReelsRoot);
        properties.getCatalog().setImportRoot(originalRoot);
        properties.getCatalog().setBooksImportRoot(originalBooksRoot);
    }

    @Test
    void contentTypeCoversReelsWithoutBreakingOthers() {
        assertThat(ContentType.ofId("A1-R-CIN-01")).isEqualTo(ContentType.REEL);
        assertThat(ContentType.ofId("A2-R-SPO-03")).isEqualTo(ContentType.REEL);
        assertThat(ContentType.ofId("A1-R-XXX-01")).isNull();
        assertThat(ContentType.ofId("A1-R-CIN-1")).isNull();
        assertThat(ContentType.ofId("A1-001")).isEqualTo(ContentType.EPISODE);
        assertThat(ContentType.ofId("A1-K01")).isEqualTo(ContentType.BOOK);
        assertThat(ContentType.REEL.packageBasePath("A1-R-CIN-01")).isEqualTo("_reels/A1-R-CIN-01");
        assertThat(ContentType.EPISODE.packageBasePath("A1-001")).isEqualTo("A1-001");
    }

    @Test
    void importCreatesReelRowsAndNeverApproves() {
        Response report = call("POST", IMPORT, null, editor);
        assertThat(report.status()).as(report.raw()).isEqualTo(200);
        assertThat(report.body().path("created").asInt()).isEqualTo(4);
        Map<String, JsonNode> results = new LinkedHashMap<>();
        report.body().path("items").forEach(i -> results.put(i.path("contentId").asString(), i));
        assertThat(results.keySet()).containsExactlyInAnyOrder("A1-R-CIN-01", "A2-R-SPO-01", "A1-R-BOK-01",
                "B1-R-SPO-01");
        assertThat(results.get("A1-R-CIN-01").path("status").asString()).isEqualTo("IN_REVIEW");
        assertThat(results.get("A2-R-SPO-01").path("status").asString()).isEqualTo("IN_REVIEW");
        assertThat(results.get("A1-R-BOK-01").path("status").asString()).isEqualTo("DRAFT");
        assertThat(results.get("B1-R-SPO-01").path("status").asString()).isEqualTo("DRAFT");
        // Kaynak reel.json kullanıldığı not edilir (üretim paketi yok).
        assertThat(results.get("A1-R-CIN-01").toString()).contains("kaynak reel.json");

        Map<String, Object> row = jdbc.queryForMap(
                "SELECT content_type, package_base_path, season, genre, level, number, descriptor::text AS d "
                        + "FROM content_items WHERE content_id = 'A1-R-CIN-01'");
        assertThat(row.get("content_type")).isEqualTo("REEL");
        assertThat(row.get("package_base_path")).isEqualTo("_reels/A1-R-CIN-01");
        assertThat(row.get("season")).isNull();
        assertThat(row.get("genre")).isNull();
        assertThat(row.get("level")).isEqualTo("A1");
        assertThat(row.get("number")).isEqualTo(1);
        assertThat((String) row.get("d")).contains("\"category\": \"CIN\"").contains("\"titleTr\"");

        // İdempotent.
        Response again = call("POST", IMPORT, null, editor);
        assertThat(again.body().path("unchanged").asInt()).isEqualTo(4);
        assertThat(again.body().path("created").asInt()).isZero();
    }

    @Test
    void approvalNeedsChecklistButNotCanonAndPublishingFiltersCatalog() {
        call("POST", IMPORT, null, editor);
        // Onayda kanon maddesi istenmez (reel bağımsız içeriktir).
        Response approved = transition(editor, "A1-R-CIN-01", 1, "APPROVE", Map.of("checklist", REEL_CHECKLIST));
        assertThat(approved.status()).as(approved.raw()).isEqualTo(200);
        assertThat(approved.body().path("item").path("status").asString()).isEqualTo("APPROVED");
        String checklist = jdbc.queryForObject(
                "SELECT approval_checklist::text FROM content_items WHERE content_id = 'A1-R-CIN-01'", String.class);
        assertThat(checklist).doesNotContain("canonChecked");

        // Onaylı ama yayımlanmamış: katalogda görünmez.
        assertThat(reelIds(null, null)).isEmpty();

        expectOk(transition(editor, "A1-R-CIN-01", 1, "PUBLISH", Map.of()));
        List<JsonNode> listed = new ArrayList<>();
        get(REELS, null).body().path("items").forEach(listed::add);
        assertThat(listed).hasSize(1);
        JsonNode card = listed.get(0);
        assertThat(card.path("contentId").asString()).isEqualTo("A1-R-CIN-01");
        assertThat(card.path("contentVersion").asInt()).isEqualTo(1);
        assertThat(card.path("level").asString()).isEqualTo("A1");
        assertThat(card.path("number").asInt()).isEqualTo(1);
        assertThat(card.path("category").asString()).isEqualTo("CIN");
        assertThat(card.path("family").asString()).isEqualTo("FAM-CIN-1");
        assertThat(card.path("titleTr").asString()).isEqualTo("Gişede iki bilet");
        assertThat(card.path("duration").asDouble()).isEqualTo(10.0);
        assertThat(card.path("target").path("en").asString()).isEqualTo("Two tickets, please.");
        assertThat(card.path("packageBaseUrl").asString()).endsWith("/packages/_reels/A1-R-CIN-01/");
        assertThat(card.path("reelUrl").asString()).endsWith("/packages/_reels/A1-R-CIN-01/reel.json");

        // Geri çekilen içerik yayın süzmesinden geçmez.
        expectOk(transition(editor, "A1-R-CIN-01", 1, "WITHDRAW", Map.of("reason", "SAFETY")));
        assertThat(reelIds(null, null)).isEmpty();
    }

    @Test
    void approvalStillNeedsTheOtherChecklistItems() {
        call("POST", IMPORT, null, editor);
        Response partial = transition(editor, "A1-R-CIN-01", 1, "APPROVE",
                Map.of("checklist", Map.of("translationApproved", true, "mediaChecked", true,
                        "rightsAndAiDisclosureChecked", true)));
        assertThat(partial.status()).isEqualTo(422);
        assertThat(problemCode(partial)).isEqualTo("APPROVAL_REQUIREMENTS_NOT_MET");
        assertThat(partial.body().path("missing").toString()).contains("levelChecked")
                .doesNotContain("canonChecked");
    }

    @Test
    void lintMissingBlocksApproval() {
        call("POST", IMPORT, null, editor);
        expectOk(transition(editor, "A1-R-BOK-01", 1, "SUBMIT", Map.of()));
        Response noLint = transition(editor, "A1-R-BOK-01", 1, "APPROVE", Map.of("checklist", REEL_CHECKLIST));
        assertThat(noLint.status()).isEqualTo(422);
        assertThat(noLint.body().path("missing").toString()).contains("lintReport");
        expectOk(transition(editor, "B1-R-SPO-01", 1, "SUBMIT", Map.of()));
        Response lintErrors = transition(editor, "B1-R-SPO-01", 1, "APPROVE",
                Map.of("checklist", REEL_CHECKLIST));
        assertThat(lintErrors.status()).isEqualTo(422);
        assertThat(lintErrors.body().path("missing").toString()).contains("lintErrors");
    }

    @Test
    void catalogFiltersByLevelAndCategory() {
        call("POST", IMPORT, null, editor);
        approve(editor, "A1-R-CIN-01", 1);
        expectOk(transition(editor, "A1-R-CIN-01", 1, "PUBLISH", Map.of()));
        approve(editor, "A2-R-SPO-01", 1);
        expectOk(transition(editor, "A2-R-SPO-01", 1, "PUBLISH", Map.of()));

        assertThat(reelIds("A1", null)).containsExactly("A1-R-CIN-01");
        assertThat(reelIds("A2", null)).containsExactly("A2-R-SPO-01");
        assertThat(reelIds(null, "SPO")).containsExactly("A2-R-SPO-01");
        assertThat(reelIds(null, "BOK")).isEmpty();
        assertThat(problemCode(get(REELS + "?category=XYZ", null))).isEqualTo("VALIDATION_FAILED");
        assertThat(problemCode(get(REELS + "?level=C9", null))).isEqualTo("VALIDATION_FAILED");
    }

    @Test
    void databaseConstraintsMatchTheContract() {
        call("POST", IMPORT, null, editor);
        assertThatThrownBy(() -> jdbc.update(
                "UPDATE content_items SET content_id = 'A1-R-XXX-01' WHERE content_id = 'A1-R-CIN-01'"))
                .isInstanceOf(DataIntegrityViolationException.class);
        assertThatThrownBy(() -> jdbc.update(
                "UPDATE content_items SET level = 'A2' WHERE content_id = 'A1-R-CIN-01'"))
                .isInstanceOf(DataIntegrityViolationException.class);
        assertThatThrownBy(() -> jdbc.update(
                "UPDATE content_items SET season = 1 WHERE content_id = 'A1-R-CIN-01'"))
                .isInstanceOf(DataIntegrityViolationException.class);
    }

    // ------------------------------------------------------------------ yardımcılar

    private List<String> reelIds(String level, String category) {
        StringBuilder query = new StringBuilder();
        if (level != null) {
            query.append("level=").append(level);
        }
        if (category != null) {
            query.append(query.isEmpty() ? "" : "&").append("category=").append(category);
        }
        List<String> out = new ArrayList<>();
        get(REELS + (query.isEmpty() ? "" : "?" + query), null).body().path("items")
                .forEach(i -> out.add(i.path("contentId").asString()));
        return out;
    }

    /**
     * Kaynak ya da üretim paketi: {@code reeller/<id>-<slug>/reel.json}; {@code errors} null ise lint raporu
     * yazılmaz (onay verilemez), 0 ise temiz rapor.
     */
    private Path reel(String folder, String id, String level, String category, Integer errors) throws IOException {
        String title = switch (category) {
            case "CIN" -> "Gişede iki bilet";
            case "SPO" -> "Antrenmandan sonra su";
            default -> "Kütüphanede kitap seçimi";
        };
        Path dir = Files.createDirectories(root.resolve("reeller").resolve(folder));
        Files.writeString(dir.resolve("reel.json"), """
                {"schemaVersion": 1, "id": "%s", "contentVersion": 1, "sourceType": "standalone",
                 "category": "%s", "categoryTr": "Kitap", "level": "%s", "titleTr": "%s",
                 "learningObjective": "Bir isteği kibarca söylemek", "family": "FAM-%s-1",
                 "duration": 10.0, "video": "%s.mp4", "poster": "%s.webp",
                 "status": "DRAFT",
                 "target": {"kind": "phrase", "en": "Two tickets, please.", "tr": "İki bilet, lütfen.",
                            "cue": "s02-02"},
                 "related": [],
                 "cues": [{"id": "s02-02", "start": 3.6, "end": 6.4, "speaker": "ALEX",
                           "text": "Two tickets, please.", "tr": "İki bilet, lütfen.", "words": []}]}"""
                .formatted(id, category, level, title, category, id, id));
        if (errors != null) {
            StringBuilder list = new StringBuilder();
            for (int i = 0; i < errors; i++) {
                list.append(i == 0 ? "" : ",").append("\"HATA [reel.cue] örnek\"");
            }
            Path lint = dir.resolve("_build/lint.json");
            Files.createDirectories(lint.getParent());
            Files.writeString(lint, """
                    {"tool": "reel-lint", "schemaVersion": 1, "contentId": "%s", "level": "%s",
                     "generatedAt": "%s", "errors": [%s], "warnings": []}"""
                    .formatted(id, level, Instant.now().toString(), list));
        }
        return dir;
    }
}
