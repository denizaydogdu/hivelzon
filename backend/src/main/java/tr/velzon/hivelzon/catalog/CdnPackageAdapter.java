package tr.velzon.hivelzon.catalog;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.stream.Collectors;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import tr.velzon.hivelzon.common.config.HivelzonProperties;

/**
 * Üretim paket CDN'i (H-044). JSON, görsel, ses ve kaynak videolar Bunny
 * Storage + Pull Zone gibi bir dosya CDN'inde değişmez sürüm klasörlerindedir.
 * Bunny Stream video kimlikleri hesap açıldıktan sonraki yükleme katmanında
 * paketlere işlenir; bu adaptör sır ya da yönetim API'si kullanmaz.
 */
@Component
@ConditionalOnProperty(name = "hivelzon.media.provider", havingValue = "cdn")
public class CdnPackageAdapter implements VideoHostingPort {

    private final String base;

    public CdnPackageAdapter(HivelzonProperties properties) {
        String value = properties.getMedia().getCdnBaseUrl();
        this.base = value.endsWith("/") ? value : value + "/";
    }

    @Override
    public String packageBaseUrl(String packageBasePath) {
        return base + encodePath(packageBasePath) + "/";
    }

    @Override
    public String packageBaseUrl(String packageBasePath, int contentVersion) {
        if (contentVersion < 1) {
            throw new IllegalArgumentException("contentVersion en az 1 olmalı");
        }
        return packageBaseUrl(packageBasePath) + "v" + contentVersion + "/";
    }

    private static String encodePath(String path) {
        return Arrays.stream(path.split("/"))
                .filter(segment -> !segment.isEmpty())
                .map(segment -> URLEncoder.encode(segment, StandardCharsets.UTF_8).replace("+", "%20"))
                .collect(Collectors.joining("/"));
    }
}
