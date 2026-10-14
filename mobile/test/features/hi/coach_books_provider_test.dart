import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/hi/application/hi_providers.dart';
import 'package:hivelzon/features/hi/domain/coach_rules.dart';
import 'package:hivelzon/features/library/data/book_progress_store.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';

import '../../support/fake_content_source.dart';

/// Hi'nin girdileri Kitaplık'tan okunur (H-067): yarım kitap ve önerilen
/// seviyede açılmamış kitap; Kitaplık yüklenemezse Hi yine öneri verir.
void main() {
  Future<CoachInput> input(
    AppDatabase db, {
    bool booksFail = false,
    List<String> episodes = const ['A1-001'],
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
            ..books = testBookSummaries(['A1-K01', 'A1-K02', 'A2-K01'])
            ..booksFail = booksFail,
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

  test('yarım kitap ve okunmamış kitap Hi\'ye gelir', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    await BookProgressStore(
      db,
    ).savePosition('A1-K01', chapterId: 'c1', pageNumber: 2, sentenceIndex: 0);
    final i = await input(db);
    expect(i.bookInProgress?.bookId, 'A1-K01');
    expect(i.bookInProgress?.percent, 33);
    expect(i.bookToStart?.bookId, 'A1-K02');
    // Bölüm 1'in ifadelerinin tekrar zamanı geldi: tekrar kitaptan önce.
    expect(suggestToday(i).kind, HiSuggestionKind.review);
  });

  test('Kitaplık yüklenemezse kitap önerisi yok, Hi yine çalışır', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final i = await input(db, booksFail: true);
    expect(i.bookInProgress, isNull);
    expect(i.bookToStart, isNull);
    expect(suggestToday(i).kind, isNot(HiSuggestionKind.continueBook));
  });
}
