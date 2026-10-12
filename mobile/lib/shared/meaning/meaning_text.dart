// Anlam paneli (H-046) için metin modeli: İngilizce cümle, Türkçesi,
// kelime anlamları ve kalıp ifadeler.
//
// Saf Dart. Kaynak: `subs/*.en.json` (zamanlı kelimeler) ya da `scenes.json`
// kart satırı, karar repliği ve görev kökü (zamansız kelimeler).

/// Kalıp ifade: `words` dizisinde [startWord]..[endWord] (ikisi de dahil).
class PhraseChunk {
  const PhraseChunk({
    required this.en,
    required this.tr,
    required this.startWord,
    required this.endWord,
  });

  static PhraseChunk? fromJson(Object? json) {
    if (json is! Map) return null;
    final en = json['en'];
    final tr = json['tr'];
    final s = json['startWord'];
    final e = json['endWord'];
    if (en is! String || tr is! String || s is! int || e is! int || e < s) {
      return null;
    }
    return PhraseChunk(en: en, tr: tr, startWord: s, endWord: e);
  }

  static List<PhraseChunk> listFromJson(Object? json) => [
    if (json is List)
      for (final c in json) ?PhraseChunk.fromJson(c),
  ];

  final String en;
  final String tr;
  final int startWord;
  final int endWord;

  bool contains(int index) => index >= startWord && index <= endWord;

  int get length => endWord - startWord + 1;
}

/// Paneldeki tek kelime. Zamanı varsa ([start], [end]) sesi segmentten kesilir.
class MeaningWord {
  const MeaningWord(this.w, {this.gloss, this.start, this.end});

  final String w;

  /// Bu cümledeki Türkçe anlamı (özel adda ya da çeviri yoksa null).
  final String? gloss;
  final double? start;
  final double? end;

  bool get hasTiming => start != null && end != null && end! > start!;

  /// Görev boşluğu (`___`): dokunulamaz.
  bool get isBlank => RegExp(r'^\W*_{2,}\W*$').hasMatch(w);

  /// Noktalamasız görünüm ("Friday." → "Friday").
  String get bare {
    final s = w.replaceAll('’', "'");
    final m = RegExp(
      r"^[^\p{L}\p{N}]*(.*?)[^\p{L}\p{N}]*$",
      unicode: true,
    ).firstMatch(s);
    final out = m?.group(1) ?? s;
    return out.isEmpty ? s : out;
  }
}

/// Panelde açılan metin. [sourceId], öğrenme olayı ve defter kaydı içindir
/// (ör. `s02-03` ipucu kimliği ya da `c-note#0` kart satırı).
class MeaningText {
  const MeaningText({
    required this.contentId,
    required this.sourceId,
    required this.en,
    required this.words,
    this.tr,
    this.speaker,
    this.chunks = const [],
  });

  /// `scenes.json` zamansız metni: `{tr, words: [{w, gloss}], chunks}`.
  static MeaningText? fromSceneJson({
    required String contentId,
    required String sourceId,
    required String en,
    String? speaker,
    Object? tr,
    Object? words,
    Object? chunks,
  }) {
    final list = <MeaningWord>[
      if (words is List)
        for (final w in words)
          if (w is Map && w['w'] is String)
            MeaningWord(w['w'] as String, gloss: w['gloss'] as String?),
    ];
    if (tr is! String && list.every((w) => w.gloss == null)) return null;
    return MeaningText(
      contentId: contentId,
      sourceId: sourceId,
      en: en,
      speaker: speaker,
      tr: tr is String ? tr : null,
      words: list,
      chunks: PhraseChunk.listFromJson(chunks),
    );
  }

  final String contentId;
  final String sourceId;
  final String en;
  final String? tr;
  final String? speaker;
  final List<MeaningWord> words;
  final List<PhraseChunk> chunks;

  bool get hasTurkish => tr != null && tr!.trim().isNotEmpty;

  /// Kelimeyi içeren en uzun kalıp (yoksa null).
  PhraseChunk? chunkAt(int index) {
    PhraseChunk? best;
    for (final c in chunks) {
      if (c.contains(index) && (best == null || c.length > best.length)) {
        best = c;
      }
    }
    return best;
  }

  /// Görsel gruplama: soldan sağa, birbiriyle çakışmayan kalıplar.
  List<PhraseChunk> get displayChunks {
    final sorted = List.of(chunks)
      ..sort((a, b) {
        final s = a.startWord.compareTo(b.startWord);
        return s != 0 ? s : b.length.compareTo(a.length);
      });
    final out = <PhraseChunk>[];
    var lastEnd = -1;
    for (final c in sorted) {
      if (c.startWord > lastEnd && c.endWord < words.length) {
        out.add(c);
        lastEnd = c.endWord;
      }
    }
    return out;
  }
}
