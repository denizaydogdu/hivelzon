import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../shared/storage/app_database.dart';
import '../domain/daily_set.dart';
import '../domain/discover_prefs.dart';
import '../domain/feed.dart';
import '../domain/reel_progress.dart';

/// Keşfet'in cihazdaki kaydı (H-040; H-094 P2). Hepsi `app_meta` içinde
/// tutulur, eşitlenmez ve sunucuya gitmez; en az veri ilkesi (plan §5):
///
/// - `discover.watch.<gün>` → bugünkü izleme saniyesi; yerel gece yarısında
///   yeni gün başlar, eski günler yazarken silinir.
/// - `discover.daily.<gün>` → günün seçkisi `{version, level, prefsSnapshot,
///   items:[{id, contentVersion}]}`; gün içinde **kararlıdır**.
/// - `discover.reel.<id>` → `{contentVersion, watchedSeconds, completed,
///   lastShownDay, practiceResult?}`; **öğrenme kanıtı değildir**.
/// - `discover.prefs` → kategoriler + seviye geçersiz kılma.
class DiscoverStore {
  DiscoverStore(this._db);

  final AppDatabase _db;
  static const prefix = 'discover.watch.';
  static const dailyPrefix = 'discover.daily.';
  static const reelPrefix = 'discover.reel.';
  static const resumePrefix = 'discover.resume.';
  static const prefsKey = 'discover.prefs';

  static String keyFor(DateTime now) => '$prefix${localDayKey(now)}';

  static String dailyKeyFor(DateTime now) => '$dailyPrefix${localDayKey(now)}';

  static String reelKeyFor(String id) => '$reelPrefix$id';

  static String resumeKeyFor(DateTime now) =>
      '$resumePrefix${localDayKey(now)}';

  Future<String?> _read(String key) async => (await (_db.select(
    _db.appMeta,
  )..where((t) => t.key.equals(key))).getSingleOrNull())?.value;

  Future<void> _write(String key, String value) => _db
      .into(_db.appMeta)
      .insertOnConflictUpdate(AppMetaCompanion.insert(key: key, value: value));

  Future<int> watchedSeconds(DateTime now) async =>
      int.tryParse(await _read(keyFor(now)) ?? '') ?? 0;

  /// Bugünün sayacına [seconds] ekler; toplamı döndürür. Tek işlemde okunur
  /// ve yazılır (eşzamanlı eklemeler kaybolmaz); eski günler silinir.
  Future<int> addSeconds(DateTime now, int seconds) async {
    if (seconds <= 0) return watchedSeconds(now);
    final key = keyFor(now);
    return _db.transaction(() async {
      final current = await watchedSeconds(now);
      final total = current + seconds;
      await _write(key, '$total');
      await (_db.delete(
        _db.appMeta,
      )..where((t) => t.key.like('$prefix%') & t.key.equals(key).not())).go();
      return total;
    });
  }

  // --- Tercihler (plan §5) ---------------------------------------------------

  /// Kategoriler + seviye geçersiz kılma. Bozuk kayıt varsayılana döner.
  Future<DiscoverPrefs> prefs() async {
    final raw = await _read(prefsKey);
    if (raw == null || raw.isEmpty) return const DiscoverPrefs();
    try {
      return DiscoverPrefs.fromJson(jsonDecode(raw));
    } on Object {
      return const DiscoverPrefs();
    }
  }

  Future<void> setPrefs(DiscoverPrefs prefs) =>
      _write(prefsKey, jsonEncode(prefs.toJson()));

  /// Keşfet'in zorluk seviyesi (H-094): kullanıcının elle seçimi. `null`
  /// ise seçim yok, yerleştirmenin önerdiği seviye kullanılır. Yalnızca
  /// Keşfet videolarını etkiler; yerleştirme sonucunu değiştirmez (K-06).
  static const reelLevelKey = prefsKey;

  Future<String?> reelLevel() async => (await prefs()).level;

  /// Seçimi yazar; `null` seçimi siler (önerilen seviyeye dönüş).
  Future<void> setReelLevel(String? level) async {
    final current = await prefs();
    await setPrefs(
      level == null
          ? current.copyWith(clearLevel: true)
          : current.copyWith(level: level),
    );
  }

  /// Günlük seçkide dağıtılacak kategoriler.
  Future<void> setReelCategories(List<String> categories) async {
    final current = await prefs();
    await setPrefs(
      current.copyWith(
        categories: categories.isEmpty ? kDefaultReelCategories : categories,
      ),
    );
  }

  // --- Günlük seçki (plan §5) -------------------------------------------------

  /// Bugünün seçkisi; yoksa `null` (çağıran seçip yazar).
  Future<DailySet?> dailySet(DateTime now) async {
    final raw = await _read(dailyKeyFor(now));
    if (raw == null || raw.isEmpty) return null;
    try {
      return DailySet.fromJson(jsonDecode(raw));
    } on Object {
      return null;
    }
  }

  /// Günün seçkisini yazar; **eski günlerin seçkisi silinir** (en az veri).
  Future<void> setDailySet(DateTime now, DailySet set) async {
    final key = dailyKeyFor(now);
    await _db.transaction(() async {
      await _write(key, jsonEncode(set.toJson()));
      await (_db.delete(_db.appMeta)..where(
            (t) => t.key.like('$dailyPrefix%') & t.key.equals(key).not(),
          ))
          .go();
    });
  }

  // --- Aynı gün kalınan yer (plan §5) ----------------------------------------

  /// Aynı gün en son açılan video (günlük set); yoksa `null` (baştan).
  Future<String?> resumeId(DateTime now) async {
    final v = await _read(resumeKeyFor(now));
    return v == null || v.isEmpty ? null : v;
  }

  /// Kalınan videoyu yazar; eski günlerin kaydı silinir (en az veri).
  Future<void> setResumeId(DateTime now, String? id) async {
    final key = resumeKeyFor(now);
    await _db.transaction(() async {
      if (id == null || id.isEmpty) {
        await (_db.delete(_db.appMeta)..where((t) => t.key.equals(key))).go();
      } else {
        await _write(key, id);
      }
      await (_db.delete(_db.appMeta)..where(
            (t) => t.key.like('$resumePrefix%') & t.key.equals(key).not(),
          ))
          .go();
    });
  }

  // --- Reel ilerlemesi (plan §5) ---------------------------------------------
  /// Bütün reel ilerlemeleri (seçim önceliği bunu okur).
  Future<Map<String, ReelProgress>> allReelProgress() async {
    final rows = await (_db.select(
      _db.appMeta,
    )..where((t) => t.key.like('$reelPrefix%'))).get();
    final out = <String, ReelProgress>{};
    for (final row in rows) {
      final id = row.key.substring(reelPrefix.length);
      if (id.isEmpty) continue;
      final progress = _decodeProgress(row.value);
      if (progress != null) out[id] = progress;
    }
    return out;
  }

  Future<ReelProgress?> reelProgress(String id) async =>
      _decodeProgress(await _read(reelKeyFor(id)));

  /// İlerlemeyi **birleştirir** (plan §5): içerik sürümü değişirse eski
  /// saniye/sonuç taşınmaz; saniye eklenir, `completed` doğruya döner,
  /// gösterim günü en yenisi olur.
  Future<ReelProgress> mergeProgress(
    String id, {
    required int contentVersion,
    int addSeconds = 0,
    bool completed = false,
    String? shownDay,
    PracticeResult? practiceResult,
  }) async {
    final key = reelKeyFor(id);
    return _db.transaction(() async {
      final current = _decodeProgress(await _read(key));
      final next = mergeReelProgress(
        current,
        contentVersion: contentVersion,
        addSeconds: addSeconds,
        completed: completed,
        shownDay: shownDay,
        practiceResult: practiceResult,
      );
      await _write(key, jsonEncode(next.toJson()));
      return next;
    });
  }

  ReelProgress? _decodeProgress(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return ReelProgress.fromJson(jsonDecode(raw));
    } on Object {
      return null;
    }
  }
}
