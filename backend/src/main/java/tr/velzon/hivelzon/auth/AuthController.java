package tr.velzon.hivelzon.auth;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import tr.velzon.hivelzon.auth.AuthDtos.RefreshRequest;
import tr.velzon.hivelzon.auth.AuthDtos.StartRequest;
import tr.velzon.hivelzon.auth.AuthDtos.StartResponse;
import tr.velzon.hivelzon.auth.AuthDtos.TokenResponse;
import tr.velzon.hivelzon.auth.AuthDtos.VerifyRequest;
import tr.velzon.hivelzon.common.web.AuditContextFilter;

@RestController
@RequestMapping("/api/v1/auth")
class AuthController {

    private final OtpService otp;
    private final TokenService tokens;

    AuthController(OtpService otp, TokenService tokens) {
        this.otp = otp;
        this.tokens = tokens;
    }

    @PostMapping("/email/start")
    @ResponseStatus(HttpStatus.ACCEPTED)
    StartResponse start(@Valid @RequestBody StartRequest body, HttpServletRequest request) {
        return otp.start(body.email(), AuditContextFilter.from(request));
    }

    @PostMapping("/email/verify")
    TokenResponse verify(@Valid @RequestBody VerifyRequest body, HttpServletRequest request) {
        return otp.verify(body, AuditContextFilter.from(request));
    }

    @PostMapping("/refresh")
    TokenResponse refresh(@Valid @RequestBody RefreshRequest body, HttpServletRequest request) {
        return tokens.refresh(body.refreshToken(), AuditContextFilter.from(request));
    }

    @PostMapping("/logout")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    void logout(@Valid @RequestBody RefreshRequest body, HttpServletRequest request) {
        tokens.logout(body.refreshToken(), AuditContextFilter.from(request));
    }
}
