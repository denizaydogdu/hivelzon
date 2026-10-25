package tr.velzon.hivelzon.common.config;

import static java.nio.charset.StandardCharsets.UTF_8;
import static org.assertj.core.api.Assertions.assertThat;

import java.io.InputStream;

import org.junit.jupiter.api.Test;

/** Üretim profil dosyasının sessizce bozulmaması için dosya düzeyinde kapı. */
class ProductionProfileFileTest {

    @Test
    void productionForwardsClientIpBehindProxy() throws Exception {
        assertThat(productionProfile())
                .contains("forward-headers-strategy: framework");
    }

    @Test
    void productionNeverEnablesDevelopmentImporter() throws Exception {
        assertThat(productionProfile()).contains("dev-import-enabled: false");
    }

    private static String productionProfile() throws Exception {
        try (InputStream in = ProductionProfileFileTest.class.getResourceAsStream("/application-prod.yml")) {
            assertThat(in).as("application-prod.yml sınıf yolunda olmalı").isNotNull();
            return new String(in.readAllBytes(), UTF_8);
        }
    }
}
