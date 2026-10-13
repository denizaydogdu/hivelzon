package tr.velzon.hivelzon.user;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import tr.velzon.hivelzon.common.security.CurrentUser;
import tr.velzon.hivelzon.common.web.AuditContextFilter;

@RestController
@RequestMapping("/api/v1/me")
class MeController {

    private final UserService users;

    MeController(UserService users) {
        this.users = users;
    }

    @GetMapping
    MeResponse me(@AuthenticationPrincipal Jwt jwt) {
        return users.me(CurrentUser.from(jwt));
    }

    @DeleteMapping
    @ResponseStatus(HttpStatus.ACCEPTED)
    DeletionResponse delete(@AuthenticationPrincipal Jwt jwt, HttpServletRequest request) {
        return users.requestDeletion(CurrentUser.from(jwt), AuditContextFilter.from(request));
    }

    @PostMapping("/restore")
    MeResponse restore(@AuthenticationPrincipal Jwt jwt, HttpServletRequest request) {
        return users.restore(CurrentUser.from(jwt), AuditContextFilter.from(request));
    }
}
