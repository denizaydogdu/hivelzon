import 'package:drift/drift.dart';

import '../../../shared/storage/app_database.dart';
import '../domain/age.dart';

/// Açılışın (H-039) cihazdaki kayıtları (`app_meta`; eşitlenmez, sunucuya
/// gitmez):
/// - açılış bitti mi (bir kez gösterilir);
/// - doğum yılı **saklanmaz** (veri minimizasyonu, kullanıcı kararı 2026-10-14):
///   13–17 için yalnızca 18 yaşına girilen yıl tutulur; 13 altı için hesap
///   kapısının yılı [AgeGate]'tedir; 18+ için yaşa dair kayıt yoktur;
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
  static const adultFromYearKey = 'profile.adultFromYear';

  /// H-039'un ilk sürümünün yazdığı anahtar; artık yazılmaz, görülünce silinir.
  static const legacyBirthYearKey = 'profile.birthYear';
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
  /// (yaş eşiği, ad, ayarlar) silinmez.
  Future<void> reset() async {
    await _ready;
    await (_db.delete(
      _db.appMeta,
    )..where((t) => t.key.equals(completedKey))).go();
  }

  /// 18 yaşına girilen yıl (yalnızca 13–17 için kayıtlı; yoksa `null`).
  Future<int?> adultFromYear() async {
    await _ready;
    return int.tryParse(await _meta(adultFromYearKey) ?? '');
  }

  /// Doğum yılından yalnızca henüz geçmemiş eşik saklanır; yıl kendisi
  /// yazılmaz. Tekrar çağrı aynı sonucu verir; eski doğum yılı kaydı silinir.
  Future<void> setAgeThresholds(int birthYear, DateTime now) async {
    await _ready;
    final adultFrom = birthYear + adultAge;
    await _db.transaction(() async {
      await (_db.delete(
        _db.appMeta,
      )..where((t) => t.key.isIn([legacyBirthYearKey, adultFromYearKey]))).go();
      if (adultFrom > now.toUtc().year) {
        await _setMeta(adultFromYearKey, '$adultFrom');
      }
    });
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
