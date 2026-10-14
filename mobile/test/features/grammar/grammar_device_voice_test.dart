import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/design/tokens.dart';

import '../../support/fake_content_source.dart';
import '../../support/grammar_harness.dart';

const _route = '/dilbilgisi/$kTestLessonId';

/// İngilizce örneklerin cihaz sesi (H-064 ek): önceden üretilmiş dosya
/// varsa dosya çalar; yoksa telefonun İngilizce sesi okur; cihazda ses
/// yoksa düğme gizli. Tek ses: örnek başlayınca anlatım durur; kart
/// değişince ve ekrandan çıkınca okuma durur.
void main() {
  Finder key(String k) => find.byKey(ValueKey(k));

  testWidgets('dosya yok → cihaz sesi okur; anlatım durur; kelime vurgusu', (
    tester,
  ) async {
    final h = GrammarHarness(noEnglishAudio: true, deviceVoice: true);
    addTearDown(h.dispose);
    await h.pump(tester, _route);
    expect(h.audio.playing, isTrue, reason: 'Türkçe anlatım çalıyor');
    final opened = h.audio.opened.length;

    expect(key('play-c01-ex1'), findsOneWidget);
    await tester.tap(key('play-c01-ex1'));
    await h.settle(tester, rounds: 3);
    expect(h.speech.spoken, [('Ece opens the box.', 0.85)]);
    expect(h.audio.playing, isFalse, reason: 'aynı anda tek ses');
    expect(h.audio.opened, hasLength(opened), reason: 'dosya açılmaz');
    expect(
      find.descendant(
        of: key('play-c01-ex1'),
        matching: find.byIcon(Icons.stop_circle_outlined),
      ),
      findsOneWidget,
    );

    // Motor "opens"u okuyor → ekranda vurgulu.
    h.speech.word(4, 9);
    await tester.pump();
    final opens = tester.widget<Text>(
      find.descendant(of: key('ex-c01-ex1-w1'), matching: find.byType(Text)),
    );
    expect(opens.style?.backgroundColor, AppPalette.seaBlue100);

    // Okuma biter → düğme yeniden "dinle".
    h.speech.finish();
    await tester.pump();
    expect(
      find.descendant(
        of: key('play-c01-ex1'),
        matching: find.byIcon(Icons.volume_up_rounded),
      ),
      findsOneWidget,
    );
  });

  testWidgets('dosya varsa dosya çalar (cihaz sesi kullanılmaz)', (
    tester,
  ) async {
    final h = GrammarHarness(deviceVoice: true);
    addTearDown(h.dispose);
    await h.pump(tester, _route);
    await h.next(tester, 2);
    await tester.tap(key('play-c03-ex2'));
    await h.settle(tester, rounds: 3);
    expect(h.audio.opened.last.path, endsWith('/audio/c03-ex2.m4a'));
    expect(h.speech.spoken, isEmpty);
  });

  testWidgets('dosya yok ve cihazda İngilizce ses yok → düğme gizli', (
    tester,
  ) async {
    final h = GrammarHarness(noEnglishAudio: true);
    addTearDown(h.dispose);
    await h.pump(tester, _route);
    expect(key('example-c01-ex1'), findsOneWidget);
    expect(key('play-c01-ex1'), findsNothing);
  });

  testWidgets('sessiz modda cihaz sesi de yok', (tester) async {
    final h = GrammarHarness(noEnglishAudio: true, deviceVoice: true);
    addTearDown(h.dispose);
    await h.pump(tester, _route);
    expect(key('play-c01-ex1'), findsOneWidget);
    await tester.tap(key('lesson-sound'));
    await h.settle(tester, rounds: 5);
    expect(key('play-c01-ex1'), findsNothing);
  });

  testWidgets('kart değişince ve ekrandan çıkınca okuma durur', (tester) async {
    final h = GrammarHarness(noEnglishAudio: true, deviceVoice: true);
    addTearDown(h.dispose);
    await h.pump(tester, _route);
    await tester.tap(key('play-c01-ex1'));
    await h.settle(tester, rounds: 3);
    expect(h.speech.speaking, isTrue);

    await h.next(tester);
    expect(h.speech.speaking, isFalse);
    expect(h.speech.stops, 1);

    await h.next(tester);
    await tester.tap(key('play-c03-ex2'));
    await h.settle(tester, rounds: 3);
    expect(h.speech.spoken.last.$1, 'He goes to school.');
    expect(h.speech.speaking, isTrue);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
    expect(h.speech.speaking, isFalse);
    expect(h.speech.stops, 2);
  });

  testWidgets('"Söyle" cümlesi de cihaz sesiyle dinlenir', (tester) async {
    final h = GrammarHarness(noEnglishAudio: true, deviceVoice: true);
    addTearDown(h.dispose);
    await h.pump(tester, _route);
    await h.next(tester, 4);
    // Soru 4'e (Söyle) gel: ilk üç soru cevaplanır.
    Future<void> tapKey(String k) async {
      await tester.ensureVisible(key(k));
      await tester.tap(key(k));
      await h.settle(tester, rounds: 3);
    }

    await tapKey('opt-1');
    await tapKey('practice-next');
    await tester.enterText(key('fill-field'), 'plays');
    await h.settle(tester, rounds: 3);
    await tapKey('practice-check');
    await tapKey('practice-next');
    for (final i in [2, 1, 0]) {
      await tapKey('order-token-$i');
    }
    await tapKey('practice-check');
    await tapKey('practice-next');
    expect(find.text('Soru 4 / 4'), findsOneWidget);
    expect(key('play-c05-q4'), findsOneWidget);
    await tester.ensureVisible(key('play-c05-q4'));
    await tester.tap(key('play-c05-q4'));
    await h.settle(tester, rounds: 3);
    expect(h.speech.spoken.last.$1, 'She goes to school.');
  });
}
