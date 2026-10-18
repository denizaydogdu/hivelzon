// Bağımsız konu reelleri (H-094): `/reels/<id>/reel.json`.
//
// Saf Dart. Reel, bir bölüme bağlı olmayan, tek öğrenme hedefi taşıyan dikey
// kısa videodur (Keşfet "Bugünün seçkisi"). Kaynak türü `standalone`; mevcut
// hikâye klipleri (`episode_clip`) ayrı kalır: bağımsız reel bir bölüme
// aitmiş gibi gösterilmez.
//
// Altyazı zamanları videonun başına görelidir. Defter kartı reel paketinden
// görsel ve ses alabilir (`_reels/<id>/…`; `content_source.dart`
// `resolveMediaUri`). Katalogdaki `status` bilgisi yayın yetkisi vermez
// (yetkili durum backend'dedir, plan §6.4).

import '../../player/domain/episode.dart';
import '../../player/domain/subtitles.dart';
import 'clip.dart';

/// Kategori kodları (konu): Sinema · Spor · Kitap.
const Map<String, String> kReelCategoryTr = {
  'CIN': 'Sinema',
  'SPO': 'Spor',
  'BOK': 'Kitap',
};

/// Kategorilerin yayın/gösterim sırası (günlük seçkinin ilgi dağıtımı bu
/// sırayı izler — plan §4).
const List<String> kReelCategoryOrder = ['CIN', 'SPO', 'BOK'];

/// Reelin gerçek bağı (varsa): bölüm, kitap ya da dilbilgisi dersi. Gerçek bir
/// bağ yoksa boş kalır ve "Tam hikâye" gizlenir (plan §6.3).
class ReelRelated {
  const ReelRelated({required this.kind, required this.id, this.titleTr});

  factory ReelRelated.fromJson(Map<String, dynamic> j) => ReelRelated(
    kind: j['kind'] as String,
    id: j['id'] as String,
    titleTr: j['titleTr'] as String?,
  );

  /// `episode` | `book` | `grammar`.
  final String kind;
  final String id;
  final String? titleTr;
}

/// Tek bağımsız reel (`/reels/<id>/reel.json`).
class Reel {
  const Reel({
    required this.id,
    required this.contentVersion,
    required this.sourceType,
    required this.category,
    required this.categoryTr,
    required this.level,
    required this.titleTr,
    required this.video,
    required this.duration,
    required this.target,
    required this.subtitles,
    this.learningObjective,
    this.family,
    this.poster,
    this.image,
    this.audio,
    this.practice,
    this.related = const [],
    this.status = 'DRAFT',
  });

  factory Reel.fromJson(Map<String, dynamic> j) {
    if (j['schemaVersion'] != 1) {
      throw EpisodeFormatException('reel: desteklenmeyen schemaVersion');
    }
    final t = (j['target'] as Map).cast<String, dynamic>();
    final p = j['practice'] is Map
        ? (j['practice'] as Map).cast<String, dynamic>()
        : null;
    final duration = (j['duration'] as num).toDouble();
    final category = j['category'] as String;
    return Reel(
      id: j['id'] as String,
      contentVersion: (j['contentVersion'] as num?)?.toInt() ?? 1,
      sourceType: (j['sourceType'] as String?) ?? 'standalone',
      category: category,
      categoryTr:
          (j['categoryTr'] as String?) ?? kReelCategoryTr[category] ?? category,
      level: (j['level'] as String?) ?? '',
      titleTr: j['titleTr'] as String,
      learningObjective: j['learningObjective'] as String?,
      family: j['family'] as String?,
      video: j['video'] as String,
      poster: j['poster'] as String?,
      image: j['image'] as String?,
      audio: j['audio'] as String?,
      duration: duration,
      target: ClipTarget(
        kind: (t['kind'] as String?) ?? 'phrase',
        en: t['en'] as String,
        tr: t['tr'] as String,
        cueId: t['cue'] as String?,
      ),
      practice: p == null
          ? null
          : ClipQuiz(
              promptTr: p['promptTr'] as String,
              explainTr: p['explainTr'] as String?,
              options: [
                for (final o in (p['options'] as List? ?? const []))
                  ClipQuizOption(
                    text: (o as Map)['text'] as String,
                    lang: (o['lang'] as String?) ?? 'tr',
                    correct: o['correct'] == true,
                  ),
              ],
            ),
      related: [
        for (final r in (j['related'] as List? ?? const []))
          ReelRelated.fromJson((r as Map).cast<String, dynamic>()),
      ],
      status: (j['status'] as String?) ?? 'DRAFT',
      subtitles: SubtitleTrack.fromJson({
        'schemaVersion': 1,
        'segment': j['id'],
        'duration': duration,
        'cues': j['cues'] ?? const [],
      }),
    );
  }

  final String id;

  /// İçerik sürümü; artınca eski izlenme/soru sonucu yeni sürüme taşınmaz.
  final int contentVersion;

  /// `standalone` (bağımsız reel) | `episode_clip` (hikâye klibi).
  final String sourceType;

  /// Kategori kodu (`CIN` | `SPO` | `BOK`) ve Türkçe adı.
  final String category;
  final String categoryTr;

  /// Seviye (`A1` | `A2` …).
  final String level;
  final String titleTr;

  /// Tek iletişim hedefi (öğretim amacı).
  final String? learningObjective;

  /// Aynı iletişim hedefinin seviye/bağlam sürümlerini bağlar.
  final String? family;

  /// Paket içi yol: video (720×1280) ve ilk kare.
  final String video;
  final String? poster;

  /// Defter kartının taşıyacağı paket içi görsel ve (varsa) kesilmiş ses yolu.
  final String? image;
  final String? audio;

  final double duration;
  final ClipTarget target;

  /// İsteğe bağlı tek anlama sorusu (atlanabilir; plan §7).
  final ClipQuiz? practice;

  /// Gerçek bağ (varsa); boşsa "Tam hikâye" gösterilmez.
  final List<ReelRelated> related;

  /// Katalog durumu (`DRAFT` | `APPROVED` | `PUBLISHED` | `WITHDRAWN`).
  final String status;

  final SubtitleTrack subtitles;

  bool get isStandalone => sourceType == 'standalone';

  /// Geri çekilen içerik sabit seçkide olsa bile oynatılmaz (plan §5).
  bool get isWithdrawn => status == 'WITHDRAWN';

  /// Defter/anlamın gerçek kaynağı: bağımsız reel kendi kimliğidir.
  String get sourceContentId => id;

  /// Hedefin geçtiği satır kimliği.
  String? get sourceCueId => target.cueId;

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

/// `/reels/index.json` katalog özeti (günlük seçki ve listeleme için).
class ReelSummary {
  const ReelSummary({
    required this.id,
    required this.contentVersion,
    required this.sourceType,
    required this.category,
    required this.categoryTr,
    required this.level,
    required this.titleTr,
    required this.duration,
    this.poster,
    this.family,
    this.status = 'DRAFT',
  });

  factory ReelSummary.fromJson(Map<String, dynamic> j) {
    final category = j['category'] as String;
    return ReelSummary(
      id: j['id'] as String,
      contentVersion: (j['contentVersion'] as num?)?.toInt() ?? 1,
      sourceType: (j['sourceType'] as String?) ?? 'standalone',
      category: category,
      categoryTr:
          (j['categoryTr'] as String?) ?? kReelCategoryTr[category] ?? category,
      level: (j['level'] as String?) ?? '',
      titleTr: (j['titleTr'] as String?) ?? j['id'] as String,
      duration: (j['duration'] as num?)?.toDouble() ?? 0,
      poster: j['poster'] as String?,
      family: j['family'] as String?,
      status: (j['status'] as String?) ?? 'DRAFT',
    );
  }

  final String id;
  final int contentVersion;
  final String sourceType;
  final String category;
  final String categoryTr;
  final String level;
  final String titleTr;
  final double duration;
  final String? poster;
  final String? family;
  final String status;

  bool get isWithdrawn => status == 'WITHDRAWN';
}

/// `/reels/index.json`: bağımsız reellerin kataloğu.
class ReelCatalog {
  const ReelCatalog({required this.reels});

  factory ReelCatalog.fromJson(Map<String, dynamic> j) {
    if (j['schemaVersion'] != 1) {
      throw EpisodeFormatException('reels: desteklenmeyen schemaVersion');
    }
    return ReelCatalog(
      reels: [
        for (final r in (j['reels'] as List? ?? const []))
          ReelSummary.fromJson((r as Map).cast<String, dynamic>()),
      ],
    );
  }

  /// Dışa aktarma sırası.
  final List<ReelSummary> reels;

  /// Kategoriye (ve istenirse seviyeye) göre reeller.
  List<ReelSummary> byCategory(String category, {String? level}) => [
    for (final r in reels)
      if (r.category == category && (level == null || r.level == level)) r,
  ];

  /// Verilen seviyedeki reeller.
  List<ReelSummary> forLevel(String level) => [
    for (final r in reels)
      if (r.level == level) r,
  ];

  ReelSummary? byId(String id) {
    for (final r in reels) {
      if (r.id == id) return r;
    }
    return null;
  }
}
