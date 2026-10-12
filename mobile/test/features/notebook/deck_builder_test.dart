import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/notebook/domain/clue_board.dart';
import 'package:hivelzon/features/notebook/domain/deck_builder.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/player/domain/episode.dart';
import 'package:hivelzon/features/player/domain/subtitles.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';

import '../../support/fixtures.dart';

/// Gerçek paket altyazıları (`test/fixtures/subs/<id>/`).
SubtitleIndex subsFor(Episode e) => {
  for (final n in e.nodes.values)
    if (n is SegmentNode &&
        n is! TitleNode &&
        n is! RecapNode &&
        n.subtitles != null)
      n.id: SubtitleTrack.fromJson(
        jsonDecode(
          fixtureText('subs/${e.info.id}/${n.subtitles!.split('/').last}'),
        ),
      ),
};

void main() {
  final at = DateTime.utc(2026, 10, 12, 9);

  group('buildEpisodeDeck (B1 paket verisi)', () {
    final b1 = loadFixture('A1-001');
    final deck = buildEpisodeDeck(b1, subtitles: subsFor(b1), now: at);
    NotebookItem item(String en) =>
        deck.items.firstWhere((i) => i.textEn == en);

    test('hedef ifadeler kart olur; Türkçesi bulunamayan atlanır', () {
      expect(deck.items.map((i) => i.textEn), [
        'Can you hear me?',
        'Yes, I can.',
        'Again, please.',
        'Where is…?',
      ]);
      // "Listen." B1 altyazısında yok ve targetPhraseGloss'ta da yok.
      expect(deck.skipped, ['Listen.']);
      expect(
        deck.items.every((i) => i.source == NotebookSource.autoTargetPhrase),
        isTrue,
      );
    });

    test('ses: karakterin sesi, kelime zamanlarıyla segmentten', () {
      final can = item('Can you hear me?');
      expect(can.audio!.path, 'segments/s02.mp4');
      expect(can.audio!.start, 11.027);
      expect(can.audio!.end, 12.587);
      expect(can.exampleEn, 'Can you hear me?');
      expect(can.exampleTr, 'Beni duyabiliyor musun?');
      expect(can.textTr, 'Beni duyabiliyor musun?');
      expect(can.cueId, 's02-04');
      // "Yes, I can." → "Yes, I can hear you." satırının ilk üç kelimesi.
      final yes = item('Yes, I can.');
      expect(yes.audio!.path, 'segments/k1-ok.mp4');
      expect(yes.exampleEn, 'Yes, I can hear you.');
      expect(yes.exampleAudio!.end, greaterThan(yes.audio!.end!));
      // "Where is…?" → "Where is the old station?" (s05).
      final where = item('Where is…?');
      expect(where.audio!.path, 'segments/s05.mp4');
      expect(where.exampleEn, 'Where is the old station?');
      expect(where.kind, NotebookKind.phrase);
    });

    test('görsel: satırın segmentine en yakın sahne görseli', () {
      expect(item('Can you hear me?').imagePath, 'stills/T2-pov.jpg');
      // Karar anının sonucu (k2 → k2-ok): karar anının görseli.
      expect(item('Again, please.').imagePath, 'stills/I2-telefon-hi.jpg');
      expect(item('Yes, I can.').imagePath, 'stills/T2-pov.jpg');
      expect(item('Where is…?').imagePath, 'stills/I5-harita.jpg');
      expect(imageNear(b1, 's03'), 'stills/I2-telefon-hi.jpg');
    });

    test('bakılan kelime: dilbilgisi sözcüğü değilse kart olur', () {
      final withLookups = buildEpisodeDeck(
        b1,
        subtitles: subsFor(b1),
        now: at,
        lookups: [
          for (final (src, w) in const [
            ('s02-02', 'Channel'),
            ('s02-04', 'you'),
            ('s02-04', 'hear'),
            ('s02-02', 'Channel'),
            ('yok-01', 'station'),
          ])
            LearningEvent(
              contentId: 'A1-001',
              sourceId: src,
              target: w,
              at: at,
            ),
          LearningEvent(
            contentId: 'A1-001',
            sourceId: 's02-04',
            target: LearningEvent.sentence,
            at: at,
          ),
        ],
      );
      final lookups = withLookups.items
          .where((i) => i.source == NotebookSource.lookup)
          .toList();
      expect(lookups.map((i) => i.textEn), ['channel', 'hear']);
      expect(lookups.first.textTr, 'kanal');
      expect(lookups.first.kind, NotebookKind.word);
      expect(lookups.first.audio!.start, 1.87);
      expect(lookups.first.exampleEn, 'Channel seven.');
    });

    test('anahtar normalleştirme: aynı ifade iki kez girmez', () {
      expect(
        itemKey(NotebookKind.phrase, 'Where is…?'),
        itemKey(NotebookKind.phrase, 'where is ...'),
      );
      expect(wordCount('Where is…?'), 2);
      expect(wordCount('Listen.'), 1);
    });
  });

  group('ipucu panosu', () {
    test('ipuçları bölüm sonu kartından', () {
      final clues = extractClues(loadFixture('A1-001'));
      expect(clues.map((c) => c.clueId), ['C1', 'C2']);
      expect(clues.first.textTr, 'Telsiz mesajı (ses + metin)');
      expect(clues.last.textTr, 'Not: E. / old station / Friday / 7');
    });

    test('bağlar: açık soru metni ve kısmi cevap notu', () {
      final b1 = extractStoryLinks(loadFixture('A1-001'));
      expect(b1.openQuestionId, 'Q1');
      expect(b1.openQuestionTr, 'Old Station nerede?');
      final b2 = extractStoryLinks(loadFixture('A1-002'));
      expect(b2.answers, ['Q1:partial']);
      expect(b2.partialNotes, {'Q1': 'limanda.'});
    });

    StoryLinkRecord rec(String id) {
      final l = extractStoryLinks(loadFixture(id));
      return StoryLinkRecord(
        contentId: l.contentId,
        number: l.number,
        openQuestionId: l.openQuestionId,
        openQuestionTr: l.openQuestionTr,
        answers: l.answers,
        partialNotes: l.partialNotes,
      );
    }

    test('açık sorular: yenisi önce, kapanan düşer, en çok 3', () {
      final after2 = deriveOpenQuestions([rec('A1-002'), rec('A1-001')]);
      expect(after2.map((q) => q.id), ['Q2', 'Q1']);
      expect(after2.last.partialNote, 'limanda.');
      final after4 = deriveOpenQuestions([
        for (final id in ['A1-001', 'A1-002', 'A1-003', 'A1-004']) rec(id),
      ]);
      // Q1 B3'te, Q3 B4'te kapandı; Q2 (B5'te kapanacak) ve Q4 açık.
      expect(after4.map((q) => q.id), ['Q4', 'Q2']);
      final many = deriveOpenQuestions([
        for (var i = 1; i <= 5; i++)
          StoryLinkRecord(
            contentId: 'X-00$i',
            number: i,
            openQuestionId: 'Q$i',
            openQuestionTr: 'Soru $i',
          ),
      ]);
      expect(many.map((q) => q.id), ['Q5', 'Q4', 'Q3']);
    });
  });
}
