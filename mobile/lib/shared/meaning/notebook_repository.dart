import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/notebook/application/notebook_providers.dart';
import '../../features/notebook/data/notebook_store.dart';
import '../../features/notebook/domain/notebook_item.dart';

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
    this.contextTr,
    this.source = NotebookSource.userSaved,
    this.sourceTitle,
    this.imagePath,
    this.audio,
    this.contextAudio,
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

  /// Cümlenin Türkçesi (kitaptan eklenende, H-067).
  final String? contextTr;

  /// Nereden eklendi (varsayılan: anlam panelinde "Deftere ekle").
  final NotebookSource source;

  /// Kitabın başlığı (H-067: `Kitap: <başlık>, s. N`).
  final String? sourceTitle;

  /// Kart görseli ve sesi (kitapta eklenirken bilinir; bölümde sonradan
  /// bölüm verisinden doldurulur).
  final String? imagePath;
  final MediaClip? audio;
  final MediaClip? contextAudio;

  /// UTC.
  final DateTime savedAt;

  /// Aynı ifade iki kez eklenmez.
  String get key => itemKey(toNotebookKind(kind), en);

  /// Defter kartı taslağı (görsel ve ses sonradan bölüm verisinden doldurulur).
  NotebookItem toItem() => NotebookItem(
    kind: toNotebookKind(kind),
    textEn: en,
    textTr: tr,
    exampleEn: context,
    exampleTr: contextTr,
    contentId: contentId,
    cueId: sourceId,
    source: source,
    sourceTitle: sourceTitle,
    imagePath: imagePath,
    audio: audio,
    exampleAudio: contextAudio,
    createdAt: savedAt.toUtc(),
  );

  SavedPhrase copyWith({
    String? contextTr,
    NotebookSource? source,
    String? sourceTitle,
    String? imagePath,
    MediaClip? audio,
    MediaClip? contextAudio,
  }) => SavedPhrase(
    contentId: contentId,
    sourceId: sourceId,
    kind: kind,
    en: en,
    tr: tr,
    context: context,
    savedAt: savedAt,
    contextTr: contextTr ?? this.contextTr,
    source: source ?? this.source,
    sourceTitle: sourceTitle ?? this.sourceTitle,
    imagePath: imagePath ?? this.imagePath,
    audio: audio ?? this.audio,
    contextAudio: contextAudio ?? this.contextAudio,
  );

  static NotebookKind toNotebookKind(SavedKind k) => switch (k) {
    SavedKind.word => NotebookKind.word,
    SavedKind.phrase => NotebookKind.phrase,
    SavedKind.sentence => NotebookKind.sentence,
  };

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

/// Defter girişi (anlam panelindeki "Deftere ekle"). Uygulamada Drift
/// ([DriftNotebookRepository], H-036); eklenen her ifade FSRS kartı olur.
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

/// Drift defteri (H-036): kart ve FSRS durumu birlikte yazılır.
class DriftNotebookRepository implements NotebookRepository {
  DriftNotebookRepository(this._store);

  final NotebookStore _store;

  @override
  Future<bool> add(SavedPhrase item) async =>
      await _store.addItems([item.toItem()]) > 0;

  @override
  Future<List<SavedPhrase>> all() async => [
    for (final e in await _store.entries())
      SavedPhrase(
        contentId: e.item.contentId ?? '',
        sourceId: e.item.cueId ?? '',
        kind: switch (e.item.kind) {
          NotebookKind.word => SavedKind.word,
          NotebookKind.phrase => SavedKind.phrase,
          NotebookKind.sentence || NotebookKind.rule => SavedKind.sentence,
        },
        en: e.item.textEn,
        tr: e.item.textTr,
        context: e.item.exampleEn,
        contextTr: e.item.exampleTr,
        source: e.item.source,
        sourceTitle: e.item.sourceTitle,
        imagePath: e.item.imagePath,
        audio: e.item.audio,
        contextAudio: e.item.exampleAudio,
        savedAt: e.item.createdAt ?? DateTime.now().toUtc(),
      ),
  ];
}

/// `shared_preferences` defteri (H-046). H-036'dan beri yalnızca eski
/// kayıtların okunması (taşıma) için.
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
  (ref) => DriftNotebookRepository(ref.watch(notebookStoreProvider)),
);
