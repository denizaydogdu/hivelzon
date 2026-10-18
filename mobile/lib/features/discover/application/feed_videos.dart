// Keşfet videolarının ortak modeline dönüşümü (H-094). Sunucu yolları burada
// çözülür; sayfa (`VideoPage`) ve akış (`feed.dart`) kaynak türünü bilmez.
//
// Kaynak türleri **karışmaz**: hikâye klibi sezon paketinden (`clips/…`),
// bağımsız reel `/reels/<id>/` paketinden gelir; önbellek anahtarları da
// ayrıdır (plan §4).

import '../../../l10n/tr_strings.dart';
import '../../../shared/content/content_source.dart';
import '../domain/clip.dart';
import '../domain/feed_video.dart';
import '../domain/reel.dart';
import 'discover_providers.dart';

/// Hikâye klibi → video modeli. Mevcut klip davranışı birebir korunur:
/// sarı rozet "Bölüm N", "Tam hikâye" her zaman açık (klibin bölümü vardır).
FeedVideo feedVideoOfClip(
  FeedClip clip,
  ContentSource source, {
  int season = kDiscoverSeason,
}) => FeedVideo(
  keyPrefix: 'clip',
  id: clip.id,
  titleTr: clip.titleTr,
  cacheKey: clip.video,
  mediaUri: source.seasonMediaUri(season, clip.video),
  posterUri: clip.poster == null
      ? null
      : source.seasonMediaUri(season, clip.poster!),
  subtitles: clip.subtitles,
  target: clip.target,
  badge: clip.episodeNumber == null
      ? null
      : DiscoverTexts.episodeChip(clip.episodeNumber!),
  grammarId: clip.grammarId,
  grammarTitle: clip.grammarTitle,
  contentId: clip.episodeId,
  sourceTitle: DiscoverTexts.notebookSource(clip.episodeTitle ?? clip.titleTr),
  episodeId: clip.episodeId,
  episodeNumber: clip.episodeNumber,
  practice: clip.quiz,
);

/// Bağımsız konu reeli → video modeli.
///
/// - Rozet "Sinema · A1" (kategori · seviye).
/// - "Tam hikâye" **yalnızca** `related` içinde gerçek bir bölüm varsa; kitap
///   ya da dilbilgisi bağı varsa düğme gizlenir (dilbilgisi bağı ders çipini
///   açar). (plan §6.3)
/// - Defter kartı görseli ve sesi reel paketinden gelir (`_reels/<id>/…`).
/// - [repeat] ise video daha önce gösterilmiştir: arayüz "Tekrar" der (§4.5).
FeedVideo feedVideoOfReel(
  Reel reel,
  ContentSource source, {
  bool repeat = false,
}) {
  final episode = _related(reel, 'episode');
  final grammar = _related(reel, 'grammar');
  return FeedVideo(
    keyPrefix: 'reel',
    id: reel.id,
    titleTr: reel.titleTr,
    cacheKey: 'reels/${reel.id}/${reel.video}',
    mediaUri: source.reelMediaUri(reel.id, reel.video),
    posterUri: reel.poster == null
        ? null
        : source.reelMediaUri(reel.id, reel.poster!),
    subtitles: reel.subtitles,
    target: reel.target,
    badge: DiscoverTexts.reelBadge(reel.categoryTr, reel.level),
    grammarId: grammar?.id,
    grammarTitle: grammar?.titleTr,
    contentId: reel.sourceContentId,
    sourceTitle: DiscoverTexts.reelNotebookSource(
      reel.categoryTr,
      reel.titleTr,
    ),
    episodeId: episode?.id,
    practice: reel.practice,
    contentVersion: reel.contentVersion,
    isRepeat: repeat,
    imagePath: reel.image == null ? null : reelMediaPath(reel.id, reel.image!),
    audioPath: reel.audio == null ? null : reelMediaPath(reel.id, reel.audio!),
  );
}

ReelRelated? _related(Reel reel, String kind) {
  for (final r in reel.related) {
    if (r.kind == kind) return r;
  }
  return null;
}
