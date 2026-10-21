import '../../../shared/storage/app_database.dart';
import '../domain/daily_reminder.dart';

/// Günlük hatırlatma ayarı (H-042): `app_meta` tablosunda, yalnızca bu
/// cihazda. Eşitlenmez; şema değişmez.
class ReminderStore {
  ReminderStore(this._db, {Future<void>? ready})
    : _ready = ready ?? Future<void>.value();

  final AppDatabase _db;
  final Future<void> _ready;

  static const enabledKey = 'reminder.enabled';
  static const timeKey = 'reminder.time';

  Future<String?> _meta(String key) async => (await (_db.select(
    _db.appMeta,
  )..where((t) => t.key.equals(key))).getSingleOrNull())?.value;

  Future<ReminderSettings> read() async {
    await _ready;
    final enabled = await _meta(enabledKey) == '1';
    final time = ReminderSettings.parseTime(await _meta(timeKey));
    return ReminderSettings(
      enabled: enabled,
      hour: time?.$1 ?? ReminderSettings.defaultHour,
      minute: time?.$2 ?? ReminderSettings.defaultMinute,
    );
  }

  Future<void> write(ReminderSettings s) async {
    await _ready;
    await _db.batch(
      (b) => b.insertAllOnConflictUpdate(_db.appMeta, [
        AppMetaCompanion.insert(key: enabledKey, value: s.enabled ? '1' : '0'),
        AppMetaCompanion.insert(key: timeKey, value: s.timeLabel),
      ]),
    );
  }

  /// "Bu telefondaki verileri sil": ayar da silinir (varsayılan: kapalı).
  Future<void> clear() async {
    await _ready;
    await (_db.delete(
      _db.appMeta,
    )..where((t) => t.key.isIn([enabledKey, timeKey]))).go();
  }
}
