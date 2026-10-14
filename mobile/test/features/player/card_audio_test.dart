// H-083: Türkçe konuşan kartlar (ipucu, açık soru, Alex'in iç sesi, not)
// Hi kartı gibi `audio` taşır; oynatıcı kart açılınca sesi çalar ve
// "Dinle" düğmesi gösterir.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/player/application/player_session.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/player/domain/episode.dart';
import 'package:hivelzon/features/player/presentation/widgets/card_view.dart';
import 'package:hivelzon/features/player/presentation/widgets/player_ui.dart';
import 'package:video_player/video_player.dart';

import '../../support/fake_content_source.dart';

/// Ağ ve platform olmadan çalışan denetleyici; oynatma durumunu tutar.
class _FakeController extends VideoPlayerController {
  _FakeController(super.uri) : super.networkUrl();

  bool played = false;
  bool disposed = false;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> play() async => played = true;

  @override
  Future<void> dispose() async {
    disposed = true;
    await super.dispose();
  }
}

Map<String, Object?> _card(
  String id,
  String kind, {
  String? audio,
  String? next,
  String text = 'Bu ne olabilir?',
}) => {
  'id': id,
  'type': 'card',
  'kind': kind,
  'lines': [
    {'text': text, 'lang': 'tr'},
  ],
  'audio': ?audio,
  'next': ?next,
};

/// Yalnız kartlardan oluşan küçük bölüm (schemaVersion 1: başlık şart değil).
Map<String, Object?> _episodeJson() => {
  'schemaVersion': 1,
  'episode': {
    'id': 'X1-001',
    'title': 'Kartlar',
    'season': 1,
    'mission': {'tr': 'Kartları dinle.'},
    'links': <String, Object?>{},
  },
  'gate': <String, Object?>{},
  'start': 'c-clue',
  'nodes': [
    _card(
      'c-clue',
      'clue',
      audio: 'audio/X1-001_c-clue_tr.m4a',
      next: 'c-question',
    ),
    _card(
      'c-question',
      'openQuestion',
      audio: 'audio/X1-001_c-question_tr.m4a',
      next: 'c-line',
    ),
    _card(
      'c-line',
      'line',
      audio: 'audio/X1-001_c-line_tr.m4a',
      next: 'c-note',
    ),
    _card(
      'c-note',
      'note',
      audio: 'audio/X1-001_c-nermin_tr.m4a',
      next: 'c-silent',
    ),
    _card('c-silent', 'clue'),
  ],
};

class _CardsSource extends FakeContentSource {
  @override
  Future<Episode> loadEpisode(String contentId) async =>
      Episode.fromJson(_episodeJson());
}

void main() {
  group('ayrıştırma', () {
    test('ipucu, açık soru, iç ses ve not kartları sesi okur', () {
      final ep = Episode.fromJson(_episodeJson());
      CardNode card(String id) => ep.nodes[id]! as CardNode;
      expect(card('c-clue').kind, CardKind.clue);
      expect(card('c-clue').audio, 'audio/X1-001_c-clue_tr.m4a');
      expect(card('c-question').kind, CardKind.openQuestion);
      expect(card('c-question').audio, 'audio/X1-001_c-question_tr.m4a');
      expect(card('c-line').kind, CardKind.line);
      expect(card('c-line').audio, 'audio/X1-001_c-line_tr.m4a');
      expect(card('c-note').kind, CardKind.note);
      expect(card('c-note').audio, 'audio/X1-001_c-nermin_tr.m4a');
      expect(card('c-silent').audio, isNull);
    });
  });

  group('oturum', () {
    late List<_FakeController> created;
    late PlayerSession session;

    setUp(() {
      created = [];
      session = PlayerSession(
        contentId: 'X1-001',
        source: _CardsSource(),
        progress: InMemoryProgressRepository(),
        logTransitions: false,
        videoFactory: (uri) {
          final c = _FakeController(uri);
          created.add(c);
          return c;
        },
      );
    });
    tearDown(() => session.dispose());

    Future<void> settle() => Future<void>.delayed(Duration.zero);

    _FakeController last() => created.last;
    String url(String path) => 'http://test.invalid/X1-001/$path';

    test('kart açılınca sesi çalar; sonraki kartta önceki ses durur', () async {
      await session.start(mode: PlayerStartMode.restart);
      await settle();
      expect(session.engine!.current!.id, 'c-clue');
      expect(last().dataSource, url('audio/X1-001_c-clue_tr.m4a'));
      expect(last().played, isTrue);

      for (final (id, path) in [
        ('c-question', 'audio/X1-001_c-question_tr.m4a'),
        ('c-line', 'audio/X1-001_c-line_tr.m4a'),
        ('c-note', 'audio/X1-001_c-nermin_tr.m4a'),
      ]) {
        final previous = last();
        session.advance();
        await settle();
        expect(session.engine!.current!.id, id);
        expect(previous.disposed, isTrue, reason: '$id: önceki ses durur');
        expect(last().dataSource, url(path));
        expect(last().played, isTrue);
      }

      // Sesi olmayan kart ses çalmaz; açık ses de durur.
      final previous = last();
      final count = created.length;
      session.advance();
      await settle();
      expect(session.engine!.current!.id, 'c-silent');
      expect(created, hasLength(count));
      expect(previous.disposed, isTrue);
    });
  });

  group('Dinle düğmesi', () {
    Future<void> pumpCard(
      WidgetTester tester,
      CardNode card, {
      VoidCallback? onListen,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: SingleChildScrollView(
                child: CardView(
                  card: card,
                  lines: card.lines,
                  onContinue: () {},
                  onListen: onListen,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));
    }

    final ep = Episode.fromJson(_episodeJson());
    for (final id in ['c-clue', 'c-question', 'c-line', 'c-note']) {
      testWidgets('$id: sesi varsa düğme görünür ve çalar', (tester) async {
        final card = ep.nodes[id]! as CardNode;
        var listened = 0;
        await pumpCard(
          tester,
          card,
          // Oynatıcıdaki bağlantıyla aynı: ses yoksa null.
          onListen: card.audio == null ? null : () => listened++,
        );
        expect(find.byType(ListenButton), findsOneWidget);
        await tester.tap(find.byType(ListenButton));
        expect(listened, 1);
      });
    }

    testWidgets('sesi olmayan kartta düğme yok', (tester) async {
      final card = ep.nodes['c-silent']! as CardNode;
      await pumpCard(tester, card, onListen: null);
      expect(find.byType(ListenButton), findsNothing);
      expect(find.byKey(const ValueKey('card-continue')), findsOneWidget);
    });
  });
}
