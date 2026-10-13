package tr.velzon.hivelzon.user;

import java.util.UUID;

/**
 * Kalıcı silmede her modül kendi tablolarındaki kişisel veriyi siler. Kullanıcı satırından önce,
 * aynı işlem içinde çağrılır; tekrar çağrılması zararsız olmalıdır (idempotent).
 */
public interface UserDataPurger {

    void purgeUserData(UUID userId);
}
