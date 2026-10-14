package tr.velzon.hivelzon.catalog;

import java.util.regex.Pattern;

/**
 * İçerik türü (H-070). İkisi de aynı tabloda ({@code content_items}) ve aynı K-05 durum makinesiyle onaylanır.
 * <ul>
 * <li>{@code EPISODE}: hikâye bölümü, kimlik {@code <SEVİYE>-<3 hane>} (A1–C1), paket yeri {@code A1-001}.</li>
 * <li>{@code BOOK}: Kitaplık kitabı, kimlik {@code <SEVİYE>-K<2 hane>} (A1–C2), paket yeri {@code _books/A1-K01}.</li>
 * </ul>
 */
public enum ContentType {
    EPISODE("^(A1|A2|B1|B2|C1)-[0-9]{3}$"),
    BOOK("^(A1|A2|B1|B2|C1|C2)-K[0-9]{2}$");

    /** Kitap paketlerinin barındırmadaki ön eki (geliştirme sunucusu: {@code /packages/_books/<id>/}). */
    public static final String BOOKS_PREFIX = "_books";

    private final Pattern id;

    ContentType(String idPattern) {
        this.id = Pattern.compile(idPattern);
    }

    public boolean matchesId(String contentId) {
        return contentId != null && id.matcher(contentId).matches();
    }

    /** {@link VideoHostingPort}'a verilen paket yeri. */
    public String packageBasePath(String contentId) {
        return this == BOOK ? BOOKS_PREFIX + "/" + contentId : contentId;
    }

    /** Kimliğin türü; ikisine de uymuyorsa {@code null}. */
    public static ContentType ofId(String contentId) {
        for (ContentType t : values()) {
            if (t.matchesId(contentId)) {
                return t;
            }
        }
        return null;
    }
}
