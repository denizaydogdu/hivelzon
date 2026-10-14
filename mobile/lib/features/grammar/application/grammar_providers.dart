import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/content/content_providers.dart';
import '../../../shared/meaning/meaning_sheet.dart' show MeaningStructure;
import '../../../shared/progress/story_progress.dart';
import '../../../shared/state/safe_refresh.dart';
import '../../../shared/storage/storage_providers.dart';
import '../../library/application/book_audio.dart';
import '../../library/application/library_providers.dart';
import '../../library/domain/book_progress.dart';
import '../../player/data/progress_repository.dart';
import '../../player/presentation/player_screen.dart';
import '../data/grammar_progress_store.dart';
import '../domain/grammar_lesson.dart';
import '../domain/grammar_progress.dart';

final grammarProgressStoreProvider = Provider<GrammarProgressStore>(
  (ref) => GrammarProgressStore(
    ref.watch(appDatabaseProvider),
    ready: ref.watch(legacyImportProvider),
  ),
);

/// Sunucudaki dersler (`/grammar/index.json`). Otomatik yeniden deneme yok:
/// hata ekranı "Tekrar dene" ile kullanıcıya bırakılır.
final grammarIndexProvider =
    FutureProvider.autoDispose<List<GrammarLessonSummary>>(
      (ref) => ref.watch(contentSourceProvider).loadGrammarIndex(),
      retry: (_, _) => null,
    );

/// Dersler yüklenemezse boş liste: giriş noktaları (bölüm paneli, anlam
/// paneli, Hi) sessizce gizlenir.
final grammarLessonsOrEmptyProvider =
    FutureProvider.autoDispose<List<GrammarLessonSummary>>((ref) async {
      try {
        return await ref.watch(grammarIndexProvider.future);
      } on Object catch (e) {
        debugPrint('[H078] ders listesi yüklenemedi: $e');
        return const [];
      }
    }, retry: (_, _) => null);

/// Ders başına ilerleme (cihazdaki).
final grammarProgressProvider =
    FutureProvider.autoDispose<Map<String, GrammarProgress>>(
      (ref) => ref.watch(grammarProgressStoreProvider).all(),
      retry: (_, _) => null,
    );

/// Bölüm ve kitapların `grammarTopics`'i (içerik kimliği → G-ID listesi).
/// Listeler yüklenemezse o kaynak boş sayılır.
final contentGrammarTopicsProvider =
    FutureProvider.autoDispose<Map<String, List<String>>>((ref) async {
      final out = <String, List<String>>{};
      try {
        for (final p in await ref.watch(packageListProvider.future)) {
          if (p.grammarTopics.isNotEmpty) out[p.id] = p.grammarTopics;
        }
      } on Object catch (e) {
        debugPrint('[H078] bölüm listesi okunamadı: $e');
      }
      try {
        for (final b in await ref.watch(bookListProvider.future)) {
          if (b.grammarTopics.isNotEmpty) out[b.id] = b.grammarTopics;
        }
      } on Object catch (e) {
        debugPrint('[H078] kitap listesi okunamadı: $e');
      }
      return out;
    }, retry: (_, _) => null);

/// "Hikâyende geçenler": oynanan (başlanmış) bölümlerin ve açılan kitapların
/// konuları; en son oynanan önce.
final storyGrammarTopicsProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  final topics = await ref.watch(contentGrammarTopicsProvider.future);
  if (topics.isEmpty) return const [];
  final seen = <(String, DateTime)>[];
  try {
    final story = await ref.watch(progressRepositoryProvider).loadAll();
    for (final p in story.values) {
      if (p.status == StoryStatus.notStarted) continue;
      seen.add((
        p.contentId,
        p.completedAt ?? p.startedAt ?? DateTime.utc(2000),
      ));
    }
  } on Object catch (e) {
    debugPrint('[H078] bölüm ilerlemesi okunamadı: $e');
  }
  try {
    final books = await ref.watch(bookProgressStoreProvider).all();
    for (final p in books.values) {
      if (p.status == BookStatus.notStarted) continue;
      seen.add((p.bookId, p.updatedAt));
    }
  } on Object catch (e) {
    debugPrint('[H078] kitap ilerlemesi okunamadı: $e');
  }
  seen.sort((a, b) => b.$2.compareTo(a.$2));
  return [for (final (id, _) in seen) ...?topics[id]];
}, retry: (_, _) => null);

/// Dilbilgisi ekranının verisi.
class GrammarListData {
  const GrammarListData({
    required this.lessons,
    required this.progress,
    required this.shelves,
  });

  final List<GrammarLessonSummary> lessons;
  final Map<String, GrammarProgress> progress;
  final GrammarShelves shelves;
}

final grammarListProvider = FutureProvider.autoDispose<GrammarListData>((
  ref,
) async {
  final lessons = await ref.watch(grammarIndexProvider.future);
  final progress = await ref.watch(grammarProgressProvider.future);
  final level = await ref.watch(suggestedLevelProvider.future);
  final story = await ref.watch(storyGrammarTopicsProvider.future);
  return GrammarListData(
    lessons: lessons,
    progress: progress,
    shelves: buildGrammarShelves(
      lessons,
      progress,
      suggestedLevel: level,
      storyTopics: story,
    ),
  );
}, retry: (_, _) => null);

/// Bölümlerin "Bu bölümdeki dilbilgisi" teklifleri (bölüm kimliği →
/// teklif). Ders ya da bölüm listesi yüklenemezse boş: düğme görünmez.
final episodeGrammarOffersProvider =
    FutureProvider.autoDispose<Map<String, GrammarOffer>>((ref) async {
      final lessons = await ref.watch(grammarLessonsOrEmptyProvider.future);
      if (lessons.isEmpty) return const {};
      try {
        final packages = await ref.watch(packageListProvider.future);
        return {
          for (final p in packages)
            p.id: ?GrammarOffer.of(p.grammarTopics, lessons),
        };
      } on Object {
        return const {};
      }
    }, retry: (_, _) => null);

/// Kitapların "Bu kitaptaki dilbilgisi" teklifleri (kitap kimliği → teklif).
final bookGrammarOffersProvider =
    FutureProvider.autoDispose<Map<String, GrammarOffer>>((ref) async {
      final lessons = await ref.watch(grammarLessonsOrEmptyProvider.future);
      if (lessons.isEmpty) return const {};
      try {
        final books = await ref.watch(bookListProvider.future);
        return {
          for (final b in books)
            b.id: ?GrammarOffer.of(b.grammarTopics, lessons),
        };
      } on Object {
        return const {};
      }
    }, retry: (_, _) => null);

/// Anlam panelinde "Bu yapı ne?" konuları: içeriğin `grammarTopics`'inden
/// listede dersi olanlar (H-078). Ders listesi henüz yüklenmediyse boş.
List<MeaningStructure> meaningStructures(WidgetRef ref, List<String> topics) {
  if (topics.isEmpty) return const [];
  final lessons = ref.read(grammarLessonsOrEmptyProvider).value ?? const [];
  final offer = GrammarOffer.of(topics, lessons);
  return [
    for (final l in offer?.lessons ?? const <GrammarLessonSummary>[])
      MeaningStructure(l.id, l.titleTr),
  ];
}

/// Ders sesi çalar (Türkçe anlatım ve İngilizce örnekler; testlerde sahtesi
/// verilir). Kitap sesiyle aynı arayüz.
final grammarAudioFactoryProvider = Provider<BookAudio Function()>((ref) {
  final factory = ref.watch(videoControllerFactoryProvider);
  return () => VideoPlayerBookAudio(factory: factory);
});

/// Dersin saati (sn, tekdüze). Testlerde elle ilerletilir.
final grammarClockProvider = Provider<double Function()?>((ref) => null);

/// İlerleme değişince Dilbilgisi ekranı ve teklifler yenilenir.
void refreshGrammar(WidgetRef ref) =>
    invalidateAndFlush(ref, [grammarProgressProvider, grammarListProvider]);
