package tr.velzon.hivelzon.consent;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import tr.velzon.hivelzon.common.security.CurrentUser;
import tr.velzon.hivelzon.common.web.PageResponse;
import tr.velzon.hivelzon.common.web.AuditContextFilter;
import tr.velzon.hivelzon.consent.ConsentDtos.ConsentHistoryItem;
import tr.velzon.hivelzon.consent.ConsentDtos.ConsentRequest;
import tr.velzon.hivelzon.consent.ConsentDtos.ConsentState;

@RestController
@RequestMapping("/api/v1/me/consents")
class ConsentController {

    private final ConsentService consents;

    ConsentController(ConsentService consents) {
        this.consents = consents;
    }

    @GetMapping
    List<ConsentState> current(@AuthenticationPrincipal Jwt jwt) {
        return consents.current(CurrentUser.from(jwt).id());
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    List<ConsentState> record(@AuthenticationPrincipal Jwt jwt, @Valid @RequestBody ConsentRequest body,
            HttpServletRequest request) {
        return consents.record(CurrentUser.from(jwt).id(), body, AuditContextFilter.from(request));
    }

    @GetMapping("/history")
    PageResponse<ConsentHistoryItem> history(@AuthenticationPrincipal Jwt jwt,
            @RequestParam(required = false) Integer page, @RequestParam(required = false) Integer size) {
        return consents.history(CurrentUser.from(jwt).id(), page, size);
    }
}
