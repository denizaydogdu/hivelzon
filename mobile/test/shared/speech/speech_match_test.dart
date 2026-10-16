import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/shared/speech/speech_match.dart';

SpeechMatch cmp(String expected, String heard) =>
    SpeechMatcher.compare(expected, heard);

void main() {
  group('tokenize (normalleştirme)', () {
    test('büyük/küçük harf, noktalama ve tipografik kesme', () {
      expect(SpeechMatcher.tokenize('Yes, I CAN.'), ['yes', 'i', 'can']);
      expect(SpeechMatcher.tokenize('It’s “seven”!'), ['it', 'is', 'seven']);
    });

    test('kısaltmalar açılır', () {
      expect(SpeechMatcher.tokenize("I'm Alex"), ['i', 'am', 'alex']);
      expect(SpeechMatcher.tokenize("don't"), ['do', 'not']);
      expect(SpeechMatcher.tokenize("can't"), ['can', 'not']);
      expect(SpeechMatcher.tokenize('cannot'), ['can', 'not']);
      expect(SpeechMatcher.tokenize("what's"), ['what', 'is']);
      expect(SpeechMatcher.tokenize("they're"), ['they', 'are']);
      expect(SpeechMatcher.tokenize("I'll"), ['i', 'will']);
      expect(SpeechMatcher.tokenize("let's go"), ['let', 'us', 'go']);
    });

    test('iyelik ekli ad iki tarafta aynı kalır', () {
      expect(SpeechMatcher.tokenize("Alex's radio"), ['alexs', 'radio']);
    });

    test('sayılar kelimeye çevrilir; saat biçimi', () {
      expect(SpeechMatcher.tokenize('7'), ['seven']);
      expect(SpeechMatcher.tokenize('13'), ['thirteen']);
      expect(SpeechMatcher.tokenize('25'), ['twenty', 'five']);
      expect(SpeechMatcher.tokenize('7:00'), ['seven']);
      expect(SpeechMatcher.tokenize('7:30'), ['seven', 'thirty']);
      expect(SpeechMatcher.tokenize('100'), ['one', 'hundred']);
    });

    test('aksanlar katlanır', () {
      expect(SpeechMatcher.tokenize('Café'), ['cafe']);
    });

    test('… joker olarak korunur', () {
      expect(SpeechMatcher.tokenize('Where is…?'), ['where', 'is', '…']);
      expect(SpeechMatcher.tokenize('Where is...?'), ['where', 'is', '…']);
    });
  });

  group('compare', () {
    test('birebir aynı → tam', () {
      final m = cmp('Yes, I can.', 'yes I can');
      expect(m.level, SpeechMatchLevel.full);
      expect(m.missingWords, isEmpty);
    });

    test('kısaltma iki yönde eşleşir', () {
      expect(cmp("I'm Alex.", 'I am Alex').level, SpeechMatchLevel.full);
      expect(cmp('I am Alex.', "I'm Alex").level, SpeechMatchLevel.full);
      expect(
        cmp("It's seven o'clock.", 'it is seven o clock').level,
        isNot(SpeechMatchLevel.full),
        reason: '"o clock" iki kelime; "oclock" ile aynı değil',
      );
      expect(
        cmp("It's seven o'clock.", "It's 7 o'clock").level,
        SpeechMatchLevel.full,
      );
      expect(
        cmp("I can't hear you.", 'I cannot hear you').level,
        SpeechMatchLevel.full,
      );
    });

    test('dolgu sesleri ve baştaki "okay" sayılmaz', () {
      final m = cmp('Yes, I can.', 'uh yes um I can');
      expect(m.level, SpeechMatchLevel.full);
      expect(m.extraWords, isEmpty);
      expect(
        cmp('Again, please.', 'okay again please').level,
        SpeechMatchLevel.full,
      );
    });

    test('beklenen ifadede "okay" varsa atılmaz', () {
      expect(cmp('Okay, thanks.', 'okay thanks').level, SpeechMatchLevel.full);
      expect(cmp('Okay, thanks.', 'thanks').level, SpeechMatchLevel.no);
    });

    test('sesteşler: motor "hear"/"here" ayıramaz', () {
      expect(
        cmp('Can you hear me?', 'can you here me').level,
        SpeechMatchLevel.full,
      );
    });

    test('İngiliz/Amerikan yazımı', () {
      expect(
        cmp(
          'Excuse me, where is the harbour?',
          'excuse me where is the harbor',
        ).level,
        SpeechMatchLevel.full,
      );
    });

    test('3+ kelimede tek eksik → yakın; eksik kelime söylenir', () {
      final m = cmp('Can you hear me?', 'can you me');
      expect(m.level, SpeechMatchLevel.close);
      expect(m.missingWords, ['hear']);
    });

    test('kısa ifadede eksik → değil', () {
      final m = cmp('Again, please.', 'again');
      expect(m.level, SpeechMatchLevel.no);
      expect(m.missingWords, ['please']);
    });

    test('iki eksik → değil', () {
      final m = cmp('Excuse me, where is the station?', 'where station');
      expect(m.level, SpeechMatchLevel.no);
      expect(m.missingWords, ['Excuse', 'me', 'is', 'the']);
    });

    test('yer değiştiren kelime (yerine başka kelime) eksik + fazla', () {
      final m = cmp('Yes, I can.', 'yes I am');
      expect(m.level, SpeechMatchLevel.close);
      expect(m.missingWords, ['can']);
      expect(m.extraWords, ['am']);
    });

    test('duyulmayan kelime asıl yazımıyla gösterilir', () {
      expect(cmp('Nice to meet you.', 'nice meet you').missingWords, ['to']);
      expect(cmp("It's seven o'clock.", "seven o'clock").missingWords, [
        "It's",
      ]);
      expect(cmp('Yes, I can.', 'yes can').missingWords, ['I']);
    });

    test('fazla kelime tamı bozmaz ama raporlanır', () {
      final m = cmp('Yes, I can.', 'yes I can Mrs Brooks');
      expect(m.level, SpeechMatchLevel.full);
      expect(m.extraWords, ['mrs', 'brooks']);
    });

    test('joker: "Where is…?" + yer adı → tam, fazla sayılmaz', () {
      final m = cmp('Where is…?', 'Where is the old station?');
      expect(m.level, SpeechMatchLevel.full);
      expect(m.extraWords, isEmpty);
    });

    test('boş yazı → değil', () {
      expect(cmp('Yes, I can.', '').level, SpeechMatchLevel.no);
      expect(cmp('Yes, I can.', 'um uh').level, SpeechMatchLevel.no);
    });

    test('sıra önemlidir', () {
      final m = cmp('Where is the station?', 'the station where is');
      expect(m.level, isNot(SpeechMatchLevel.full));
    });

    test('alternatiflerden en iyisi seçilir', () {
      final m = SpeechMatcher.compareAny('Can you hear me?', [
        'can you here me',
        'can you me',
      ]);
      expect(m.level, SpeechMatchLevel.full);
      final n = SpeechMatcher.compareAny('Can you hear me?', [
        'can you',
        'can you me',
      ]);
      expect(n.level, SpeechMatchLevel.close);
    });
  });

  group('anlamı değiştiren fazla kelime (H-087)', () {
    test('olumsuzluk eklenirse tam değil, yakın; kelime söylenir', () {
      final a = cmp('I can help you.', 'I can not help you');
      expect(a.level, SpeechMatchLevel.close);
      expect(a.missingWords, isEmpty);
      expect(a.changedWords, ['not']);
      final b = cmp('I agree.', 'I do not agree');
      expect(b.level, SpeechMatchLevel.close);
      expect(b.changedWords, ['not']);
    });

    test('kısaltmalı olumsuzluk da yakalanır', () {
      for (final (exp, heard) in const [
        ('I can help you.', "I can't help you"),
        ('I can help you.', 'I cannot help you'),
        ('I agree.', "I don't agree"),
        ('She likes tea.', "She doesn't likes tea"),
        ('I saw it.', "I didn't saw it"),
        ('I will go.', "I won't go"),
        ('It is here.', "It isn't here"),
        ('They are ready.', "They aren't ready"),
        ('I was there.', "I wasn't there"),
        ('You should go.', "You shouldn't go"),
        ('I have a map.', "I haven't a map"),
      ]) {
        final m = cmp(exp, heard);
        expect(m.level, SpeechMatchLevel.close, reason: '$exp ← $heard');
        expect(m.changedWords, contains('not'), reason: '$exp ← $heard');
      }
    });

    test('never / no eklenirse tam değil', () {
      expect(
        cmp('I drink coffee.', 'I never drink coffee').level,
        SpeechMatchLevel.close,
      );
      expect(
        cmp('I have time.', 'I have no time').level,
        SpeechMatchLevel.close,
      );
    });

    test('modal değişimi tam değil', () {
      expect(
        cmp('I can help you.', 'I must help you').level,
        isNot(SpeechMatchLevel.full),
      );
      expect(
        cmp('I can help you.', 'I could help you').level,
        isNot(SpeechMatchLevel.full),
      );
      final m = cmp('I help you.', 'I can help you');
      expect(m.level, SpeechMatchLevel.close);
      expect(m.changedWords, ['can']);
      expect(cmp('I go.', "I'll go").level, SpeechMatchLevel.close);
    });

    test('sayı farklı ya da eklenmiş → tam değil', () {
      expect(
        cmp("It's thirteen.", "It's fourteen").level,
        isNot(SpeechMatchLevel.full),
      );
      expect(
        cmp("It's thirteen.", "It's 30").level,
        isNot(SpeechMatchLevel.full),
      );
      final m = cmp('I have cats.', 'I have 3 cats');
      expect(m.level, SpeechMatchLevel.close);
      expect(m.changedWords, ['three']);
      expect(
        cmp('I have cats.', 'I have twenty cats').level,
        SpeechMatchLevel.close,
      );
    });

    test('soru yapısı: başa do/does/did eklenirse tam değil', () {
      expect(
        cmp('You like tea.', 'do you like tea').level,
        SpeechMatchLevel.close,
      );
      expect(
        cmp('You can swim.', 'can you swim').level,
        isNot(SpeechMatchLevel.full),
      );
      // Vurgulu "do" cümle içinde: anlam aynı → tam.
      expect(cmp('I agree.', 'I do agree').level, SpeechMatchLevel.full);
    });

    test('kelime sırası değişirse tam değil', () {
      expect(
        cmp('The cat is black.', 'black is the cat').level,
        isNot(SpeechMatchLevel.full),
      );
    });

    test('doğal, anlamı korumayan ekler tam kalır', () {
      for (final (exp, heard) in const [
        ('I agree.', 'I agree Maya'),
        ('I agree.', 'yes I agree'),
        ('Again, please.', 'again please please'),
        ('I agree.', 'okay I agree'),
        ('I agree.', 'well I agree'),
        ('I agree.', 'so I agree'),
        ('Yes, I can.', 'yes I can Mrs Brooks'),
        ('I agree.', 'um I agree'),
        ('Thank you.', 'thank you very much'),
        ('I want to go.', 'I want to go too'),
      ]) {
        final m = cmp(exp, heard);
        expect(m.level, SpeechMatchLevel.full, reason: '$exp ← $heard');
        expect(m.changedWords, isEmpty, reason: '$exp ← $heard');
      }
    });

    test('ifadede zaten olan olumsuzluk sorun değil', () {
      expect(
        cmp("I don't know.", 'I do not know').level,
        SpeechMatchLevel.full,
      );
      expect(cmp('No, thanks.', 'no thanks').level, SpeechMatchLevel.full);
      expect(
        cmp("I can't hear you.", "I can't hear you").level,
        SpeechMatchLevel.full,
      );
    });

    test('joker: yer adı serbest, olumsuzluk yine geçmez', () {
      expect(
        cmp('Where is…?', 'Where is the old station').level,
        SpeechMatchLevel.full,
      );
      expect(
        cmp("I'd like…", 'I would like three apples').level,
        SpeechMatchLevel.full,
      );
      final m = cmp('Where is…?', "Where isn't the station");
      expect(m.level, SpeechMatchLevel.close);
      expect(m.changedWords, ['not']);
      expect(
        cmp('I like…', "I don't like the harbour").level,
        SpeechMatchLevel.close,
      );
    });

    test('alternatiflerden anlamı koruyan seçilir', () {
      final m = SpeechMatcher.compareAny('I can help you.', [
        "I can't help you",
        'I can help you',
      ]);
      expect(m.level, SpeechMatchLevel.full);
    });
  });

  group('bestOption (karar anı)', () {
    test('doğru seçenek', () {
      final p = SpeechMatcher.bestOption(
        ['yes I can hear you'],
        ['Yes, I can hear you.', 'Yes, I am.'],
      );
      expect(p.index, 0);
    });

    test('yanlış seçenek söylenirse o seçilir (dokunmakla aynı)', () {
      final p = SpeechMatcher.bestOption(
        ['yes I am'],
        ['Yes, I can hear you.', 'Yes, I am.'],
      );
      expect(p.index, 1);
    });

    test('alt küme seçenek (Where station?) uzun cümleyi kazanmaz', () {
      final p = SpeechMatcher.bestOption(
        ['excuse me where is the old station'],
        ['Excuse me, where is the old station?', 'Where station?'],
      );
      expect(p.index, 0);
      final q = SpeechMatcher.bestOption(
        ['where station'],
        ['Excuse me, where is the old station?', 'Where station?'],
      );
      expect(q.index, 1);
    });

    test('tek "in" farkı yeterli fark', () {
      const opts = ["It's seven o'clock.", "It's in seven o'clock."];
      expect(SpeechMatcher.bestOption(["it's 7 o'clock"], opts).index, 0);
      expect(
        SpeechMatcher.bestOption(["it's in seven o'clock"], opts).index,
        1,
      );
    });

    test('tek kelimelik yakın seçenekler (Friday / Free / Fried)', () {
      const opts = ['Friday.', 'Free.', 'Fried.'];
      expect(SpeechMatcher.bestOption(['Friday'], opts).index, 0);
      expect(SpeechMatcher.bestOption(['free'], opts).index, 1);
    });

    test('alakasız konuşma → seçilmez', () {
      final p = SpeechMatcher.bestOption(
        ['banana tree'],
        ['Again, please.', 'What?'],
      );
      expect(p.picked, isFalse);
      expect(p.ambiguous, isFalse);
    });

    test('iki seçeneğe eşit yakın → belirsiz, seçilmez', () {
      final p = SpeechMatcher.bestOption(
        ['yes I can hear'],
        ['Yes, I can.', 'Yes, I can hear you.'],
      );
      expect(p.picked, isFalse);
      expect(p.ambiguous, isTrue);
    });

    test('boş yazı → seçilmez', () {
      expect(
        SpeechMatcher.bestOption([''], ['Again, please.', 'What?']).picked,
        isFalse,
      );
    });
  });

  group('detectErrorNote (hata kataloğu)', () {
    test('can sorusuna "Yes, I am"', () {
      expect(
        SpeechMatcher.detectErrorNote('Yes, I can.', ['yes I am']),
        'can-short-answer',
      );
    });

    test('be düştü', () {
      expect(
        SpeechMatcher.detectErrorNote('Where is the station?', [
          'where the station',
        ]),
        'be-dropped',
      );
    });

    test('I am agree', () {
      expect(
        SpeechMatcher.detectErrorNote('I agree.', ['I am agree']),
        'agree-no-be',
      );
    });

    test('saatte "in"', () {
      expect(
        SpeechMatcher.detectErrorNote("It's seven o'clock.", [
          "it's in seven o'clock",
        ]),
        'time-preposition',
      );
    });

    test('soru sözcüğü sonda', () {
      expect(
        SpeechMatcher.detectErrorNote('Where is the harbour?', [
          'the harbour where is',
        ]),
        'question-word-order',
      );
    });

    test('artikel düştü', () {
      expect(
        SpeechMatcher.detectErrorNote('This is a note.', ['this is note']),
        'articles',
      );
    });

    test('üçüncü tekil -s', () {
      expect(
        SpeechMatcher.detectErrorNote('He loves radios.', ['he love radios']),
        'third-person-s',
      );
      expect(
        SpeechMatcher.detectErrorNote('She has History.', ['she have history']),
        'third-person-s',
      );
    });

    test('tam eşleşmede ya da tanınmayan farkta not yok', () {
      expect(
        SpeechMatcher.detectErrorNote('Yes, I can.', ['yes I can']),
        isNull,
      );
      expect(
        SpeechMatcher.detectErrorNote('Again, please.', ['again']),
        isNull,
      );
    });
  });
}
