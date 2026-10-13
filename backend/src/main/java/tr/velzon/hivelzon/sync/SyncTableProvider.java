package tr.velzon.hivelzon.sync;

import java.util.List;

/** Modüller ({@code progress}, {@code learning}) kendi eşitlenen tablolarını bildirir. */
public interface SyncTableProvider {

    List<SyncTable> syncTables();
}
