import 'package:drift/drift.dart';

import '../storage/app_database.dart';
import 'speech_match.dart';

/// "Söyle" alıştırmasının yeri.
enum SpeechPlace {
  /// Kelime tekrarında "Dinle ve söyle".
  review('review'),

  /// Anlam panelinde "Sen de söyle".
  meaning('meaning'),

  /// Karar anında "Söyleyerek seç".
  decision('decision'),

  /// Bölüm sonunda "Hedef ifadeleri söyle".
  episodeEnd('episode_end');

  const SpeechPlace(this.code);

  final String code;

  static SpeechPlace? parse(String v) =>
      values.where((p) => p.code == v).firstOrNull;
}

/// Kaydedilen tek sonuç: **transkript ve ses alanı yoktur** (H-055).
class SpeechAttempt {
  const SpeechAttempt({
    required this.place,
    required this.itemRef,
    required this.level,
    required this.at,
    this.contentId,
    this.missingCount = 0,
    this.errorNoteId,
  });

  final SpeechPlace place;
  final String? contentId;

  /// Beklenen ifade (içerikteki metin) ya da karar seçeneği (`k1#a`).
  final String itemRef;
  final SpeechMatchLevel level;
  final int missingCount;
  final String? errorNoteId;

  /// UTC.
  final DateTime at;
}

/// "Söyle" ayarı ve sonuç kaydı (Drift `speech_attempts`, `app_meta`).
/// Yalnızca bu cihazda; sunucuya gitmez.
class SpeechStore {
  SpeechStore(this._db, {Future<void>? ready, DateTime Function()? clock})
    : _ready = ready ?? Future<void>.value(),
      _clock = clock ?? (() => DateTime.now().toUtc());

  final AppDatabase _db;
  final Future<void> _ready;
  final DateTime Function() _clock;

  static const enabledKey = 'speech.enabled';
  static const permissionAskedKey = 'speech.permissionAsked';

  DateTime now() => _clock().toUtc();

  Future<String?> _meta(String key) async {
    await _ready;
    return (await (_db.select(
      _db.appMeta,
    )..where((t) => t.key.equals(key))).getSingleOrNull())?.value;
  }

  Future<void> _setMeta(String key, String value) async {
    await _ready;
    await _db
        .into(_db.appMeta)
        .insertOnConflictUpdate(
          AppMetaCompanion.insert(key: key, value: value),
        );
  }

  /// Profil'deki aç/kapat; varsayılan açık (cihaz destekliyorsa).
  Future<bool> enabled() async => await _meta(enabledKey) != '0';

  Future<void> setEnabled(bool on) => _setMeta(enabledKey, on ? '1' : '0');

  /// Sistem izni bir kez soruldu mu (Android'de "sorulmadı" ile "reddedildi"
  /// ayrılamaz; sorulmuş ve izin yoksa reddedilmiş sayılır).
  Future<bool> permissionAsked() async =>
      await _meta(permissionAskedKey) == '1';

  Future<void> markPermissionAsked() => _setMeta(permissionAskedKey, '1');

  Future<void> record(SpeechAttempt a) async {
    await _ready;
    await _db
        .into(_db.speechAttempts)
        .insert(
          SpeechAttemptsCompanion.insert(
            place: a.place.code,
            contentId: Value(a.contentId),
            itemRef: a.itemRef,
            matchLevel: a.level.code,
            missingCount: Value(a.missingCount),
            errorNoteId: Value(a.errorNoteId),
            at: a.at.toUtc(),
          ),
        );
  }

  Future<List<SpeechAttempt>> attempts() async {
    await _ready;
    final rows = await (_db.select(
      _db.speechAttempts,
    )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
    return [
      for (final r in rows)
        SpeechAttempt(
          place: SpeechPlace.parse(r.place) ?? SpeechPlace.review,
          contentId: r.contentId,
          itemRef: r.itemRef,
          level: SpeechMatchLevel.parse(r.matchLevel),
          missingCount: r.missingCount,
          errorNoteId: r.errorNoteId,
          at: r.at.toUtc(),
        ),
    ];
  }
}
