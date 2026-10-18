// Regresyon: ürün incelemesi 2026-10-17, [P1] bulgu.
//
// "Eksik olumsuzluk ters anlamlı cevabı bağımsız hatırlama sayıyor."
// Duyulmayan olumsuzluk/modal/sayı "yakın" sayılıp Hard notu (ve taklitte
// başarı) üretiyordu. Anlamı ters çeviren cevap başarı sayılmamalıdır.
//
// Bu testler **doğru davranışı** bekler; düzeltmeden önce başarısız olur
// (bkz. aynı adımın raporu). Beklenen sonuç, mevcut hatalı davranışa göre
// değil ürün kararına göre yazılmıştır (H-089: hatırlamada anlam değiştiyse
// doğru sayılmaz).
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/notebook/domain/review_policy.dart';
import 'package:hivelzon/shared/fsrs/fsrs.dart';
import 'package:hivelzon/shared/speech/speech_match.dart';

SpeechMatch _cmp(String expected, String heard) =>
    SpeechMatcher.compare(expected, heard);

/// Olgun kart: "Söyle" (hatırlama) görevi.
const _stage = CardStage(reps: 5, state: FsrsState.review, lapses: 5);

/// Üretimdeki çağrı ile aynı: `review_screen._answerSpeech` eşleştirme
/// sonucunun `level` ve `changedWords` alanlarını politikaya verir.
FsrsRating _rating(SpeechMatch m) => ReviewPolicy.rateSpeech(
  level: m.level,
  elapsed: const Duration(seconds: 3),
  stage: _stage,
  attempts: 1,
  changedWords: m.changedWords,
);

void main() {
  group('düşen olumsuzluk anlamı değiştirir (regresyon 2026-10-17)', () {
    test('"I can\'t hear you." ← "I can hear you."', () {
      final m = _cmp("I can't hear you.", 'I can hear you');
      expect(m.missingWords, isNotEmpty, reason: 'olumsuzluk duyulmadı');
      expect(m.changedWords, contains('not'), reason: 'anlamı değiştiren kayıp');
      expect(m.imitationSucceeded, isFalse, reason: 'taklit başarı sayılmaz');
      expect(_rating(m), FsrsRating.again, reason: 'bağımsız hatırlama değil');
    });

    test('"I am not late." ← "I am late."', () {
      final m = _cmp('I am not late.', 'I am late');
      expect(m.changedWords, contains('not'));
      expect(m.imitationSucceeded, isFalse);
      expect(_rating(m), FsrsRating.again);
    });

    test('"I can\'t help you." ← "I can help you." (modal + olumsuzluk)', () {
      final m = _cmp("I can't help you.", 'I can help you');
      expect(m.changedWords, contains('not'));
      expect(_rating(m), FsrsRating.again);
    });
  });

  group('ters yön (fazla olumsuzluk) bozulmadan kalır', () {
    test('"I can help you." ← "I can not help you."', () {
      final m = _cmp('I can help you.', 'I can not help you');
      expect(m.level, SpeechMatchLevel.close);
      expect(m.missingWords, isEmpty);
      expect(m.changedWords, ['not']);
      expect(_rating(m), FsrsRating.again);
    });

    test('"I agree." ← "I do not agree."', () {
      final m = _cmp('I agree.', 'I do not agree');
      expect(m.changedWords, contains('not'));
      expect(_rating(m), FsrsRating.again);
    });
  });

  group('düşen modal ve miktar (miktar sesteşleri hariç)', () {
    test('"I can swim." ← "I swim."', () {
      final m = _cmp('I can swim.', 'I swim');
      expect(m.changedWords, contains('can'));
      expect(_rating(m), FsrsRating.again);
    });

    test('"It\'s seven o\'clock." ← "It\'s o\'clock."', () {
      final m = _cmp("It's seven o'clock.", "It's o'clock");
      expect(m.changedWords, contains('seven'));
      expect(_rating(m), FsrsRating.again);
    });
  });

  group('aşırıya kaçmaz: anlamı koruyan eksikler Hard kalır', () {
    test('"Where is the station?" ← "where is station" (yalnız "the" düştü)', () {
      final m = _cmp('Where is the station?', 'where is station');
      expect(m.level, SpeechMatchLevel.close);
      expect(m.changedWords, isEmpty);
      expect(m.imitationSucceeded, isTrue, reason: 'anlam korunmuş');
      expect(_rating(m), FsrsRating.hard, reason: 'yarım puan, başarı değil');
    });

    test('"Can you hear me?" ← "can you me" (yalnız "hear" düştü)', () {
      final m = _cmp('Can you hear me?', 'can you me');
      expect(m.level, SpeechMatchLevel.close);
      expect(m.changedWords, isEmpty);
      expect(_rating(m), FsrsRating.hard);
    });

    test('"Nice to meet you." ← "nice meet you" (sesteş "to" cezalanmaz)', () {
      final m = _cmp('Nice to meet you.', 'nice meet you');
      expect(m.changedWords, isEmpty);
      expect(_rating(m), FsrsRating.hard);
    });
  });
}
