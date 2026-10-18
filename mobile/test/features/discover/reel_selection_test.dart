// H-094 P2: günlük seçkinin kuralları (plan §4) ve saklama biçimi (plan §5).
//
// Kurallar **belirlenimlidir**: aynı katalog + aynı ilerleme → aynı seçki.
// Burada cihaz, saat ve ağ yoktur; gün/ilerleme dışarıdan verilir.
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/discover/domain/daily_set.dart';
import 'package:hivelzon/features/discover/domain/discover_prefs.dart';
import 'package:hivelzon/features/discover/domain/reel.dart';
import 'package:hivelzon/features/discover/domain/reel_progress.dart';
import 'package:hivelzon/features/discover/domain/reel_selection.dart';

import '../../support/fake_content_source.dart';

/// Sentetik A1 kataloğu: iki Sinema, iki Spor, iki Kitap (günlük seçki için).
List<Reel> _catalog() => [
  reelLike('A1-R-CIN-01', id: 'A1-R-CIN-01', family: 'FAM-CIN-1'),
  reelLike('A1-R-CIN-01', id: 'A1-R-CIN-02', family: 'FAM-CIN-2'),
  reelLike('A1-R-SPO-01', id: 'A1-R-SPO-01', family: 'FAM-SPO-1'),
  reelLike('A1-R-SPO-01', id: 'A1-R-SPO-02', family: 'FAM-SPO-2'),
  reelLike('A1-R-BOK-01', id: 'A1-R-BOK-01', family: 'FAM-BOK-1'),
  reelLike('A1-R-BOK-01', id: 'A1-R-BOK-02', family: 'FAM-BOK-2'),
  // A2 karışmamalı.
  reelLike('A1-R-CIN-01', id: 'A2-R-CIN-01', level: 'A2'),
];

List<String> _ids(List<ReelPick> picks) => [for (final p in picks) p.reel.id];

ReelProgress _done(int version, {String day = '2026-10-10'}) => ReelProgress(
  contentVersion: version,
  watchedSeconds: 10,
  completed: true,
  lastShownDay: day,
);

void main() {
  group('günlük seçim kuralları (plan §4)', () {
    test('belirlenimli: aynı girdi aynı seçkiyi verir', () {
      final catalog = catalogOf(_catalog());
      final a = selectDailyReels(
        catalog: catalog.reels,
        level: 'A1',
        categories: kDefaultReelCategories,
      );
      final b = selectDailyReels(
        catalog: catalog.reels.reversed.toList(),
        level: 'A1',
        categories: kDefaultReelCategories,
      );
      expect(_ids(a), _ids(b));
      expect(_ids(a), ['A1-R-CIN-01', 'A1-R-SPO-01', 'A1-R-BOK-01']);
    });

    test(
      'ilgi dağıtımı: her kategoriden birer, sıra Sinema → Spor → Kitap',
      () {
        final picks = selectDailyReels(
          catalog: catalogOf(_catalog()).reels,
          level: 'A1',
          categories: kDefaultReelCategories,
        );
        expect(picks.map((p) => p.reel.category), ['CIN', 'SPO', 'BOK']);
        expect(picks, hasLength(3));
        expect(picks.every((p) => p.reel.level == 'A1'), isTrue);
      },
    );

    test('öncelik: hiç tamamlanmamış, sonra en uzun süredir gösterilmemiş', () {
      // Sinema: 01 dün tamamlandı, 02 hiç gösterilmedi → 02 önce.
      final progress = {
        'A1-R-CIN-01': _done(1, day: '2026-10-17'),
        'A1-R-SPO-01': _done(1, day: '2026-10-16'),
        'A1-R-BOK-01': _done(1, day: '2026-10-15'),
      };
      final picks = selectDailyReels(
        catalog: catalogOf(_catalog()).reels,
        level: 'A1',
        categories: kDefaultReelCategories,
        progress: progress,
      );
      expect(_ids(picks), ['A1-R-CIN-02', 'A1-R-SPO-02', 'A1-R-BOK-02']);
      // Hiçbiri tamamlanmış değil → "Tekrar" etiketi yok.
      expect(picks.any((p) => p.repeat), isFalse);
    });

    test('tamamlanmış video, hiç gösterilmemişin arkasında kalır', () {
      final catalog = catalogOf([
        reelLike('A1-R-CIN-01', id: 'A1-R-CIN-01', family: 'F1'),
        reelLike('A1-R-CIN-01', id: 'A1-R-CIN-02', family: 'F2'),
      ]);
      final picks = selectDailyReels(
        catalog: catalog.reels,
        level: 'A1',
        categories: ['CIN'],
        progress: {'A1-R-CIN-01': _done(1)},
      );
      expect(_ids(picks), ['A1-R-CIN-02', 'A1-R-CIN-01']);
    });

    test(
      'kontrollü tekrar: daha önce gösterilen video "Tekrar" etiketlenir',
      () {
        final catalog = catalogOf([
          reelLike('A1-R-CIN-01', id: 'A1-R-CIN-01', family: 'F1'),
        ]);
        final picks = selectDailyReels(
          catalog: catalog.reels,
          level: 'A1',
          categories: ['CIN'],
          progress: {
            'A1-R-CIN-01': ReelProgress(
              contentVersion: 1,
              lastShownDay: '2026-10-12',
            ),
          },
        );
        expect(picks.single.repeat, isTrue);
      },
    );

    test('aynı hedef (aile) seçkide iki kez olmaz', () {
      final catalog = catalogOf([
        reelLike('A1-R-CIN-01', id: 'A1-R-CIN-01', family: 'F-AYNI'),
        reelLike('A1-R-CIN-01', id: 'A1-R-CIN-02', family: 'F-AYNI'),
        reelLike('A1-R-SPO-01', id: 'A1-R-SPO-01', family: 'F-SPO'),
      ]);
      final picks = selectDailyReels(
        catalog: catalog.reels,
        level: 'A1',
        categories: ['CIN', 'SPO'],
        count: 3,
      );
      final families = [
        for (final p in picks)
          if (p.reel.family != null) p.reel.family!,
      ];
      expect(families.toSet(), hasLength(families.length));
      expect(_ids(picks), ['A1-R-CIN-01', 'A1-R-SPO-01']);
    });

    test('geri çekilen içerik seçilmez', () {
      final catalog = catalogOf([
        reelLike('A1-R-CIN-01', id: 'A1-R-CIN-01', status: 'WITHDRAWN'),
        reelLike('A1-R-SPO-01', id: 'A1-R-SPO-01'),
      ]);
      final picks = selectDailyReels(
        catalog: catalog.reels,
        level: 'A1',
        categories: ['CIN', 'SPO'],
      );
      expect(_ids(picks), ['A1-R-SPO-01']);
    });

    test('yetersizlik: 3\'ten az video; farklı seviyeden doldurulmaz', () {
      final catalog = catalogOf([
        reelLike('A1-R-CIN-01', id: 'A1-R-CIN-01'),
        reelLike('A2-R-SPO-01', id: 'A2-R-SPO-01', level: 'A2'),
      ]);
      final picks = selectDailyReels(
        catalog: catalog.reels,
        level: 'A1',
        categories: kDefaultReelCategories,
      );
      expect(_ids(picks), ['A1-R-CIN-01']);
      expect(picks.every((p) => p.reel.level == 'A1'), isTrue);
    });

    test('kapalı kategori zorla gösterilmez', () {
      final picks = selectDailyReels(
        catalog: catalogOf(_catalog()).reels,
        level: 'A1',
        categories: ['CIN'],
      );
      expect(picks.map((p) => p.reel.category).toSet(), {'CIN'});
    });
  });

  group('geri çekme ve sürüm (plan §5)', () {
    test('geri çekilen içeriğin yerine aynı seviye-kategoriden yedek', () {
      final catalog = catalogOf(_catalog());
      final yedek = substituteReel(
        catalog: catalog.reels,
        level: 'A1',
        category: 'CIN',
        used: {'A1-R-SPO-01'},
      );
      expect(yedek?.id, 'A1-R-CIN-01');
    });

    test('yedek yoksa null (seçki daha az videoyla sürer)', () {
      final catalog = catalogOf(_catalog());
      expect(
        substituteReel(
          catalog: catalog.reels,
          level: 'A1',
          category: 'CIN',
          used: {'A1-R-CIN-01', 'A1-R-CIN-02'},
        ),
        isNull,
      );
      expect(
        substituteReel(
          catalog: catalog.reels,
          level: 'B1',
          category: 'CIN',
          used: const {},
        ),
        isNull,
      );
    });

    test('sabit seçkide geri çekilen içerik yedekle değiştirilir', () {
      final reels = _catalog();
      final catalog = catalogOf([
        for (final r in reels)
          r.id == 'A1-R-CIN-01'
              ? reelLike('A1-R-CIN-01', id: r.id, status: 'WITHDRAWN')
              : r,
      ]);
      final set = DailySet(
        level: 'A1',
        categories: kDefaultReelCategories,
        items: const [
          DailyItem(id: 'A1-R-CIN-01', contentVersion: 1),
          DailyItem(id: 'A1-R-SPO-01', contentVersion: 1),
        ],
      );
      final fixed = reconcileDailySet(set: set, catalog: catalog.reels);
      expect(fixed, isNotNull);
      expect(fixed!.items.map((i) => i.id), ['A1-R-CIN-02', 'A1-R-SPO-01']);
    });

    test('değişiklik yoksa eşleme null (gereksiz yazma yok)', () {
      final set = DailySet(
        level: 'A1',
        categories: kDefaultReelCategories,
        items: const [DailyItem(id: 'A1-R-CIN-01', contentVersion: 1)],
      );
      expect(
        reconcileDailySet(set: set, catalog: catalogOf(_catalog()).reels),
        isNull,
      );
    });

    test('içerik sürümü artınca seçki güncel sürümü taşır', () {
      final set = DailySet(
        level: 'A1',
        categories: kDefaultReelCategories,
        items: const [DailyItem(id: 'A1-R-CIN-01', contentVersion: 1)],
      );
      final catalog = catalogOf([
        reelLike('A1-R-CIN-01', id: 'A1-R-CIN-01', contentVersion: 2),
      ]);
      final fixed = reconcileDailySet(set: set, catalog: catalog.reels);
      expect(fixed!.items.single.contentVersion, 2);
    });
  });

  group('seçki ve tercih biçimi', () {
    test('DailySet JSON gidiş-dönüş; eşleşme seviye + kategori kümesi', () {
      const set = DailySet(
        level: 'A2',
        categories: ['CIN', 'BOK'],
        items: [
          DailyItem(id: 'A2-R-CIN-01', contentVersion: 3, repeat: true),
          DailyItem(id: 'A2-R-BOK-01', contentVersion: 1),
        ],
      );
      final again = DailySet.fromJson(set.toJson())!;
      expect(again.level, 'A2');
      expect(again.categories, ['CIN', 'BOK']);
      expect(again.items.map((i) => i.id), ['A2-R-CIN-01', 'A2-R-BOK-01']);
      expect(again.items.first.contentVersion, 3);
      expect(again.items.first.repeat, isTrue);
      expect(again.items[1].repeat, isFalse);

      expect(again.matches(level: 'A2', categories: ['BOK', 'CIN']), isTrue);
      expect(again.matches(level: 'A1', categories: ['CIN', 'BOK']), isFalse);
      expect(again.matches(level: 'A2', categories: ['CIN']), isFalse);
    });

    test('bozuk seçki JSON okunmaz', () {
      expect(DailySet.fromJson(null), isNull);
      expect(DailySet.fromJson({'schemaVersion': 2, 'level': 'A1'}), isNull);
      expect(DailySet.fromJson({'schemaVersion': 1}), isNull);
      expect(DailySet.fromJson({'schemaVersion': 1, 'level': 'A1'}), isNotNull);
    });

    test(
      'tercihler: seviye geçersiz kılma + kategoriler, JSON gidiş-dönüş',
      () {
        const prefs = DiscoverPrefs(level: 'A2', categories: ['BOK', 'CIN']);
        final again = DiscoverPrefs.fromJson(prefs.toJson());
        expect(again.level, 'A2');
        expect(again.normalizedCategories(), ['CIN', 'BOK']);

        final cleared = prefs.copyWith(clearLevel: true);
        expect(cleared.level, isNull);
        expect(cleared.categories, ['BOK', 'CIN']);

        // Bilinmeyen kategori ve boş liste varsayılana döner.
        final bad = DiscoverPrefs.fromJson({
          'level': '',
          'categories': ['XYZ'],
        });
        expect(bad.level, isNull);
        expect(bad.categories, kDefaultReelCategories);
        expect(DiscoverPrefs.fromJson(null).level, isNull);
      },
    );
  });

  group('reel ilerlemesi (plan §5)', () {
    test(
      'birleştirme: saniye eklenir, completed doğruya döner, gün en yenisi',
      () {
        final p1 = mergeReelProgress(
          null,
          contentVersion: 1,
          addSeconds: 3,
          shownDay: '2026-10-14',
        );
        expect(p1.watchedSeconds, 3);
        expect(p1.completed, isFalse);
        expect(p1.lastShownDay, '2026-10-14');

        final p2 = mergeReelProgress(
          p1,
          contentVersion: 1,
          addSeconds: 7,
          completed: true,
          shownDay: '2026-10-15',
        );
        expect(p2.watchedSeconds, 10);
        expect(p2.completed, isTrue);
        expect(p2.lastShownDay, '2026-10-15');

        // Geriye dönmez: completed false gözlemi true'yu bozmaz; eski gün yeni
        // günün yerine geçmez.
        final p3 = mergeReelProgress(
          p2,
          contentVersion: 1,
          completed: false,
          shownDay: '2026-10-13',
        );
        expect(p3.completed, isTrue);
        expect(p3.lastShownDay, '2026-10-15');
        expect(p3.watchedSeconds, 10);
      },
    );

    test('içerik sürümü artınca eski saniye/sonuç taşınmaz', () {
      final old = ReelProgress(
        contentVersion: 1,
        watchedSeconds: 12,
        completed: true,
        lastShownDay: '2026-10-14',
        practiceResult: PracticeResult.correct,
      );
      final next = mergeReelProgress(old, contentVersion: 2, addSeconds: 2);
      expect(next.contentVersion, 2);
      expect(next.watchedSeconds, 2);
      expect(next.completed, isFalse);
      expect(next.lastShownDay, isEmpty);
      expect(next.practiceResult, isNull);
      expect(old.isCompletedFor(2), isFalse);
      expect(old.isCompletedFor(1), isTrue);
    });

    test('soru sonucu son gözlem; JSON gidiş-dönüş', () {
      final p = mergeReelProgress(
        null,
        contentVersion: 1,
        practiceResult: PracticeResult.wrong,
      );
      expect(p.practiceResult, PracticeResult.wrong);
      final again = ReelProgress.fromJson(p.toJson())!;
      expect(again.practiceResult, PracticeResult.wrong);
      expect(again.contentVersion, 1);
      // Bilinmeyen sonuç yok sayılır, ilerleme korunur.
      expect(
        ReelProgress.fromJson({
          'contentVersion': 1,
          'practiceResult': 'belki',
        })!.practiceResult,
        isNull,
      );
      expect(ReelProgress.fromJson({'watchedSeconds': 3}), isNull);
    });
  });
}
