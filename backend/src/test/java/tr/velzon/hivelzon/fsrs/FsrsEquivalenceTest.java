package tr.velzon.hivelzon.fsrs;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.within;

import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.stream.Stream;

import org.junit.jupiter.api.Assumptions;
import org.junit.jupiter.api.DynamicTest;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestFactory;

import tools.jackson.databind.JsonNode;
import tools.jackson.databind.json.JsonMapper;

/**
 * py-fsrs 6.3.2 (referans, MIT) çıktısıyla eşdeğerlik (K-04). Veri: tools/fsrs-vectors/generate_vectors.py →
 * mobile/test/fixtures/fsrs_vectors.json; buraya kopyalandı (src/test/resources/fsrs/). Kopyanın mobil
 * dosyayla aynı kaldığı ayrıca denetlenir.
 */
class FsrsEquivalenceTest {

    private static final JsonMapper JSON = JsonMapper.builder().build();

    private static JsonNode doc() throws Exception {
        try (InputStream in = FsrsEquivalenceTest.class.getResourceAsStream("/fsrs/fsrs_vectors.json")) {
            return JSON.readTree(in);
        }
    }

    @Test
    void referenceParametersMatchPort() throws Exception {
        JsonNode params = doc().path("parameters");
        double[] values = new double[params.size()];
        for (int i = 0; i < values.length; i++) {
            values[i] = params.get(i).asDouble();
        }
        assertThat(values).containsExactly(FsrsScheduler.DEFAULT_PARAMETERS);
        assertThat(doc().path("pyFsrsVersion").asString()).isEqualTo("6.3.2");
    }

    @TestFactory
    Stream<DynamicTest> vectors() throws Exception {
        JsonNode doc = doc();
        double tol = doc.path("tolerance").path("relative").asDouble();
        assertThat(tol).isEqualTo(1e-9);
        List<DynamicTest> tests = new ArrayList<>();
        int[] total = {0};
        for (JsonNode c : doc.path("cases")) {
            tests.add(DynamicTest.dynamicTest(c.path("name").asString(), () -> {
                JsonNode cfg = c.path("config");
                FsrsScheduler s = new FsrsScheduler(FsrsScheduler.DEFAULT_PARAMETERS,
                        cfg.path("desiredRetention").asDouble(), seconds(cfg.path("learningStepsSeconds")),
                        seconds(cfg.path("relearningStepsSeconds")), cfg.path("maximumInterval").asInt());
                FsrsCard card = FsrsCard.newCard(Instant.parse(c.path("start").asString()));
                int i = 0;
                for (JsonNode r : c.path("reviews")) {
                    String where = c.path("name").asString() + " #" + i++;
                    Instant at = Instant.parse(r.path("reviewAt").asString());
                    double expectedR = r.path("retrievabilityBefore").asDouble();
                    assertThat(s.retrievability(card, at)).as(where + " R").isCloseTo(expectedR, within(tol));
                    card = s.review(card,
                            FsrsRating.valueOf(r.path("rating").asString().toUpperCase(Locale.ROOT)), at);
                    JsonNode e = r.path("expected");
                    assertThat(card.state().name().toLowerCase(Locale.ROOT)).as(where + " state")
                            .isEqualTo(e.path("state").asString());
                    if (e.path("step").isNull()) {
                        assertThat(card.step()).as(where + " step").isNull();
                    } else {
                        assertThat(card.step()).as(where + " step").isEqualTo(e.path("step").asInt());
                    }
                    double es = e.path("stability").asDouble();
                    double ed = e.path("difficulty").asDouble();
                    assertThat(Math.abs(card.stability() - es)).as(where + " S").isLessThanOrEqualTo(Math.abs(es) * tol);
                    assertThat(Math.abs(card.difficulty() - ed)).as(where + " D").isLessThanOrEqualTo(Math.abs(ed) * tol);
                    assertThat(card.due()).as(where + " due").isEqualTo(Instant.parse(e.path("due").asString()));
                    total[0]++;
                }
            }));
        }
        tests.add(DynamicTest.dynamicTest("toplam 159 inceleme denetlendi",
                () -> assertThat(total[0]).isEqualTo(159)));
        return tests.stream();
    }

    @Test
    void appConfigMatchesAppVectors() throws Exception {
        JsonNode app = null;
        for (JsonNode c : doc().path("cases")) {
            if (c.path("name").asString().startsWith("app:")) {
                app = c.path("config");
                break;
            }
        }
        assertThat(app).isNotNull();
        FsrsScheduler s = FsrsScheduler.hivelzon();
        assertThat(s.desiredRetention()).isEqualTo(app.path("desiredRetention").asDouble()).isEqualTo(0.90);
        assertThat(s.learningSteps()).isEqualTo(seconds(app.path("learningStepsSeconds")));
        assertThat(s.relearningSteps()).isEqualTo(seconds(app.path("relearningStepsSeconds")));
    }

    @Test
    void fixtureCopyMatchesMobileFixture() throws Exception {
        Path mobile = Path.of("..", "mobile", "test", "fixtures", "fsrs_vectors.json");
        Assumptions.assumeTrue(Files.exists(mobile), "mobil depo yanında değil");
        try (InputStream in = FsrsEquivalenceTest.class.getResourceAsStream("/fsrs/fsrs_vectors.json")) {
            assertThat(in.readAllBytes()).isEqualTo(Files.readAllBytes(mobile));
        }
    }

    @Test
    void roundHalfEvenLikePython() {
        assertThat(Stream.of(0.5, 1.5, 2.5, 2.4999, 2.5001, 3.5).map(FsrsScheduler::roundHalfEven).toList())
                .containsExactly(0L, 2L, 2L, 2L, 3L, 4L);
    }

    @Test
    void daysFloorLikePythonTimedelta() {
        assertThat(FsrsScheduler.days(Duration.ofHours(23).plusMinutes(59))).isZero();
        assertThat(FsrsScheduler.days(Duration.ofDays(1))).isEqualTo(1);
        assertThat(FsrsScheduler.days(Duration.ofSeconds(-1))).isEqualTo(-1);
    }

    @Test
    void newCardAgainThenGoodGraduatesToNextDay() {
        FsrsScheduler s = FsrsScheduler.hivelzon();
        Instant t0 = Instant.parse("2026-10-13T09:00:00Z");
        FsrsCard c = s.review(FsrsCard.newCard(t0), FsrsRating.AGAIN, t0);
        assertThat(c.state()).isEqualTo(FsrsState.LEARNING);
        assertThat(c.due()).isEqualTo(t0.plus(Duration.ofMinutes(10)));
        c = s.review(c, FsrsRating.GOOD, c.due());
        assertThat(c.state()).isEqualTo(FsrsState.REVIEW);
        assertThat(c.step()).isNull();
        assertThat(Duration.between(c.lastReview(), c.due()).toDays()).isGreaterThanOrEqualTo(1);
    }

    @Test
    void invalidParametersRejected() {
        double[] bad = FsrsScheduler.DEFAULT_PARAMETERS.clone();
        bad[4] = 11;
        org.assertj.core.api.Assertions.assertThatThrownBy(() -> new FsrsScheduler(bad, 0.9,
                List.of(Duration.ofMinutes(10)), List.of(Duration.ofMinutes(10)), 36500))
                .isInstanceOf(IllegalArgumentException.class);
    }

    private static List<Duration> seconds(JsonNode arr) {
        List<Duration> out = new ArrayList<>();
        arr.forEach(v -> out.add(Duration.ofSeconds(v.asLong())));
        return out;
    }
}
