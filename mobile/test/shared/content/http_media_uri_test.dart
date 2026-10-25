import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/shared/content/http_content_source.dart';

void main() {
  final source = HttpContentSource(baseUrl: 'http://127.0.0.1:8787');

  test('paketteki mutlak HTTPS medya adresini olduğu gibi kullanır', () {
    const stream = 'https://video.example.net/library/id/playlist.m3u8';

    expect(source.mediaUri('A1-001', stream).toString(), stream);
    expect(source.seasonMediaUri(1, stream).toString(), stream);
    expect(source.bookMediaUri('A1-K01', stream).toString(), stream);
    expect(source.grammarMediaUri('G-A1-01', stream).toString(), stream);
    expect(source.reelMediaUri('A1-R-CIN-01', stream).toString(), stream);
  });

  test('paketteki mutlak güvensiz adresi reddeder', () {
    expect(
      () => source.reelMediaUri(
        'A1-R-CIN-01',
        'http://video.example.net/video.mp4',
      ),
      throwsArgumentError,
    );
    expect(
      () => source.mediaUri('A1-001', 'https://user:secret@example.net/x'),
      throwsArgumentError,
    );
  });

  test('göreli medya yollarını mevcut paket kökünde çözer', () {
    expect(
      source.mediaUri('A1-001', 'video/scene.mp4').toString(),
      'http://127.0.0.1:8787/packages/A1-001/video/scene.mp4',
    );
  });
}
