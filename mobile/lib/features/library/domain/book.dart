// Kitaplık kitabı (H-067): H-066 paketindeki `book.json` + `pages.json`
// (`docs/KITAPLIK.md` §6.3). Saf Dart.
//
// Zamanlar saniyedir ve cümlenin **bölüm sesinin** (`chapters[].audio`)
// başına görelidir. Hizalama yoksa `start`/`end` null'dur: kitap yalnızca
// sessiz okunur.

import '../../../shared/content/content_source.dart' show grammarTopicsOf;
import '../../../shared/meaning/meaning_text.dart';
import 'book_comprehension.dart';

/// Kitaplık seviyeleri (C2 yalnız Kitaplık'ta; `KITAPLIK.md` §2).
const kBookLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

/// `book.json → genre` kodları.
enum BookGenre {
  mystery('mystery'),
  adventure('adventure'),
  humor('humor'),
  scifiFantasy('scifi-fantasy'),
  everyday('everyday');

  const BookGenre(this.code);

  final String code;

  static BookGenre? parse(Object? v) {
    for (final g in values) {
      if (g.code == v) return g;
    }
    return null;
  }
}

/// Kitabın renkleri (`#RRGGBB` → `0xFFRRGGBB`). Arayüz bunları
/// `BookColors`'a çevirir (okunurluk denetimiyle).
class BookPalette {
  const BookPalette({
    required this.background,
    required this.text,
    required this.accent,
    this.surface,
    this.highlight,
  });

  factory BookPalette.fromJson(Object? json) {
    final m = json is Map ? json : const {};
    return BookPalette(
      background: parseHexColor(m['background']) ?? fallback.background,
      text: parseHexColor(m['text']) ?? fallback.text,
      accent: parseHexColor(m['accent']) ?? fallback.accent,
      surface: parseHexColor(m['surface']),
      highlight: parseHexColor(m['highlight']),
    );
  }

  /// Paleti olmayan kitap: kum zemin, mürekkep yazı, deniz mavisi vurgu.
  static const fallback = BookPalette(
    background: 0xFFF7F1E6,
    text: 0xFF2B2B2B,
    accent: 0xFF1F4E79,
  );

  final int background;
  final int text;
  final int accent;
  final int? surface;
  final int? highlight;
}

/// `#RRGGBB` → `0xFFRRGGBB`; geçersizse null.
int? parseHexColor(Object? v) {
  if (v is! String) return null;
  final m = RegExp(r'^#([0-9a-fA-F]{6})$').firstMatch(v.trim());
  if (m == null) return null;
  return 0xFF000000 | int.parse(m.group(1)!, radix: 16);
}

/// Kitaplık listesindeki kitap (`/books/index.json`).
class BookSummary {
  const BookSummary({
    required this.id,
    required this.title,
    required this.level,
    this.titleTr,
    this.genre,
    this.cover,
    this.estimatedMinutes,
    this.pageCount,
    this.chapterCount,
    this.firstChapterAudio,
    this.grammarTopics = const [],
  });

  factory BookSummary.fromJson(Map<String, dynamic> j) => BookSummary(
    id: j['id'] as String,
    title: (j['title'] as String?) ?? j['id'] as String,
    titleTr: j['titleTr'] as String?,
    level: (j['level'] as String?) ?? levelOf(j['id'] as String),
    genre: BookGenre.parse(j['genre']),
    cover: j['cover'] as String?,
    estimatedMinutes: (j['estimatedMinutes'] as num?)?.round(),
    pageCount: (j['pageCount'] as num?)?.toInt(),
    chapterCount: (j['chapters'] as num?)?.toInt(),
    firstChapterAudio: j['firstChapterAudio'] as bool?,
    grammarTopics: grammarTopicsOf(j['grammarTopics']),
  );

  final String id;
  final String title;
  final String? titleTr;
  final String level;
  final BookGenre? genre;

  /// Paketteki kapak yolu (`images/cover.webp`) ya da null.
  final String? cover;
  final int? estimatedMinutes;
  final int? pageCount;
  final int? chapterCount;

  /// İlk bölümün sesi var mı (`index.json → firstChapterAudio`). Eski
  /// listelerde yoktur (null): sesli sayılır.
  final bool? firstChapterAudio;

  /// "Bana bir kitap oku" sesli açar: ilk bölümünün sesi olan kitap önce.
  bool get startsWithAudio => firstChapterAudio ?? true;

  /// Kitapta geçen dilbilgisi konuları (G-ID; H-077 `grammarTopics`).
  final List<String> grammarTopics;

  /// `A2-K03` → `A2`.
  static String levelOf(String id) => id.split('-').first;
}

class BookWord {
  const BookWord(this.w, {this.start, this.end, this.gloss});

  factory BookWord.fromJson(Map<String, dynamic> j) => BookWord(
    j['w'] as String,
    start: (j['start'] as num?)?.toDouble(),
    end: (j['end'] as num?)?.toDouble(),
    gloss: j['gloss'] as String?,
  );

  /// Metindeki biçimiyle (noktalama dahil: `box."`).
  final String w;
  final double? start;
  final double? end;

  /// Bu cümledeki Türkçe anlamı; özel adda ya da çeviri yoksa null.
  final String? gloss;

  bool get hasTiming => start != null && end != null && end! > start!;

  /// Noktalamasız biçim (`"What` → `What`).
  String get bare => MeaningWord(w).bare;
}

class BookSentence {
  const BookSentence({
    required this.id,
    required this.paragraph,
    required this.text,
    required this.words,
    this.start,
    this.end,
    this.tr,
    this.chunks = const [],
  });

  factory BookSentence.fromJson(Map<String, dynamic> j) => BookSentence(
    id: j['id'] as String,
    paragraph: (j['paragraph'] as num?)?.toInt() ?? 1,
    text: j['text'] as String,
    start: (j['start'] as num?)?.toDouble(),
    end: (j['end'] as num?)?.toDouble(),
    tr: j['tr'] as String?,
    words: [
      for (final w in (j['words'] as List? ?? const []))
        BookWord.fromJson((w as Map).cast<String, dynamic>()),
    ],
    chunks: PhraseChunk.listFromJson(j['chunks']),
  );

  /// `p01-s02`; bölüm başlığında `c1-h`.
  final String id;

  /// Sayfadaki paragraf (1'den); bölüm başlığında 0.
  final int paragraph;
  final String text;
  final double? start;
  final double? end;
  final String? tr;
  final List<BookWord> words;
  final List<PhraseChunk> chunks;

  bool get hasTiming => start != null && end != null && end! >= start!;

  bool get isHeading => paragraph == 0;

  /// Anlam paneli metni (kelime zamanlarıyla; zamanlar bölüm sesine göre).
  MeaningText toMeaning(String bookId) => MeaningText(
    contentId: bookId,
    sourceId: id,
    en: text,
    tr: tr,
    words: [
      for (final w in words)
        MeaningWord(w.w, gloss: w.gloss, start: w.start, end: w.end),
    ],
    chunks: chunks,
  );
}

class BookPage {
  const BookPage({
    required this.id,
    required this.number,
    required this.chapterId,
    required this.sentences,
    this.image,
  });

  factory BookPage.fromJson(Map<String, dynamic> j) => BookPage(
    id: j['id'] as String,
    number: (j['number'] as num).toInt(),
    chapterId: j['chapter'] as String,
    image: j['image'] as String?,
    sentences: [
      for (final s in (j['sentences'] as List? ?? const []))
        BookSentence.fromJson((s as Map).cast<String, dynamic>()),
    ],
  );

  final String id;

  /// Kitap boyunca sayfa numarası (1'den): "s. 4".
  final int number;
  final String chapterId;

  /// `images/p01.webp` ya da resimsiz sayfada null (palet rengiyle çizilir).
  final String? image;
  final List<BookSentence> sentences;

  /// Paragraf sırasıyla cümleler.
  List<List<BookSentence>> get paragraphs {
    final out = <List<BookSentence>>[];
    int? last;
    for (final s in sentences) {
      if (out.isEmpty || s.paragraph != last) out.add([]);
      out.last.add(s);
      last = s.paragraph;
    }
    return out;
  }
}

class BookChapter {
  const BookChapter({
    required this.id,
    required this.title,
    required this.heading,
    required this.pageIds,
    this.titleTr,
    this.audio,
    this.duration,
  });

  final String id;
  final String title;
  final String? titleTr;

  /// `audio/c1.m4a` ya da sesi olmayan bölümde null.
  final String? audio;
  final double? duration;

  /// Seslendirilen bölüm başlığı (sesin ilk cümlesi).
  final BookSentence heading;
  final List<String> pageIds;
}

/// Ses ile metnin eşleştiği sıra: bölüm başlığı + bölümün bütün cümleleri.
class TrackItem {
  const TrackItem(
    this.sentence, {
    required this.pageIndex,
    required this.index,
  });

  final BookSentence sentence;

  /// Kitaptaki sayfa sırası (0'dan).
  final int pageIndex;

  /// Sayfadaki cümle sırası; bölüm başlığında -1.
  final int index;
}

class ChapterTrack {
  ChapterTrack(this.chapter, this.items);

  final BookChapter chapter;
  final List<TrackItem> items;

  /// [t] anında okunan cümle: başlangıcı [t]'den önce olan son cümle (iki
  /// cümle arasındaki boşlukta önceki vurgulu kalır). İlk cümleden önce 0.
  /// Zamanı olmayan cümleler atlanır.
  int indexAt(double t) {
    var lo = 0;
    var hi = items.length - 1;
    var best = 0;
    // Zamanlar sıralıdır (hizalama); zamansızlar için doğrusal yedek.
    if (items.any((i) => i.sentence.start == null)) {
      for (var k = 0; k < items.length; k++) {
        final s = items[k].sentence.start;
        if (s != null && s <= t) best = k;
      }
      return best;
    }
    while (lo <= hi) {
      final mid = (lo + hi) >> 1;
      if (items[mid].sentence.start! <= t) {
        best = mid;
        lo = mid + 1;
      } else {
        hi = mid - 1;
      }
    }
    return best;
  }

  /// Cümlede [t] anında okunan kelime (yoksa null): başlangıcı geçmiş son
  /// kelime, cümle bitmeden.
  static int? wordAt(BookSentence s, double t) {
    if (s.end != null && t > s.end! + 0.05) return null;
    int? best;
    for (var k = 0; k < s.words.length; k++) {
      final st = s.words[k].start;
      if (st != null && st <= t) best = k;
    }
    return best;
  }

  /// Bölüm sesinin sonu (süre yoksa son cümlenin bitişi).
  double get end {
    if (chapter.duration != null) return chapter.duration!;
    for (final i in items.reversed) {
      if (i.sentence.end != null) return i.sentence.end!;
    }
    return 0;
  }
}

/// Bir kitabın tamamı.
class Book {
  Book({
    required this.id,
    required this.title,
    required this.level,
    required this.palette,
    required this.chapters,
    required this.pages,
    this.titleTr,
    this.genre,
    this.blurbTr,
    this.cover,
    this.estimatedMinutes,
    this.contentVersion = 1,
    this.grammarTopics = const [],
    this.comprehension,
  }) {
    for (var i = 0; i < pages.length; i++) {
      _pageIndex[pages[i].id] = i;
    }
  }

  /// [bookJson]: paketteki `book.json`; [pagesJson]: `pages.json`.
  factory Book.fromJson(
    Map<String, dynamic> bookJson,
    Map<String, dynamic> pagesJson,
  ) {
    final meta = <String, Map<String, dynamic>>{
      for (final c in (bookJson['chapters'] as List? ?? const []))
        (c as Map)['id'] as String: c.cast<String, dynamic>(),
    };
    final pages = [
      for (final p in (pagesJson['pages'] as List? ?? const []))
        BookPage.fromJson((p as Map).cast<String, dynamic>()),
    ]..sort((a, b) => a.number.compareTo(b.number));
    final chapters = <BookChapter>[];
    for (final raw in (pagesJson['chapters'] as List? ?? const [])) {
      final c = (raw as Map).cast<String, dynamic>();
      final id = c['id'] as String;
      final m = meta[id] ?? const {};
      chapters.add(
        BookChapter(
          id: id,
          title: (c['title'] as String?) ?? (m['title'] as String?) ?? id,
          titleTr: m['titleTr'] as String?,
          audio: (c['audio'] as String?) ?? (m['audio'] as String?),
          duration: ((c['duration'] as num?) ?? (m['duration'] as num?))
              ?.toDouble(),
          heading: BookSentence.fromJson(
            (c['heading'] as Map).cast<String, dynamic>(),
          ),
          pageIds: [for (final p in (c['pages'] as List? ?? const [])) '$p'],
        ),
      );
    }
    final id = (bookJson['id'] as String?) ?? pagesJson['bookId'] as String;
    return Book(
      id: id,
      title: (bookJson['title'] as String?) ?? id,
      titleTr: bookJson['titleTr'] as String?,
      level:
          (bookJson['level'] as String?) ??
          (pagesJson['level'] as String?) ??
          BookSummary.levelOf(id),
      genre: BookGenre.parse(bookJson['genre']),
      blurbTr: bookJson['blurbTr'] as String?,
      cover: bookJson['cover'] as String?,
      estimatedMinutes: (bookJson['estimatedMinutes'] as num?)?.round(),
      contentVersion: (bookJson['contentVersion'] as num?)?.toInt() ?? 1,
      grammarTopics: grammarTopicsOf(bookJson['grammarTopics']),
      comprehension: BookComprehension.fromJson(bookJson['comprehension']),
      palette: BookPalette.fromJson(bookJson['palette']),
      chapters: chapters,
      pages: pages,
    );
  }

  final String id;
  final String title;
  final String? titleTr;
  final String level;
  final BookGenre? genre;
  final String? blurbTr;
  final String? cover;
  final int? estimatedMinutes;
  final int contentVersion;

  /// Kitapta geçen dilbilgisi konuları (G-ID; H-077).
  final List<String> grammarTopics;

  /// Kitap sonu anlama (H-091); paket eskiyse ya da yoksa null.
  final BookComprehension? comprehension;
  final BookPalette palette;
  final List<BookChapter> chapters;
  final List<BookPage> pages;

  final Map<String, int> _pageIndex = {};
  final Map<String, ChapterTrack> _tracks = {};

  int get pageCount => pages.length;

  int pageIndexOf(String pageId) => _pageIndex[pageId] ?? 0;

  BookChapter chapterOf(BookPage page) => chapters.firstWhere(
    (c) => c.id == page.chapterId,
    orElse: () => chapters.first,
  );

  int chapterIndexOf(String chapterId) {
    final i = chapters.indexWhere((c) => c.id == chapterId);
    return i < 0 ? 0 : i;
  }

  /// Bölümün ilk sayfası mı (başlık bu sayfanın üstünde yazılır)?
  bool isChapterStart(int pageIndex) {
    final p = pages[pageIndex];
    final c = chapterOf(p);
    return c.pageIds.isNotEmpty && c.pageIds.first == p.id;
  }

  /// Bölümün ses sırası (başlık + cümleler).
  ChapterTrack track(String chapterId) => _tracks.putIfAbsent(chapterId, () {
    final c = chapters[chapterIndexOf(chapterId)];
    final items = <TrackItem>[];
    var first = true;
    for (final pid in c.pageIds) {
      final pi = _pageIndex[pid];
      if (pi == null) continue;
      if (first) {
        items.add(TrackItem(c.heading, pageIndex: pi, index: -1));
        first = false;
      }
      final page = pages[pi];
      for (var k = 0; k < page.sentences.length; k++) {
        items.add(TrackItem(page.sentences[k], pageIndex: pi, index: k));
      }
    }
    return ChapterTrack(c, items);
  });

  /// Sesli okunabilir mi: en az bir bölümün sesi ve zamanları var. Ses
  /// bölüm bölüm hazırlanabilir (ör. ücretsiz TTS kotası bitti); sesi
  /// olmayan bölüm sessiz okunur ([chapterCanListen]).
  bool get canListen => chapters.any((c) => chapterCanListen(c.id));

  /// Bu bölüm sesli okunabilir mi: sesi var ve bütün cümlelerinin zamanı var.
  bool chapterCanListen(String chapterId) {
    final c = chapters.where((c) => c.id == chapterId).firstOrNull;
    if (c == null || c.audio == null) return false;
    final items = track(c.id).items;
    return items.isNotEmpty && items.every((i) => i.sentence.hasTiming);
  }

  /// İlk bölümü sesli okunabilir mi ("Bana bir kitap oku" sesli açar).
  bool get firstChapterCanListen =>
      chapters.isNotEmpty && chapterCanListen(chapters.first.id);

  /// Sayfadaki cümle (−1: bölüm başlığı).
  BookSentence sentenceAt(int pageIndex, int index) {
    final p = pages[pageIndex];
    if (index < 0) return chapterOf(p).heading;
    return p.sentences[index.clamp(0, p.sentences.length - 1)];
  }

  /// Sayfanın onaylı Türkçesi, sırasıyla (H-086): (cümle sırası, Türkçe).
  /// Bölümün ilk sayfasında başlık (−1) önce gelir. Türkçesi olmayan cümle
  /// atlanır; liste boşsa sayfanın Türkçesi yoktur.
  List<(int, String)> turkishOf(int pageIndex) {
    final p = pages[pageIndex];
    String? clean(String? tr) {
      final t = tr?.trim();
      return t == null || t.isEmpty ? null : t;
    }

    return [
      if (isChapterStart(pageIndex))
        if (clean(chapterOf(p).heading.tr) case final t?) (-1, t),
      for (final (i, s) in p.sentences.indexed)
        if (clean(s.tr) case final t?) (i, t),
    ];
  }

  /// Sayfa kimliğinden sayfa numarası (`p03-s01` → 3).
  static int? pageNumberOf(String? sentenceId) {
    final m = RegExp(r'^p(\d{2,3})').firstMatch(sentenceId ?? '');
    return m == null ? null : int.parse(m.group(1)!);
  }
}
