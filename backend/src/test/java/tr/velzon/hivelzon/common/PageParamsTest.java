package tr.velzon.hivelzon.common;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;
import org.springframework.data.domain.Sort;

import tr.velzon.hivelzon.common.web.PageParams;

class PageParamsTest {

    @Test
    void clampsToSafeBounds() {
        assertThat(PageParams.of(null, null, Sort.unsorted()).getPageSize()).isEqualTo(20);
        assertThat(PageParams.of(-3, 0, Sort.unsorted()).getPageNumber()).isZero();
        assertThat(PageParams.of(2, 500, Sort.unsorted()).getPageSize()).isEqualTo(100);
        assertThat(PageParams.of(2, 500, Sort.unsorted()).getPageNumber()).isEqualTo(2);
    }
}
