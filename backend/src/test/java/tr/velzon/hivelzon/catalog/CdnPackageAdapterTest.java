package tr.velzon.hivelzon.catalog;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

import tr.velzon.hivelzon.common.config.HivelzonProperties;

class CdnPackageAdapterTest {

    @Test
    void contentVersionsUseImmutableFolders() {
        HivelzonProperties properties = new HivelzonProperties();
        properties.getMedia().setCdnBaseUrl("https://media.hi.velzon.tr/packages");
        CdnPackageAdapter adapter = new CdnPackageAdapter(properties);

        assertThat(adapter.packageBaseUrl("_reels/A1-R-CIN-01", 2))
                .isEqualTo("https://media.hi.velzon.tr/packages/_reels/A1-R-CIN-01/v2/");
        assertThat(adapter.packageBaseUrl("A1 001/özel", 12))
                .isEqualTo("https://media.hi.velzon.tr/packages/A1%20001/%C3%B6zel/v12/");
    }

    @Test
    void unversionedIndexesStayAtStablePath() {
        HivelzonProperties properties = new HivelzonProperties();
        properties.getMedia().setCdnBaseUrl("https://media.hi.velzon.tr/packages/");
        CdnPackageAdapter adapter = new CdnPackageAdapter(properties);

        assertThat(adapter.packageBaseUrl("_season/S1"))
                .isEqualTo("https://media.hi.velzon.tr/packages/_season/S1/");
    }
}
