import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/grammar/data/grammar_progress_store.dart';
import 'package:hivelzon/features/hi/application/hi_providers.dart';
import 'package:hivelzon/features/hi/domain/coach_rules.dart';
import 'package:hivelzon/features/library/data/book_progress_store.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';

import '../../support/fake_content_source.dart';

/// Hi koçu ve dilbilgisi (H-078): oynanan bölümde ya da okunan kitapta geçen,
/// bitmemiş konu düşük öncelikle önerilir; gerekçe kaynağı söyler.
void main() {
  final now = DateTime.utc(2026, 10, 14, 20);
  const grammar = CoachGrammar(
    lessonId: kTestLessonId,
    titleTr: 'Üçüncü tekil -s',
    sourceTr: '"The New Neighbour" bölümünde',
    minutes: 3,
  );
  const unread = CoachBook(
    bookId: 'A1-K02',
    title: 'Lost in the Market',
    level: 'A1',
    estimatedMinutes: 7,
  );

  test('kural: kitap önerisinden sonra, dinlenmeden önce; gerekçe görünür', () {
    final withBook = suggestToday(
      CoachInput(
        now: now,
        dailyGoalMinutes: 10,
        bookToStart: unread,
        grammar: grammar,
      ),
    );
    expect(withBook.kind, HiSuggestionKind.startBook);
    final s = suggestToday(
      CoachInput(now: now, dailyGoalMinutes: 10, grammar: grammar),
    );
    expect(s.kind, HiSuggestionKind.grammarSuggest);
    expect(s.title, 'Kısa bir konu: Üçüncü tekil -s');
    expect(s.reasonTr, startsWith('"The New Neighbour" bölümünde bu yapı'));
    expect(s.minutes, 3);
    expect(s.reasonTr, isNot(contains('dk')));
    expect(s.actionLabel, 'Konuyu aç');
    expect(s.actionRoute, '/dilbilgisi/$kTestLessonId');
    expect(
      suggestToday(CoachInput(now: now, dailyGoalMinutes: 10)).kind,
      HiSuggestionKind.rest,
    );
  });

  Future<CoachInput> input(
    AppDatabase db, {
    List<String> episodes = const ['A1-001'],
    bool grammarFails = false,
  }) async {
    final progress = InMemoryProgressRepository();
    for (final id in episodes) {
      await progress.markCompleted(id, gate: const {});
    }
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        legacyImportProvider.overrideWithValue(Future<void>.value()),
        contentSourceProvider.overrideWithValue(
          FakeContentSource(packageIds: episodes)
            ..books = testBookSummaries(
              ['A1-K99'],
              grammarTopics: {
                'A1-K99': ['G-A1-02-there-is'],
              },
            )
            ..grammarTopics = {
              'A1-001': [kTestLessonId],
            }
            ..lessons = testLessonSummaries([kTestLessonId, 'G-A1-02-there-is'])
            ..grammarFails = grammarFails,
        ),
        progressRepositoryProvider.overrideWithValue(progress),
        learningEventLogProvider.overrideWithValue(InMemoryLearningEventLog()),
      ],
    );
    addTearDown(c.dispose);
    final sub = c.listen(coachInputProvider, (_, _) {});
    addTearDown(sub.close);
    return c.read(coachInputProvider.future);
  }

  test('girdi: en son oynanan içeriğin bitmemiş konusu', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    var i = await input(db);
    expect(i.grammar?.lessonId, kTestLessonId);
    expect(i.grammar?.sourceTr, '"A Strange Message" bölümünde');

    // Konu bitince sıradaki kaynağa (açılan kitap) geçer.
    await GrammarProgressStore(db).markCompleted(kTestLessonId);
    await BookProgressStore(
      db,
    ).savePosition('A1-K99', chapterId: 'c1', pageNumber: 1, sentenceIndex: 0);
    i = await input(db);
    expect(i.grammar?.lessonId, 'G-A1-02-there-is');
    expect(i.grammar?.sourceTr, '"The Test Box" kitabında');
  });

  test('ders listesi yüklenemezse öneri yok, Hi yine çalışır', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final i = await input(db, grammarFails: true);
    expect(i.grammar, isNull);
    expect(suggestToday(i).kind, isNot(HiSuggestionKind.grammarSuggest));
  });
}
