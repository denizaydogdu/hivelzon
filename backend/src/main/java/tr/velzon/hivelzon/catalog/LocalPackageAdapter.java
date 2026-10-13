package tr.velzon.hivelzon.catalog;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.stream.Collectors;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import tr.velzon.hivelzon.common.config.HivelzonProperties;

/**
 * Geliştirme adaptörü: adresler yerel içerik sunucusunu gösterir
 * ({@code tools/dev-content-server/serve.py}: {@code /packages/<contentId>/…}, {@code /packages/_season/S1/…}).
 */
@Component
@ConditionalOnProperty(name = "hivelzon.media.provider", havingValue = "local", matchIfMissing = true)
public class LocalPackageAdapter implements VideoHostingPort {

    private final String base;

    public LocalPackageAdapter(HivelzonProperties properties) {
        String b = properties.getMedia().getLocalBaseUrl();
        this.base = b.endsWith("/") ? b : b + "/";
    }

    @Override
    public String packageBaseUrl(String packageBasePath) {
        String encoded = Arrays.stream(packageBasePath.split("/"))
                .filter(s -> !s.isEmpty())
                .map(s -> URLEncoder.encode(s, StandardCharsets.UTF_8).replace("+", "%20"))
                .collect(Collectors.joining("/"));
        return base + encoded + "/";
    }
}
