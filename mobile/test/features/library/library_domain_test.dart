import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/library/data/book_progress_store.dart';
import 'package:hivelzon/features/library/domain/book.dart';
import 'package:hivelzon/features/library/domain/book_notebook.dart';
import 'package:hivelzon/features/library/domain/book_progress.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/notebook/presentation/widgets/notebook_row.dart';
import 'package:hivelzon/shared/meaning/notebook_repository.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/text/turkish.dart';

import '../../support/fake_api_server.dart';
import '../../support/fake_content_source.dart';
import '../../support/sync_harness.dart';

BookProgress _p(
  String id,
  BookStatus status, {
  int page = 1,
  int sentence = 0,
  required DateTime at,
  DateTime? completedAt,
  DateTime? startedAt,
}) => BookProgress(
  bookId: id,
  status: status,
  chapterId: 'c1',
  pageNumber: page,
  sentenceIndex: sentence,
  positionSec: page * 1.0,
  startedAt: startedAt,
  completedAt: completedAt,
  updatedAt: at,
);

void main() {
  final t0 = DateTime.utc(2026, 10, 14, 9);

  group('kitap paketi (H-066 dışa aktarımı)', () {
    test('book.json + pages.json okunur', () {
      final b = loadTestBook();
      expect(b.id, 'A1-K99');
      expect(b.title, 'The Test Box');
      expect(b.level, 'A1');
      expect(b.genre, BookGenre.mystery);
      expect(b.pages.map((p) => p.number), [1, 2, 3]);
      expect(b.chapters.map((c) => c.titleTr), ['Küçük Bir Kutu', 'Anahtar']);
      expect(b.palette.background, 0xFFFFF4E0);
      expect(b.palette.highlight, 0xFFFFE08A);
      expect(b.palette.surface, isNull);
      expect(b.pages[0].paragraphs.map((p) => p.length), [2, 1]);
      expect(b.canListen, isTrue);
      expect(b.isChapterStart(0), isTrue);
      expect(b.isChapterStart(1), isFalse);
      expect(b.isChapterStart(2), isTrue);
      final w = b.pages[1].sentences[0].words.first;
      expect(w.w, '"What');
      expect(w.bare, 'What');
      expect(b.pages[0].sentences[0].words.first.gloss, isNull); // özel ad
    });

    test('zamanlama: başlangıcı geçmiş son cümle; aradaki boşlukta önceki', () {
      final b = loadTestBook();
      final t = b.track('c1');
      expect(t.items.length, 1 + 3 + 2);
      expect(t.items.first.index, -1);
      String at(double s) => t.items[t.indexAt(s)].sentence.id;
      expect(at(0), 'c1-h');
      expect(at(0.9), 'c1-h'); // başlık bitti, ilk cümle başlamadı
      expect(at(1.3), 'p01-s01');
      expect(at(2.9), 'p01-s01'); // 2,7–3,1 arası boşluk
      expect(at(3.1), 'p01-s02');
      expect(at(6.4), 'p02-s01');
      expect(at(11), 'p02-s02');
      expect(t.end, 11.3);
      final s = b.pages[0].sentences[0];
      expect(ChapterTrack.wordAt(s, 1.2), isNull);
      expect(ChapterTrack.wordAt(s, 2.0), 3); // small
      expect(ChapterTrack.wordAt(s, 2.69), 4);
      expect(ChapterTrack.wordAt(s, 3.0), isNull);
    });

    test('zamansız kitap sesli okunamaz', () {
      final b = Book.fromJson(
        {'id': 'A1-K98', 'title': 'X', 'level': 'A1'},
        {
          'bookId': 'A1-K98',
          'chapters': [
            {
              'id': 'c1',
              'title': 'T',
              'audio': null,
              'duration': null,
              'heading': {
                'id': 'c1-h',
                'paragraph': 0,
                'text': 'T',
                'start': null,
                'end': null,
                'tr': null,
                'words': [],
                'chunks': [],
              },
              'pages': ['p01'],
            },
          ],
          'pages': [
            {
              'id': 'p01',
              'number': 1,
              'chapter': 'c1',
              'image': null,
              'sentences': [
                {
                  'id': 'p01-s01',
                  'paragraph': 1,
                  'text': 'Hi.',
                  'start': null,
                  'end': null,
                  'tr': null,
                  'words': [],
                  'chunks': [],
                },
              ],
            },
          ],
        },
      );
      expect(b.canListen, isFalse);
      expect(b.palette.background, BookPalette.fallback.background);
    });

    test('renk ayrıştırma', () {
      expect(parseHexColor('#1F4E79'), 0xFF1F4E79);
      expect(parseHexColor('1F4E79'), isNull);
      expect(parseHexColor('#12345'), isNull);
      expect(Book.pageNumberOf('p03-s01'), 3);
      expect(Book.pageNumberOf('c1-h'), isNull);
    });
  });

  group('raflar ve "Bana bir kitap oku"', () {
    final books = testBookSummaries([
      'A1-K01',
      'A1-K02',
      'A1-K03',
      'A2-K01',
      'B1-K01',
    ]);

    test('rafları kurar: devam, seviyem, öteki seviyeler, okuduklarım', () {
      final progress = {
        'A1-K02': _p('A1-K02', BookStatus.inProgress, page: 2, at: t0),
        'B1-K01': _p(
          'B1-K01',
          BookStatus.inProgress,
          at: t0.add(const Duration(hours: 1)),
        ),
        'A1-K03': _p('A1-K03', BookStatus.completed, at: t0, completedAt: t0),
      };
      final s = buildShelves(books, progress, suggestedLevel: 'a2');
      expect(s.userLevel, 'A2');
      expect(s.continueReading.map((b) => b.id), ['B1-K01', 'A1-K02']);
      expect(s.userLevelBooks.map((b) => b.id), ['A2-K01']);
      expect(s.otherLevels.map((e) => e.$1), ['A1', 'B1']);
      expect(s.finished.map((b) => b.id), ['A1-K03']);
      // Seviye yoksa ya da tanınmıyorsa A1.
      expect(buildShelves(books, {}).userLevel, 'A1');
      expect(libraryLevel('Z9'), 'A1');
      expect(levelsWithBooks(books), ['A1', 'A2', 'B1']);
    });

    test('rastgele okunmamış kitap: yarım ve biten seçilmez; yoksa null', () {
      final progress = {
        'A1-K01': _p('A1-K01', BookStatus.inProgress, at: t0),
        'A1-K03': _p('A1-K03', BookStatus.completed, at: t0),
      };
      for (var seed = 0; seed < 20; seed++) {
        expect(
          pickUnreadBook(books, progress, 'A1', math.Random(seed))!.id,
          'A1-K02',
        );
      }
      final all = {
        ...progress,
        'A1-K02': _p('A1-K02', BookStatus.inProgress, at: t0),
      };
      expect(pickUnreadBook(books, all, 'A1', math.Random(1)), isNull);
      expect(pickUnreadBook(books, {}, 'C2', math.Random(1)), isNull);
      // Birden çok aday: tohuma göre değişir, hep okunmamışlardan.
      final picks = {
        for (var seed = 0; seed < 30; seed++)
          pickUnreadBook(books, {}, 'A1', math.Random(seed))!.id,
      };
      expect(picks, {'A1-K01', 'A1-K02', 'A1-K03'});
    });

    test('okunan kısım sayfaya göre; başlanmışta en az %1', () {
      expect(
        _p('x', BookStatus.inProgress, page: 1, at: t0).fraction(10),
        0.01,
      );
      expect(_p('x', BookStatus.inProgress, page: 6, at: t0).fraction(10), 0.5);
      expect(_p('x', BookStatus.completed, at: t0).fraction(10), 1);
      expect(_p('x', BookStatus.notStarted, at: t0).fraction(10), 0);
    });
  });

  group('ilerleme birleştirme ("bitti" kazanır)', () {
    test('aynı durumda son yazan kazanır', () {
      final a = _p('b', BookStatus.inProgress, page: 2, at: t0);
      final b = _p(
        'b',
        BookStatus.inProgress,
        page: 5,
        at: t0.add(const Duration(minutes: 1)),
        startedAt: t0,
      );
      expect(mergeBookProgress(a, b).pageNumber, 5);
      expect(mergeBookProgress(b, a).pageNumber, 5);
    });

    test('daha yeni "okunuyor" bitmişi düşürmez; yer bitenin', () {
      final done = _p(
        'b',
        BookStatus.completed,
        page: 12,
        at: t0,
        completedAt: t0,
        startedAt: t0.subtract(const Duration(days: 1)),
      );
      final later = _p(
        'b',
        BookStatus.inProgress,
        page: 2,
        at: t0.add(const Duration(hours: 1)),
        startedAt: t0,
      );
      for (final m in [
        mergeBookProgress(done, later),
        mergeBookProgress(later, done),
      ]) {
        expect(m.status, BookStatus.completed);
        expect(m.pageNumber, 12);
        expect(m.completedAt, t0);
        expect(m.updatedAt, later.updatedAt);
        expect(m.startedAt, done.startedAt);
      }
    });

    test('daha yeni "okunuyor" başlamamışı yükseltir', () {
      final m = mergeBookProgress(
        _p('b', BookStatus.notStarted, at: t0.add(const Duration(hours: 1))),
        _p('b', BookStatus.inProgress, page: 3, at: t0),
      );
      expect(m.status, BookStatus.inProgress);
      expect(m.pageNumber, 1); // yer daha yeni kopyanın
    });
  });

  group('Drift deposu', () {
    late AppDatabase db;
    late DateTime now;
    late BookProgressStore store;

    setUp(() {
      db = AppDatabase.memory();
      now = t0;
      store = BookProgressStore(db, clock: () => now);
    });
    tearDown(() => db.close());

    test('kalınan yer yazılır; aynı yer ikinci kez yazılmaz', () async {
      expect(await store.get('A1-K99'), isNull);
      expect(
        await store.savePosition(
          'A1-K99',
          chapterId: 'c1',
          pageNumber: 2,
          sentenceIndex: 1,
          positionSec: 9.5,
        ),
        isTrue,
      );
      now = now.add(const Duration(minutes: 1));
      expect(
        await store.savePosition(
          'A1-K99',
          chapterId: 'c1',
          pageNumber: 2,
          sentenceIndex: 1,
        ),
        isFalse,
      );
      final p = (await store.get('A1-K99'))!;
      expect(p.status, BookStatus.inProgress);
      expect(p.pageNumber, 2);
      expect(p.positionSec, 9.5);
      expect(p.startedAt, t0);
      expect(p.updatedAt, t0);
    });

    test('biten kitap yeniden okununca da "bitti" kalır', () async {
      await store.savePosition(
        'A1-K99',
        chapterId: 'c2',
        pageNumber: 3,
        sentenceIndex: 2,
      );
      now = now.add(const Duration(minutes: 5));
      await store.markCompleted('A1-K99');
      final done = (await store.get('A1-K99'))!;
      expect(done.status, BookStatus.completed);
      expect(done.completedAt, now);
      now = now.add(const Duration(minutes: 5));
      await store.markCompleted('A1-K99'); // idempotent: ilk bitiş kalır
      await store.savePosition(
        'A1-K99',
        chapterId: 'c1',
        pageNumber: 1,
        sentenceIndex: -1,
      );
      final again = (await store.get('A1-K99'))!;
      expect(again.status, BookStatus.completed);
      expect(again.completedAt, done.completedAt);
      expect(again.pageNumber, 1);
    });

    test(
      'okuma ayarları cihazda: yazı boyutu 3 kademe, kelime vurgusu',
      () async {
        expect(await store.textSize(), 1);
        await store.setTextSize(5);
        expect(await store.textSize(), 2);
        expect(await store.wordHighlight(), isFalse);
        await store.setWordHighlight(true);
        expect(await store.wordHighlight(), isTrue);
      },
    );
  });

  group('Defter: kitaptan ekleme', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase.memory());
    tearDown(() => db.close());

    test(
      'kelime: Türkçe, örnek cümle, kitap sesinden telaffuz, görsel, kaynak',
      () async {
        final book = loadTestBook(title: 'The Blue Door');
        // "small" (p01-s01, 3. kelime).
        final item = bookWordSave(book, 0, 0, 3, now: t0);
        expect(item.en, 'small');
        expect(item.tr, 'küçük');
        expect(item.context, 'Ece has a small box.');
        expect(item.contextTr, "Ece'nin küçük bir kutusu var.");
        expect(item.source, NotebookSource.book);
        expect(item.sourceTitle, 'The Blue Door');
        expect(item.imagePath, '_books/A1-K99/images/p01.webp');
        expect(item.audio!.path, '_books/A1-K99/audio/c1.m4a');
        expect(item.audio!.start, 1.975);
        expect(item.audio!.end, 2.35);
        expect(item.contextAudio!.start, 1.3);
        expect(item.contextAudio!.end, 2.7);
        // Resimsiz sayfada kapak.
        expect(bookItemImage(book, 1), '_books/A1-K99/images/cover.webp');

        final repo = DriftNotebookRepository(NotebookStore(db));
        expect(await repo.add(item), isTrue);
        expect(await repo.add(bookWordSave(book, 0, 0, 3, now: t0)), isFalse);
        final entries = await NotebookStore(db).entries();
        expect(entries, hasLength(1));
        final saved = entries.single.item;
        expect(saved.source, NotebookSource.book);
        expect(saved.sourceTitle, 'The Blue Door');
        expect(saved.bookPage, 1);
        expect(saved.episodeTag, isNull);
        expect(saved.exampleTr, "Ece'nin küçük bir kutusu var.");
        expect(saved.audio!.isRange, isTrue);
        // Kelime tekrarına (FSRS) yeni kart olarak girer.
        expect(entries.single.card.isNew, isTrue);
        expect(notebookSourceLine(saved), 'Kitap: The Blue Door, s. 1');
      },
    );

    test('kaynak satırları', () {
      NotebookItem item(
        NotebookSource s, {
        String? cid,
        String? title,
        String? cue,
      }) => NotebookItem(
        kind: NotebookKind.word,
        textEn: 'x',
        source: s,
        contentId: cid,
        sourceTitle: title,
        cueId: cue,
      );
      expect(
        notebookSourceLine(item(NotebookSource.userSaved, cid: 'A1-003')),
        "Bölüm 3'ten ekledin",
      );
      expect(notebookSourceLine(item(NotebookSource.userSaved)), isNull);
      expect(
        notebookSourceLine(
          item(NotebookSource.autoTargetPhrase, cid: 'A1-001'),
        ),
        isNull,
      );
      expect(
        notebookSourceLine(item(NotebookSource.topicSet)),
        'Konu setinden',
      );
      expect(
        notebookSourceLine(
          item(
            NotebookSource.book,
            cid: 'A2-K03',
            title: 'The Parrot',
            cue: 'p12-s04',
          ),
        ),
        'Kitap: The Parrot, s. 12',
      );
      expect(notebookSourceLine(item(NotebookSource.book)), 'Kitaptan');
      expect(
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 20, 30, 40, 60].map(ablativeNumber),
        [
          "1'den",
          "2'den",
          "3'ten",
          "4'ten",
          "5'ten",
          "6'dan",
          "7'den",
          "8'den",
          "9'dan",
          "10'dan",
          "12'den",
          "20'den",
          "30'dan",
          "40'tan",
          "60'tan",
        ],
      );
    });
  });

  group('eşitleme (hesap açıkken)', () {
    late FakeApiServer server;
    late TestClock clock;
    final devices = <Device>[];
    Device device() {
      final d = Device(server, clock);
      devices.add(d);
      return d;
    }

    setUp(() {
      clock = TestClock();
      server = FakeApiServer(clock: clock.call);
    });
    tearDown(() async {
      for (final d in devices) {
        await d.close();
      }
      devices.clear();
    });
    const email = 'deniz@example.com';

    test('kitap ilerlemesi öteki cihaza gider; "bitti" kazanır', () async {
      final a = device();
      final b = device();
      await a.signIn(email);
      await b.signIn(email);
      final sa = BookProgressStore(a.db, clock: clock.call);
      final sb = BookProgressStore(b.db, clock: clock.call);
      await sa.savePosition(
        'A1-K99',
        chapterId: 'c1',
        pageNumber: 2,
        sentenceIndex: 1,
        positionSec: 9.5,
      );
      expect((await a.engine.sync()).ok, isTrue);
      expect((await b.engine.sync()).ok, isTrue);
      expect((await sb.get('A1-K99'))!.pageNumber, 2);

      // B kitabı bitirir; A (eski bilgiyle) daha sonra yarıda bir yer yazar.
      clock.advance(const Duration(minutes: 1));
      await sb.markCompleted('A1-K99');
      await b.engine.sync();
      clock.advance(const Duration(minutes: 1));
      await sa.savePosition(
        'A1-K99',
        chapterId: 'c1',
        pageNumber: 1,
        sentenceIndex: 0,
      );
      await a.engine.sync();
      await b.engine.sync();
      for (final s in [sa, sb]) {
        final p = (await s.get('A1-K99'))!;
        expect(p.status, BookStatus.completed);
      }
    });

    test('kitaptan eklenen ifade kaynağıyla eşitlenir', () async {
      final a = device();
      final b = device();
      await a.signIn(email);
      await b.signIn(email);
      final book = loadTestBook(title: 'The Blue Door');
      await DriftNotebookRepository(
        NotebookStore(a.db),
      ).add(bookWordSave(book, 2, 0, 3, now: clock.now));
      await a.engine.sync();
      await b.engine.sync();
      final item = (await NotebookStore(b.db).entries()).single.item;
      expect(item.source, NotebookSource.book);
      expect(notebookSourceLine(item), 'Kitap: The Blue Door, s. 3');
    });
  });
}
