import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/router.dart';
import 'package:hivelzon/features/hi/domain/coach_rules.dart';

/// Hi koçu ve Kitaplık (H-067): yarım kitap bölümden ve tekrardan sonra,
/// kitaba başlamak dinlenmeden hemen önce; gerekçe görünür.
void main() {
  final now = DateTime.utc(2026, 10, 14, 20);
  const reading = CoachBook(
    bookId: 'A1-K01',
    title: 'The Blue Door',
    level: 'A1',
    percent: 40,
    estimatedMinutes: 10,
  );
  const unread = CoachBook(
    bookId: 'A1-K02',
    title: 'Lost in the Market',
    level: 'A1',
    estimatedMinutes: 7,
  );
  const episode = CoachEpisode(
    contentId: 'A1-002',
    number: 2,
    title: 'The New Neighbour',
    estimatedMinutes: 7,
  );

  CoachInput input({
    CoachEpisode? inProgress,
    CoachEpisode? next,
    int reviewDue = 0,
    CoachBook? book,
    CoachBook? start,
  }) => CoachInput(
    now: now,
    dailyGoalMinutes: 10,
    inProgress: inProgress,
    next: next,
    reviewDue: reviewDue,
    bookInProgress: book,
    bookToStart: start,
  );

  test('yarım bölüm ve tekrar, yarım kitaptan önce gelir', () {
    expect(
      suggestToday(input(inProgress: episode, book: reading)).kind,
      HiSuggestionKind.continueEpisode,
    );
    expect(
      suggestToday(input(reviewDue: 6, book: reading)).kind,
      HiSuggestionKind.review,
    );
  });

  test('yarım kitap: kaldığı cümleden devam, gerekçe yüzdeyle', () {
    final s = suggestToday(input(next: episode, book: reading, start: unread));
    expect(s.kind, HiSuggestionKind.continueBook);
    expect(s.title, 'Kitaba devam: The Blue Door');
    expect(s.reasonTr, contains('%40'));
    expect(s.reasonTr, contains('kaldığın cümleden'));
    expect(s.minutes, 6); // kalan %60 × 10 dk
    expect(s.actionRoute, AppRoutes.book('A1-K01'));
  });

  test('kitaba başlamak: sıradaki bölüm yoksa ve tekrar yoksa', () {
    expect(
      suggestToday(input(next: episode, start: unread)).kind,
      HiSuggestionKind.startEpisode,
    );
    expect(
      suggestToday(input(reviewDue: 2, start: unread)).kind,
      HiSuggestionKind.review,
    );
    final s = suggestToday(input(start: unread));
    expect(s.kind, HiSuggestionKind.startBook);
    expect(s.title, 'Bir kitap dinle: Lost in the Market');
    expect(s.reasonTr, contains('A1 seviyesinde'));
    expect(s.actionRoute, AppRoutes.book('A1-K02', listen: true));
    expect(suggestToday(input()).kind, HiSuggestionKind.rest);
  });

  test('dil: suçlama ve geri sayım yok', () {
    for (final s in [
      suggestToday(input(book: reading)),
      suggestToday(input(start: unread)),
    ]) {
      for (final bad in ['kaçırdın', 'hemen', 'son şans', 'kaldı!']) {
        expect(s.reasonTr.toLowerCase(), isNot(contains(bad)));
      }
    }
  });
}
