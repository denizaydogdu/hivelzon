import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'content_source.dart';
import 'http_content_source.dart';

/// Testlerde `overrideWithValue` ile değiştirilir.
final contentSourceProvider = Provider<ContentSource>(
  (ref) => HttpContentSource(),
);

/// Hikâye sekmesindeki geçici bölüm listesi (gerçek harita H-035).
///
/// Otomatik yeniden deneme kapalı: hata ekranı "Tekrar dene" ile kullanıcıya bırakılır.
final packageListProvider = FutureProvider.autoDispose<List<PackageSummary>>(
  (ref) => ref.watch(contentSourceProvider).listPackages(),
  retry: (_, _) => null,
);

/// Sezon paketi (H-050). Yüklenemezse Hikâye sekmesi sezon başlığını gizler.
final seasonProvider = FutureProvider.autoDispose.family<SeasonInfo, int>(
  (ref, season) => ref.watch(contentSourceProvider).loadSeason(season),
  retry: (_, _) => null,
);
