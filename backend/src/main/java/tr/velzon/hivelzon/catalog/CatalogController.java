package tr.velzon.hivelzon.catalog;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HexFormat;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.http.CacheControl;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import tools.jackson.databind.json.JsonMapper;
import tr.velzon.hivelzon.common.config.HivelzonProperties;

/**
 * Açık katalog uçları (kimlik gerekmez: misafir ve hesapsız kullanıcılar da içerik görür). Cevaplar güçlü ETag
 * ve kısa {@code Cache-Control} taşır; {@code If-None-Match} eşleşirse gövdesiz {@code 304}.
 */
@RestController
@RequestMapping("/api/v1/catalog")
class CatalogController {

    private final CatalogService catalog;
    private final HivelzonProperties properties;
    private final JsonMapper json = JsonMapper.builder().build();

    CatalogController(CatalogService catalog, HivelzonProperties properties) {
        this.catalog = catalog;
        this.properties = properties;
    }

    @GetMapping("/seasons/{season}")
    ResponseEntity<String> season(@PathVariable int season, HttpServletRequest request) {
        return cached(json.writeValueAsString(catalog.season(season)), request);
    }

    @GetMapping("/items")
    ResponseEntity<String> items(@RequestParam(required = false) Integer season,
            @RequestParam(required = false) Integer page, @RequestParam(required = false) Integer size,
            HttpServletRequest request) {
        return cached(json.writeValueAsString(catalog.items(season, page, size)), request);
    }

    /** Kitaplık kataloğu (H-070); {@code level} = A1…C2 (isteğe bağlı). */
    @GetMapping("/books")
    ResponseEntity<String> books(@RequestParam(required = false) String level,
            @RequestParam(required = false) Integer page, @RequestParam(required = false) Integer size,
            HttpServletRequest request) {
        return cached(json.writeValueAsString(catalog.books(level, page, size)), request);
    }

    /**
     * Bağımsız reeller (H-094 P4); {@code level} = A1…C1, {@code category} = CIN/SPO/BOK (isteğe bağlı).
     * Yalnız yayımlanmış ya da zamanı gelmiş onaylı sürümler döner (geri çekilen görünmez).
     */
    @GetMapping("/reels")
    ResponseEntity<String> reels(@RequestParam(required = false) String level,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) Integer page, @RequestParam(required = false) Integer size,
            HttpServletRequest request) {
        return cached(json.writeValueAsString(catalog.reels(level, category, page, size)), request);
    }

    private ResponseEntity<String> cached(String body, HttpServletRequest request) {
        String etag = "\"" + sha256(body).substring(0, 32) + "\"";
        CacheControl cache = CacheControl.maxAge(properties.getCatalog().getCacheMaxAge()).cachePublic()
                .mustRevalidate();
        if (matches(request.getHeader("If-None-Match"), etag)) {
            return ResponseEntity.status(HttpStatus.NOT_MODIFIED).eTag(etag).cacheControl(cache).build();
        }
        return ResponseEntity.ok().eTag(etag).cacheControl(cache).contentType(MediaType.APPLICATION_JSON).body(body);
    }

    static boolean matches(String ifNoneMatch, String etag) {
        if (ifNoneMatch == null) {
            return false;
        }
        for (String candidate : ifNoneMatch.split(",")) {
            String c = candidate.trim();
            if (c.startsWith("W/")) {
                c = c.substring(2);
            }
            if (c.equals("*") || c.equals(etag)) {
                return true;
            }
        }
        return false;
    }

    private static String sha256(String s) {
        try {
            return HexFormat.of().formatHex(MessageDigest.getInstance("SHA-256").digest(s.getBytes(StandardCharsets.UTF_8)));
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException(e);
        }
    }
}
