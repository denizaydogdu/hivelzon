import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/shared/content/content_source.dart';
import 'package:hivelzon/shared/content/http_content_source.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../support/fixtures.dart';

/// Geliştirme sunucusunun reel uçları (H-094 `serve.py`): `/reels/index.json`
/// ve `/reels/<reel>/<yol>`.
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
          '/reels/index.json' => fixtureText('reels/index.json'),
          '/reels/A1-R-CIN-01/reel.json' => fixtureText(
            'reels/A1-R-CIN-01.json',
          ),
          _ => null,
        };
        return body == null
            ? http.Response('yok', 404)
            : http.Response.bytes(utf8.encode(body), 200);
      }),
    );
  });

  test('reel listesi ve paketi okunur', () async {
    final list = await source.listReels();
    expect(list.reels.map((r) => r.id), [
      'A1-R-BOK-01',
      'A1-R-BOK-02',
      'A1-R-BOK-03',
      'A1-R-CIN-01',
      'A1-R-CIN-02',
      'A1-R-CIN-03',
      'A1-R-SPO-01',
      'A1-R-SPO-02',
      'A1-R-SPO-03',
      'A2-R-BOK-01',
      'A2-R-BOK-02',
      'A2-R-BOK-03',
      'A2-R-CIN-01',
      'A2-R-CIN-02',
      'A2-R-CIN-03',
      'A2-R-SPO-01',
      'A2-R-SPO-02',
      'A2-R-SPO-03',
    ]);
    expect(list.byId('A1-R-CIN-01')!.categoryTr, 'Sinema');
    expect(list.byCategory('BOK').map((r) => r.level), [
      'A1',
      'A1',
      'A1',
      'A2',
      'A2',
      'A2',
    ]);

    final reel = await source.loadReel('A1-R-CIN-01');
    expect(reel.titleTr, 'Gişede iki bilet');
    expect(reel.level, 'A1');
    expect(reel.target.en, 'Two tickets, please.');
    expect(reel.subtitles.cues, hasLength(3));
    expect(reel.practice!.correctIndex, 0);
    expect(requests, contains('/reels/A1-R-CIN-01/reel.json'));
  });

  test('medya adresleri; defter yolu `_reels/` reel paketine gider', () {
    expect(
      source.reelMediaUri('A1-R-CIN-01', 'audio/s02-02.m4a').toString(),
      'http://127.0.0.1:8787/reels/A1-R-CIN-01/audio/s02-02.m4a',
    );
    expect(
      resolveMediaUri(
        source,
        'A1-R-CIN-01',
        reelMediaPath('A1-R-CIN-01', 'stills/s02.webp'),
      ).toString(),
      'http://127.0.0.1:8787/reels/A1-R-CIN-01/stills/s02.webp',
    );
    // Bölüm yolu değişmez.
    expect(
      resolveMediaUri(source, 'A1-001', 'stills/a.webp').toString(),
      'http://127.0.0.1:8787/packages/A1-001/stills/a.webp',
    );
  });

  test('bulunamayan reel: içerik yok hatası', () async {
    await expectLater(
      source.loadReel('A2-BOK-01'),
      throwsA(isA<ContentUnavailableException>()),
    );
  });
}
