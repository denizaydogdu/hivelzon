import 'dart:convert';

import 'package:hivelzon/features/discover/domain/clip.dart';
import 'package:hivelzon/features/grammar/domain/grammar_lesson.dart';
import 'package:hivelzon/features/hi/domain/hi_content.dart';
import 'package:hivelzon/features/library/domain/book.dart';
import 'package:hivelzon/features/player/domain/episode.dart';
import 'package:hivelzon/features/player/domain/subtitles.dart';
import 'package:hivelzon/features/topic_sets/domain/topic_set.dart';
import 'package:hivelzon/shared/content/content_source.dart';

import 'fixtures.dart';

/// Fixture JSON'larından okuyan kaynak; medya adresleri sahte.
class FakeContentSource implements ContentSource {
  FakeContentSource({
    this.fail = false,
    this.seasonFails = false,
    this.packageIds = const ['A1-001', 'A1-002'],
    this.withCatalogue = true,
    this.mapImage,
    this.realSubtitles = false,
    this.withTopicSets = true,
    this.withHi = true,
  });

  /// Sezon paketinde `hi.json` olsun mu (H-048; gerçek dışa aktarım kopyası).
  bool withHi;
  int hiLoads = 0;

  @override
  Future<HiContent> loadHiContent(int season) async {
    hiLoads++;
    if (fail || !withHi) throw ContentUnavailableException('hi.json yok');
    return loadHiFixture();
  }

  /// Sezon paketinde konu setleri olsun mu (H-051; gerçek paket kopyaları).
  bool withTopicSets;
  int topicSetLoads = 0;

  /// `true`: altyazı `test/fixtures/subs/<id>/<dosya>`'dan okunur (yoksa hata);
  /// `false`: her segment için B1 s02 altyazısı (oynatıcı testleri).
  bool realSubtitles;

  bool fail;

  /// Sunucuda paketi olan bölümler (fixture'lar: A1-001…A1-004).
  List<String> packageIds;

  /// Sezon paketinde 12 bölümlük harita kataloğu olsun mu (H-035).
  bool withCatalogue;
  String? mapImage;

  /// Sezon paketi yoksa Hikâye sekmesi sezon başlığını gizler.
  bool seasonFails;
  int listCalls = 0;

  @override
  Future<List<PackageSummary>> listPackages() async {
    listCalls++;
    if (fail) throw ContentUnavailableException('kapalı');
    return [
      for (final id in packageIds)
        PackageSummary(
          id: id,
          title: loadFixture(id).info.title,
          level: 'A1',
          season: 1,
          number: int.parse(id.substring(3)),
          estimatedMinutes: 6,
          grammarTopics: grammarTopics[id] ?? const [],
        ),
    ];
  }

  /// Bölüm ve kitapların `grammarTopics` alanı (H-078): içerik kimliği →
  /// G-ID listesi.
  Map<String, List<String>> grammarTopics = const {};

  @override
  Future<Episode> loadEpisode(String contentId) async {
    if (fail) throw ContentUnavailableException('kapalı');
    return loadFixture(contentId);
  }

  @override
  Future<SubtitleTrack> loadSubtitles(String contentId, String path) async {
    if (realSubtitles) {
      final name = path.split('/').last;
      return SubtitleTrack.fromJson(
        jsonDecode(fixtureText('subs/$contentId/$name')),
      );
    }
    return SubtitleTrack.fromJson(
      jsonDecode(fixtureText('A1-001.s02.en.json')),
    );
  }

  @override
  Uri mediaUri(String contentId, String path) =>
      Uri.parse('http://test.invalid/$contentId/$path');

  @override
  Future<SeasonInfo> loadSeason(int season) async {
    if (fail || seasonFails) throw ContentUnavailableException('kapalı');
    return SeasonInfo(
      season: season,
      title: 'The Missing Signal',
      introVideo: 'jenerik-tam.mp4',
      introDuration: 10.3,
      titleBackground: 'jenerik-baslik.mp4',
      titlePoster: 'jenerik-baslik.webp',
      mapImage: mapImage,
      mapWidth: mapImage == null ? null : 1520,
      mapHeight: mapImage == null ? null : 2688,
      episodes: withCatalogue ? catalogue(packageIds) : const [],
      topicSets: withTopicSets ? topicSetSummaries() : const [],
      clipsPath: withClips ? 'clips.json' : null,
    );
  }

  /// Keşfet klipleri (H-040): sezon paketinde `clips.json` olsun mu.
  /// Varsayılan kapalı (eski testler klip görmez). [clipCatalog] verilirse
  /// o döner; yoksa gerçek dışa aktarımın kopyası (`fixtures/clips.json`).
  bool withClips = false;
  bool clipsFail = false;
  ClipCatalog? clipCatalog;
  int clipLoads = 0;

  @override
  Future<ClipCatalog> loadClips(int season, String path) async {
    clipLoads++;
    if (fail || clipsFail) throw ContentUnavailableException('kapalı');
    return clipCatalog ?? loadClipFixture();
  }

  @override
  Future<TopicSet> loadTopicSet(int season, String path) async {
    topicSetLoads++;
    if (fail) throw ContentUnavailableException('kapalı');
    return loadTopicSetFixture(path.split('/').last.replaceAll('.json', ''));
  }

  @override
  Uri seasonMediaUri(int season, String path) =>
      Uri.parse('http://test.invalid/_season/S$season/$path');

  /// Kitaplık (H-067): sunucudaki kitaplar. Varsayılan boş (eski testler
  /// kitaplığı görmez); [testBookSummaries] ile doldurulur.
  List<BookSummary> books = const [];
  bool booksFail = false;
  int bookListCalls = 0;

  @override
  Future<List<BookSummary>> listBooks() async {
    bookListCalls++;
    if (fail || booksFail) throw ContentUnavailableException('kapalı');
    return books;
  }

  /// Her kimlik için deneme kitabı A1-K99'un kopyası (kimlik, başlık ve
  /// seviye değişir).
  @override
  Future<Book> loadBook(String bookId) async {
    if (fail || booksFail) throw ContentUnavailableException('kapalı');
    return loadTestBook(
      id: bookId,
      unnarrated: unnarratedChapters,
      withoutTurkish: withoutTurkish,
      grammarTopics: grammarTopics[bookId] ?? const [],
    );
  }

  /// Sesi henüz hazır olmayan bölümler (kitap bölüm bölüm seslendirilir).
  Set<String> unnarratedChapters = const {};

  /// Türkçesi (`tr`) olmayan cümleler ve başlıklar (kimlikle; H-086).
  Set<String> withoutTurkish = const {};

  @override
  Uri bookMediaUri(String bookId, String path) =>
      Uri.parse('http://test.invalid/books/$bookId/$path');

  /// Dilbilgisi dersleri (H-078). Varsayılan boş (eski testler dersleri
  /// görmez); [testLessonSummaries] ile doldurulur.
  List<GrammarLessonSummary> lessons = const [];
  bool grammarFails = false;
  int grammarIndexCalls = 0;

  /// Sesi olmayan ders (sessiz okuma) ya da yalnız İngilizce sesi olmayan.
  bool lessonsSilent = false;
  bool lessonsNoEnglishAudio = false;

  /// "Hikâyede gör" bölüm bağının hedefi (deneme dersinde `A1-901`).
  String? lessonEpisodeLink;

  @override
  Future<List<GrammarLessonSummary>> loadGrammarIndex() async {
    grammarIndexCalls++;
    if (fail || grammarFails) throw ContentUnavailableException('kapalı');
    return lessons;
  }

  /// Her kimlik için deneme dersi G-A1-99'un kopyası (kimlik, başlık ve
  /// seviye değişir).
  @override
  Future<GrammarLesson> loadLesson(String lessonId) async {
    if (fail || grammarFails) throw ContentUnavailableException('kapalı');
    final s = lessons.where((l) => l.id == lessonId).firstOrNull;
    return loadTestLesson(
      id: lessonId,
      title: s?.titleTr,
      level: s?.level,
      silent: lessonsSilent,
      noEnglishAudio: lessonsNoEnglishAudio,
      episodeLink: lessonEpisodeLink,
    );
  }

  @override
  Uri grammarMediaUri(String lessonId, String path) =>
      Uri.parse('http://test.invalid/grammar/$lessonId/$path');
}

/// Sezon 1 klipleri (H-040 dışa aktarımının kopyası: 17 klip, B1–B4).
ClipCatalog loadClipFixture() => ClipCatalog.fromJson(
  (jsonDecode(fixtureText('clips.json')) as Map).cast<String, dynamic>(),
);

/// Deneme dersi (H-077 `G-A1-99-third-person-s` dışa aktarımı; sahte ses
/// süreleriyle). [silent]: hiç ses yok; [noEnglishAudio]: yalnız Türkçe
/// anlatımın sesi var.
GrammarLesson loadTestLesson({
  String id = kTestLessonId,
  String? title,
  String? level,
  bool silent = false,
  bool noEnglishAudio = false,
  String? episodeLink,
}) {
  final lesson =
      (jsonDecode(fixtureText('grammar/$kTestLessonId/lesson.json')) as Map)
          .cast<String, dynamic>();
  final cards =
      (jsonDecode(fixtureText('grammar/$kTestLessonId/cards.json')) as Map)
          .cast<String, dynamic>();
  lesson['id'] = id;
  if (title != null) lesson['titleTr'] = title;
  if (level != null) lesson['level'] = level;
  for (final c in cards['cards'] as List) {
    final card = c as Map;
    if (episodeLink != null) {
      for (final l in card['links'] as List) {
        if ((l as Map)['kind'] == 'episode') l['episodeId'] = episodeLink;
      }
    }
    if (silent && card['narration'] is Map) {
      (card['narration'] as Map)['audio'] = null;
    }
    if (silent || noEnglishAudio) {
      for (final e in [
        ...card['examples'] as List,
        ...card['practice'] as List,
      ]) {
        if ((e as Map).containsKey('audio')) e['audio'] = null;
      }
    }
  }
  return GrammarLesson.fromJson(lesson, cards);
}

const kTestLessonId = 'G-A1-99-third-person-s';

/// Ders listesi: [ids] kimlikli deneme dersleri (başlık kimlikten).
List<GrammarLessonSummary> testLessonSummaries(
  List<String> ids, {
  Map<String, String> titles = const {},
  List<String> episodes = const ['A1-901'],
  List<String> books = const ['A1-K99'],
}) => [
  for (final id in ids)
    GrammarLessonSummary(
      id: id,
      level: GrammarLessonSummary.levelOf(id),
      titleTr: titles[id] ?? (id == kTestLessonId ? 'Üçüncü tekil -s' : id),
      goalTr: 'Tek kişiden söz ederken fiile ek getirebilirsin.',
      episodes: episodes,
      books: books,
      cardCount: 7,
      estimatedMinutes: 2.5,
      status: 'DRAFT',
    ),
];

/// Deneme kitabı (H-066 `A1-K99-the-test-box` dışa aktarımı; testte ses ve
/// görsel varmış gibi bölüm süreleri ve görsel yolları eklendi).
Book loadTestBook({
  String id = 'A1-K99',
  String? title,
  String? level,
  double? chapterDuration,
  Set<String> unnarrated = const {},
  Set<String> withoutTurkish = const {},
  List<String> grammarTopics = const [],
}) {
  final book = (jsonDecode(fixtureText('books/A1-K99/book.json')) as Map)
      .cast<String, dynamic>();
  final pages = (jsonDecode(fixtureText('books/A1-K99/pages.json')) as Map)
      .cast<String, dynamic>();
  book['id'] = id;
  if (grammarTopics.isNotEmpty) book['grammarTopics'] = grammarTopics;
  if (title != null) book['title'] = title;
  if (level != null) book['level'] = level;
  if (id != 'A1-K99' && title == null) book['title'] = 'The Test Box $id';
  if (chapterDuration != null) {
    for (final c in pages['chapters'] as List) {
      (c as Map)['duration'] = chapterDuration;
    }
  }
  // Sesi olmayan bölüm: ses yolu, süre ve bütün zamanlar boş.
  void untime(Map<dynamic, dynamic> sentence) {
    sentence['start'] = null;
    sentence['end'] = null;
    for (final w in (sentence['words'] as List? ?? const [])) {
      (w as Map)['start'] = null;
      w['end'] = null;
    }
  }

  for (final list in [book['chapters'], pages['chapters']]) {
    for (final c in (list as List? ?? const [])) {
      if (unnarrated.contains((c as Map)['id'])) {
        c['audio'] = null;
        c['duration'] = null;
        if (c['heading'] is Map) untime(c['heading'] as Map);
      }
    }
  }
  // Türkçesi olmayan cümleler (H-086).
  if (withoutTurkish.isNotEmpty) {
    for (final c in pages['chapters'] as List) {
      final h = (c as Map)['heading'];
      if (h is Map && withoutTurkish.contains(h['id'])) h.remove('tr');
    }
    for (final p in pages['pages'] as List) {
      for (final s in ((p as Map)['sentences'] as List)) {
        if (withoutTurkish.contains((s as Map)['id'])) s.remove('tr');
      }
    }
  }
  for (final p in pages['pages'] as List) {
    if (unnarrated.contains((p as Map)['chapter'])) {
      for (final s in (p['sentences'] as List)) {
        untime(s as Map);
      }
    }
  }
  return Book.fromJson(book, pages);
}

/// Kitap listesi: [ids] kimlikli deneme kitapları.
List<BookSummary> testBookSummaries(
  List<String> ids, {
  Map<String, List<String>> grammarTopics = const {},
}) => [
  for (final id in ids)
    BookSummary(
      grammarTopics: grammarTopics[id] ?? const [],
      id: id,
      title: id == 'A1-K99' ? 'The Test Box' : 'The Test Box $id',
      level: BookSummary.levelOf(id),
      genre: BookGenre.values[ids.indexOf(id) % BookGenre.values.length],
      estimatedMinutes: 7,
      pageCount: 3,
      chapterCount: 2,
    ),
];

/// Sezon 1 kataloğu: 12 bölüm (başlıklar kanondan), paketi olanlar `available`.
List<SeasonEpisode> catalogue(List<String> built) => [
  for (final (i, t) in const [
    'A Strange Message',
    'The New Neighbour',
    'Find the Station',
    'The Note',
    'Too Late?',
    'The Recording',
    'Who Knows What?',
    'The First Reveal',
    'The Café on the Hill',
    'Spare Parts',
    'Storm Warning',
    'The Lighthouse',
  ].indexed)
    SeasonEpisode(
      number: i + 1,
      contentId: 'A1-${(i + 1).toString().padLeft(3, '0')}',
      title: t,
      teaserTr: 'İpucu ${i + 1}.',
      teaserStatus: 'DRAFT',
      available: built.contains('A1-${(i + 1).toString().padLeft(3, '0')}'),
      mapX: 0.3 + 0.03 * i,
      mapY: 0.9 - 0.07 * i,
    ),
];

/// Sezon paketindeki konu seti özetleri (gerçek dışa aktarım kopyası).
List<TopicSetSummary> topicSetSummaries() => [
  for (final t
      in (jsonDecode(fixtureText('sets/topic_sets.json'))['topicSets'] as List))
    TopicSetSummary.fromJson((t as Map).cast<String, dynamic>()),
];

TopicSet loadTopicSetFixture(String id) => TopicSet.fromJson(
  (jsonDecode(fixtureText('sets/$id.json')) as Map).cast<String, dynamic>(),
);

/// Sezon paketindeki Hi verisi (gerçek dışa aktarım kopyası, H-048).
HiContent loadHiFixture() => HiContent.fromJson(
  (jsonDecode(fixtureText('hi.json')) as Map).cast<String, dynamic>(),
);
