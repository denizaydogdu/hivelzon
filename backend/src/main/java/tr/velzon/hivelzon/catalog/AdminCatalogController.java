package tr.velzon.hivelzon.catalog;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Profile;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import tr.velzon.hivelzon.audit.AuditAction;
import tr.velzon.hivelzon.audit.AuditService;
import tr.velzon.hivelzon.common.security.CurrentUser;
import tr.velzon.hivelzon.common.web.AuditContextFilter;
import tr.velzon.hivelzon.user.UserService;

/**
 * Geliştirme içe aktarması: yalnızca prod dışı profilde ve {@code hivelzon.catalog.dev-import-enabled=true} iken
 * vardır; EDITOR/ADMIN rolü ister (SecurityConfig: {@code /api/v1/admin/**}). Yayın onayı H-041'de.
 */
@RestController
@RequestMapping("/api/v1/admin/catalog")
@Profile("!prod")
@ConditionalOnProperty(name = "hivelzon.catalog.dev-import-enabled", havingValue = "true")
class AdminCatalogController {

    private final CatalogImportService importer;
    private final UserService users;
    private final AuditService audit;

    AdminCatalogController(CatalogImportService importer, UserService users, AuditService audit) {
        this.importer = importer;
        this.users = users;
        this.audit = audit;
    }

    @PostMapping("/import")
    CatalogImportService.ImportReport importCatalog(@AuthenticationPrincipal Jwt jwt, HttpServletRequest request) {
        CurrentUser current = CurrentUser.from(jwt);
        users.requireActive(current.id());
        CatalogImportService.ImportReport report = importer.importAll();
        audit.record(AuditAction.CATALOG_IMPORT, current.id(), AuditContextFilter.from(request),
                "c" + report.created() + ":u" + report.updated() + ":s" + report.skipped());
        return report;
    }
}
