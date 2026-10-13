// Video sürümü seçimi (H-054). Saf Dart: Flutter içe aktarımı yoktur.
//
// Paket her video için iki sürüm taşır: `video` alanı 1080p'dir (eski
// uygulamalar onu oynatır), `renditions` alanı 720p ve 1080p yollarını
// listeler. Uygulama varsayılan olarak 720p oynatır (~1,7 Mbps, 1080p'nin
// üçte biri). 1080p yalnızca debug/profile derlemede seçilebilir:
//
//     flutter run --dart-define=HV_RENDITION=1080p

/// Uygulamanın varsayılan oynattığı sürüm.
const String kRendition720 = '720p';
const String kRendition1080 = '1080p';

const String _override = String.fromEnvironment('HV_RENDITION');
const bool _isRelease = bool.fromEnvironment('dart.vm.product');

/// Seçilen sürüm: yayın derlemesinde her zaman 720p.
const String kPreferredRendition = (!_isRelease && _override == kRendition1080)
    ? kRendition1080
    : kRendition720;

/// Düğümün oynatılacak yolu: [renditions] içinde [preferred] varsa o, yoksa
/// [video] (sürümsüz eski paketler).
String pickRendition(
  String video,
  Object? renditions, [
  String preferred = kPreferredRendition,
]) {
  if (renditions is Map) {
    final p = renditions[preferred];
    if (p is String && p.isNotEmpty) return p;
  }
  return video;
}

/// H-054 öncesi kaydedilen durağan görsel yolu (`stills/x.jpg`) bugünkü
/// paketteki adına (`stills/x.webp`) çevrilir; başka yollar olduğu gibi kalır.
/// Defterde saklanan eski kart görselleri böylece yeni paketlerde de açılır.
String currentStillPath(String path) =>
    path.startsWith('stills/') && path.endsWith('.jpg')
    ? '${path.substring(0, path.length - 4)}.webp'
    : path;
