import '../../../shared/storage/app_database.dart';

/// Kullanıcının seslenme adı (H-053): yalnızca ilk ad ya da takma ad, yalnızca
/// bu cihazda (`app_meta`). Hesap açılınca (H-038) hesaba taşınır. KVKK: en az
/// veri; boş bırakılabilir.
class UserProfileStore {
  UserProfileStore(this._db, {Future<void>? ready})
    : _ready = ready ?? Future<void>.value();

  final AppDatabase _db;
  final Future<void> _ready;

  static const displayNameKey = 'profile.displayName';
  static const maxNameLength = 20;

  Future<String?> displayName() async {
    await _ready;
    final row = await (_db.select(
      _db.appMeta,
    )..where((t) => t.key.equals(displayNameKey))).getSingleOrNull();
    final v = row?.value.trim();
    return v == null || v.isEmpty ? null : v;
  }

  /// Boş ad kaydı siler. Geçersiz adda [ArgumentError] (arayüz önce
  /// [validateDisplayName] ile denetler).
  Future<void> setDisplayName(String? raw) async {
    await _ready;
    final name = normalizeDisplayName(raw ?? '');
    if (name == null) {
      await (_db.delete(
        _db.appMeta,
      )..where((t) => t.key.equals(displayNameKey))).go();
      return;
    }
    final error = validateDisplayName(name);
    if (error != null) throw ArgumentError.value(raw, 'name', error.name);
    await _db
        .into(_db.appMeta)
        .insertOnConflictUpdate(
          AppMetaCompanion.insert(key: displayNameKey, value: name),
        );
  }
}

/// Baştaki/sondaki boşluk atılır, aradaki boşluklar teke iner; boşsa `null`.
String? normalizeDisplayName(String raw) {
  final v = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
  return v.isEmpty ? null : v;
}

enum DisplayNameError { tooLong, invalidCharacters }

final _allowed = RegExp(r"^[\p{L}\p{M}][\p{L}\p{M} '’\-.]*$", unicode: true);

/// Ad kuralı: en fazla 20 karakter; harf, boşluk, kesme işareti, tire, nokta.
/// Boş ad geçerlidir (isteğe bağlı alan).
DisplayNameError? validateDisplayName(String raw) {
  final v = normalizeDisplayName(raw);
  if (v == null) return null;
  if (v.runes.length > UserProfileStore.maxNameLength) {
    return DisplayNameError.tooLong;
  }
  if (!_allowed.hasMatch(v)) return DisplayNameError.invalidCharacters;
  return null;
}
