import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/talk/domain/talk_task.dart';
import 'package:hivelzon/l10n/tr_strings.dart';

import '../../support/talk_harness.dart';

/// H-104: Konuş görevlerinde Hi'nin Türkçe yönlendirmeleri (Alania sesi).
/// Ses varsa yönlendirmenin yanında küçük "dinle" düğmesi; kendiliğinden
/// çalmaz, dokununca sezon paketindeki sesi çalar; ses yoksa düğme yok.
void main() {
  const base = 'http://test.invalid/_season/S1/';

  group('talk.json ayrıştırma', () {
    test('giriş, görev, tur görevi, kibar tepki ve ipucu sesleri', () {
      final c = TalkCatalog.fromJson({
        'tasks': [
          {
            'id': 's',
            'kind': 'scene',
            'unlockAfter': 'A1-002',
            'titleTr': 'x',
            'image': {'episode': 'A1-002', 'path': 'stills/a.webp'},
            'introTr': 'Giriş',
            'introAudio': 'talk/konusma-s-intro.m4a',
            'turns': [
              {
                'id': 't1',
                'line': {'en': 'Hi!', 'tr': 'Merhaba!'},
                'promptTr': 'Selam ver.',
                'promptAudio': 'talk/konusma-s-t1-prompt.m4a',
                'accept': ['Hi!', 'Hello!'],
                'distractors': [
                  {
                    'en': 'Bye!',
                    'reactionTr': 'Selam: Hi!',
                    'reactionAudio': 'talk/konusma-s-t1-d1.m4a',
                  },
                ],
              },
            ],
          },
          {
            'id': 'm',
            'kind': 'message',
            'unlockAfter': 'A1-004',
            'titleTr': 'y',
            'image': {'episode': 'A1-004', 'path': 'stills/b.webp'},
            'taskTr': 'Yaz.',
            'taskAudio': 'talk/konusma-m-task.m4a',
            'check': {
              'all': [
                ['seven'],
              ],
              'hintTr': 'Saati yaz.',
              'hintAudio': 'talk/konusma-m-hint.m4a',
            },
          },
          {
            'id': 'n',
            'kind': 'message',
            'unlockAfter': 'A1-004',
            'titleTr': 'z',
            'image': {'episode': 'A1-004', 'path': 'stills/b.webp'},
            'taskTr': 'Yaz.',
            'check': null,
          },
        ],
      });
      final s = c.byId('s')!;
      expect(s.introAudio, 'talk/konusma-s-intro.m4a');
      expect(s.turns.single.promptAudio, 'talk/konusma-s-t1-prompt.m4a');
      expect(
        s.turns.single.distractors.single.reactionAudio,
        'talk/konusma-s-t1-d1.m4a',
      );
      final m = c.byId('m')!;
      expect(m.taskAudio, 'talk/konusma-m-task.m4a');
      expect(m.check!.hintAudio, 'talk/konusma-m-hint.m4a');
      final n = c.byId('n')!;
      expect(n.taskAudio, isNull);
      expect(n.introAudio, isNull);
    });
  });

  group('sahne', () {
    testWidgets('ses varsa giriş ve tur görevinin yanında dinle; kendiliğinden '
        'çalmaz, dokununca Hi sesini çalar', (tester) async {
      final h = TalkHarness();
      addTearDown(h.dispose);
      await h.pump(tester, '/konusma/maya-neighbour');
      final intro = find.byKey(const ValueKey('talk-intro-listen'));
      expect(intro, findsOneWidget);
      expect(find.byTooltip(TalkTexts.listenHiTask), findsOneWidget);
      expect(h.audio, isEmpty);
      await h.tap(tester, 'talk-intro-listen');
      expect(
        h.audio.single.uri.toString(),
        '${base}talk/konusma-maya-neighbour-intro.m4a',
      );
      expect(h.audio.single.played, isTrue);

      await h.tap(tester, 'talk-start');
      expect(find.byKey(const ValueKey('talk-prompt-listen')), findsOneWidget);
      // Yeni tur kendiliğinden çalmaz.
      expect(h.audio, hasLength(1));
      await h.tap(tester, 'talk-prompt-listen');
      expect(
        h.audio.last.uri.toString(),
        '${base}talk/konusma-maya-neighbour-t1-prompt.m4a',
      );
    });

    testWidgets('yakın seçenekte kibar tepkinin sesi', (tester) async {
      final h = TalkHarness();
      addTearDown(h.dispose);
      await h.pump(tester, '/konusma/maya-neighbour');
      await h.tap(tester, 'talk-start');
      await h.tap(tester, 'talk-choose');
      final wrong = find.widgetWithText(OutlinedButton, 'I Alex.');
      await tester.ensureVisible(wrong);
      await tester.tap(wrong);
      await h.settle(tester);
      expect(find.byKey(const ValueKey('talk-reaction')), findsOneWidget);
      expect(find.byTooltip(TalkTexts.listenHiHint), findsOneWidget);
      await h.tap(tester, 'talk-reaction-listen');
      expect(
        h.audio.last.uri.toString(),
        '${base}talk/konusma-maya-neighbour-t1-d1.m4a',
      );
    });

    testWidgets('ses yoksa dinle düğmesi yok', (tester) async {
      final h = TalkHarness();
      addTearDown(h.dispose);
      h.source.talkHiAudio = false;
      await h.pump(tester, '/konusma/maya-neighbour');
      expect(find.byKey(const ValueKey('talk-intro-listen')), findsNothing);
      await h.tap(tester, 'talk-start');
      expect(find.byKey(const ValueKey('talk-prompt-listen')), findsNothing);
      expect(find.byTooltip(TalkTexts.listenHiTask), findsNothing);
      expect(find.byKey(const ValueKey('talk-prompt')), findsOneWidget);
    });
  });

  group('kısa mesaj', () {
    testWidgets('görevin ve ipucunun sesi; ipucu yalnız gösterilince', (
      tester,
    ) async {
      final h = TalkHarness(completed: const ['A1-001', 'A1-004']);
      addTearDown(h.dispose);
      await h.pump(tester, '/konusma/meet-note');
      expect(find.byKey(const ValueKey('message-task-listen')), findsOneWidget);
      expect(find.byKey(const ValueKey('message-hint-listen')), findsNothing);
      await tester.enterText(
        find.byKey(const ValueKey('message-field')),
        'On Friday.',
      );
      await h.tap(tester, 'message-send');
      expect(find.byKey(const ValueKey('message-hint')), findsOneWidget);
      await h.tap(tester, 'message-hint-listen');
      expect(
        h.audio.single.uri.toString(),
        '${base}talk/konusma-meet-note-hint.m4a',
      );
      await h.tap(tester, 'message-task-listen');
      expect(
        h.audio.last.uri.toString(),
        '${base}talk/konusma-meet-note-task.m4a',
      );
    });

    testWidgets('ses yoksa düğme yok', (tester) async {
      final h = TalkHarness(completed: const ['A1-001']);
      addTearDown(h.dispose);
      h.source.talkHiAudio = false;
      await h.pump(tester, '/konusma/hi-intro');
      expect(find.byKey(const ValueKey('message-task')), findsOneWidget);
      expect(find.byKey(const ValueKey('message-task-listen')), findsNothing);
    });
  });

  group('erişilebilirlik', () {
    for (final (path, key) in [
      ('/konusma/cafe-rosa', 'talk-intro-listen'),
      ('/konusma/late-maya', 'message-task-listen'),
    ]) {
      testWidgets('$path: 320 × 568, metin 1,3× taşma yok; dokunma alanı '
          '≥ 44', (tester) async {
        final h = TalkHarness(
          completed: const [
            'A1-001',
            'A1-002',
            'A1-003',
            'A1-004',
            'A1-005',
            'A1-009',
          ],
        );
        addTearDown(h.dispose);
        await h.pump(tester, path, size: const Size(320, 568), textScale: 1.3);
        expect(tester.takeException(), isNull);
        final f = find.byKey(ValueKey(key));
        expect(f, findsOneWidget);
        final size = tester.getSize(f);
        expect(size.width, greaterThanOrEqualTo(44));
        expect(size.height, greaterThanOrEqualTo(44));
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        if (path.endsWith('cafe-rosa')) {
          await h.tap(tester, 'talk-start');
          expect(tester.takeException(), isNull);
          expect(
            find.byKey(const ValueKey('talk-prompt-listen')),
            findsOneWidget,
          );
        }
      });
    }
  });
}
