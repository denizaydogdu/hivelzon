package tr.velzon.hivelzon.catalog;

import java.util.List;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import tr.velzon.hivelzon.common.security.CurrentUser;
import tr.velzon.hivelzon.common.web.ApiException;
import tr.velzon.hivelzon.common.web.AuditContextFilter;
import tr.velzon.hivelzon.common.web.ErrorCode;
import tr.velzon.hivelzon.user.Role;
import tr.velzon.hivelzon.user.User;
import tr.velzon.hivelzon.user.UserService;

/**
 * Editör onay uçları (H-041). {@code /api/v1/admin/**} SecurityConfig'te EDITOR/ADMIN ister; ayrıca rol
 * veritabanından yeniden denetlenir (rolü geri alınan editörün belirteci 15 dk daha geçerli olabilir).
 * Bütün ortamlarda açıktır (prod dahil); içe aktarma ise yalnızca prod dışında ({@link AdminCatalogController}).
 */
@RestController
@RequestMapping("/api/v1/admin/content")
class AdminContentController {

    private final EditorialService editorial;
    private final UserService users;

    AdminContentController(EditorialService editorial, UserService users) {
        this.editorial = editorial;
        this.users = users;
    }

    @GetMapping("/items")
    List<EditorialService.AdminItem> items(@AuthenticationPrincipal Jwt jwt,
            @RequestParam(required = false) Integer season) {
        requireEditor(jwt);
        return editorial.list(season);
    }

    @GetMapping("/items/{contentId}/versions/{version}")
    EditorialService.AdminItemDetail item(@AuthenticationPrincipal Jwt jwt, @PathVariable String contentId,
            @PathVariable int version) {
        requireEditor(jwt);
        return editorial.detail(contentId, version);
    }

    @PostMapping("/items/{contentId}/versions/{version}/transitions")
    EditorialService.AdminItemDetail transition(@AuthenticationPrincipal Jwt jwt, @PathVariable String contentId,
            @PathVariable int version, @RequestBody EditorialService.TransitionRequest body,
            HttpServletRequest request) {
        User editor = requireEditor(jwt);
        return editorial.transition(editor.getId(), AuditContextFilter.from(request), contentId, version, body);
    }

    private User requireEditor(Jwt jwt) {
        User user = users.requireActive(CurrentUser.from(jwt).id());
        if (user.getRole() != Role.EDITOR && user.getRole() != Role.ADMIN) {
            throw new ApiException(ErrorCode.FORBIDDEN);
        }
        return user;
    }
}
