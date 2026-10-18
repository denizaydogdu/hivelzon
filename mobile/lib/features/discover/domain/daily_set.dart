// Günlük seçkinin cihazdaki kaydı (H-094 P2, plan §5): `discover.daily.<gün>`.
//
// Seçki **kimlik + içerik sürümü** listesiyle saklanır; aynı yerel gün içinde
// yeniden seçilmez (kararlılık). `prefsSnapshot` (seviye + kategoriler) da
// saklanır: seviye ya da kategoriler değişirse seçki **açıkça yeni başlar**
// (günlük izleme sayacı ve öğrenme kayıtları silinmez — plan §5).

/// Günlük seçkideki tek video.
class DailyItem {
  const DailyItem({
    required this.id,
    required this.contentVersion,
    this.repeat = false,
  });

  final String id;

  /// Seçki yazıldığı andaki içerik sürümü; oynatılırken **güncel** sürüm
  /// gösterilir, sürüm artınca video yeniden "izlenmemiş" sayılır.
  final int contentVersion;

  /// Video kullanıcıya daha önce gösterildiği için **tekrar** olarak
  /// etiketlendi mi (etiket gün içinde değişmez).
  final bool repeat;

  Map<String, dynamic> toJson() => {
    'id': id,
    'contentVersion': contentVersion,
    if (repeat) 'repeat': true,
  };

  static DailyItem? fromJson(Object? raw) {
    if (raw is! Map) return null;
    final j = raw.cast<String, dynamic>();
    final id = j['id'] as String?;
    final version = (j['contentVersion'] as num?)?.toInt();
    if (id == null || id.isEmpty || version == null) return null;
    return DailyItem(
      id: id,
      contentVersion: version,
      repeat: j['repeat'] == true,
    );
  }
}

/// Bir yerel güne ait seçki (`discover.daily.<gün>` gövdesi).
class DailySet {
  const DailySet({
    required this.level,
    required this.categories,
    required this.items,
    this.schemaVersion = 1,
  });

  final int schemaVersion;

  /// Seçkinin yapıldığı seviye (`prefsSnapshot`).
  final String level;

  /// Seçkinin yapıldığı kategoriler (sıralı, `prefsSnapshot`).
  final List<String> categories;

  final List<DailyItem> items;

  /// Seçki şu anki tercihlerle uyuşuyor mu (seviye + kategori kümesi).
  /// Uyuşmuyorsa yeni seçim **açıkça** başlar (plan §5).
  bool matches({required String level, required List<String> categories}) =>
      this.level == level && _sameSet(this.categories, categories);

  Map<String, dynamic> toJson() => {
    'schemaVersion': schemaVersion,
    'level': level,
    'categories': categories,
    'items': [for (final i in items) i.toJson()],
  };

  static DailySet? fromJson(Object? raw) {
    if (raw is! Map) return null;
    final j = raw.cast<String, dynamic>();
    if ((j['schemaVersion'] as num?)?.toInt() != 1) return null;
    final level = j['level'] as String?;
    if (level == null || level.isEmpty) return null;
    return DailySet(
      level: level,
      categories: [
        for (final c in (j['categories'] as List? ?? const []))
          if (c is String && c.isNotEmpty) c,
      ],
      items: [
        for (final i in (j['items'] as List? ?? const []))
          ?DailyItem.fromJson(i),
      ],
    );
  }
}

bool _sameSet(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  final x = [...a]..sort();
  final y = [...b]..sort();
  for (var i = 0; i < x.length; i++) {
    if (x[i] != y[i]) return false;
  }
  return true;
}
