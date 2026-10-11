// Segment altyazısı (`subs/<düğüm>.en.json`, şema: subs.schema.json).
//
// Saf Dart. Zamanlar saniyedir ve segmentin başına görelidir.

import 'episode.dart';

class SubtitleWord {
  const SubtitleWord(this.w, this.start, this.end);

  final String w;
  final double start;
  final double end;
}

class SubtitleCue {
  const SubtitleCue({
    required this.id,
    required this.start,
    required this.end,
    required this.speaker,
    required this.text,
    required this.words,
    this.tr,
  });

  final String id;
  final double start;
  final double end;
  final String speaker;
  final String text;
  final String? tr;
  final List<SubtitleWord> words;

  bool covers(double t) => t >= start && t < end;
}

class SubtitleTrack {
  const SubtitleTrack({
    required this.segment,
    required this.duration,
    required this.cues,
  });

  factory SubtitleTrack.fromJson(Object? json) {
    if (json is! Map) throw EpisodeFormatException('subs: nesne bekleniyordu');
    if (json['schemaVersion'] != 1) {
      throw EpisodeFormatException('subs: desteklenmeyen schemaVersion');
    }
    final cues = <SubtitleCue>[];
    for (final c in (json['cues'] as List? ?? const [])) {
      final m = c as Map;
      cues.add(
        SubtitleCue(
          id: m['id'] as String,
          start: (m['start'] as num).toDouble(),
          end: (m['end'] as num).toDouble(),
          speaker: (m['speaker'] as String?) ?? '',
          text: m['text'] as String,
          tr: m['tr'] as String?,
          words: [
            for (final w in (m['words'] as List? ?? const []))
              SubtitleWord(
                (w as Map)['w'] as String,
                (w['start'] as num).toDouble(),
                (w['end'] as num).toDouble(),
              ),
          ],
        ),
      );
    }
    cues.sort((a, b) => a.start.compareTo(b.start));
    return SubtitleTrack(
      segment: (json['segment'] as String?) ?? '',
      duration: (json['duration'] as num?)?.toDouble() ?? 0,
      cues: cues,
    );
  }

  final String segment;
  final double duration;
  final List<SubtitleCue> cues;

  /// Verilen saniyede görünen ipucu (yoksa null).
  SubtitleCue? cueAt(double seconds) {
    for (final c in cues) {
      if (c.covers(seconds)) return c;
      if (c.start > seconds) break;
    }
    return null;
  }

  /// Türkçe satır var mı? (`tr` henüz null; EN+TR modu bunu bekler.)
  bool get hasTurkish => cues.any((c) => c.tr != null && c.tr!.isNotEmpty);
}

/// Hedef ifadelerin sözcüklerini ipucu sözcüklerinde bulur.
///
/// "Where is…?" gibi `…` ile biten ifadeler önek olarak eşleşir. Dönüş,
/// [cue.words] içinde vurgulanacak sözcüklerin sırasıdır.
Set<int> targetWordIndexes(SubtitleCue cue, List<String> targetPhrases) {
  final words = [for (final w in cue.words) _norm(w.w)];
  if (words.isEmpty) return const {};
  final hits = <int>{};
  for (final parts in _phraseVariants(targetPhrases)) {
    if (parts.isEmpty) continue;
    for (var i = 0; i + parts.length <= words.length; i++) {
      var ok = true;
      for (var k = 0; k < parts.length; k++) {
        if (words[i + k] != parts[k]) {
          ok = false;
          break;
        }
      }
      if (ok) {
        for (var k = 0; k < parts.length; k++) {
          hits.add(i + k);
        }
      }
    }
  }
  return hits;
}

/// "Turn left / right." → [turn, left] ve [turn, right].
Iterable<List<String>> _phraseVariants(List<String> phrases) sync* {
  for (final phrase in phrases) {
    final tokens = phrase
        .replaceAll('…', ' ')
        .replaceAll('...', ' ')
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();
    final slash = tokens.indexOf('/');
    final variants = slash > 0 && slash < tokens.length - 1
        ? [
            [...tokens.sublist(0, slash), ...tokens.sublist(slash + 2)],
            [...tokens.sublist(0, slash - 1), ...tokens.sublist(slash + 1)],
          ]
        : [tokens];
    for (final v in variants) {
      final parts = v.map(_norm).where((p) => p.isNotEmpty).toList();
      if (parts.isNotEmpty) yield parts;
    }
  }
}

String _norm(String w) =>
    w.toLowerCase().replaceAll(RegExp(r"[^a-z0-9'’]"), '').replaceAll('’', "'");
