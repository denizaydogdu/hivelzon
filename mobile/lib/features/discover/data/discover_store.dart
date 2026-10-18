import 'package:drift/drift.dart';

import '../../../shared/storage/app_database.dart';
import '../domain/feed.dart';

/// Keşfet'in cihazdaki kaydı (H-040; `app_meta`, eşitlenmez, sunucuya
/// gitmez): bugünkü izleme süresi (saniye). Anahtar yerel güne bağlıdır
/// (`discover.watch.2026-10-14`); yerel gece yarısında yeni gün başlar, eski
/// günlerin kaydı yazarken silinir.
class DiscoverStore {
  DiscoverStore(this._db);

  final AppDatabase _db;
  static const prefix = 'discover.watch.';

  static String keyFor(DateTime now) => '$prefix${localDayKey(now)}';

  Future<int> watchedSeconds(DateTime now) async {
    final row = await (_db.select(
      _db.appMeta,
    )..where((t) => t.key.equals(keyFor(now)))).getSingleOrNull();
    return int.tryParse(row?.value ?? '') ?? 0;
  }

  /// Bugünün sayacına [seconds] ekler; toplamı döndürür. Tek işlemde okunur
  /// ve yazılır (eşzamanlı eklemeler kaybolmaz); eski günler silinir.
  Future<int> addSeconds(DateTime now, int seconds) async {
    if (seconds <= 0) return watchedSeconds(now);
    final key = keyFor(now);
    return _db.transaction(() async {
      final current = await watchedSeconds(now);
      final total = current + seconds;
      await _db
          .into(_db.appMeta)
          .insertOnConflictUpdate(
            AppMetaCompanion.insert(key: key, value: '$total'),
          );
      await (_db.delete(
        _db.appMeta,
      )..where((t) => t.key.like('$prefix%') & t.key.equals(key).not())).go();
      return total;
    });
  }

  /// Keşfet'in zorluk seviyesi (H-094): kullanıcının elle seçimi. `null`
  /// ise seçim yok, yerleştirmenin önerdiği seviye kullanılır. Yalnızca
  /// Keşfet videolarını etkiler; yerleştirme sonucunu değiştirmez (K-06).
  static const reelLevelKey = 'discover.reel.level';

  Future<String?> reelLevel() async =>
      (await (_db.select(
            _db.appMeta,
          )..where((t) => t.key.equals(reelLevelKey))).getSingleOrNull())
          ?.value;

  /// Seçimi yazar; `null` seçimi siler (önerilen seviyeye dönüş).
  Future<void> setReelLevel(String? level) async {
    if (level == null) {
      await (_db.delete(
        _db.appMeta,
      )..where((t) => t.key.equals(reelLevelKey))).go();
      return;
    }
    await _db
        .into(_db.appMeta)
        .insertOnConflictUpdate(
          AppMetaCompanion.insert(key: reelLevelKey, value: level),
        );
  }
}
