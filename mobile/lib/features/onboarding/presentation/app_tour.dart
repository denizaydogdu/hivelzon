import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/ui/ui.dart';
import '../../player/presentation/widgets/hi_avatar.dart';
import '../application/onboarding_providers.dart';

/// Uygulama açıldıktan sonra **yalnızca bir kez** gösterilen kısa tur
/// (2026-10-26). Açılışın "Hazır" adımı turu işaretler; bu kapı bekleyen tur
/// varsa iskeletin üstüne Hi'nin kartını açar. "Atla" da turu kapatır ve bir
/// daha gösterilmez.
class AppTourGate extends ConsumerWidget {
  const AppTourGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(tourPendingProvider).value ?? false;
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        if (pending)
          AppTourOverlay(
            onDone: () async {
              try {
                await ref.read(onboardingStoreProvider).markTourSeen();
              } on Object catch (e) {
                // Tur işareti yazılamazsa uygulama akışı durmaz.
                debugPrint('[tour] işaret yazılamadı: $e');
              }
              // Başarısız olsa da yeniden oku: tur kapanır (yazılamadıysa
              // bir sonraki açılışta yeniden denenir).
              if (context.mounted) ref.invalidate(tourPendingProvider);
            },
          ),
      ],
    );
  }
}

/// Tur kartı: altta Hi'nin sakin anlatımı, üstte karartılmış uygulama.
/// Zaman sınırı ve zorunluluk yok; "Atla" her an açık.
class AppTourOverlay extends StatefulWidget {
  const AppTourOverlay({super.key, required this.onDone});

  /// Tur bitti ya da atlandı (işareti yazan taraf).
  final Future<void> Function() onDone;

  @override
  State<AppTourOverlay> createState() => _AppTourOverlayState();
}

class _AppTourOverlayState extends State<AppTourOverlay> {
  static const _steps = TourTexts.steps;

  int _index = 0;
  bool _busy = false;

  bool get _last => _index == _steps.length - 1;

  Future<void> _finish() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.onDone();
    } on Object catch (e) {
      // Kapanış yazılamazsa kart açık kalır; kullanıcı yeniden deneyebilir.
      debugPrint('[tour] kapatılamadı: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _next() {
    if (_busy) return;
    if (_last) {
      unawaited(_finish());
      return;
    }
    setState(() => _index++);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final step = _steps[_index];
    final reduced = AppMotion.reduced(context);
    final duration = reduced ? Duration.zero : AppMotion.base;
    return Material(
      key: const ValueKey('tour-overlay'),
      color: AppScrim.dim,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        // Tur açıkken alttaki sekmelere dokunulmaz.
        onTap: () {},
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(AppSpace.s16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpace.s16),
                      decoration: const BoxDecoration(
                        color: AppPalette.white,
                        borderRadius: AppRadius.lgAll,
                        boxShadow: AppShadows.level3,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ExcludeSemantics(
                                child: HiAvatar(
                                  size: 64,
                                  glow: false,
                                  greet: _index == 0,
                                  expression: _index == 0
                                      ? HiExpression.waving
                                      : HiExpression.happy,
                                ),
                              ),
                              const SizedBox(width: AppSpace.s16),
                              Expanded(
                                child: AnimatedSwitcher(
                                  duration: duration,
                                  switchInCurve: AppMotion.enter,
                                  switchOutCurve: AppMotion.exit,
                                  child: Column(
                                    key: ValueKey('tour-step-$_index'),
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CapsLabel(
                                        TourTexts.stepLabel(
                                          _index + 1,
                                          _steps.length,
                                        ),
                                        tone: CapsTone.blue,
                                      ),
                                      const SizedBox(height: AppSpace.s4),
                                      Semantics(
                                        header: true,
                                        child: Text(
                                          step.title,
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                                color: AppPalette.seaBlue,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: AppSpace.s8),
                                      Text(
                                        step.body,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: AppPalette.ink700,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              TextButton(
                                key: const ValueKey('tour-skip'),
                                onPressed: _busy
                                    ? null
                                    : () => unawaited(_finish()),
                                child: const Text(TourTexts.skip),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpace.s16),
                          Row(
                            children: [
                              _Dots(index: _index, count: _steps.length),
                              const Spacer(),
                              FilledButton(
                                key: const ValueKey('tour-next'),
                                style: AppButtonStyles.primary(),
                                onPressed: _busy ? null : _next,
                                child: Text(
                                  _last ? TourTexts.finish : TourTexts.next,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.index, required this.count});

  final int index;
  final int count;

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.of(context, AppMotion.base);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: duration,
            curve: AppMotion.standard,
            margin: const EdgeInsets.only(right: AppSpace.s8),
            width: i == index ? AppSpace.s24 : AppSpace.s8,
            height: AppSpace.s8,
            decoration: BoxDecoration(
              color: i <= index ? AppPalette.seaBlue : AppPalette.ink200,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
      ],
    );
  }
}
