import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/content/content_providers.dart';
import '../../../shared/content/content_source.dart';
import '../../../shared/meaning/error_taxonomy.dart';
import '../../../shared/progress/story_progress.dart';
import '../../../shared/storage/storage_providers.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../player/application/player_session.dart';
import '../../player/data/progress_repository.dart';
import '../../story/domain/season_map.dart';
import '../../topic_sets/application/topic_set_providers.dart';
import '../../topic_sets/domain/topic_set.dart';
import '../data/hi_store.dart';
import '../domain/coach_rules.dart';
import '../domain/hi_content.dart';
import '../domain/lookup_search.dart';
import '../domain/weekly_summary.dart';

final hiStoreProvider = Provider<HiStore>(
  (ref) => HiStore(
    ref.watch(appDatabaseProvider),
    ready: ref.watch(legacyImportProvider),
  ),
);

/// Sezon paketindeki `hi.json`. Yüklenemezse Hi verisiz çalışır (öneriler
/// yine gelir; notlar, konu kartları ve sözlük boş kalır).
final hiContentProvider = FutureProvider<HiContent>((ref) async {
  try {
    return await ref
        .watch(contentSourceProvider)
        .loadHiContent(kTopicSetSeason);
  } on Object catch (e) {
    debugPrint('[H048] Hi verisi yüklenemedi: $e');
    return HiContent.empty;
  }
}, retry: (_, _) => null);

/// Önerinin girdileri (bütün kaynaklar bir kez okunur).
final coachInputProvider = FutureProvider.autoDispose<CoachInput>((ref) async {
  final store = ref.watch(hiStoreProvider);
  final now = store.now();
  final content = await ref.watch(hiContentProvider.future);
  final progress = await ref.watch(progressRepositoryProvider).loadAll();
  List<PackageSummary> packages;
  try {
    packages = await ref.watch(packageListProvider.future);
  } on Object {
    packages = const [];
  }
  SeasonInfo? info;
  try {
    info = await ref.watch(seasonProvider(kTopicSetSeason).future);
  } on Object {
    info = null;
  }
  final map = buildSeasonMap(
    season: kTopicSetSeason,
    info: info,
    packages: packages,
    progress: progress,
  );
  final minutes = {
    for (final p in packages)
      if (p.estimatedMinutes != null) p.id: p.estimatedMinutes!.round(),
  };
  CoachEpisode? asCoach(MapEpisode? e) => e == null
      ? null
      : CoachEpisode(
          contentId: e.contentId,
          number: e.number,
          title: e.title,
          estimatedMinutes: minutes[e.contentId],
        );
  final inProgress = map.episodes
      .where(
        (e) => e.state == MapNodeState.inProgress && e.progress.hasCheckpoint,
      )
      .firstOrNull;
  final next = map.episodes
      .where((e) => e.state == MapNodeState.next)
      .firstOrNull;
  final overview = await ref.watch(reviewOverviewProvider.future);
  final goal = await ref.watch(notebookStoreProvider).dailyGoalMinutes();
  final hunted = await store.huntedSets();
  final sets = info == null
      ? const <TopicSetView>[]
      : resolveTopicSets(info.topicSets, progress);
  return CoachInput(
    now: now,
    dailyGoalMinutes: goal,
    inProgress: asCoach(inProgress),
    next: asCoach(next),
    completedCount: map.completedCount,
    reviewDue: overview.sessionCount,
    errors: await store.errorsSince(now.subtract(kCoachWindow)),
    notesReadAt: await store.notesReadAt(),
    unhuntedSets: [
      for (final s in sets)
        if (s.unlocked && !hunted.contains(s.summary.id))
          CoachTopicSet(
            id: s.summary.id,
            titleTr: s.summary.titleTr,
            unlockEpisode: s.summary.unlockEpisode,
          ),
    ],
    content: content,
  );
}, retry: (_, _) => null);

final hiSuggestionProvider = FutureProvider.autoDispose<HiSuggestion>(
  (ref) async => suggestToday(await ref.watch(coachInputProvider.future)),
  retry: (_, _) => null,
);

/// Balondaki nokta: bugün için yeni bir öneri var ve panel bugün açılmadı.
final hiBadgeProvider = FutureProvider.autoDispose<bool>((ref) async {
  try {
    final s = await ref.watch(hiSuggestionProvider.future);
    if (s.kind == HiSuggestionKind.rest) return false;
    final store = ref.watch(hiStoreProvider);
    return await store.panelOpenedDay() != localDay(store.now());
  } on Object {
    return false;
  }
}, retry: (_, _) => null);

final weeklySummaryProvider = FutureProvider.autoDispose<WeeklySummary>((
  ref,
) async {
  final store = ref.watch(hiStoreProvider);
  final now = store.now();
  final since = now.subtract(kCoachWindow);
  return computeWeeklySummary(
    now: now,
    itemCreatedAt: await store.itemsCreatedSince(since),
    reviews: await store.reviewsSince(since),
    completedAt: await store.completedSince(since),
    errors: await store.errorsSince(since),
  );
}, retry: (_, _) => null);

/// "Bu ne demek?" adayları: açılan bölümlerin onaylı dizini + defter +
/// açılmış konu setleri. Açılmamış bölümün metni gösterilmez (spoiler yok).
final lookupCandidatesProvider =
    FutureProvider.autoDispose<List<LookupCandidate>>((ref) async {
      final content = await ref.watch(hiContentProvider.future);
      final progress = await ref.watch(progressRepositoryProvider).loadAll();
      final opened = {
        for (final e in progress.entries)
          if (e.value.status != StoryStatus.notStarted) e.key,
      };
      final out = <LookupCandidate>[];
      try {
        for (final e in await ref.watch(notebookStoreProvider).entries()) {
          out.add(LookupCandidate(item: e.item, origin: LookupOrigin.notebook));
        }
      } on Object catch (e) {
        debugPrint('[H048] defter okunamadı: $e');
      }
      for (final l in content.lookup) {
        if (!opened.contains(l.contentId)) continue;
        out.add(
          LookupCandidate(
            item: l.toNotebookItem(),
            origin: LookupOrigin.episode,
            alt: l.alt,
          ),
        );
      }
      try {
        final season = await ref.watch(seasonProvider(kTopicSetSeason).future);
        final source = ref.watch(contentSourceProvider);
        for (final v in resolveTopicSets(season.topicSets, progress)) {
          if (!v.unlocked) continue;
          final set = await source.loadTopicSet(
            kTopicSetSeason,
            v.summary.path,
          );
          for (final it in set.items) {
            out.add(
              LookupCandidate(
                item: set.toNotebookItem(it),
                origin: LookupOrigin.topicSet,
              ),
            );
          }
        }
      } on Object catch (e) {
        debugPrint('[H048] konu setleri okunamadı: $e');
      }
      return out;
    }, retry: (_, _) => null);

/// Panelde gösterilecek yan görev: en son biten bölümün, henüz cevaplanmamış
/// görevi (yoksa null).
final bridgeTaskProvider = FutureProvider.autoDispose<BridgeTask?>((ref) async {
  final content = await ref.watch(hiContentProvider.future);
  if (content.bridgeTasks.isEmpty) return null;
  final progress = await ref.watch(progressRepositoryProvider).loadAll();
  final states = await ref.watch(hiStoreProvider).bridgeStates();
  final done =
      [
        for (final p in progress.values)
          if (p.status == StoryStatus.completed) p,
      ]..sort(
        (a, b) => (b.completedAt ?? DateTime(0)).compareTo(
          a.completedAt ?? DateTime(0),
        ),
      );
  for (final p in done) {
    final t = content.bridgeTaskFor(p.contentId);
    if (t != null && !states.containsKey(t.id)) return t;
  }
  return null;
}, retry: (_, _) => null);

final hiKnowledgeProvider = FutureProvider.autoDispose<HiKnowledge>(
  (ref) => ref.watch(hiStoreProvider).knowledge(),
  retry: (_, _) => null,
);

/// Defterde yeniden açılabilen konu kartları (yalnızca görülenler).
final seenTopicIntrosProvider = FutureProvider.autoDispose<List<TopicIntro>>((
  ref,
) async {
  final content = await ref.watch(hiContentProvider.future);
  final seen = await ref.watch(hiStoreProvider).seenTopicIntros();
  return [
    for (final t in content.topicIntros)
      if (seen.contains(t.id)) t,
  ];
}, retry: (_, _) => null);

/// Panel ve balon sayılarını yeniler (ilerleme ya da defter değişince).
void refreshHi(WidgetRef ref) {
  ref.invalidate(coachInputProvider);
  ref.invalidate(hiBadgeProvider);
  ref.invalidate(weeklySummaryProvider);
  ref.invalidate(lookupCandidatesProvider);
  ref.invalidate(bridgeTaskProvider);
  ref.invalidate(hiKnowledgeProvider);
  ref.invalidate(seenTopicIntrosProvider);
}

/// Oynatıcı için Hi (konu kartı + yanlış seçimin hata türü).
final playerCoachProvider = Provider<PlayerCoach?>(
  (ref) => HiPlayerCoach(
    ref.watch(hiStoreProvider),
    () => ref.read(hiContentProvider.future),
  ),
);

class HiPlayerCoach implements PlayerCoach {
  HiPlayerCoach(this._store, this._content);

  final HiStore _store;
  final Future<HiContent> Function() _content;

  @override
  Future<EpisodeCoaching> forEpisode(String contentId) async {
    final content = await _content();
    final seen = await _store.seenTopicIntros();
    return EpisodeCoaching(
      introsByNode: {
        for (final t in content.topicIntros)
          if (t.contentId == contentId && !seen.contains(t.id)) t.node: t,
      },
      decisionErrors: <String, ErrorType>{
        for (final d in content.decisionErrors)
          if (d.contentId == contentId) d.sourceId: d.errorType,
      },
    );
  }

  @override
  Future<void> markTopicSeen(String topicId) =>
      _store.markTopicIntroSeen(topicId);
}
