import 'dart:convert';

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
        ),
    ];
  }

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
    );
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
    return loadTestBook(id: bookId);
  }

  @override
  Uri bookMediaUri(String bookId, String path) =>
      Uri.parse('http://test.invalid/books/$bookId/$path');
}

/// Deneme kitabı (H-066 `A1-K99-the-test-box` dışa aktarımı; testte ses ve
/// görsel varmış gibi bölüm süreleri ve görsel yolları eklendi).
Book loadTestBook({
  String id = 'A1-K99',
  String? title,
  String? level,
  double? chapterDuration,
}) {
  final book = (jsonDecode(fixtureText('books/A1-K99/book.json')) as Map)
      .cast<String, dynamic>();
  final pages = (jsonDecode(fixtureText('books/A1-K99/pages.json')) as Map)
      .cast<String, dynamic>();
  book['id'] = id;
  if (title != null) book['title'] = title;
  if (level != null) book['level'] = level;
  if (id != 'A1-K99' && title == null) book['title'] = 'The Test Box $id';
  if (chapterDuration != null) {
    for (final c in pages['chapters'] as List) {
      (c as Map)['duration'] = chapterDuration;
    }
  }
  return Book.fromJson(book, pages);
}

/// Kitap listesi: [ids] kimlikli deneme kitapları.
List<BookSummary> testBookSummaries(List<String> ids) => [
  for (final id in ids)
    BookSummary(
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
