import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/discover/domain/reel.dart';
import 'package:hivelzon/features/grammar/domain/grammar_lesson.dart';
import 'package:hivelzon/features/player/domain/episode.dart';
import 'package:hivelzon/features/player/domain/subtitles.dart';
import 'package:hivelzon/features/player/presentation/player_screen.dart'
    show videoControllerFactoryProvider;
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/meaning/meaning_controller.dart';
import 'package:hivelzon/shared/meaning/meaning_sheet.dart';
import 'package:hivelzon/shared/meaning/meaning_text.dart';
import 'package:hivelzon/shared/meaning/notebook_repository.dart';

import '../../support/fake_content_source.dart';
import '../../support/talk_harness.dart' show FakeAudioController;

/// İngilizce sesin çağrılarını sayar (anlam paneli kelime/cümle sesi).
class _RecordingAudio implements MeaningAudio {
  int stops = 0;
  int plays = 0;

  @override
  bool get canPlayWords => true;

  @override
  bool get canPlaySentence => true;

  @override
  Future<void> playWord(MeaningWord word, {required double speed}) async =>
      plays++;

  @override
  Future<void> playSentence({required double speed}) async => plays++;

  @override
  Future<void> stop() async => stops++;
}

/// H-109 Faz 3: çevirilerin Türkçe sesi. Anlam panelinde "Türkçesini dinle"
/// yalnız ses varken ve Türkçe gösterildikten sonra görünür, yalnız dokununca
/// çalar, İngilizce sesle aynı anda çalmaz; paket alanı yoksa hiçbir şey
/// değişmez.
void main() {
  group('paket alanları', () {
    Map<String, dynamic> cue({Object? trAudio, String? tr = 'Bir daha.'}) => {
      'id': 's02-01',
      'start': 0.5,
      'end': 2.0,
      'speaker': 'ALEX',
      'text': 'Again.',
      'tr': tr,
      'words': [
        {'w': 'Again.', 'start': 0.5, 'end': 1.0},
      ],
      'trAudio': ?trAudio,
    };

    SubtitleTrack track(List<Map<String, dynamic>> cues) =>
        SubtitleTrack.fromJson({
          'schemaVersion': 1,
          'segment': 's02',
          'duration': 3,
          'cues': cues,
        });

    test('altyazı: `trAudio` okunur, anlam metnine geçer; güvensiz yol ve '
        'Türkçesi olmayan satır sessiz', () {
      final c = track([cue(trAudio: 'audio/ceviri/l-1.m4a')]).cues.single;
      expect(c.trAudio, 'audio/ceviri/l-1.m4a');
      expect(c.toMeaning('A1-001').trAudio, 'audio/ceviri/l-1.m4a');
      expect(c.toMeaning('A1-001').hasTurkishAudio, isTrue);
      expect(track([cue()]).cues.single.trAudio, isNull);
      expect(track([cue(trAudio: '../x.m4a')]).cues.single.trAudio, isNull);
      expect(track([cue(trAudio: 3)]).cues.single.trAudio, isNull);
      final noTr = track([
        cue(trAudio: 'audio/ceviri/l-1.m4a', tr: null),
      ]).cues.single;
      expect(noTr.toMeaning('A1-001').trAudio, isNull);
    });

    test('bölüm: `episode.translationAudio` metinle birebir eşleşir', () {
      final info = EpisodeInfo.fromJson({
        'id': 'A1-001',
        'title': 'A Strange Message',
        'mission': {'tr': 'Mesajı bul.'},
        'links': const {},
        'translationAudio': {
          'Bir daha.': 'audio/ceviri/l-1.m4a',
          'Kötü.': '../kacak.m4a',
          'Sayı.': 7,
        },
      });
      expect(info.trAudioFor('Bir daha.'), 'audio/ceviri/l-1.m4a');
      expect(info.trAudioFor(' Bir daha. '), 'audio/ceviri/l-1.m4a');
      expect(info.trAudioFor('Bir daha'), isNull);
      expect(info.trAudioFor('Kötü.'), isNull);
      expect(info.trAudioFor('Sayı.'), isNull);
      expect(info.trAudioFor(null), isNull);
      final old = EpisodeInfo.fromJson({
        'id': 'A1-001',
        'title': 'A Strange Message',
        'mission': {'tr': 'Mesajı bul.'},
        'links': const {},
      });
      expect(old.translationAudio, isEmpty);
    });

    test('reel: satır sesi reel paketine bağlanır', () {
      final r = Reel.fromJson({
        'schemaVersion': 1,
        'id': 'A1-R-BOK-01',
        'category': 'BOK',
        'level': 'A1',
        'titleTr': 'Kütüphanede',
        'duration': 11.0,
        'video': 'A1-R-BOK-01.mp4',
        'target': {
          'kind': 'phrase',
          'en': 'Again.',
          'tr': 'Bir daha.',
          'cue': 's02-01',
        },
        'cues': [
          cue(trAudio: 'audio/tr/sub-s02-01.m4a'),
          {...cue(), 'id': 's02-02'},
        ],
      });
      final cues = r.subtitles.cues;
      expect(cues.first.trAudio, '_reels/A1-R-BOK-01/audio/tr/sub-s02-01.m4a');
      expect(cues.last.trAudio, isNull);
    });

    test('dilbilgisi: örnek ve "Söyle" Türkçesinin sesi', () {
      final e = GrammarExample.fromJson({
        'id': 'c03-ex1',
        'en': 'She goes to school.',
        'tr': 'O okula gider.',
        'trAudio': 'audio/c03-ex1-tl.m4a',
        'trDuration': 1.8,
      });
      expect(e.trAudio, 'audio/c03-ex1-tl.m4a');
      expect(
        e.toMeaning('G-A1-13-third-person-s').trAudio,
        '_grammar/G-A1-13-third-person-s/audio/c03-ex1-tl.m4a',
      );
      final plain = GrammarExample.fromJson({
        'id': 'c03-ex1',
        'en': 'She goes to school.',
        'tr': 'O okula gider.',
      });
      expect(plain.toMeaning('G-A1-13-third-person-s').trAudio, isNull);
      // Ders sessiz modda: anlam panelinde Türkçe ses verilmez.
      expect(
        e.toMeaning('G-A1-13-third-person-s', trSound: false).trAudio,
        isNull,
      );
      final say = PracticeItem.fromJson({
        'id': 'c07-q5',
        'kind': 'say',
        'text': 'She goes to school.',
        'tr': 'O okula gider.',
        'trAudio': 'audio/c07-q5-tl.m4a',
      })!;
      expect(say.trAudio, 'audio/c07-q5-tl.m4a');
    });

    test('withTrAudio var olan sesi ezmez, null yolu yok sayar', () {
      const t = MeaningText(
        contentId: 'A1-001',
        sourceId: 'x',
        en: 'Hi.',
        words: [],
        tr: 'Merhaba.',
      );
      expect(t.withTrAudio(null).trAudio, isNull);
      final a = t.withTrAudio('audio/ceviri/a.m4a');
      expect(a.trAudio, 'audio/ceviri/a.m4a');
      expect(a.withTrAudio('audio/ceviri/b.m4a').trAudio, 'audio/ceviri/a.m4a');
      expect(a.tr, 'Merhaba.');
    });
  });

  group('anlam paneli: "Türkçesini dinle"', () {
    final listen = find.byKey(const ValueKey('meaning-tr-listen'));

    MeaningText text({String? trAudio, String contentId = 'A1-001'}) =>
        MeaningText(
          contentId: contentId,
          sourceId: 's02-01',
          en: 'Again, please.',
          tr: 'Bir daha, lütfen.',
          words: const [
            MeaningWord('Again,', gloss: 'tekrar', start: 0.1, end: 0.4),
            MeaningWord('please.', gloss: 'lütfen', start: 0.4, end: 0.8),
          ],
          trAudio: trAudio,
        );

    Future<(MeaningController, _RecordingAudio, List<FakeAudioController>)>
    pump(WidgetTester tester, MeaningText t) async {
      tester.view.physicalSize = const Size(1179, 4000);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final audio = _RecordingAudio();
      final m = MeaningController(
        text: t,
        audio: audio,
        events: InMemoryLearningEventLog(),
        notebook: InMemoryNotebookRepository(),
      );
      addTearDown(m.dispose);
      final players = <FakeAudioController>[];
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            contentSourceProvider.overrideWithValue(
              FakeContentSource(packageIds: const ['A1-001']),
            ),
            videoControllerFactoryProvider.overrideWithValue((uri) {
              final c = FakeAudioController(uri);
              players.add(c);
              return c;
            }),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: Scaffold(body: MeaningSheet(controller: m)),
          ),
        ),
      );
      await tester.pump();
      return (m, audio, players);
    }

    bool playing(WidgetTester tester) => find
        .descendant(of: listen, matching: find.byIcon(Icons.stop_rounded))
        .evaluate()
        .isNotEmpty;

    testWidgets('ses yoksa Türkçe gösterilse de düğme yok', (tester) async {
      final (m, _, players) = await pump(tester, text());
      m.reveal();
      await tester.pump();
      expect(find.text('Bir daha, lütfen.'), findsOneWidget);
      expect(listen, findsNothing);
      expect(players, isEmpty);
    });

    testWidgets('düğme Türkçe gösterilince çıkar; kendiliğinden çalmaz; '
        'dokununca bölüm paketinden çalar ve İngilizce sesi durdurur; '
        'İngilizce ses başlayınca Türkçe durur', (tester) async {
      final (m, audio, players) = await pump(
        tester,
        text(trAudio: 'audio/ceviri/l-abc.m4a'),
      );
      expect(listen, findsNothing);
      m.reveal();
      await tester.pump();
      expect(listen, findsOneWidget);
      expect(players, isEmpty);
      await tester.tap(listen);
      await tester.pump();
      await tester.pump();
      expect(audio.stops, 1);
      expect(players, hasLength(1));
      expect(
        players.single.uri.toString(),
        'http://test.invalid/A1-001/audio/ceviri/l-abc.m4a',
      );
      expect(players.single.played, isTrue);
      expect(playing(tester), isTrue);
      // İngilizce kelime sesi başladı: Türkçe durur.
      m.selectWord(0);
      await tester.pump();
      await tester.pump();
      expect(audio.plays, 1);
      expect(playing(tester), isFalse);
      // Yeniden Türkçe, sonra "Tekrar dinle": yine durur.
      await tester.tap(listen);
      await tester.pump();
      await tester.pump();
      expect(playing(tester), isTrue);
      await m.replay();
      await tester.pump();
      await tester.pump();
      expect(playing(tester), isFalse);
    });

    testWidgets('reel ve ders yolları kendi paketlerinden çözülür', (
      tester,
    ) async {
      var (m, _, players) = await pump(
        tester,
        text(
          contentId: 'A1-R-BOK-01',
          trAudio: '_reels/A1-R-BOK-01/audio/tr/sub-s02-01.m4a',
        ),
      );
      m.reveal();
      await tester.pump();
      await tester.tap(listen);
      await tester.pump();
      await tester.pump();
      expect(
        players.single.uri.toString(),
        'http://test.invalid/reels/A1-R-BOK-01/audio/tr/sub-s02-01.m4a',
      );
      (m, _, players) = await pump(
        tester,
        text(
          contentId: 'G-A1-13-third-person-s',
          trAudio: '_grammar/G-A1-13-third-person-s/audio/c03-ex1-tl.m4a',
        ),
      );
      m.reveal();
      await tester.pump();
      await tester.tap(listen);
      await tester.pump();
      await tester.pump();
      expect(
        players.single.uri.toString(),
        'http://test.invalid/grammar/G-A1-13-third-person-s/audio/c03-ex1-tl.m4a',
      );
    });
  });
}
