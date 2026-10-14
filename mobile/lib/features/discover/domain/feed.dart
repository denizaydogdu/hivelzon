// Keşfet akışının düzeni (H-040, K-15). Saf Dart.
//
// - 4–5 klipte bir quiz kartı: 4 klipten sonra son kliplerden birinin
//   sorusu; o 4 klipte soru yoksa 5. klipten sonra yeniden bakılır, yine
//   yoksa o blokta quiz çıkmaz.
// - ~10 klipte bir mola kartı (sonda değil).
// - Akış biter: klipler tükenince bitiş kartı (sonsuz kaydırma yok).

import '../../onboarding/domain/age.dart';
import 'clip.dart';

sealed class FeedEntry {
  const FeedEntry();
}

class ClipEntry extends FeedEntry {
  const ClipEntry(this.clip, this.ordinal);

  final FeedClip clip;

  /// Akıştaki klip sırası (1'den).
  final int ordinal;
}

class QuizEntry extends FeedEntry {
  const QuizEntry(this.clip);

  /// Sorunun geldiği klip.
  final FeedClip clip;
}

class BreakEntry extends FeedEntry {
  const BreakEntry(this.clipsBefore);

  /// Mola kartından önce izlenen klip sayısı.
  final int clipsBefore;
}

class EndEntry extends FeedEntry {
  const EndEntry();
}

const kQuizEvery = 4;
const kBreakEvery = 10;

List<FeedEntry> buildFeed(
  List<FeedClip> clips, {
  int quizEvery = kQuizEvery,
  int breakEvery = kBreakEvery,
}) {
  final out = <FeedEntry>[];
  final used = <String>{};
  var sinceQuiz = 0;
  for (var i = 0; i < clips.length; i++) {
    out.add(ClipEntry(clips[i], i + 1));
    sinceQuiz++;
    if (sinceQuiz >= quizEvery) {
      FeedClip? pick;
      // En yeni klipten geriye: az önce izlenenin sorusu öncelikli.
      for (var k = i; k > i - sinceQuiz && k >= 0; k--) {
        final c = clips[k];
        if (c.quiz != null && !used.contains(c.id)) {
          pick = c;
          break;
        }
      }
      if (pick != null) {
        used.add(pick.id);
        out.add(QuizEntry(pick));
        sinceQuiz = 0;
      } else if (sinceQuiz > quizEvery) {
        sinceQuiz = 0;
      }
    }
    final n = i + 1;
    if (n % breakEvery == 0 && n < clips.length) out.add(BreakEntry(n));
  }
  out.add(const EndEntry());
  return out;
}

/// [from] sırasından sonraki ilk klip girdisinin sırası (yoksa null).
int? nextClipIndex(List<FeedEntry> feed, int from) {
  for (var i = from + 1; i < feed.length; i++) {
    if (feed[i] is ClipEntry) return i;
  }
  return null;
}

/// Günlük Keşfet sınırı (K-15): 13–17 için varsayılan 20 dk. 13 altı da
/// aynı sınırı alır (açık soru, H-040). 18+ ve yaşını söylemeyen için sınır
/// yok.
const kTeenDailyLimit = Duration(minutes: 20);

class DiscoverLimit {
  const DiscoverLimit(this.band, this.daily);

  /// Yaş bilgisi yoksa null.
  final AgeBand? band;

  /// Günlük süre; sınır yoksa null.
  final Duration? daily;

  bool get limited => daily != null;

  static const none = DiscoverLimit(null, null);
}

/// Yaş grubu, cihazdaki eşiklerden (H-039): [ageBlockedUntil] (13 yaş altı,
/// hesap açılabilecek yıl) ve [adultFromYear] (18 yaşına girilen yıl; 13–17
/// ve 13 altı için kayıtlı). Doğum yılı saklanmaz.
DiscoverLimit discoverLimitFor({
  required DateTime now,
  int? ageBlockedUntil,
  int? adultFromYear,
}) {
  final year = now.toUtc().year;
  if (ageBlockedUntil != null && year < ageBlockedUntil) {
    return const DiscoverLimit(AgeBand.under13, kTeenDailyLimit);
  }
  if (adultFromYear != null && year < adultFromYear) {
    return const DiscoverLimit(AgeBand.teen, kTeenDailyLimit);
  }
  if (adultFromYear != null || ageBlockedUntil != null) {
    return const DiscoverLimit(AgeBand.adult, null);
  }
  return DiscoverLimit.none;
}

/// Yerel güne göre anahtar (`2026-10-14`): sayaç yerel gece yarısında
/// sıfırlanır.
String localDayKey(DateTime now) {
  final l = now.toLocal();
  String two(int v) => v.toString().padLeft(2, '0');
  return '${l.year}-${two(l.month)}-${two(l.day)}';
}
