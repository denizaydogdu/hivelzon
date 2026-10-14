import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/shared/content/content_source.dart';
import 'package:hivelzon/shared/content/http_content_source.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../support/fixtures.dart';

/// Geliştirme sunucusunun kitap uçları (H-066 `serve.py`): `/books/index.json`
/// ve `/books/<kitap>/<yol>`.
void main() {
  final requests = <String>[];
  late HttpContentSource source;

  setUp(() {
    requests.clear();
    source = HttpContentSource(
      baseUrl: 'http://127.0.0.1:8787',
      client: MockClient((r) async {
        requests.add(r.url.path);
        final body = switch (r.url.path) {
          '/books/index.json' => jsonEncode({
            'schemaVersion': 1,
            'books': [
              {
                'id': 'A1-K99',
                'title': 'The Test Box',
                'titleTr': 'Deneme Kutusu',
                'level': 'A1',
                'genre': 'mystery',
                'contentVersion': 1,
                'status': 'DRAFT',
                'cover': null,
                'estimatedMinutes': null,
                'pageCount': 3,
                'chapters': 2,
              },
            ],
          }),
          '/books/A1-K99/book.json' => fixtureText('books/A1-K99/book.json'),
          '/books/A1-K99/pages.json' => fixtureText('books/A1-K99/pages.json'),
          _ => null,
        };
        return body == null
            ? http.Response('yok', 404)
            : http.Response.bytes(utf8.encode(body), 200);
      }),
    );
  });

  test('kitap listesi ve paketi okunur', () async {
    final list = await source.listBooks();
    expect(list.single.id, 'A1-K99');
    expect(list.single.pageCount, 3);
    expect(list.single.chapterCount, 2);
    expect(list.single.cover, isNull);
    final book = await source.loadBook('A1-K99');
    expect(book.pages, hasLength(3));
    expect(book.chapters.first.audio, 'audio/c1.m4a');
    expect(requests, contains('/books/A1-K99/pages.json'));
  });

  test('medya adresleri; defter yolu `_books/` kitap paketine gider', () {
    expect(
      source.bookMediaUri('A1-K99', 'audio/c1.m4a').toString(),
      'http://127.0.0.1:8787/books/A1-K99/audio/c1.m4a',
    );
    expect(
      resolveMediaUri(
        source,
        'A1-K99',
        bookMediaPath('A1-K99', 'images/p01.webp'),
      ).toString(),
      'http://127.0.0.1:8787/books/A1-K99/images/p01.webp',
    );
    // Bölüm yolu değişmez.
    expect(
      resolveMediaUri(source, 'A1-001', 'stills/a.webp').toString(),
      'http://127.0.0.1:8787/packages/A1-001/stills/a.webp',
    );
  });

  test('bulunamayan kitap: içerik yok hatası', () async {
    await expectLater(
      source.loadBook('A2-K01'),
      throwsA(isA<ContentUnavailableException>()),
    );
  });
}
