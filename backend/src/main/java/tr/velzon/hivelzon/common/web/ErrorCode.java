package tr.velzon.hivelzon.common.web;

import org.springframework.http.HttpStatus;

/**
 * Makinece okunur hata kodları. {@code detail} metni kullanıcıya gösterilebilir (sade Türkçe, "sen" dili,
 * suçlamasız; bkz. docs/ARAYUZ-METINLERI.md).
 */
public enum ErrorCode {
    VALIDATION_FAILED(HttpStatus.BAD_REQUEST, "Bilgilerde bir eksik var. Kontrol edip tekrar dene."),
    OTP_INVALID(HttpStatus.BAD_REQUEST, "Bu kod eşleşmedi. E-postandaki kodu bir daha kontrol et."),
    OTP_EXPIRED(HttpStatus.BAD_REQUEST, "Bu kodun süresi doldu. Yeni bir kod isteyebilirsin."),
    OTP_TOO_MANY_ATTEMPTS(HttpStatus.BAD_REQUEST, "Bu kod için deneme hakkın bitti. Yeni bir kod isteyebilirsin."),
    RATE_LIMITED(HttpStatus.TOO_MANY_REQUESTS, "Kısa sürede çok istek geldi. Biraz sonra tekrar dene."),
    SIGNUP_DETAILS_REQUIRED(HttpStatus.UNPROCESSABLE_CONTENT,
            "Hesabını açmak için doğum yılını yaz ve kullanım koşullarını onayla."),
    AGE_NOT_ALLOWED(HttpStatus.FORBIDDEN, "hiVelzon'u kullanmak için en az 13 yaşında olman gerekiyor."),
    CONSENT_VERSION_OUTDATED(HttpStatus.CONFLICT, "Metnin yeni bir sürümü var. Güncel metni açıp yeniden onayla."),
    REFRESH_TOKEN_INVALID(HttpStatus.UNAUTHORIZED, "Oturumun sona erdi. Yeniden giriş yapabilirsin."),
    TOKEN_REUSED(HttpStatus.UNAUTHORIZED, "Güvenliğin için oturumun kapatıldı. Yeniden giriş yapabilirsin."),
    UNAUTHORIZED(HttpStatus.UNAUTHORIZED, "Bu işlem için giriş yapman gerekiyor."),
    FORBIDDEN(HttpStatus.FORBIDDEN, "Bu işlem için iznin yok."),
    ACCOUNT_PENDING_DELETION(HttpStatus.FORBIDDEN,
            "Hesabın silinmek üzere. Devam etmek için önce hesabını geri alabilirsin."),
    REAUTH_REQUIRED(HttpStatus.FORBIDDEN, "Hesabını geri almak için e-postana gelen kodla yeniden giriş yap."),
    NOT_FOUND(HttpStatus.NOT_FOUND, "Aradığın şey bulunamadı."),
    PAYLOAD_TOO_LARGE(HttpStatus.CONTENT_TOO_LARGE,
            "Gönderilen veri çok büyük. Daha küçük parçalar hâlinde tekrar gönder."),
    SYNC_ROW_INVALID(HttpStatus.BAD_REQUEST, "Eşitlenen kayıtlardan biri geçersiz."),
    SYNC_FIELD_NOT_ALLOWED(HttpStatus.BAD_REQUEST, "Eşitlenen kayıtta izin verilmeyen bir alan var."),
    TRANSCRIPT_NOT_ALLOWED(HttpStatus.BAD_REQUEST,
            "Konuşmanın sesi ya da yazısı sunucuya gönderilmez; yalnızca sonucu eşitlenir."),
    CATALOG_IMPORT_FAILED(HttpStatus.UNPROCESSABLE_CONTENT, "İçerik paketi okunamadı. Paket dosyalarını kontrol et."),
    METHOD_NOT_ALLOWED(HttpStatus.METHOD_NOT_ALLOWED, "Bu işlem desteklenmiyor."),
    MAIL_UNAVAILABLE(HttpStatus.SERVICE_UNAVAILABLE, "Şu an e-posta gönderemedik. Biraz sonra tekrar dene."),
    INTERNAL_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "Beklenmeyen bir sorun oldu. Biraz sonra tekrar dene.");

    private final HttpStatus status;
    private final String detail;

    ErrorCode(HttpStatus status, String detail) {
        this.status = status;
        this.detail = detail;
    }

    public HttpStatus status() {
        return status;
    }

    public String detail() {
        return detail;
    }
}
