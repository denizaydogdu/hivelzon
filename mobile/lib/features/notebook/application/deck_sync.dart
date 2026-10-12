import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../shared/content/content_source.dart';
import '../../../shared/meaning/learning_event_log.dart';
import '../../../shared/progress/story_progress.dart';
import '../../player/application/player_session.dart';
import '../../player/data/progress_repository.dart';
import '../../player/domain/episode.dart';
import '../../player/domain/subtitles.dart';
import '../data/notebook_store.dart';
import '../domain/deck_builder.dart';

/// Bölüm verisini defter, ipucu panosu ve FSRS kartlarına aktarır (H-036).
///
/// - Bölüm bitince ([onEpisodeCompleted]): hedef ifadeler, bakılan kelimeler,
///   ipuçları, açık soru bağları.
/// - İpucu kartı görülünce ([onClueCard]): o kartın ipuçları.
/// - Geriye dönük ([syncCompleted]): bu sürümden önce bitirilmiş bölümler bir
///   kez aktarılır (`app_meta` işareti); kaydedilen ifadelerin eksik
///   görsel/sesi doldurulur.
///
/// Hepsi idempotent: aynı ifade, ipucu ya da bağ ikinci kez yazılmaz.
class DeckSync {
  DeckSync({
    required NotebookStore store,
    required ContentSource source,
    required ProgressRepository progress,
    required Future<List<LearningEvent>> Function(String contentId) lookups,
  }) : _store = store,
       _source = source,
       _progress = progress,
       _lookups = lookups;

  static String markerKey(String contentId) => 'deck.ingested.$contentId';

  /// Deste kuralları değişince (ör. H-052: altyazıda geçmeyen hedef ifade,
  /// sözlük filtresi) biten bölümler bir kez yeniden aktarılır. Aktarım
  /// idempotenttir: var olan kart ve tekrar durumu korunur.
  static const deckFormat = 2;

  static bool isCurrentMarker(String? marker) =>
      marker != null && marker.contains(' d$deckFormat ');

  final NotebookStore _store;
  final ContentSource _source;
  final ProgressRepository _progress;
  final Future<List<LearningEvent>> Function(String contentId) _lookups;

  Future<void> _lock = Future<void>.value();
  final Set<String> _enrichTried = {};

  /// Aynı anda tek aktarım (Ana Sayfa ve Defter aynı anda isteyebilir).
  Future<T> _serial<T>(Future<T> Function() body) {
    final prev = _lock;
    final done = Completer<void>();
    _lock = done.future;
    return prev.then((_) => body()).whenComplete(done.complete);
  }

  Future<void> onEpisodeCompleted(Episode episode) =>
      _serial(() => _ingest(episode));

  Future<void> onClueCard(Episode episode, CardNode card) => _serial(() async {
    final ids = card.clueIds.toSet();
    final clues = extractClues(
      episode,
    ).where((c) => ids.isEmpty || ids.contains(c.clueId)).toList();
    await _store.addClues(episode.info.id, clues);
  });

  /// Bitmiş ama aktarılmamış bölümleri aktarır; aktarılan bölüm sayısı.
  Future<int> syncCompleted() => _serial(() async {
    final all = await _progress.loadAll();
    var n = 0;
    for (final e in all.entries) {
      if (e.value.status != StoryStatus.completed) continue;
      if (isCurrentMarker(await _store.meta(markerKey(e.key)))) continue;
      try {
        await _ingest(await _source.loadEpisode(e.key));
        n++;
      } on Object catch (err) {
        debugPrint('[H036] ${e.key} deftere aktarılamadı: $err');
      }
    }
    await _enrichSaved();
    return n;
  });

  Future<void> _ingest(Episode episode) async {
    final id = episode.info.id;
    final subs = await _subtitles(episode);
    final lookups = await _lookups(id);
    final deck = buildEpisodeDeck(
      episode,
      subtitles: subs,
      lookups: lookups,
      now: _store.now(),
    );
    final added = await _store.addItems(deck.items);
    await _store.addClues(id, extractClues(episode));
    await _store.saveStoryLinks(extractStoryLinks(episode));
    await _enrichFor(episode, subs);
    await _store.setMeta(
      markerKey(id),
      'v${episode.info.contentVersion} d$deckFormat items=${deck.items.length} '
      'added=$added skipped=${deck.skipped.join('|')}',
    );
    debugPrint(
      '[H036] $id deftere: ${deck.items.length} kart ($added yeni), '
      'atlanan: ${deck.skipped}',
    );
  }

  Future<void> _enrichSaved() async {
    final missing = await _store.itemsMissingMedia();
    final ids = {for (final i in missing) ?i.contentId}
      ..removeAll(_enrichTried);
    for (final id in ids) {
      _enrichTried.add(id);
      try {
        final episode = await _source.loadEpisode(id);
        await _enrichFor(episode, await _subtitles(episode));
      } on Object catch (err) {
        debugPrint('[H036] $id kartları zenginleştirilemedi: $err');
      }
    }
  }

  Future<void> _enrichFor(Episode episode, SubtitleIndex subs) async {
    final missing = await _store.itemsMissingMedia();
    for (final item in missing) {
      if (item.contentId != episode.info.id) continue;
      await _store.fillMissing(enrichSaved(item, episode, subtitles: subs));
    }
  }

  Future<SubtitleIndex> _subtitles(Episode episode) async {
    final out = <String, SubtitleTrack>{};
    for (final n in episode.nodes.values) {
      if (n is! SegmentNode || n is TitleNode || n is RecapNode) continue;
      final path = n.subtitles;
      if (path == null) continue;
      try {
        out[n.id] = await _source.loadSubtitles(episode.info.id, path);
      } on Object catch (err) {
        debugPrint('[H036] altyazı okunamadı ${episode.info.id}/$path: $err');
      }
    }
    return out;
  }
}

/// Oynatıcı kancaları → [DeckSync].
class NotebookPlayerHooks implements PlayerHooks {
  NotebookPlayerHooks(this._sync);

  final DeckSync _sync;

  @override
  Future<void> onClueCard(Episode episode, CardNode card) =>
      _sync.onClueCard(episode, card);

  @override
  Future<void> onEpisodeCompleted(Episode episode) =>
      _sync.onEpisodeCompleted(episode);
}
