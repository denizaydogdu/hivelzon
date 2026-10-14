import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/grammar/domain/grammar_lesson.dart';
import 'package:hivelzon/shared/content/content_source.dart';
import 'package:hivelzon/shared/content/http_content_source.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../support/fixtures.dart';

const _id = 'G-A1-99-third-person-s';

/// Geliştirme sunucusunun dilbilgisi uçları (H-077 `serve.py`):
/// `/grammar/index.json` ve `/grammar/<G-ID>/<yol>`; bölüm ve kitap
/// listelerinde `grammarTopics`.
void main() {
  final requests = <String>[];
  late HttpContentSource source;
  var broken = false;

  setUp(() {
    requests.clear();
    broken = false;
    source = HttpContentSource(
      baseUrl: 'http://127.0.0.1:8787',
      client: MockClient((r) async {
        requests.add(r.url.path);
        final lesson = jsonDecode(fixtureText('grammar/$_id/lesson.json'));
        final body = switch (r.url.path) {
          '/grammar/index.json' =>
            broken
                ? '{"lessons": [{"title": 3}]}'
                : jsonEncode({
                    'schemaVersion': 1,
                    'lessons': [
                      {
                        for (final k in const [
                          'id',
                          'level',
                          'titleTr',
                          'titleEn',
                          'goalTr',
                          'prerequisites',
                          'contentVersion',
                          'status',
                          'linksTo',
                          'cardCount',
                          'estimatedMinutes',
                        ])
                          k: (lesson as Map)[k],
                      },
                    ],
                  }),
          '/grammar/$_id/lesson.json' => fixtureText(
            'grammar/$_id/lesson.json',
          ),
          '/grammar/$_id/cards.json' => fixtureText('grammar/$_id/cards.json'),
          '/packages/index.json' => jsonEncode({
            'packages': [
              {
                'id': 'A1-001',
                'title': 'A Strange Message',
                'grammarTopics': [_id],
              },
              {'id': 'A1-002', 'title': 'The New Neighbour'},
            ],
          }),
          '/books/index.json' => jsonEncode({
            'books': [
              {
                'id': 'A1-K99',
                'title': 'The Test Box',
                'grammarTopics': [_id],
              },
            ],
          }),
          _ => null,
        };
        return body == null
            ? http.Response('yok', 404)
            : http.Response.bytes(utf8.encode(body), 200);
      }),
    );
  });

  test('ders listesi ve paketi okunur', () async {
    final list = await source.loadGrammarIndex();
    expect(list.single.id, _id);
    expect(list.single.level, 'A1');
    expect(list.single.titleTr, 'Üçüncü tekil -s');
    expect(list.single.episodes, ['A1-901']);
    expect(list.single.books, ['A1-K99']);
    expect(list.single.cardCount, 7);
    expect(list.single.minutes, 3); // 2,5 dk → ~3 dk
    final lesson = await source.loadLesson(_id);
    expect(lesson.cards, hasLength(7));
    expect(lesson.cards.first.type, GrammarCardType.hook);
    expect(requests, contains('/grammar/$_id/cards.json'));
  });

  test('bozuk liste ve eksik ders: içerik hatası', () async {
    broken = true;
    await expectLater(
      source.loadGrammarIndex(),
      throwsA(isA<ContentUnavailableException>()),
    );
    await expectLater(
      source.loadLesson('G-A1-01-yok'),
      throwsA(isA<ContentUnavailableException>()),
    );
  });

  test('bölüm ve kitap listelerinde grammarTopics; yoksa boş', () async {
    final packages = await source.listPackages();
    expect(packages.first.grammarTopics, [_id]);
    expect(packages.last.grammarTopics, isEmpty);
    final books = await source.listBooks();
    expect(books.single.grammarTopics, [_id]);
  });

  test('medya adresleri; defter yolu `_grammar/` ders paketine gider', () {
    expect(
      source.grammarMediaUri(_id, 'audio/c01-tr.m4a').toString(),
      'http://127.0.0.1:8787/grammar/$_id/audio/c01-tr.m4a',
    );
    expect(
      resolveMediaUri(
        source,
        _id,
        grammarMediaPath(_id, 'audio/c07-ex1.m4a'),
      ).toString(),
      'http://127.0.0.1:8787/grammar/$_id/audio/c07-ex1.m4a',
    );
    expect(parseGrammarMediaPath('_books/A1-K99/x.m4a'), isNull);
  });
}
