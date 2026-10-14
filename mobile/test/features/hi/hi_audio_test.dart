// H-083: Hi'nin notu, konu kartı ve yan görevde Türkçe ses ("Dinle").
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/hi/domain/hi_content.dart';
import 'package:hivelzon/features/hi/presentation/hi_cards.dart';
import 'package:hivelzon/features/hi/presentation/panel/hi_bridge_card.dart';
import 'package:hivelzon/features/player/presentation/player_screen.dart'
    show videoControllerFactoryProvider;
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/meaning/error_taxonomy.dart';
import 'package:video_player/video_player.dart';

import '../../support/fake_content_source.dart';

class _FakeController extends VideoPlayerController {
  _FakeController(super.uri) : super.networkUrl();

  bool played = false;
  bool disposed = false;

  @override
  Future<void> initialize() async {
    value = value.copyWith(
      isInitialized: true,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Future<void> play() async {
    played = true;
    value = value.copyWith(isPlaying: true);
  }

  @override
  Future<void> dispose() async {
    disposed = true;
    await super.dispose();
  }
}

const _seasonUrl = 'http://test.invalid/_season/S1/';

ErrorNote _note({String? audio}) => ErrorNote(
  id: 'be-dropped',
  errorType: ErrorType.other,
  labelTr: '"be" düşmesi',
  explanationTr: 'Türkçede "-dir" düşer; İngilizcede "am/is/are" kalır.',
  examples: const [(wrong: 'I happy.', right: "I'm happy.")],
  audio: audio,
);

TopicIntro _intro({String? audio}) => TopicIntro(
  id: 'can-questions',
  contentId: 'A1-001',
  node: 's02',
  titleEn: 'Can you…?',
  linesTr: const ['Bir şeyi yapabilir mi diye sorarken "Can you…?" denir.'],
  exampleEn: 'Can you hear me?',
  exampleTr: 'Beni duyabiliyor musun?',
  audio: audio,
);

BridgeTask _bridge({String? audio}) => BridgeTask(
  id: 'bt-a1-001',
  contentId: 'A1-001',
  titleTr: 'Bugün bir kez "Can you…?" diye sor.',
  textTr: 'Bir arkadaşına İngilizce küçük bir soru sor.',
  audio: audio,
);

void main() {
  group('hi.json ayrıştırma', () {
    test('not, konu kartı ve yan görev sesi (sezon paketine göre yol)', () {
      final hi = HiContent.fromJson({
        'errorCatalog': [
          {
            'id': 'be-dropped',
            'errorType': 'other',
            'labelTr': 'x',
            'explanationTr': 'y',
            'audio': 'hi/note-be-dropped.m4a',
          },
          {
            'id': 'silent',
            'errorType': 'other',
            'labelTr': 'x',
            'explanationTr': 'y',
          },
        ],
        'topicIntros': [
          {
            'id': 'can-questions',
            'contentId': 'A1-001',
            'trigger': {'node': 's02'},
            'titleEn': 'Can you…?',
            'linesTr': ['a'],
            'exampleEn': 'b',
            'exampleTr': 'c',
            'audio': 'hi/intro-can-questions.m4a',
          },
        ],
        'bridgeTasks': [
          {
            'id': 'bt-a1-001',
            'contentId': 'A1-001',
            'titleTr': 'a',
            'textTr': 'b',
            'audio': 'hi/bridge-bt-a1-001.m4a',
          },
        ],
      });
      expect(hi.errorCatalog.first.audio, 'hi/note-be-dropped.m4a');
      expect(hi.errorCatalog.last.audio, isNull);
      expect(hi.topicIntros.single.audio, 'hi/intro-can-questions.m4a');
      expect(hi.bridgeTasks.single.audio, 'hi/bridge-bt-a1-001.m4a');
    });
  });

  group('Dinle düğmesi', () {
    late List<_FakeController> created;

    setUp(() => created = []);

    Future<void> pump(WidgetTester tester, Widget home) async {
      tester.view.physicalSize = const Size(1179, 2556);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            contentSourceProvider.overrideWithValue(FakeContentSource()),
            videoControllerFactoryProvider.overrideWithValue((uri) {
              final c = _FakeController(uri);
              created.add(c);
              return c;
            }),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(body: home),
          ),
        ),
      );
      await tester.pump();
    }

    final listen = find.byKey(const ValueKey('hi-listen'));

    testWidgets('ses yoksa düğme yok (not, konu, yan görev)', (tester) async {
      await pump(
        tester,
        ListView(
          children: [
            HiNoteCard(note: _note()),
            HiTopicCard(intro: _intro()),
            HiBridgeCard(task: _bridge()),
          ],
        ),
      );
      expect(listen, findsNothing);
      expect(find.byTooltip(HiTexts.listen), findsNothing);
    });

    testWidgets(
      'Hi notu: dokununca sezon sesi çalar; sayfa kapanınca durur ve bırakılır',
      (tester) async {
        await pump(
          tester,
          Builder(
            builder: (context) => TextButton(
              onPressed: () =>
                  showHiNote(context, _note(audio: 'hi/note-be-dropped.m4a')),
              child: const Text('aç'),
            ),
          ),
        );
        await tester.tap(find.text('aç'));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(find.byKey(const ValueKey('hi-note-sheet')), findsOneWidget);
        expect(listen, findsOneWidget);
        expect(find.byTooltip(HiTexts.listen), findsOneWidget);
        expect(created, isEmpty, reason: 'kendiliğinden çalmaz');

        await tester.tap(listen);
        await tester.pump();
        expect(created, hasLength(1));
        expect(
          created.single.dataSource,
          '${_seasonUrl}hi/note-be-dropped.m4a',
        );
        expect(created.single.played, isTrue);
        expect(find.byTooltip(HiTexts.listenStop), findsOneWidget);

        await tester.tap(find.byTooltip(CommonTexts.close));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(find.byKey(const ValueKey('hi-note-sheet')), findsNothing);
        expect(created.single.disposed, isTrue);
      },
    );

    testWidgets('konu kartı (Defter): çalarken dokunmak durdurur; atılınca '
        'ses durur', (tester) async {
      await pump(
        tester,
        HiTopicCard(intro: _intro(audio: 'hi/intro-can-questions.m4a')),
      );
      await tester.tap(listen);
      await tester.pump();
      expect(
        created.single.dataSource,
        '${_seasonUrl}hi/intro-can-questions.m4a',
      );
      // Çalarken dokununca durur.
      await tester.tap(listen);
      await tester.pump();
      expect(created.single.disposed, isTrue);
      expect(find.byTooltip(HiTexts.listen), findsOneWidget);

      // Yeniden çalar; kart atılınca durur.
      await tester.tap(listen);
      await tester.pump();
      expect(created, hasLength(2));
      expect(created.last.disposed, isFalse);
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      expect(created.last.disposed, isTrue);
    });

    testWidgets('yan görev: sesi çalar; aynı anda tek Hi sesi', (tester) async {
      await pump(
        tester,
        ListView(
          children: [
            HiBridgeCard(task: _bridge(audio: 'hi/bridge-bt-a1-001.m4a')),
            HiTopicCard(intro: _intro(audio: 'hi/intro-can-questions.m4a')),
          ],
        ),
      );
      expect(listen, findsNWidgets(2));
      await tester.tap(listen.first);
      await tester.pump();
      expect(created.single.dataSource, '${_seasonUrl}hi/bridge-bt-a1-001.m4a');
      await tester.tap(listen.last);
      await tester.pump();
      expect(created, hasLength(2));
      expect(created.first.disposed, isTrue, reason: 'önceki ses durur');
      expect(created.last.played, isTrue);

      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      expect(created.last.disposed, isTrue);
    });

    testWidgets('oynatıcı kendi çalarını verirse kart onu kullanır', (
      tester,
    ) async {
      var listened = 0;
      await pump(
        tester,
        HiTopicCard(
          intro: _intro(audio: 'hi/intro-can-questions.m4a'),
          onListen: () => listened++,
        ),
      );
      await tester.tap(listen);
      await tester.pump();
      expect(listened, 1);
      expect(created, isEmpty);
    });
  });
}
