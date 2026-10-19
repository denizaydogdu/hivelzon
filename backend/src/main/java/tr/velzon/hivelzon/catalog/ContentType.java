package tr.velzon.hivelzon.catalog;

import java.util.regex.Pattern;

/**
 * İçerik türü (H-070; reel H-094 P4). Hepsi aynı tabloda ({@code content_items}) ve aynı K-05 durum
 * makinesiyle onaylanır.
 * <ul>
 * <li>{@code EPISODE}: hikâye bölümü, kimlik {@code <SEVİYE>-<3 hane>} (A1–C1), paket yeri {@code A1-001}.</li>
 * <li>{@code BOOK}: Kitaplık kitabı, kimlik {@code <SEVİYE>-K<2 hane>} (A1–C2), paket yeri {@code _books/A1-K01}.</li>
 * <li>{@code REEL}: bağımsız konu reeli, kimlik {@code <SEVİYE>-R-<KAT>-<2 hane>} (A1-R-CIN-01; kategori
 * CIN/SPO/BOK, seviye A1–C2), paket yeri {@code _reels/A1-R-CIN-01}. Bölüme bağlı değildir (kanon maddesi istenmez).</li>
 * </ul>
 */
public enum ContentType {
    EPISODE("^(A1|A2|B1|B2|C1)-[0-9]{3}$"),
    BOOK("^(A1|A2|B1|B2|C1|C2)-K[0-9]{2}$"),
    REEL("^(A1|A2|B1|B2|C1|C2)-R-(CIN|SPO|BOK)-[0-9]{2}$");

    /** Kitap paketlerinin barındırmadaki ön eki (geliştirme sunucusu: {@code /packages/_books/<id>/}). */
    public static final String BOOKS_PREFIX = "_books";

    /** Reel paketlerinin barındırmadaki ön eki (geliştirme sunucusu: {@code /packages/_reels/<id>/}). */
    public static final String REELS_PREFIX = "_reels";

    private final Pattern id;

    ContentType(String idPattern) {
        this.id = Pattern.compile(idPattern);
    }

    public boolean matchesId(String contentId) {
        return contentId != null && id.matcher(contentId).matches();
    }

    /** {@link VideoHostingPort}'a verilen paket yeri. */
    public String packageBasePath(String contentId) {
        return switch (this) {
            case BOOK -> BOOKS_PREFIX + "/" + contentId;
            case REEL -> REELS_PREFIX + "/" + contentId;
            case EPISODE -> contentId;
        };
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
