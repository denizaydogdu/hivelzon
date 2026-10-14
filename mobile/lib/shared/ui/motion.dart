import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/design/tokens.dart';

/// Dokunma tepkisi (H-057): basılıyken hafifçe küçülür (0,97, 150 ms),
/// bırakınca geri gelir. Dokunmayı kendisi yakalamaz; içteki düğme ya da
/// `InkWell` çalışmaya devam eder. "Hareketi azalt" açıksa ölçek değişmez.
class PressScale extends StatefulWidget {
  const PressScale({super.key, required this.child, this.enabled = true});

  final Widget child;

  /// Kapalıysa (ör. devre dışı düğme) tepki yok.
  final bool enabled;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _pressed = false;

  void _set(bool v) {
    if (_pressed != v && mounted) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.enabled && !AppMotion.reduced(context);
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: active ? (_) => _set(true) : null,
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: active && _pressed ? AppMotion.pressScale : 1,
        duration: AppMotion.fast,
        curve: AppMotion.standard,
        child: widget.child,
      ),
    );
  }
}

/// Öğeleri sırayla belirtir (solarak + hafif yukarı kayarak). Uzun listede
/// yalnızca ilk [AppMotion.staggerMaxItems] öğe gecikir; kullanıcı
/// beklemez. "Hareketi azalt" açıksa öğeler doğrudan görünür.
///
/// Gecikme `flutter_animate` efektinin içindedir (zamanlayıcı yok), bu yüzden
/// testlerde bekleyen `Timer` bırakmaz.
class StaggeredList extends StatelessWidget {
  const StaggeredList({
    super.key,
    required this.children,
    this.spacing = AppSpace.s16,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  final List<Widget> children;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final still = AppMotion.reduced(context);
    final items = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0 && spacing > 0) items.add(SizedBox(height: spacing));
      items.add(still ? children[i] : staggerIn(children[i], i));
    }
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: items,
    );
  }

  /// Tek öğeye sırayla belirme efekti ([index]. sırada). Liste dışı
  /// kullanımlar için (ör. `ListView.builder` öğeleri).
  static Widget staggerIn(Widget child, int index) {
    final delay =
        AppMotion.stagger *
        (index < AppMotion.staggerMaxItems ? index : AppMotion.staggerMaxItems);
    return child
        .animate()
        .fadeIn(delay: delay, duration: AppMotion.base, curve: AppMotion.enter)
        .slideY(
          begin: AppMotion.slideOffset,
          end: 0,
          delay: delay,
          duration: AppMotion.base,
          curve: AppMotion.enter,
        );
  }
}

/// Tek öğenin belirmesi (ör. bir panelin ilk açılışı). Hareket azaltılmışsa
/// doğrudan görünür.
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({super.key, required this.child, this.index = 0});

  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) => AppMotion.reduced(context)
      ? child
      : StaggeredList.staggerIn(child, index);
}
