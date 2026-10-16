import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/tr_strings.dart';
import '../../../shared/content/content_providers.dart';
import '../../../shared/content/content_source.dart';
import '../../../shared/meaning/error_taxonomy.dart';
import '../../../shared/progress/story_progress.dart';
import '../../../shared/state/safe_refresh.dart';
import '../../../shared/storage/storage_providers.dart';
import '../../grammar/application/grammar_providers.dart';
import '../../library/application/library_providers.dart';
import '../../library/domain/book.dart';
import '../../library/domain/book_progress.dart';
import '../../onboarding/application/onboarding_providers.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../player/application/player_session.dart';
import '../../player/data/progress_repository.dart';
import '../../story/domain/season_map.dart';
import '../../talk/application/talk_providers.dart';
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
          lastPlayedAt: progress[e.contentId]?.updatedAt,
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
  String? level;
  try {
    level = await ref.watch(onboardingStoreProvider).suggestedLevel();
  } on Object {
    level = null;
  }
  final books = await _coachBooks(ref, level);
  final grammar = await _coachGrammar(ref, packages, progress);
  final sets = info == null
      ? const <TopicSetView>[]
      : resolveTopicSets(info.topicSets, progress);

  // Günlük plan (H-088): bugün ne yapıldı, en son ne zaman çalışıldı,
  // bugün hangi öneriler geçildi. Okunamayan kaynak planı durdurmaz.
  final (dayStart, _) = localDayBounds(now);
  bool today(DateTime? t) => t != null && !t.toUtc().isBefore(dayStart);
  final lastReview = await _orNull(store.lastReviewAt);
  final grammarDoneToday =
      await _orNull(() async {
        final all = await ref.watch(grammarProgressStoreProvider).all();
        return all.values.any((p) => today(p.completedAt));
      }) ??
      false;
  final huntToday = await _orNull(() => store.huntDoneSince(dayStart)) ?? false;
  final dismissed = await _orNull(store.dismissedToday) ?? const <String>{};
  // Konuş görevleri ve ilk 7 gün (H-090). Okunamazsa plan onlarsız sürer.
  final talk =
      await _orNull(() => ref.watch(talkViewsProvider.future)) ?? const [];
  final talkToday =
      await _orNull(
        () => ref.watch(talkProgressStoreProvider).doneSince(dayStart),
      ) ??
      false;
  final startedAt = await _orNull(
    () => ref.watch(onboardingStoreProvider).completedAt(),
  );
  DateTime? lastActive = lastReview;
  void seen(DateTime? t) {
    if (t != null && (lastActive == null || t.isAfter(lastActive!))) {
      lastActive = t;
    }
  }

  for (final p in progress.values) {
    seen(p.updatedAt ?? p.completedAt ?? p.startedAt);
  }
  seen(books.lastRead);
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
    bookInProgress: books.reading,
    bookToStart: books.unread,
    grammar: grammar,
    level: level,
    lastActiveAt: lastActive,
    dismissed: dismissed,
    reviewedToday: today(lastReview),
    mainDoneToday:
        progress.values.any((p) => today(p.completedAt)) ||
        today(books.lastRead),
    taskDoneToday: huntToday || grammarDoneToday || talkToday,
    talkTasks: [
      for (final v in talk)
        if (v.unlocked && !v.done)
          CoachTalk(
            id: v.task.id,
            titleTr: v.task.titleTr,
            scene: v.task.isScene,
            unlockEpisode: v.task.unlockEpisode,
            characterTr: v.task.isScene ? v.task.characterName : v.task.to,
            minutes: v.task.minutes,
          ),
    ],
    talkDoneToday: talkToday,
    startedAt: startedAt,
  );
}, retry: (_, _) => null);

Future<T?> _orNull<T>(Future<T> Function() read) async {
  try {
    return await read();
  } on Object catch (e) {
    debugPrint('[H088] plan girdisi okunamadı: $e');
    return null;
  }
}

/// Hi için dilbilgisi (H-078): en son oynanan bölümde ya da açılan kitapta
/// geçen, bitirilmemiş ilk konu. Ders listesi yoksa ya da okunamazsa yok.
Future<CoachGrammar?> _coachGrammar(
  Ref ref,
  List<PackageSummary> packages,
  Map<String, StoryProgress> story,
) async {
  try {
    final lessons = await ref.watch(grammarLessonsOrEmptyProvider.future);
    if (lessons.isEmpty) return null;
    final done = await ref.watch(grammarProgressStoreProvider).all();
    final byId = {for (final l in lessons) l.id: l};
    // (kaynak, konular, zaman): oynanan bölümler ve açılan kitaplar.
    final seen = <(String, List<String>, DateTime)>[];
    for (final p in packages) {
      final s = story[p.id];
      if (p.grammarTopics.isEmpty || s == null) continue;
      if (s.status == StoryStatus.notStarted) continue;
      seen.add((
        HiTexts.grammarSourceEpisode(p.title),
        p.grammarTopics,
        s.completedAt ?? s.startedAt ?? DateTime.utc(2000),
      ));
    }
    try {
      final books = await ref.watch(contentSourceProvider).listBooks();
      final read = await ref.watch(bookProgressStoreProvider).all();
      for (final b in books) {
        final p = read[b.id];
        if (b.grammarTopics.isEmpty || p == null) continue;
        if (p.status == BookStatus.notStarted) continue;
        seen.add((
          HiTexts.grammarSourceBook(b.title),
          b.grammarTopics,
          p.updatedAt,
        ));
      }
    } on Object catch (e) {
      debugPrint('[H078] Hi için kitaplar okunamadı: $e');
    }
    seen.sort((a, b) => b.$3.compareTo(a.$3));
    for (final (source, topics, _) in seen) {
      for (final id in topics) {
        final l = byId[id];
        if (l == null || (done[id]?.isCompleted ?? false)) continue;
        return CoachGrammar(
          lessonId: l.id,
          titleTr: l.titleTr,
          sourceTr: source,
          minutes: l.minutes,
        );
      }
    }
    return null;
  } on Object catch (e) {
    debugPrint('[H078] Hi için dilbilgisi okunamadı: $e');
    return null;
  }
}

/// Hi için kitaplar (H-067): son okunan yarım kitap, önerilen seviyede
/// açılmamış ilk kitap ve en son okuma anı (H-088). Kitaplık yüklenemezse
/// hiçbiri yok.
Future<({CoachBook? reading, CoachBook? unread, DateTime? lastRead})>
_coachBooks(Ref ref, String? level) async {
  try {
    final progress = await ref.watch(bookProgressStoreProvider).all();
    DateTime? lastRead;
    for (final p in progress.values) {
      if (p.status == BookStatus.notStarted) continue;
      if (lastRead == null || p.updatedAt.isAfter(lastRead)) {
        lastRead = p.updatedAt;
      }
    }
    final List<BookSummary> books;
    try {
      books = await ref.watch(contentSourceProvider).listBooks();
    } on Object catch (e) {
      debugPrint('[H067] Hi için kitaplar okunamadı: $e');
      return (reading: null, unread: null, lastRead: lastRead);
    }
    final shelves = buildShelves(books, progress, suggestedLevel: level);
    CoachBook of(BookSummary b) => CoachBook(
      bookId: b.id,
      title: b.title,
      level: b.level,
      percent: ((progress[b.id]?.fraction(b.pageCount) ?? 0) * 100).round(),
      estimatedMinutes: b.estimatedMinutes,
    );
    final reading = shelves.continueReading.firstOrNull;
    // Hi kitabı sesli açar: ilk bölümünün sesi olan kitap önce.
    final unreadAll = shelves.userLevelBooks.where(
      (b) =>
          progress[b.id] == null ||
          progress[b.id]!.status == BookStatus.notStarted,
    );
    final unread =
        unreadAll.where((b) => b.startsWithAudio).firstOrNull ??
        unreadAll.firstOrNull;
    return (
      reading: reading == null ? null : of(reading),
      unread: unread == null ? null : of(unread),
      lastRead: lastRead,
    );
  } on Object catch (e) {
    debugPrint('[H067] Hi için kitaplar okunamadı: $e');
    return (reading: null, unread: null, lastRead: null);
  }
}

/// Bugünün planı (H-088): Ana Sayfa'nın birincil kartı ve Hi'nin önerisi
/// buradan gelir (tek karar, [planToday]).
final dailyPlanProvider = FutureProvider.autoDispose<DailyPlan>(
  (ref) async => planToday(await ref.watch(coachInputProvider.future)),
  retry: (_, _) => null,
);

final hiSuggestionProvider = FutureProvider.autoDispose<HiSuggestion>(
  (ref) async => (await ref.watch(dailyPlanProvider.future)).primary,
  retry: (_, _) => null,
);

/// "Başka bir öneri": öneriyi bugünlük geçer, plan yeniden hesaplanır.
Future<void> dismissSuggestion(WidgetRef ref, HiSuggestion s) async {
  if (!s.dismissible) return;
  try {
    await ref.read(hiStoreProvider).dismissToday(s.key);
  } on Object catch (e) {
    debugPrint('[H088] öneri geçilemedi: $e');
  }
  refreshHi(ref);
}

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
    // H-093: kanıt cümlesi (okunamazsa yalnız sayılar).
    evidence: await _orNull(() => store.evidenceSince(since)) ?? const [],
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
/// Görünmeyen sekmelerde de güvenli (H-056, [invalidateAndFlush]).
void refreshHi(WidgetRef ref) => invalidateAndFlush(ref, [
  coachInputProvider,
  dailyPlanProvider,
  hiSuggestionProvider,
  hiBadgeProvider,
  weeklySummaryProvider,
  lookupCandidatesProvider,
  bridgeTaskProvider,
  hiKnowledgeProvider,
  seenTopicIntrosProvider,
]);

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
