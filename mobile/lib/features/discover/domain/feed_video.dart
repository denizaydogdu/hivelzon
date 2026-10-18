// Keşfet'te gösterilen tek video (H-094): bağımsız konu reeli ya da mevcut
// hikâye klibi. Saf Dart.
//
// Video sayfası (`VideoPage`) yalnız bu modeli bilir; böylece günlük üçlü
// ("Bugünün seçkisi") ve hikâye klipleri **aynı oynatıcıyı** paylaşır ama
// kaynak türleri karışmaz:
//
// - `keyPrefix` ile arayüz anahtarları ve erişilebilirlik metinleri ayrılır
//   (`clip-…` / `reel-…`); mevcut klip davranışı ve golden'ları değişmez.
// - `cacheKey` video denetleyicisi önbelleğinin anahtarıdır (klip: paket yolu,
//   reel: `reels/<id>/<yol>`) ve `mediaUri` ile birlikte gelir; kaynak türü
//   farkı yalnızca adres çözümünde kalır.
// - Bölüm kilitleri ve spoiler koruması **hikâye kliplerinde** kalır (plan §4):
//   bağımsız reel bir bölüme aitmiş gibi gösterilmez; bağımsız reel'de gereksiz
//   bölüm kilidi yoktur.
//
// "Tam hikâye" yalnızca gerçek bağ varsa görünür: klipte her zaman bir bölüm
// vardır; reellde `related` içinde `episode` yoksa düğme hiç çizilmez (§6.3).

import '../../player/domain/subtitles.dart';
import 'clip.dart';

class FeedVideo {
  const FeedVideo({
    required this.keyPrefix,
    required this.id,
    required this.titleTr,
    required this.cacheKey,
    required this.mediaUri,
    required this.subtitles,
    required this.target,
    this.badge,
    this.posterUri,
    this.grammarId,
    this.grammarTitle,
    this.contentId,
    this.sourceTitle,
    this.episodeId,
    this.episodeNumber,
    this.practice,
    this.imagePath,
    this.audioPath,
    this.contentVersion = 1,
    this.isRepeat = false,
  });

  /// `clip` (hikâye klibi) | `reel` (bağımsız konu reeli).
  final String keyPrefix;

  /// Klip ya da reel kimliği.
  final String id;
  final String titleTr;

  /// Video denetleyicisi önbelleği anahtarı (kaynaklar karışmasın diye
  /// paket yolu reellde önek taşır).
  final String cacheKey;

  /// Tam adres (`ContentSource.seasonMediaUri` / `reelMediaUri`).
  final Uri mediaUri;
  final SubtitleTrack subtitles;
  final ClipTarget target;

  /// Üstteki sarı rozet: klipte "Bölüm 3", reellde "Sinema · A1".
  final String? badge;
  final Uri? posterUri;

  /// Dilbilgisi dersi (varsa): klipte klibin dersi, reellde `related` dersi.
  final String? grammarId;
  final String? grammarTitle;

  /// Anlam panelinin ve Defter kartının içerik kimliği.
  final String? contentId;

  /// Defter kartının kaynak adı ("Keşfet: …").
  final String? sourceTitle;

  /// "Tam hikâye": açılacak bölüm (klipte bölümün kimliği, reellde gerçek
  /// `related` bağ). `null` ise düğme gizlenir.
  final String? episodeId;
  final int? episodeNumber;

  /// Videonun sonunda çıkan **isteğe bağlı tek** anlama sorusu (atlanabilir).
  final ClipQuiz? practice;

  /// Defter kartının taşıyacağı görsel ve ses yolu (reel paketinde
  /// `_reels/<id>/<yol>`; `resolveMediaUri` bu öneki tanır).
  final String? imagePath;
  final String? audioPath;

  /// İçeriğin sürümü (ilerleme kaydı buna bağlanır; artınca yeniden
  /// "izlenmemiş" sayılır — plan §5).
  final int contentVersion;

  /// Bu video kullanıcıya daha önce gösterildi (arayüz "Tekrar" der; yalnız
  /// bağımsız reellerde anlamlıdır).
  final bool isRepeat;

  bool get isReel => keyPrefix == 'reel';

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
