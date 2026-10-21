// H-094 P2: günlük seçkinin cihazdaki davranışı (plan §4–5).
//
// - Gün içinde seçki kararlı; aynı video yeniden seçilmez (sürüm + kimlik).
// - Gün dönünce yeni seçki yazılır; **oynayan video kesilmez**.
// - Seviye değişince yeni seçim başlar; günlük izleme sayacı silinmez.
// - Geri çekilen içerik sabit seçkide olsa oynatılmaz, yedeği konur.
// - İçerik sürümü artınca eski izleme/soru sonucu taşınmaz.
// - Tamamlanma: sona yaklaşma (%90) + aktif izleme (sürenin %80'i) birlikte;
//   iki saniyeyi döndürmek ya da sona atlayıp kısa izlemek sayılmaz (H-096).
// - Soru sonucu yalnız ürün kaydına yazılır; Defter'e/kanıta yazılmaz.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/discover/application/discover_providers.dart';
import 'package:hivelzon/features/discover/data/discover_store.dart';
import 'package:hivelzon/features/discover/domain/daily_set.dart';
import 'package:hivelzon/features/discover/domain/feed.dart';
import 'package:hivelzon/features/discover/domain/reel.dart';
import 'package:hivelzon/features/discover/domain/reel_progress.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';

import '../../support/discover_harness.dart';
import '../../support/fake_content_source.dart';

Finder _key(String k) => find.byKey(ValueKey(k));

Future<void> _tap(WidgetTester tester, DiscoverHarness h, String key) async {
  await tester.tap(_key(key));
  await h.settle(tester, rounds: 12);
}

List<String> _ids(DiscoverHarness h, WidgetTester tester) => [
  for (final e in h.feedState(tester).feed.whereType<VideoEntry>()) e.video.id,
];

/// Sentetik A1 kataloğu: (isteğe bağlı) iki Sinema, bir Spor, bir Kitap.
List<Reel> _reels({
  String cinStatus = 'DRAFT',
  int cinVersion = 1,
  bool secondCinema = true,
}) => [
  reelLike(
    'A1-R-CIN-01',
    id: 'A1-R-CIN-01',
    status: cinStatus,
    contentVersion: cinVersion,
    family: 'FAM-CIN-1',
  ),
  if (secondCinema)
    reelLike('A1-R-CIN-01', id: 'A1-R-CIN-02', family: 'FAM-CIN-2'),
  reelLike('A1-R-SPO-01', id: 'A1-R-SPO-01', family: 'FAM-SPO-1'),
  reelLike('A1-R-BOK-01', id: 'A1-R-BOK-01', family: 'FAM-BOK-1'),
];

Future<DiscoverHarness> _pump(
  WidgetTester tester, {
  List<Reel>? reels,
  DateTime Function()? clockOf,
  Duration Function(String uri)? durationFor,
  Duration Function(String uri)? positionFor,
}) async {
  final h = DiscoverHarness(
    chip: DiscoverChip.today,
    withReels: true,
    reels: reels,
    suggestedLevel: 'A1',
    clockOf: clockOf,
    durationFor: durationFor,
    positionFor: positionFor,
  );
  addTearDown(h.dispose);
  await h.pump(tester);
  return h;
}

void main() {
  group('günlük seçkinin saklanması', () {
    testWidgets('aynı gün aynı seçki: kimlik + içerik sürümü saklanır', (
      tester,
    ) async {
      final h = await _pump(tester, reels: _reels());
      final first = _ids(h, tester);
      expect(first, ['A1-R-CIN-01', 'A1-R-SPO-01', 'A1-R-BOK-01']);

      final set = await tester.runAsync(
        () => DiscoverStore(h.db).dailySet(h.clock),
      );
      expect(set!.level, 'A1');
      expect(set.items.map((i) => i.id), first);
      expect(set.items.every((i) => i.contentVersion == 1), isTrue);

      // Yeniden açılış (aynı cihaz/gün): seçki değişmez.
      await h.unmount(tester);
      await h.pump(tester);
      expect(_ids(h, tester), first);
      await h.unmount(tester);
    });

    testWidgets('gün dönünce yeni seçki yazılır, eski gün silinir', (
      tester,
    ) async {
      var now = DateTime(2026, 10, 14, 10);
      final h = await _pump(tester, reels: _reels(), clockOf: () => now);
      expect(_ids(h, tester), ['A1-R-CIN-01', 'A1-R-SPO-01', 'A1-R-BOK-01']);
      await h.unmount(tester);

      now = DateTime(2026, 10, 15, 10);
      await h.pump(tester);
      final store = DiscoverStore(h.db);
      final day2 = await tester.runAsync(() => store.dailySet(now));
      expect(day2, isNotNull);
      // Yeni gün yeni seçki: dün gösterilen Sinema yerine hiç gösterilmemiş
      // olan gelir (plan §4.4).
      expect(day2!.items.map((i) => i.id), [
        'A1-R-CIN-02',
        'A1-R-SPO-01',
        'A1-R-BOK-01',
      ]);
      final day1 = await tester.runAsync(
        () => store.dailySet(DateTime(2026, 10, 14, 10)),
      );
      expect(day1, isNull);
      await h.unmount(tester);
    });

    testWidgets('gece yarısı oynayan video kesilmez (yeni gün oturumda)', (
      tester,
    ) async {
      var now = DateTime(2026, 10, 14, 23, 59);
      final h = await _pump(tester, reels: _reels(), clockOf: () => now);
      final before = _ids(h, tester);
      expect(h.feedState(tester).index, 0);

      // Saat gece yarısını geçti; ekran kendiliğinden yeniden seçmez.
      now = DateTime(2026, 10, 15, 0, 1);
      await h.settle(tester);
      expect(h.feedState(tester).index, 0);
      expect(_ids(h, tester), before);
      expect(h.video.isPlaying('A1-R-CIN-01.mp4'), isTrue);
      await h.unmount(tester);
    });
  });

  group('gün içi değişiklik', () {
    testWidgets('seviye değişince yeni seçim; günlük sayaç silinmez', (
      tester,
    ) async {
      final h = await _pump(tester);
      await h.watched(tester, 120);
      expect(
        h.feedState(tester).feed.whereType<VideoEntry>().first.video.id,
        'A1-R-CIN-01',
      );

      await _tap(tester, h, 'level-chip');
      await _tap(tester, h, 'level-option-A2');
      expect(
        h.feedState(tester).feed.whereType<VideoEntry>().map((e) => e.video.id),
        ['A2-R-CIN-01', 'A2-R-SPO-01', 'A2-R-BOK-01'],
      );
      final store = DiscoverStore(h.db);
      final set = await tester.runAsync(() => store.dailySet(h.clock));
      expect(set!.level, 'A2');
      final watched = await tester.runAsync(
        () => store.watchedSeconds(h.clock),
      );
      expect(watched, 120);
      await h.unmount(tester);
    });
  });

  group('geri çekme ve içerik sürümü', () {
    testWidgets('sabit seçkide geri çekilen içerik yedekle değiştirilir', (
      tester,
    ) async {
      // Seçki dün CIN-01 ile yazılmış; bugün CIN-01 geri çekildi.
      final h = DiscoverHarness(
        chip: DiscoverChip.today,
        withReels: true,
        reels: _reels(cinStatus: 'WITHDRAWN'),
        suggestedLevel: 'A1',
      );
      addTearDown(h.dispose);
      await tester.runAsync(
        () => DiscoverStore(h.db).setDailySet(
          h.clock,
          const DailySet(
            level: 'A1',
            categories: ['CIN', 'SPO', 'BOK'],
            items: [
              DailyItem(id: 'A1-R-CIN-01', contentVersion: 1),
              DailyItem(id: 'A1-R-SPO-01', contentVersion: 1),
              DailyItem(id: 'A1-R-BOK-01', contentVersion: 1),
            ],
          ),
        ),
      );
      await h.pump(tester);

      expect(_ids(h, tester), ['A1-R-CIN-02', 'A1-R-SPO-01', 'A1-R-BOK-01']);
      expect(_key('reel-page-A1-R-CIN-01'), findsNothing);
      // Yedek **kalıcıdır**: sabit seçki güncellenir.
      final set = await tester.runAsync(
        () => DiscoverStore(h.db).dailySet(h.clock),
      );
      expect(set!.items.map((i) => i.id), [
        'A1-R-CIN-02',
        'A1-R-SPO-01',
        'A1-R-BOK-01',
      ]);
      await h.unmount(tester);
    });

    testWidgets('içerik sürümü artınca "Tekrar" kalkar, sonuç taşınmaz', (
      tester,
    ) async {
      final h = DiscoverHarness(
        chip: DiscoverChip.today,
        withReels: true,
        reels: _reels(cinVersion: 2, secondCinema: false),
        suggestedLevel: 'A1',
      );
      addTearDown(h.dispose);
      // Eski sürümde (v1) dün gösterilmiş ve tamamlanmış.
      await tester.runAsync(
        () => DiscoverStore(h.db).mergeProgress(
          'A1-R-CIN-01',
          contentVersion: 1,
          addSeconds: 10,
          completed: true,
          shownDay: '2026-10-13',
          practiceResult: PracticeResult.correct,
        ),
      );
      await h.pump(tester);

      expect(_key('reel-page-A1-R-CIN-01'), findsOneWidget);
      expect(_key('reel-repeat'), findsNothing);
      final set = await tester.runAsync(
        () => DiscoverStore(h.db).dailySet(h.clock),
      );
      expect(set!.items.first.contentVersion, 2);

      final progress = await tester.runAsync(
        () => DiscoverStore(h.db).reelProgress('A1-R-CIN-01'),
      );
      expect(progress!.contentVersion, 2);
      expect(progress.completed, isFalse);
      expect(progress.practiceResult, isNull);
      expect(progress.watchedSeconds, lessThan(10));
      await h.unmount(tester);
    });

    testWidgets('daha önce gösterilen video açıkça "Tekrar" etiketlenir', (
      tester,
    ) async {
      final h = DiscoverHarness(
        chip: DiscoverChip.today,
        withReels: true,
        reels: _reels(secondCinema: false),
        suggestedLevel: 'A1',
      );
      addTearDown(h.dispose);
      await tester.runAsync(
        () => DiscoverStore(h.db).mergeProgress(
          'A1-R-CIN-01',
          contentVersion: 1,
          shownDay: '2026-10-13',
        ),
      );
      await h.pump(tester);
      expect(_key('reel-page-A1-R-CIN-01'), findsOneWidget);
      expect(_key('reel-repeat'), findsOneWidget);
      expect(find.text('Tekrar'), findsOneWidget);
      final semantics = tester.ensureSemantics();
      expect(
        find.bySemanticsLabel(RegExp('Bu video daha önce gösterildi')),
        findsWidgets,
      );
      semantics.dispose();
      await h.unmount(tester);
    });

    testWidgets('en uzun süredir gösterilmemiş seçilir; ertesi gün döner', (
      tester,
    ) async {
      var now = DateTime(2026, 10, 14, 10);
      final h = DiscoverHarness(
        chip: DiscoverChip.today,
        withReels: true,
        reels: _reels(),
        suggestedLevel: 'A1',
        clockOf: () => now,
      );
      addTearDown(h.dispose);
      await tester.runAsync(() async {
        final store = DiscoverStore(h.db);
        // İkisi de gösterilmiş, hiçbiri tamamlanmamış: eski olan önce gelir.
        await store.mergeProgress(
          'A1-R-CIN-01',
          contentVersion: 1,
          shownDay: '2026-10-12',
        );
        await store.mergeProgress(
          'A1-R-CIN-02',
          contentVersion: 1,
          shownDay: '2026-10-13',
        );
      });
      await h.pump(tester);
      expect(_ids(h, tester), ['A1-R-CIN-01', 'A1-R-SPO-01', 'A1-R-BOK-01']);
      // Daha önce gösterildiği için açıkça "Tekrar".
      expect(_key('reel-repeat'), findsOneWidget);

      // Ertesi gün: 01 dün gösterildi, 02 daha eski → 02 döner.
      await h.unmount(tester);
      now = DateTime(2026, 10, 15, 10);
      await h.pump(tester);
      expect(_ids(h, tester), ['A1-R-CIN-02', 'A1-R-SPO-01', 'A1-R-BOK-01']);
      expect(_key('reel-repeat'), findsOneWidget);
      await h.unmount(tester);
    });
  });

  group('aynı gün kalınan yer (plan §5)', () {
    testWidgets('günlük sette kalınan video yeniden açılır', (tester) async {
      final h = await _pump(tester, reels: _reels());
      h.feedState(tester).jumpTo(2); // ikinci video (Spor)
      await h.settle(tester);
      expect(_key('reel-page-A1-R-SPO-01'), findsOneWidget);
      final saved = await tester.runAsync(
        () => DiscoverStore(h.db).resumeId(h.clock),
      );
      expect(saved, 'A1-R-SPO-01');

      await h.unmount(tester);
      await h.pump(tester);
      expect(h.feedState(tester).index, 2);
      expect(_key('reel-page-A1-R-SPO-01'), findsOneWidget);
      await h.unmount(tester);
    });

    testWidgets('kategori havuzu günlük setin kalınan yerini değiştirmez', (
      tester,
    ) async {
      final h = await _pump(tester, reels: _reels());
      expect(
        await tester.runAsync(() => DiscoverStore(h.db).resumeId(h.clock)),
        'A1-R-CIN-01',
      );
      await tester.ensureVisible(_key('chip-cinema'));
      await _tap(tester, h, 'chip-cinema');
      await h.swipeUp(tester); // havuzda gezinme
      expect(
        await tester.runAsync(() => DiscoverStore(h.db).resumeId(h.clock)),
        'A1-R-CIN-01',
      );
      await h.unmount(tester);
    });

    testWidgets('yeni gün kalınan yer taşınmaz', (tester) async {
      var now = DateTime(2026, 10, 14, 10);
      final h = await _pump(tester, reels: _reels(), clockOf: () => now);
      h.feedState(tester).jumpTo(2);
      await h.settle(tester);
      await h.unmount(tester);

      now = DateTime(2026, 10, 15, 10);
      await h.pump(tester);
      expect(h.feedState(tester).index, 0);
      final store = DiscoverStore(h.db);
      expect(await tester.runAsync(() => store.resumeId(now)), 'A1-R-CIN-02');
      expect(
        await tester.runAsync(() => store.resumeId(DateTime(2026, 10, 14, 10))),
        isNull,
      );
      await h.unmount(tester);
    });
  });

  group('tamamlanma ölçümü (plan §5)', () {
    testWidgets('sona yaklaşma + yeterli aktif izleme tamamlanma sayılır', (
      tester,
    ) async {
      final h = await _pump(
        tester,
        durationFor: (_) => const Duration(seconds: 10),
        positionFor: (_) => const Duration(milliseconds: 9200),
      );
      // 9 sn aktif oynatma ≥ sürenin %80'i (8 sn).
      await tester.pump(const Duration(seconds: 9));
      expect(h.video.isPlaying('A1-R-CIN-01.mp4'), isTrue);
      await h.swipeUp(tester); // sayfa değişimi ilerlemeyi yazar
      final p = await tester.runAsync(
        () => DiscoverStore(h.db).reelProgress('A1-R-CIN-01'),
      );
      expect(p!.completed, isTrue);
      expect(p.lastShownDay, localDayKey(h.clock));
      await h.unmount(tester);
    });

    // H-096 (21 Ekim 2026 takip incelemesi): konum %90'a atlarsa (ileri
    // sarma, son parçaya geçiş) kısa bir izleme tamamlanma yazıyordu.
    testWidgets('sona atlayıp kısa izlemek tamamlanma sayılmaz', (
      tester,
    ) async {
      final h = await _pump(
        tester,
        durationFor: (_) => const Duration(seconds: 10),
        positionFor: (_) => const Duration(milliseconds: 9200),
      );
      // Konum %92, ama yalnız 2 sn aktif oynatma (< %80 = 8 sn).
      await tester.pump(const Duration(seconds: 2));
      expect(h.video.isPlaying('A1-R-CIN-01.mp4'), isTrue);
      await h.swipeUp(tester);
      final p = await tester.runAsync(
        () => DiscoverStore(h.db).reelProgress('A1-R-CIN-01'),
      );
      expect(p!.completed, isFalse);
      // Açık oynatma yine sayılır (ürün ölçümü).
      expect(p.watchedSeconds, greaterThan(0));
      await h.unmount(tester);
    });

    testWidgets('aynı iki saniyeyi döndürmek tamamlanma sayılmaz', (
      tester,
    ) async {
      final h = await _pump(
        tester,
        durationFor: (_) => const Duration(seconds: 10),
        positionFor: (_) => const Duration(seconds: 1),
      );
      await tester.pump(const Duration(seconds: 3));
      await h.swipeUp(tester);
      final p = await tester.runAsync(
        () => DiscoverStore(h.db).reelProgress('A1-R-CIN-01'),
      );
      expect(p!.completed, isFalse);
      // Açık oynatma yine sayılır (ürün ölçümü).
      expect(p.watchedSeconds, greaterThan(0));
      await h.unmount(tester);
    });
  });

  group('soru sonucu (ürün ölçümü, kanıt değil)', () {
    testWidgets('doğru cevap yalnız reel kaydına yazılır', (tester) async {
      final h = await _pump(tester);
      final s = h.feedState(tester);
      s.jumpTo(1); // ilk videonun kısa sorusu
      await h.settle(tester);
      expect(_key('practice-card'), findsOneWidget);
      await _tap(tester, h, 'practice-opt-0');

      final p = await tester.runAsync(
        () => DiscoverStore(h.db).reelProgress('A1-R-CIN-01'),
      );
      expect(p!.practiceResult, PracticeResult.correct);
      // Defter'e ve anlam olayına yazılmaz (kanıt değil).
      final items = await tester.runAsync(() => NotebookStore(h.db).entries());
      expect(items, isEmpty);
      expect(h.learningLog.events, isEmpty);
      await h.unmount(tester);
    });

    testWidgets('"Atla" sonucu atlandı olarak yazılır, ilerleme açık kalır', (
      tester,
    ) async {
      final h = await _pump(tester);
      h.feedState(tester).jumpTo(1);
      await h.settle(tester);
      await _tap(tester, h, 'practice-skip');
      expect(h.feedState(tester).index, 2);
      final p = await tester.runAsync(
        () => DiscoverStore(h.db).reelProgress('A1-R-CIN-01'),
      );
      expect(p!.practiceResult, PracticeResult.skipped);
      await h.unmount(tester);
    });
  });
}
