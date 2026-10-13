package tr.velzon.hivelzon.fsrs;

/** FSRS kart durumu; sayısal değerler mobil ve py-fsrs ile aynı (1 learning, 2 review, 3 relearning). */
public enum FsrsState {
    LEARNING(1),
    REVIEW(2),
    RELEARNING(3);

    private final int value;

    FsrsState(int value) {
        this.value = value;
    }

    public int value() {
        return value;
    }

    public static FsrsState fromValue(int v) {
        for (FsrsState s : values()) {
            if (s.value == v) {
                return s;
            }
        }
        throw new IllegalArgumentException("unknown state " + v);
    }
}
