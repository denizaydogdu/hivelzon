import 'package:drift/drift.dart';

import '../storage/app_database.dart';
import '../sync/sync_ids.dart';

/// Günlük ölçülen süre (Drift `daily_activity`, H-074). Yalnızca günlük toplam
/// saniye tutulur; cihaz dışına yalnızca hesap açıkken (eşitleme) çıkar.
class DailyActivityStore {
  DailyActivityStore(this._db, {Future<void>? ready})
    : _ready = ready ?? Future<void>.value();

  final AppDatabase _db;
  final Future<void> _ready;

  /// Bu kurulumun rastgele kaynak kimliği (UUIDv4). Eşitleme `deviceId`'sinden
  /// ayrıdır; yalnızca iki cihazın aynı gündeki süresini ayrı tutmaya yarar.
  static const sourceIdKey = 'activity.sourceId';

  /// Gerçek ölçümün başladığı an (UTC, ISO-8601). Bundan önceki etkinlik
  /// halkada eski tahminle sayılır (geçiş, H-074).
  static const measuredSinceKey = 'activity.measuredSince';

  /// Bir günde sayılabilecek en uzun süre.
  static const maxSecondsPerDay = 86400;

  String? _sourceId;
  bool _sinceMarked = false;

  Future<String?> _meta(String key) async => (await (_db.select(
    _db.appMeta,
  )..where((t) => t.key.equals(key))).getSingleOrNull())?.value;

  Future<void> _setMetaOnce(String key, String value) => _db
      .into(_db.appMeta)
      .insert(
        AppMetaCompanion.insert(key: key, value: value),
        mode: InsertMode.insertOrIgnore,
      );

  Future<String> sourceId() async {
    final cached = _sourceId;
    if (cached != null) return cached;
    await _ready;
    var id = await _meta(sourceIdKey);
    if (id == null) {
      await _setMetaOnce(sourceIdKey, SyncIds.v4());
      id = (await _meta(sourceIdKey))!;
    }
    return _sourceId = id;
  }

  Future<DateTime?> measuredSince() async {
    await _ready;
    return DateTime.tryParse(await _meta(measuredSinceKey) ?? '')?.toUtc();
  }

  /// İlk ölçümün anı bir kez yazılır (sonraki çağrılar bir şey değiştirmez).
  Future<void> markMeasuredSince(DateTime at) async {
    if (_sinceMarked) return;
    await _ready;
    await _setMetaOnce(measuredSinceKey, at.toUtc().toIso8601String());
    _sinceMarked = true;
  }

  /// Ölçülen süreyi bu kaynağın gün satırına ekler (tek işlem; ekleme
  /// SQLite'ta atomik yapılır).
  Future<void> addSeconds(Map<String, int> secondsByDay, DateTime now) async {
    if (secondsByDay.isEmpty) return;
    final source = await sourceId();
    await _db.transaction(() async {
      for (final MapEntry(key: day, value: s) in secondsByDay.entries) {
        if (s <= 0) continue;
        await _db.customInsert(
          'INSERT INTO daily_activity (day, source_id, active_seconds, '
          'updated_at) VALUES (?, ?, ?, ?) '
          'ON CONFLICT (day, source_id) DO UPDATE SET active_seconds = '
          'MIN($maxSecondsPerDay, daily_activity.active_seconds + '
          'excluded.active_seconds), updated_at = excluded.updated_at',
          variables: [
            Variable.withString(day),
            Variable.withString(source),
            Variable.withInt(s > maxSecondsPerDay ? maxSecondsPerDay : s),
            Variable<DateTime>(now.toUtc()),
          ],
          updates: {_db.dailyActivity},
        );
      }
    });
  }

  /// O gün bütün kaynaklarda (bu cihaz + eşitlenen öteki cihazlar) ölçülen
  /// toplam süre (sn).
  Future<int> secondsOn(String day) async {
    await _ready;
    final row = await _db
        .customSelect(
          'SELECT COALESCE(SUM(active_seconds), 0) AS s FROM daily_activity '
          'WHERE day = ?',
          variables: [Variable.withString(day)],
          readsFrom: {_db.dailyActivity},
        )
        .getSingle();
    return row.read<int>('s');
  }
}
