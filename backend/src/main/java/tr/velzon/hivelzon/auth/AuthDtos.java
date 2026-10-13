package tr.velzon.hivelzon.auth;

import java.time.Instant;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

import tr.velzon.hivelzon.user.UserStatus;

public final class AuthDtos {

    private AuthDtos() {
    }

    /** Not: {@code toString} kişisel veriyi gizler (DEBUG loglarına e-posta, kod, belirteç düşmesin). */
    public record StartRequest(@NotBlank @Size(max = 254) String email) {
        @Override
        public String toString() {
            return "StartRequest[email=***]";
        }
    }

    /** Kod gönderildi. Hesap olsun olmasın cevap aynıdır (hesap varlığı sızdırılmaz). */
    public record StartResponse(int codeValidSeconds) {
    }

    /**
     * Kodu doğrular: hesap varsa giriş, yoksa kayıt. Kayıt alanları ({@code birthYear}, {@code termsVersion},
     * {@code privacyNoticeVersion}; isteğe bağlı {@code displayName}, {@code marketing}) yalnızca kayıtta
     * gerekir. Hesap yokken eksikse kod harcanmadan {@code SIGNUP_DETAILS_REQUIRED} döner ve istemci aynı kodla
     * bilgileri ekleyip tekrar gönderir. Girişte kayıt alanları yok sayılır.
     */
    public record VerifyRequest(
            @NotBlank @Size(max = 254) String email,
            @NotBlank @Pattern(regexp = "\\d{6}") String code,
            Integer birthYear,
            @Size(min = 1, max = 40) @Pattern(regexp = "[\\p{L} .'-]+") String displayName,
            @Size(max = 64) @Pattern(regexp = "[\\p{L}\\p{N} ._'()-]*") String deviceName,
            @Size(max = 32) String termsVersion,
            @Size(max = 32) String privacyNoticeVersion,
            Boolean marketing) {

        @Override
        public String toString() {
            return "VerifyRequest[email=***, code=***, signupDetails=" + hasSignupDetails() + "]";
        }

        boolean hasSignupDetails() {
            return birthYear != null && termsVersion != null && !termsVersion.isBlank()
                    && privacyNoticeVersion != null && !privacyNoticeVersion.isBlank();
        }
    }

    public record RefreshRequest(@NotBlank @Size(max = 128) String refreshToken) {
        @Override
        public String toString() {
            return "RefreshRequest[refreshToken=***]";
        }
    }

    public record TokenResponse(
            String tokenType,
            String accessToken,
            long expiresIn,
            String refreshToken,
            long refreshExpiresIn,
            boolean newUser,
            UserStatus accountStatus,
            Instant scheduledPurgeAt) {
        @Override
        public String toString() {
            return "TokenResponse[accessToken=***, refreshToken=***, newUser=" + newUser + ", accountStatus="
                    + accountStatus + "]";
        }
    }
}
