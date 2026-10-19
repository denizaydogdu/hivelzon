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
 * <li>Kitap (H-070): {@code <kitaplık kökü>/<id>-<slug>/_build/package/manifest.json} + {@code book.json}.</li>
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
    private static final Pattern BOOK_DIR = Pattern.compile("^(A1|A2|B1|B2|C1|C2)-K\\d{2}-[a-z0-9-]+$");
    /** Reel klasörü: {@code <id>-<slug>} ya da yalnız {@code <id>} (deneme paketleri). */
    private static final Pattern REEL_DIR = Pattern.compile("^((A1|A2|B1|B2|C1)-R-(CIN|SPO|BOK)-\\d{2})(-[a-z0-9-]+)?$");
    private static final java.util.Set<String> REEL_CATEGORIES = java.util.Set.of("CIN", "SPO", "BOK");
    /** Reel kataloğuna giden reel.json alanları (medya ve durum hariç). */
    private static final List<String> REEL_DESCRIPTOR_FIELDS = List.of("learningObjective", "family",
            "sourceType", "target", "duration", "related");
    private static final java.util.Set<String> GENRES = java.util.Set.of("mystery", "adventure", "humor",
            "scifi-fantasy", "everyday");
    /** Kitap kataloğuna giden book.json alanları (bölüm/sayfa listesi, anlatım ayarı ve durum hariç). */
    private static final List<String> BOOK_DESCRIPTOR_FIELDS = List.of("id", "slug", "level", "genre", "title",
            "titleTr", "blurbTr", "hookEn", "aiGenerated", "palette", "cover", "grammarTopics", "wordCount",
            "pageCount", "estimatedMinutes");
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
        Path booksRoot = Path.of(properties.getCatalog().getBooksImportRoot()).toAbsolutePath().normalize();
        if (Files.isDirectory(booksRoot)) {
            try (Stream<Path> dirs = Files.list(booksRoot)) {
                for (Path dir : dirs.filter(Files::isDirectory).sorted().toList()) {
                    if (!BOOK_DIR.matcher(dir.getFileName().toString()).matches()) {
                        continue; // _maliyet vb. kitap değil
                    }
                    Path pkg = dir.resolve("_build").resolve("package");
                    if (!Files.isRegularFile(pkg.resolve("manifest.json")) || !Files.isRegularFile(pkg.resolve("book.json"))) {
                        continue; // paket henüz üretilmemiş
                    }
                    ItemResult r = importBook(dir, pkg, now);
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
        }
        Path reelsRoot = Path.of(properties.getCatalog().getReelsImportRoot()).toAbsolutePath().normalize();
        if (Files.isDirectory(reelsRoot)) {
            try (Stream<Path> dirs = Files.list(reelsRoot)) {
                for (Path dir : dirs.filter(Files::isDirectory).sorted().toList()) {
                    if (!REEL_DIR.matcher(dir.getFileName().toString()).matches()) {
                        continue; // _maliyet vb. reel değil
                    }
                    ItemResult r = importReel(dir, now);
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
            Lint lint = readLint(dir, pkg.resolve("manifest.json"), contentId,
                    "content_lint.py --write-reports", notes);
            String translationStatus = readTranslationStatus(dir);

            String sha = HexFormat.of().formatHex(java.security.MessageDigest.getInstance("SHA-256").digest(manifestBytes));
            Long totalBytes = manifest.hasNonNull("totalBytes") ? manifest.path("totalBytes").asLong() : null;
            String renditionBytes = manifest.has("renditionBytes") ? json.writeValueAsString(manifest.get("renditionBytes")) : null;
            Integer minutes = episode.hasNonNull("estimatedMinutes") ? episode.path("estimatedMinutes").asInt()
                    : content != null && content.hasNonNull("estimatedMinutes") ? content.path("estimatedMinutes").asInt() : null;
            String slug = episode.path("slug").asString(null);

            return upsert(new Row(ContentType.EPISODE, contentId, version, slug, season, number, level, title, null,
                    null, sha, totalBytes, renditionBytes, minutes, lint, translationStatus), notes, now);
        } catch (IOException | RuntimeException | java.security.NoSuchAlgorithmException e) {
            if (e instanceof org.springframework.dao.DataAccessException dae) {
                throw dae;
            }
            log.warn("Bölüm paketi okunamadı: {} ({})", folderId, e.getClass().getSimpleName());
            return new ItemResult(folderId, null, "SKIPPED", null, null, null, List.of("paket dosyaları okunamadı"));
        }
    }

    /**
     * Kitap (H-070): {@code <kitaplar>/<id>-<slug>/_build/package/manifest.json} ({@code contentType: BOOK}) +
     * {@code book.json}; kitap klasöründeki {@code ceviri.tr.json} ve {@code _build/lint.json}
     * ({@code book_lint.py --write-reports}). {@code book.json → status} yok sayılır (durum veritabanında).
     */
    private ItemResult importBook(Path dir, Path pkg, Instant now) {
        List<String> notes = new ArrayList<>();
        String folderId = dir.getFileName().toString().substring(0, 6);
        try {
            byte[] manifestBytes = Files.readAllBytes(pkg.resolve("manifest.json"));
            JsonNode manifest = json.readTree(manifestBytes);
            JsonNode book = json.readTree(Files.readAllBytes(pkg.resolve("book.json")));

            String contentId = manifest.path("contentId").asString(null);
            int version = manifest.path("contentVersion").asInt(0);
            if (contentId == null || !contentId.equals(folderId) || !contentId.equals(book.path("id").asString(null))
                    || !"BOOK".equals(manifest.path("contentType").asString(null))
                    || version < 1 || version != book.path("contentVersion").asInt(-1)) {
                return new ItemResult(folderId, version > 0 ? version : null, "SKIPPED", null, null, null,
                        List.of("manifest, book.json ve klasör adı tutarsız (contentId/contentType/contentVersion)"));
            }
            String level = book.path("level").asString("");
            String title = book.path("title").asString("");
            String genre = book.path("genre").asString("");
            if (!contentId.startsWith(level + "-") || title.isBlank() || !GENRES.contains(genre)) {
                return new ItemResult(contentId, version, "SKIPPED", null, null, null,
                        List.of("book.json alanları eksik ya da geçersiz (level/title/genre)"));
            }
            if (book.hasNonNull("status") && !"DRAFT".equalsIgnoreCase(book.path("status").asString(""))) {
                notes.add("book.json durumu yok sayıldı: onay durumu veritabanında, editör ekranından değişir");
            }
            Lint lint = readLint(dir, pkg.resolve("manifest.json"), contentId,
                    "content_lint.py --write-reports", notes);
            String translationStatus = readTranslationStatus(dir);

            ObjectNode descriptor = json.createObjectNode();
            for (String field : BOOK_DESCRIPTOR_FIELDS) {
                if (book.has(field)) {
                    descriptor.set(field, book.get(field));
                }
            }
            descriptor.put("chapterCount", book.path("chapters").size());
            String sha = HexFormat.of().formatHex(java.security.MessageDigest.getInstance("SHA-256").digest(manifestBytes));
            Long totalBytes = manifest.hasNonNull("totalBytes") ? manifest.path("totalBytes").asLong() : null;
            Integer minutes = book.hasNonNull("estimatedMinutes")
                    ? (int) Math.ceil(book.path("estimatedMinutes").asDouble()) : null;
            int number = Integer.parseInt(contentId.substring(4));
            return upsert(new Row(ContentType.BOOK, contentId, version, book.path("slug").asString(null), null, number,
                    level, title, genre, json.writeValueAsString(descriptor), sha, totalBytes, null, minutes, lint,
                    translationStatus), notes, now);
        } catch (IOException | RuntimeException | java.security.NoSuchAlgorithmException e) {
            if (e instanceof org.springframework.dao.DataAccessException dae) {
                throw dae;
            }
            log.warn("Kitap paketi okunamadı: {} ({})", folderId, e.getClass().getSimpleName());
            return new ItemResult(folderId, null, "SKIPPED", null, null, null, List.of("paket dosyaları okunamadı"));
        }
    }

    /**
     * Reel (H-094 P4): {@code <reeller>/<id>-<slug>/} altında üretim paketi
     * {@code _build/package/reel.json} (yoksa kaynak {@code reel.json}); medya pakette kalır.
     * {@code reel.json → status} yok sayılır (durum veritabanında). Reel bölüme bağlı değildir:
     * kanon maddesi istenmez, kategori kimlikten ve dosyadan doğrulanır.
     */
    private ItemResult importReel(Path dir, Instant now) {
        List<String> notes = new ArrayList<>();
        var m = REEL_DIR.matcher(dir.getFileName().toString());
        String folderId = m.matches() ? m.group(1) : dir.getFileName().toString();
        try {
            Path pkg = dir.resolve("_build").resolve("package");
            Path reelFile = Files.isRegularFile(pkg.resolve("reel.json")) ? pkg.resolve("reel.json")
                    : dir.resolve("reel.json");
            if (!Files.isRegularFile(reelFile)) {
                return new ItemResult(folderId, null, "SKIPPED", null, null, null, List.of("reel.json yok"));
            }
            if (!reelFile.startsWith(pkg)) {
                notes.add("üretim paketi yok: kaynak reel.json kullanıldı (medya paketlenmemiş)");
            }
            byte[] bytes = Files.readAllBytes(reelFile);
            JsonNode reel = json.readTree(bytes);
            String contentId = reel.path("id").asString(null);
            int version = reel.path("contentVersion").asInt(0);
            String level = reel.path("level").asString("");
            String category = reel.path("category").asString("");
            String titleTr = reel.path("titleTr").asString("");
            String sourceType = reel.path("sourceType").asString("standalone");
            if (contentId == null || !contentId.equals(folderId) || version < 1
                    || !level.matches("A1|A2|B1|B2|C1|C2") || !contentId.startsWith(level + "-R-")
                    || !REEL_CATEGORIES.contains(category) || !contentId.contains("-R-" + category + "-")
                    || !"standalone".equals(sourceType) || titleTr.isBlank()) {
                return new ItemResult(folderId, version > 0 ? version : null, "SKIPPED", null, null, null,
                        List.of("reel.json alanları eksik ya da klasörle tutarsız "
                                + "(id/level/category/sourceType/titleTr)"));
            }
            if (reel.hasNonNull("status") && !"DRAFT".equalsIgnoreCase(reel.path("status").asString(""))) {
                notes.add("reel.json durumu yok sayıldı: onay durumu veritabanında, editör ekranından değişir");
            }
            Lint lint = readLint(dir, reelFile, contentId, "reel_lint.py --write-reports", notes);
            String translationStatus = readTranslationStatus(dir);

            ObjectNode descriptor = json.createObjectNode();
            descriptor.put("category", category);
            descriptor.put("titleTr", titleTr);
            descriptor.put("level", level);
            for (String field : REEL_DESCRIPTOR_FIELDS) {
                if (reel.has(field)) {
                    descriptor.set(field, reel.get(field));
                }
            }
            String sha = HexFormat.of().formatHex(
                    java.security.MessageDigest.getInstance("SHA-256").digest(bytes));
            int number = Integer.parseInt(contentId.substring(contentId.length() - 2));
            return upsert(new Row(ContentType.REEL, contentId, version, reel.path("slug").asString(null), null,
                    number, level, titleTr, null, json.writeValueAsString(descriptor), sha, null, null, null, lint,
                    translationStatus), notes, now);
        } catch (IOException | RuntimeException | java.security.NoSuchAlgorithmException e) {
            if (e instanceof org.springframework.dao.DataAccessException dae) {
                throw dae;
            }
            log.warn("Reel paketi okunamadı: {} ({})", folderId, e.getClass().getSimpleName());
            return new ItemResult(folderId, null, "SKIPPED", null, null, null, List.of("paket dosyaları okunamadı"));
        }
    }

    /** content_items satırının içe aktarılan alanları (durum ve yayın zamanı hariç: onlar editörün). */
    private record Row(ContentType type, String contentId, int version, String slug, Integer season, int number,
            String level, String title, String genre, String descriptor, String sha, Long totalBytes,
            String renditionBytes, Integer minutes, Lint lint, String translationStatus) {
    }

    /**
     * Yeni sürüm: lint temizse {@code IN_REVIEW}, değilse {@code DRAFT}; asla onaylı başlamaz (K-05).
     * {@code DRAFT}/{@code IN_REVIEW}: yalnızca paket bilgisi ve lint özeti güncellenir. Sonrası donmuştur.
     */
    private ItemResult upsert(Row r, List<String> notes, Instant now) {
        Integer lintErrors = r.lint() == null ? null : r.lint().errors();
        Integer lintWarnings = r.lint() == null ? null : r.lint().warnings();
        OffsetDateTime lintAt = r.lint() == null ? null : utc(r.lint().checkedAt());
        String contentId = r.contentId();
        int version = r.version();
        List<String[]> existing = jdbc.query(
                "SELECT status, manifest_sha256, content_type FROM content_items "
                        + "WHERE content_id = ? AND content_version = ? FOR UPDATE",
                (rs, i) -> new String[] {rs.getString(1), rs.getString(2), rs.getString(3)}, contentId, version);
        if (existing.isEmpty()) {
            ContentStatus initial = lintErrors != null && lintErrors == 0 ? ContentStatus.IN_REVIEW : ContentStatus.DRAFT;
            int inserted = jdbc.update("""
                    INSERT INTO content_items (content_type, content_id, content_version, slug, season, number, level,
                        title, genre, descriptor, status, package_base_path, manifest_sha256, total_bytes,
                        rendition_bytes, estimated_minutes, lint_errors, lint_warnings, lint_checked_at,
                        translation_status, imported_at, updated_at, status_changed_at)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?::jsonb, ?, ?, ?, ?, ?::jsonb, ?, ?, ?, ?, ?, ?, ?, ?)
                    ON CONFLICT (content_id, content_version) DO NOTHING""",
                    r.type().name(), contentId, version, r.slug(), r.season(), r.number(), r.level(), r.title(),
                    r.genre(), r.descriptor(), initial.name(), r.type().packageBasePath(contentId), r.sha(),
                    r.totalBytes(), r.renditionBytes(), r.minutes(), lintErrors, lintWarnings, lintAt,
                    r.translationStatus(), utc(now), utc(now), utc(now));
            if (inserted == 1) {
                return new ItemResult(contentId, version, "CREATED", initial.name(), lintErrors, lintWarnings, notes);
            }
            notes.add("eşzamanlı içe aktarma: satır başka işlemde oluştu");
            return new ItemResult(contentId, version, "SKIPPED", null, lintErrors, lintWarnings, notes);
        }
        if (!r.type().name().equals(existing.get(0)[2])) {
            notes.add("aynı kimlikte başka türde içerik var");
            return new ItemResult(contentId, version, "SKIPPED", null, lintErrors, lintWarnings, notes);
        }
        ContentStatus current = ContentStatus.valueOf(existing.get(0)[0]);
        if (!current.isEditable()) {
            // Onaylanmış (ya da kapanmış) sürüm donmuştur: paket ve lint özeti değişmez.
            if (r.sha().equals(existing.get(0)[1])) {
                return new ItemResult(contentId, version, "UNCHANGED", current.name(), lintErrors, lintWarnings,
                        notes);
            }
            notes.add(current + " sürümün paketi değişmiş: onaydan sonra paket değişmez, contentVersion artırılmalı");
            return new ItemResult(contentId, version, "SKIPPED", current.name(), lintErrors, lintWarnings, notes);
        }
        // DRAFT / IN_REVIEW: yalnızca paket bilgisi ve lint özeti güncellenir; durum ve yayın zamanı korunur.
        Object[] values = {r.slug(), r.season(), r.number(), r.level(), r.title(), r.genre(), r.descriptor(),
                r.type().packageBasePath(contentId), r.sha(), r.totalBytes(), r.renditionBytes(), r.minutes(),
                lintErrors, lintWarnings, lintAt, r.translationStatus()};
        List<Object> args = new ArrayList<>(java.util.Arrays.asList(values));
        args.addAll(java.util.Arrays.asList(utc(now), utc(now), contentId, version));
        args.addAll(java.util.Arrays.asList(values));
        int updated = jdbc.update("""
                UPDATE content_items SET slug = ?, season = ?, number = ?, level = ?, title = ?, genre = ?,
                    descriptor = ?::jsonb, package_base_path = ?, manifest_sha256 = ?, total_bytes = ?,
                    rendition_bytes = ?::jsonb, estimated_minutes = ?, lint_errors = ?, lint_warnings = ?,
                    lint_checked_at = ?, translation_status = ?, imported_at = ?, updated_at = ?
                 WHERE content_id = ? AND content_version = ?
                   AND (slug, season, number, level, title, genre, descriptor, package_base_path, manifest_sha256,
                        total_bytes, rendition_bytes, estimated_minutes, lint_errors, lint_warnings, lint_checked_at,
                        translation_status)
                       IS DISTINCT FROM
                       (?::varchar, ?::integer, ?::integer, ?::varchar, ?::varchar, ?::varchar, ?::jsonb, ?::varchar,
                        ?::varchar, ?::bigint, ?::jsonb, ?::integer, ?::integer, ?::integer, ?::timestamptz,
                        ?::varchar)""",
                args.toArray());
        return new ItemResult(contentId, version, updated == 1 ? "UPDATED" : "UNCHANGED", current.name(),
                lintErrors, lintWarnings, notes);
    }

    /**
     * {@code <bölüm>/_build/lint.json}: {@code content_lint.py --write-reports} (kitapta
     * {@code book_lint.py --write-reports}) çıktısı (tek bölüm:
     * {@code contentId}, {@code errors[]}, {@code warnings[]}, {@code generatedAt}) ya da {@code --json} raporu
     * ({@code episodes[]} içinden bu bölüm). Rapor yoksa, okunamıyorsa ya da paketten eskiyse {@code null}: onay
     * verilemez. Sunucu Python çalıştırmaz; rapor içerik hattında üretilir.
     */
    private Lint readLint(Path dir, Path packageFile, String contentId, String tool, List<String> notes) {
        Path file = dir.resolve("_build").resolve("lint.json");
        if (!Files.isRegularFile(file)) {
            notes.add("lint raporu yok (_build/lint.json): " + tool + " çalıştırılmalı");
            return null;
        }
        try {
            Instant lintTime = Files.getLastModifiedTime(file).toInstant();
            Instant packageTime = Files.getLastModifiedTime(packageFile).toInstant();
            if (lintTime.isBefore(packageTime)) {
                notes.add("lint raporu paketten eski: " + tool + " yeniden çalıştırılmalı");
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
            } else if (doc.has("books")) {
                for (JsonNode e : doc.path("books")) {
                    if (contentId.equals(e.path("bookId").asString(null))) {
                        entry = e;
                    }
                }
            } else if (doc.has("reels")) {
                for (JsonNode e : doc.path("reels")) {
                    if (contentId.equals(e.path("id").asString(null))
                            || contentId.equals(e.path("contentId").asString(null))) {
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
