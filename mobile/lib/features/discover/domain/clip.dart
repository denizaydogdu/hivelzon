// Keşfet klipleri (H-040): sezon paketindeki `clips.json` (BOLUM-PAKETI §9).
//
// Saf Dart. Her klip bir bölümün kayıtlarından kesilmiş, en çok 30 sn'lik,
// tek öğrenme hedefi taşıyan kısa videodur. Altyazı zamanları klibin başına
// görelidir; satır kimlikleri bölümdeki kimliklerle aynıdır (Defter kartı
// bölüm verisinden görsel ve ses alabilsin).

import '../../player/domain/episode.dart';
import '../../player/domain/subtitles.dart';

/// Klibin öğrenme hedefi: ifade ya da kelime.
class ClipTarget {
  const ClipTarget({
    required this.kind,
    required this.en,
    required this.tr,
    this.cueId,
  });

  /// `phrase` | `word`.
  final String kind;
  final String en;
  final String tr;

  /// Hedefin geçtiği altyazı satırı (dışa aktarma bulur).
  final String? cueId;

  bool get isWord => kind == 'word';
}

class ClipQuizOption {
  const ClipQuizOption({
    required this.text,
    this.lang = 'tr',
    this.correct = false,
  });

  final String text;

  /// `tr` | `en` (ekran okuyucu dili için).
  final String lang;
  final bool correct;
}

/// Klipten türetilen kısa soru (K-15): puan yok, süre yok.
class ClipQuiz {
  const ClipQuiz({
    required this.promptTr,
    required this.options,
    this.explainTr,
    this.promptAudio,
    this.explainAudio,
  });

  final String promptTr;
  final List<ClipQuizOption> options;

  /// Cevaptan sonra görünen kısa açıklama.
  final String? explainTr;

  /// Sorunun (ve Türkçe seçeneklerin) Hi sesiyle okunuşu (H-109). Reelde
  /// reel paketi içi yol (`audio/tr/practice-prompt.m4a`); hikâye klibinde
  /// (H-109 Faz 3b) sezon yolu (`_season/S1/clips/S1-K04.tr-prompt.m4a`,
  /// `feedVideoOfClip` bağlar). Yoksa düğme görünmez.
  final String? promptAudio;

  /// Açıklamanın Hi sesiyle okunuşu (H-109).
  final String? explainAudio;

  int get correctIndex => options.indexWhere((o) => o.correct);

  /// Aynı soru, ses yolları [map] ile dönüştürülmüş (ör. sezon öneki).
  ClipQuiz mapAudio(String Function(String path) map) => ClipQuiz(
    promptTr: promptTr,
    options: options,
    explainTr: explainTr,
    promptAudio: promptAudio == null ? null : map(promptAudio!),
    explainAudio: explainAudio == null ? null : map(explainAudio!),
  );
}

/// `practice.audioTr.<key>.audio` / `quiz.audioTr.<key>.audio` (H-109):
/// alıştırmanın Türkçe sesi, paket içi yol. Eski paket ya da bozuk alan →
/// null (düğme görünmez).
String? practiceTrAudio(Map<String, dynamic> practice, String key) {
  final at = practice['audioTr'];
  if (at is! Map) return null;
  final e = at[key];
  if (e is! Map) return null;
  final a = e['audio'];
  return a is String && a.isNotEmpty ? a : null;
}

class FeedClip {
  const FeedClip({
    required this.id,
    required this.episodeId,
    required this.titleTr,
    required this.video,
    required this.duration,
    required this.target,
    required this.subtitles,
    this.episodeNumber,
    this.episodeTitle,
    this.poster,
    this.grammarId,
    this.grammarTitle,
    this.quiz,
    this.sourceStatus,
  });

  factory FeedClip.fromJson(Map<String, dynamic> j) {
    final t = (j['target'] as Map).cast<String, dynamic>();
    final g = j['grammar'] is Map
        ? (j['grammar'] as Map).cast<String, dynamic>()
        : null;
    final q = j['quiz'] is Map
        ? (j['quiz'] as Map).cast<String, dynamic>()
        : null;
    final duration = (j['duration'] as num).toDouble();
    return FeedClip(
      id: j['id'] as String,
      episodeId: j['episode'] as String,
      episodeNumber: (j['episodeNumber'] as num?)?.toInt(),
      episodeTitle: j['episodeTitle'] as String?,
      titleTr: j['titleTr'] as String,
      video: j['video'] as String,
      poster: j['poster'] as String?,
      duration: duration,
      target: ClipTarget(
        kind: (t['kind'] as String?) ?? 'phrase',
        en: t['en'] as String,
        tr: t['tr'] as String,
        cueId: t['cue'] as String?,
      ),
      grammarId: g?['id'] as String?,
      grammarTitle: g?['titleTr'] as String?,
      quiz: q == null
          ? null
          : ClipQuiz(
              promptTr: q['promptTr'] as String,
              explainTr: q['explainTr'] as String?,
              promptAudio: practiceTrAudio(q, 'prompt'),
              explainAudio: practiceTrAudio(q, 'explain'),
              options: [
                for (final o in (q['options'] as List))
                  ClipQuizOption(
                    text: (o as Map)['text'] as String,
                    lang: (o['lang'] as String?) ?? 'tr',
                    correct: o['correct'] == true,
                  ),
              ],
            ),
      sourceStatus: j['sourceStatus'] as String?,
      subtitles: SubtitleTrack.fromJson({
        'schemaVersion': 1,
        'segment': j['id'],
        'duration': duration,
        'cues': j['cues'] ?? const [],
      }),
    );
  }

  final String id;
  final String episodeId;
  final int? episodeNumber;
  final String? episodeTitle;
  final String titleTr;

  /// Sezon paketine göre yol (`clips/S1-K01.mp4`, 720p).
  final String video;

  /// İlk kare (`clips/S1-K01.webp`); video hazır olana dek görünür.
  final String? poster;
  final double duration;
  final ClipTarget target;
  final SubtitleTrack subtitles;

  /// Dilbilgisi dersi (G-ID) ve Türkçe adı; yoksa null.
  final String? grammarId;
  final String? grammarTitle;
  final ClipQuiz? quiz;

  /// Kaynak bölümün yayın durumu (bilgi; uygulama süzmez).
  final String? sourceStatus;

  /// Hedef ifadenin geçtiği satır (yoksa ilk satır).
  SubtitleCue? get targetCue {
    final cues = subtitles.cues;
    if (cues.isEmpty) return null;
    for (final c in cues) {
      if (c.id == target.cueId) return c;
    }
    return cues.first;
  }
}

/// `clips.json`: sezonun klipleri (dışa aktarma sırası = akış sırası).
/// Yapay zekâ notu pakette yoksa (ve bağımsız reellerde) kullanılan varsayılan.
const kDefaultAiLabel = 'Yapay zekâ ile üretilmiştir';

class ClipCatalog {
  const ClipCatalog({
    required this.season,
    required this.clips,
    this.status,
    this.aiLabel = kDefaultAiLabel,
  });

  factory ClipCatalog.fromJson(Map<String, dynamic> j) {
    if (j['schemaVersion'] != 1) {
      throw EpisodeFormatException('clips: desteklenmeyen schemaVersion');
    }
    return ClipCatalog(
      season: (j['season'] as num).toInt(),
      status: j['status'] as String?,
      aiLabel: (j['aiLabel'] as String?) ?? kDefaultAiLabel,
      clips: [
        for (final c in (j['clips'] as List? ?? const []))
          FeedClip.fromJson((c as Map).cast<String, dynamic>()),
      ],
    );
  }

  final int season;
  final String? status;
  final String aiLabel;
  final List<FeedClip> clips;
}
