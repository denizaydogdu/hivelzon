package tr.velzon.hivelzon.catalog;

/**
 * Medya barındırma bağlantı noktası (K-13). Katalog yalnızca paketin yerini ({@code packageBasePath}: bölüm için
 * {@code A1-001}, sezon için {@code _season/S1}) bilir; istemcinin indireceği adresi adaptör kurar.
 * Yerelde {@link LocalPackageAdapter} (geliştirme içerik sunucusu); Bunny Stream adaptörü H-044'te.
 */
public interface VideoHostingPort {

    /** Paketin kök adresi; sonu {@code /} ile biter. Paket içindeki göreli yollar buna eklenir. */
    String packageBaseUrl(String packageBasePath);

    default String fileUrl(String packageBasePath, String relativePath) {
        return packageBaseUrl(packageBasePath) + relativePath;
    }
}
