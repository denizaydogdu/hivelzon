import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SavedKind { word, phrase, sentence }

/// Deftere eklenen kelime, kalıp ya da cümle (FSRS adayı, K-04).
class SavedPhrase {
  const SavedPhrase({
    required this.contentId,
    required this.sourceId,
    required this.kind,
    required this.en,
    required this.savedAt,
    this.tr,
    this.context,
  });

  factory SavedPhrase.fromJson(Map<String, dynamic> j) => SavedPhrase(
    contentId: j['contentId'] as String,
    sourceId: j['sourceId'] as String,
    kind: SavedKind.values.byName(j['kind'] as String),
    en: j['en'] as String,
    tr: j['tr'] as String?,
    context: j['context'] as String?,
    savedAt: DateTime.parse(j['savedAt'] as String),
  );

  final String contentId;
  final String sourceId;
  final SavedKind kind;
  final String en;
  final String? tr;

  /// Kelime ya da kalıbın geçtiği cümle.
  final String? context;

  /// UTC.
  final DateTime savedAt;

  /// Aynı ifade iki kez eklenmez.
  String get key => '${kind.name}|${en.toLowerCase()}';

  Map<String, dynamic> toJson() => {
    'contentId': contentId,
    'sourceId': sourceId,
    'kind': kind.name,
    'en': en,
    'tr': tr,
    'context': context,
    'savedAt': savedAt.toUtc().toIso8601String(),
  };
}

/// Defter. Şimdilik yerel; H-036'da FSRS kartlarıyla Drift'e taşınır.
abstract interface class NotebookRepository {
  /// Eklendiyse true; zaten defterdeyse false.
  Future<bool> add(SavedPhrase item);

  Future<List<SavedPhrase>> all();
}

class InMemoryNotebookRepository implements NotebookRepository {
  final List<SavedPhrase> items = [];

  @override
  Future<bool> add(SavedPhrase item) async {
    if (items.any((e) => e.key == item.key)) return false;
    items.add(item);
    return true;
  }

  @override
  Future<List<SavedPhrase>> all() async => List.of(items);
}

class SharedPrefsNotebookRepository implements NotebookRepository {
  SharedPrefsNotebookRepository({SharedPreferencesAsync? prefs})
    : _prefs = prefs ?? SharedPreferencesAsync();

  static const _key = 'notebook.items';
  final SharedPreferencesAsync _prefs;

  @override
  Future<bool> add(SavedPhrase item) async {
    final list = await all();
    if (list.any((e) => e.key == item.key)) return false;
    list.add(item);
    await _prefs.setString(
      _key,
      jsonEncode([for (final e in list) e.toJson()]),
    );
    return true;
  }

  @override
  Future<List<SavedPhrase>> all() async {
    final raw = await _prefs.getString(_key);
    if (raw == null) return [];
    try {
      return [
        for (final e in jsonDecode(raw) as List)
          SavedPhrase.fromJson((e as Map).cast<String, dynamic>()),
      ];
    } on Object {
      return [];
    }
  }
}

final notebookRepositoryProvider = Provider<NotebookRepository>(
  (ref) => SharedPrefsNotebookRepository(),
);
