package tr.velzon.hivelzon.catalog;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Editör onay ekranı (H-041): {@code src/main/resources/static/admin/} altındaki statik sayfa. Sayfa veri
 * içermez; giriş e-posta koduyla yapılır ve veriler rol isteyen {@code /api/v1/admin/**} uçlarından gelir.
 */
@Configuration(proxyBeanMethods = false)
class AdminUiConfig implements WebMvcConfigurer {

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addRedirectViewController("/admin", "/admin/index.html");
        registry.addRedirectViewController("/admin/", "/admin/index.html");
    }
}
