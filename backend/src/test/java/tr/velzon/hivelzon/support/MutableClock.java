package tr.velzon.hivelzon.support;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.util.concurrent.atomic.AtomicReference;

/** Testlerde ileri sarılabilen saat (UTC). */
public class MutableClock extends Clock {

    public static final Instant START = Instant.parse("2026-10-13T10:00:00Z");

    private final AtomicReference<Instant> now = new AtomicReference<>(START);

    public void reset() {
        now.set(START);
    }

    public void advance(Duration duration) {
        now.updateAndGet(i -> i.plus(duration));
    }

    @Override
    public ZoneId getZone() {
        return ZoneOffset.UTC;
    }

    @Override
    public Clock withZone(ZoneId zone) {
        return this;
    }

    @Override
    public Instant instant() {
        return now.get();
    }
}
