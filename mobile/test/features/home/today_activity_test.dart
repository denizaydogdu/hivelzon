import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/home/application/home_providers.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/shared/activity/active_time_meter.dart';
import 'package:hivelzon/shared/activity/study_clock.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';

import '../../support/fake_content_source.dart';

/// H-060, H-074: Ana Sayfa günlük hedef halkası. Ölçüm başlamadan önce
/// mevcut kayıtlardan tahmin (bugün biten bölüm + bugünkü tekrar süresi);
/// ölçüm başladıktan sonra cihazda ölçülen süre.
void main() {
  late AppDatabase db;
  late InMemoryProgressRepository progress;
  late DateTime now;

  setUp(() {
    db = AppDatabase.memory();
    progress = InMemoryProgressRepository();
    now = DateTime.now();
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
        studyClockProvider.overrideWith(
          (ref) => StudyClock(
            ref.watch(dailyActivityStoreProvider),
            clock: () => now,
          ),
        ),
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

  test('ölçülen süre: yarım bırakılan bölümde geçen süre halkaya yansır ve '
      'ölçüm yazılınca halka yenilenir', () async {
    final c = container();
    expect((await read(c)).minutes, 0);
    // Bölüm açıldı, 7 dk 10 sn oynandı, yarıda kapatıldı (biten bölüm yok).
    final clock = c.read(studyClockProvider)..enter();
    for (var i = 0; i < 43; i++) {
      now = now.add(const Duration(seconds: 10));
      clock.signal();
    }
    clock.leave();
    await clock.flush();
    final t = await read(c);
    expect(t.minutes, 8); // 430 sn → 8 dk (yukarı yuvarlanır)
    expect(t.progress, closeTo(0.8, 1e-9));
  });

  test('geçiş: ölçümden önce biten bölüm tahminle, sonrası ölçümle sayılır; '
      'aynı tekrar iki kez sayılmaz', () async {
    await progress.markCompleted('A1-001', gate: const {});
    final c = container();
    expect((await read(c)).minutes, 6); // ölçüm yok: yalnız tahmin
    final card = await db.select(db.reviewCards).get();

    // Ölçüm başlar; tekrar ekranında 90 sn geçer, cevap da kaydedilir.
    final store = c.read(dailyActivityStoreProvider);
    now = DateTime.now().add(const Duration(seconds: 1));
    await store.markMeasuredSince(now);
    await store.addSeconds({localDayKey(now): 90}, now);
    await db
        .into(db.reviewLogs)
        .insert(
          ReviewLogsCompanion.insert(
            cardId: card.first.id,
            rating: 3,
            reviewedAt: now.toUtc().add(const Duration(seconds: 80)),
            taskType: 'picture_choice',
            correct: true,
            durationMs: 80000,
          ),
        );
    expect(
      await c.read(dailyActivityStoreProvider).measuredSince(),
      now.toUtc(),
    );
    c.invalidate(todayActivityProvider);
    // 6 dk tahmin (ölçümden önce biten bölüm) + 90 sn ölçülen (→ 2 dk);
    // ölçümden sonraki tekrar cevabı ayrıca sayılmaz.
    expect((await read(c)).minutes, 8);
  });
}
