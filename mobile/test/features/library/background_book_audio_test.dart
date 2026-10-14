import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/library/application/background_book_audio.dart';
import 'package:hivelzon/features/library/application/book_media_session.dart';

import '../../support/fake_audio_session.dart';
import '../../support/fake_book_audio.dart';

/// Arka planda çalan kitap sesi (H-068): `just_audio` + `audio_service`
/// bağdaştırıcısı, sahte motor ve sahte oturumla.
void main() {
  late ReaderTestClock clock;
  late FakeAudioEngine engine;
  late FakeSessionHost host;

  final c1 = Uri.parse('http://test.invalid/books/A1-K99/audio/c1.m4a');
  final c2 = Uri.parse('http://test.invalid/books/A1-K99/audio/c2.m4a');
  const info = BookMediaInfo(
    bookTitle: 'The Test Box',
    chapterTitle: 'A Small Box',
    hasNextChapter: true,
  );

  BackgroundBookAudio make({Duration delay = Duration.zero}) =>
      BackgroundBookAudio(engine: engine, host: host, pauseStateDelay: delay);

  setUp(() {
    clock = ReaderTestClock();
    engine = FakeAudioEngine(clock, durations: {'c1.m4a': 11.3, 'c2.m4a': 7});
    host = FakeSessionHost();
  });

  tearDown(() => host.close());

  test('aç: süre okunur; aynı ses ikinci kez yüklenmez', () async {
    final a = make();
    expect(a.uri, isNull);
    expect(await a.position(), 0);
    await a.open(c1);
    expect(a.uri, c1);
    expect(a.duration, 11.3);
    await a.open(c1);
    expect(engine.loaded, [c1]);
    await a.open(c2);
    expect(a.duration, 7);
    expect(engine.loaded, [c1, c2]);
  });

  test('açılamazsa hata fırlatır, adres boş kalır', () async {
    engine.failLoad = true;
    final a = make();
    await expectLater(a.open(c1), throwsStateError);
    expect(a.uri, isNull);
    await a.play();
    expect(engine.plays, 0);
  });

  test('oynat / duraklat / atla / hız / konum motora gider', () async {
    final a = make();
    await a.open(c1);
    await a.play();
    expect(host.prepares, 1);
    expect(engine.playing, isTrue);
    clock.advance(2);
    expect(await a.position(), closeTo(2, 1e-9));
    await a.setSpeed(1.25);
    await a.setSpeed(1.25);
    expect(engine.speeds, [1.25]);
    clock.advance(2);
    expect(await a.position(), closeTo(4.5, 1e-9));
    await a.seek(-3);
    expect(engine.seeks.last, 0);
    await a.seek(9);
    await a.pause();
    expect(engine.playing, isFalse);
    expect(await a.position(), closeTo(9, 1e-9));
    expect(a.isCompleted, isFalse);
    await a.seek(11.3);
    expect(a.isCompleted, isTrue);
  });

  test('künye: kitap, bölüm, süre; aynı künye yeniden gönderilmez; '
      'durum kilit ekranına gider', () async {
    final a = make();
    await a.setMediaInfo(info);
    // Ses açılmadan künye gönderilmez.
    expect(host.items, isEmpty);
    await a.open(c1);
    expect(host.items.single.$1, info);
    expect(host.items.single.$2, 11.3);
    expect(host.owner, same(a));
    await a.setMediaInfo(info);
    expect(host.items, hasLength(1));
    await a.play();
    expect(host.states.last.playing, isTrue);
    expect(host.states.last.hasNextChapter, isTrue);
    await a.setSpeed(0.75);
    expect(host.states.last.speed, 0.75);
    await a.pause();
    expect(host.states.last.playing, isFalse);
    // Yeni bölüm: yeni künye, yeni süre.
    const info2 = BookMediaInfo(bookTitle: 'The Test Box', chapterTitle: 'Two');
    await a.open(c2);
    await a.setMediaInfo(info2);
    expect(host.items.last.$1, info2);
    expect(host.items.last.$2, 7);
    expect(host.states.last.hasNextChapter, isFalse);
  });

  test('duraklama bildirime gecikmeyle yansır; arada çalarsa hiç yansımaz '
      '(bölüm geçişi Android ön plan hizmetini düşürmez)', () {
    fakeAsync((async) {
      final a = make(delay: const Duration(milliseconds: 800));
      unawaited(a.open(c1));
      unawaited(a.setMediaInfo(info));
      async.flushMicrotasks();
      unawaited(a.play());
      async.flushMicrotasks();
      expect(host.states.last.playing, isTrue);
      host.states.clear();
      // Bölüm geçişi: duraklat → hemen yeniden çal.
      unawaited(a.pause());
      async.flushMicrotasks();
      expect(host.states.where((s) => !s.playing), isEmpty);
      async.elapse(const Duration(milliseconds: 100));
      unawaited(a.play());
      async.flushMicrotasks();
      async.elapse(const Duration(seconds: 2));
      expect(host.states.every((s) => s.playing), isTrue);
      // Gerçek duraklama: 0,8 sn sonra yansır.
      unawaited(a.pause());
      async.elapse(const Duration(milliseconds: 500));
      expect(host.states.last.playing, isTrue);
      async.elapse(const Duration(milliseconds: 400));
      expect(host.states.last.playing, isFalse);
    });
  });

  test('kilit ekranı komutları sahibe gelir; kilit ekranından duraklatma '
      'hemen yansır', () {
    fakeAsync((async) {
      final a = make(delay: const Duration(milliseconds: 800));
      final got = <BookRemoteCommand>[];
      a.commands.listen((c) {
        got.add(c);
        if (c == BookRemoteCommand.pause) unawaited(a.pause());
      });
      // Sahibi değilken (künye yok) komut gelmez.
      host.press(BookRemoteCommand.play);
      expect(got, isEmpty);
      unawaited(a.open(c1));
      unawaited(a.setMediaInfo(info));
      unawaited(a.play());
      async.flushMicrotasks();
      for (final c in BookRemoteCommand.values) {
        host.press(c);
      }
      async.flushMicrotasks();
      expect(got, BookRemoteCommand.values);
      expect(host.states.last.playing, isFalse);
    });
  });

  test('kapatınca oturum ve çalar bırakılır, komut gelmez', () async {
    final a = make();
    final got = <BookRemoteCommand>[];
    a.commands.listen(got.add);
    await a.open(c1);
    await a.setMediaInfo(info);
    await a.play();
    expect(host.active, isTrue);
    await a.dispose();
    expect(engine.disposed, isTrue);
    expect(host.active, isFalse);
    expect(host.releases, [a]);
    host.press(BookRemoteCommand.play);
    await Future<void>.delayed(Duration.zero);
    expect(got, isEmpty);
    // İkinci kapatma ve kapandıktan sonra çağrılar zararsız.
    await a.dispose();
    await a.play();
    await a.pause();
    expect(host.releases, hasLength(1));
    await expectLater(a.open(c2), throwsStateError);
  });

  test('eski okuyucu yenisinin oturumunu kapatamaz', () async {
    final old = make();
    await old.open(c1);
    await old.setMediaInfo(info);
    final engine2 = FakeAudioEngine(clock, durations: {'c2.m4a': 7});
    final fresh = BackgroundBookAudio(
      engine: engine2,
      host: host,
      pauseStateDelay: Duration.zero,
    );
    await fresh.open(c2);
    await fresh.setMediaInfo(info);
    expect(host.owner, same(fresh));
    final oldGot = <BookRemoteCommand>[];
    old.commands.listen(oldGot.add);
    host.press(BookRemoteCommand.pause);
    await Future<void>.delayed(Duration.zero);
    expect(oldGot, isEmpty);
    await old.dispose();
    expect(host.active, isTrue);
    expect(host.owner, same(fresh));
    await fresh.dispose();
    expect(host.active, isFalse);
  });

  test('oturum hazırlanamasa da ses çalar', () async {
    final a = BackgroundBookAudio(
      engine: engine,
      host: _FailingPrepareHost(),
      pauseStateDelay: Duration.zero,
    );
    await a.open(c1);
    await a.play();
    expect(engine.playing, isTrue);
  });
}

class _FailingPrepareHost extends FakeSessionHost {
  @override
  Future<void> prepare() async => throw StateError('oturum yok');
}
