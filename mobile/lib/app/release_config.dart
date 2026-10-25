/// H-044 mağaza derlemesi güvenlik kapısı.
///
/// Yerel geliştirme adresleri debug/profile derlemelerinde geçerlidir. Release
/// derlemesi ise yalnızca kimlik bilgisi taşımayan, genel HTTPS adresleriyle
/// açılır; böylece 127.0.0.1 varsayılanıyla işlevsiz mağaza paketi üretilemez.
void validateReleaseEndpoints({
  required bool isRelease,
  required String apiBaseUrl,
  required String contentBaseUrl,
  required String reelCatalogUrl,
}) {
  if (!isRelease) return;
  final values = {
    'API_BASE_URL': apiBaseUrl,
    'CONTENT_BASE_URL': contentBaseUrl,
    'REEL_CATALOG_URL': reelCatalogUrl,
  };
  for (final MapEntry(key: name, value: value) in values.entries) {
    final uri = Uri.tryParse(value);
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        _isLocalHost(uri.host)) {
      throw StateError(
        '$name release derlemesinde kimlik bilgisi içermeyen genel bir HTTPS '
        'adresi olmalı.',
      );
    }
  }
}

bool _isLocalHost(String host) {
  final h = host.toLowerCase();
  if (h == 'localhost' ||
      h.endsWith('.localhost') ||
      h.endsWith('.local') ||
      h == '::1' ||
      h == '0.0.0.0' ||
      h.startsWith('127.') ||
      h.startsWith('10.') ||
      h.startsWith('192.168.')) {
    return true;
  }
  final parts = h.split('.');
  if (parts.length == 4) {
    final first = int.tryParse(parts[0]);
    final second = int.tryParse(parts[1]);
    if (first == 172 && second != null && second >= 16 && second <= 31) {
      return true;
    }
    if (first == 169 && second == 254) return true;
  }
  return false;
}
