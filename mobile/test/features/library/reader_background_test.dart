import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/library/application/background_book_audio.dart';
import 'package:hivelzon/features/library/application/book_media_session.dart';
import 'package:hivelzon/features/library/application/reader_controller.dart';
import 'package:hivelzon/features/library/domain/book.dart';
import 'package:hivelzon/features/library/presentation/reader_screen.dart';
import 'package:hivelzon/features/library/presentation/widgets/book_page_view.dart';

import '../../support/fake_audio_session.dart';
import '../../support/fake_book_audio.dart';
import '../../support/fake_content_source.dart';
import '../../support/library_harness.dart';

/// Arka planda dinleme ve kilit ekranı (H-068): okuyucu + gerçek
/// bağdaştırıcı (`BackgroundBookAudio`), sahte motor ve sahte oturumla.
void main() {
  group('okuyucu denetleyicisi + oturum', () {
    late ReaderTestClock clock;
    late FakeAudioEngine engine;
    late FakeSessionHost host;
    late BackgroundBookAudio audio;
    late Book book;

    ReaderController make({ReaderPlace? start}) => ReaderController(
      book: book,
      audio: audio,
      mediaUri: (p) => Uri.parse('http://test.invalid/books/A1-K99/$p'),
      clock: clock.call,
      start: start,
      tickInterval: const Duration(hours: 1),
    );

    Future<void> flush() async {
      for (var i = 0; i < 5; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    Future<void> step(ReaderController c, double dt) async {
      clock.advance(dt);
      c.tick();
      await flush();
    }

    setUp(() {
      clock = ReaderTestClock();
      engine = FakeAudioEngine(clock, durations: {'c1.m4a': 11.3, 'c2.m4a': 7});
      host = FakeSessionHost();
      audio = BackgroundBookAudio(
        engine: engine,
        host: host,
        pauseStateDelay: Duration.zero,
      );
      book = loadTestBook();
    });

    tearDown(() => host.close());

    test('kilit ekranı künyesi: kitap, bölüm, paketteki kapak, sonraki '
        'bölüm', () async {
      final c = make();
      await c.play();
      await flush();
      final (info, duration) = host.items.last;
      expect(info.bookTitle, 'The Test Box');
      expect(info.chapterTitle, book.chapters[0].title);
      expect(
        info.artUri,
        Uri.parse('http://test.invalid/books/A1-K99/images/cover.webp'),
      );
      expect(info.hasNextChapter, isTrue);
      expect(duration, 11.3);
      expect(host.states.last.playing, isTrue);
      // Son bölümde "Sonraki bölüm" yok.
      await c.goToChapter(1);
      await flush();
      expect(host.items.last.$1.chapterTitle, book.chapters[1].title);
      expect(host.items.last.$1.hasNextChapter, isFalse);
      expect(host.states.last.hasNextChapter, isFalse);
      c.dispose();
    });

    test('kilit ekranı: duraklat, oynat, 10 sn geri, sonraki bölüm', () async {
      final c = make();
      await c.play();
      await step(c, 4);
      host.press(BookRemoteCommand.pause);
      await flush();
      expect(c.isPlaying, isFalse);
      expect(engine.playing, isFalse);
      expect(host.states.last.playing, isFalse);
      final at = engine.position;
      host.press(BookRemoteCommand.play);
      await flush();
      expect(c.isPlaying, isTrue);
      expect(engine.playing, isTrue);
      // Duraklatılan yerden sürer.
      expect(engine.position, closeTo(at, 1e-9));
      await step(c, 1);
      host.press(BookRemoteCommand.back10);
      await flush();
      expect(engine.seeks.last, 0);
      expect(c.place, const ReaderPlace(0, -1));
      expect(c.isPlaying, isTrue);
      host.press(BookRemoteCommand.nextChapter);
      await flush();
      expect(c.chapter.id, 'c2');
      expect(c.place, const ReaderPlace(2, -1));
      expect(engine.loaded.last.path, endsWith('audio/c2.m4a'));
      expect(c.isPlaying, isTrue);
      expect(engine.playing, isTrue);
      // Son bölümde "sonraki" bir şey yapmaz.
      host.press(BookRemoteCommand.nextChapter);
      await flush();
      expect(c.chapter.id, 'c2');
      // Kesinti / durdur: okuyucu duraklar (çalar kendi başına sürmez).
      host.press(BookRemoteCommand.stop);
      await flush();
      expect(c.isPlaying, isFalse);
      expect(engine.playing, isFalse);
      c.dispose();
    });

    test('öne dönünce vurgu duvar saatinden değil çalardan eşlenir', () async {
      final c = make();
      await c.play();
      await step(c, 1);
      // Arka planda: çalar 2,0 sn'de takıldı (ör. ağ), saat 6 sn ilerledi,
      // zamanlayıcı çalışmadı (adım yok).
      await engine.seek(2.0);
      await engine.pause();
      clock.advance(6);
      await c.resync();
      final s = book.sentenceAt(c.place.pageIndex, c.place.sentenceIndex);
      expect(s.start! <= 2.0 && 2.0 <= s.end! + 0.5, isTrue, reason: '$s');
      expect(c.estimatedPosition, closeTo(2.0, 1e-9));
      c.dispose();
    });

    test('uyku zamanlayıcısı arka planda sesi durdurur; okuyucu kapanınca '
        'oturum kapanır', () async {
      engine = FakeAudioEngine(clock, durations: {'c1.m4a': 9999});
      audio = BackgroundBookAudio(
        engine: engine,
        host: host,
        pauseStateDelay: Duration.zero,
      );
      book = loadTestBook(chapterDuration: 9999);
      final c = make();
      await c.play();
      c.setSleep(SleepOption.min10);
      for (var i = 0; i < 601; i++) {
        await step(c, 1);
      }
      expect(c.isPlaying, isFalse);
      expect(c.sleepFired, isTrue);
      expect(engine.playing, isFalse);
      expect(host.states.last.playing, isFalse);
      expect(host.active, isTrue);
      c.dispose();
      await flush();
      expect(engine.disposed, isTrue);
      expect(host.active, isFalse);
    });
  });

  group('okuyucu ekranı + oturum', () {
    String pageLabel(WidgetTester t) =>
        t.widget<Text>(find.byKey(const ValueKey('reader-page-label'))).data!;

    BookWordView word(WidgetTester t, String sentence, int i) =>
        t.widget<BookWordView>(find.byKey(ValueKey('w-$sentence-$i')));

    Future<void> toBackground(WidgetTester tester) async {
      for (final s in [
        AppLifecycleState.inactive,
        AppLifecycleState.hidden,
        AppLifecycleState.paused,
      ]) {
        tester.binding.handleAppLifecycleStateChanged(s);
      }
      await tester.pump();
    }

    Future<void> toForeground(WidgetTester tester) async {
      for (final s in [
        AppLifecycleState.hidden,
        AppLifecycleState.inactive,
        AppLifecycleState.resumed,
      ]) {
        tester.binding.handleAppLifecycleStateChanged(s);
      }
    }

    testWidgets('okuyucu kapanınca ses durur, oturum ve çalar bırakılır', (
      tester,
    ) async {
      final h = LibraryHarness(background: true);
      addTearDown(h.dispose);
      await h.pump(tester, '/hikaye');
      expect(h.session.active, isFalse);
      // Hikâye → Kitaplık → kitap; kapatınca Hikâye'ye dönülür.
      unawaited(h.router.push('/kitap/A1-K99'));
      await h.settle(tester);
      expect(find.byType(ReaderScreen), findsOneWidget);
      expect(h.engine.playing, isTrue);
      expect(h.session.active, isTrue);
      expect(h.session.items.last.$1.bookTitle, 'The Test Box');
      await h.listenFor(tester, 1.0);
      await tester.tap(find.byKey(const ValueKey('reader-close')));
      await h.settle(tester);
      expect(find.byType(ReaderScreen), findsNothing);
      expect(h.engine.playing, isFalse);
      expect(h.engine.disposed, isTrue);
      expect(h.session.active, isFalse);
      expect(h.session.releases, [h.backgroundAudio]);
    });

    testWidgets('arka planda: ses sürer, bölüm sonu uyku zamanlayıcısı sesi '
        'durdurur; öne dönünce vurgu çalarla eşlenir', (tester) async {
      final h = LibraryHarness(background: true);
      addTearDown(h.dispose);
      await h.pump(tester, '/kitap/A1-K99');
      await tester.tap(find.byKey(const ValueKey('reader-sleep-button')));
      await h.settle(tester);
      await tester.tap(find.byKey(const ValueKey('sleep-endOfChapter')));
      await h.settle(tester);
      await toBackground(tester);
      // Ekran kilitli: ses sürer, sayfa arka planda da ilerler.
      await h.listenFor(tester, 7.0);
      expect(h.engine.playing, isTrue);
      expect(h.session.states.last.playing, isTrue);
      await h.listenFor(tester, 4.6);
      // Bölüm bitti: uyku zamanlayıcısı sesi durdurdu, kilit ekranı
      // "duraklatıldı" gösterir; oturum açık kalır (kilit ekranından
      // yeniden başlatılabilir).
      expect(h.engine.playing, isFalse);
      expect(h.session.states.last.playing, isFalse);
      expect(h.session.active, isTrue);
      await toForeground(tester);
      await h.settle(tester);
      expect(pageLabel(tester), 's. 3 / 3');
      expect(
        find.text('Uyku zamanlayıcısı sesi durdurdu. İyi uykular!'),
        findsOneWidget,
      );
      // Kilit ekranından yeniden: sıradaki bölüm okunur.
      h.session.press(BookRemoteCommand.play);
      await h.settle(tester);
      expect(h.engine.playing, isTrue);
      expect(h.engine.loaded.last.path, endsWith('audio/c2.m4a'));
      // Okuyucu kapanır (ağaçtan çıkar): oturum kapanır.
      await tester.pumpWidget(const SizedBox());
      await h.settle(tester, rounds: 3);
      expect(h.engine.disposed, isTrue);
      expect(h.session.active, isFalse);
    });

    testWidgets('öne dönünce vurgu duvar saatinden değil çaların '
        'konumundan eşlenir', (tester) async {
      final h = LibraryHarness(background: true);
      addTearDown(h.dispose);
      await h.pump(tester, '/kitap/A1-K99');
      await h.listenFor(tester, 0.5);
      expect(word(tester, 'c1-h', 0).highlighted, isTrue);
      await toBackground(tester);
      // Arka planda çalar saat tahmininden ayrıldı (ör. kesinti sonrası
      // yeniden ayarlandı): çalar 3,3 sn'de (ikinci cümle), saat aynı.
      await h.engine.seek(3.3);
      await toForeground(tester);
      // Zamanlayıcı adımı beklenmeden (örnek almadan) eşlenir.
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump();
      expect(word(tester, 'c1-h', 0).highlighted, isFalse);
      expect(word(tester, 'p01-s02', 0).highlighted, isTrue);
      await tester.pumpWidget(const SizedBox());
      await h.settle(tester, rounds: 3);
      expect(h.session.active, isFalse);
    });
  });
}
