import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/design/tokens.dart';
import '../../app/design/typography.dart';
import '../../l10n/tr_strings.dart';
import 'crash_log.dart';

/// Uygulamanın çökme kaydı (H-043). Testlerde geçici klasörlü bir kayıtla
/// değiştirilir.
final crashLogProvider = Provider<CrashLog>((ref) => CrashLog.instance);

/// Çökme yakalama (H-043): Flutter çizim hataları, platform hataları ve
/// yakalanmamış asenkron hatalar yerel kayda yazılır ([CrashLog]). Üçüncü
/// taraf yok, ağ yok. Debug'da hatalar ayrıca eskisi gibi konsolda görünür.
abstract final class CrashReporting {
  static CrashLog? _log;

  /// `main()` içinde, `runApp`'ten önce ve aynı bölgede (`runZonedGuarded`)
  /// çağrılır. [release] testte değiştirilebilir.
  static void install(CrashLog log, {bool release = kReleaseMode}) {
    _log = log;
    final previous = FlutterError.onError;
    FlutterError.onError = (details) {
      unawaited(log.record('flutter', details.exception, details.stack));
      if (previous != null) {
        previous(details);
      } else {
        FlutterError.presentError(details);
      }
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      unawaited(log.record('platform', error, stack));
      if (!release) debugPrint('[H043] yakalanmamış hata: $error');
      // İşlendi: uygulama kapanmaz; kullanıcı sakin hata ekranını görür.
      return true;
    };
    if (release) ErrorWidget.builder = (_) => const CalmErrorBox();
  }

  /// `runZonedGuarded` hata işleyicisi.
  static void onZoneError(Object error, StackTrace stack) {
    final log = _log ?? CrashLog.instance;
    unawaited(log.record('zone', error, stack));
    if (kDebugMode) debugPrint('[H043] bölge hatası: $error\n$stack');
  }
}

/// Yayın derlemesinde çizilemeyen parçanın yerine görünen sakin kutu
/// (H-043). Kırmızı hata ekranı ve teknik metin yok. Tema gerektirmez
/// (ağacın herhangi bir yerinde çizilebilir); dar alanda yalnız zemin.
class CalmErrorBox extends StatelessWidget {
  const CalmErrorBox({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppTypography.textTheme(AppPalette.ink);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: text.bodyMedium!,
        child: Semantics(
          label: CrashTexts.errorBoxTitle,
          container: true,
          child: ColoredBox(
            color: AppPalette.sand,
            child: LayoutBuilder(
              builder: (context, c) {
                final roomy =
                    c.hasBoundedHeight &&
                    c.hasBoundedWidth &&
                    c.maxHeight >= 120 &&
                    c.maxWidth >= 200;
                if (!roomy) return const SizedBox.expand();
                return ExcludeSemantics(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpace.s16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              CrashTexts.errorBoxTitle,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: text.titleMedium,
                            ),
                          ),
                          const SizedBox(height: AppSpace.s4),
                          Flexible(
                            child: Text(
                              CrashTexts.errorBoxBody,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: text.bodyMedium?.copyWith(
                                color: AppPalette.ink500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
