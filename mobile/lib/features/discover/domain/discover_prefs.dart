// Keşfet videoları için cihazdaki tercihler (H-094 P2, plan §5):
// `discover.prefs` = kategoriler + seviye geçersiz kılma. Eşitlenmez.
//
// - `level` `null` ise seviye seçilmemiştir: yerleştirmenin önerisi (katalogda
//   karşılığı varsa) geçerlidir; aksi hâlde eldeki ilk seviye (K-06: öneri
//   bilgidir, vaat değil).
// - `categories` günlük seçkinin ilgi dağıtımında kullanılır (varsayılan üç
//   konu). Zorla gösterilmez: kapalı kategori günlük seçkiye girmez (plan §4).

import 'reel.dart';

/// Varsayılan kategoriler (yayın sırası = görünen sıra).
const List<String> kDefaultReelCategories = ['CIN', 'SPO', 'BOK'];

class DiscoverPrefs {
  const DiscoverPrefs({this.level, this.categories = kDefaultReelCategories});

  /// Elle seçilen seviye (`null` = öneri).
  final String? level;

  /// Günlük seçkide dağıtılacak kategoriler (boşsa seçki kurulamaz).
  final List<String> categories;

  /// Kategorileri katalog sırasına göre sadeleştirilmiş hâli.
  List<String> normalizedCategories() => [
    for (final c in kReelCategoryOrder)
      if (categories.contains(c)) c,
  ];

  DiscoverPrefs copyWith({
    String? level,
    bool clearLevel = false,
    List<String>? categories,
  }) => DiscoverPrefs(
    level: clearLevel ? null : (level ?? this.level),
    categories: categories ?? this.categories,
  );

  Map<String, dynamic> toJson() => {
    if (level != null && level!.isNotEmpty) 'level': level,
    'categories': categories,
  };

  static DiscoverPrefs fromJson(Object? raw) {
    if (raw is! Map) return const DiscoverPrefs();
    final j = raw.cast<String, dynamic>();
    final level = j['level'] as String?;
    final categories = [
      for (final c in (j['categories'] as List? ?? const []))
        if (c is String && kReelCategoryOrder.contains(c)) c,
    ];
    return DiscoverPrefs(
      level: level == null || level.isEmpty ? null : level,
      categories: categories.isEmpty ? kDefaultReelCategories : categories,
    );
  }
}
