package tr.velzon.hivelzon.sync;

import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * İtme uygulandıktan sonra, aynı işlem ve kullanıcı kilidi içinde çalışır (ör. FSRS kartlarının cevaplardan
 * yeniden hesaplanması). Döndürdüğü çatışmalar cevaba eklenir.
 */
public interface SyncPushHook {

    List<SyncDtos.Conflict> afterPush(UUID userId, Map<String, List<SyncRow>> rowsByTable);
}
