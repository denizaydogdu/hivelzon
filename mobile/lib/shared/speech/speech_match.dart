// "Söyle" karşılaştırma motoru (H-055). Saf Dart; ağ ve ses yok.
//
// Cihazdaki tanıma motorunun yazısı ([transcript]) beklenen ifadeyle kelime
// düzeyinde karşılaştırılır. Telaffuz ölçülmez (motor yanlış telaffuzu da
// doğru kelimeye "düzeltir"; `docs/KONUSMA-ALISTIRMASI.md`). Puan üretilmez:
// sonuç yalnızca üç düzeydir (tam / yakın / değil) ve duyulmayan kelimeler.
//
// Kurallar:
// - normalleştirme iki tarafa da aynı uygulanır: küçük harf, tipografik
//   kesme ve tırnak, noktalama, aksan (café → cafe), küçük sayılar (7 ↔
//   seven), kısaltmalar (I'm = I am, don't = do not, can't = cannot = can not),
//   birkaç İngiliz/Amerikan yazımı (harbour = harbor) ve sesteş kelimeler
//   (hear = here: motor ikisini ayıramaz);
// - dolgu sesleri ("uh", "um", baştaki "okay") yalnızca yazıdan atılır
//   (beklenen ifadede geçiyorsa atılmaz);
// - `…` joker sayılır: "Where is…?" için "Where is the station?" tam kabul;
// - hizalama: kelimeler üzerinde Levenshtein (sıra önemlidir).

import 'dart:math' as math;

/// Karşılaştırma sonucu düzeyi (puan yok).
enum SpeechMatchLevel {
  /// Beklenen bütün kelimeler duyuldu.
  full('full'),

  /// En az 3 kelimelik ifadede tek kelime duyulmadı.
  close('close'),

  /// Diğer durumlar (ya da hiç ses yok).
  no('no');

  const SpeechMatchLevel(this.code);

  final String code;

  static SpeechMatchLevel parse(String? v) =>
      values.firstWhere((l) => l.code == v, orElse: () => no);
}

class SpeechMatch {
  const SpeechMatch({
    required this.level,
    this.missingWords = const [],
    this.extraWords = const [],
  });

  static const nothing = SpeechMatch(level: SpeechMatchLevel.no);

  final SpeechMatchLevel level;

  /// Beklenen ama duyulmayan kelimeler (normalleştirilmiş, ifadedeki sırayla).
  final List<String> missingWords;

  /// Duyulan ama beklenmeyen kelimeler (dolgu sesleri hariç).
  final List<String> extraWords;

  bool get isFull => level == SpeechMatchLevel.full;
}

/// Seçenekler arasından söylenen (karar anı). [index] null ise belirsiz ya
/// da eşleşme yok: kullanıcıdan dokunarak seçmesi istenir.
class OptionPick {
  const OptionPick({this.index, this.ambiguous = false});

  final int? index;

  /// İki seçenek birbirine çok yakın puan aldı.
  final bool ambiguous;

  bool get picked => index != null;
}

abstract final class SpeechMatcher {
  /// "Yakın" için ifadenin en az kelime sayısı.
  static const int closeMinWords = 3;

  /// Karar anında kabul için en düşük benzerlik ve ikinciyle en az fark.
  static const double optionMinSimilarity = 0.5;
  static const double optionMinMargin = 0.15;

  static const Set<String> fillers = {
    'uh',
    'um',
    'umm',
    'uhm',
    'er',
    'erm',
    'ah',
    'hmm',
    'mm',
    'mhm',
  };

  /// Yalnızca baştaysa atılan sözcükler.
  static const Set<String> leadingFillers = {'okay', 'ok', 'so', 'well'};

  // ------------------------------------------------------------ normalleştirme

  /// Kelimelere ayrılmış, normalleştirilmiş metin. `…` korunur (joker).
  static List<String> tokenize(String s) => [for (final t in _tokens(s)) t.$1];

  /// (normalleştirilmiş kelime, ekranda gösterilecek asıl kelime).
  static List<(String, String)> _tokens(String s) {
    var t = s
        .replaceAll(RegExp('[’‘`´]'), "'")
        .replaceAll(RegExp('[“”„«»]'), ' ')
        .replaceAll('...', '…');
    // Saat: 7:30 → 7 30, 7:00 → 7.
    t = t.replaceAllMapped(
      RegExp(r'\b(\d{1,2}):(\d{2})\b'),
      (m) => m.group(2) == '00' ? m.group(1)! : '${m.group(1)} ${m.group(2)}',
    );
    t = t
        .replaceAll(RegExp(r"[^\p{L}\p{N}'…\s]", unicode: true), ' ')
        .replaceAll('…', ' … ');
    final out = <(String, String)>[];
    for (final raw in t.split(RegExp(r'\s+'))) {
      if (raw.isEmpty) continue;
      final w = raw.replaceAll(RegExp(r"^'+|'+$"), '');
      if (w.isEmpty) continue;
      for (final e in _expand(_foldDiacritics(w.toLowerCase()))) {
        for (final n in _number(e)) {
          out.add((_canonical(n), w));
        }
      }
    }
    return out;
  }

  static List<String> _expand(String w) {
    final fixed = _contractions[w];
    if (fixed != null) return fixed;
    if (w.endsWith("n't")) {
      return [w.substring(0, w.length - 3), 'not'];
    }
    for (final (suffix, full) in const [
      ("'re", 'are'),
      ("'ve", 'have'),
      ("'ll", 'will'),
      ("'d", 'would'),
      ("'m", 'am'),
    ]) {
      if (w.endsWith(suffix) && w.length > suffix.length) {
        return [w.substring(0, w.length - suffix.length), full];
      }
    }
    if (w.endsWith("'s")) {
      final base = w.substring(0, w.length - 2);
      if (_isBeforeS.contains(base)) return [base, 'is'];
    }
    // Kalan kesme işaretleri (o'clock, Alex's) iki tarafta aynı biçimde atılır.
    return [w.replaceAll("'", '')];
  }

  static const Map<String, List<String>> _contractions = {
    "can't": ['can', 'not'],
    'cannot': ['can', 'not'],
    "won't": ['will', 'not'],
    "shan't": ['shall', 'not'],
    "let's": ['let', 'us'],
    "i'm": ['i', 'am'],
    'gonna': ['going', 'to'],
    'wanna': ['want', 'to'],
  };

  /// `'s` = `is` sayılan sözcükler (iyelik değil).
  static const Set<String> _isBeforeS = {
    'it',
    'he',
    'she',
    'that',
    'this',
    'there',
    'here',
    'what',
    'where',
    'who',
    'how',
    'when',
    'why',
  };

  static List<String> _number(String w) {
    final n = int.tryParse(w);
    if (n == null || n < 0 || n > 999) return [w];
    return numberWords(n);
  }

  static const _ones = [
    'zero',
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine',
    'ten',
    'eleven',
    'twelve',
    'thirteen',
    'fourteen',
    'fifteen',
    'sixteen',
    'seventeen',
    'eighteen',
    'nineteen',
  ];
  static const _tens = [
    '',
    '',
    'twenty',
    'thirty',
    'forty',
    'fifty',
    'sixty',
    'seventy',
    'eighty',
    'ninety',
  ];

  /// 0–999 → İngilizce kelimeler ("twenty five", "one hundred").
  static List<String> numberWords(int n) {
    if (n < 20) return [_ones[n]];
    if (n < 100) {
      return [_tens[n ~/ 10], if (n % 10 != 0) _ones[n % 10]];
    }
    return [
      _ones[n ~/ 100],
      'hundred',
      if (n % 100 != 0) ...numberWords(n % 100),
    ];
  }

  /// Sesteşler ve yazım çeşitleri tek biçime iner (iki tarafa da uygulanır).
  static String _canonical(String w) => _canon[w] ?? w;

  static const Map<String, String> _canon = {
    // Motor sesteşleri ayıramaz.
    'here': 'hear',
    'to': 'two',
    'too': 'two',
    'for': 'four',
    'write': 'right',
    'their': 'there',
    'know': 'no',
    'won': 'one',
    'sea': 'see',
    'bye': 'by',
    'buy': 'by',
    'ate': 'eight',
    'knew': 'new',
    'high': 'hi',
    'hey': 'hi',
    'meat': 'meet',
    'son': 'sun',
    'our': 'hour',
    'eye': 'i',
    'whether': 'weather',
    'okay': 'ok',
    'yeah': 'yes',
    'yep': 'yes',
    // İngiliz / Amerikan yazımı.
    'harbor': 'harbour',
    'neighbor': 'neighbour',
    'neighbors': 'neighbours',
    'color': 'colour',
    'favorite': 'favourite',
    'center': 'centre',
    'theater': 'theatre',
    'gray': 'grey',
    'mom': 'mum',
  };

  static String _foldDiacritics(String s) {
    const from = 'àáâãäåçèéêëìíîïñòóôõöùúûüýÿışğ';
    const to = 'aaaaaaceeeeiiiinooooouuuuyyisg';
    final b = StringBuffer();
    for (final ch in s.split('')) {
      final i = from.indexOf(ch);
      b.write(i < 0 ? ch : to[i]);
    }
    return b.toString();
  }

  // ------------------------------------------------------------ karşılaştırma

  /// Beklenen ifade ile yazıyı karşılaştırır. [transcripts]: motorun
  /// alternatifleri (en iyisi başta); en iyi sonuç döner.
  static SpeechMatch compareAny(String expected, List<String> transcripts) {
    SpeechMatch? best;
    for (final t in transcripts) {
      final m = compare(expected, t);
      if (best == null || _rank(m) < _rank(best)) best = m;
    }
    return best ?? SpeechMatch.nothing;
  }

  static int _rank(SpeechMatch m) =>
      m.level.index * 1000 + m.missingWords.length * 10 + m.extraWords.length;

  static SpeechMatch compare(String expected, String transcript) {
    final exp = _tokens(expected);
    final wildcard = exp.any((t) => t.$1 == '…');
    final wantT = [
      for (final t in exp)
        if (t.$1 != '…') t,
    ];
    final want = [for (final t in wantT) t.$1];
    final heard = _dropFillers(tokenize(transcript), want.toSet());
    if (want.isEmpty || heard.isEmpty) {
      return SpeechMatch(
        level: SpeechMatchLevel.no,
        missingWords: _surfaces(wantT, {
          for (var i = 0; i < want.length; i++) i,
        }),
      );
    }
    final a = _align(want, heard);
    // Joker varsa fazla kelime beklenir (ör. "Where is…?" + yer adı).
    final extra = wildcard ? const <String>[] : a.extra;
    final missing = _surfaces(wantT, a.missingAt.toSet());
    final level = a.missing.isEmpty
        ? SpeechMatchLevel.full
        : (a.missing.length == 1 && want.length >= closeMinWords)
        ? SpeechMatchLevel.close
        : SpeechMatchLevel.no;
    return SpeechMatch(level: level, missingWords: missing, extraWords: extra);
  }

  /// Duyulmayan kelimelerin asıl yazımı; kısaltmanın iki parçası tek kez
  /// ("it's"), "I" büyük harfle.
  static List<String> _surfaces(List<(String, String)> want, Set<int> at) {
    final out = <String>[];
    String? prev;
    int? prevIndex;
    for (var i = 0; i < want.length; i++) {
      if (!at.contains(i)) continue;
      var w = want[i].$2;
      if (w.toLowerCase() == 'i') w = 'I';
      final sameWord =
          prev == w && prevIndex == i - 1 && want[i - 1].$2 == want[i].$2;
      if (!sameWord) out.add(w);
      prev = w;
      prevIndex = i;
    }
    return out;
  }

  static List<String> _dropFillers(List<String> heard, Set<String> wanted) {
    final out = [
      for (final w in heard)
        if (!fillers.contains(w) || wanted.contains(w)) w,
    ];
    while (out.isNotEmpty &&
        (leadingFillers.contains(out.first) || out.first == 'ok') &&
        !wanted.contains(out.first)) {
      out.removeAt(0);
    }
    return out;
  }

  /// Kelime düzeyinde hizalama: duyulmayan ve fazla kelimeler.
  static ({
    List<String> missing,
    List<String> extra,
    List<(String, String)> swaps,
    List<int> missingAt,
    int distance,
  })
  _align(List<String> want, List<String> heard) {
    final n = want.length;
    final m = heard.length;
    final d = List.generate(n + 1, (_) => List<int>.filled(m + 1, 0));
    for (var i = 0; i <= n; i++) {
      d[i][0] = i;
    }
    for (var j = 0; j <= m; j++) {
      d[0][j] = j;
    }
    for (var i = 1; i <= n; i++) {
      for (var j = 1; j <= m; j++) {
        final cost = want[i - 1] == heard[j - 1] ? 0 : 1;
        d[i][j] = math.min(
          math.min(d[i - 1][j] + 1, d[i][j - 1] + 1),
          d[i - 1][j - 1] + cost,
        );
      }
    }
    final missing = <String>[];
    final extra = <String>[];
    final swaps = <(String, String)>[];
    final missingAt = <int>[];
    var i = n;
    var j = m;
    while (i > 0 || j > 0) {
      if (i > 0 &&
          j > 0 &&
          want[i - 1] == heard[j - 1] &&
          d[i][j] == d[i - 1][j - 1]) {
        i--;
        j--;
      } else if (i > 0 && j > 0 && d[i][j] == d[i - 1][j - 1] + 1) {
        missing.add(want[i - 1]);
        missingAt.add(i - 1);
        extra.add(heard[j - 1]);
        swaps.add((want[i - 1], heard[j - 1]));
        i--;
        j--;
      } else if (i > 0 && d[i][j] == d[i - 1][j] + 1) {
        missing.add(want[i - 1]);
        missingAt.add(i - 1);
        i--;
      } else {
        extra.add(heard[j - 1]);
        j--;
      }
    }
    return (
      missing: missing.reversed.toList(),
      extra: extra.reversed.toList(),
      swaps: swaps.reversed.toList(),
      missingAt: missingAt.reversed.toList(),
      distance: d[n][m],
    );
  }

  /// İki kelime dizisinin benzerliği: 1 − (düzenleme uzaklığı / uzun olan).
  static double similarity(List<String> a, List<String> b) {
    if (a.isEmpty && b.isEmpty) return 1;
    final r = _align(a, b);
    return 1 - r.distance / math.max(a.length, b.length);
  }

  /// Karar anı: yazı hangi seçeneğe en yakın? Eşik altı ya da iki seçenek
  /// birbirine çok yakınsa seçilmez (kullanıcı dokunarak seçer).
  static OptionPick bestOption(List<String> transcripts, List<String> options) {
    if (options.isEmpty) return const OptionPick();
    var bestScore = -1.0;
    var bestIndex = -1;
    var secondScore = -1.0;
    final opts = [
      for (final o in options)
        [
          for (final w in tokenize(o))
            if (w != '…') w,
        ],
    ];
    final scores = List<double>.filled(options.length, 0);
    for (final t in transcripts) {
      final heard = _dropFillers(tokenize(t), {for (final o in opts) ...o});
      if (heard.isEmpty) continue;
      for (var i = 0; i < opts.length; i++) {
        scores[i] = math.max(scores[i], similarity(opts[i], heard));
      }
    }
    for (var i = 0; i < scores.length; i++) {
      final s = scores[i];
      if (s > bestScore) {
        secondScore = bestScore;
        bestScore = s;
        bestIndex = i;
      } else if (s > secondScore) {
        secondScore = s;
      }
    }
    if (bestIndex < 0 || bestScore < optionMinSimilarity) {
      return const OptionPick();
    }
    if (secondScore >= 0 && bestScore - secondScore < optionMinMargin - 1e-9) {
      return const OptionPick(ambiguous: true);
    }
    return OptionPick(index: bestIndex);
  }

  // ------------------------------------------------------------ Türk öğrencinin tipik hataları

  /// Yazıda tanınabilen tipik hata → hata kataloğu kimliği
  /// (`icerik/_evren/hata-katalogu.json`). Tam eşleşmede ve bulunamazsa null.
  static String? detectErrorNote(String expected, List<String> transcripts) {
    for (final t in transcripts) {
      final id = _detect(expected, t);
      if (id != null) return id;
    }
    return null;
  }

  static const Set<String> _be = {'am', 'is', 'are'};
  static const Set<String> _articles = {'a', 'an', 'the'};
  static const Set<String> _wh = {'where', 'what', 'when', 'who', 'how', 'why'};

  static String? _detect(String expected, String transcript) {
    final want = [
      for (final w in tokenize(expected))
        if (w != '…') w,
    ];
    final heard = _dropFillers(tokenize(transcript), want.toSet());
    if (want.isEmpty || heard.isEmpty) return null;
    final a = _align(want, heard);
    if (a.missing.isEmpty && a.extra.isEmpty) return null;
    final heardText = ' ${heard.join(' ')} ';
    // "I am agree" (am fazladan).
    if (heardText.contains(' i am agree ')) return 'agree-no-be';
    // "Can you…? — Yes, I am." (can yerine am).
    if (want.contains('can') &&
        a.missing.contains('can') &&
        (a.extra.contains('am') || a.extra.contains('is'))) {
      return 'can-short-answer';
    }
    // Saat/günde "in": "It's in seven o'clock".
    if (a.extra.contains('in') && !want.contains('in')) {
      final hasTime =
          want.contains('oclock') ||
          want.any((w) => _days.contains(w)) ||
          want.contains('at') ||
          want.contains('on');
      if (hasTime) return 'time-preposition';
    }
    // Soru sözcüğü yer değiştirdi (aynı kelimeler, başka sıra).
    if (_wh.contains(want.first) &&
        heard.first != want.first &&
        heard.contains(want.first)) {
      return 'question-word-order';
    }
    // am / is / are düştü.
    if (a.missing.any(_be.contains) && !a.extra.any(_be.contains)) {
      return 'be-dropped';
    }
    // a / an / the düştü.
    if (a.missing.any(_articles.contains) && !a.extra.any(_articles.contains)) {
      return 'articles';
    }
    // He/She/It + fiil -s düştü (loves → love, has → have).
    for (final (w, h) in a.swaps) {
      if ((w == 'has' && h == 'have') ||
          (w.length > 2 &&
              w.endsWith('s') &&
              w.substring(0, w.length - 1) == h) ||
          (w.endsWith('es') && w.substring(0, w.length - 2) == h)) {
        return 'third-person-s';
      }
    }
    return null;
  }

  static const Set<String> _days = {
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  };
}
