import 'dart:convert';
import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../storage/app_database.dart';
import '../storage/storage_providers.dart';
import '../sync/sync_ids.dart';
import 'error_taxonomy.dart';

/// Kullanıcının bir kelimeye ya da cümlenin Türkçesine baktığı an (H-046).
///
/// Yalnızca öğrenme sinyalidir: bakmak puan düşürmez, uyarı göstermez (K-32).
class LearningEvent {
  const LearningEvent({
    required this.contentId,
    required this.sourceId,
    required this.target,
    required this.at,
    this.errorType,
    this.clientEventId,
  });

  factory LearningEvent.fromJson(Map<String, dynamic> j) => LearningEvent(
    contentId: j['contentId'] as String,
    sourceId: j['sourceId'] as String,
    target: j['target'] as String,
    at: DateTime.parse(j['at'] as String),
    errorType: ErrorType.parse(j['errorType'] as String?),
  );

  /// Cümlenin tamamına bakıldıysa [target] bu değerdir.
  static const sentence = 'sentence';

  final String contentId;

  /// Altyazı ipucu kimliği (`s02-03`) ya da kart satırı (`c-note#0`).
  final String sourceId;

  /// Bakılan kelime ya da [sentence].
  final String target;

  /// UTC.
  final DateTime at;

  /// Hata türü (sürüm [kErrorTaxonomyVersion]); bakmak hata değildir: null.
  final ErrorType? errorType;

  /// Eşitleme kimliği (H-038); kaydedilirken üretilir.
  final String? clientEventId;

  Map<String, dynamic> toJson() => {
    'contentId': contentId,
    'sourceId': sourceId,
    'target': target,
    'at': at.toUtc().toIso8601String(),
    if (errorType != null) 'errorType': errorType!.code,
  };
}

/// Öğrenme olayları kaydı. Yerelde Drift `learning_events` (H-036); sunucuya
/// eşitleme H-038'de.
abstract interface class LearningEventLog {
  Future<void> record(LearningEvent event);

  Future<List<LearningEvent>> recent();
}

/// Rastgele eşitleme kimliği (128 bit, onaltılık).
String newClientEventId([math.Random? random]) {
  final r = random ?? math.Random.secure();
  return [
    for (var i = 0; i < 16; i++)
      r.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ].join();
}

/// Drift deposu (H-036). [ready]: eski kayıtların taşınması.
class DriftLearningEventLog implements LearningEventLog {
  DriftLearningEventLog(this._db, {Future<void>? ready, this.recentLimit = 500})
    : _ready = ready ?? Future<void>.value();

  final AppDatabase _db;
  final Future<void> _ready;
  final int recentLimit;

  @override
  Future<void> record(LearningEvent event) async {
    await _ready;
    final eventId = event.clientEventId ?? newClientEventId();
    await _db
        .into(_db.learningEvents)
        .insert(
          LearningEventsCompanion.insert(
            clientEventId: eventId,
            // H-038: eşitleme kimliği = olay kimliğinin UUID biçimi.
            clientId: Value(SyncIds.fromLegacyEventId(eventId)),
            contentId: event.contentId,
            sourceId: event.sourceId,
            target: event.target,
            at: event.at.toUtc(),
            errorType: Value(event.errorType?.code),
            errorTaxonomyVersion: Value(
              event.errorType == null ? null : kErrorTaxonomyVersion,
            ),
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  @override
  Future<List<LearningEvent>> recent() async {
    await _ready;
    final rows =
        await (_db.select(_db.learningEvents)
              ..orderBy([(t) => OrderingTerm.desc(t.id)])
              ..limit(recentLimit))
            .get();
    return [
      for (final r in rows.reversed)
        LearningEvent(
          contentId: r.contentId,
          sourceId: r.sourceId,
          target: r.target,
          at: r.at.toUtc(),
          errorType: ErrorType.parse(r.errorType),
          clientEventId: r.clientEventId,
        ),
    ];
  }

  /// Bir bölümde bakılan kelimeler (hata olmayan olaylar).
  Future<List<LearningEvent>> lookupsFor(String contentId) async {
    await _ready;
    final rows =
        await (_db.select(_db.learningEvents)
              ..where(
                (t) => t.contentId.equals(contentId) & t.errorType.isNull(),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.id)]))
            .get();
    return [
      for (final r in rows)
        LearningEvent(
          contentId: r.contentId,
          sourceId: r.sourceId,
          target: r.target,
          at: r.at.toUtc(),
          clientEventId: r.clientEventId,
        ),
    ];
  }
}

class InMemoryLearningEventLog implements LearningEventLog {
  final List<LearningEvent> events = [];

  @override
  Future<void> record(LearningEvent event) async => events.add(event);

  @override
  Future<List<LearningEvent>> recent() async => List.of(events);
}

/// `shared_preferences` üzerinde en fazla [maxEvents] olay tutar (H-046).
/// H-036'dan beri yalnızca eski kayıtların okunması (taşıma) için.
class SharedPrefsLearningEventLog implements LearningEventLog {
  SharedPrefsLearningEventLog({
    SharedPreferencesAsync? prefs,
    this.maxEvents = 500,
  }) : _prefs = prefs ?? SharedPreferencesAsync();

  static const _key = 'learning.events';
  final SharedPreferencesAsync _prefs;
  final int maxEvents;

  @override
  Future<void> record(LearningEvent event) async {
    final list = await _load();
    list.add(event.toJson());
    final trimmed = list.length > maxEvents
        ? list.sublist(list.length - maxEvents)
        : list;
    await _prefs.setString(_key, jsonEncode(trimmed));
  }

  @override
  Future<List<LearningEvent>> recent() async => [
    for (final j in await _load()) LearningEvent.fromJson(j),
  ];

  Future<List<Map<String, dynamic>>> _load() async {
    final raw = await _prefs.getString(_key);
    if (raw == null) return [];
    try {
      return [
        for (final e in jsonDecode(raw) as List)
          (e as Map).cast<String, dynamic>(),
      ];
    } on Object {
      return [];
    }
  }
}

final learningEventLogProvider = Provider<LearningEventLog>(
  (ref) => DriftLearningEventLog(
    ref.watch(appDatabaseProvider),
    ready: ref.watch(legacyImportProvider),
  ),
);
