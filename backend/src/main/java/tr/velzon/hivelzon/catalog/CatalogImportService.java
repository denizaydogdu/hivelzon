package tr.velzon.hivelzon.catalog;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Clock;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.HexFormat;
import java.util.List;
import java.util.Locale;
import java.util.regex.Pattern;
import java.util.stream.Stream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;
import tools.jackson.databind.node.ObjectNode;
import tr.velzon.hivelzon.common.config.HivelzonProperties;
import tr.velzon.hivelzon.common.web.ApiException;
import tr.velzon.hivelzon.common.web.ErrorCode;

/**
 * Geliştirme içe aktarması (K-12: içerik kod olarak yönetilir → content-lint → içe aktarma). Yapılandırılan
 * içerik kökünden okur; istekten yol almaz.
 * <ul>
 * <li>Bölüm: {@code <kök>/<id>-<slug>/_build/package/manifest.json} + {@code scenes.json} ({@code episode}) +
 * bölüm klasöründeki {@code content.json}, varsa {@code ceviri.tr.json} ve {@code _build/lint.json}.</li>
 * <li>Sezon: {@code <kök>/_evren/_build/season/S<n>/season.json}.</li>
 * </ul>
 * (content_id, content_version) ile idempotent: aynı paket ikinci kez içe aktarılınca satır değişmez.
 *
 * <p><b>Durum veritabanındadır (H-041).</b> İçe aktarma durumu ve yayın zamanını hiç yazmaz;
 * {@code content.json → status/publishAt} yok sayılır (AI'ın yayın yetkisi yok, K-05). Yeni sürüm lint temizse
 * {@code IN_REVIEW}, değilse {@code DRAFT} başlar. {@code DRAFT}/{@code IN_REVIEW} sürümde yeniden içe aktarma
 * yalnızca paket bilgisini ve lint özetini günceller; onaylanmış ya da kapanmış sürüm donmuştur (paket değiştiyse
 * {@code SKIPPED}: yeni sürüm gerekir). Geçişler {@link EditorialService}'tedir.
 */
@Service
public class CatalogImportService {

    private static final Logger log = LoggerFactory.getLogger(CatalogImportService.class);
    private static final Pattern EPISODE_DIR = Pattern.compile("^(A1|A2|B1|B2|C1)-\\d{3}-[a-z0-9-]+$");
    private static final Pattern SEASON_DIR = Pattern.compile("^S(\\d{1,3})$");

    public record ItemResult(String contentId, Integer contentVersion, String result, String status,
            Integer lintErrors, Integer lintWarnings, List<String> notes) {
    }

    public record SeasonResult(int season, String result) {
    }

    public record ImportReport(int created, int updated, int unchanged, int skipped, List<ItemResult> items,
            List<SeasonResult> seasons) {
    }

    /** content-lint özeti: hata ve uyarı sayısı, raporun zamanı. */
    record Lint(int errors, int warnings, Instant checkedAt) {
    }

    private final JdbcTemplate jdbc;
    private final JsonMapper json;
    private final HivelzonProperties properties;
    private final Clock clock;

    public CatalogImportService(JdbcTemplate jdbc, HivelzonProperties properties, Clock clock) {
        this.jdbc = jdbc;
        this.json = JsonMapper.builder().build();
        this.properties = properties;
        this.clock = clock;
    }

    @Transactional
    public ImportReport importAll() {
        Path root = Path.of(properties.getCatalog().getImportRoot()).toAbsolutePath().normalize();
        if (!Files.isDirectory(root)) {
            log.warn("Katalog içe aktarma kökü yok: {}", root);
            throw new ApiException(ErrorCode.CATALOG_IMPORT_FAILED);
        }
        Instant now = clock.instant();
        List<ItemResult> items = new ArrayList<>();
        int created = 0;
        int updated = 0;
        int unchanged = 0;
        int skipped = 0;
        try (Stream<Path> dirs = Files.list(root)) {
            for (Path dir : dirs.filter(Files::isDirectory).sorted().toList()) {
                if (!EPISODE_DIR.matcher(dir.getFileName().toString()).matches()) {
                    continue;
                }
                Path pkg = dir.resolve("_build").resolve("package");
                if (!Files.isRegularFile(pkg.resolve("manifest.json")) || !Files.isRegularFile(pkg.resolve("scenes.json"))) {
                    continue; // paket henüz üretilmemiş: "Yakında"
                }
                ItemResult r = importEpisode(dir, pkg, now);
                items.add(r);
                switch (r.result()) {
                    case "CREATED" -> created++;
                    case "UPDATED" -> updated++;
                    case "UNCHANGED" -> unchanged++;
                    default -> skipped++;
                }
            }
        } catch (IOException e) {
            throw new ApiException(ErrorCode.CATALOG_IMPORT_FAILED);
        }
        List<SeasonResult> seasons = new ArrayList<>();
        Path seasonRoot = root.resolve("_evren").resolve("_build").resolve("season");
        if (Files.isDirectory(seasonRoot)) {
            try (Stream<Path> dirs = Files.list(seasonRoot)) {
                for (Path dir : dirs.filter(Files::isDirectory).sorted().toList()) {
                    var m = SEASON_DIR.matcher(dir.getFileName().toString());
                    if (m.matches() && Files.isRegularFile(dir.resolve("season.json"))) {
                        seasons.add(importSeason(dir, now));
                    }
                }
            } catch (IOException e) {
                throw new ApiException(ErrorCode.CATALOG_IMPORT_FAILED);
            }
        }
        return new ImportReport(created, updated, unchanged, skipped, items, seasons);
    }

    private ItemResult importEpisode(Path dir, Path pkg, Instant now) {
        List<String> notes = new ArrayList<>();
        String folderId = dir.getFileName().toString().substring(0, 6);
        try {
            byte[] manifestBytes = Files.readAllBytes(pkg.resolve("manifest.json"));
            JsonNode manifest = json.readTree(manifestBytes);
            JsonNode episode = json.readTree(Files.readAllBytes(pkg.resolve("scenes.json"))).path("episode");
            Path contentFile = dir.resolve("content.json");
            JsonNode content = Files.isRegularFile(contentFile) ? json.readTree(Files.readAllBytes(contentFile)) : null;

            String contentId = manifest.path("contentId").asString(null);
            int version = manifest.path("contentVersion").asInt(0);
            if (contentId == null || !contentId.equals(folderId) || !contentId.equals(episode.path("id").asString(null))
                    || version < 1 || version != episode.path("contentVersion").asInt(-1)) {
                return new ItemResult(folderId, version > 0 ? version : null, "SKIPPED", null, null, null,
                        List.of("manifest, scenes.json ve klasör adı tutarsız (contentId/contentVersion)"));
            }
            if (content != null && content.has("version") && content.path("version").asInt() != version) {
                notes.add("content.json sürümü paketten farklı; paket yeniden üretilmeli");
            }
            String level = episode.path("level").asString("");
            int season = episode.path("season").asInt(0);
            int number = episode.path("number").asInt(-1);
            String title = episode.path("title").asString("");
            if (season < 1 || number < 0 || title.isBlank() || !level.matches("A1|A2|B1|B2|C1")) {
                return new ItemResult(contentId, version, "SKIPPED", null, null, null,
                        List.of("scenes.json episode alanları eksik"));
            }
            if (content != null && content.hasNonNull("status")
                    && !"DRAFT".equalsIgnoreCase(content.path("status").asString(""))) {
                notes.add("content.json durumu yok sayıldı: onay durumu veritabanında, editör ekranından değişir");
            }
            Lint lint = readLint(dir, pkg, contentId, notes);
            Integer lintErrors = lint == null ? null : lint.errors();
            Integer lintWarnings = lint == null ? null : lint.warnings();
            OffsetDateTime lintAt = lint == null ? null : utc(lint.checkedAt());
            String translationStatus = readTranslationStatus(dir);

            String sha = HexFormat.of().formatHex(java.security.MessageDigest.getInstance("SHA-256").digest(manifestBytes));
            Long totalBytes = manifest.hasNonNull("totalBytes") ? manifest.path("totalBytes").asLong() : null;
            String renditionBytes = manifest.has("renditionBytes") ? json.writeValueAsString(manifest.get("renditionBytes")) : null;
            Integer minutes = episode.hasNonNull("estimatedMinutes") ? episode.path("estimatedMinutes").asInt()
                    : content != null && content.hasNonNull("estimatedMinutes") ? content.path("estimatedMinutes").asInt() : null;
            String slug = episode.path("slug").asString(null);

            List<String[]> existing = jdbc.query(
                    "SELECT status, manifest_sha256 FROM content_items WHERE content_id = ? AND content_version = ? FOR UPDATE",
                    (rs, i) -> new String[] {rs.getString(1), rs.getString(2)}, contentId, version);
            if (existing.isEmpty()) {
                // Yeni sürüm: lint temizse doğrudan incelemeye, değilse taslak. Asla onaylı başlamaz (K-05).
                ContentStatus initial = lintErrors != null && lintErrors == 0 ? ContentStatus.IN_REVIEW : ContentStatus.DRAFT;
                int inserted = jdbc.update("""
                        INSERT INTO content_items (content_id, content_version, slug, season, number, level, title, status,
                            package_base_path, manifest_sha256, total_bytes, rendition_bytes, estimated_minutes,
                            lint_errors, lint_warnings, lint_checked_at, translation_status, imported_at, updated_at,
                            status_changed_at)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?::jsonb, ?, ?, ?, ?, ?, ?, ?, ?)
                        ON CONFLICT (content_id, content_version) DO NOTHING""",
                        contentId, version, slug, season, number, level, title, initial.name(), contentId, sha,
                        totalBytes, renditionBytes, minutes, lintErrors, lintWarnings, lintAt, translationStatus,
                        utc(now), utc(now), utc(now));
                if (inserted == 1) {
                    return new ItemResult(contentId, version, "CREATED", initial.name(), lintErrors, lintWarnings, notes);
                }
                notes.add("eşzamanlı içe aktarma: satır başka işlemde oluştu");
                return new ItemResult(contentId, version, "SKIPPED", null, lintErrors, lintWarnings, notes);
            }
            ContentStatus current = ContentStatus.valueOf(existing.get(0)[0]);
            if (!current.isEditable()) {
                // Onaylanmış (ya da kapanmış) sürüm donmuştur: paket ve lint özeti değişmez.
                if (sha.equals(existing.get(0)[1])) {
                    return new ItemResult(contentId, version, "UNCHANGED", current.name(), lintErrors, lintWarnings,
                            notes);
                }
                notes.add(current + " sürümün paketi değişmiş: onaydan sonra paket değişmez, contentVersion artırılmalı");
                return new ItemResult(contentId, version, "SKIPPED", current.name(), lintErrors, lintWarnings, notes);
            }
            // DRAFT / IN_REVIEW: yalnızca paket bilgisi ve lint özeti güncellenir; durum ve yayın zamanı korunur.
            int updated = jdbc.update("""
                    UPDATE content_items SET slug = ?, season = ?, number = ?, level = ?, title = ?,
                        package_base_path = ?, manifest_sha256 = ?, total_bytes = ?, rendition_bytes = ?::jsonb,
                        estimated_minutes = ?, lint_errors = ?, lint_warnings = ?, lint_checked_at = ?,
                        translation_status = ?, imported_at = ?, updated_at = ?
                     WHERE content_id = ? AND content_version = ?
                       AND (slug, season, number, level, title, package_base_path, manifest_sha256, total_bytes,
                            rendition_bytes, estimated_minutes, lint_errors, lint_warnings, lint_checked_at,
                            translation_status)
                           IS DISTINCT FROM
                           (?::varchar, ?::integer, ?::integer, ?::varchar, ?::varchar, ?::varchar, ?::varchar,
                            ?::bigint, ?::jsonb, ?::integer, ?::integer, ?::integer, ?::timestamptz, ?::varchar)""",
                    slug, season, number, level, title, contentId, sha, totalBytes, renditionBytes, minutes,
                    lintErrors, lintWarnings, lintAt, translationStatus, utc(now), utc(now),
                    contentId, version,
                    slug, season, number, level, title, contentId, sha, totalBytes, renditionBytes, minutes,
                    lintErrors, lintWarnings, lintAt, translationStatus);
            return new ItemResult(contentId, version, updated == 1 ? "UPDATED" : "UNCHANGED", current.name(),
                    lintErrors, lintWarnings, notes);
        } catch (IOException | RuntimeException | java.security.NoSuchAlgorithmException e) {
            if (e instanceof org.springframework.dao.DataAccessException dae) {
                throw dae;
            }
            log.warn("Bölüm paketi okunamadı: {} ({})", folderId, e.getClass().getSimpleName());
            return new ItemResult(folderId, null, "SKIPPED", null, null, null, List.of("paket dosyaları okunamadı"));
        }
    }

    /**
     * {@code <bölüm>/_build/lint.json}: {@code content_lint.py --write-reports} çıktısı (tek bölüm:
     * {@code contentId}, {@code errors[]}, {@code warnings[]}, {@code generatedAt}) ya da {@code --json} raporu
     * ({@code episodes[]} içinden bu bölüm). Rapor yoksa, okunamıyorsa ya da paketten eskiyse {@code null}: onay
     * verilemez. Sunucu Python çalıştırmaz; rapor içerik hattında üretilir.
     */
    private Lint readLint(Path dir, Path pkg, String contentId, List<String> notes) {
        Path file = dir.resolve("_build").resolve("lint.json");
        if (!Files.isRegularFile(file)) {
            notes.add("lint raporu yok (_build/lint.json): content_lint.py --write-reports çalıştırılmalı");
            return null;
        }
        try {
            Instant lintTime = Files.getLastModifiedTime(file).toInstant();
            Instant packageTime = Files.getLastModifiedTime(pkg.resolve("manifest.json")).toInstant();
            if (lintTime.isBefore(packageTime)) {
                notes.add("lint raporu paketten eski: content-lint yeniden çalıştırılmalı");
                return null;
            }
            JsonNode doc = json.readTree(Files.readAllBytes(file));
            JsonNode entry = null;
            if (doc.has("episodes")) {
                for (JsonNode e : doc.path("episodes")) {
                    if (contentId.equals(e.path("contentId").asString(null))) {
                        entry = e;
                    }
                }
            } else if (contentId.equals(doc.path("contentId").asString(null))) {
                entry = doc;
            }
            if (entry == null || !entry.path("errors").isArray() || !entry.path("warnings").isArray()) {
                notes.add("lint raporu bu bölüme ait değil ya da biçimi bozuk");
                return null;
            }
            Instant checkedAt = lintTime;
            if (doc.hasNonNull("generatedAt")) {
                try {
                    checkedAt = OffsetDateTime.parse(doc.path("generatedAt").asString()).toInstant();
                } catch (DateTimeParseException ignored) {
                    // dosya zamanı kullanılır
                }
            }
            return new Lint(entry.path("errors").size(), entry.path("warnings").size(), checkedAt);
        } catch (IOException | RuntimeException e) {
            notes.add("lint raporu okunamadı");
            return null;
        }
    }

    private String readTranslationStatus(Path dir) {
        Path ceviri = dir.resolve("ceviri.tr.json");
        if (!Files.isRegularFile(ceviri)) {
            return null;
        }
        try {
            String s = json.readTree(Files.readAllBytes(ceviri)).path("status").asString("").toUpperCase(Locale.ROOT);
            return s.matches("[A-Z_]{1,16}") ? s : "UNKNOWN";
        } catch (IOException | RuntimeException e) {
            return "UNKNOWN";
        }
    }

    private SeasonResult importSeason(Path dir, Instant now) throws IOException {
        byte[] bytes = Files.readAllBytes(dir.resolve("season.json"));
        JsonNode doc = json.readTree(bytes);
        int season = doc.path("season").asInt(0);
        String expected = dir.getFileName().toString().substring(1);
        String level = doc.path("level").asString("");
        if (season < 1 || !String.valueOf(season).equals(expected) || !level.matches("A1|A2|B1|B2|C1")) {
            return new SeasonResult(season, "SKIPPED");
        }
        ObjectNode descriptor = ((ObjectNode) doc).deepCopy();
        descriptor.remove(List.of("files", "totalBytes", "renditionBytes"));
        String sha;
        try {
            sha = HexFormat.of().formatHex(java.security.MessageDigest.getInstance("SHA-256").digest(bytes));
        } catch (java.security.NoSuchAlgorithmException e) {
            throw new IllegalStateException(e);
        }
        List<Boolean> rows = jdbc.query("""
                INSERT INTO catalog_seasons (season, title, level, package_base_path, descriptor, descriptor_sha256,
                    imported_at, updated_at)
                VALUES (?, ?, ?, ?, ?::jsonb, ?, ?, ?)
                ON CONFLICT (season) DO UPDATE SET title = EXCLUDED.title, level = EXCLUDED.level,
                    package_base_path = EXCLUDED.package_base_path, descriptor = EXCLUDED.descriptor,
                    descriptor_sha256 = EXCLUDED.descriptor_sha256, imported_at = EXCLUDED.imported_at,
                    updated_at = EXCLUDED.updated_at
                WHERE catalog_seasons.descriptor_sha256 IS DISTINCT FROM EXCLUDED.descriptor_sha256
                RETURNING (xmax = 0) AS inserted""",
                (rs, i) -> rs.getBoolean(1),
                season, doc.path("title").asString("S" + season), level, "_season/S" + season,
                json.writeValueAsString(descriptor), sha, utc(now), utc(now));
        return new SeasonResult(season, rows.isEmpty() ? "UNCHANGED" : rows.get(0) ? "CREATED" : "UPDATED");
    }

    static OffsetDateTime utc(Instant i) {
        return i == null ? null : i.atOffset(ZoneOffset.UTC);
    }
}
