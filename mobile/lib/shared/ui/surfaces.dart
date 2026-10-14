import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/design/tokens.dart';
import '../../l10n/tr_strings.dart';

/// Alt panel iskeleti (H-057): tutamaç + isteğe bağlı başlık ve "Kapat"
/// satırı + içerik. Kum zemin, üst köşeler 20 px. Ekranlardaki 8 ayrı sheet
/// iskeletinin yerine (ekran fazlarında).
class AppSheet extends StatelessWidget {
  const AppSheet({
    super.key,
    required this.child,
    this.title,
    this.closeLabel = CommonTexts.close,
    this.onClose,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpace.s16,
      0,
      AppSpace.s16,
      AppSpace.s24,
    ),
  });

  final Widget child;
  final String? title;

  /// Kapat düğmesinin ekran okuyucu etiketi.
  final String closeLabel;

  /// Verilmezse `Navigator.pop`.
  final VoidCallback? onClose;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpace.s8),
          Center(
            child: Container(
              width: AppSpace.s32,
              height: AppSpace.s4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpace.s16,
              AppSpace.s4,
              AppSpace.s4,
              AppSpace.s4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: title == null
                      ? const SizedBox.shrink()
                      : Semantics(
                          header: true,
                          child: Text(
                            title!,
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                ),
                IconButton(
                  onPressed: onClose ?? () => Navigator.of(context).maybePop(),
                  tooltip: closeLabel,
                  icon: Icon(Icons.close_rounded, semanticLabel: closeLabel),
                ),
              ],
            ),
          ),
          Flexible(
            child: Padding(padding: padding, child: child),
          ),
        ],
      ),
    );
  }
}

/// [AppSheet] ile alt panel açar. İçerik uzunsa kaydırılabilir olmalıdır
/// (`isScrollControlled: true`, en fazla ekranın %90'ı). Kök gezginde açılır:
/// sekme çubuğunu ve Hi balonunu da örter (H-059; balon panelin üstünde
/// kalıyordu).
Future<T?> showAppSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  String? title,
  String closeLabel = CommonTexts.close,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    useSafeArea: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.9,
    ),
    builder: (context) =>
        AppSheet(title: title, closeLabel: closeLabel, child: builder(context)),
  );
}

/// Şekilli başlığın alt kenarı.
enum HeaderShape { wave, diagonal }

/// Şekilli sayfa başlığı (H-057): dalga ya da çapraz kesimli alt kenar,
/// isteğe bağlı illüstrasyon ve üstünde başlık. İllüstrasyon varsa okunurluk
/// için alttan koyulaşan perde eklenir.
class ShapedHeader extends StatelessWidget {
  const ShapedHeader({
    super.key,
    this.title,
    this.subtitle,
    this.shape = HeaderShape.wave,
    this.image,
    this.height = 200,
    this.color = AppPalette.seaBlue,
    this.leading,
  });

  /// Başlık. Verilmezse yalnızca şekilli görsel çizilir (kimlik bilgisi
  /// başlığın altında durur, ör. Profil; perde de eklenmez).
  final String? title;
  final String? subtitle;
  final HeaderShape shape;

  /// İllüstrasyon (H-058 görselleri). Görselde yazı olmaz.
  final ImageProvider? image;
  final double height;

  /// İllüstrasyon yokken zemin rengi.
  final Color color;

  /// Başlığın üstünde küçük öğe (ör. avatar).
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const onColor = AppPalette.white;
    return ClipPath(
      clipper: ShapedEdgeClipper(shape),
      // En az [height]; büyük yazıda (1,3×) içerik kadar uzar, taşmaz.
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height),
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            // Yüksekliği en az [height] yapan ve genişliği dolduran zemin.
            SizedBox(width: double.infinity, height: height),
            Positioned.fill(child: ColoredBox(color: color)),
            if (image != null) ...[
              Positioned.fill(
                child: Image(
                  image: image!,
                  fit: BoxFit.cover,
                  excludeFromSemantics: true,
                ),
              ),
              if (title != null)
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppScrim.gradientEnd],
                      ),
                    ),
                  ),
                ),
            ] else
              const Positioned.fill(child: _HeaderDecor()),
            if (title != null)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpace.s24,
                  AppSpace.s16,
                  AppSpace.s24,
                  height * 0.22,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(height: AppSpace.s12),
                    ],
                    Semantics(
                      header: true,
                      child: Text(
                        title!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: onColor,
                        ),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpace.s4),
                      Text(
                        subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: onColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// İllüstrasyonsuz başlıkta sakin süs: sağ üstte fener ışığı gibi iki
/// yumuşak daire.
class _HeaderDecor extends StatelessWidget {
  const _HeaderDecor();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -AppSpace.s48,
          top: -AppSpace.s48,
          child: _circle(180, AppPalette.lighthouseYellow, 0.22),
        ),
        Positioned(
          right: AppSpace.s48,
          top: AppSpace.s24,
          child: _circle(56, AppPalette.lighthouseYellow, 0.35),
        ),
        Positioned(
          left: -AppSpace.s32,
          bottom: -AppSpace.s32,
          child: _circle(120, AppPalette.seaBlue300, 0.25),
        ),
      ],
    );
  }

  static Widget _circle(double size, Color c, double alpha) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: c.withValues(alpha: alpha),
    ),
  );
}

/// [ShapedHeader]'ın alt kenar kesimi; başka yüzeylerde de kullanılır (ör.
/// Ana Sayfa'daki bölüm kartının görseli, H-060).
class ShapedEdgeClipper extends CustomClipper<Path> {
  const ShapedEdgeClipper(this.shape);

  final HeaderShape shape;

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final p = Path()..lineTo(0, h * 0.86);
    switch (shape) {
      case HeaderShape.wave:
        p
          ..cubicTo(w * 0.22, h * 1.0, w * 0.42, h * 0.78, w * 0.62, h * 0.86)
          ..cubicTo(w * 0.80, h * 0.93, w * 0.92, h * 0.90, w, h * 0.80);
      case HeaderShape.diagonal:
        p.lineTo(w, h * 0.70);
    }
    return p
      ..lineTo(w, 0)
      ..close();
  }

  @override
  bool shouldReclip(ShapedEdgeClipper old) => old.shape != shape;
}

/// Boş durum (H-057): illüstrasyon ya da ikon + başlık + açıklama + eylem.
/// "Boş ekran bir davettir": metin ne yapılacağını söyler.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.illustration,
    this.action,
  });

  final String title;
  final String? message;

  /// İllüstrasyon yokken gösterilir.
  final IconData? icon;

  /// İllüstrasyon (H-058; ör. `Image.asset`).
  final Widget? illustration;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.s24,
        vertical: AppSpace.s32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (illustration != null)
            ExcludeSemantics(child: SizedBox(height: 160, child: illustration))
          else if (icon != null)
            ExcludeSemantics(
              child: Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: AppPalette.seaBlue50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: AppIconSize.xl,
                  color: AppPalette.seaBlue,
                ),
              ),
            ),
          const SizedBox(height: AppSpace.s24),
          Semantics(
            header: true,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpace.s8),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppPalette.ink500,
              ),
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: AppSpace.s24),
            action!,
          ],
        ],
      ),
    );
  }
}

/// Durum çubuğu perdesi (H-064): üst güvenli alanı olmayan, illüstrasyonu
/// durum çubuğunun altına uzanan kaydırılan sayfalarda (Profil, açılışın
/// karşılama adımı) içerik kaydırılınca saatin ve Dynamic Island'ın altına
/// kum renkli sakin bir şerit belirir; içerik saatin üstüne binmez.
///
/// [child] içindeki ilk dikey kaydırmayı dinler. Sayfa en üstteyken şerit
/// görünmez (illüstrasyon durum çubuğunun altında, simgeler açık renk);
/// kaydırılınca şerit belirir, simgeler koyulaşır. "Hareketi azalt" açıksa
/// geçiş anlıktır.
class StatusBarScrim extends StatefulWidget {
  const StatusBarScrim({
    super.key,
    required this.child,
    this.color = AppPalette.sand,
    this.revealAfter = AppSpace.s8,
  });

  final Widget child;

  /// Şeridin rengi (sayfa zemini).
  final Color color;

  /// Bu kadar kaydırılınca şerit belirir.
  final double revealAfter;

  @override
  State<StatusBarScrim> createState() => _StatusBarScrimState();
}

class _StatusBarScrimState extends State<StatusBarScrim> {
  bool _covered = false;

  bool _onScroll(ScrollNotification n) {
    if (n.depth != 0 || n.metrics.axis != Axis.vertical) return false;
    final covered = n.metrics.pixels > widget.revealAfter;
    if (covered != _covered) setState(() => _covered = covered);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final reduced = AppMotion.reduced(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _covered ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: Stack(
          children: [
            Positioned.fill(child: widget.child),
            if (top > 0)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: top,
                child: IgnorePointer(
                  ignoring: !_covered,
                  child: AnimatedOpacity(
                    key: const ValueKey('status-bar-scrim'),
                    opacity: _covered ? 1 : 0,
                    duration: reduced ? Duration.zero : AppMotion.fast,
                    curve: AppMotion.standard,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: widget.color,
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                      ),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
