package tr.velzon.hivelzon.user;

import static org.assertj.core.api.Assertions.assertThat;

import jakarta.persistence.EntityManagerFactory;

import org.hibernate.SessionFactory;
import org.hibernate.stat.Statistics;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import tr.velzon.hivelzon.support.IntegrationTest;

/**
 * N+1 denetimi: /me ve /me/consents sabit sayıda SQL ifadesiyle cevap verir (Hibernate istatistikleri).
 * Bölüm 2'deki liste uçları da aynı desenle denetlenir.
 */
class MeQueryCountTest extends IntegrationTest {

    @Autowired
    EntityManagerFactory emf;

    private Statistics stats() {
        return emf.unwrap(SessionFactory.class).getStatistics();
    }

    @Test
    void meUsesSingleStatement() {
        String access = login("sayim@example.com").text("accessToken");
        Statistics stats = stats();
        stats.clear();
        assertThat(get("/api/v1/me", access).status()).isEqualTo(200);
        assertThat(stats.getPrepareStatementCount()).isEqualTo(1);
    }

    @Test
    void consentsDoNotGrowWithHistory() {
        String access = login("sayim@example.com").text("accessToken");
        Statistics stats = stats();
        stats.clear();
        get("/api/v1/me/consents", access);
        long baseline = stats.getPrepareStatementCount();

        for (int i = 0; i < 6; i++) {
            call("POST", "/api/v1/me/consents",
                    java.util.Map.of("type", "MARKETING", "version", "taslak-1", "granted", i % 2 == 0), access);
        }
        stats.clear();
        assertThat(get("/api/v1/me/consents", access).status()).isEqualTo(200);
        assertThat(stats.getPrepareStatementCount()).isEqualTo(baseline).isLessThanOrEqualTo(2);

        stats.clear();
        assertThat(get("/api/v1/me/consents/history?size=50", access).body().path("items").size()).isEqualTo(9);
        assertThat(stats.getPrepareStatementCount()).isLessThanOrEqualTo(3); // kullanıcı + sayfa + sayım
    }
}
