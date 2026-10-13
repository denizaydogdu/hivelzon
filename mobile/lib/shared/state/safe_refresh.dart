import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderBase, ProviderOrFamily;

/// Sağlayıcıları **güvenle** yeniler (H-056).
///
/// Sorun (Riverpod 3): görünmeyen sekmedeki (TickerMode kapalı) ekranın
/// abonelikleri duraklatılır. Geçersiz kılınan bir sağlayıcının yalnızca
/// duraklatılmış dinleyicisi varsa yeniden hesaplanmaz, "kirli" bekler. Sekme
/// yeniden görünürken (Flutter build aşamasının içinde) abonelik sürdürülür,
/// kirli sağlayıcı o anda hesaplanır ve ona bağlı **başka bir sağlayıcı**
/// (ör. `seasonMapProvider` → `storyProgressProvider`) Riverpod
/// zamanlayıcısını tetikler: `ProviderScope` build sırasında `setState`
/// çağırır → "setState() or markNeedsBuild() called during build".
///
/// Çözüm: geçersiz kılmanın hemen ardından, build dışında, var olan her
/// sağlayıcı bir kez okunur (`ref.read`): zincir o anda hesaplanır, sekme
/// görünür olduğunda kirli sağlayıcı kalmaz. Okuma, duraklatılmış
/// dinleyicileri olan `autoDispose` sağlayıcıyı kapatmaz (dinleyicisi var).
///
/// Build sırasında çağrılırsa iş kare sonuna ertelenir. Aile (family)
/// sağlayıcıları yalnızca geçersiz kılınır.
void invalidateAndFlush(WidgetRef ref, Iterable<ProviderOrFamily> providers) {
  final list = List<ProviderOrFamily>.of(providers);
  void run() {
    if (ref is BuildContext && !(ref as BuildContext).mounted) return;
    for (final p in list) {
      ref.invalidate(p);
    }
    for (final p in list) {
      if (p is ProviderBase<Object?> && ref.exists(p)) ref.read(p);
    }
  }

  if (SchedulerBinding.instance.schedulerPhase ==
      SchedulerPhase.persistentCallbacks) {
    SchedulerBinding.instance.addPostFrameCallback((_) => run());
  } else {
    run();
  }
}
