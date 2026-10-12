import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/player/domain/episode.dart';
import 'package:hivelzon/features/player/domain/subtitles.dart';

import '../../support/fixtures.dart';

void main() {
  test('altyazı: tr, kelime anlamı ve kalıplar okunur (H-046)', () {
    final track = SubtitleTrack.fromJson(
      jsonDecode(fixtureText('A1-001.s02.en.json')),
    );
    final cue = track.cueAt(11.5)!;
    expect(cue.tr, 'Beni duyabiliyor musun?');
    expect(cue.words.map((w) => w.gloss), [
      '-ebilir mi (soru)',
      'sen',
      'duymak',
      'beni',
    ]);
    expect(cue.chunks.single.en, 'Can you hear me?');
    expect(cue.chunks.single.startWord, 0);
    expect(cue.chunks.single.endWord, 3);

    final m = cue.toMeaning('A1-001');
    expect(m.sourceId, cue.id);
    expect(m.words.first.hasTiming, isTrue);
    expect(m.chunkAt(2)!.tr, 'Beni duyabiliyor musun?');
  });

  test('eski altyazı (anlamsız) da okunur', () {
    final track = SubtitleTrack.fromJson({
      'schemaVersion': 1,
      'segment': 's',
      'duration': 2,
      'cues': [
        {
          'id': 's-01',
          'start': 0,
          'end': 1,
          'speaker': 'ALEX',
          'text': 'Hi.',
          'tr': null,
          'words': [
            {'w': 'Hi.', 'start': 0, 'end': 0.5},
          ],
        },
      ],
    });
    expect(track.hasTurkish, isFalse);
    expect(track.cues.single.chunks, isEmpty);
    expect(track.cues.single.words.single.gloss, isNull);
  });

  test('kart satırı, karar repliği ve görev kökü anlamları', () {
    final b3 = loadFixture('A1-003');
    final note = b3.node('c-note') as CardNode;
    final line = note.lines.firstWhere((l) => l.lang == Lang.en);
    expect(line.gloss!.tr, isNotEmpty);
    expect(line.gloss!.words.first.w, 'The');

    final b1 = loadFixture('A1-001');
    final k1 = b1.node('k1') as DecisionNode;
    expect(k1.cue!.gloss!.tr, 'Alo? Alo? Beni duyabiliyor musun?');
    expect(k1.cue!.gloss!.chunks.single.startWord, 2);
    // Seçenekler çevrilmez (kullanıcı kararı).
    final tr = b1.nodes.values
        .whereType<DecisionNode>()
        .expand((d) => d.options)
        .map((o) => o.text);
    expect(tr, isNotEmpty);

    final b4 = loadFixture('A1-004');
    final item = (b4.node('t-kanit') as TaskNode).items.single;
    expect(item.stem, 'I have Art on Friday. What time?');
    expect(item.stemGloss!.tr, 'Cuma günü resim dersim var. Saat kaçta?');

    // Türkçe satırda anlam yok (Hi kartı).
    final hi = b1.node('h-02') as CardNode;
    expect(hi.lines.first.lang, Lang.tr);
    expect(hi.lines.first.gloss, isNull);
  });

  test('🎯 hedef ifadelerin anlamları (H-050)', () {
    final b1 = loadFixture('A1-001').info;
    expect(b1.targetPhrases, contains('Can you hear me?'));
    expect(
      b1.targetPhraseGloss['Can you hear me?']!.tr,
      'Beni duyabiliyor musun?',
    );
    expect(b1.targetPhraseGloss['Where is…?']!.tr, '… nerede?');
    // Altyazıda geçmeyen ifade de anlamını `phrases`tan alır (H-052).
    expect(b1.targetPhraseGloss['Listen.']!.tr, 'Dinle.');
    // Bölüm sözlüğü (H-052).
    expect(
      [for (final g in b1.glossary) '${g.word}=${g.tr}'],
      ['channel=kanal'],
    );
    final b4 = loadFixture('A1-004').info;
    expect(b4.targetPhraseGloss['on Friday']!.words.last.gloss, 'cuma');
  });
}
