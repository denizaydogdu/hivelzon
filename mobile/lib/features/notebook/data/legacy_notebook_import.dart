import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../../shared/meaning/learning_event_log.dart';
import '../../../shared/meaning/notebook_repository.dart';
import '../../../shared/storage/app_database.dart';
import '../../../shared/storage/legacy_prefs_import.dart';
import 'notebook_store.dart';

/// H-046 `shared_preferences` defteri ve öğrenme olayları → Drift, bir kez (H-036).
///
/// Taşınanlar: `notebook.items` (her biri FSRS kartıyla, kaynak `user_saved`)
/// ve `learning.events` (eşitleme kimliği belirlenimci: aynı olay iki kez
/// yazılmaz). İdempotent: `app_meta` işareti varsa hiçbir şey yapılmaz; işaret
/// ve kayıtlar aynı işlemde yazılır. Eski anahtarlar silinmez (dal geri
/// alınırsa eski sürüm veriyi yine bulur).
class LegacyNotebookImport {
  LegacyNotebookImport(this._db, this._source, {DateTime Function()? clock})
    : _clock = clock ?? (() => DateTime.now().toUtc());

  static const markerKey = 'migration.sharedPrefs.notebook.v1';
  static const notebookKey = 'notebook.items';
  static const eventsKey = 'learning.events';

  final AppDatabase _db;
  final LegacyKeyValueSource _source;
  final DateTime Function() _clock;

  /// Taşındıysa `true`; işaret zaten varsa `false`.
  Future<bool> run() async {
    final done = await (_db.select(
      _db.appMeta,
    )..where((t) => t.key.equals(markerKey))).getSingleOrNull();
    if (done != null) return false;
    final items = <SavedPhrase>[];
    final events = <LearningEvent>[];
    final keys = await _source.keys();
    if (keys.contains(notebookKey)) {
      for (final j in _list(await _source.getString(notebookKey))) {
        try {
          items.add(SavedPhrase.fromJson(j));
        } on Object {
          // Bozuk kayıt atlanır.
        }
      }
    }
    if (keys.contains(eventsKey)) {
      for (final j in _list(await _source.getString(eventsKey))) {
        try {
          events.add(LearningEvent.fromJson(j));
        } on Object {
          // Bozuk kayıt atlanır.
        }
      }
    }
    final store = NotebookStore(_db, clock: _clock);
    var added = 0;
    await _db.transaction(() async {
      added = await store.addItems([for (final i in items) i.toItem()]);
      for (final (n, e) in events.indexed) {
        await _db
            .into(_db.learningEvents)
            .insert(
              LearningEventsCompanion.insert(
                clientEventId:
                    'legacy-$n-${e.at.toUtc().microsecondsSinceEpoch}',
                contentId: e.contentId,
                sourceId: e.sourceId,
                target: e.target,
                at: e.at.toUtc(),
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }
      await _db
          .into(_db.appMeta)
          .insert(
            AppMetaCompanion.insert(
              key: markerKey,
              value:
                  'items=$added/${items.length} events=${events.length} '
                  'at=${_clock().toUtc().toIso8601String()}',
            ),
            mode: InsertMode.insertOrIgnore,
          );
    });
    debugPrint(
      '[H036] shared_preferences → Drift: $added defter kaydı, '
      '${events.length} öğrenme olayı',
    );
    return true;
  }

  static List<Map<String, dynamic>> _list(String? raw) {
    if (raw == null) return const [];
    try {
      return [
        for (final e in jsonDecode(raw) as List)
          if (e is Map) e.cast<String, dynamic>(),
      ];
    } on Object {
      return const [];
    }
  }
}
