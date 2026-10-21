// Günlük seçkinin kural tabanlı seçimi (H-094 P2, plan §4).
//
// Öneri motoru yoktur: aynı girdi **aynı** seçkiyi verir (belirlenimli sıra).
//
// 1. Aday havuzu: geri çekilmemiş ve seviyesi tutan reeller; **asla farklı
//    seviyeden doldurulmaz** (§4.6).
// 2. İlgi dağıtımı: seçili kategoriler arasında birer (varsayılan Sinema ·
//    Spor · Kitap). Kapalı/boş kategori zorla doldurulmaz (§4.3).
// 3. Öncelik: önce **hiç tamamlanmamış** (bu içerik sürümünde), sonra **en
//    uzun süredir gösterilmemiş**; eşitlikte kimlik sırası (§4.4).
// 4. Kontrollü tekrar: aynı hedefi (aile) taşıyan iki video aynı seçkiye
//    girmez; elde kalanlar daha önce gösterilmişse video **tekrar**
//    etiketiyle sunulur (§4.5).
// 5. Yetersizlik: 3'ten az video kabul, seçki yine geçerlidir (§4.6).
//
// Saf Dart: cihaz, ağ ve saat bağımlılığı yok; "gün" ve "ilerleme" dışarıdan
// verilir (test edilebilirlik).

import 'daily_set.dart';
import 'reel.dart';
import 'reel_progress.dart';

/// Seçkinin tek parçası: katalog özeti + "daha önce gösterildi" etiketi.
class ReelPick {
  const ReelPick({required this.reel, this.repeat = false});

  final ReelSummary reel;

  /// Video kullanıcıya daha önce gösterildi: arayüz açıkça "Tekrar" der.
  final bool repeat;
}

/// Belirlenimli günlük seçki (plan §4).
///
/// [progress] reel kimliğinden ilerlemeye eşler; seçim yalnız buna ve
/// kataloğa bakar (gün/cihaz bağımlılığı yok — çağıran günü yönetir).
List<ReelPick> selectDailyReels({
  required List<ReelSummary> catalog,
  required String level,
  required List<String> categories,
  Map<String, ReelProgress> progress = const {},
  int count = 3,
}) {
  final candidates = [
    for (final r in catalog)
      if (!r.isWithdrawn && r.level == level) r,
  ]..sort((a, b) => a.id.compareTo(b.id));

  final picked = <ReelPick>[];
  final used = <String>{};
  final families = <String>{};

  ReelSummary? take(Iterable<ReelSummary> pool) {
    final ok = [
      for (final r in pool)
        if (!used.contains(r.id))
          if (r.family == null || !families.contains(r.family)) r,
    ];
    return _best(ok, progress);
  }

  void add(ReelSummary reel) {
    picked.add(ReelPick(reel: reel, repeat: _shownBefore(reel, progress)));
    used.add(reel.id);
    if (reel.family != null) families.add(reel.family!);
  }

  // 1) Kategori başına birer (kapalı kategori zorla gösterilmez).
  for (final c in categories) {
    if (picked.length >= count) break;
    final r = take(candidates.where((e) => e.category == c));
    if (r != null) add(r);
  }

  // 2) Kontrollü tekrar: eksik kalan yerler **seçili** kategorilerdeki
  // adaylardan doldurulur; kapalı kategori zorla gösterilmez.
  final allowed = [
    for (final r in candidates)
      if (categories.contains(r.category)) r,
  ];
  while (picked.length < count) {
    final r = take(allowed);
    if (r == null) break;
    add(r);
  }
  return picked;
}

/// Geri çekilen/eksilen bir seçkinin yerine **aynı seviye ve kategoriden**
/// yedek (plan §5). [used] seçkide kalan kimlikler; uygun aday yoksa `null`
/// (o zaman daha az video gösterilir).
ReelSummary? substituteReel({
  required List<ReelSummary> catalog,
  required String level,
  required String category,
  required Set<String> used,
  Map<String, ReelProgress> progress = const {},
}) {
  final pool = [
    for (final r in catalog)
      if (!r.isWithdrawn &&
          r.level == level &&
          r.category == category &&
          !used.contains(r.id))
        r,
  ];
  return _best(pool, progress);
}

/// Seçkiyi katalogdaki **güncel** sürümlerle eşler; geri çekilen/eksilen
/// içerik yerine aynı seviye-kategoriden yedek koyar (plan §5). Değişiklik
/// yoksa `null` döner (gereksiz yazma yok).
DailySet? reconcileDailySet({
  required DailySet set,
  required List<ReelSummary> catalog,
  Map<String, ReelProgress> progress = const {},
}) => reconcileDailySetDetailed(
  set: set,
  catalog: catalog,
  progress: progress,
)?.set;

/// [reconcileDailySet] ile aynı; ayrıca hangi kimliğin hangi yedekle
/// değiştirildiğini döndürür (H-096: kalınan video yedeğinden sürer).
({DailySet set, Map<String, String> replaced})? reconcileDailySetDetailed({
  required DailySet set,
  required List<ReelSummary> catalog,
  Map<String, ReelProgress> progress = const {},
}) {
  final replaced = <String, String>{};
  final byId = {for (final r in catalog) r.id: r};
  final items = <DailyItem>[];
  final used = <String>{};
  final families = <String>{};
  var changed = false;

  void keep(ReelSummary r, {required bool repeat}) {
    items.add(
      DailyItem(id: r.id, contentVersion: r.contentVersion, repeat: repeat),
    );
    used.add(r.id);
    if (r.family != null) families.add(r.family!);
  }

  for (final item in set.items) {
    final summary = byId[item.id];
    final usable =
        summary != null &&
        !summary.isWithdrawn &&
        (summary.family == null || !families.contains(summary.family));
    if (usable) {
      if (summary.contentVersion != item.contentVersion) changed = true;
      keep(summary, repeat: item.repeat);
      continue;
    }
    // Geri çekilmiş, eksilmiş ya da aynı hedefli: aynı seviye-kategoriden
    // yedek konur; uygun aday yoksa seçki **daha az video** ile sürer.
    changed = true;
    final yedek = substituteReel(
      catalog: catalog,
      level: set.level,
      // Katalogdan tamamen düşen içerikte `summary` yoktur; kategori
      // saklanan kimlikten okunur (backend yalnız yayımlanmışları döndürür).
      category: summary?.category ?? reelCategoryFromId(item.id) ?? '',
      used: used,
      progress: progress,
    );
    if (yedek != null) {
      keep(yedek, repeat: _shownBefore(yedek, progress));
      replaced[item.id] = yedek.id;
    }
  }
  if (!changed) return null;
  return (
    set: DailySet(level: set.level, categories: set.categories, items: items),
    replaced: replaced,
  );
}

/// Hiç tamamlanmamış önce, sonra en uzun süredir gösterilmemiş, sonra kimlik.
ReelSummary? _best(List<ReelSummary> pool, Map<String, ReelProgress> progress) {
  if (pool.isEmpty) return null;
  final sorted = [...pool]
    ..sort((a, b) {
      final ca = _completed(a, progress);
      final cb = _completed(b, progress);
      if (ca != cb) return ca ? 1 : -1;
      final la = _lastShown(a, progress);
      final lb = _lastShown(b, progress);
      if (la != lb) return la.compareTo(lb);
      return a.id.compareTo(b.id);
    });
  return sorted.first;
}

bool _completed(ReelSummary r, Map<String, ReelProgress> progress) =>
    progress[r.id]?.isCompletedFor(r.contentVersion) ?? false;

String _lastShown(ReelSummary r, Map<String, ReelProgress> progress) =>
    progress[r.id]?.lastShownDay ?? '';

/// Video kullanıcıya daha önce (bu sürümde) gösterildi mi.
bool _shownBefore(ReelSummary r, Map<String, ReelProgress> progress) {
  final p = progress[r.id];
  return p != null && p.isFor(r.contentVersion) && p.lastShownDay.isNotEmpty;
}
