// Konuş cevaplarının denetimi (H-090). Saf Dart; ağ ve ses yok.
//
// Normalleştirme "Söyle" motoruyla aynıdır ([SpeechMatcher.tokenize]:
// küçük harf, aksan, kısaltmalar, sayılar, sesteşler). İçerik hattı aynı
// kuralları Python'da uygular (`hvpipeline/talk.py`); ortak örnekler
// `test/fixtures/talk_check_vectors.json`.
//
// Kurallar:
// - Söylenen cevap, kabul listesindeki bir cevapla **tam** eşleşmeli. Turda
//   birkaç doğal cevap kabul edildiği için "yakın" (bir kelime duyulmadı)
//   yeterli sayılmaz: "I from Türkiye" gibi tipik hata cevap sayılmasın.
//   Yakın sonuç "Neredeyse!" olur ve eksik kelime söylenir.
// - Anlamı değiştiren ek (olumsuzluk, kip, sayı; H-087) tam eşleşmeyi bozar.
// - Kabul cevabı yoksa ve yakın seçeneklerden (distractor) biri tam
//   duyulursa onun kibar tepkisi gösterilir (K-28: aynı tura dönülür).
// - Mesaj: her gerekli gruptan bir kalıp geçmeli, yasak kelime (anlamı
//   tersine çeviren) **yalnız gerekli kalıbın geçtiği cümlede** olmamalı;
//   kural yoksa öz değerlendirme. Kalıplar tam sözcüklerdir ("late" değil
//   "I'm late"): anahtar kelime bulmak görevin anlamını tamamlamaz.
// - Hedef ifade kullanımı (`usesPhrase`) **bir cümle içinde** aranır; farklı
//   cümlelerden birleştirilen kelimeler kanıt sayılmaz (17 Ekim 2026
//   regresyonu).

import '../../../shared/speech/speech_match.dart';
import 'talk_task.dart';

/// Söylenen cevabın sonucu.
enum TalkSpeechOutcome {
  /// Kabul edilen bir cevap tam söylendi.
  accepted,

  /// Yakın ama kabul edilmeyen seçenek tam söylendi (kibar tepki).
  distractor,

  /// Bir kabul cevabına yakın: eksik ya da anlamı değiştiren kelime var.
  close,

  /// Eşleşme yok.
  no,

  /// Ses duyulmadı.
  silence,
}

class TalkSpeechResult {
  const TalkSpeechResult(
    this.outcome, {
    this.acceptIndex,
    this.distractorIndex,
    this.match,
  });

  final TalkSpeechOutcome outcome;

  /// Tam eşleşen kabul cevabı (accepted).
  final int? acceptIndex;

  /// Tam duyulan yakın seçenek (distractor).
  final int? distractorIndex;

  /// En yakın kabul cevabıyla karşılaştırma (eksik ve anlamı değiştiren
  /// kelimeler geri bildirim için).
  final SpeechMatch? match;

  bool get accepted => outcome == TalkSpeechOutcome.accepted;
}

abstract final class TalkMatcher {
  /// Normalleştirilmiş kelimeler (`…` jokeri atılır).
  static List<String> tokens(String s) => [
    for (final t in SpeechMatcher.tokenize(s))
      if (t != '…' && t.isNotEmpty) t,
  ];

  /// Turda söyleneni değerlendirir. [heard]: tanıma motorunun alternatifleri.
  static TalkSpeechResult judgeSpeech(TalkTurn turn, List<String> heard) {
    final alts = [
      for (final h in heard)
        if (h.trim().isNotEmpty) h,
    ];
    if (alts.isEmpty) {
      return const TalkSpeechResult(TalkSpeechOutcome.silence);
    }
    SpeechMatch? best;
    int? bestIndex;
    for (var i = 0; i < turn.accept.length; i++) {
      final m = SpeechMatcher.compareAny(turn.accept[i], alts);
      if (m.isFull) {
        return TalkSpeechResult(
          TalkSpeechOutcome.accepted,
          acceptIndex: i,
          match: m,
        );
      }
      if (best == null || _rank(m) < _rank(best)) {
        best = m;
        bestIndex = i;
      }
    }
    for (var i = 0; i < turn.distractors.length; i++) {
      if (SpeechMatcher.compareAny(turn.distractors[i].en, alts).isFull) {
        return TalkSpeechResult(
          TalkSpeechOutcome.distractor,
          distractorIndex: i,
        );
      }
    }
    return TalkSpeechResult(
      best?.level == SpeechMatchLevel.close
          ? TalkSpeechOutcome.close
          : TalkSpeechOutcome.no,
      acceptIndex: bestIndex,
      match: best,
    );
  }

  static int _rank(SpeechMatch m) =>
      m.level.index * 1000 +
      m.missingWords.length * 10 +
      m.changedWords.length * 5 +
      m.extraWords.length;

  /// Dokunarak ya da dizerek verilen cevap kabul listesinde mi (yazım farkı
  /// sayılmaz).
  static bool isAccepted(TalkTurn turn, String answer) {
    final a = tokens(answer).join(' ');
    return turn.accept.any((x) => tokens(x).join(' ') == a);
  }

  /// Metni cümlelere böler (`. ! ? ;` ve satır sonu) ve her cümleyi
  /// normalleştirilmiş kelimelere ayırır. Virgül cümle sınırı **değildir**:
  /// "Sorry, Maya. I'm late." → ["sorry maya", "i am late"].
  static List<List<String>> sentences(String text) {
    final out = <List<String>>[];
    for (final part in text.split(RegExp(r'[.!?;\n]+'))) {
      final t = tokens(part);
      if (t.isNotEmpty) out.add(t);
    }
    return out;
  }

  /// [phrase]'in kelimeleri [text]'in **bir cümlesi içinde** aynı sırayla
  /// geçiyor mu (arada başka kelime olabilir; `…` jokeri atılır).
  ///
  /// Cümle sınırı aşılmaz: "Sorry, I am early. Maya is late." → "Sorry, I'm
  /// late." **sayılmaz** (17 Ekim 2026 regresyonu: iki cümleden birleştirilen
  /// kelimeler "kendi kullandı" kanıtı üretmez). Tek cümle içinde ara kelime
  /// serbesttir: "Sorry Maya, I'm late." → "Sorry, I'm late." geçer.
  static bool usesPhrase(String text, String phrase) {
    final want = tokens(phrase);
    if (want.isEmpty) return false;
    for (final toks in sentences(text)) {
      var i = 0;
      for (final w in toks) {
        if (w == want[i] && ++i == want.length) return true;
      }
    }
    return false;
  }

  /// Cevapta kullanılan hedef ifadeler ("kendi kullandı" kanıtı için).
  static List<String> usedTargets(Iterable<String> targets, String text) => [
    for (final t in targets)
      if (usesPhrase(text, t)) t,
  ];

  /// Hedef ifadenin **bütün kelimeleri** metinde geçiyor mu (sıra serbest).
  ///
  /// Yalnız **anlam denetiminden geçen** serbest mesajlarda kullanılır: kural
  /// hedefi zaten doğrular, burada ifadenin parçaları aranır. Böylece
  /// "Sorry, Maya. I'm late." → "Sorry, I'm late." sayılır, ama
  /// "Sorry, I am early. Maya is late." kuraldan geçmediği için **hiçbir**
  /// hedef yazılmaz (17 Ekim 2026 regresyonu).
  static List<String> coveredTargets(Iterable<String> targets, String text) {
    final have = tokens(text).toSet();
    return [
      for (final t in targets)
        if (tokens(t).every(have.contains)) t,
    ];
  }

  static bool _hasPhrase(List<String> toks, String phrase) {
    final p = tokens(phrase);
    if (p.isEmpty || p.length > toks.length) return false;
    outer:
    for (var i = 0; i + p.length <= toks.length; i++) {
      for (var j = 0; j < p.length; j++) {
        if (toks[i + j] != p[j]) continue outer;
      }
      return true;
    }
    return false;
  }

  /// Mesaj kuralı. Kural yoksa null (öz değerlendirme).
  ///
  /// - Her `all` grubundan bir kalıp **mesajda** geçmeli. Kalıplar tam
  ///   sözcüklerdir ("late" değil "I'm late"): anahtar kelime bulmak görevin
  ///   anlamını tamamlamaz (17 Ekim 2026 regresyonu).
  /// - `none` kelimeleri **yalnız gerekli bir kalıbın geçtiği cümlede**
  ///   yasaktır. Ayrı cümledeki olumsuzluk hedefi tersine çevirmez:
  ///   "Sorry, I'm late. I will never do it again." geçer; "Sorry, I'm not
  ///   late." geçmez.
  static MessageCheckResult? checkMessage(String text, MessageCheck? check) {
    if (check == null) return null;
    final sents = sentences(text);
    final all = [for (final s in sents) ...s];
    final missing = [
      for (final g in check.all)
        if (!g.any((alt) => _hasPhrase(all, alt))) g.first,
    ];
    final matched = [
      for (final s in sents)
        if (check.all.any((g) => g.any((alt) => _hasPhrase(s, alt)))) s,
    ];
    final forbidden = [
      for (final n in check.none)
        if (matched.any((s) => _hasPhrase(s, n))) n,
    ];
    return MessageCheckResult(missing: missing, forbidden: forbidden);
  }

  /// "Kelimelerle kur" taşları: örnek cevabın kelimeleri (noktalamasıyla),
  /// [seed]'e göre karışık ama her açılışta aynı sırada.
  static List<String> tiles(String model, int seed) {
    final words = model.split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    final list = [...words];
    if (list.length < 2) return list;
    // Basit, deterministik karıştırma (LCG); asıl sırayla aynı kalırsa döndür.
    var x = seed.abs() + 7;
    for (var i = list.length - 1; i > 0; i--) {
      x = (x * 1103515245 + 12345) & 0x7fffffff;
      final j = x % (i + 1);
      final t = list[i];
      list[i] = list[j];
      list[j] = t;
    }
    if (list.join(' ') == model.trim()) {
      list.add(list.removeAt(0));
    }
    return list;
  }
}

class MessageCheckResult {
  const MessageCheckResult({
    this.missing = const [],
    this.forbidden = const [],
  });

  /// Eksik gruplar (her grubun ilk kalıbı; ipucu için).
  final List<String> missing;

  /// Bulunan yasak kelimeler (anlamı tersine çevirebilir).
  final List<String> forbidden;

  bool get passed => missing.isEmpty && forbidden.isEmpty;
}
