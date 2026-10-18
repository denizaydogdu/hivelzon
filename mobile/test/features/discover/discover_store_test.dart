// H-094 P2: Keşfet'in cihazdaki kayıtları (plan §5).
//
// `discover.watch.<gün>` · `discover.daily.<gün>` · `discover.reel.<id>` ·
// `discover.prefs` — hepsi `app_meta` içinde, eşitlenmez.
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/discover/data/discover_store.dart';
import 'package:hivelzon/features/discover/domain/daily_set.dart';
import 'package:hivelzon/features/discover/domain/discover_prefs.dart';
import 'package:hivelzon/features/discover/domain/feed.dart';
import 'package:hivelzon/features/discover/domain/reel_progress.dart';
import 'package:hivelzon/shared/storage/app_database.dart';

void main() {
  final day1 = DateTime(2026, 10, 14, 10);
  final day2 = DateTime(2026, 10, 15, 10);

  late AppDatabase db;
  late DiscoverStore store;

  setUp(() {
    db = AppDatabase.memory();
    store = DiscoverStore(db);
  });

  tearDown(() => db.close());

  group('tercihler', () {
    test('varsayılan: seviye seçilmemiş, üç kategori', () async {
      final prefs = await store.prefs();
      expect(prefs.level, isNull);
      expect(prefs.categories, kDefaultReelCategories);
      expect(await store.reelLevel(), isNull);
    });

    test('seviye seçimi yazılır ve kategoriyi bozmaz', () async {
      await store.setReelCategories(['CIN', 'BOK']);
      await store.setReelLevel('A2');
      final prefs = await store.prefs();
      expect(prefs.level, 'A2');
      expect(prefs.categories, ['CIN', 'BOK']);
      expect(await store.reelLevel(), 'A2');

      await store.setReelLevel(null);
      expect(await store.reelLevel(), isNull);
      expect((await store.prefs()).categories, ['CIN', 'BOK']);
    });

    test(
      'boş kategori listesi varsayılana döner; bozuk kayıt okunmaz',
      () async {
        await db
            .into(db.appMeta)
            .insertOnConflictUpdate(
              AppMetaCompanion.insert(
                key: DiscoverStore.prefsKey,
                value: '{bozuk',
              ),
            );
        expect((await store.prefs()).categories, kDefaultReelCategories);
        await store.setReelCategories(const []);
        expect((await store.prefs()).categories, kDefaultReelCategories);
      },
    );
  });

  group('günlük seçki', () {
    const set = DailySet(
      level: 'A1',
      categories: ['CIN', 'SPO', 'BOK'],
      items: [
        DailyItem(id: 'A1-R-CIN-01', contentVersion: 2),
        DailyItem(id: 'A1-R-SPO-01', contentVersion: 1, repeat: true),
      ],
    );

    test('gün anahtarına yazılır; aynı gün aynı seçki okunur', () async {
      expect(await store.dailySet(day1), isNull);
      await store.setDailySet(day1, set);
      final read = await store.dailySet(day1);
      expect(read!.level, 'A1');
      expect(read.items.map((i) => i.id), ['A1-R-CIN-01', 'A1-R-SPO-01']);
      expect(read.items.first.contentVersion, 2);
      expect(read.items[1].repeat, isTrue);
      // Farklı gün: seçki yok.
      expect(await store.dailySet(day2), isNull);
    });

    test('yeni gün yazılınca eski günün seçkisi silinir', () async {
      await store.setDailySet(day1, set);
      await store.setDailySet(
        day2,
        const DailySet(
          level: 'A1',
          categories: ['CIN'],
          items: [DailyItem(id: 'A1-R-CIN-01', contentVersion: 2)],
        ),
      );
      expect(await store.dailySet(day2), isNotNull);
      expect(await store.dailySet(day1), isNull);
    });

    test('bozuk seçki null döner (yeniden seçilir)', () async {
      await db
          .into(db.appMeta)
          .insertOnConflictUpdate(
            AppMetaCompanion.insert(
              key: DiscoverStore.dailyKeyFor(day1),
              value: '[]',
            ),
          );
      expect(await store.dailySet(day1), isNull);
    });
  });

  group('reel ilerlemesi', () {
    test('birleştirme yazar; tümü okunur', () async {
      await store.mergeProgress(
        'A1-R-CIN-01',
        contentVersion: 1,
        addSeconds: 4,
        shownDay: localDayKey(day1),
      );
      await store.mergeProgress(
        'A1-R-CIN-01',
        contentVersion: 1,
        addSeconds: 6,
        completed: true,
        practiceResult: PracticeResult.correct,
      );
      await store.mergeProgress(
        'A1-R-SPO-01',
        contentVersion: 3,
        shownDay: localDayKey(day2),
      );

      final p = (await store.reelProgress('A1-R-CIN-01'))!;
      expect(p.watchedSeconds, 10);
      expect(p.completed, isTrue);
      expect(p.lastShownDay, localDayKey(day1));
      expect(p.practiceResult, PracticeResult.correct);

      final all = await store.allReelProgress();
      expect(all.keys, containsAll(['A1-R-CIN-01', 'A1-R-SPO-01']));
      expect(all['A1-R-SPO-01']!.contentVersion, 3);
      expect(await store.reelProgress('A1-R-BOK-01'), isNull);
    });

    test('içerik sürümü artınca saniye ve sonuç taşınmaz', () async {
      await store.mergeProgress(
        'A1-R-CIN-01',
        contentVersion: 1,
        addSeconds: 9,
        completed: true,
        practiceResult: PracticeResult.correct,
      );
      final next = await store.mergeProgress(
        'A1-R-CIN-01',
        contentVersion: 2,
        addSeconds: 1,
      );
      expect(next.contentVersion, 2);
      expect(next.watchedSeconds, 1);
      expect(next.completed, isFalse);
      expect(next.practiceResult, isNull);
      expect(next.lastShownDay, isEmpty);
    });

    test('bozuk satır atlanır, diğerleri okunur', () async {
      await store.mergeProgress('A1-R-CIN-01', contentVersion: 1);
      await db
          .into(db.appMeta)
          .insertOnConflictUpdate(
            AppMetaCompanion.insert(
              key: DiscoverStore.reelKeyFor('A1-R-SPO-01'),
              value: 'x',
            ),
          );
      final all = await store.allReelProgress();
      expect(all.keys, ['A1-R-CIN-01']);
    });
  });
}
