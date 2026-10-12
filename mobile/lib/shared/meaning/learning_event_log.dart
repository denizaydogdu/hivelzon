import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kullanıcının bir kelimeye ya da cümlenin Türkçesine baktığı an (H-046).
///
/// Yalnızca öğrenme sinyalidir: bakmak puan düşürmez, uyarı göstermez (K-32).
class LearningEvent {
  const LearningEvent({
    required this.contentId,
    required this.sourceId,
    required this.target,
    required this.at,
  });

  factory LearningEvent.fromJson(Map<String, dynamic> j) => LearningEvent(
    contentId: j['contentId'] as String,
    sourceId: j['sourceId'] as String,
    target: j['target'] as String,
    at: DateTime.parse(j['at'] as String),
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

  Map<String, dynamic> toJson() => {
    'contentId': contentId,
    'sourceId': sourceId,
    'target': target,
    'at': at.toUtc().toIso8601String(),
  };
}

/// Öğrenme olayları kaydı. Şimdilik yerel; H-036'da sunucudaki
/// `learning_events` tablosuna eşitlenir.
abstract interface class LearningEventLog {
  Future<void> record(LearningEvent event);

  Future<List<LearningEvent>> recent();
}

class InMemoryLearningEventLog implements LearningEventLog {
  final List<LearningEvent> events = [];

  @override
  Future<void> record(LearningEvent event) async => events.add(event);

  @override
  Future<List<LearningEvent>> recent() async => List.of(events);
}

/// `shared_preferences` üzerinde en fazla [maxEvents] olay tutar.
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
  (ref) => SharedPrefsLearningEventLog(),
);
