import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/content/content_providers.dart';
import '../../../shared/content/content_source.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../notebook/data/notebook_store.dart';
import '../../player/data/progress_repository.dart';
import '../domain/hunt_review.dart';
import '../domain/topic_set.dart';

/// Konu setlerinin sezonu (MVP: Sezon 1).
const kTopicSetSeason = 1;

/// Defter → Konu setleri: setler ve kilit durumları (bölüm bitince açılır).
final topicSetsProvider = FutureProvider.autoDispose<List<TopicSetView>>((
  ref,
) async {
  final season = await ref.watch(seasonProvider(kTopicSetSeason).future);
  final progress = await ref.watch(progressRepositoryProvider).loadAll();
  return resolveTopicSets(season.topicSets, progress);
}, retry: (_, _) => null);

/// Bir setin tamamı.
final topicSetProvider = FutureProvider.autoDispose.family<TopicSet, String>((
  ref,
  id,
) async {
  final season = await ref.watch(seasonProvider(kTopicSetSeason).future);
  final summary = season.topicSets.where((s) => s.id == id).firstOrNull;
  if (summary == null) {
    throw ContentUnavailableException('Konu seti yok: $id');
  }
  return ref
      .watch(contentSourceProvider)
      .loadTopicSet(kTopicSetSeason, summary.path);
}, retry: (_, _) => null);

/// Defterdeki ifade anahtarları (setteki öğe "defterinde" mi).
final deckKeysProvider = FutureProvider.autoDispose<Set<String>>((ref) async {
  final entries = await ref.watch(notebookStoreProvider).entries();
  return {for (final e in entries) e.item.key};
}, retry: (_, _) => null);

/// Bölüm bitince açılan set (bölüm sonu ekranındaki satır için).
final topicSetUnlockedByProvider = FutureProvider.autoDispose
    .family<TopicSetSummary?, String>((ref, contentId) async {
      try {
        final season = await ref.watch(seasonProvider(kTopicSetSeason).future);
        return season.topicSets
            .where((s) => s.unlockAfter == contentId)
            .firstOrNull;
      } on Object catch (e) {
        debugPrint('[H051] konu seti bilgisi okunamadı: $e');
        return null;
      }
    }, retry: (_, _) => null);

final topicSetActionsProvider = Provider<TopicSetActions>(
  (ref) => TopicSetActions(ref.watch(notebookStoreProvider)),
);

/// Defter yazmaları: öğe ekleme ve sahne avı sonuçları.
class TopicSetActions {
  TopicSetActions(this._store);

  final NotebookStore _store;

  /// Öğeleri desteye ekler (var olan ifade ikinci kez eklenmez; eksik görsel
  /// ve sesi tamamlanır). Eklenen yeni ifade sayısı.
  Future<int> addToDeck(TopicSet set, Iterable<TopicSetItem> items) async {
    final now = _store.now();
    final notebook = [
      for (final it in items) set.toNotebookItem(it, createdAt: now),
    ];
    final added = await _store.addItems(notebook);
    for (final n in notebook) {
      await _store.applySetImage(n);
    }
    return added;
  }

  /// Sahne avı sonuçlarını defterdeki ifadelere pratik olarak yazar (H-089:
  /// FSRS değişmez, kanıt basamağı yazılır); defterdeki ifade sayısı.
  Future<int> recordHunt(List<HuntResult> results) async {
    final outcomes = huntOutcomes(
      results: results,
      entries: await _store.entries(),
      now: _store.now(),
    );
    for (final o in outcomes) {
      await _store.saveOutcome(o);
    }
    return outcomes.length;
  }
}
