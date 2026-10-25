package tr.velzon.hivelzon.common.config;

import java.net.URI;
import java.util.Locale;

import org.springframework.core.env.Environment;
import org.springframework.core.env.Profiles;
import org.springframework.stereotype.Component;

/** H-044: üretim profilinin yerel/güvensiz ayarlarla açılmasını engeller. */
@Component
public class ProductionConfigValidator {

    public ProductionConfigValidator(HivelzonProperties properties, Environment environment) {
        if (!environment.acceptsProfiles(Profiles.of("prod"))) {
            return;
        }
        if (!"cdn".equals(properties.getMedia().getProvider())) {
            throw new IllegalStateException(
                    "HIVELZON_MEDIA_PROVIDER prod profilinde cdn olmalı; local medya yayımlanamaz.");
        }
        if (!isPublicHttps(properties.getMedia().getCdnBaseUrl())) {
            throw new IllegalStateException(
                    "HIVELZON_MEDIA_CDN_BASE_URL kimlik bilgisi içermeyen genel bir HTTPS adresi olmalı.");
        }
        if (properties.getCatalog().isDevImportEnabled()) {
            throw new IllegalStateException(
                    "HIVELZON_CATALOG_DEV_IMPORT prod profilinde false olmalı.");
        }
    }

    static boolean isPublicHttps(String value) {
        if (value == null || value.isBlank()) return false;
        try {
            URI uri = URI.create(value);
            String host = uri.getHost();
            return "https".equalsIgnoreCase(uri.getScheme())
                    && host != null
                    && !host.isBlank()
                    && uri.getRawUserInfo() == null
                    && !isLocalHost(host);
        } catch (IllegalArgumentException ignored) {
            return false;
        }
    }

    private static boolean isLocalHost(String host) {
        String h = host.toLowerCase(Locale.ROOT);
        if (h.equals("localhost") || h.endsWith(".localhost") || h.endsWith(".local")
                || h.equals("::1") || h.equals("[::1]") || h.equals("0.0.0.0")
                || h.startsWith("127.") || h.startsWith("10.") || h.startsWith("192.168.")) {
            return true;
        }
        String[] parts = h.split("\\.");
        if (parts.length != 4) return false;
        try {
            int first = Integer.parseInt(parts[0]);
            int second = Integer.parseInt(parts[1]);
            return (first == 172 && second >= 16 && second <= 31)
                    || (first == 169 && second == 254);
        } catch (NumberFormatException ignored) {
            return false;
        }
    }
}
