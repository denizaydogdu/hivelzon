import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/shared/content/content_source.dart';
import 'package:hivelzon/shared/content/http_content_source.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../support/fixtures.dart';

/// Backend'in yayımlanmış reel kataloğu (H-094 P4): `/api/v1/catalog/reels`.
/// Bu yol yetkili durumdur; geri çekilen içerik listede yoktur.
void main() {
  final requests = <String>[];
  late List<Map<String, dynamic>> items;
  late int totalItems;
  late HttpContentSource source;

  Map<String, dynamic> card({
    required String id,
    required String level,
    required String category,
    String? family,
    double duration = 12.6,
  }) => {
    'contentId': id,
    'contentVersion': 1,
    'slug': null,
    'level': level,
    'number': 1,
    'category': category,
    'family': family,
    'titleTr': 'Gişede iki bilet',
    'title': 'Gişede iki bilet',
    'learningObjective': 'Kibarca bilet istemek',
    'duration': duration,
    'target': {'en': 'Two tickets, please.', 'tr': 'İki bilet, lütfen.'},
    'publishAt': '2026-10-21T05:15:23Z',
    'packageBaseUrl': 'http://127.0.0.1:8787/packages/_reels/$id/',
    'reelUrl': 'http://127.0.0.1:8787/packages/_reels/$id/reel.json',
  };

  setUp(() {
    requests.clear();
    items = [
      card(
        id: 'A1-R-CIN-01',
        level: 'A1',
        category: 'CIN',
        family: 'FAM-CIN-TICKETS',
      ),
      card(id: 'A2-R-SPO-01', level: 'A2', category: 'SPO', duration: 12.0),
    ];
    totalItems = items.length;
    source = HttpContentSource(
      baseUrl: 'http://127.0.0.1:8787',
      reelCatalogUrl: 'http://127.0.0.1:8080/api/v1/catalog/reels',
      client: MockClient((r) async {
        requests.add(r.url.path);
        if (r.url.path == '/api/v1/catalog/reels') {
          final page = int.parse(r.url.queryParameters['page'] ?? '0');
          // Sayfalama sınaması: ilk sayfada yalnız ilk kayıt.
          final slice = totalItems == 2 && items.length == 2
              ? (page == 0 ? items.take(1).toList() : items.skip(1).toList())
              : items;
          return http.Response.bytes(
            utf8.encode(
              jsonEncode({
                'items': slice,
                'page': page,
                'size': 100,
                'totalItems': totalItems,
                'totalPages': 1,
              }),
            ),
            200,
          );
        }
        if (r.url.path == '/packages/_reels/A1-R-CIN-01/reel.json') {
          return http.Response.bytes(
            utf8.encode(fixtureText('reels/A1-R-CIN-01.json')),
            200,
          );
        }
        return http.Response('yok', 404);
      }),
    );
  });

  test('backend kataloğu eşlenir; aile ve yayın durumu korunur', () async {
    final list = await source.listReels();
    expect(list.reels.map((r) => r.id), ['A1-R-CIN-01', 'A2-R-SPO-01']);
    final cin = list.byId('A1-R-CIN-01')!;
    expect(cin.categoryTr, 'Sinema');
    expect(cin.level, 'A1');
    expect(cin.family, 'FAM-CIN-TICKETS');
    expect(cin.sourceType, 'standalone');
    expect(cin.status, 'PUBLISHED');
    expect(cin.duration, 12.6);
    expect(list.byId('A2-R-SPO-01')!.categoryTr, 'Spor');
    expect(list.byId('A2-R-SPO-01')!.family, isNull);
    // İki sayfa istendi.
    expect(requests.where((p) => p == '/api/v1/catalog/reels').length, 2);
  });

  test('paket ve medya adresleri backend packageBaseUrl kullanır', () async {
    await source.listReels();
    expect(
      source.reelMediaUri('A1-R-CIN-01', 'audio/s02-02.m4a').toString(),
      'http://127.0.0.1:8787/packages/_reels/A1-R-CIN-01/audio/s02-02.m4a',
    );
    expect(
      resolveMediaUri(
        source,
        'A1-R-CIN-01',
        reelMediaPath('A1-R-CIN-01', 'stills/s02.webp'),
      ).toString(),
      'http://127.0.0.1:8787/packages/_reels/A1-R-CIN-01/stills/s02.webp',
    );

    final reel = await source.loadReel('A1-R-CIN-01');
    expect(reel.titleTr, 'Gişede iki bilet');
    expect(requests, contains('/packages/_reels/A1-R-CIN-01/reel.json'));
  });

  test('katalog yüklenmeden loadReel: katalog bir kez okunur', () async {
    final reel = await source.loadReel('A1-R-CIN-01');
    expect(reel.id, 'A1-R-CIN-01');
  });

  test('yayında olmayan kimlik oynatılmaz', () async {
    await expectLater(
      source.loadReel('A2-R-CIN-03'),
      throwsA(isA<ContentUnavailableException>()),
    );
    expect(requests.where((p) => p.contains('A2-R-CIN-03')), isEmpty);
  });

  test('backend hatası dosya kataloğuna sessizce düşmez', () async {
    source = HttpContentSource(
      baseUrl: 'http://127.0.0.1:8787',
      reelCatalogUrl: 'http://127.0.0.1:8080/api/v1/catalog/reels',
      client: MockClient((r) async {
        if (r.url.path == '/api/v1/catalog/reels') {
          return http.Response('bozuk', 500);
        }
        if (r.url.path == '/reels/index.json') {
          return http.Response.bytes(
            utf8.encode(fixtureText('reels/index.json')),
            200,
          );
        }
        return http.Response('yok', 404);
      }),
    );
    await expectLater(
      source.listReels(),
      throwsA(isA<ContentUnavailableException>()),
    );
    expect(requests, isNot(contains('/reels/index.json')));
  });
}
