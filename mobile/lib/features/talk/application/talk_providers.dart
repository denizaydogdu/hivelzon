import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/content/content_providers.dart';
import '../../../shared/state/safe_refresh.dart';
import '../../../shared/storage/storage_providers.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../notebook/domain/evidence_ladder.dart';
import '../../player/data/progress_repository.dart';
import '../data/talk_progress_store.dart';
import '../domain/talk_task.dart';

/// Konuş görevlerinin sezonu (MVP: Sezon 1).
const kTalkSeason = 1;

final talkProgressStoreProvider = Provider<TalkProgressStore>(
  (ref) => TalkProgressStore(
    ref.watch(appDatabaseProvider),
    ready: ref.watch(legacyImportProvider),
  ),
);

/// Sezon paketindeki `talk.json`. Pakette yoksa boş katalog (Konuş sekmesi
/// "hazırlanıyor" der); bağlantı hatası hata olarak döner ("Tekrar dene").
final talkCatalogProvider = FutureProvider.autoDispose<TalkCatalog>((
  ref,
) async {
  final season = await ref.watch(seasonProvider(kTalkSeason).future);
  final path = season.talkPath;
  if (path == null) return TalkCatalog.empty;
  return ref.watch(contentSourceProvider).loadTalk(kTalkSeason, path);
}, retry: (_, _) => null);

/// Konuş sekmesinin listesi: görevler, kilitleri ve bitenler.
final talkViewsProvider = FutureProvider.autoDispose<List<TalkTaskView>>((
  ref,
) async {
  final catalog = await ref.watch(talkCatalogProvider.future);
  final progress = await ref.watch(progressRepositoryProvider).loadAll();
  final done = await ref.watch(talkProgressStoreProvider).doneAt();
  return resolveTalkTasks(catalog, progress, done);
}, retry: (_, _) => null);

/// Tek görev (oynatma ekranı).
final talkTaskProvider = FutureProvider.autoDispose.family<TalkTask, String>((
  ref,
  id,
) async {
  final catalog = await ref.watch(talkCatalogProvider.future);
  final t = catalog.byId(id);
  if (t == null) throw StateError('Konuş görevi yok: $id');
  return t;
}, retry: (_, _) => null);

final talkActionsProvider = Provider<TalkActions>(
  (ref) => TalkActions(
    ref.watch(talkProgressStoreProvider),
    record: (phrases, stage) =>
        ref.read(notebookStoreProvider).recordPhraseUse(phrases, stage),
  ),
);

/// Konuş yazmaları. Yalnızca görev kimliği, zaman ve kanıt basamağı yazılır;
/// kullanıcının yazdığı ya da söylediği metin hiçbir yere yazılmaz.
class TalkActions {
  TalkActions(this._progress, {required this.record});

  final TalkProgressStore _progress;

  /// Kanıt yazıcı (defterdeki ifadeler; FSRS değişmez, H-089).
  final Future<int> Function(Iterable<String> phrases, EvidenceStage stage)
  record;

  /// Hedef ifadeler kullanıldı: yardımsız → kendi kullandı, seçerek ya da
  /// dizerek → yardımla yaptı. Hata akışı durdurmaz.
  Future<void> recordUse(Iterable<String> phrases, {required bool own}) async {
    if (phrases.isEmpty) return;
    try {
      await record(phrases, own ? EvidenceStage.ownUse : EvidenceStage.helped);
    } on Object catch (e) {
      debugPrint('[H090] kanıt yazılamadı: $e');
    }
  }

  Future<void> markDone(String taskId) async {
    try {
      await _progress.markDone(taskId);
    } on Object catch (e) {
      debugPrint('[H090] görev kaydı yazılamadı: $e');
    }
  }
}

/// Bitirilen görevden sonra liste ve plan yenilenir.
void refreshTalk(WidgetRef ref) => invalidateAndFlush(ref, [talkViewsProvider]);
