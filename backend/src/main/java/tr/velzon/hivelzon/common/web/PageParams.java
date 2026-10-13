package tr.velzon.hivelzon.common.web;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;

/**
 * Sayfalama parametreleri: {@code page} 0'dan başlar, {@code size} varsayılan 20, en çok 100.
 * Sınır dışı değerler hata vermek yerine sınıra çekilir.
 */
public final class PageParams {

    public static final int DEFAULT_SIZE = 20;
    public static final int MAX_SIZE = 100;

    private PageParams() {
    }

    public static PageRequest of(Integer page, Integer size, Sort sort) {
        int p = page == null || page < 0 ? 0 : Math.min(page, 10_000);
        int s = size == null || size < 1 ? DEFAULT_SIZE : Math.min(size, MAX_SIZE);
        return PageRequest.of(p, s, sort);
    }
}
