package tr.velzon.hivelzon.catalog;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Clock;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;
import tools.jackson.databind.node.ArrayNode;
import tools.jackson.databind.node.ObjectNode;
import tr.velzon.hivelzon.common.web.ApiException;
import tr.velzon.hivelzon.common.web.ErrorCode;
import tr.velzon.hivelzon.common.web.PageParams;
import tr.velzon.hivelzon.common.web.PageResponse;

/**
 * Açık katalog (bölümler ve H-070 kitapları ayrı listelerde). Yalnızca görünür içerik döner: {@code PUBLISHED} ya da ({@code APPROVED}/{@code SCHEDULED} ve
 * {@code publish_at <= şimdi}). Aynı bölümün birden çok görünür sürümü varsa en yenisi. Her liste sabit sayıda
 * SQL ifadesiyle (N+1 yok) okunur.
 */
@Service
public class CatalogService {

    /** Görünür sürümler (bölüm başına en yeni); {@code ?} = şimdi. */
    private static final String VISIBLE = """
            SELECT DISTINCT ON (content_id) content_id, content_version, slug, season, number, level, title,
                   publish_at, package_base_path, manifest_sha256, total_bytes, rendition_bytes::text AS rendition_bytes,
                   estimated_minutes, updated_at
              FROM content_items
             WHERE content_type = 'EPISODE'
               AND (status = 'PUBLISHED' OR (status IN ('APPROVED', 'SCHEDULED') AND publish_at <= ?))
            """;

    /** Görünür kitap sürümleri (kitap başına en yeni, H-070); {@code ?} = şimdi. */
    private static final String VISIBLE_BOOKS = """
            SELECT DISTINCT ON (content_id) content_id, content_version, slug, number, level, genre, title,
                   descriptor::text AS descriptor, publish_at, package_base_path, manifest_sha256, total_bytes,
                   estimated_minutes, updated_at
              FROM content_items
             WHERE content_type = 'BOOK'
               AND (status = 'PUBLISHED' OR (status IN ('APPROVED', 'SCHEDULED') AND publish_at <= ?))
            """;
    private static final java.util.regex.Pattern LEVEL = java.util.regex.Pattern.compile("^(A1|A2|B1|B2|C1|C2)$");
    private static final java.util.regex.Pattern REEL_LEVEL = java.util.regex.Pattern.compile("^(A1|A2|B1|B2|C1|C2)$");
    private static final java.util.regex.Pattern REEL_CATEGORY = java.util.regex.Pattern.compile("^(CIN|SPO|BOK)$");

    /** Görünür reel sürümleri (reel başına en yeni, H-094 P4); {@code ?} = şimdi. */
    private static final String VISIBLE_REELS = """
            SELECT DISTINCT ON (content_id) content_id, content_version, slug, number, level, title,
                   descriptor::text AS descriptor, publish_at, package_base_path, manifest_sha256, total_bytes,
                   estimated_minutes, updated_at
              FROM content_items
             WHERE content_type = 'REEL'
               AND (status = 'PUBLISHED' OR (status IN ('APPROVED', 'SCHEDULED') AND publish_at <= ?))
            """;

    public record CatalogItem(String contentId, int contentVersion, String slug, int season, int number, String level,
            String title, Integer estimatedMinutes, Instant publishAt, String packageBaseUrl, String scenesUrl,
            String manifestUrl, String manifestSha256, Long totalBytes, JsonNode renditionBytes, Instant updatedAt) {
    }

    /**
     * Kitap kataloğu kartı (H-070): rafta gereken her şey; bölüm ve sayfalar paketteki {@code book.json} ve
     * {@code pages.json}'dadır. {@code coverUrl} paket içindeki kapak ya da {@code null}.
     */
    public record BookItem(String contentId, int contentVersion, String slug, String level, int number, String genre,
            String title, String titleTr, String blurbTr, String hookEn, JsonNode palette, String coverUrl,
            Integer wordCount, Integer pageCount, Integer chapterCount, Integer estimatedMinutes, Boolean aiGenerated,
            JsonNode grammarTopics, Instant publishAt, String packageBaseUrl, String bookUrl, String pagesUrl,
            String manifestUrl, String manifestSha256, Long totalBytes, Instant updatedAt) {
    }

    /**
     * Reel kataloğu kartı (H-094 P4): Keşfet'in "Bugün"ü için gereken katalog küçük verisi. Altyazı,
     * soru ve medya paketteki {@code reel.json} ve dosyalarındadır; {@code reelUrl} paket içindeki
     * {@code reel.json}'dır. {@code related} yalnız gerçek bağları taşır.
     */
    public record ReelItem(String contentId, int contentVersion, String slug, String level, int number,
            String category, String family, String titleTr, String title, String learningObjective, JsonNode target,
            Double duration, JsonNode related, Instant publishAt, String packageBaseUrl, String reelUrl,
            String sourceSha256, Long totalBytes, Instant updatedAt) {
    }

    private final JdbcTemplate jdbc;
    private final VideoHostingPort hosting;    private final JsonMapper json = JsonMapper.builder().build();
    private final Clock clock;

    public CatalogService(JdbcTemplate jdbc, VideoHostingPort hosting, Clock clock) {
        this.jdbc = jdbc;
        this.hosting = hosting;
        this.clock = clock;
    }

    @Transactional(readOnly = true)
    public PageResponse<CatalogItem> items(Integer season, Integer page, Integer size) {
        var pageable = PageParams.of(page, size, org.springframework.data.domain.Sort.unsorted());
        OffsetDateTime now = CatalogImportService.utc(clock.instant());
        String filter = season == null ? "" : " AND season = ?";
        Object[] args = season == null ? new Object[] {now} : new Object[] {now, season};
        Long total = jdbc.queryForObject("SELECT count(*) FROM (" + VISIBLE + filter
                + " ORDER BY content_id, content_version DESC) v", Long.class, args);
        Object[] pageArgs = season == null
                ? new Object[] {now, pageable.getPageSize(), pageable.getOffset()}
                : new Object[] {now, season, pageable.getPageSize(), pageable.getOffset()};
        List<CatalogItem> items = jdbc.query("SELECT * FROM (" + VISIBLE + filter
                + " ORDER BY content_id, content_version DESC) v ORDER BY season, number, content_id LIMIT ? OFFSET ?",
                this::mapItem, pageArgs);
        long t = total == null ? 0 : total;
        int pages = (int) ((t + pageable.getPageSize() - 1) / pageable.getPageSize());
        return new PageResponse<>(items, pageable.getPageNumber(), pageable.getPageSize(), t, pages);
    }

    /** Görünür kitaplar; isteğe bağlı seviye süzgeci. Sıra: seviye, K numarası. */
    @Transactional(readOnly = true)
    public PageResponse<BookItem> books(String level, Integer page, Integer size) {
        if (level != null && !LEVEL.matcher(level).matches()) {
            throw new ApiException(ErrorCode.VALIDATION_FAILED, Map.of("field", "level"));
        }
        var pageable = PageParams.of(page, size, org.springframework.data.domain.Sort.unsorted());
        OffsetDateTime now = CatalogImportService.utc(clock.instant());
        String filter = level == null ? "" : " AND level = ?";
        String visible = VISIBLE_BOOKS + filter + " ORDER BY content_id, content_version DESC";
        Object[] args = level == null ? new Object[] {now} : new Object[] {now, level};
        Long total = jdbc.queryForObject("SELECT count(*) FROM (" + visible + ") v", Long.class, args);
        Object[] pageArgs = level == null
                ? new Object[] {now, pageable.getPageSize(), pageable.getOffset()}
                : new Object[] {now, level, pageable.getPageSize(), pageable.getOffset()};
        List<BookItem> items = jdbc.query("SELECT * FROM (" + visible
                + ") v ORDER BY level, number, content_id LIMIT ? OFFSET ?", this::mapBook, pageArgs);
        long t = total == null ? 0 : total;
        int pages = (int) ((t + pageable.getPageSize() - 1) / pageable.getPageSize());
        return new PageResponse<>(items, pageable.getPageNumber(), pageable.getPageSize(), t, pages);
    }

    /**
     * Görünür reeller (H-094 P4); isteğe bağlı seviye (A1…C1) ve kategori (CIN/SPO/BOK) süzgeci.
     * Sıra: seviye, kategori numarası. Yalnız yayımlanmış ya da zamanı gelmiş onaylı sürümler döner.
     */
    @Transactional(readOnly = true)
    public PageResponse<ReelItem> reels(String level, String category, Integer page, Integer size) {
        if (level != null && !REEL_LEVEL.matcher(level).matches()) {
            throw new ApiException(ErrorCode.VALIDATION_FAILED, Map.of("field", "level"));
        }
        if (category != null && !REEL_CATEGORY.matcher(category).matches()) {
            throw new ApiException(ErrorCode.VALIDATION_FAILED, Map.of("field", "category"));
        }
        var pageable = PageParams.of(page, size, org.springframework.data.domain.Sort.unsorted());
        OffsetDateTime now = CatalogImportService.utc(clock.instant());
        List<Object> args = new ArrayList<>();
        args.add(now);
        List<String> where = new ArrayList<>();
        if (level != null) {
            where.add("level = ?");
            args.add(level);
        }
        if (category != null) {
            where.add("descriptor->>'category' = ?");
            args.add(category);
        }
        String filter = where.isEmpty() ? "" : " AND " + String.join(" AND ", where);
        String visible = VISIBLE_REELS + filter + " ORDER BY content_id, content_version DESC";
        Long total = jdbc.queryForObject("SELECT count(*) FROM (" + visible + ") v", Long.class,
                args.toArray());
        List<Object> pageArgs = new ArrayList<>(args);
        pageArgs.add(pageable.getPageSize());
        pageArgs.add(pageable.getOffset());
        List<ReelItem> items = jdbc.query("SELECT * FROM (" + visible
                + ") v ORDER BY level, number, content_id LIMIT ? OFFSET ?", this::mapReel,
                pageArgs.toArray());
        long t = total == null ? 0 : total;
        int pages = (int) ((t + pageable.getPageSize() - 1) / pageable.getPageSize());
        return new PageResponse<>(items, pageable.getPageNumber(), pageable.getPageSize(), t, pages);
    }

    /**
     * Sezon: season.json'un uygulamaya dönen hâli. {@code episodes[]} sezonun bütün bölüm yerleridir (harita);
     * {@code available} yalnızca görünür bölümde {@code true} ve bölümün paket bilgisi eklenir. Onaylanmamış
     * ({@code teaserStatus != APPROVED}) tanıtım cümlesi gösterilmez.
     */
    @Transactional(readOnly = true)
    public ObjectNode season(int season) {
        List<Map<String, Object>> rows = jdbc.queryForList(
                "SELECT descriptor::text AS descriptor, package_base_path, updated_at FROM catalog_seasons WHERE season = ?",
                season);
        if (rows.isEmpty()) {
            throw new ApiException(ErrorCode.NOT_FOUND);
        }
        Map<String, Object> row = rows.get(0);
        ObjectNode doc = (ObjectNode) json.readTree((String) row.get("descriptor"));
        OffsetDateTime now = CatalogImportService.utc(clock.instant());
        Map<String, CatalogItem> visible = new HashMap<>();
        for (CatalogItem item : jdbc.query(VISIBLE + " AND season = ? ORDER BY content_id, content_version DESC",
                this::mapItem, now, season)) {
            visible.put(item.contentId(), item);
        }
        String seasonPath = (String) row.get("package_base_path");
        doc.put("packageBaseUrl", hosting.packageBaseUrl(seasonPath));
        if (doc.get("episodes") instanceof ArrayNode episodes) {
            for (JsonNode e : episodes) {
                ObjectNode ep = (ObjectNode) e;
                if (!"APPROVED".equals(ep.path("teaserStatus").asString(""))) {
                    ep.remove("teaserTr");
                }
                CatalogItem item = visible.remove(ep.path("contentId").asString(""));
                ep.put("available", item != null);
                if (item != null) {
                    ep.set("item", json.valueToTree(item));
                }
            }
            // Görünür olup harita listesinde yer almayan bölüm (ör. prolog) de dönsün.
            visible.values().stream()
                    .sorted(java.util.Comparator.comparingInt(CatalogItem::number))
                    .forEach(item -> {
                        ObjectNode ep = episodes.addObject();
                        ep.put("number", item.number());
                        ep.put("contentId", item.contentId());
                        ep.put("title", item.title());
                        ep.put("available", true);
                        ep.set("item", json.valueToTree(item));
                    });
        }
        return doc;
    }

    private ReelItem mapReel(ResultSet rs, int i) throws SQLException {
        int version = rs.getInt("content_version");
        String packageUrl = hosting.packageBaseUrl(rs.getString("package_base_path"), version);
        JsonNode d = json.readTree(rs.getString("descriptor"));
        OffsetDateTime publishAt = rs.getObject("publish_at", OffsetDateTime.class);
        return new ReelItem(rs.getString("content_id"), version, rs.getString("slug"),
                rs.getString("level"), rs.getInt("number"), text(d, "category"), text(d, "family"),
                text(d, "titleTr"), rs.getString("title"), text(d, "learningObjective"), d.get("target"),
                d.hasNonNull("duration") ? d.path("duration").asDouble() : null, d.get("related"),
                publishAt == null ? null : publishAt.toInstant(), packageUrl, packageUrl + "reel.json",
                rs.getString("manifest_sha256"), (Long) rs.getObject("total_bytes"),
                rs.getObject("updated_at", OffsetDateTime.class).toInstant());
    }

    private BookItem mapBook(ResultSet rs, int i) throws SQLException {
        int version = rs.getInt("content_version");
        // Kitaplık paketleri mobilde `CONTENT_BASE_URL/packages/<id>/` sabit yolundan
        // okunur; sürümlü klasör yalnız reellerde kullanılır (H-044 notu).
        String packageUrl = hosting.packageBaseUrl(rs.getString("package_base_path"));
        JsonNode d = json.readTree(rs.getString("descriptor"));
        OffsetDateTime publishAt = rs.getObject("publish_at", OffsetDateTime.class);
        String cover = text(d, "cover");
        return new BookItem(rs.getString("content_id"), version, rs.getString("slug"),
                rs.getString("level"), rs.getInt("number"), rs.getString("genre"), rs.getString("title"),
                text(d, "titleTr"), text(d, "blurbTr"), text(d, "hookEn"), d.get("palette"),
                cover == null ? null : packageUrl + cover, integer(d, "wordCount"), integer(d, "pageCount"),
                integer(d, "chapterCount"), (Integer) rs.getObject("estimated_minutes"),
                d.hasNonNull("aiGenerated") ? d.path("aiGenerated").asBoolean() : null, d.get("grammarTopics"),
                publishAt == null ? null : publishAt.toInstant(), packageUrl, packageUrl + "book.json",
                packageUrl + "pages.json", packageUrl + "manifest.json", rs.getString("manifest_sha256"),
                (Long) rs.getObject("total_bytes"), rs.getObject("updated_at", OffsetDateTime.class).toInstant());
    }

    private static String text(JsonNode node, String field) {
        return node.hasNonNull(field) ? node.path(field).asString() : null;
    }

    private static Integer integer(JsonNode node, String field) {
        return node.hasNonNull(field) ? node.path(field).asInt() : null;
    }

    private CatalogItem mapItem(ResultSet rs, int i) throws SQLException {
        String base = rs.getString("package_base_path");
        int version = rs.getInt("content_version");
        // Bölüm paketleri de mobilde sabit `packages/<id>/` yolundan okunur.
        String packageUrl = hosting.packageBaseUrl(base);
        String rendition = rs.getString("rendition_bytes");
        OffsetDateTime publishAt = rs.getObject("publish_at", OffsetDateTime.class);
        Integer minutes = (Integer) rs.getObject("estimated_minutes");
        Long totalBytes = (Long) rs.getObject("total_bytes");
        return new CatalogItem(rs.getString("content_id"), version, rs.getString("slug"),
                rs.getInt("season"), rs.getInt("number"), rs.getString("level"), rs.getString("title"), minutes,
                publishAt == null ? null : publishAt.toInstant(), packageUrl, packageUrl + "scenes.json",
                packageUrl + "manifest.json", rs.getString("manifest_sha256"), totalBytes,
                rendition == null ? null : json.readTree(rendition),
                rs.getObject("updated_at", OffsetDateTime.class).toInstant());
    }
}
