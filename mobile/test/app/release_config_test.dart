import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/release_config.dart';

void main() {
  group('yayın adres kapısı', () {
    test('release dışındaki yerel geliştirme adreslerine dokunmaz', () {
      expect(
        () => validateReleaseEndpoints(
          isRelease: false,
          apiBaseUrl: 'http://127.0.0.1:8080',
          contentBaseUrl: 'http://localhost:8787',
          reelCatalogUrl: '',
        ),
        returnsNormally,
      );
    });

    test('release için yalnız genel HTTPS adreslerini kabul eder', () {
      expect(
        () => validateReleaseEndpoints(
          isRelease: true,
          apiBaseUrl: 'https://api.hi.velzon.tr',
          contentBaseUrl: 'https://media.hi.velzon.tr',
          reelCatalogUrl: 'https://api.hi.velzon.tr/api/v1/catalog/reels',
        ),
        returnsNormally,
      );
    });

    for (final (name, value) in [
      ('boş', ''),
      ('HTTP', 'http://api.hi.velzon.tr'),
      ('localhost', 'https://localhost'),
      ('IPv4 loopback', 'https://127.0.0.1'),
      ('IPv6 loopback', 'https://[::1]'),
      ('özel ağ IPv4', 'https://192.168.1.10'),
      ('yerel alan adı', 'https://backend.local'),
      ('kullanıcı bilgisi', 'https://user:secret@api.hi.velzon.tr'),
    ]) {
      test('release adresinde $name değerini reddeder', () {
        expect(
          () => validateReleaseEndpoints(
            isRelease: true,
            apiBaseUrl: value,
            contentBaseUrl: 'https://media.hi.velzon.tr',
            reelCatalogUrl: 'https://api.hi.velzon.tr/api/v1/catalog/reels',
          ),
          throwsA(isA<StateError>()),
        );
      });
    }

    test('hangi ayarın bozuk olduğunu söyler', () {
      expect(
        () => validateReleaseEndpoints(
          isRelease: true,
          apiBaseUrl: 'https://api.hi.velzon.tr',
          contentBaseUrl: 'http://127.0.0.1:8787',
          reelCatalogUrl: 'https://api.hi.velzon.tr/api/v1/catalog/reels',
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'ileti',
            contains('CONTENT_BASE_URL'),
          ),
        ),
      );
    });
  });
}
