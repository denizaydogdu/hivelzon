import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/hi/domain/coach_rules.dart';
import 'package:hivelzon/features/hi/domain/hi_content.dart';
import 'package:hivelzon/features/hi/domain/lookup_search.dart';
import 'package:hivelzon/features/hi/domain/weekly_summary.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/meaning/error_taxonomy.dart';

import '../../support/fake_content_source.dart';

LookupCandidate _c(
  String en,
  String tr, {
  LookupOrigin origin = LookupOrigin.episode,
  List<String> alt = const [],
}) => LookupCandidate(
  item: NotebookItem(
    kind: NotebookKind.word,
    textEn: en,
    textTr: tr,
    contentId: 'A1-001',
    source: NotebookSource.lookup,
  ),
  origin: origin,
  alt: alt,
);

void main() {
  group('hi.json (gerçek dışa aktarım)', () {
    final hi = loadHiFixture();

    test('katalog: kararlı kimlikler, tür sürüm 1, 1–2 örnek', () {
      expect(hi.errorCatalog.length, greaterThanOrEqualTo(6));
      for (final n in hi.errorCatalog) {
        expect(n.id, matches(RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$')));
        expect(n.errorType, isNot(ErrorType.other));
        expect(n.examples.length, inInclusiveRange(1, 2));
        expect(n.explanationTr, isNotEmpty);
      }
      expect(
        hi.errorCatalog.map((n) => n.id),
        containsAll([
          'be-dropped',
          'can-short-answer',
          'question-word-order',
          'time-preposition',
          'agree-no-be',
          'third-person-s',
          'articles',
        ]),
      );
    });

    test('karar eşlemesi: B4 "in seven o\'clock" → Edat, saat notu', () {
      final d = hi.decisionError('A1-004', 'k2#b')!;
      expect(d.errorType, ErrorType.preposition);
      expect(hi.note(d.entry)!.labelTr, 'Saat ve gün: at / on');
      expect(hi.decisionError('A1-004', 'k2#a'), isNull);
    });

    test('konu tanıtımları B1–B4 segmentlerinde, 2–3 satır', () {
      expect(hi.topicIntros.map((t) => t.id), [
        'can-questions',
        'where-is',
        'this-is-to-be',
        'directions',
        'time',
      ]);
      for (final t in hi.topicIntros) {
        expect(t.linesTr.length, inInclusiveRange(2, 3));
        expect(t.node, isNot('title'));
      }
    });

    test('köprü görevleri: bölüm başına en fazla 1', () {
      final ids = hi.bridgeTasks.map((t) => t.contentId).toList();
      expect(ids.toSet().length, ids.length);
      expect(hi.bridgeTaskFor('A1-004')!.textTr, contains("It's seven"));
    });

    test('ifadeyle ilgili not ("Neden böyle?")', () {
      expect(hi.noteForPhrase("It's seven o'clock.")!.id, 'time-preposition');
      expect(hi.noteForPhrase('Yes, I can.')!.id, 'can-short-answer');
      expect(hi.noteForPhrase('harbour'), isNull);
    });

    test('Hi metinlerinde suçlayıcı dil yok (metin denetim listesi)', () {
      const banned = [
        'kaçırdın',
        'başarısız',
        'yanlış yaptın',
        'serini kaybettin',
        'son şans',
        'tembel',
      ];
      final texts = [
        for (final n in hi.errorCatalog) ...[n.labelTr, n.explanationTr],
        for (final t in hi.topicIntros) ...t.linesTr,
        for (final b in hi.bridgeTasks) ...[b.titleTr, b.textTr],
        HiTexts.restReason,
        HiTexts.lookupNoMatch,
        HiTexts.weekEmpty,
        HiTexts.privacyConfirmBody,
        HiTexts.whyWrong,
      ];
      for (final t in texts) {
        for (final w in banned) {
          expect(t.toLowerCase(), isNot(contains(w)), reason: t);
        }
      }
      expect(HiTexts.whyWrong.toLowerCase(), isNot(contains('yanlış')));
    });
  });

  group('"Bu ne demek?" arama', () {
    final list = [
      _c('station', 'istasyon'),
      _c('Excuse me', 'Affedersiniz / Pardon (kibar başlangıç)'),
      _c('I', 'ben'),
      _c('İzmir', 'İzmir'),
      _c('near', 'yakınında'),
      _c('harbour', 'liman'),
      _c('station', 'istasyon', origin: LookupOrigin.notebook),
      _c('light', 'ışık'),
    ];

    test('Türkçe büyük İ ile arama ("İSTASYON" → station)', () {
      final r = searchLookup('İSTASYON', list);
      expect(r.first.item.textEn, 'station');
      expect(r, hasLength(1)); // aynı ifade bir kez
      expect(r.first.origin, LookupOrigin.notebook); // önce defterdeki
    });

    test('İngilizce "I" bulunur (lowerTr "ı" yapsa da)', () {
      expect(searchLookup('I', list).first.item.textEn, 'I');
      expect(searchLookup('i', list).first.item.textEn, 'I');
    });

    test('Türkçe klavyesiz yazım: "isik" → ışık, "yakininda" → near', () {
      expect(searchLookup('isik', list).single.item.textEn, 'light');
      expect(searchLookup('yakininda', list).single.item.textEn, 'near');
    });

    test('çoklu anlam: "pardon" → Excuse me; kelime başı eşleşir', () {
      expect(searchLookup('pardon', list).single.item.textEn, 'Excuse me');
      expect(searchLookup('excu', list).single.item.textEn, 'Excuse me');
    });

    test('tek harf yalnızca tam eşleşir; eşleşme yoksa boş', () {
      expect(searchLookup('h', list), isEmpty);
      expect(searchLookup('lighthouse', list), isEmpty);
      expect(searchLookup('   ', list), isEmpty);
    });

    test('foldForSearch', () {
      expect(foldForSearch('İSTASYON'), 'istasyon');
      expect(foldForSearch('Köprü, Şişe!'), 'kopru sise');
      expect(foldForSearch("It’s near…"), "it's near");
    });

    test('dizin girdisi deftere uygun ses taşır', () {
      final hi = loadHiFixture();
      final station = hi.lookup.firstWhere((e) => e.en == 'station');
      final item = station.toNotebookItem();
      expect(item.hasAudio, isTrue);
      expect(item.audio!.isRange, isTrue);
      expect(item.contentId, 'A1-001');
    });
  });

  group('haftalık özet', () {
    final now = DateTime.utc(2026, 10, 13, 12);
    DateTime ago(int days, [int hours = 0]) =>
        now.subtract(Duration(days: days, hours: hours));

    test('son 7 gün: ifade, farklı kart, bölüm, en sık tür', () {
      final s = computeWeeklySummary(
        now: now,
        itemCreatedAt: [ago(1), ago(2), ago(6, 23), ago(8)],
        reviews: [(1, ago(1)), (1, ago(0, 2)), (2, ago(3)), (3, ago(9))],
        completedAt: [ago(2), ago(10)],
        errors: [
          ErrorObservation(type: ErrorType.preposition, at: ago(1)),
          ErrorObservation(type: ErrorType.preposition, at: ago(2)),
          ErrorObservation(type: ErrorType.wordOrder, at: ago(0, 1)),
          ErrorObservation(type: ErrorType.recall, at: ago(9)),
          ErrorObservation(type: ErrorType.recall, at: ago(9)),
          ErrorObservation(type: ErrorType.recall, at: ago(9)),
        ],
      );
      expect(s.phrasesAdded, 3);
      expect(s.phrasesReviewed, 2);
      expect(s.episodesCompleted, 1);
      expect(s.focus, ErrorType.preposition);
      expect(s.isEmpty, isFalse);
    });

    test('eşit sayıda en yeni tür; kayıt yoksa boş', () {
      final s = computeWeeklySummary(
        now: now,
        itemCreatedAt: const [],
        reviews: const [],
        completedAt: const [],
        errors: [
          ErrorObservation(type: ErrorType.preposition, at: ago(3)),
          ErrorObservation(type: ErrorType.article, at: ago(1)),
        ],
      );
      expect(s.focus, ErrorType.article);
      final empty = computeWeeklySummary(
        now: now,
        itemCreatedAt: const [],
        reviews: const [],
        completedAt: const [],
        errors: const [],
      );
      expect(empty.isEmpty, isTrue);
    });
  });

  test('HiContent.empty güvenli', () {
    expect(HiContent.empty.note('x'), isNull);
    expect(HiContent.empty.noteForType(ErrorType.article), isNull);
  });
}
