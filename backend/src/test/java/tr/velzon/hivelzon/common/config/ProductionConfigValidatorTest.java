package tr.velzon.hivelzon.common.config;

import static org.assertj.core.api.Assertions.assertThatCode;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.junit.jupiter.api.Test;
import org.springframework.mock.env.MockEnvironment;

class ProductionConfigValidatorTest {

    @Test
    void developmentAllowsLocalMedia() {
        HivelzonProperties properties = properties("local", "http://127.0.0.1:8787/packages/");

        assertThatCode(() -> new ProductionConfigValidator(properties, new MockEnvironment()))
                .doesNotThrowAnyException();
    }

    @Test
    void productionRejectsLocalProvider() {
        HivelzonProperties properties = properties("local", "http://127.0.0.1:8787/packages/");

        assertThatThrownBy(() -> new ProductionConfigValidator(properties, prod()))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("HIVELZON_MEDIA_PROVIDER");
    }

    @Test
    void productionRejectsNonPublicOrNonHttpsCdn() {
        for (String value : new String[] {
                "", "http://media.hi.velzon.tr/packages/", "https://localhost/packages/",
                "https://192.168.1.10/packages/", "https://user:secret@media.hi.velzon.tr/packages/"
        }) {
            HivelzonProperties properties = properties("cdn", value);
            assertThatThrownBy(() -> new ProductionConfigValidator(properties, prod()))
                    .as(value)
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("HIVELZON_MEDIA_CDN_BASE_URL");
        }
    }

    @Test
    void productionAcceptsPublicHttpsCdnAndClosedImporter() {
        HivelzonProperties properties = properties("cdn", "https://media.hi.velzon.tr/packages/");
        properties.getCatalog().setDevImportEnabled(false);

        assertThatCode(() -> new ProductionConfigValidator(properties, prod()))
                .doesNotThrowAnyException();
    }

    @Test
    void productionRejectsOpenDevelopmentImporter() {
        HivelzonProperties properties = properties("cdn", "https://media.hi.velzon.tr/packages/");
        properties.getCatalog().setDevImportEnabled(true);

        assertThatThrownBy(() -> new ProductionConfigValidator(properties, prod()))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("HIVELZON_CATALOG_DEV_IMPORT");
    }

    private static HivelzonProperties properties(String provider, String cdnBaseUrl) {
        HivelzonProperties properties = new HivelzonProperties();
        properties.getMedia().setProvider(provider);
        properties.getMedia().setCdnBaseUrl(cdnBaseUrl);
        properties.getCatalog().setDevImportEnabled(false);
        return properties;
    }

    private static MockEnvironment prod() {
        return new MockEnvironment().withProperty("spring.profiles.active", "prod");
    }
}
