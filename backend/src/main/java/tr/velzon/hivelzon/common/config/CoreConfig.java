package tr.velzon.hivelzon.common.config;

import java.time.Clock;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;

@Configuration(proxyBeanMethods = false)
@EnableConfigurationProperties(HivelzonProperties.class)
public class CoreConfig {

    /** Bütün zaman hesapları bu saatten yapılır (UTC); testler kontrollü bir saat koyar. */
    @Bean
    Clock clock() {
        return Clock.systemUTC();
    }

    /** Zamanlanmış işler (hesap silme, temizlik). Testlerde kapalıdır; işler doğrudan çağrılır. */
    @Configuration(proxyBeanMethods = false)
    @EnableScheduling
    @ConditionalOnProperty(name = "hivelzon.jobs.enabled", havingValue = "true", matchIfMissing = true)
    static class SchedulingConfig {
    }
}
