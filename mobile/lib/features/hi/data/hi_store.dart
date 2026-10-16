import 'package:drift/drift.dart';

import '../../../shared/meaning/error_taxonomy.dart';
import '../../../shared/storage/app_database.dart';
import '../../../shared/sync/sync_store.dart';
import '../../notebook/data/notebook_store.dart';
import '../../notebook/domain/evidence_ladder.dart';
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
    this.evidence = const [],
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

  /// Öğrenme kanıtları (H-089, H-093): ifade, basamak, ilk an; en yeniden
  /// eskiye.
  final List<HiEvidence> evidence;
}

/// Gizlilik ekranındaki tek kanıt satırı (H-093).
class HiEvidence {
  const HiEvidence({required this.text, required this.stage, required this.at});

  /// İfadenin İngilizcesi (defterde yoksa anahtardaki metin).
  final String text;
  final EvidenceStage stage;

  /// UTC.
  final DateTime at;
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

  /// Bugün geçilen öneriler (H-088; yalnızca bu cihazda, eşitlenmez).
  static const dismissedKey = 'hi.dismissedToday';

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

  /// "Başka bir öneri" ile bugün (yerel gün) geçilen önerilerin anahtarları
  /// (H-088). Ertesi gün boş döner. Değer: `gün\nanahtar\nanahtar…`.
  Future<Set<String>> dismissedToday() async {
    await _ready;
    final raw = (await (_db.select(
      _db.appMeta,
    )..where((t) => t.key.equals(dismissedKey))).getSingleOrNull())?.value;
    if (raw == null) return const {};
    final lines = raw.split('\n');
    if (lines.first != localDay(now())) return const {};
    return {
      for (final l in lines.skip(1))
        if (l.isNotEmpty) l,
    };
  }

  /// Öneriyi bugünlük geçer (idempotent: aynı anahtar bir kez yazılır).
  Future<void> dismissToday(String suggestionKey) async {
    await _ready;
    await _db.transaction(() async {
      final keys = {...await dismissedToday(), suggestionKey};
      await _db
          .into(_db.appMeta)
          .insertOnConflictUpdate(
            AppMetaCompanion.insert(
              key: dismissedKey,
              value: [localDay(now()), ...keys].join('\n'),
            ),
          );
    });
  }

  /// Kanıt basamağı satırları (basamak, ilk an) [since] sonrası (H-093,
  /// haftalık özet). Satır ifade + basamak başına tektir.
  Future<List<(EvidenceStage, DateTime)>> evidenceSince(DateTime since) async {
    await _ready;
    final rows = await (_db.select(
      _db.evidenceRecords,
    )..where((t) => t.at.isBiggerOrEqualValue(since.toUtc()))).get();
    return [
      for (final r in rows)
        if (EvidenceStage.parse(r.stage) case final s?) (s, r.at.toUtc()),
    ];
  }

  /// [since] sonrası bitirilen sahne avı var mı (günlük planın küçük görevi).
  Future<bool> huntDoneSince(DateTime since) async => (await _records(
    HiRecordKind.huntDone,
  )).values.any((r) => !r.$2.isBefore(since.toUtc()));

  /// Son kelime tekrarı etkinliğinin anı (yoksa null): hatırlama cevabı
  /// (`review_logs`) ya da tekrar oturumundaki pratik. H-089'dan beri pratik
  /// `review_logs`'a yazılmadığından anı ayrıca tutulur
  /// ([NotebookStore.lastPracticeKey]); yalnız pratik yapılıp bırakılan
  /// oturum da "bugün tekrar yapıldı" sayılır (H-093).
  Future<DateTime?> lastReviewAt() async {
    await _ready;
    final row =
        await (_db.select(_db.reviewLogs)
              ..orderBy([(t) => OrderingTerm.desc(t.reviewedAt)])
              ..limit(1))
            .getSingleOrNull();
    final recall = row?.reviewedAt.toUtc();
    final raw =
        (await (_db.select(_db.appMeta)
                  ..where((t) => t.key.equals(NotebookStore.lastPracticeKey)))
                .getSingleOrNull())
            ?.value;
    final practice = raw == null ? null : DateTime.tryParse(raw)?.toUtc();
    if (recall == null) return practice;
    if (practice == null) return recall;
    return practice.isAfter(recall) ? practice : recall;
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

  /// Hatırlama cevapları (kart, an). H-089'dan beri pratik burada yok.
  Future<List<(int, DateTime)>> reviewsSince(DateTime since) async {
    await _ready;
    final rows = await (_db.select(
      _db.reviewLogs,
    )..where((t) => t.reviewedAt.isBiggerOrEqualValue(since.toUtc()))).get();
    return [for (final r in rows) (r.cardId, r.reviewedAt.toUtc())];
  }

  /// Tekrar cevaplarının anı ve kartta geçen süre (H-060, Ana Sayfa günlük
  /// hedef halkası). Mevcut `review_logs` kaydından; yeni kayıt tutulmaz.
  ///
  /// Yalnız ölçüm başlamadan önceki geçiş tahmininde kullanılır (H-074).
  /// H-089'dan beri burada yalnız hatırlama cevapları var; pratik süresi
  /// tekrar ekranında `StudyClock` ile zaten ölçülür (H-093 denetimi), bu
  /// yüzden eksik sayılmaz.
  Future<List<(DateTime, Duration)>> reviewTimeSince(DateTime since) async {
    await _ready;
    final rows = await (_db.select(
      _db.reviewLogs,
    )..where((t) => t.reviewedAt.isBiggerOrEqualValue(since.toUtc()))).get();
    return [
      for (final r in rows)
        (r.reviewedAt.toUtc(), Duration(milliseconds: r.durationMs)),
    ];
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
    final evidenceRows = await (_db.select(
      _db.evidenceRecords,
    )..orderBy([(t) => OrderingTerm.desc(t.at)])).get();
    final texts = {for (final i in items) i.itemKey: i.textEn};
    return HiKnowledge(
      evidence: [
        for (final r in evidenceRows)
          if (EvidenceStage.parse(r.stage) case final s?)
            HiEvidence(
              text: texts[r.itemKey] ?? _keyText(r.itemKey),
              stage: s,
              at: r.at.toUtc(),
            ),
      ],
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
  /// öğrenme kanıtları (H-093; Profil'deki "Neler yapabiliyorsun" ve haftalık
  /// kanıt cümlesi boşalır), yan görev durumları, açılan notlar, panel
  /// işareti ve bugün geçilen öneriler (H-088). İlerleme, defter, tekrar
  /// geçmişi (FSRS kartı ve hatırlama cevapları), ad ve görülen konu
  /// tanıtımları **silinmez**.
  ///
  /// Hesap açıksa (H-038) silme bütün cihazlarda geçerlidir: silme işareti
  /// ([HiRecordKind.hiReset]) yazılır, eşitlemede sunucuya gider ve sunucudaki
  /// "Söyle" sonuçlarının silinmesi kuyruğa alınır. Hesap yoksa yalnızca bu
  /// cihazdaki kayıtlar silinir; hiçbir şey dışarı gitmez. Bu cihazda daha
  /// önce hesap açılmışsa silme anı saklanır ve aynı hesapla yeniden girişte
  /// işaret olarak gider (H-056; başka hesapla girişte gitmez).
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
      } else {
        // Çıkışlıyken (H-056): silme anı saklanır; aynı hesapla yeniden
        // girişte bütün cihazlara işlenir.
        await SyncStore(_db, clock: now).recordSignedOutHiReset(now());
      }
      final events = await _db.delete(_db.learningEvents).go();
      final speech = await _db.delete(_db.speechAttempts).go();
      final evidence = await _db.delete(_db.evidenceRecords).go();
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
      )..where((t) => t.key.isIn([panelOpenedKey, dismissedKey]))).go();
      return events + speech + evidence + records;
    });
  }
}

/// Defterde olmayan ifadenin anahtarından metni (`phrase|where is…` →
/// `where is…`).
String _keyText(String key) {
  final i = key.indexOf('|');
  return i < 0 ? key : key.substring(i + 1);
}

/// Yerel gün anahtarı: `2026-10-13`.
String localDay(DateTime utc) {
  final l = utc.toLocal();
  String two(int v) => v.toString().padLeft(2, '0');
  return '${l.year}-${two(l.month)}-${two(l.day)}';
}
