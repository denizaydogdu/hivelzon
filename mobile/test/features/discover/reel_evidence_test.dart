// H-094 P3: kanıt ve Defter bağı (plan §7).
//
// - **Kaydet** yalnızca **ifadeyi** ekler (video koleksiyonu yok), kanıt
//   yazmaz; yeni kart normal tekrar planına girer.
// - İzlemek, tekrar izlemek, altyazı/anlam açmak, seçenekten doğruyu bulmak
//   → **kanıt yazılmaz** (H-089).
// - Videonun sonundaki soru sonucu **ayrı** saklanır (`discover.reel.<id>`);
//   Defter kartı (FSRS), `review_logs` ve kanıt değişmez.
// - "Tam hikâye" yalnız gezinmedir; kanıt/Defter yazmaz.
// - Reel kaynağından eklenen ifade **görseli, sesi ve kaynağıyla** geri
//   açılır (bölüm etiketi taşımaz).
//
// Taklit ("Sen de söyle") kuralı H-093'te sınanır: yalnız `helped`, kart
// değişmez (`test/features/speak/speak_places_test.dart`).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/discover/application/discover_providers.dart';
import 'package:hivelzon/features/discover/data/discover_store.dart';
import 'package:hivelzon/features/discover/domain/reel.dart';
import 'package:hivelzon/features/discover/domain/reel_progress.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/shared/content/content_source.dart';

import '../../support/discover_harness.dart';
import '../../support/fake_content_source.dart';

Finder _key(String k) => find.byKey(ValueKey(k));

Future<void> _tap(WidgetTester tester, DiscoverHarness h, String key) async {
  await tester.tap(_key(key));
  await h.settle(tester, rounds: 12);
}

Future<DiscoverHarness> _pump(
  WidgetTester tester, {
  List<Reel>? reels,
  Duration Function(String uri)? durationFor,
  Duration Function(String uri)? positionFor,
}) async {
  final h = DiscoverHarness(
    chip: DiscoverChip.today,
    withReels: true,
    reels: reels,
    suggestedLevel: 'A1',
    durationFor: durationFor,
    positionFor: positionFor,
  );
  addTearDown(h.dispose);
  await h.pump(tester);
  return h;
}

void main() {
  group('kaydetme ayrımı (plan §7)', () {
    testWidgets('"Kaydet" yalnız ifadeyi ekler; kanıt ve cevap yazılmaz', (
      tester,
    ) async {
      final h = await _pump(tester);
      await _tap(tester, h, 'reel-save');

      final store = NotebookStore(h.db);
      final entries = await tester.runAsync(() => store.entries());
      expect(entries, hasLength(1));
      final e = entries!.single;
      expect(e.item.textEn, 'Two tickets, please.');
      expect(e.item.kind, NotebookKind.phrase);
      // Yeni kart: normal tekrar planına girer, "cevaplanmış" değildir.
      expect(e.card.isNew, isTrue);
      expect(e.card.reps, 0);
      // Kanıt ve cevap kaydı yok.
      expect(await tester.runAsync(() => store.evidence()), isEmpty);
      expect(
        await tester.runAsync(() => h.db.select(h.db.reviewLogs).get()),
        isEmpty,
      );
      // Video "kaydedildi" gibi bir koleksiyon/ek kayıt yok.
      expect(
        await tester.runAsync(() => h.db.select(h.db.notebookItems).get()),
        hasLength(1),
      );
      await h.unmount(tester);
    });

    testWidgets('"Anlam" panelinden ekleme: kanıt yok, reel bağı korunur', (
      tester,
    ) async {
      final h = await _pump(
        tester,
        durationFor: (_) => const Duration(seconds: 16),
        positionFor: (_) => const Duration(milliseconds: 4200),
      );
      await _tap(tester, h, 'reel-meaning');
      expect(_key('meaning-save'), findsOneWidget);
      await _tap(tester, h, 'meaning-save');
      await _tap(tester, h, 'meaning-close');

      final store = NotebookStore(h.db);
      final e = (await tester.runAsync(() => store.entries()))!.single;
      expect(e.item.textEn, 'Two tickets, please.');
      expect(e.item.sourceTitle, 'Keşfet: Sinema · Gişede iki bilet');
      expect(e.item.episodeTag, isNull);
      expect(e.item.imagePath, '_reels/A1-R-CIN-01/stills/s02.webp');
      expect(e.item.audio!.path, '_reels/A1-R-CIN-01/audio/s02-02.m4a');
      expect(await tester.runAsync(() => store.evidence()), isEmpty);
      await h.unmount(tester);
    });
  });

  group('izlemek ve gezinmek kanıt yazmaz', () {
    testWidgets('izleme + anlam paneli + tekrar: kanıt ve cevap yok', (
      tester,
    ) async {
      final h = await _pump(
        tester,
        durationFor: (_) => const Duration(seconds: 10),
        positionFor: (_) => const Duration(milliseconds: 2500),
      );
      await tester.pump(const Duration(seconds: 3));
      await _tap(tester, h, 'reel-meaning');
      await _tap(tester, h, 'meaning-close');
      await tester.pump(const Duration(seconds: 2));

      final store = NotebookStore(h.db);
      expect(await tester.runAsync(() => store.evidence()), isEmpty);
      expect(await tester.runAsync(() => store.entries()), isEmpty);
      // İzleme ölçümü yine yazılır (kanıt değil).
      final p = await tester.runAsync(
        () => DiscoverStore(h.db).reelProgress('A1-R-CIN-01'),
      );
      expect(p!.watchedSeconds, greaterThan(0));
      await h.unmount(tester);
    });

    testWidgets('"Tam hikâye" yalnız bölümü açar; kanıt yazılmaz', (
      tester,
    ) async {
      final catalog = catalogWith();
      final h = await _pump(
        tester,
        reels: [
          reelWith(
            'A1-R-CIN-01',
            related: [
              {
                'kind': 'episode',
                'id': 'A1-001',
                'titleTr': 'A Strange Message',
              },
            ],
          ),
          ...reelsWithoutPosters(catalog).where((r) => r.id != 'A1-R-CIN-01'),
        ],
      );
      expect(_key('reel-full-story'), findsOneWidget);
      await _tap(tester, h, 'reel-full-story');
      expect(h.opened, contains('play:A1-001'));
      final store = NotebookStore(h.db);
      expect(await tester.runAsync(() => store.evidence()), isEmpty);
      expect(await tester.runAsync(() => store.entries()), isEmpty);
      await h.unmount(tester);
    });
  });

  group('soru sonucu ayrı saklanır (FSRS/kanıt değişmez)', () {
    testWidgets('doğru cevap yalnız practiceResult; kart ve kanıt sabit', (
      tester,
    ) async {
      final h = await _pump(tester);
      await _tap(tester, h, 'reel-save');
      final store = NotebookStore(h.db);
      final before = (await tester.runAsync(
        () => store.entries(),
      ))!.single.card;

      h.feedState(tester).jumpTo(1);
      await h.settle(tester);
      expect(_key('practice-card'), findsOneWidget);
      await _tap(tester, h, 'practice-opt-0');

      final p = await tester.runAsync(
        () => DiscoverStore(h.db).reelProgress('A1-R-CIN-01'),
      );
      expect(p!.practiceResult, PracticeResult.correct);

      final after = (await tester.runAsync(() => store.entries()))!.single.card;
      expect(after.reps, before.reps);
      expect(after.fsrs.due, before.fsrs.due);
      expect(after.fsrs.state, before.fsrs.state);
      expect(after.isNew, isTrue);
      expect(await tester.runAsync(() => store.evidence()), isEmpty);
      expect(
        await tester.runAsync(() => h.db.select(h.db.reviewLogs).get()),
        isEmpty,
      );
      await h.unmount(tester);
    });

    testWidgets('"Bilmiyorum" ve "Atla" da kanıt yazmaz', (tester) async {
      final h = await _pump(tester);
      await _tap(tester, h, 'reel-save');
      final store = NotebookStore(h.db);
      h.feedState(tester).jumpTo(1);
      await h.settle(tester);
      await _tap(tester, h, 'practice-dont-know');
      await _tap(tester, h, 'practice-next');
      expect(h.feedState(tester).index, 2);

      final p = await tester.runAsync(
        () => DiscoverStore(h.db).reelProgress('A1-R-CIN-01'),
      );
      expect(p!.practiceResult, PracticeResult.wrong);
      expect(await tester.runAsync(() => store.evidence()), isEmpty);
      final card = (await tester.runAsync(() => store.entries()))!.single.card;
      expect(card.isNew, isTrue);
      await h.unmount(tester);
    });
  });

  group('defterden geri açılma (reel kaynağı)', () {
    testWidgets('yeniden açılışta görsel/ses/kaynak aynı; adres reel paketi', (
      tester,
    ) async {
      final h = await _pump(tester);
      await _tap(tester, h, 'reel-save');
      await h.unmount(tester);

      // Yeni oturum (aynı cihaz): kayıt kalıcı.
      await h.pump(tester);
      final store = NotebookStore(h.db);
      final e = (await tester.runAsync(() => store.entries()))!.single;
      expect(e.item.textEn, 'Two tickets, please.');
      expect(e.item.contentId, 'A1-R-CIN-01');
      expect(e.item.episodeTag, isNull);
      expect(e.item.sourceTitle, 'Keşfet: Sinema · Gişede iki bilet');
      final source = h.source;
      expect(
        resolveMediaUri(
          source,
          e.item.contentId!,
          e.item.imagePath!,
        ).toString(),
        'http://test.invalid/reels/A1-R-CIN-01/stills/s02.webp',
      );
      expect(
        resolveMediaUri(
          source,
          e.item.contentId!,
          e.item.audio!.path,
        ).toString(),
        'http://test.invalid/reels/A1-R-CIN-01/audio/s02-02.m4a',
      );
      await h.unmount(tester);
    });
  });
}
