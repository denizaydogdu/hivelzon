package tr.velzon.hivelzon.common.config;

import java.time.Duration;
import java.time.Period;

import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * hiVelzon ayarları ({@code hivelzon.*}). Sırlar ({@code jwt-secret}, {@code otp-pepper}) yalnızca ortam
 * değişkeninden gelir; repoda değerleri yoktur. Bkz. {@link SecretsValidator}.
 */
@ConfigurationProperties(prefix = "hivelzon")
public class HivelzonProperties {

    private final Security security = new Security();
    private final Otp otp = new Otp();
    private final RateLimit rateLimit = new RateLimit();
    private final Account account = new Account();
    private final Consent consent = new Consent();
    private final Mail mail = new Mail();
    private final Catalog catalog = new Catalog();
    private final Media media = new Media();
    private final Sync sync = new Sync();
    private final Retention retention = new Retention();

    public Security getSecurity() { return security; }
    public Otp getOtp() { return otp; }
    public RateLimit getRateLimit() { return rateLimit; }
    public Account getAccount() { return account; }
    public Consent getConsent() { return consent; }
    public Mail getMail() { return mail; }
    public Catalog getCatalog() { return catalog; }
    public Media getMedia() { return media; }
    public Sync getSync() { return sync; }
    public Retention getRetention() { return retention; }

    public static class Security {
        /** HS256 anahtarı, Base64; en az 32 bayt. Ortam: HIVELZON_JWT_SECRET. */
        private String jwtSecret = "";
        /** E-posta, IP ve kod özetleri için HMAC anahtarı, Base64; en az 32 bayt. Ortam: HIVELZON_OTP_PEPPER. */
        private String otpPepper = "";
        private String issuer = "hivelzon";
        private Duration accessTokenTtl = Duration.ofMinutes(15);
        private Duration refreshTokenTtl = Duration.ofDays(30);
        /**
         * Hoşgörü penceresi (H-056): dönen yenileme belirteci bu süre içinde yeniden gelirse aynı halef döner
         * (ağ kopması, çift istek). Sonrası yeniden kullanım sayılır. 0: kapalı.
         */
        private Duration refreshGrace = Duration.ofSeconds(30);

        public String getJwtSecret() { return jwtSecret; }
        public void setJwtSecret(String v) { jwtSecret = v; }
        public String getOtpPepper() { return otpPepper; }
        public void setOtpPepper(String v) { otpPepper = v; }
        public String getIssuer() { return issuer; }
        public void setIssuer(String v) { issuer = v; }
        public Duration getAccessTokenTtl() { return accessTokenTtl; }
        public void setAccessTokenTtl(Duration v) { accessTokenTtl = v; }
        public Duration getRefreshTokenTtl() { return refreshTokenTtl; }
        public void setRefreshTokenTtl(Duration v) { refreshTokenTtl = v; }
        public Duration getRefreshGrace() { return refreshGrace; }
        public void setRefreshGrace(Duration v) { refreshGrace = v; }
    }

    public static class Otp {
        private Duration ttl = Duration.ofMinutes(10);
        private int maxAttempts = 5;

        public Duration getTtl() { return ttl; }
        public void setTtl(Duration v) { ttl = v; }
        public int getMaxAttempts() { return maxAttempts; }
        public void setMaxAttempts(int v) { maxAttempts = v; }
    }

    public static class RateLimit {
        private Duration window = Duration.ofHours(1);
        private int otpStartPerEmail = 5;
        private int otpStartPerIp = 20;
        private int otpVerifyPerIp = 60;
        private int refreshPerIp = 120;

        public Duration getWindow() { return window; }
        public void setWindow(Duration v) { window = v; }
        public int getOtpStartPerEmail() { return otpStartPerEmail; }
        public void setOtpStartPerEmail(int v) { otpStartPerEmail = v; }
        public int getOtpStartPerIp() { return otpStartPerIp; }
        public void setOtpStartPerIp(int v) { otpStartPerIp = v; }
        public int getOtpVerifyPerIp() { return otpVerifyPerIp; }
        public void setOtpVerifyPerIp(int v) { otpVerifyPerIp = v; }
        public int getRefreshPerIp() { return refreshPerIp; }
        public void setRefreshPerIp(int v) { refreshPerIp = v; }
    }

    public static class Account {
        private Duration deletionGracePeriod = Duration.ofDays(30);
        private int minimumAge = 13;
        private int adultAge = 18;

        public Duration getDeletionGracePeriod() { return deletionGracePeriod; }
        public void setDeletionGracePeriod(Duration v) { deletionGracePeriod = v; }
        public int getMinimumAge() { return minimumAge; }
        public void setMinimumAge(int v) { minimumAge = v; }
        public int getAdultAge() { return adultAge; }
        public void setAdultAge(int v) { adultAge = v; }
    }

    public static class Consent {
        /** Kullanım koşullarının güncel sürümü. Eski sürümü onaylamış hesap engellenmez (H-095). */
        private String termsVersion = "taslak-2";
        /** KVKK aydınlatma metninin güncel sürümü. */
        private String privacyNoticeVersion = "taslak-2";
        /** Ticari ileti izni metninin güncel sürümü. */
        private String marketingVersion = "taslak-1";

        public String getTermsVersion() { return termsVersion; }
        public void setTermsVersion(String v) { termsVersion = v; }
        public String getPrivacyNoticeVersion() { return privacyNoticeVersion; }
        public void setPrivacyNoticeVersion(String v) { privacyNoticeVersion = v; }
        public String getMarketingVersion() { return marketingVersion; }
        public void setMarketingVersion(String v) { marketingVersion = v; }
    }

    public static class Mail {
        private String from = "hiVelzon <no-reply@hi.velzon.tr>";

        public String getFrom() { return from; }
        public void setFrom(String v) { from = v; }
    }

    public static class Catalog {
        /**
         * Geliştirme içe aktarmasının okuduğu içerik kökü ({@code icerik/}): bölüm paketleri
         * {@code <kök>/<id>/_build/package/}, sezon paketleri {@code <kök>/_evren/_build/season/S<n>/}.
         */
        private String importRoot = "../icerik";
        /**
         * Kitaplık kökü ({@code kitaplar/}, H-070): kitap paketleri {@code <kök>/<id>-<slug>/_build/package/}.
         * Klasör yoksa kitaplar atlanır (bölüm içe aktarması etkilenmez).
         */
        private String booksImportRoot = "../kitaplar";
        /**
         * Reel kökü ({@code reeller/}, H-094 P4): reel paketleri {@code <kök>/<id>-<slug>/} altında
         * {@code _build/package/reel.json} (yoksa kaynak {@code reel.json}) ile okunur.
         * Klasör yoksa reeller atlanır.
         */
        private String reelsImportRoot = "../reeller";
        /** {@code POST /api/v1/admin/catalog/import} açık mı (prod'da kapalı). */
        private boolean devImportEnabled = true;
        /** Katalog cevaplarının istemcide önbellekte kalma süresi (sonra ETag ile yeniden doğrulanır). */
        private Duration cacheMaxAge = Duration.ofSeconds(60);

        public String getImportRoot() { return importRoot; }
        public void setImportRoot(String v) { importRoot = v; }
        public String getBooksImportRoot() { return booksImportRoot; }
        public void setBooksImportRoot(String v) { booksImportRoot = v; }
        public String getReelsImportRoot() { return reelsImportRoot; }
        public void setReelsImportRoot(String v) { reelsImportRoot = v; }
        public boolean isDevImportEnabled() { return devImportEnabled; }
        public void setDevImportEnabled(boolean v) { devImportEnabled = v; }
        public Duration getCacheMaxAge() { return cacheMaxAge; }
        public void setCacheMaxAge(Duration v) { cacheMaxAge = v; }
    }

    public static class Media {
        /** VideoHostingPort adaptörü: {@code local} (geliştirme) ya da {@code cdn} (üretim). */
        private String provider = "local";
        /** Yerel içerik sunucusunun paket kökü (tools/dev-content-server/serve.py). */
        private String localBaseUrl = "http://127.0.0.1:8787/packages/";
        /** Üretim paket CDN kökü (Bunny Storage + Pull Zone); yalnız genel HTTPS. */
        private String cdnBaseUrl = "";

        public String getProvider() { return provider; }
        public void setProvider(String v) { provider = v; }
        public String getLocalBaseUrl() { return localBaseUrl; }
        public void setLocalBaseUrl(String v) { localBaseUrl = v; }
        public String getCdnBaseUrl() { return cdnBaseUrl; }
        public void setCdnBaseUrl(String v) { cdnBaseUrl = v; }
    }

    public static class Sync {
        /** Bir eşitleme isteğinde en çok satır (bütün tablolar toplamı). */
        private int maxRowsPerPush = 500;
        /** {@code /api/v1/sync/push} gövde sınırı (bayt). */
        private long maxPushBytes = 1024 * 1024;
        /** Diğer {@code /api/**} uçlarının gövde sınırı (bayt). */
        private long maxDefaultBodyBytes = 64 * 1024;
        /** Çekmede sayfa başına varsayılan ve en çok satır. */
        private int pullDefaultLimit = 200;
        private int pullMaxLimit = 500;
        /** İstemci saatinin sunucudan en çok ne kadar ileride olabileceği; ötesi sunucu saatine çekilir. */
        private Duration maxClockSkew = Duration.ofMinutes(5);
        /** Saatte kullanıcı başına istek sınırları. */
        private int pushPerHour = 240;
        private int pullPerHour = 1200;
        private int ratePerHour = 2000;

        public int getMaxRowsPerPush() { return maxRowsPerPush; }
        public void setMaxRowsPerPush(int v) { maxRowsPerPush = v; }
        public long getMaxPushBytes() { return maxPushBytes; }
        public void setMaxPushBytes(long v) { maxPushBytes = v; }
        public long getMaxDefaultBodyBytes() { return maxDefaultBodyBytes; }
        public void setMaxDefaultBodyBytes(long v) { maxDefaultBodyBytes = v; }
        public int getPullDefaultLimit() { return pullDefaultLimit; }
        public void setPullDefaultLimit(int v) { pullDefaultLimit = v; }
        public int getPullMaxLimit() { return pullMaxLimit; }
        public void setPullMaxLimit(int v) { pullMaxLimit = v; }
        public Duration getMaxClockSkew() { return maxClockSkew; }
        public void setMaxClockSkew(Duration v) { maxClockSkew = v; }
        public int getPushPerHour() { return pushPerHour; }
        public void setPushPerHour(int v) { pushPerHour = v; }
        public int getPullPerHour() { return pullPerHour; }
        public void setPullPerHour(int v) { pullPerHour = v; }
        public int getRatePerHour() { return ratePerHour; }
        public void setRatePerHour(int v) { ratePerHour = v; }
    }

    /** Saklama süreleri (H-095, hukukçu cevabı 2026-10-21). */
    public static class Retention {
        /**
         * Rıza kayıtları (hesap kalıcı silindikten sonra) ve denetim kaydı (olay tarihinden) bu süre saklanır,
         * sonra silinir. Sıfır ya da negatifse temizlik hiçbir şey silmez.
         */
        private Period records = Period.ofYears(2);

        public Period getRecords() { return records; }
        public void setRecords(Period v) { records = v; }
    }
}
