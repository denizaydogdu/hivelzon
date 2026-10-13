package tr.velzon.hivelzon.fsrs;

/** 1 Again, 2 Hard, 3 Good, 4 Easy (mobil ve py-fsrs ile aynı). */
public enum FsrsRating {
    AGAIN(1),
    HARD(2),
    GOOD(3),
    EASY(4);

    private final int value;

    FsrsRating(int value) {
        this.value = value;
    }

    public int value() {
        return value;
    }

    public static FsrsRating fromValue(int v) {
        for (FsrsRating r : values()) {
            if (r.value == v) {
                return r;
            }
        }
        throw new IllegalArgumentException("unknown rating " + v);
    }
}
