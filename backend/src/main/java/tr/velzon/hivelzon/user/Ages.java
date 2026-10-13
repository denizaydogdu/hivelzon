package tr.velzon.hivelzon.user;

import java.time.Clock;
import java.time.ZoneOffset;

import org.springframework.stereotype.Component;

import tr.velzon.hivelzon.common.config.HivelzonProperties;

/**
 * Yalnızca doğum yılı tutulur (veri en aza indirme). Yaş = bu yıl − doğum yılı, yani kişinin bu takvim
 * yılında ulaştığı yaş. Ay/gün sorulmadığı için yılın başında 1 yaş fazla sayılabilir; bu sınır kullanıcıya
 * açık soru olarak iletildi (H-037 notları).
 */
@Component
public class Ages {

    private final Clock clock;
    private final HivelzonProperties properties;

    public Ages(Clock clock, HivelzonProperties properties) {
        this.clock = clock;
        this.properties = properties;
    }

    public int currentYear() {
        return clock.instant().atZone(ZoneOffset.UTC).getYear();
    }

    public int ageThisYear(int birthYear) {
        return currentYear() - birthYear;
    }

    public boolean isValidBirthYear(int birthYear) {
        return birthYear >= 1900 && birthYear <= currentYear();
    }

    public boolean isAllowed(int birthYear) {
        return ageThisYear(birthYear) >= properties.getAccount().getMinimumAge();
    }

    public AgeBand band(int birthYear) {
        return ageThisYear(birthYear) >= properties.getAccount().getAdultAge()
                ? AgeBand.ADULT_18_PLUS : AgeBand.TEEN_13_17;
    }
}
