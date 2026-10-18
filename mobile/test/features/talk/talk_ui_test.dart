import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/domain/evidence_ladder.dart';
import 'package:hivelzon/features/talk/data/talk_progress_store.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/speech/speech_recognizer_port.dart';

import '../../support/talk_harness.dart';

/// H-090: Konuş sekmesi ve görevler. Mikrofonsuz (dokunarak) tam akış,
/// söyleyerek akış (kendi kullandı), ters anlamlı cevabın kabul edilmemesi,
/// mesaj kuralı ve öz değerlendirme; kayıtlarda metin yok.
void main() {
  Future<void> tapText(WidgetTester tester, TalkHarness h, String text) async {
    final f = find.widgetWithText(OutlinedButton, text);
    await h.scrollTo(tester, f);
    await tester.ensureVisible(f);
    await tester.pump();
    await tester.tap(f);
    await h.settle(tester);
  }

  group('Konuş sekmesi', () {
    testWidgets('sahneler ve mesajlar; kilit nedeni; yapay zekâ açıklaması', (
      tester,
    ) async {
      final h = TalkHarness();
      addTearDown(h.dispose);
      await h.pump(tester, '/konus');
      expect(find.text(TalkTexts.introTitle), findsOneWidget);
      expect(find.textContaining('yapay zekâ yok'), findsOneWidget);
      expect(find.byKey(const ValueKey('talk-task-maya-neighbour')), findsOne);
      expect(find.byKey(const ValueKey('talk-task-ask-the-way')), findsOne);
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('talk-task-cafe-rosa')),
        200,
      );
      expect(
        find.byKey(const ValueKey('talk-status-cafe-rosa')),
        findsOneWidget,
      );
      expect(find.text("Bölüm 9'u bitirince açılır."), findsOneWidget);
    });

    testWidgets('talk.json yoksa sakin boş durum; bağlantı yoksa tekrar dene', (
      tester,
    ) async {
      final h = TalkHarness();
      addTearDown(h.dispose);
      h.source.withTalk = false;
      await h.pump(tester, '/konus');
      expect(find.byKey(const ValueKey('talk-empty')), findsOneWidget);
    });

    testWidgets('bağlantı hatası: Tekrar dene', (tester) async {
      final h = TalkHarness();
      addTearDown(h.dispose);
      h.source.talkFails = true;
      await h.pump(tester, '/konus');
      expect(find.byKey(const ValueKey('talk-error')), findsOneWidget);
      h.source.talkFails = false;
      await tester.tap(find.text(CommonTexts.retry));
      await h.settle(tester);
      expect(find.byKey(const ValueKey('talk-task-maya-neighbour')), findsOne);
    });
  });

  group('sahne (mikrofonsuz)', () {
    testWidgets('dokunarak ve dizerek baştan sona; mikrofon düğmesi yok, '
        'izin sorulmaz; bitince kayıt (metin yok)', (tester) async {
      final h = TalkHarness();
      addTearDown(h.dispose);
      await h.addTargets(["I'm from Türkiye.", 'Nice to meet you.']);
      await h.pump(tester, '/konusma/maya-neighbour');
      await h.tap(tester, 'talk-start');
      expect(find.text('Tur 1 / 4'), findsOneWidget);
      expect(find.byKey(const ValueKey('talk-mic')), findsNothing);
      // Türkçesi istenince.
      expect(find.text('Günaydın! Yardımcı olabilir miyim?'), findsNothing);
      await h.tap(tester, 'talk-line-tr');
      expect(find.text('Günaydın! Yardımcı olabilir miyim?'), findsOneWidget);

      // Tur 1: seç → yakın seçenek önce (kibar tepki), sonra kabul.
      await h.tap(tester, 'talk-choose');
      await tapText(tester, h, 'I Alex.');
      expect(find.byKey(const ValueKey('talk-reaction')), findsOneWidget);
      await tapText(tester, h, "Hi! I'm Alex.");
      expect(find.text(TalkTexts.accepted), findsOneWidget);
      expect(find.byKey(const ValueKey('talk-also')), findsOneWidget);
      await h.tap(tester, 'talk-next');

      // Tur 2: geç → örnek cevap.
      await h.tap(tester, 'talk-skip');
      expect(find.byKey(const ValueKey('talk-model')), findsOneWidget);
      await h.tap(tester, 'talk-next');

      // Tur 3: kelimelerle kur (yanlış sıra → bir daha dene).
      await h.tap(tester, 'talk-build');
      final tiles = find.byWidgetPredicate(
        (w) =>
            w is OutlinedButton &&
            (w.key as ValueKey?)?.value.toString().startsWith('talk-tile') ==
                true,
      );
      // Önce ters sırayla dene.
      final n = tester.widgetList(tiles).length;
      for (var i = n - 1; i >= 0; i--) {
        await h.tap(tester, 'talk-tile-$i');
      }
      final retried = find.byKey(const ValueKey('talk-build-retry'));
      if (retried.evaluate().isNotEmpty) {
        // Doğru sırayla: örnek cevabın kelimeleri.
        const model = "I'm from Türkiye. From İzmir.";
        for (final w in model.split(' ')) {
          await tapText(tester, h, w);
        }
      }
      expect(find.text(TalkTexts.accepted), findsOneWidget);
      await h.tap(tester, 'talk-next');

      // Tur 4: seç.
      await h.tap(tester, 'talk-choose');
      await tapText(tester, h, 'Nice to meet you.');
      await h.tap(tester, 'talk-next');

      expect(find.byKey(const ValueKey('talk-end')), findsOneWidget);
      expect(find.text(TalkTexts.endBody), findsOneWidget);
      expect(h.recognizer.listens, 0);
      expect(h.recognizer.permissionRequests, 0);

      final done = await tester.runAsync(
        () => TalkProgressStore(h.db).doneAt(),
      );
      expect(done!.keys, ['maya-neighbour']);
      final rows = await tester.runAsync(
        () => h.db.select(h.db.userTalkProgress).get(),
      );
      expect(rows!.single.toJson().keys, {
        'taskId',
        'completedAt',
        'lastDoneAt',
        'updatedAt',
      });
      // Seçerek ve dizerek → yardımla yaptı (kendi kullandı değil).
      final ev = await tester.runAsync(() => NotebookStore(h.db).evidence());
      expect(ev!['phrase|i\'m from türkiye']?.keys, [EvidenceStage.helped]);
      expect(ev['phrase|nice to meet you']?.keys, [EvidenceStage.helped]);
    });
  });

  group('sahne (söyleyerek)', () {
    testWidgets('seçenek görmeden söyledi → kendi kullandı; bitiş metni '
        'ifadeleri sayar', (tester) async {
      final h = TalkHarness(
        speech: true,
        completed: const ['A1-001', 'A1-002', 'A1-003', 'A1-009'],
        script: const ['full'],
      );
      addTearDown(h.dispose);
      await h.addTargets([
        'Can I have a tea, please?',
        'How much is it?',
        'Here you are.',
        'Thank you.',
      ]);
      await h.pump(tester, '/konusma/cafe-rosa');
      await h.tap(tester, 'talk-start');
      for (var i = 0; i < 4; i++) {
        await h.tap(tester, 'talk-mic');
        expect(find.text('Söyledin!'), findsOneWidget);
        await h.tap(tester, 'talk-next');
      }
      expect(h.recognizer.listens, 4);
      final ev = await tester.runAsync(() => NotebookStore(h.db).evidence());
      expect(ev!['phrase|can i have a tea please']?.keys, [
        EvidenceStage.ownUse,
      ]);
      expect(ev['phrase|here you are']?.keys, [EvidenceStage.ownUse]);
      expect(find.textContaining('Kendin kullandığın ifadeler'), findsOne);
    });

    testWidgets('ters anlamlı cevap kabul edilmez; 2 denemeden sonra örnek '
        'cevap ve seçenekler; tur yine tamamlanır (yardımla)', (tester) async {
      final h = TalkHarness(
        speech: true,
        script: const ["yes I'm not", 'banana tree'],
      );
      addTearDown(h.dispose);
      await h.pump(tester, '/konusma/maya-neighbour');
      await h.tap(tester, 'talk-start');
      await h.tap(tester, 'talk-skip');
      await h.tap(tester, 'talk-next');
      // Tur 2: "Are you new here?" → "yes I'm not".
      await h.tap(tester, 'talk-mic');
      expect(find.text(TalkTexts.accepted), findsNothing);
      expect(find.text('Söyledin!'), findsNothing);
      expect(
        find.textContaining('İfadede olmayan bir kelime duydum: not'),
        findsOneWidget,
      );
      await h.tap(tester, 'talk-mic');
      expect(find.byKey(const ValueKey('talk-revealed')), findsOneWidget);
      expect(find.byKey(const ValueKey('talk-mic')), findsNothing);
      await h.tap(tester, 'talk-choose');
      await tapText(tester, h, "Yes. I'm your new neighbour.");
      expect(find.text(TalkTexts.accepted), findsOneWidget);
    });

    testWidgets('yakın seçenek söylenirse kibar tepki', (tester) async {
      final h = TalkHarness(speech: true, script: const ['I from Turkey']);
      addTearDown(h.dispose);
      await h.pump(tester, '/konusma/maya-neighbour');
      await h.tap(tester, 'talk-start');
      for (var i = 0; i < 2; i++) {
        await h.tap(tester, 'talk-skip');
        await h.tap(tester, 'talk-next');
      }
      await h.tap(tester, 'talk-mic');
      expect(find.byKey(const ValueKey('talk-reaction')), findsOneWidget);
      expect(find.textContaining('"am" düşmesin'), findsOneWidget);
    });

    testWidgets('izin ilk kullanımda sorulur; "Şimdi değil" ile dokunarak '
        'devam', (tester) async {
      final h = TalkHarness(
        speech: true,
        permission: SpeechPermission.notAsked,
      );
      addTearDown(h.dispose);
      await h.pump(tester, '/konusma/ask-the-way');
      await h.tap(tester, 'talk-start');
      expect(h.recognizer.permissionRequests, 0);
      await h.tap(tester, 'talk-mic');
      expect(find.byKey(const ValueKey('speech-permission-sheet')), findsOne);
      await h.tap(tester, 'speech-permission-later');
      expect(h.recognizer.permissionRequests, 0);
      expect(h.recognizer.listens, 0);
      await h.tap(tester, 'talk-choose');
      await tapText(tester, h, 'Excuse me, where is the bus stop?');
      expect(find.text(TalkTexts.accepted), findsOneWidget);
    });
  });

  group('kısa mesaj', () {
    testWidgets('kural: eksik ve ters anlam sakin ipucu; ipucundan sonra '
        'doğru mesaj yardımlı sayılır; yazılan metin saklanmaz', (
      tester,
    ) async {
      final h = TalkHarness(
        completed: const ['A1-001', 'A1-002', 'A1-003', 'A1-004', 'A1-005'],
      );
      addTearDown(h.dispose);
      await h.addTargets(["Sorry, I'm late."]);
      await h.pump(tester, '/konusma/late-maya');
      await tester.enterText(
        find.byKey(const ValueKey('message-field')),
        "Sorry, I'm not late.",
      );
      await h.tap(tester, 'message-send');
      expect(find.byKey(const ValueKey('message-hint')), findsOneWidget);
      expect(find.textContaining('"not" var'), findsOneWidget);
      expect(find.textContaining("göremedim: I'm late"), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('message-field')),
        'Sorry Maya! I am late. The bus is late.',
      );
      await h.tap(tester, 'message-send');
      expect(find.text(TalkTexts.passed), findsOneWidget);
      expect(find.byKey(const ValueKey('message-model')), findsOneWidget);
      // İpucu görüldü: kanıt **yardımlı** yazılır, own_use değil.
      final ev = await tester.runAsync(() => NotebookStore(h.db).evidence());
      expect(ev!["phrase|sorry i'm late"]?.keys, [EvidenceStage.helped]);
      expect(find.textContaining('yardımla kullandın'), findsOneWidget);
      final done = await tester.runAsync(
        () => TalkProgressStore(h.db).doneAt(),
      );
      expect(done!.keys, ['late-maya']);
      // Veritabanında yazılan mesaj yok.
      final dump = await tester.runAsync(() async {
        final out = StringBuffer();
        for (final t in h.db.allTables) {
          final rows = await h.db
              .customSelect('SELECT * FROM ${t.actualTableName}')
              .get();
          for (final r in rows) {
            out.writeln(r.data.values.join('|'));
          }
        }
        return out.toString();
      });
      expect(dump, isNot(contains('bus is late')));
      expect(dump, isNot(contains('Sorry Maya')));
    });

    testWidgets('kural: ilk denemede doğru mesaj kendi kullanım sayılır', (
      tester,
    ) async {
      final h = TalkHarness(
        completed: const ['A1-001', 'A1-002', 'A1-003', 'A1-004', 'A1-005'],
      );
      addTearDown(h.dispose);
      await h.addTargets(["Sorry, I'm late."]);
      await h.pump(tester, '/konusma/late-maya');
      // Yardım görülmedi: farklı cümleye bölünmüş doğal cevap da geçer.
      await tester.enterText(
        find.byKey(const ValueKey('message-field')),
        'Sorry, Maya. I am late.',
      );
      await h.tap(tester, 'message-send');
      expect(find.text(TalkTexts.passed), findsOneWidget);
      expect(
        find.textContaining('Kendin kullandığın ifadeler'),
        findsOneWidget,
      );
      final ev = await tester.runAsync(() => NotebookStore(h.db).evidence());
      expect(ev!["phrase|sorry i'm late"]?.keys, [EvidenceStage.ownUse]);
    });

    testWidgets('kural yoksa örnek mesaj + öz değerlendirme; kanıt yazılmaz', (
      tester,
    ) async {
      final h = TalkHarness();
      addTearDown(h.dispose);
      await h.addTargets(['My name is…']);
      await h.pump(tester, '/konusma/hi-intro');
      await tester.enterText(
        find.byKey(const ValueKey('message-field')),
        'Hi! My name is Deniz.',
      );
      await h.tap(tester, 'message-send');
      expect(find.text(TalkTexts.selfCheckTitle), findsOneWidget);
      expect(find.byKey(const ValueKey('message-model')), findsOneWidget);
      await h.tap(tester, 'message-similar');
      expect(find.text(TalkTexts.messageDone), findsOneWidget);
      final ev = await tester.runAsync(() => NotebookStore(h.db).evidence());
      expect(ev, isEmpty);
      final done = await tester.runAsync(
        () => TalkProgressStore(h.db).doneAt(),
      );
      expect(done!.keys, ['hi-intro']);
    });
  });

  test(
    'ilerleme deposu: ilk bitiş korunur, yeniden yapınca son an ilerler',
    () async {
      final h = TalkHarness();
      addTearDown(h.dispose);
      var now = DateTime.utc(2026, 10, 16, 9);
      final store = TalkProgressStore(h.db, clock: () => now);
      await store.markDone('cafe-rosa');
      now = DateTime.utc(2026, 10, 17, 9);
      await store.markDone('cafe-rosa');
      final row = (await h.db.select(h.db.userTalkProgress).get()).single;
      expect(row.completedAt.toUtc(), DateTime.utc(2026, 10, 16, 9));
      expect(row.lastDoneAt.toUtc(), DateTime.utc(2026, 10, 17, 9));
      expect(await store.doneSince(DateTime.utc(2026, 10, 17)), isTrue);
      expect(await store.doneSince(DateTime.utc(2026, 10, 18)), isFalse);
    },
  );
}
