// H-094 P1: günlük üç video (bağımsız reeller), her videonun sonunda
// atlanabilir tek anlama sorusu, sakin bitiş, çipler ve seviye paneli;
// eski hikâye kliplerinin bozulmadığı ve reel kaynağının Defter'e görsel/ses
// bağlantısını doğru kurduğu burada kanıtlanır.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/discover/application/discover_providers.dart';
import 'package:hivelzon/features/discover/data/discover_store.dart';
import 'package:hivelzon/features/discover/domain/feed.dart';
import 'package:hivelzon/features/discover/domain/reel.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/shared/content/content_source.dart';

import '../../support/discover_harness.dart';
import '../../support/fake_content_source.dart';

Finder _key(String k) => find.byKey(ValueKey(k));

Future<void> _tap(WidgetTester tester, DiscoverHarness h, String key) async {
  await tester.tap(_key(key));
  await h.settle(tester, rounds: 12);
}

/// Yatay kaydırılan çip satırında çipi görünür kılıp dokunur.
Future<void> _tapChip(WidgetTester tester, DiscoverHarness h, String key) async {
  await tester.ensureVisible(_key(key));
  await tester.pump();
  await _tap(tester, h, key);
}

/// Akış girdilerinin kısa gösterimi ('v' video, 'p' soru, 'd' sakin bitiş).
String _kinds(List<FeedEntry> feed) => [
  for (final e in feed)
    switch (e) {
      VideoEntry() => 'v',
      PracticeEntry() => 'p',
      DailyEndEntry() => 'd',
      ClipEntry() => 'c',
      QuizEntry() => 'q',
      BreakEntry() => 'b',
      EndEntry() => 'e',
    },
].join();

/// Günlük set açılışı (varsayılan çip "Bugün", A1 önerilen seviye).
Future<DiscoverHarness> _daily(
  WidgetTester tester, {
  TestAge age = TestAge.adult,
  int? watched,
  ReelCatalog? catalog,
  List<Reel>? reels,
  Duration Function(String uri)? durationFor,
  Duration Function(String uri)? positionFor,
  String? suggestedLevel = 'A1',
}) async {
  final h = DiscoverHarness(
    chip: DiscoverChip.today,
    age: age,
    withReels: true,
    reelCatalog: catalog,
    reels: reels,
    durationFor: durationFor,
    positionFor: positionFor,
    suggestedLevel: suggestedLevel,
  );
  addTearDown(h.dispose);
  if (watched != null) await h.watched(tester, watched);
  await h.pump(tester);
  return h;
}

/// [index] sayfasına gider.
Future<void> _jump(WidgetTester tester, DiscoverHarness h, int index) async {
  final s = h.feedState(tester);
  s.jumpTo(index);
  await h.settle(tester);
}

void main() {
  group('günlük seçki (Bugün)', () {
    testWidgets('üç video var; her videonun sonunda tek soru, sonda sakin bitiş', (
      tester,
    ) async {
      final h = await _daily(tester);
      final s = h.feedState(tester);

      // Sıra: video → soru → video → soru → video → soru → bitiş.
      expect(_kinds(s.feed), 'vpvpvpd');
      expect(s.feed.whereType<VideoEntry>().length, 3);
      expect(s.feed.whereType<PracticeEntry>().length, 3);
      expect(s.feed.last, isA<DailyEndEntry>());
      // `quizEvery = 4` düzeni günlük sette çalışmaz (plan §7).
      expect(s.feed.whereType<QuizEntry>(), isEmpty);
      expect(s.feed.whereType<BreakEntry>(), isEmpty);

      // Seçki seviyeye göre kararlı: A1'in üç konusu, kimliğe göre sıralı.
      expect(
        s.feed.whereType<VideoEntry>().map((e) => e.video.id),
        ['A1-R-BOK-01', 'A1-R-CIN-01', 'A1-R-SPO-01'],
      );
      expect(
        s.feed.whereType<VideoEntry>().map((e) => e.ordinal),
        [1, 2, 3],
      );

      // Başlık ve rozet: kategori · seviye.
      expect(find.text('Bugün senin için 3 kısa video'), findsOneWidget);
      expect(_key('reel-page-A1-R-BOK-01'), findsOneWidget);
      expect(find.text('Kitap · A1'), findsOneWidget);
      expect(find.text('Kütüphanede kitap seçimi'), findsOneWidget);

      // Sonsuz akış yok: sayfa sayısı akışın uzunluğu kadar.
      await _jump(tester, h, s.feed.length - 1);
      await h.swipeUp(tester);
      expect(h.feedState(tester).index, s.feed.length - 1);

      await h.unmount(tester);
    });

    testWidgets('video bitince kendiliğinden geçmez: "Tekrar izle"', (
      tester,
    ) async {
      final h = await _daily(
        tester,
        durationFor: (_) => const Duration(seconds: 2),
      );
      await tester.pump(const Duration(seconds: 3));
      await h.settle(tester);
      expect(h.feedState(tester).index, 0);
      expect(_key('reel-replay'), findsOneWidget);
      expect(_key('reel-swipe-hint'), findsOneWidget);
      // Sıradaki sayfa kısa soru: ipucu onu söyler (K-32).
      expect(find.text('Kısa soru için yukarı kaydır.'), findsOneWidget);
      await _tap(tester, h, 'reel-replay');
      expect(h.video.isPlaying('A1-R-BOK-01.mp4'), isTrue);
      await h.unmount(tester);
    });

    testWidgets('sakin bitiş: kaçırma baskısı ve geri sayım yok', (
      tester,
    ) async {
      final h = await _daily(tester);
      final s = h.feedState(tester);
      await _jump(tester, h, s.feed.length - 1);

      expect(_key('daily-end-card'), findsOneWidget);
      expect(find.text('Bugünkü seçkini tamamladın'), findsOneWidget);
      expect(
        find.text('Bugünün 3 videosunu izledin. Yarın yeni videolar gelir.'),
        findsOneWidget,
      );
      // Süreli içerik algısı yok: geri sayım / "kaçırma" dili yok.
      expect(find.textContaining('kaldı'), findsNothing);
      expect(find.textContaining('kaçır'), findsNothing);
      expect(find.textContaining('saniye'), findsNothing);

      // "Hikâye kliplerine bak" çipi değiştirir; eski klip akışı açılır.
      await _tap(tester, h, 'daily-end-more');
      expect(find.text('Bölümlerden kısa klipler'), findsOneWidget);
      expect(_key('clip-page-S1-K01'), findsOneWidget);

      await h.unmount(tester);
    });

    testWidgets('denetleyici sınırı: günlük sette de en çok 3', (tester) async {
      final h = await _daily(tester);
      final s = h.feedState(tester);
      var maxLive = 0;
      for (var i = 0; i < s.feed.length; i++) {
        await h.swipeUp(tester);
        expect(h.video.liveCount, lessThanOrEqualTo(3));
        expect(s.cache.liveCount, lessThanOrEqualTo(3));
        if (h.video.liveCount > maxLive) maxLive = h.video.liveCount;
      }
      expect(maxLive, lessThanOrEqualTo(3));
      expect(s.cache.peakLive, lessThanOrEqualTo(3));
      await h.unmount(tester);
      await tester.pump(const Duration(seconds: 1));
      expect(h.video.liveCount, 0);
    });
  });

  group('video sonundaki mini soru', () {
    testWidgets('yanlış cevap ilerlemeyi engellemez; "Atla" ile geçilir', (
      tester,
    ) async {
      final h = await _daily(tester);
      await _jump(tester, h, 1);

      expect(_key('practice-card'), findsOneWidget);
      expect(find.text('Oyuncu ne istiyor?'), findsNothing);
      // İlk sıradaki videonun sorusu (A1-R-BOK-01).
      expect(find.text('Ne soruluyor?'), findsOneWidget);
      expect(find.text('Video: Kütüphanede kitap seçimi'), findsOneWidget);

      // Yanlış seçenek (Kitap güzel mi? → 1. seçenek doğru; 3. seçenek yanlış).
      await _tap(tester, h, 'practice-opt-2');
      expect(find.text('Bir daha bakalım.'), findsOneWidget);
      expect(h.feedState(tester).index, 1);

      // Atlanabilir: yanlış cevaptan sonra da "Atla" görünür.
      expect(_key('practice-skip'), findsOneWidget);
      await _tap(tester, h, 'practice-skip');
      expect(h.feedState(tester).index, 2);
      expect(_key('reel-page-A1-R-CIN-01'), findsOneWidget);
      await h.unmount(tester);
    });

    testWidgets('doğru cevapta açıklama ve "Sonraki video"', (tester) async {
      final h = await _daily(tester);
      await _jump(tester, h, 1);
      await _tap(tester, h, 'practice-opt-0');
      expect(find.text('Evet, doğru.'), findsOneWidget);
      expect(find.text('Kitabın güzel olup olmadığı soruluyor.'), findsOneWidget);
      await _tap(tester, h, 'practice-next');
      expect(h.feedState(tester).index, 2);
      await h.unmount(tester);
    });

    testWidgets('"Bilmiyorum" doğru cevabı gösterir, ilerleme açık kalır', (
      tester,
    ) async {
      final h = await _daily(tester);
      await _jump(tester, h, 1);
      await _tap(tester, h, 'practice-dont-know');
      expect(find.text('Doğru cevap bu.'), findsOneWidget);
      expect(_key('practice-next'), findsOneWidget);
      await h.unmount(tester);
    });
  });

  group('çipler ve seviye', () {
    testWidgets('kategori çipi o kategorinin havuzunu gösterir', (
      tester,
    ) async {
      final h = await _daily(tester);
      await _tapChip(tester, h, 'chip-cinema');
      expect(find.text('Sinema havuzu'), findsOneWidget);
      expect(
        h.feedState(tester).feed.whereType<VideoEntry>().map((e) => e.video.id),
        ['A1-R-CIN-01'],
      );
      // Havuzda "daha fazla" düğmesi yok (o zaten havuz).
      await _jump(tester, h, 2);
      expect(_key('daily-end-card'), findsOneWidget);
      expect(_key('daily-end-more'), findsNothing);

      await _tapChip(tester, h, 'chip-sport');
      expect(find.text('Spor havuzu'), findsOneWidget);
      expect(
        h.feedState(tester).feed.whereType<VideoEntry>().map((e) => e.video.id),
        ['A1-R-SPO-01'],
      );

      // "Hikâye klipleri" eski akışa döner (kaynak türleri karışmaz).
      await _tapChip(tester, h, 'chip-storyClips');
      expect(_key('clip-page-S1-K01'), findsOneWidget);
      expect(h.feedState(tester).feed.whereType<VideoEntry>(), isEmpty);
      await h.unmount(tester);
    });

    testWidgets('seviye paneli: A2 seçilir, cihazda saklanır, geri dönülebilir', (
      tester,
    ) async {
      final h = await _daily(tester);
      expect(find.text('Seviye: A1'), findsOneWidget);

      await _tap(tester, h, 'level-chip');
      // Başlık CapsLabel ile büyütülür.
      expect(find.text('Keşfet zorluğu'.toUpperCase()), findsOneWidget);
      expect(
        find.textContaining('yerleştirme sonucunu değiştirmez'),
        findsOneWidget,
      );
      expect(find.text('Önerilen seviyem (A1)'), findsOneWidget);

      await _tap(tester, h, 'level-option-A2');
      expect(find.text('Seviye: A2'), findsOneWidget);
      expect(
        h.feedState(tester).feed.whereType<VideoEntry>().map((e) => e.video.id),
        ['A2-R-BOK-01', 'A2-R-CIN-01', 'A2-R-SPO-01'],
      );
      final stored = await tester.runAsync(
        () => DiscoverStore(h.db).reelLevel(),
      );
      expect(stored, 'A2');

      // Uygulama yeniden açılsa da seçim kalır (aynı cihaz: aynı veritabanı).
      await h.unmount(tester);
      await h.pump(tester);
      expect(find.text('Seviye: A2'), findsOneWidget);
      await h.unmount(tester);
    });

    testWidgets('"Önerilen seviyeye dön" seçimi siler', (tester) async {
      final h = await _daily(tester);
      await _tap(tester, h, 'level-chip');
      await _tap(tester, h, 'level-option-A2');
      expect(find.text('Seviye: A2'), findsOneWidget);

      await _tap(tester, h, 'level-chip');
      await _tap(tester, h, 'level-reset');
      expect(find.text('Seviye: A1'), findsOneWidget);
      expect(
        h.feedState(tester).feed.whereType<VideoEntry>().map((e) => e.video.id),
        ['A1-R-BOK-01', 'A1-R-CIN-01', 'A1-R-SPO-01'],
      );
      final stored = await tester.runAsync(
        () => DiscoverStore(h.db).reelLevel(),
      );
      expect(stored, isNull);
      await h.unmount(tester);
    });

    testWidgets('yerleştirme bu seviyede değilse "önerilen seviyem" denmez', (
      tester,
    ) async {
      // B1 yerleştirmesi: katalogda B1 yok. A1 videoları "senin seviyen"
      // diye sunulmaz; kolay pratik olarak açıkça etiketlenir (K-06).
      final h = await _daily(tester, suggestedLevel: 'B1');
      expect(find.text('Seviye: A1'), findsOneWidget);

      await _tap(tester, h, 'level-chip');
      expect(find.textContaining('Önerilen seviyem'), findsNothing);
      expect(
        find.textContaining('kolay pratik olarak işaretli'),
        findsOneWidget,
      );

      // Elle seçim yine mümkün; geri alma "Seçimi kaldır" olur.
      await _tap(tester, h, 'level-option-A2');
      expect(find.text('Seviye: A2'), findsOneWidget);
      await _tap(tester, h, 'level-chip');
      expect(find.text('Seçimi kaldır'), findsOneWidget);
      await _tap(tester, h, 'level-reset');
      expect(find.text('Seviye: A1'), findsOneWidget);
      await h.unmount(tester);
    });
  });

  group('"Tam hikâye" ve geri çekme', () {
    testWidgets('gerçek bölüm bağı yoksa düğme gizlenir', (tester) async {
      final h = await _daily(tester);
      expect(_key('reel-page-A1-R-BOK-01'), findsOneWidget);
      expect(_key('reel-full-story'), findsNothing);
      await h.unmount(tester);
    });

    testWidgets('gerçek bölüm bağı varsa düğme bölümü açar', (tester) async {
      final catalog = catalogWith();
      final h = await _daily(
        tester,
        catalog: catalog,
        reels: [
          reelWith(
            'A1-R-BOK-01',
            related: [
              {'kind': 'episode', 'id': 'A1-001', 'titleTr': 'A Strange Message'},
            ],
          ),
          ...reelsWithoutPosters(
            catalog,
          ).where((r) => r.id != 'A1-R-BOK-01'),
        ],
      );
      expect(_key('reel-full-story'), findsOneWidget);
      await _tap(tester, h, 'reel-full-story');
      expect(h.opened, ['play:A1-001']);
      await h.unmount(tester);
    });

    testWidgets('geri çekilen reel seçkide oynatılmaz', (tester) async {
      final h = await _daily(
        tester,
        catalog: catalogWith(withdraw: ['A1-R-CIN-01']),
      );
      final s = h.feedState(tester);
      expect(
        s.feed.whereType<VideoEntry>().map((e) => e.video.id),
        ['A1-R-BOK-01', 'A1-R-SPO-01'],
      );
      expect(find.text('Bugün senin için 2 kısa video'), findsOneWidget);
      expect(_key('reel-page-A1-R-CIN-01'), findsNothing);
      await h.unmount(tester);
    });
  });

  group('Defter bağlantısı (reel kaynağı)', () {
    testWidgets('"Kaydet": ifade görsel ve ses bağlantısıyla eklenir', (
      tester,
    ) async {
      final h = await _daily(tester);
      expect(find.text('Kaydet'), findsOneWidget);
      await _tap(tester, h, 'reel-save');
      expect(find.text('"Is this book good?" deftere eklendi.'), findsOneWidget);
      expect(find.text('Defterinde'), findsOneWidget);

      final items = await tester.runAsync(() => NotebookStore(h.db).entries());
      final item = items!.single.item;
      expect(item.textEn, 'Is this book good?');
      expect(item.textTr, 'Bu kitap güzel mi?');
      // Kaynak: reel paketi (bölüm değil).
      expect(item.contentId, 'A1-R-BOK-01');
      expect(item.cueId, 's02-02');
      expect(item.episodeTag, isNull);
      expect(item.sourceTitle, 'Keşfet: Kitap · Kütüphanede kitap seçimi');

      // Görsel ve ses doğru reel paketine çözülür.
      expect(item.imagePath, '_reels/A1-R-BOK-01/stills/s02.webp');
      expect(item.audio!.path, '_reels/A1-R-BOK-01/audio/s02-02.m4a');
      final source = h.source;
      expect(
        resolveMediaUri(source, item.contentId!, item.imagePath!).toString(),
        'http://test.invalid/reels/A1-R-BOK-01/stills/s02.webp',
      );
      expect(
        resolveMediaUri(source, item.contentId!, item.audio!.path).toString(),
        'http://test.invalid/reels/A1-R-BOK-01/audio/s02-02.m4a',
      );

      // İkinci kez eklenmez (mevcut davranış korunur).
      await _tap(tester, h, 'reel-save');
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('"Is this book good?" zaten defterinde.'), findsOneWidget);
      final again = await tester.runAsync(() => NotebookStore(h.db).entries());
      expect(again, hasLength(1));
      await h.unmount(tester);
    });

    testWidgets('"Anlam" paneli reel hedefini açar ve oradan eklenir', (
      tester,
    ) async {
      final h = await _daily(
        tester,
        durationFor: (_) => const Duration(seconds: 16),
        positionFor: (_) => const Duration(milliseconds: 4200),
      );
      await tester.pump(const Duration(milliseconds: 600));
      await h.settle(tester, rounds: 5);
      await _tap(tester, h, 'reel-meaning');
      expect(find.text('Is this book good?'), findsWidgets);
      expect(h.video.isPlaying('A1-R-BOK-01.mp4'), isFalse);
      await h.unmount(tester);
    });
  });

  group('günlük süre sınırı (K-15)', () {
    testWidgets('13–17: süre dolmuşsa günlük set de açılmaz', (tester) async {
      final h = await _daily(tester, age: TestAge.teen, watched: 20 * 60);
      expect(_key('limit-card'), findsOneWidget);
      expect(_key('discover-pages'), findsNothing);
      expect(_key('reel-page-A1-R-BOK-01'), findsNothing);
      expect(h.video.liveCount, 0);
      await h.unmount(tester);
    });
  });

  group('boş ve hata durumları', () {
    testWidgets('havuz boşsa sakin boş durum ve "Bugüne dön"', (tester) async {
      // Spor reelleri geri çekilmiş: Spor havuzu boş, günlük sette Sinema var.
      final h = await _daily(
        tester,
        catalog: catalogWith(withdraw: ['A1-R-BOK-01', 'A1-R-SPO-01']),
      );
      await _tapChip(tester, h, 'chip-sport');
      expect(find.text('Spor havuzu'), findsOneWidget);
      expect(_key('reels-empty'), findsOneWidget);
      expect(find.text('Burada henüz video yok'), findsOneWidget);

      // Boş durum günlük sete döndürür (zorlamaz, sakin).
      await _tap(tester, h, 'reels-today');
      expect(
        h.feedState(tester).feed.whereType<VideoEntry>().map((e) => e.video.id),
        ['A1-R-CIN-01'],
      );
      expect(find.text('Bugün senin için 1 kısa video'), findsOneWidget);
      await h.unmount(tester);
    });

    testWidgets('reeller yüklenemezse hata ve "Tekrar dene"', (tester) async {
      final h = DiscoverHarness(
        chip: DiscoverChip.today,
        withReels: true,
        reelsFail: true,
      );
      addTearDown(h.dispose);
      await h.pump(tester);
      expect(_key('reels-error'), findsOneWidget);
      expect(_key('reels-retry'), findsOneWidget);
      await h.unmount(tester);
    });
  });
}
