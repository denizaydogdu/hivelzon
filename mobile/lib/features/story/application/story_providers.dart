import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../shared/content/content_providers.dart';
import '../../../shared/progress/story_progress.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../player/data/progress_repository.dart';
import '../domain/season_map.dart';

/// Bütün bölümlerin yerel ilerlemesi. Oynatıcıdan dönünce yenilenir.
final storyProgressProvider =
    FutureProvider.autoDispose<Map<String, StoryProgress>>(
      (ref) => ref.watch(progressRepositoryProvider).loadAll(),
      retry: (_, _) => null,
    );

/// Hikâye haritası ve Ana Sayfa kartı için sezon durumu (H-035).
///
/// Paket listesi yüklenemezse hata verir ("Sunucu çalışmıyor"). Sezon paketi
/// yüklenemezse harita yalnızca sunucudaki bölümlerle çizilir. Eşzamanlı
/// birleştirme: ilerleme yenilenirken eski harita görünür kalır (yanıp sönmez).
final seasonMapProvider = Provider.autoDispose<AsyncValue<SeasonMap>>((ref) {
  final packages = ref.watch(packageListProvider);
  final progress = ref.watch(storyProgressProvider);
  if (packages.hasError && !packages.isLoading) {
    return AsyncError(packages.error!, packages.stackTrace ?? StackTrace.empty);
  }
  if (progress.hasError && !progress.isLoading) {
    return AsyncError(progress.error!, progress.stackTrace ?? StackTrace.empty);
  }
  final list = packages.value;
  final saved = progress.value;
  if (list == null || saved == null) return const AsyncLoading();
  final seasons = [
    ...{for (final p in list) ?p.season},
  ]..sort();
  final season = seasons.isEmpty ? 1 : seasons.first;
  final info = ref.watch(seasonProvider(season));
  if (!info.hasValue && !info.hasError) return const AsyncLoading();
  return AsyncData(
    buildSeasonMap(
      season: season,
      info: info.value,
      packages: list,
      progress: saved,
    ),
  );
});

/// "Tekrar dene": paket listesi, sezon paketi ve ilerleme yeniden okunur.
void retrySeasonMap(WidgetRef ref) {
  ref.invalidate(packageListProvider);
  ref.invalidate(seasonProvider);
  ref.invalidate(storyProgressProvider);
}

/// Bölümü açar; oynatıcıdan dönünce harita ve Ana Sayfa kartı yenilenir.
/// [mode]: `resume` | `restart` | `null` (kayıt varsa oynatıcı sorar).
Future<void> openEpisode(
  BuildContext context,
  WidgetRef ref,
  String contentId, {
  String? mode,
}) async {
  await context.push(AppRoutes.play(contentId, mode: mode));
  if (!context.mounted) return;
  await refreshWhenVisible(context, ref);
}

/// İlerlemeyi yeniler; ekran görünür olana dek (TickerMode açık) bekler.
///
/// Riverpod 3, görünmeyen ekrandaki dinleyicileri duraklatır. Duraklatılmış
/// dinleyici varken geçersiz kılınan sağlayıcı, ekran yeniden görünürken
/// build sırasında yenilenir ve hata verir; bu yüzden önce ekranın
/// görünmesi beklenir (en çok ~1 sn).
Future<void> refreshWhenVisible(BuildContext context, WidgetRef ref) async {
  for (var i = 0; i < 60; i++) {
    if (!context.mounted) return;
    if (TickerMode.getNotifier(context).value) break;
    await WidgetsBinding.instance.endOfFrame;
  }
  if (!context.mounted) return;
  ref.invalidate(storyProgressProvider);
  // Biten bölümün ifadeleri deftere geçmiş olabilir (H-036).
  ref.invalidate(reviewOverviewProvider);
}
