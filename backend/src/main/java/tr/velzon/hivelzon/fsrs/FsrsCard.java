package tr.velzon.hivelzon.fsrs;

import java.time.Instant;

/**
 * Kartın bellek durumu (değişmez). Yeni kart: LEARNING, adım 0, S ve D yok. Zamanlar UTC.
 *
 * @param step öğrenme / yeniden öğrenme adımı; REVIEW durumunda null
 */
public record FsrsCard(FsrsState state, Integer step, Double stability, Double difficulty, Instant due,
        Instant lastReview) {

    public static FsrsCard newCard(Instant due) {
        return new FsrsCard(FsrsState.LEARNING, 0, null, null, due, null);
    }

    public boolean isNew() {
        return lastReview == null;
    }
}
