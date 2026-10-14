import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/library/application/reader_controller.dart';
import 'package:hivelzon/features/library/domain/book.dart';

import '../../support/fake_book_audio.dart';
import '../../support/fake_content_source.dart';

/// Okuyucunun ses eşlemesi (H-067): vurgu ≤ 0,2 sn, sayfa çevirme, bölüm
/// geçişi, kitap sonu, uyku zamanlayıcısı, 10 sn geri, tek cümle, panel.
void main() {
  late ReaderTestClock clock;
  late FakeBookAudio audio;
  late Book book;
  final places = <(String, int, int, double?)>[];
  var finished = 0;

  ReaderController make({
    ReaderMode mode = ReaderMode.listen,
    ReaderPlace? start,
  }) => ReaderController(
    book: book,
    audio: audio,
    mediaUri: (p) => Uri.parse('http://test.invalid/books/A1-K99/$p'),
    clock: clock.call,
    mode: mode,
    start: start,
    // Zamanlayıcı yerine adımlar elle atılır.
    tickInterval: const Duration(hours: 1),
    onPlace: (ch, p, sec) => places.add((
      ch.id,
      book.pages[p.pageIndex].number,
      p.sentenceIndex,
      sec,
    )),
    onFinished: () => finished++,
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

  /// Cümlenin sesteki aralığı.
  BookSentence sentence(ReaderController c) =>
      book.sentenceAt(c.place.pageIndex, c.place.sentenceIndex);

  setUp(() {
    clock = ReaderTestClock();
    audio = FakeBookAudio(clock, durations: {'c1.m4a': 11.3, 'c2.m4a': 7.0});
    book = loadTestBook();
    places.clear();
    finished = 0;
  });

  test(
    'vurgu ses konumunu en fazla 0,2 sn geriden izler (hız 1 ve 1,25)',
    () async {
      for (final speed in [1.0, 1.25, 0.75]) {
        clock = ReaderTestClock();
        audio = FakeBookAudio(clock, durations: {'c1.m4a': 11.3});
        final c = make();
        await c.setSpeed(speed);
        await c.play();
        expect(audio.opened.single.path, endsWith('audio/c1.m4a'));
        var worst = 0.0;
        // 50 ms adımlarla bölüm 1 boyunca.
        while (audio.truePosition < 10.7) {
          await step(c, 0.05);
          if (!c.isPlaying) break;
          final t = audio.truePosition;
          final s = sentence(c);
          // Okunan cümle: başlangıcı geçmiş son cümle. Kayma = gerçek
          // konumun vurgulanan cümlenin aralığı dışında kalan kısmı.
          final track = book.track('c1');
          final truth = track.items[track.indexAt(t)].sentence;
          if (!identical(truth, s)) {
            // Vurgu geride: yeni cümle en fazla 0,2 sn önce başlamış olmalı.
            final lag = t - truth.start!;
            worst = lag > worst ? lag : worst;
            expect(lag, lessThanOrEqualTo(0.2), reason: 'hız $speed, t=$t');
          }
        }
        expect(worst, lessThanOrEqualTo(0.2));
        c.dispose();
      }
    },
  );

  test('platform konumu kayarsa örnekle düzelir (≤ 0,2 sn)', () async {
    final c = make();
    await c.play();
    await step(c, 1.0);
    // Platform 0,15 sn geride kalmış gibi: sonraki örnek düzeltir.
    await audio.seek(audio.truePosition + 0.15);
    for (var i = 0; i < 4; i++) {
      await step(c, 0.05);
    }
    expect((c.estimatedPosition - audio.truePosition).abs(), lessThan(0.06));
    c.dispose();
  });

  test(
    'sayfa sonunda sayfa kendiliğinden çevrilir; konum kaydedilir',
    () async {
      final c = make();
      await c.play();
      expect(c.pageIndex, 0);
      expect(c.highlighted, const ReaderPlace(0, -1));
      // p02-s01 6,325 sn'de başlar.
      while (audio.truePosition < 6.5) {
        await step(c, 0.05);
      }
      expect(c.pageIndex, 1);
      expect(c.highlighted, const ReaderPlace(1, 0));
      expect(places.last.$2, 2);
      expect(places.last.$3, 0);
      expect(places.last.$4, closeTo(6.325, 1e-9));
      c.dispose();
    },
  );

  test(
    'bölüm bitince sıradaki bölüm açılır; son bölümde kitap biter',
    () async {
      final c = make();
      await c.play();
      while (audio.uri!.path.endsWith('c1.m4a')) {
        await step(c, 0.25);
      }
      expect(c.pageIndex, 2);
      expect(c.highlighted, const ReaderPlace(2, -1));
      expect(c.isPlaying, isTrue);
      expect(audio.truePosition, lessThan(0.3));
      while (finished == 0) {
        await step(c, 0.25);
      }
      expect(c.finished, isTrue);
      expect(c.isPlaying, isFalse);
      c.dispose();
    },
  );

  test('uyku zamanlayıcısı: 10 dk sonra ses durur (geri sayım yok)', () async {
    // Uzun bölüm gibi: süre yok sayılmasın diye çok uzun.
    audio = FakeBookAudio(clock, durations: {'c1.m4a': 9999});
    book = loadTestBook(chapterDuration: 9999);
    final c = make();
    await c.play();
    c.setSleep(SleepOption.min10);
    for (var i = 0; i < 599; i++) {
      await step(c, 1);
    }
    expect(c.isPlaying, isTrue);
    await step(c, 1.5);
    expect(c.isPlaying, isFalse);
    expect(c.sleepFired, isTrue);
    expect(c.sleep, SleepOption.off);
    c.dispose();
  });

  test(
    'uyku zamanlayıcısı: bölüm sonunda durur, sıradaki bölümün başında kalır',
    () async {
      final c = make();
      await c.play();
      c.setSleep(SleepOption.endOfChapter);
      for (var i = 0; i < 80 && c.isPlaying; i++) {
        await step(c, 0.25);
      }
      expect(c.isPlaying, isFalse);
      expect(c.sleepFired, isTrue);
      expect(c.place, const ReaderPlace(2, -1));
      expect(finished, 0);
      c.dispose();
    },
  );

  test('10 sn geri ve hız 0,75 / 1 / 1,25', () async {
    final c = make(start: const ReaderPlace(1, 1));
    await c.play();
    expect(audio.seeks.last, closeTo(9.525, 1e-9));
    await c.back10();
    expect(audio.seeks.last, 0);
    expect(c.place, const ReaderPlace(0, -1));
    expect(c.speed, 1.0);
    await c.cycleSpeed();
    expect(c.speed, 1.25);
    await c.cycleSpeed();
    expect(c.speed, 0.75);
    await c.cycleSpeed();
    expect(c.speed, 1.0);
    c.dispose();
  });

  test(
    'sessiz mod: uzun basılan cümle tek başına çalar, sonra durur',
    () async {
      final c = make(mode: ReaderMode.silent);
      expect(c.highlighted, isNull);
      await c.playSentenceOnly(const ReaderPlace(0, 1));
      expect(audio.seeks.last, closeTo(3.1, 1e-9));
      expect(c.highlighted, const ReaderPlace(0, 1));
      while (c.isPlaying) {
        await step(c, 0.1);
      }
      expect(audio.truePosition, closeTo(4.15, 0.11));
      expect(c.highlighted, isNull);
      expect(c.mode, ReaderMode.silent);
      c.dispose();
    },
  );

  test(
    'sessiz modda sayfa çevirmek kalınan yeri kaydeder, ses çalmaz',
    () async {
      final c = make(mode: ReaderMode.silent);
      await c.goToPage(2);
      expect(c.pageIndex, 2);
      expect(audio.plays, 0);
      expect(places.last, ('c2', 3, -1, 0.0));
      c.finish();
      expect(finished, 1);
      c.dispose();
    },
  );

  test(
    'anlam paneli: ses durur, kelime çalınır, kapanınca kaldığı yerden sürer',
    () async {
      final c = make();
      await c.play();
      await step(c, 2.0);
      final before = audio.truePosition;
      final was = await c.pauseForSheet();
      expect(was, isTrue);
      expect(c.isPlaying, isFalse);
      // Paneldeki kelime: "small" (1,975–2,35).
      final audioForSheet = c.meaningAudio(const ReaderPlace(0, 0));
      final w = book.sentenceAt(0, 0).toMeaning(book.id).words[3];
      await audioForSheet.playWord(w, speed: 0.75);
      expect(audio.seeks.last, closeTo(1.975, 1e-9));
      while (c.isPlaying) {
        await step(c, 0.05);
      }
      // Panel kapanır: önceki konuma döner ve sürer; hız eski hâline.
      await c.resumeAfterSheet(was);
      expect(audio.seeks.last, closeTo(before, 1e-9));
      expect(c.isPlaying, isTrue);
      expect(c.speed, 1.0);
      c.dispose();
    },
  );

  test('ses açılamazsa sessiz moda geçer', () async {
    audio.failOpen = true;
    final c = make();
    await c.play();
    expect(c.mode, ReaderMode.silent);
    expect(c.audioFailed, isTrue);
    expect(c.canListen, isFalse);
    c.dispose();
  });

  group('bölüm bölüm ses (c2 seslendirilmemiş)', () {
    setUp(() => book = loadTestBook(unnarrated: const {'c2'}));

    test('bölüm sonunda sessiz moda geçer, c2 başında kalır, not bir kez '
        '(kitap bitmez)', () async {
      final c = make();
      expect(c.canListen, isTrue);
      expect(c.chapterCanListen, isTrue);
      await c.play();
      for (var i = 0; i < 80 && c.isPlaying; i++) {
        await step(c, 0.25);
      }
      expect(c.isPlaying, isFalse);
      expect(c.mode, ReaderMode.silent);
      expect(c.place, const ReaderPlace(2, -1));
      expect(c.pageIndex, 2);
      expect(c.chapterCanListen, isFalse);
      expect(c.chapterAudioMissing, isTrue);
      expect(finished, 0);
      expect(audio.opened.map((u) => u.path), [endsWith('c1.m4a')]);
      expect(places.last, ('c2', 3, -1, 0.0));
      c.clearChapterAudioNotice();
      expect(c.chapterAudioMissing, isFalse);
      c.dispose();
    });

    test(
      'sesi olmayan bölümde "Sesli": not, sessiz kalır; play çalmaz',
      () async {
        final c = make(mode: ReaderMode.silent);
        await c.goToPage(2);
        await c.setMode(ReaderMode.listen);
        expect(c.mode, ReaderMode.silent);
        expect(c.chapterAudioMissing, isTrue);
        c.clearChapterAudioNotice();
        await c.play();
        expect(c.mode, ReaderMode.silent);
        expect(c.chapterAudioMissing, isTrue);
        expect(audio.plays, 0);
        // Seslendirilmiş bölüme dönünce sesli okunur.
        await c.goToPage(1);
        await c.setMode(ReaderMode.listen);
        expect(c.mode, ReaderMode.listen);
        expect(c.isPlaying, isTrue);
        c.dispose();
      },
    );

    test('sesli okurken sesi olmayan bölüme geçilirse ses durur', () async {
      final c = make();
      await c.play();
      await step(c, 1.0);
      await c.goToChapter(1);
      expect(c.isPlaying, isFalse);
      expect(c.mode, ReaderMode.silent);
      expect(c.chapterAudioMissing, isTrue);
      expect(c.pageIndex, 2);
      c.dispose();
    });

    test('sesi olmayan bölümde açılan kitap sessiz açılır, not', () {
      final c = make(start: const ReaderPlace(2, 0));
      expect(c.mode, ReaderMode.silent);
      expect(c.chapterAudioMissing, isTrue);
      expect(c.canListen, isTrue);
      c.dispose();
    });
  });

  test('kalınan cümleden başlar (başlık yalnız bölüm başında)', () async {
    final c = make(start: const ReaderPlace(1, 1));
    expect(c.pageIndex, 1);
    expect(c.place, const ReaderPlace(1, 1));
    await c.play();
    expect(audio.seeks.single, closeTo(9.525, 1e-9));
    final d = make(start: const ReaderPlace(1, -1));
    expect(d.place, const ReaderPlace(1, 0));
    c.dispose();
    d.dispose();
  });
}
