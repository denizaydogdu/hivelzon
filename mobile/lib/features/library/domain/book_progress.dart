// Kitap ilerlemesi (H-067, `user_book_progress`) ve Kitaplık rafları. Saf Dart.

import 'dart:math' as math;

import 'book.dart';

enum BookStatus {
  notStarted('NOT_STARTED'),
  inProgress('IN_PROGRESS'),
  completed('COMPLETED');

  const BookStatus(this.code);

  final String code;

  static BookStatus parse(Object? v) =>
      values.firstWhere((s) => s.code == v, orElse: () => notStarted);

  /// "Bitti kazanır" sırası (H-056 kuralı): başlamadı < okunuyor < bitti.
  int get rank => index;
}

/// Kitapta kalınan yer. Cümle, sayfadaki sıradır (−1: bölüm başlığı).
class BookProgress {
  const BookProgress({
    required this.bookId,
    required this.status,
    required this.updatedAt,
    this.chapterId,
    this.pageNumber,
    this.sentenceIndex,
    this.positionSec,
    this.startedAt,
    this.completedAt,
  });

  final String bookId;
  final BookStatus status;
  final String? chapterId;

  /// Kitaptaki sayfa numarası (1'den).
  final int? pageNumber;
  final int? sentenceIndex;

  /// Bölüm sesindeki konum (sn): kalınan cümlenin başı.
  final double? positionSec;
  final DateTime? startedAt;
  final DateTime? completedAt;

  /// UTC; son yazan kazanır zamanı.
  final DateTime updatedAt;

  bool get isCompleted => status == BookStatus.completed;
  bool get isInProgress => status == BookStatus.inProgress;

  /// Okunan kısım (0–1), sayfaya göre. Başlanmış kitapta en az %1.
  double fraction(int? pageCount) {
    if (isCompleted) return 1;
    final n = pageCount ?? 0;
    final p = pageNumber;
    if (n <= 0 || p == null || !isInProgress) return 0;
    return math.max(0.01, ((p - 1) / n).clamp(0.0, 0.99));
  }

  BookProgress copyWith({
    BookStatus? status,
    String? chapterId,
    int? pageNumber,
    int? sentenceIndex,
    double? positionSec,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? updatedAt,
  }) => BookProgress(
    bookId: bookId,
    status: status ?? this.status,
    chapterId: chapterId ?? this.chapterId,
    pageNumber: pageNumber ?? this.pageNumber,
    sentenceIndex: sentenceIndex ?? this.sentenceIndex,
    positionSec: positionSec ?? this.positionSec,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt ?? this.completedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

/// İki kopyayı birleştirir (eşitleme kuralı; backend `ProgressMerger` ve
/// mobil `SyncStore` aynısını uygular):
/// - durum hiçbir zaman geri gitmez ("bitti kazanır");
/// - aynı durumda son yazan kazanır (kalınan yer de onun);
/// - yeni kopya daha düşük durumdaysa kalınan yer yeninin, durum ve bitiş
///   zamanı eskinin (bitmişse kalınan yer de eskinin);
/// - başlama zamanı en erken, güncelleme zamanı en geç.
BookProgress mergeBookProgress(BookProgress a, BookProgress b) {
  final newer = b.updatedAt.isAfter(a.updatedAt) ? b : a;
  final older = identical(newer, b) ? a : b;
  DateTime? earliest(DateTime? x, DateTime? y) =>
      x == null ? y : (y == null || x.isBefore(y) ? x : y);
  final started = earliest(a.startedAt, b.startedAt);
  if (newer.status.rank >= older.status.rank) {
    return newer.copyWith(
      startedAt: started,
      completedAt: newer.completedAt ?? older.completedAt,
    );
  }
  final keepPlace = older.isCompleted ? older : newer;
  return BookProgress(
    bookId: newer.bookId,
    status: older.status,
    chapterId: keepPlace.chapterId,
    pageNumber: keepPlace.pageNumber,
    sentenceIndex: keepPlace.sentenceIndex,
    positionSec: keepPlace.positionSec,
    startedAt: started,
    completedAt: older.completedAt,
    updatedAt: newer.updatedAt,
  );
}

/// Kitaplık rafları (`KITAPLIK.md` §7).
class LibraryShelves {
  const LibraryShelves({
    required this.userLevel,
    required this.continueReading,
    required this.userLevelBooks,
    required this.otherLevels,
    required this.finished,
  });

  /// "Senin seviyen" (yerleştirme sonucu; yoksa A1).
  final String userLevel;

  /// Yarıda kalanlar, son okunan önce.
  final List<BookSummary> continueReading;
  final List<BookSummary> userLevelBooks;

  /// Öteki seviyeler, seviye sırasıyla (yalnızca kitabı olanlar).
  final List<(String, List<BookSummary>)> otherLevels;

  /// Bitenler, son biten önce.
  final List<BookSummary> finished;

  bool get isEmpty =>
      continueReading.isEmpty &&
      userLevelBooks.isEmpty &&
      otherLevels.isEmpty &&
      finished.isEmpty;
}

/// Yerleştirme sonucundan Kitaplık seviyesi (bilinmeyen kod → A1).
String libraryLevel(String? suggested) {
  final s = suggested?.trim().toUpperCase();
  return s != null && kBookLevels.contains(s) ? s : 'A1';
}

LibraryShelves buildShelves(
  List<BookSummary> books,
  Map<String, BookProgress> progress, {
  String? suggestedLevel,
}) {
  final level = libraryLevel(suggestedLevel);
  int byId(BookSummary a, BookSummary b) => a.id.compareTo(b.id);
  DateTime at(BookSummary b) =>
      progress[b.id]?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
  final cont =
      books.where((b) => progress[b.id]?.isInProgress ?? false).toList()
        ..sort((a, b) => at(b).compareTo(at(a)));
  final done = books.where((b) => progress[b.id]?.isCompleted ?? false).toList()
    ..sort((a, b) {
      DateTime c(BookSummary x) =>
          progress[x.id]?.completedAt ?? progress[x.id]!.updatedAt;
      return c(b).compareTo(c(a));
    });
  final mine = books.where((b) => b.level == level).toList()..sort(byId);
  final others = <(String, List<BookSummary>)>[
    for (final l in kBookLevels)
      if (l != level && books.any((b) => b.level == l))
        (l, books.where((b) => b.level == l).toList()..sort(byId)),
  ];
  return LibraryShelves(
    userLevel: level,
    continueReading: cont,
    userLevelBooks: mine,
    otherLevels: others,
    finished: done,
  );
}

/// "Bana bir kitap oku": [level] seviyesinde hiç açılmamış kitaplardan biri
/// (yoksa null). Yarıda kalan ya da biten kitap seçilmez.
BookSummary? pickUnreadBook(
  List<BookSummary> books,
  Map<String, BookProgress> progress,
  String level,
  math.Random random,
) {
  final unread = [
    for (final b in books)
      if (b.level == level &&
          (progress[b.id]?.status ?? BookStatus.notStarted) ==
              BookStatus.notStarted)
        b,
  ]..sort((a, b) => a.id.compareTo(b.id));
  if (unread.isEmpty) return null;
  return unread[random.nextInt(unread.length)];
}

/// Seçicideki seviyeler: kitabı olanlar (seviye sırasıyla).
List<String> levelsWithBooks(List<BookSummary> books) => [
  for (final l in kBookLevels)
    if (books.any((b) => b.level == l)) l,
];
