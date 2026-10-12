// Bölüm kilidi (H-035; K-26, K-29, K-32). Saf Dart.
//
// Bölüm N oynanabilir ⇔ paketi var VE (N == 1 YA DA Bölüm N−1'in kapısı tamam
// YA DA bölüm daha önce başlatılmış/bitirilmiş). Tekrar oynamak her zaman
// serbesttir. Zaman kilidi, geri sayım ve tarih yoktur.

import '../../../shared/progress/story_progress.dart';

enum EpisodeAvailability {
  /// Oynanabilir (ilk kez, devam ya da tekrar).
  playable,

  /// Önceki bölümün kapısı henüz açılmadı.
  locked,

  /// Paket henüz yok ("Yakında"; tarih gösterilmez).
  comingSoon,
}

class EpisodeAccess {
  const EpisodeAccess._(this.kind, {this.blockedBy, this.missing = const {}});

  const EpisodeAccess.playable() : this._(EpisodeAvailability.playable);

  const EpisodeAccess.comingSoon() : this._(EpisodeAvailability.comingSoon);

  const EpisodeAccess.locked({
    required int blockedBy,
    required Set<GateItem> missing,
  }) : this._(
         EpisodeAvailability.locked,
         blockedBy: blockedBy,
         missing: missing,
       );

  final EpisodeAvailability kind;

  /// Kilitliyse: tamamlanması gereken bölümün numarası (N−1).
  final int? blockedBy;

  /// Kilitliyse: önceki bölümde eksik kalan kapı ölçütleri.
  final Set<GateItem> missing;

  bool get isPlayable => kind == EpisodeAvailability.playable;
}

/// [previous]: Bölüm N−1'in ilerlemesi (yoksa hiç oynanmamış).
EpisodeAccess episodeAccess({
  required int number,
  required bool available,
  StoryProgress? own,
  StoryProgress? previous,
}) {
  if (!available) return const EpisodeAccess.comingSoon();
  if (number <= 1) return const EpisodeAccess.playable();
  // Başlanmış ya da bitmiş bölüm her zaman yeniden açılır (kilit kalıcı değil).
  if (own != null && own.status != StoryStatus.notStarted) {
    return const EpisodeAccess.playable();
  }
  if (previous != null && previous.gateComplete) {
    return const EpisodeAccess.playable();
  }
  return EpisodeAccess.locked(
    blockedBy: number - 1,
    missing: previous?.missingGateItems ?? GateItem.values.toSet(),
  );
}

/// Türkçe belirtme hâli eki: "Bölüm 1'i", "Bölüm 2'yi", "Bölüm 6'yı" …
String accusativeNumber(int n) {
  const ones = {
    1: "'i",
    2: "'yi",
    3: "'ü",
    4: "'ü",
    5: "'i",
    6: "'yı",
    7: "'yi",
    8: "'i",
    9: "'u",
  };
  const tens = {
    1: "'u",
    2: "'yi",
    3: "'u",
    4: "'ı",
    5: "'yi",
    6: "'ı",
    7: "'i",
    8: "'i",
    9: "'u",
  };
  final last = n % 10;
  if (last != 0) return '$n${ones[last]}';
  final t = (n ~/ 10) % 10;
  if (t != 0) return '$n${tens[t]}';
  return "$n'ü"; // yüz, bin …: yalnızca güvenli varsayılan
}

/// "anlama, hedef ifade ve görev"
String joinTr(List<String> items) => switch (items.length) {
  0 => '',
  1 => items.first,
  _ => '${items.sublist(0, items.length - 1).join(', ')} ve ${items.last}',
};

/// Kilit nedeni: nazik, suçlamasız (K-32). Kilitli değilse `null`.
String? lockReason(EpisodeAccess access) {
  if (access.kind != EpisodeAvailability.locked) return null;
  final n = access.blockedBy!;
  final missing = [
    for (final g in GateItem.values)
      if (access.missing.contains(g)) g.labelTr,
  ];
  final head = 'Önce Bölüm ${accusativeNumber(n)} tamamla.';
  if (missing.isEmpty) return head;
  return '$head Kalan adımlar: ${joinTr(missing)}.';
}
