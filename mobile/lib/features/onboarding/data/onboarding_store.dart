import 'package:drift/drift.dart';

import '../../../shared/storage/app_database.dart';

/// Açılışın (H-039) cihazdaki kayıtları (`app_meta`; eşitlenmez, sunucuya
/// gitmez):
/// - açılış bitti mi (bir kez gösterilir);
/// - doğum yılı (yalnızca yıl; H-002, H-009);
/// - yerleştirme testinin önerdiği seviye (yalnızca bilgi; K-06).
class OnboardingStore {
  OnboardingStore(this._db, {Future<void>? ready, DateTime Function()? clock})
    : _ready = ready ?? Future<void>.value(),
      _clock = clock ?? (() => DateTime.now().toUtc());

  final AppDatabase _db;
  final Future<void> _ready;
  final DateTime Function() _clock;

  static const completedKey = 'onboarding.completedAt';
  static const noticeVersionKey = 'onboarding.noticeVersion';
  static const birthYearKey = 'profile.birthYear';
  static const suggestedLevelKey = 'placement.suggestedLevel';

  Future<String?> _meta(String key) async => (await (_db.select(
    _db.appMeta,
  )..where((t) => t.key.equals(key))).getSingleOrNull())?.value;

  Future<void> _setMeta(String key, String value) => _db
      .into(_db.appMeta)
      .insertOnConflictUpdate(AppMetaCompanion.insert(key: key, value: value));

  /// Açılış gösterilmeli mi? Bitmişse hayır. Bu cihazda daha önce kullanım
  /// varsa (H-039 öncesi kullanıcı) açılış bitmiş sayılır ve işaretlenir;
  /// bir kez yazılır, tekrar çağrı bir şey değiştirmez.
  Future<bool> needsOnboarding() async {
    await _ready;
    if (await _meta(completedKey) != null) return false;
    if (await hasExistingUsage()) {
      await markCompleted();
      return false;
    }
    return true;
  }

  /// Bölüm ilerlemesi, defter, öğrenme olayı, izlenmiş jenerik, hesap ya da
  /// Profil'de değiştirilmiş ayar varsa `true`.
  Future<bool> hasExistingUsage() async {
    final row = await _db
        .customSelect(
          'SELECT '
          '(SELECT count(*) FROM user_story_progress) + '
          '(SELECT count(*) FROM notebook_items) + '
          '(SELECT count(*) FROM learning_events) + '
          '(SELECT count(*) FROM season_state WHERE intro_seen = 1) + '
          '(SELECT count(*) FROM sync_state WHERE account_user_id IS NOT NULL) + '
          "(SELECT count(*) FROM app_meta WHERE key IN ('profile.displayName', "
          "'settings.dailyGoalMinutes')) AS n",
          readsFrom: {
            _db.userStoryProgress,
            _db.notebookItems,
            _db.learningEvents,
            _db.seasonState,
            _db.syncState,
            _db.appMeta,
          },
        )
        .getSingle();
    return row.read<int>('n') > 0;
  }

  /// İlk bitiş anı kalır (tekrar çağrı üzerine yazmaz).
  Future<void> markCompleted() async {
    await _ready;
    await _db
        .into(_db.appMeta)
        .insert(
          AppMetaCompanion.insert(
            key: completedKey,
            value: _clock().toIso8601String(),
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  /// Açılışı yeniden göstermek için (testler ve debug). Girilen bilgiler
  /// (doğum yılı, ad, ayarlar) silinmez.
  Future<void> reset() async {
    await _ready;
    await (_db.delete(
      _db.appMeta,
    )..where((t) => t.key.equals(completedKey))).go();
  }

  Future<int?> birthYear() async {
    await _ready;
    return int.tryParse(await _meta(birthYearKey) ?? '');
  }

  Future<void> setBirthYear(int year) async {
    await _ready;
    await _setMeta(birthYearKey, '$year');
  }

  /// Okunan bilgilendirme metninin sürümü (yalnızca cihazda).
  Future<void> setNoticeVersion(String version) async {
    await _ready;
    await _setMeta(noticeVersionKey, version);
  }

  Future<String?> suggestedLevel() async {
    await _ready;
    return _meta(suggestedLevelKey);
  }

  Future<void> setSuggestedLevel(String code) async {
    await _ready;
    await _setMeta(suggestedLevelKey, code);
  }
}
