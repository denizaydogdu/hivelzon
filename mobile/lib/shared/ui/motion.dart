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

/// Tembel listede (`SliverList.builder`, ızgara) sırayla belirme, **yalnız
/// öğenin ilk görünüşünde** (H-061). [seen] ekranın durumunda tutulur: liste
/// kaydırılıp öğe yeniden kurulunca ya da arama süzünce yeniden oynamaz. İlk
/// [AppMotion.staggerMaxItems] öğe dışındakiler beklemeden görünür.
/// "Hareketi azalt" açıksa durağan.
class StaggerOnce extends StatefulWidget {
  const StaggerOnce({
    super.key,
    required this.id,
    required this.index,
    required this.seen,
    required this.child,
  });

  /// Öğenin kalıcı kimliği (ör. ifade anahtarı).
  final Object id;
  final int index;
  final Set<Object> seen;
  final Widget child;

  @override
  State<StaggerOnce> createState() => _StaggerOnceState();
}

class _StaggerOnceState extends State<StaggerOnce> {
  late final bool _play =
      widget.index < AppMotion.staggerMaxItems && widget.seen.add(widget.id);

  @override
  Widget build(BuildContext context) {
    // `_play` ilk kurulumda bir kez hesaplanır ve kimlik o anda işaretlenir.
    final play = _play;
    if (!play || AppMotion.reduced(context)) return widget.child;
    return StaggeredList.staggerIn(widget.child, widget.index);
  }
}

/// Sakin belirme (H-061): geri bildirim ve özet ikonları hafifçe büyüyerek
/// gelir (0,85 → 1, 400 ms); zıplama, titreme ya da tekrar yok (K-32).
/// "Hareketi azalt" açıksa doğrudan son hâli.
///
/// H-062: örtük animasyonla (`TweenAnimationBuilder`) çizilir; zamanlayıcı
/// bırakmaz (oynatıcı ve bölüm sonu tek karede de test edilebilir).
class CalmPop extends StatelessWidget {
  const CalmPop({super.key, required this.child});

  final Widget child;

  static const _fadeEnd = 0.625; // base / slow

  @override
  Widget build(BuildContext context) {
    if (AppMotion.reduced(context)) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppMotion.slow,
      child: child,
      builder: (context, t, child) => Opacity(
        opacity: const Interval(
          0,
          _fadeEnd,
          curve: AppMotion.enter,
        ).transform(t),
        child: Transform.scale(
          scale: 0.85 + 0.15 * Curves.easeOutBack.transform(t),
          child: child,
        ),
      ),
    );
  }
}

/// Tek öğenin yumuşak girişi (H-062): solarak ve hafifçe yukarı kayarak
/// gelir; [index] ile sırayla (öğe başına [AppMotion.stagger], en çok
/// [AppMotion.staggerMaxItems]). Örtük animasyon: zamanlayıcı yok, ilk
/// karede de dokunulabilir. "Hareketi azalt" açıksa doğrudan görünür.
class SoftEntrance extends StatelessWidget {
  const SoftEntrance({super.key, required this.child, this.index = 0});

  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (AppMotion.reduced(context)) return child;
    final steps = index < AppMotion.staggerMaxItems
        ? index
        : AppMotion.staggerMaxItems;
    final delay = AppMotion.stagger * steps;
    final total = AppMotion.base + delay;
    final start = delay.inMicroseconds / total.inMicroseconds;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: total,
      curve: Interval(start, 1, curve: AppMotion.enter),
      child: child,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: FractionalTranslation(
          translation: Offset(0, (1 - t) * AppMotion.slideOffset),
          child: child,
        ),
      ),
    );
  }
}

/// Sakin kutlama (H-061): fener ışığı gibi iki yumuşak sarı halka ve ortada
/// ikon. Bir kez belirir; dış halka hafifçe genişleyip yerine oturur. Konfeti,
/// ses, titreme ya da tekrar eden ışık yok (K-32). Hareket azaltılmışsa
/// durağan. Ekran okuyucuya görünmez (süs).
class CalmCelebration extends StatelessWidget {
  const CalmCelebration({super.key, required this.icon, this.size = 112});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final still = AppMotion.reduced(context);
    Widget halo = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppPalette.yellow100,
        shape: BoxShape.circle,
      ),
    );
    if (!still) {
      // Örtük animasyon (H-062): zamanlayıcı bırakmaz.
      halo = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: AppMotion.slow * 2,
        child: halo,
        builder: (context, t, child) => Opacity(
          opacity: const Interval(0, 0.5, curve: AppMotion.enter).transform(t),
          child: Transform.scale(
            scale: 0.6 + 0.4 * AppMotion.enter.transform(t),
            child: child,
          ),
        ),
      );
    }
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            halo,
            CalmPop(
              child: Container(
                width: size * 0.68,
                height: size * 0.68,
                decoration: const BoxDecoration(
                  color: AppPalette.yellow200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: AppIconSize.xl,
                  color: AppPalette.orange700,
                ),
              ),
            ),
          ],
        ),
      ),
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
