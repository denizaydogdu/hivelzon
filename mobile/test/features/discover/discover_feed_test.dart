// H-040 Keşfet akışı: sayfalama, quiz ve mola kartlarının yeri, bitiş kartı
// (sonsuz kaydırma yok), günlük süre (13–17, 13 altı, 18+), anlam paneli
// (durur / sürer), Defter'e kaydetme, "Tam hikâye", dilbilgisi etiketi,
// denetleyici sınırı (en çok 3), boş / hata durumları, "Hareketi azalt".
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/discover/domain/clip.dart';
import 'package:hivelzon/features/discover/domain/feed.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/shared/meaning/meaning_sheet.dart';

import '../../support/discover_harness.dart';
import '../../support/fake_content_source.dart';

Finder _key(String k) => find.byKey(ValueKey(k));

Future<void> _tap(WidgetTester tester, DiscoverHarness h, String key) async {
  await tester.tap(_key(key));
  await h.settle(tester, rounds: 12);
}

/// Klibi [n] kez kopyalayıp yeni kimlik verir (uzun akış için).
ClipCatalog _bigCatalog(int n) {
  final base = loadClipFixture();
  return ClipCatalog(
    season: 1,
    aiLabel: base.aiLabel,
    clips: [
      for (var i = 0; i < n; i++)
        copyClip(base.clips[i % base.clips.length], id: 'S1-K${i + 1}'),
    ],
  );
}

void main() {
  // ------------------------------------------------------------ saf kurallar

  group('akış düzeni (K-15)', () {
    test(
      'gerçek 17 klip: 4 klipte bir quiz, 10. klipten sonra mola, sonda bitiş',
      () {
        final feed = buildFeed(loadClipFixture().clips);
        final kinds = [
          for (final e in feed)
            switch (e) {
              ClipEntry() => 'c',
              QuizEntry() => 'q',
              BreakEntry() => 'b',
              EndEntry() => 'e',
            },
        ].join();
        expect(kinds, 'ccccqccccqccbccqccccqce');
        expect(feed.whereType<ClipEntry>().length, 17);
        expect(feed.last, isA<EndEntry>());
        // Quiz az önce izlenen klipten (4. ve 8. klip).
        final quizzes = feed.whereType<QuizEntry>().map((q) => q.clip.id);
        expect(quizzes.first, 'S1-K04');
        expect(quizzes.toSet().length, quizzes.length);
      },
    );

    test('4 klipte soru yoksa 5. klipte bakılır; yine yoksa quiz atlanır', () {
      final clips = loadClipFixture().clips;
      FeedClip noQuiz(FeedClip c) => FeedClip(
        id: c.id,
        episodeId: c.episodeId,
        titleTr: c.titleTr,
        video: c.video,
        duration: c.duration,
        target: c.target,
        subtitles: c.subtitles,
      );
      final list = [
        for (var i = 0; i < 9; i++) i == 4 ? clips[i] : noQuiz(clips[i]),
      ];
      final feed = buildFeed(list);
      final idx = feed.indexWhere((e) => e is QuizEntry);
      // 5 klipten sonra (4 klipte soru yoktu).
      expect(feed.take(idx).whereType<ClipEntry>().length, 5);
      expect(feed.whereType<QuizEntry>().length, 1);
      expect(
        buildFeed([for (final c in list) noQuiz(c)]).whereType<QuizEntry>(),
        isEmpty,
      );
    });

    test('mola ~10 klipte bir, sonda mola yok', () {
      final feed = buildFeed(_bigCatalog(30).clips);
      final breaks = [
        for (final (i, e) in feed.indexed)
          if (e is BreakEntry) (i, e.clipsBefore),
      ];
      expect(breaks.map((b) => b.$2), [10, 20]);
      expect(buildFeed(_bigCatalog(10).clips).whereType<BreakEntry>(), isEmpty);
    });

    test('günlük sınır: 13–17 ve 13 altı 20 dk, 18+ ve bilinmeyen yok', () {
      final now = DateTime(2026, 10, 14);
      expect(
        discoverLimitFor(now: now, adultFromYear: 2029).daily,
        const Duration(minutes: 20),
      );
      final u13 = discoverLimitFor(
        now: now,
        ageBlockedUntil: 2029,
        adultFromYear: 2034,
      );
      expect(u13.daily, const Duration(minutes: 20));
      expect(discoverLimitFor(now: now).limited, isFalse);
      // 18'e girilen yıl geldi: sınır kalkar.
      expect(discoverLimitFor(now: now, adultFromYear: 2026).limited, isFalse);
      expect(localDayKey(DateTime(2026, 1, 5, 23, 59)), '2026-01-05');
    });

    test('clips.json: altyazı klibe göre, hedef satırı ve dilbilgisi', () {
      final c = loadClipFixture().clips.first;
      expect(c.id, 'S1-K01');
      expect(c.target.en, 'Can you hear me?');
      expect(c.targetCue!.id, 's02-04');
      expect(c.grammarId, 'G-A1-07-can');
      // İkinci parça (k1-ok) 13,167. saniyede başlar.
      final k = c.subtitles.cues.last;
      expect(k.id, 'k1-ok-01');
      expect(k.start, greaterThan(13.1));
      expect(c.subtitles.cueAt(11.5)!.text, 'Can you hear me?');
    });
  });

  // ------------------------------------------------------------ ekran

  testWidgets('akış açılır: ilk klip oynar, sıradaki önceden açılır', (
    tester,
  ) async {
    final h = DiscoverHarness();
    addTearDown(h.dispose);
    await h.pump(tester);
    expect(_key('clip-page-S1-K01'), findsOneWidget);
    expect(find.text('Telsizde bir ses'), findsOneWidget);
    expect(find.text('Bölüm 1'), findsOneWidget);
    expect(_key('clip-grammar'), findsOneWidget);
    expect(find.textContaining('Yapay zekâ'), findsOneWidget);
    expect(h.video.isPlaying('S1-K01.mp4'), isTrue);
    expect(
      h.video.liveUris.where((u) => u.endsWith('S1-K02.mp4')),
      hasLength(1),
    );
    expect(h.video.liveCount, 2);
    await h.unmount(tester);
  });

  testWidgets('bütün akış: quiz, mola, bitiş; en çok 3 denetleyici', (
    tester,
  ) async {
    final h = DiscoverHarness(catalog: _bigCatalog(22));
    addTearDown(h.dispose);
    await h.pump(tester);
    final s = h.feedState(tester);
    final seen = <String>[];
    var maxLive = h.video.liveCount;
    for (var i = 0; i < s.feed.length + 2; i++) {
      final e = s.feed[s.index];
      seen.add(switch (e) {
        ClipEntry() => 'c',
        QuizEntry() => 'q',
        BreakEntry() => 'b',
        EndEntry() => 'e',
      });
      switch (e) {
        case QuizEntry():
          expect(_key('quiz-card'), findsOneWidget);
        case BreakEntry():
          expect(_key('break-card'), findsOneWidget);
          expect(find.textContaining('klip izledin'), findsOneWidget);
        case EndEntry():
          expect(_key('end-card'), findsOneWidget);
        case ClipEntry(:final clip):
          expect(h.video.isPlaying('${clip.id}.mp4'), isTrue);
      }
      expect(h.video.liveCount, lessThanOrEqualTo(3));
      expect(s.cache.liveCount, lessThanOrEqualTo(3));
      if (h.video.liveCount > maxLive) maxLive = h.video.liveCount;
      if (e is EndEntry) {
        // Sonsuz kaydırma yok: bitişten sonra sayfa yok.
        await h.swipeUp(tester);
        expect(h.feedState(tester).index, s.feed.length - 1);
        break;
      }
      await h.swipeUp(tester);
    }
    expect(seen.where((k) => k == 'c'), hasLength(22));
    expect(seen.join(), startsWith('ccccq'));
    expect(seen, contains('b'));
    expect(seen.last, 'e');
    expect(s.cache.peakLive, lessThanOrEqualTo(3));
    expect(maxLive, lessThanOrEqualTo(3));
    // Ölçüm (H-040 bellek raporu): kurulan / aynı anda en çok.
    debugPrint(
      '[H040] ölçüm: ${s.cache.created} denetleyici kuruldu, aynı anda en çok '
      '${s.cache.peakLive} (sahte platform en çok $maxLive)',
    );
    await h.unmount(tester);
    await tester.pump(const Duration(seconds: 1));
    expect(h.video.liveCount, 0);
  });

  testWidgets('altyazıya dokununca video durur, panel kapanınca sürer', (
    tester,
  ) async {
    final h = DiscoverHarness(
      durationFor: (_) => const Duration(seconds: 16),
      positionFor: (_) => const Duration(milliseconds: 11500),
    );
    addTearDown(h.dispose);
    await h.pump(tester);
    await tester.pump(const Duration(milliseconds: 600));
    await h.settle(tester, rounds: 5);
    expect(_key('clip-subtitle'), findsOneWidget);
    expect(find.text('Can you hear me?'), findsWidgets);
    await _tap(tester, h, 'clip-subtitle');
    expect(find.byType(MeaningSheet), findsOneWidget);
    expect(h.video.isPlaying('S1-K01.mp4'), isFalse);
    // Kapat → kaldığı yerden sürer.
    Navigator.of(tester.element(find.byType(MeaningSheet))).pop();
    await h.settle(tester);
    expect(find.byType(MeaningSheet), findsNothing);
    expect(h.video.isPlaying('S1-K01.mp4'), isTrue);
    await h.unmount(tester);
  });

  testWidgets('"Anlam" düğmesi hedef satırını açar; panelden deftere eklenir', (
    tester,
  ) async {
    final h = DiscoverHarness();
    addTearDown(h.dispose);
    await h.pump(tester);
    await _tap(tester, h, 'clip-meaning');
    expect(find.byType(MeaningSheet), findsOneWidget);
    expect(find.text('Can you hear me?'), findsWidgets);
    await tester.tap(find.text('Deftere ekle'));
    await h.settle(tester);
    final items = await tester.runAsync(() => NotebookStore(h.db).entries());
    expect(items!.single.item.textEn, 'Can you hear me?');
    expect(items.single.item.sourceTitle, 'Keşfet: A Strange Message');
    await h.unmount(tester);
  });

  testWidgets('"Kaydet": klibin ifadesi Defter\'e, kaynak "Keşfet: bölüm"', (
    tester,
  ) async {
    final h = DiscoverHarness();
    addTearDown(h.dispose);
    await h.pump(tester);
    expect(find.text('Kaydet'), findsOneWidget);
    await _tap(tester, h, 'clip-save');
    expect(find.text('"Can you hear me?" deftere eklendi.'), findsOneWidget);
    expect(find.text('Defterinde'), findsOneWidget);
    final items = await tester.runAsync(() => NotebookStore(h.db).entries());
    final item = items!.single.item;
    expect(item.textEn, 'Can you hear me?');
    expect(item.textTr, 'Beni duyabiliyor musun?');
    expect(item.contentId, 'A1-001');
    expect(item.cueId, 's02-04');
    expect(item.sourceTitle, 'Keşfet: A Strange Message');
    // İkinci kez: zaten defterinde.
    await _tap(tester, h, 'clip-save');
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('"Can you hear me?" zaten defterinde.'), findsOneWidget);
    await h.unmount(tester);
  });

  testWidgets('"Tam hikâye" bölümü açar, video durur', (tester) async {
    final h = DiscoverHarness();
    addTearDown(h.dispose);
    await h.pump(tester);
    await _tap(tester, h, 'clip-full-story');
    expect(h.opened, ['play:A1-001']);
    expect(h.video.isPlaying('S1-K01.mp4'), isFalse);
    await h.unmount(tester);
  });

  testWidgets('dilbilgisi etiketi dersi açar', (tester) async {
    final h = DiscoverHarness();
    addTearDown(h.dispose);
    await h.pump(tester);
    expect(find.textContaining('Dilbilgisi: can'), findsOneWidget);
    await _tap(tester, h, 'clip-grammar');
    expect(h.opened, ['lesson:G-A1-07-can']);
    await h.unmount(tester);
  });

  testWidgets('başka sayfa üstüne açılınca video durur', (tester) async {
    final h = DiscoverHarness();
    addTearDown(h.dispose);
    await h.pump(tester);
    expect(h.video.isPlaying('S1-K01.mp4'), isTrue);
    h.router.push('/hikaye');
    await h.settle(tester);
    expect(h.video.isPlaying('S1-K01.mp4'), isFalse);
    h.router.pop();
    await h.settle(tester);
    expect(h.video.isPlaying('S1-K01.mp4'), isTrue);
    await h.unmount(tester);
  });

  testWidgets('ses açık başlar; düğme sesi kapatır ve açar', (tester) async {
    final h = DiscoverHarness();
    addTearDown(h.dispose);
    await h.pump(tester);
    expect(find.bySemanticsLabel('Sesi kapat'), findsOneWidget);
    await _tap(tester, h, 'clip-mute');
    expect(find.bySemanticsLabel('Sesi aç'), findsOneWidget);
    await h.unmount(tester);
  });

  testWidgets('klip bitince kendiliğinden geçmez: "Tekrar izle"', (
    tester,
  ) async {
    final h = DiscoverHarness(durationFor: (_) => const Duration(seconds: 2));
    addTearDown(h.dispose);
    await h.pump(tester);
    await tester.pump(const Duration(seconds: 3));
    await h.settle(tester);
    expect(h.feedState(tester).index, 0);
    expect(_key('clip-replay'), findsOneWidget);
    expect(_key('clip-swipe-hint'), findsOneWidget);
    await _tap(tester, h, 'clip-replay');
    expect(h.video.isPlaying('S1-K01.mp4'), isTrue);
    await h.unmount(tester);
  });

  group('quiz kartı (puansız)', () {
    Future<DiscoverHarness> toQuiz(
      WidgetTester tester, {
      bool reduce = false,
    }) async {
      final h = DiscoverHarness();
      addTearDown(h.dispose);
      await h.pump(tester, reduceMotion: reduce);
      for (var i = 0; i < 4; i++) {
        await h.swipeUp(tester);
      }
      expect(_key('quiz-card'), findsOneWidget);
      return h;
    }

    testWidgets('yanlış: "Bir daha bakalım.", doğru: açıklama ve "Devam et"', (
      tester,
    ) async {
      final h = await toQuiz(tester);
      // S1-K04: "Nice to meet you." → 0 doğru.
      await _tap(tester, h, 'quiz-opt-1');
      expect(find.text('Bir daha bakalım.'), findsOneWidget);
      expect(_key('quiz-next'), findsNothing);
      await _tap(tester, h, 'quiz-opt-0');
      expect(find.text('Evet, doğru.'), findsOneWidget);
      expect(_key('quiz-explain'), findsOneWidget);
      await tester.tap(_key('quiz-next'));
      await tester.pump(const Duration(milliseconds: 400));
      await h.settle(tester);
      expect(
        h.feedState(tester).feed[h.feedState(tester).index],
        isA<ClipEntry>(),
      );
      await h.unmount(tester);
    });

    testWidgets(
      '"Bilmiyorum" doğru cevabı gösterir; hareket azaltılınca anında geçer',
      (tester) async {
        final h = await toQuiz(tester, reduce: true);
        await _tap(tester, h, 'quiz-dont-know');
        expect(find.text('Doğru cevap bu.'), findsOneWidget);
        final before = h.feedState(tester).index;
        await tester.tap(_key('quiz-next'));
        await tester.pump();
        expect(h.feedState(tester).index, before + 1);
        await h.settle(tester);
        await h.unmount(tester);
      },
    );
  });

  group('günlük süre (K-15)', () {
    testWidgets('13–17: 20 dk dolunca sakin kart; izlerken geri sayım yok', (
      tester,
    ) async {
      final h = DiscoverHarness(age: TestAge.teen);
      addTearDown(h.dispose);
      await h.watched(tester, 20 * 60 - 3);
      await h.pump(tester);
      expect(_key('limit-card'), findsNothing);
      expect(find.textContaining('dakika'), findsNothing);
      expect(find.textContaining('kaldı'), findsNothing);
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(seconds: 1));
        await h.settle(tester, rounds: 3);
      }
      expect(_key('limit-card'), findsOneWidget);
      expect(find.text('Bugünlük Keşfet burada bitiyor'), findsOneWidget);
      expect(h.video.isPlaying('S1-K01.mp4'), isFalse);
      expect(await h.storedSeconds(tester), greaterThanOrEqualTo(20 * 60));
      await _tap(tester, h, 'limit-story');
      expect(find.text('story'), findsOneWidget);
      await h.unmount(tester);
    });

    testWidgets('13–17: süre dolmuşsa akış açılmaz, video kurulmaz', (
      tester,
    ) async {
      final h = DiscoverHarness(age: TestAge.teen);
      addTearDown(h.dispose);
      await h.watched(tester, 20 * 60);
      await h.pump(tester);
      expect(_key('limit-card'), findsOneWidget);
      expect(h.video.liveCount, 0);
      await h.unmount(tester);
    });

    testWidgets('13 altı da 20 dk ile sınırlı (açık soru)', (tester) async {
      final h = DiscoverHarness(age: TestAge.under13);
      addTearDown(h.dispose);
      await h.watched(tester, 20 * 60);
      await h.pump(tester);
      expect(_key('limit-card'), findsOneWidget);
      await h.unmount(tester);
    });

    testWidgets('18+: sınır yok, süre yine de cihazda sayılır', (tester) async {
      final h = DiscoverHarness(
        age: TestAge.adult,
        durationFor: (_) => const Duration(seconds: 30),
      );
      addTearDown(h.dispose);
      await h.watched(tester, 20 * 60 + 100);
      await h.pump(tester);
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(seconds: 1));
        await h.settle(tester, rounds: 2);
      }
      expect(_key('limit-card'), findsNothing);
      expect(h.video.isPlaying('S1-K01.mp4'), isTrue);
      expect(await h.storedSeconds(tester), greaterThan(20 * 60 + 100));
      await h.unmount(tester);
    });

    testWidgets('sayaç yerel gün başında sıfırdan başlar', (tester) async {
      final h = DiscoverHarness(
        age: TestAge.teen,
        now: DateTime(2026, 10, 15, 0, 5),
      );
      addTearDown(h.dispose);
      // Dünün kaydı (20 dk) bugünü etkilemez.
      await tester.runAsync(
        () => h.db.customStatement(
          "INSERT INTO app_meta (key, value) VALUES ('discover.watch.2026-10-14', '1200')",
        ),
      );
      await h.pump(tester);
      expect(_key('limit-card'), findsNothing);
      await h.unmount(tester);
    });
  });

  testWidgets('yalnızca açılmış bölümlerin klipleri; bitişte hikâye önerilir', (
    tester,
  ) async {
    final h = DiscoverHarness(unlocked: 1);
    addTearDown(h.dispose);
    await h.pump(tester);
    final s = h.feedState(tester);
    final clips = s.feed.whereType<ClipEntry>().map((e) => e.clip.episodeId);
    expect(clips.toSet(), {'A1-001'});
    while (h.feedState(tester).feed[h.feedState(tester).index] is! EndEntry) {
      await h.swipeUp(tester);
    }
    expect(find.textContaining('Hikâyede ilerledikçe'), findsOneWidget);
    await _tap(tester, h, 'end-story');
    expect(find.text('story'), findsOneWidget);
    await h.unmount(tester);
  });

  testWidgets('klip yoksa boş durum', (tester) async {
    final h = DiscoverHarness(withClips: false);
    addTearDown(h.dispose);
    await h.pump(tester);
    expect(_key('discover-empty'), findsOneWidget);
    expect(find.text('Klipler hazırlanıyor'), findsOneWidget);
    await h.unmount(tester);
  });

  testWidgets('yüklenemezse hata ve "Tekrar dene"', (tester) async {
    final h = DiscoverHarness(clipsFail: true);
    addTearDown(h.dispose);
    await h.pump(tester);
    expect(_key('discover-error'), findsOneWidget);
    h.source.clipsFail = false;
    await _tap(tester, h, 'discover-retry');
    await h.settle(tester);
    expect(_key('clip-page-S1-K01'), findsOneWidget);
    await h.unmount(tester);
  });
}
