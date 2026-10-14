import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/home/application/home_providers.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';

import '../../support/fake_content_source.dart';

/// H-060: Ana Sayfa günlük hedef halkası mevcut kayıtlardan hesaplanır
/// (yeni kayıt tutulmaz): bugün biten bölüm + bugünkü tekrar süresi.
void main() {
  late AppDatabase db;
  late InMemoryProgressRepository progress;

  setUp(() {
    db = AppDatabase.memory();
    progress = InMemoryProgressRepository();
  });
  tearDown(() => db.close());

  ProviderContainer container() {
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        legacyImportProvider.overrideWithValue(Future<void>.value()),
        contentSourceProvider.overrideWithValue(
          FakeContentSource(packageIds: ['A1-001', 'A1-002']),
        ),
        progressRepositoryProvider.overrideWithValue(progress),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  Future<TodayActivity> read(ProviderContainer c) async {
    final sub = c.listen(todayActivityProvider, (_, _) {});
    addTearDown(sub.close);
    return c.read(todayActivityProvider.future);
  }

  test('hiçbir şey yapılmadı: 0 / 10 dk', () async {
    final t = await read(container());
    expect(t.minutes, 0);
    expect(t.goalMinutes, 10);
    expect(t.progress, 0);
  });

  test('bugün biten bölüm (6 dk) + bugünkü tekrar süresi; dünkü tekrar '
      'sayılmaz', () async {
    await progress.markCompleted('A1-001', gate: const {});
    final c = container();
    // İlk okuma: bölümün ifadeleri deftere geçer (kartlar oluşur).
    expect((await read(c)).minutes, 6);
    final card = await db.select(db.reviewCards).get();
    expect(card, isNotEmpty);
    final now = DateTime.now().toUtc();
    for (final (at, ms) in [
      (now, 40000),
      (now, 30000),
      (now.subtract(const Duration(days: 2)), 600000),
    ]) {
      await db
          .into(db.reviewLogs)
          .insert(
            ReviewLogsCompanion.insert(
              cardId: card.first.id,
              rating: 3,
              reviewedAt: at,
              taskType: 'picture_choice',
              correct: true,
              durationMs: ms,
            ),
          );
    }
    c.invalidate(todayActivityProvider);
    final t = await read(c);
    // 6 dk bölüm + 70 sn tekrar (→ 2 dk).
    expect(t.minutes, 8);
    expect(t.progress, closeTo(0.8, 1e-9));
  });
}
