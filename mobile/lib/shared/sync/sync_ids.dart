import 'package:uuid/uuid.dart';

/// Eşitleme kimlikleri (H-038; backend `Uuids`, README "Eşitleme kuralları").
///
/// - Doğal anahtarlı tablolarda kimlik her cihazda aynıdır:
///   `UUIDv5(syncNamespace, "<tablo>:<anahtar1>|<anahtar2>…")`.
/// - Cevap, öğrenme olayı ve "Söyle" sonucu cihazın verdiği UUID'yle tekildir.
abstract final class SyncIds {
  /// Backend `Uuids.SYNC_NAMESPACE` ile aynı.
  static const syncNamespace = '6f1b8f1e-3c55-5d7a-9a43-6869566c7a6e';

  static const _uuid = Uuid();

  /// RFC 9562 UUIDv5 (SHA-1): aynı ad her yerde aynı kimliği verir.
  static String v5(String name) => _uuid.v5(syncNamespace, name);

  /// Doğal anahtardan satır kimliği: `"<tablo>:<k1>|<k2>…"`.
  static String natural(String table, List<Object> keys) =>
      v5('$table:${keys.map((k) => '$k').join('|')}');

  /// Rastgele UUIDv4 (cevap, olay, "Söyle" sonucu).
  static String v4() => _uuid.v4();

  /// Kartın kimliği (defterdeki ifadenin anahtarından).
  static String card(String itemKey) => natural('review_cards', [itemKey]);

  /// Cevabın kimliği: backend `/review/rate` kuralıyla aynı
  /// (`"review_logs:<kart>|<Instant>|<not>"`). Aynı cevap iki yoldan gelse de
  /// tek kayıt olur.
  static String reviewLog(
    String cardClientId,
    DateTime reviewedAt,
    int rating,
  ) => v5('review_logs:$cardClientId|${javaInstant(reviewedAt)}|$rating');

  /// Eski (şema 4) öğrenme olayı kimliği 32 onaltılık karakterdir; tireli
  /// UUID biçimine çevrilir (aynı değer). Başka biçimdeyse ondan UUIDv5.
  static String fromLegacyEventId(String id) {
    final hex = id.toLowerCase();
    if (RegExp(r'^[0-9a-f]{32}$').hasMatch(hex)) {
      return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
          '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
          '${hex.substring(20)}';
    }
    if (isUuid(hex)) return hex;
    return v5('learning_events:$id');
  }

  static bool isUuid(String s) => RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  ).hasMatch(s);
}

/// Java `Instant.toString()` biçimi (ISO_INSTANT): kesir yoksa yazılmaz,
/// varsa 3 ya da 6 hane. Ör. `2026-10-13T09:05:00Z`, `…:00.120Z`.
String javaInstant(DateTime t) {
  final u = t.toUtc();
  String two(int v) => v.toString().padLeft(2, '0');
  final base =
      '${u.year.toString().padLeft(4, '0')}-${two(u.month)}-${two(u.day)}'
      'T${two(u.hour)}:${two(u.minute)}:${two(u.second)}';
  final micros = u.millisecond * 1000 + u.microsecond;
  if (micros == 0) return '${base}Z';
  if (micros % 1000 == 0) {
    return '$base.${u.millisecond.toString().padLeft(3, '0')}Z';
  }
  return '$base.${micros.toString().padLeft(6, '0')}Z';
}
