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
 * Geliştirme içe aktarması (K-12: içerik kod olarak yönetilir → içe aktarma). Yapılandırılan içerik kökünden
 * okur; istekten yol almaz.
 * <ul>
 * <li>Bölüm: {@code <kök>/<id>-<slug>/_build/package/manifest.json} + {@code scenes.json} ({@code episode}) +
 * bölüm klasöründeki {@code content.json} ve varsa {@code ceviri.tr.json}.</li>
 * <li>Sezon: {@code <kök>/_evren/_build/season/S<n>/season.json}.</li>
 * </ul>
 * (content_id, content_version) ile idempotent: aynı paket ikinci kez içe aktarılınca satır değişmez.
 *
 * <p><b>Durum eşlemesi</b> (editör onay ekranı H-041 gelene kadar): {@code content.json → status} K-05
 * değerlerinden biriyse o alınır, değilse DRAFT. APPROVED / SCHEDULED / PUBLISHED yalnızca onay kanıtı varsa
 * kabul edilir: {@code humanReviewed: true} <b>ve</b> {@code ceviri.tr.json} varsa onun {@code status: APPROVED}
 * olması. Kanıt yoksa DRAFT'a düşer (rapora yazılır). Çevirinin tek başına onaylı olması bölümü onaylamaz.
 * SCHEDULED için {@code publishAt} zorunludur (yoksa DRAFT).
 */
@Service
public class CatalogImportService {

    private static final Logger log = LoggerFactory.getLogger(CatalogImportService.class);
    private static final Pattern EPISODE_DIR = Pattern.compile("^(A1|A2|B1|B2|C1)-\\d{3}-[a-z0-9-]+$");
    private static final Pattern SEASON_DIR = Pattern.compile("^S(\\d{1,3})$");

    public record ItemResult(String contentId, Integer contentVersion, String result, String status,
            List<String> notes) {
    }

    public record SeasonResult(int season, String result) {
    }

    public record ImportReport(int created, int updated, int unchanged, int skipped, List<ItemResult> items,
            List<SeasonResult> seasons) {
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
                return new ItemResult(folderId, version > 0 ? version : null, "SKIPPED", null,
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
                return new ItemResult(contentId, version, "SKIPPED", null, List.of("scenes.json episode alanları eksik"));
            }

            Instant publishAt = null;
            if (content != null && content.hasNonNull("publishAt")) {
                try {
                    publishAt = OffsetDateTime.parse(content.path("publishAt").asString()).toInstant();
                } catch (DateTimeParseException e) {
                    notes.add("publishAt okunamadı (ISO-8601 ve saat dilimi gerekir)");
                }
            }
            ContentStatus status = mapStatus(dir, content, publishAt, notes);

            String sha = HexFormat.of().formatHex(java.security.MessageDigest.getInstance("SHA-256").digest(manifestBytes));
            Long totalBytes = manifest.hasNonNull("totalBytes") ? manifest.path("totalBytes").asLong() : null;
            String renditionBytes = manifest.has("renditionBytes") ? json.writeValueAsString(manifest.get("renditionBytes")) : null;
            Integer minutes = episode.hasNonNull("estimatedMinutes") ? episode.path("estimatedMinutes").asInt()
                    : content != null && content.hasNonNull("estimatedMinutes") ? content.path("estimatedMinutes").asInt() : null;
            String slug = episode.path("slug").asString(null);

            List<Boolean> rows = jdbc.query("""
                    INSERT INTO content_items (content_id, content_version, slug, season, number, level, title, status,
                        publish_at, package_base_path, manifest_sha256, total_bytes, rendition_bytes, estimated_minutes,
                        imported_at, updated_at)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?::jsonb, ?, ?, ?)
                    ON CONFLICT (content_id, content_version) DO UPDATE SET
                        slug = EXCLUDED.slug, season = EXCLUDED.season, number = EXCLUDED.number,
                        level = EXCLUDED.level, title = EXCLUDED.title, status = EXCLUDED.status,
                        publish_at = EXCLUDED.publish_at, package_base_path = EXCLUDED.package_base_path,
                        manifest_sha256 = EXCLUDED.manifest_sha256, total_bytes = EXCLUDED.total_bytes,
                        rendition_bytes = EXCLUDED.rendition_bytes, estimated_minutes = EXCLUDED.estimated_minutes,
                        imported_at = EXCLUDED.imported_at, updated_at = EXCLUDED.updated_at
                    WHERE (content_items.slug, content_items.season, content_items.number, content_items.level,
                           content_items.title, content_items.status, content_items.publish_at,
                           content_items.package_base_path, content_items.manifest_sha256, content_items.total_bytes,
                           content_items.rendition_bytes, content_items.estimated_minutes)
                          IS DISTINCT FROM
                          (EXCLUDED.slug, EXCLUDED.season, EXCLUDED.number, EXCLUDED.level, EXCLUDED.title,
                           EXCLUDED.status, EXCLUDED.publish_at, EXCLUDED.package_base_path, EXCLUDED.manifest_sha256,
                           EXCLUDED.total_bytes, EXCLUDED.rendition_bytes, EXCLUDED.estimated_minutes)
                    RETURNING (xmax = 0) AS inserted""",
                    (rs, i) -> rs.getBoolean(1),
                    contentId, version, slug, season, number, level, title, status.name(), utc(publishAt), contentId,
                    sha, totalBytes, renditionBytes, minutes, utc(now), utc(now));
            String result = rows.isEmpty() ? "UNCHANGED" : rows.get(0) ? "CREATED" : "UPDATED";
            return new ItemResult(contentId, version, result, status.name(), notes);
        } catch (IOException | RuntimeException | java.security.NoSuchAlgorithmException e) {
            if (e instanceof org.springframework.dao.DataAccessException dae) {
                throw dae;
            }
            log.warn("Bölüm paketi okunamadı: {} ({})", folderId, e.getClass().getSimpleName());
            return new ItemResult(folderId, null, "SKIPPED", null, List.of("paket dosyaları okunamadı"));
        }
    }

    private ContentStatus mapStatus(Path dir, JsonNode content, Instant publishAt, List<String> notes) throws IOException {
        if (content == null) {
            notes.add("content.json yok: DRAFT");
            return ContentStatus.DRAFT;
        }
        String raw = content.path("status").asString("DRAFT").toUpperCase(Locale.ROOT);
        ContentStatus status;
        try {
            status = ContentStatus.valueOf(raw);
        } catch (IllegalArgumentException e) {
            notes.add("bilinmeyen durum '" + raw + "': DRAFT");
            return ContentStatus.DRAFT;
        }
        if (!status.requiresApproval()) {
            return status;
        }
        boolean humanReviewed = content.path("humanReviewed").asBoolean(false);
        Path ceviri = dir.resolve("ceviri.tr.json");
        boolean translationOk = !Files.isRegularFile(ceviri)
                || "APPROVED".equals(json.readTree(Files.readAllBytes(ceviri)).path("status").asString(""));
        if (!humanReviewed || !translationOk) {
            notes.add(status + " için onay kanıtı yok (humanReviewed ve çeviri onayı gerekir): DRAFT");
            return ContentStatus.DRAFT;
        }
        if (status == ContentStatus.SCHEDULED && publishAt == null) {
            notes.add("SCHEDULED için publishAt gerekir: DRAFT");
            return ContentStatus.DRAFT;
        }
        return status;
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
