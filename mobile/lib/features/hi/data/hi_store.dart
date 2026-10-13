import 'package:drift/drift.dart';

import '../../../shared/meaning/error_taxonomy.dart';
import '../../../shared/storage/app_database.dart';
import '../domain/coach_rules.dart';

/// Hi kayıt türleri (`hi_records.kind`).
abstract final class HiRecordKind {
  static const topicIntro = 'topic_intro';
  static const bridgeTask = 'bridge_task';
  static const noteRead = 'note_read';

  /// Sahne avı tamamlanan konu seti (ilerleme gibi; silmede kalır).
  static const huntDone = 'hunt_done';

  /// "Hi'nin kayıtlarını sil" işareti (H-038): hesap açıkken yazılır,
  /// eşitlemeyle öteki cihazlara gider; o ana kadarki Hi kayıtları orada da
  /// silinir. `refId` = [hiResetRef], `status` = `cleared`.
  static const hiReset = 'hi_reset';
  static const hiResetRef = 'all';
}

enum BridgeState { done, dismissed }

/// Gizlilik ekranındaki "Hi benim hakkımda ne biliyor?" sayıları.
class HiKnowledge {
  const HiKnowledge({
    required this.lookups,
    required this.errors,
    required this.errorCounts,
    required this.bridgeDone,
    required this.bridgeDismissed,
    required this.notebookItems,
    required this.reviewAnswers,
    required this.completedEpisodes,
    required this.inProgressEpisodes,
    this.speechAttempts = 0,
    this.speechFull = 0,
  });

  /// Anlamına bakılan kelime sayısı (hata olmayan olaylar).
  final int lookups;

  /// Hata türü yazılmış olaylar.
  final int errors;
  final Map<ErrorType, int> errorCounts;
  final int bridgeDone;
  final int bridgeDismissed;
  final int notebookItems;
  final int reviewAnswers;
  final int completedEpisodes;
  final int inProgressEpisodes;

  /// "Söyle" denemeleri (H-055; yalnızca sonuç saklanır) ve tam eşleşenler.
  final int speechAttempts;
  final int speechFull;
}

/// Hi-A'nın yerel kayıtları (H-048; Drift `hi_records`, `app_meta`) ve
/// önerilerin okuduğu sayılar (öğrenme olayları, defter, tekrar, ilerleme).
///
/// Zamanlar UTC. Hepsi yalnızca bu cihazda (KVKK: en az veri; dışarı gitmez).
class HiStore {
  HiStore(this._db, {Future<void>? ready, DateTime Function()? clock})
    : _ready = ready ?? Future<void>.value(),
      _clock = clock ?? (() => DateTime.now().toUtc());

  final AppDatabase _db;
  final Future<void> _ready;
  final DateTime Function() _clock;

  static const panelOpenedKey = 'hi.panelOpenedDay';

  DateTime now() => _clock().toUtc();

  // ------------------------------------------------------------ kayıtlar

  Future<Map<String, (String, DateTime)>> _records(String kind) async {
    await _ready;
    final rows = await (_db.select(
      _db.hiRecords,
    )..where((t) => t.kind.equals(kind))).get();
    return {for (final r in rows) r.refId: (r.status, r.updatedAt.toUtc())};
  }

  Future<void> _put(String kind, String id, String status) async {
    await _ready;
    await _db
        .into(_db.hiRecords)
        .insertOnConflictUpdate(
          HiRecordsCompanion.insert(
            kind: kind,
            refId: id,
            status: status,
            updatedAt: now(),
          ),
        );
  }

  /// Görülen konu tanıtımları (konu başına bir kez).
  Future<Set<String>> seenTopicIntros() async =>
      (await _records(HiRecordKind.topicIntro)).keys.toSet();

  /// İlk görülme anı korunur (ikinci çağrı bir şey değiştirmez).
  Future<void> markTopicIntroSeen(String id) async {
    await _ready;
    await _db
        .into(_db.hiRecords)
        .insert(
          HiRecordsCompanion.insert(
            kind: HiRecordKind.topicIntro,
            refId: id,
            status: 'seen',
            updatedAt: now(),
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Future<Map<String, BridgeState>> bridgeStates() async => {
    for (final e in (await _records(HiRecordKind.bridgeTask)).entries)
      e.key: e.value.$1 == 'done' ? BridgeState.done : BridgeState.dismissed,
  };

  Future<void> setBridgeState(String id, BridgeState s) =>
      _put(HiRecordKind.bridgeTask, id, s.name);

  Future<void> markHuntDone(String setId) =>
      _put(HiRecordKind.huntDone, setId, 'done');

  Future<Set<String>> huntedSets() async =>
      (await _records(HiRecordKind.huntDone)).keys.toSet();

  /// (c) önerisi açıldı: aynı türün eski hataları yeniden önerilmez.
  Future<void> markNoteRead(ErrorType type) =>
      _put(HiRecordKind.noteRead, type.code, 'read');

  Future<Map<String, DateTime>> notesReadAt() async => {
    for (final e in (await _records(HiRecordKind.noteRead)).entries)
      e.key: e.value.$2,
  };

  /// Panel bugün (yerel gün) açıldı mı: balondaki nokta için.
  Future<String?> panelOpenedDay() async {
    await _ready;
    return (await (_db.select(
      _db.appMeta,
    )..where((t) => t.key.equals(panelOpenedKey))).getSingleOrNull())?.value;
  }

  Future<void> markPanelOpened() async {
    await _ready;
    await _db
        .into(_db.appMeta)
        .insertOnConflictUpdate(
          AppMetaCompanion.insert(key: panelOpenedKey, value: localDay(now())),
        );
  }

  // ------------------------------------------------------------ okumalar

  /// Hata türü yazılmış öğrenme olayları ([since] sonrası).
  Future<List<ErrorObservation>> errorsSince(DateTime since) async {
    await _ready;
    final rows =
        await (_db.select(_db.learningEvents)..where(
              (t) =>
                  t.errorType.isNotNull() &
                  t.at.isBiggerOrEqualValue(since.toUtc()),
            ))
            .get();
    return [
      for (final r in rows)
        ErrorObservation(
          type: ErrorType.parse(r.errorType) ?? ErrorType.other,
          at: r.at.toUtc(),
          contentId: r.contentId,
          sourceId: r.sourceId,
        ),
    ];
  }

  Future<List<DateTime>> itemsCreatedSince(DateTime since) async {
    await _ready;
    final rows = await (_db.select(
      _db.notebookItems,
    )..where((t) => t.createdAt.isBiggerOrEqualValue(since.toUtc()))).get();
    return [for (final r in rows) r.createdAt.toUtc()];
  }

  Future<List<(int, DateTime)>> reviewsSince(DateTime since) async {
    await _ready;
    final rows = await (_db.select(
      _db.reviewLogs,
    )..where((t) => t.reviewedAt.isBiggerOrEqualValue(since.toUtc()))).get();
    return [for (final r in rows) (r.cardId, r.reviewedAt.toUtc())];
  }

  Future<List<DateTime>> completedSince(DateTime since) async {
    await _ready;
    final rows = await (_db.select(
      _db.userStoryProgress,
    )..where((t) => t.completedAt.isBiggerOrEqualValue(since.toUtc()))).get();
    return [
      for (final r in rows)
        if (r.completedAt != null) r.completedAt!.toUtc(),
    ];
  }

  Future<HiKnowledge> knowledge() async {
    await _ready;
    final events = await _db.select(_db.learningEvents).get();
    final counts = <ErrorType, int>{};
    var lookups = 0;
    for (final e in events) {
      final t = ErrorType.parse(e.errorType);
      if (t == null) {
        lookups++;
      } else {
        counts[t] = (counts[t] ?? 0) + 1;
      }
    }
    final bridge = await bridgeStates();
    final progress = await _db.select(_db.userStoryProgress).get();
    final items = await _db.select(_db.notebookItems).get();
    final logs = await _db.select(_db.reviewLogs).get();
    final speech = await _db.select(_db.speechAttempts).get();
    return HiKnowledge(
      speechAttempts: speech.length,
      speechFull: speech.where((r) => r.matchLevel == 'full').length,
      lookups: lookups,
      errors: events.length - lookups,
      errorCounts: counts,
      bridgeDone: bridge.values.where((s) => s == BridgeState.done).length,
      bridgeDismissed: bridge.values
          .where((s) => s == BridgeState.dismissed)
          .length,
      notebookItems: items.length,
      reviewAnswers: logs.length,
      completedEpisodes: progress.where((p) => p.status == 'COMPLETED').length,
      inProgressEpisodes: progress
          .where((p) => p.status == 'IN_PROGRESS')
          .length,
    );
  }

  // ------------------------------------------------------------ silme

  /// "Hi'nin kayıtlarını sil": öğrenme olayları, "Söyle" sonuçları (H-055),
  /// yan görev durumları, açılan notlar ve panel işareti. İlerleme, defter, tekrar geçmişi, ad ve görülen
  /// konu tanıtımları **silinmez**.
  ///
  /// Hesap açıksa (H-038) silme bütün cihazlarda geçerlidir: silme işareti
  /// ([HiRecordKind.hiReset]) yazılır, eşitlemede sunucuya gider ve sunucudaki
  /// "Söyle" sonuçlarının silinmesi kuyruğa alınır. Hesap yoksa yalnızca bu
  /// cihazdaki kayıtlar silinir; hiçbir şey dışarı gitmez.
  Future<int> deleteLearningData() async {
    await _ready;
    return _db.transaction(() async {
      final account = await (_db.select(
        _db.syncState,
      )..where((t) => t.id.equals(1))).getSingleOrNull();
      if (account?.accountUserId != null) {
        await _db
            .into(_db.hiRecords)
            .insertOnConflictUpdate(
              HiRecordsCompanion.insert(
                kind: HiRecordKind.hiReset,
                refId: HiRecordKind.hiResetRef,
                status: 'cleared',
                updatedAt: now(),
              ),
            );
        await (_db.update(_db.syncState)..where((t) => t.id.equals(1))).write(
          const SyncStateCompanion(pendingSpeechDelete: Value(true)),
        );
      }
      final events = await _db.delete(_db.learningEvents).go();
      final speech = await _db.delete(_db.speechAttempts).go();
      final records =
          await (_db.delete(_db.hiRecords)..where(
                (t) => t.kind.isIn([
                  HiRecordKind.bridgeTask,
                  HiRecordKind.noteRead,
                ]),
              ))
              .go();
      await (_db.delete(
        _db.appMeta,
      )..where((t) => t.key.equals(panelOpenedKey))).go();
      return events + speech + records;
    });
  }
}

/// Yerel gün anahtarı: `2026-10-13`.
String localDay(DateTime utc) {
  final l = utc.toLocal();
  String two(int v) => v.toString().padLeft(2, '0');
  return '${l.year}-${two(l.month)}-${two(l.day)}';
}
