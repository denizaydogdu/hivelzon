// Dilbilgisi dersi (H-078; paket biçimi H-077, `docs/DILBILGISI.md` §9).
//
// Saf Dart. Kaynak: dev içerik sunucusunun `/grammar/index.json` listesi ve
// ders paketindeki `lesson.json` + `cards.json`.

import '../../../shared/meaning/meaning_text.dart';

/// Ders listesindeki bir ders (`/grammar/index.json` → `lessons[]`).
class GrammarLessonSummary {
  const GrammarLessonSummary({
    required this.id,
    required this.level,
    required this.titleTr,
    this.titleEn,
    this.goalTr,
    this.prerequisites = const [],
    this.episodes = const [],
    this.books = const [],
    this.cardCount,
    this.estimatedMinutes,
    this.status,
  });

  factory GrammarLessonSummary.fromJson(Map<String, dynamic> j) {
    final links = j['linksTo'] is Map
        ? (j['linksTo'] as Map).cast<String, dynamic>()
        : const <String, dynamic>{};
    final id = j['id'] as String;
    return GrammarLessonSummary(
      id: id,
      level: (j['level'] as String?) ?? levelOf(id),
      titleTr: (j['titleTr'] as String?) ?? id,
      titleEn: j['titleEn'] as String?,
      goalTr: j['goalTr'] as String?,
      prerequisites: _strings(j['prerequisites']),
      episodes: _strings(links['episodes']),
      books: _strings(links['books']),
      cardCount: (j['cardCount'] as num?)?.toInt(),
      estimatedMinutes: (j['estimatedMinutes'] as num?)?.toDouble(),
      status: j['status'] as String?,
    );
  }

  final String id;
  final String level;
  final String titleTr;
  final String? titleEn;
  final String? goalTr;
  final List<String> prerequisites;

  /// Dersin bağlandığı bölümler ve kitaplar (`linksTo`).
  final List<String> episodes;
  final List<String> books;
  final int? cardCount;

  /// Ses + soru başına 10 sn (paket hesaplar); ses yoksa null.
  final double? estimatedMinutes;
  final String? status;

  /// Ekranda gösterilen süre (dk, en az 1); bilinmiyorsa null.
  int? get minutes {
    final m = estimatedMinutes;
    if (m == null) return null;
    final r = m.round();
    return r < 1 ? 1 : r;
  }

  /// `G-A1-03-third-person-s` → `A1`.
  static String levelOf(String id) {
    final parts = id.split('-');
    return parts.length > 1 ? parts[1] : 'A1';
  }
}

/// CEFR sırası (raf sıralaması).
const kGrammarLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

int levelRank(String level) {
  final i = kGrammarLevels.indexOf(level);
  return i < 0 ? kGrammarLevels.length : i;
}

/// Kelime ve zamanı (sn, parça sesinin başına göre). Ses yoksa zaman da
/// olmayabilir.
class TimedWord {
  const TimedWord(this.w, {this.start, this.end});

  factory TimedWord.fromJson(Map<String, dynamic> j) => TimedWord(
    j['w'] as String,
    start: (j['start'] as num?)?.toDouble(),
    end: (j['end'] as num?)?.toDouble(),
  );

  final String w;
  final double? start;
  final double? end;

  bool get hasTiming => start != null && end != null;
}

/// Türkçe anlatımın bir cümlesi.
class NarrationSentence {
  const NarrationSentence({
    required this.text,
    this.start,
    this.end,
    this.words = const [],
  });

  factory NarrationSentence.fromJson(Map<String, dynamic> j) =>
      NarrationSentence(
        text: j['text'] as String,
        start: (j['start'] as num?)?.toDouble(),
        end: (j['end'] as num?)?.toDouble(),
        words: _words(j['words']),
      );

  final String text;
  final double? start;
  final double? end;
  final List<TimedWord> words;

  /// Ekranda gösterilen kelimeler: zamanlı kelimeler ya da metnin boşlukla
  /// bölünmüşü (ses yoksa).
  List<String> get tokens => words.isNotEmpty
      ? [for (final w in words) w.w]
      : text.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
}

/// Hi'nin Türkçe anlatımı (kart başına bir parça).
class Narration {
  const Narration({
    required this.text,
    this.audio,
    this.duration,
    this.sentences = const [],
  });

  factory Narration.fromJson(Map<String, dynamic> j) {
    final sentences = [
      for (final s in (j['sentences'] as List? ?? const []))
        NarrationSentence.fromJson((s as Map).cast<String, dynamic>()),
    ];
    final text = j['text'] as String;
    return Narration(
      text: text,
      audio: j['audio'] as String?,
      duration: (j['duration'] as num?)?.toDouble(),
      sentences: sentences.isEmpty
          ? [NarrationSentence(text: text)]
          : sentences,
    );
  }

  final String text;

  /// Paketteki ses (`audio/c02-tr.m4a`); bu ortamda yoksa null.
  final String? audio;
  final double? duration;
  final List<NarrationSentence> sentences;

  bool get hasAudio => audio != null;

  /// [t] anında okunan yer: (cümle, kelime). Önceki kelimenin sonundan
  /// sonrakinin başına kadar önceki kelime vurgulu kalır (titremesin).
  (int, int?)? placeAt(double t) {
    (int, int?)? found;
    for (var si = 0; si < sentences.length; si++) {
      final s = sentences[si];
      final start = s.start ?? s.words.firstOrNull?.start;
      if (start == null || t < start) break;
      int? word;
      for (var wi = 0; wi < s.words.length; wi++) {
        final ws = s.words[wi].start;
        if (ws == null || t < ws) break;
        word = wi;
      }
      found = (si, word);
    }
    return found;
  }
}

/// İngilizce örnek (Sarah'nın sesi) ya da kural kartının örneği.
class GrammarExample {
  const GrammarExample({
    required this.id,
    required this.en,
    this.tr,
    this.targets = const [],
    this.audio,
    this.duration,
    this.start,
    this.end,
    this.words = const [],
  });

  factory GrammarExample.fromJson(Map<String, dynamic> j) => GrammarExample(
    id: j['id'] as String,
    en: j['en'] as String,
    tr: j['tr'] as String?,
    targets: [
      for (final t in (j['targets'] as List? ?? const []))
        if (t is Map && t['start'] is num && t['end'] is num)
          ((t['start'] as num).toInt(), (t['end'] as num).toInt()),
    ],
    audio: j['audio'] as String?,
    duration: (j['duration'] as num?)?.toDouble(),
    start: (j['start'] as num?)?.toDouble(),
    end: (j['end'] as num?)?.toDouble(),
    words: _words(j['words']),
  );

  final String id;
  final String en;
  final String? tr;

  /// Hedef yapının karakter aralıkları (`[[goes]]` → (3, 7)).
  final List<(int, int)> targets;
  final String? audio;
  final double? duration;

  /// Sesteki konuşma aralığı.
  final double? start;
  final double? end;
  final List<TimedWord> words;

  bool get hasAudio => audio != null;

  /// Ekrandaki kelimeler ve hedef olup olmadıkları (metindeki konumdan).
  List<ExampleToken> get tokens {
    final out = <ExampleToken>[];
    for (final m in RegExp(r'\S+').allMatches(en)) {
      final target = targets.any((t) => m.start < t.$2 && m.end > t.$1);
      out.add(ExampleToken(m.group(0)!, target: target));
    }
    return out;
  }

  /// [t] anında okunan kelime (zamanlı kelime sırası ekrandakiyle aynı).
  int? wordAt(double t) {
    int? found;
    for (var i = 0; i < words.length; i++) {
      final s = words[i].start;
      if (s == null || t < s) break;
      found = i;
    }
    return found;
  }

  /// Anlam paneli metni: kelimelerin Türkçesi yok, cümlenin Türkçesi var.
  MeaningText toMeaning(String lessonId) => MeaningText(
    contentId: lessonId,
    sourceId: id,
    en: en,
    tr: tr,
    words: [
      for (final (i, t) in tokens.indexed)
        MeaningWord(
          t.text,
          start: i < words.length ? words[i].start : null,
          end: i < words.length ? words[i].end : null,
        ),
    ],
  );
}

class ExampleToken {
  const ExampleToken(this.text, {this.target = false});

  final String text;
  final bool target;
}

/// "Türkçede nasıl?" kartındaki yanlış biçim (sessiz; utandırmaz).
class WrongForm {
  const WrongForm({required this.id, required this.en, this.tr});

  factory WrongForm.fromJson(Map<String, dynamic> j) => WrongForm(
    id: j['id'] as String,
    en: j['en'] as String,
    tr: j['tr'] as String?,
  );

  final String id;
  final String en;

  /// Kısa Türkçe açıklama ("Ek eksik.").
  final String? tr;
}

/// Kodla çizilen şema (görsel kredisi yok).
sealed class GrammarDiagram {
  const GrammarDiagram();

  static GrammarDiagram? fromJson(Object? json) {
    if (json is! Map) return null;
    final j = json.cast<String, dynamic>();
    List<Map<String, dynamic>> items(String key) => [
      for (final x in (j[key] as List? ?? const []))
        if (x is Map) x.cast<String, dynamic>(),
    ];
    return switch (j['kind']) {
      'timeline' => TimelineDiagram([
        for (final p in items('points'))
          TimelinePoint(
            TimelineAt.parse(p['at'] as String?),
            (p['text'] as String?) ?? '',
          ),
      ]),
      'boxes' => BoxesDiagram([
        for (final b in items('boxes'))
          DiagramBox((b['text'] as String?) ?? '', b['caption'] as String?),
      ], arrows: j['arrows'] != false),
      'suffix' => SuffixDiagram([
        for (final w in items('words'))
          SuffixWord(
            (w['base'] as String?) ?? '',
            (w['suffix'] as String?) ?? '',
          ),
      ]),
      _ => null,
    };
  }
}

enum TimelineAt {
  past,
  now,
  future;

  static TimelineAt parse(String? v) =>
      values.firstWhere((a) => a.name == v, orElse: () => now);
}

class TimelinePoint {
  const TimelinePoint(this.at, this.text);

  final TimelineAt at;
  final String text;
}

class TimelineDiagram extends GrammarDiagram {
  const TimelineDiagram(this.points);

  final List<TimelinePoint> points;
}

class DiagramBox {
  const DiagramBox(this.text, this.caption);

  final String text;
  final String? caption;
}

class BoxesDiagram extends GrammarDiagram {
  const BoxesDiagram(this.boxes, {this.arrows = true});

  final List<DiagramBox> boxes;
  final bool arrows;
}

class SuffixWord {
  const SuffixWord(this.base, this.suffix);

  final String base;
  final String suffix;

  String get word => '$base$suffix';
}

class SuffixDiagram extends GrammarDiagram {
  const SuffixDiagram(this.words);

  final List<SuffixWord> words;
}

enum PracticeKind {
  choose,
  fill,
  order,
  say;

  static PracticeKind? parse(Object? v) =>
      values.where((k) => k.name == v).firstOrNull;
}

/// Alıştırma sorusu (puan, süre, can yok; K-32).
class PracticeItem {
  const PracticeItem({
    required this.id,
    required this.kind,
    this.stem,
    this.options = const [],
    this.answers = const [],
    this.tokens = const [],
    this.answer,
    this.text,
    this.tr,
    this.audio,
    this.words = const [],
    this.feedbackTr,
  });

  static PracticeItem? fromJson(Object? json) {
    if (json is! Map) return null;
    final j = json.cast<String, dynamic>();
    final kind = PracticeKind.parse(j['kind']);
    if (kind == null) return null;
    return PracticeItem(
      id: j['id'] as String,
      kind: kind,
      stem: j['stem'] as String?,
      options: [
        for (final o in (j['options'] as List? ?? const []))
          if (o is Map && o['text'] is String)
            PracticeOption(o['text'] as String, correct: o['correct'] == true),
      ],
      answers: _strings(j['answers']),
      tokens: _strings(j['tokens']),
      answer: j['answer'] as String?,
      text: j['text'] as String?,
      tr: j['tr'] as String?,
      audio: j['audio'] as String?,
      words: _words(j['words']),
      feedbackTr: j['feedbackTr'] as String?,
    );
  }

  final String id;
  final PracticeKind kind;

  /// Seç ve boşluk doldur: `She ___ to school.`
  final String? stem;
  final List<PracticeOption> options;

  /// Boşluk doldur: kabul edilen cevaplar.
  final List<String> answers;

  /// Sırala: karışık parçalar ve doğru cümle.
  final List<String> tokens;
  final String? answer;

  /// Söyle: cümle, Türkçesi ve sesi.
  final String? text;
  final String? tr;
  final String? audio;
  final List<TimedWord> words;

  /// Yanlış cevapta kısa Türkçe açıklama.
  final String? feedbackTr;

  /// Cevap doğru mu? Seçimde seçeneğin sırası; boşlukta yazılan; sıralamada
  /// seçilen parçalar sırasıyla boşlukla birleştirilmiş metin.
  bool check(String input) => switch (kind) {
    PracticeKind.choose => options.any(
      (o) => o.correct && normalizeAnswer(o.text) == normalizeAnswer(input),
    ),
    PracticeKind.fill => answers.any(
      (a) => normalizeAnswer(a) == normalizeAnswer(input),
    ),
    PracticeKind.order =>
      answer != null && normalizeAnswer(answer!) == normalizeAnswer(input),
    PracticeKind.say => true,
  };

  /// Seçimde doğru seçenek (açıklama için).
  String? get correctOption =>
      options.where((o) => o.correct).firstOrNull?.text;

  /// Çözülmüş cümle: boşluk doldurulmuş kök ya da sıralı cümle.
  String? get solved => switch (kind) {
    PracticeKind.choose => _fillStem(correctOption),
    PracticeKind.fill => _fillStem(answers.firstOrNull),
    PracticeKind.order => answer,
    PracticeKind.say => text,
  };

  String? _fillStem(String? word) {
    final s = stem;
    if (s == null || word == null) return null;
    // "(play)" gibi ipucu çözümde görünmez.
    return s
        .replaceFirst('___', word)
        .replaceAll(RegExp(r'\s*\([^)]*\)\s*'), ' ')
        .replaceAll(RegExp(r'\s+([.,!?])'), r'$1')
        .trim();
  }
}

class PracticeOption {
  const PracticeOption(this.text, {this.correct = false});

  final String text;
  final bool correct;
}

/// Cevap karşılaştırması: büyük/küçük harf, tipografik kesme, noktalama ve
/// fazla boşluk önemsiz.
String normalizeAnswer(String s) => s
    .toLowerCase()
    .replaceAll('’', "'")
    .replaceAll(RegExp(r"[^\p{L}\p{N}'\s]", unicode: true), ' ')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();

enum StoryLinkKind { episode, book }

/// "Hikâyede gör": yapının geçtiği gerçek bölüm ya da kitap cümlesi.
class GrammarStoryLink {
  const GrammarStoryLink({
    required this.kind,
    required this.contentId,
    required this.text,
    this.node,
    this.cueId,
    this.cueText,
    this.chapter,
    this.page,
    this.sentenceId,
  });

  static GrammarStoryLink? fromJson(Object? json) {
    if (json is! Map) return null;
    final j = json.cast<String, dynamic>();
    final text = j['text'] as String?;
    if (text == null) return null;
    return switch (j['kind']) {
      'episode' when j['episodeId'] is String => GrammarStoryLink(
        kind: StoryLinkKind.episode,
        contentId: j['episodeId'] as String,
        text: text,
        node: j['node'] as String?,
        cueId: j['cueId'] as String?,
        cueText: j['cueText'] as String?,
      ),
      'book' when j['bookId'] is String => GrammarStoryLink(
        kind: StoryLinkKind.book,
        contentId: j['bookId'] as String,
        text: text,
        chapter: j['chapter'] as String?,
        page: j['page'] as String?,
        sentenceId: j['sentenceId'] as String?,
      ),
      _ => null,
    };
  }

  final StoryLinkKind kind;

  /// Bölüm (`A1-001`) ya da kitap (`A1-K01`) kimliği.
  final String contentId;

  /// Yapının geçtiği cümle (birebir).
  final String text;

  /// Bölümde sahne düğümü ve altyazı satırı (varsa).
  final String? node;
  final String? cueId;

  /// Altyazı satırının tamamı (cümleden uzun olabilir).
  final String? cueText;

  /// Kitapta bölüm, sayfa (`p03`) ve cümle (`p03-s02`).
  final String? chapter;
  final String? page;
  final String? sentenceId;
}

enum GrammarCardType {
  hook,
  explain,
  examples,
  contrast,
  practice,
  seeInStory,
  rule;

  static GrammarCardType parse(Object? v) =>
      values.firstWhere((t) => t.name == v, orElse: () => explain);
}

class GrammarCard {
  const GrammarCard({
    required this.id,
    required this.type,
    this.title,
    this.narration,
    this.examples = const [],
    this.wrong = const [],
    this.diagrams = const [],
    this.practice = const [],
    this.links = const [],
  });

  factory GrammarCard.fromJson(Map<String, dynamic> j) {
    List<Map<String, dynamic>> maps(String key) => [
      for (final x in (j[key] as List? ?? const []))
        if (x is Map) x.cast<String, dynamic>(),
    ];
    return GrammarCard(
      id: j['id'] as String,
      type: GrammarCardType.parse(j['type']),
      title: j['title'] as String?,
      narration: j['narration'] is Map
          ? Narration.fromJson((j['narration'] as Map).cast<String, dynamic>())
          : null,
      examples: [for (final e in maps('examples')) GrammarExample.fromJson(e)],
      wrong: [for (final w in maps('wrong')) WrongForm.fromJson(w)],
      diagrams: [for (final d in maps('diagrams')) ?GrammarDiagram.fromJson(d)],
      practice: [for (final p in maps('practice')) ?PracticeItem.fromJson(p)],
      links: [for (final l in maps('links')) ?GrammarStoryLink.fromJson(l)],
    );
  }

  final String id;
  final GrammarCardType type;
  final String? title;
  final Narration? narration;
  final List<GrammarExample> examples;
  final List<WrongForm> wrong;
  final List<GrammarDiagram> diagrams;
  final List<PracticeItem> practice;
  final List<GrammarStoryLink> links;
}

/// Ders paketi: `lesson.json` (meta) + `cards.json` (kartlar).
class GrammarLesson {
  const GrammarLesson({
    required this.id,
    required this.level,
    required this.titleTr,
    required this.cards,
    this.titleEn,
    this.goalTr,
    this.contentVersion = 1,
    this.estimatedMinutes,
  });

  factory GrammarLesson.fromJson(
    Map<String, dynamic> lessonJson,
    Map<String, dynamic> cardsJson,
  ) {
    final id = (lessonJson['id'] as String?) ?? cardsJson['lessonId'] as String;
    return GrammarLesson(
      id: id,
      level:
          (lessonJson['level'] as String?) ??
          (cardsJson['level'] as String?) ??
          GrammarLessonSummary.levelOf(id),
      titleTr: (lessonJson['titleTr'] as String?) ?? id,
      titleEn: lessonJson['titleEn'] as String?,
      goalTr: lessonJson['goalTr'] as String?,
      contentVersion: (lessonJson['contentVersion'] as num?)?.toInt() ?? 1,
      estimatedMinutes: (lessonJson['estimatedMinutes'] as num?)?.toDouble(),
      cards: [
        for (final c in (cardsJson['cards'] as List? ?? const []))
          GrammarCard.fromJson((c as Map).cast<String, dynamic>()),
      ],
    );
  }

  final String id;
  final String level;
  final String titleTr;
  final String? titleEn;
  final String? goalTr;
  final int contentVersion;
  final double? estimatedMinutes;
  final List<GrammarCard> cards;

  int indexOfCard(String? cardId) {
    final i = cards.indexWhere((c) => c.id == cardId);
    return i < 0 ? 0 : i;
  }

  /// Kural kartı (son kart; yoksa null).
  GrammarCard? get ruleCard =>
      cards.where((c) => c.type == GrammarCardType.rule).lastOrNull;
}

List<String> _strings(Object? v) => [
  if (v is List)
    for (final x in v)
      if (x is String) x,
];

List<TimedWord> _words(Object? v) => [
  if (v is List)
    for (final w in v)
      if (w is Map && w['w'] is String)
        TimedWord.fromJson(w.cast<String, dynamic>()),
];
