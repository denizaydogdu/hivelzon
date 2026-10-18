import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/talk/domain/talk_match.dart';
import 'package:hivelzon/features/talk/domain/talk_task.dart';
import 'package:hivelzon/shared/speech/speech_match.dart';

import '../../support/fixtures.dart';

/// H-090: Konuş cevaplarının denetimi. Kabul listesi, yakın seçenek, anlamı
/// tersine çeviren ek (H-087), mesaj kuralı ve hedef ifade eşleşmesi.
void main() {
  final catalog = TalkCatalog.fromJson(
    (jsonDecode(fixtureText('talk.json')) as Map).cast(),
  );
  TalkTurn turn(String task, String id) =>
      catalog.byId(task)!.turns.firstWhere((t) => t.id == id);

  group('söylenen cevap (birkaç doğal cevap kabul)', () {
    test('kabul listesindeki her cevap tam söylenince kabul', () {
      final t = turn('cafe-rosa', 't1');
      for (final a in t.accept) {
        final r = TalkMatcher.judgeSpeech(t, [a.toLowerCase()]);
        expect(r.outcome, TalkSpeechOutcome.accepted, reason: a);
      }
      expect(
        TalkMatcher.judgeSpeech(t, [
          'can I have a hot chocolate please',
        ]).acceptIndex,
        1,
      );
    });

    test('motorun alternatiflerinden biri yeter; dolgu sesi atılır', () {
      final t = turn('ask-the-way', 't1');
      final r = TalkMatcher.judgeSpeech(t, [
        'excuse me where is the bus top',
        'um excuse me where is the bus stop',
      ]);
      expect(r.accepted, isTrue);
    });

    test('ters anlamlı cevap kabul edilmez (H-087)', () {
      final t = turn('maya-neighbour', 't2');
      final r = TalkMatcher.judgeSpeech(t, ["yes I'm not"]);
      expect(r.outcome, isNot(TalkSpeechOutcome.accepted));
      final no = TalkMatcher.judgeSpeech(turn('ask-the-way', 't4'), [
        'no thank you',
      ]);
      // "No, thank you" teşekkür sayılır mı? Ek "no" anlamı değiştirir.
      expect(no.outcome, TalkSpeechOutcome.close);
      expect(no.match!.changedWords, contains('no'));
      final late = TalkMatcher.judgeSpeech(turn('cafe-rosa', 't2'), [
        "thank you how much isn't it",
      ]);
      expect(late.accepted, isFalse);
    });

    test('tipik hata (am düştü) kabul edilmez; yakın seçeneğin tepkisi', () {
      final t = turn('maya-neighbour', 't3');
      final r = TalkMatcher.judgeSpeech(t, ['I from Turkey']);
      expect(r.outcome, TalkSpeechOutcome.distractor);
      expect(t.distractors[r.distractorIndex!].reactionTr, contains('am'));
      // Yakın seçenekte olmayan aynı hata: "Neredeyse!" (eksik kelime).
      final izmir = TalkMatcher.judgeSpeech(t, ['I from Izmir']);
      expect(izmir.outcome, TalkSpeechOutcome.close);
      expect(izmir.match!.missingWords, ["I'm"]);
    });

    test('Türkiye ve İzmir motorun yazımıyla eşleşir', () {
      final t = turn('maya-neighbour', 't3');
      expect(TalkMatcher.judgeSpeech(t, ["I'm from Turkey"]).accepted, isTrue);
      expect(TalkMatcher.judgeSpeech(t, ['I am from Izmir']).accepted, isTrue);
      expect(SpeechMatcher.tokenize('İzmir'), ['izmir']);
    });

    test('yakın seçenek: "Yes, I can." → kibar tepki', () {
      final t = turn('maya-neighbour', 't2');
      final r = TalkMatcher.judgeSpeech(t, ['yes I can']);
      expect(r.outcome, TalkSpeechOutcome.distractor);
    });

    test('sessizlik ve alakasız söz', () {
      final t = turn('cafe-rosa', 't3');
      expect(
        TalkMatcher.judgeSpeech(t, const []).outcome,
        TalkSpeechOutcome.silence,
      );
      expect(
        TalkMatcher.judgeSpeech(t, ['  ']).outcome,
        TalkSpeechOutcome.silence,
      );
      expect(
        TalkMatcher.judgeSpeech(t, ['the weather is nice']).outcome,
        TalkSpeechOutcome.no,
      );
    });
  });

  group('dokunarak ya da dizerek', () {
    test('yazım farkı sayılmaz; yakın seçenek kabul değil', () {
      final t = turn('cafe-rosa', 't3');
      expect(TalkMatcher.isAccepted(t, 'here you are'), isTrue);
      expect(TalkMatcher.isAccepted(t, 'Here are you.'), isFalse);
    });

    test('taşlar örnek cevabın kelimeleri, karışık ve kararlı', () {
      final t = turn('ask-the-way', 't1');
      final a = TalkMatcher.tiles(t.model, 1);
      final b = TalkMatcher.tiles(t.model, 1);
      expect(a, b);
      expect([...a]..sort(), [...t.model.split(' ')]..sort());
      expect(a.join(' '), isNot(t.model));
      expect(TalkMatcher.tiles('Thanks!', 3), ['Thanks!']);
    });
  });

  group('ortak örnekler (içerik hattıyla aynı sonuç)', () {
    final vectors = (jsonDecode(fixtureText('talk_check_vectors.json')) as Map)
        .cast<String, dynamic>();
    for (final v in (vectors['checks'] as List).cast<Map>()) {
      test('mesaj kuralı: ${v['text']}', () {
        final check = MessageCheck.fromJson(
          (v['check'] as Map).cast<String, dynamic>(),
        );
        final r = TalkMatcher.checkMessage(v['text'] as String, check)!;
        expect(r.passed, v['expect']);
      });
    }
    for (final v in (vectors['contains'] as List).cast<Map>()) {
      test('hedef ifade: ${v['phrase']} ⊂ ${v['text']}', () {
        expect(
          TalkMatcher.usesPhrase(v['text'] as String, v['phrase'] as String),
          v['expect'],
        );
      });
    }
  });

  group('mesaj', () {
    test('kural yoksa öz değerlendirme (null)', () {
      expect(TalkMatcher.checkMessage('Hello!', null), isNull);
    });

    test('eksik grup ve yasak kelime geri bildirim için döner', () {
      final check = catalog.byId('late-maya')!.check!;
      // Gerekli kalıp geçmediği için olumsuzluk **kapsam dışı**: iki kalıp da
      // eksik olarak söylenir.
      final r = TalkMatcher.checkMessage("I'm not late", check)!;
      expect(r.passed, isFalse);
      expect(r.missing, ['sorry', "I'm late"]);
      expect(r.forbidden, isEmpty);

      // Gerekli kalıbın cümlesindeki olumsuzluk yasak: anlam tersine dönmüş.
      final r2 = TalkMatcher.checkMessage("Sorry, I'm not late.", check)!;
      expect(r2.passed, isFalse);
      expect(r2.missing, ["I'm late"]);
      expect(r2.forbidden, ['not']);
    });

    test('kullanılan hedef ifadeler', () {
      // Tek cümle içinde ara kelime serbest.
      expect(
        TalkMatcher.usedTargets(["Sorry, I'm late."], 'Sorry Maya, I am late.'),
        ["Sorry, I'm late."],
      );
      // Farklı cümlelerden birleştirilmez (17 Ekim 2026 regresyonu).
      expect(
        TalkMatcher.usedTargets([
          "Sorry, I'm late.",
        ], 'Sorry, I am early. Maya is late.'),
        isEmpty,
      );
      expect(
        TalkMatcher.usedTargets(['on Friday', 'at seven'], 'Friday at 7'),
        ['at seven'],
      );
      // Serbest mesaj: kural anlamı doğruladıktan sonra ifadenin parçaları.
      expect(
        TalkMatcher.coveredTargets([
          "Sorry, I'm late.",
        ], 'Sorry, Maya. I am late.'),
        ["Sorry, I'm late."],
      );
      expect(
        TalkMatcher.coveredTargets(["Sorry, I'm late."], 'Sorry, I am early.'),
        isEmpty,
      );
    });
  });

  test('katalog: 3 sahne + mesajlar, sıralı, taslak', () {
    final scenes = catalog.tasks.where((t) => t.isScene).map((t) => t.id);
    expect(scenes, ['maya-neighbour', 'ask-the-way', 'cafe-rosa']);
    expect(catalog.tasks.where((t) => !t.isScene), hasLength(3));
    expect(catalog.tasks.every((t) => t.status == 'DRAFT'), isTrue);
    final cafe = catalog.byId('cafe-rosa')!;
    expect(cafe.unlockAfter, 'A1-009');
    expect(cafe.unlockEpisode, 9);
    expect(cafe.turns[1].line.audio, 'talk/cafe-rosa-t2.m4a');
    expect(cafe.turns.first.line.audio, isNull);
    expect(catalog.byId('hi-intro')!.check, isNull);
  });
}
