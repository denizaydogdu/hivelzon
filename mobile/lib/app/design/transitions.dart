import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'tokens.dart';

/// Sayfa geçişleri (H-057).
///
/// İleri giden (push) alt sayfalarda yumuşak "solarak geç" + hafif kayma.
/// iOS'ta yerel kaydırma geçişi kalır: kenardan kaydırarak geri dönme
/// (swipe-back) yalnızca yerel geçişte çalışır ve kullanıcı bunu bekler.
/// Sekmeler arası geçiş anlıktır (`NoTransitionPage`).
/// "Hareketi azalt" açıksa geçiş yok (sayfa doğrudan görünür).
Page<T> appPage<T>({required LocalKey key, required Widget child}) {
  final platform = defaultTargetPlatform;
  if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
    return MaterialPage<T>(key: key, child: child);
  }
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: AppMotion.base,
    reverseTransitionDuration: AppMotion.base,
    transitionsBuilder: appFadeThroughTransition,
  );
}

/// Solarak geç + alttan hafif kayma; arkadaki sayfa hafifçe solar.
Widget appFadeThroughTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  if (AppMotion.reduced(context)) return child;
  final enter = CurvedAnimation(
    parent: animation,
    curve: AppMotion.enter,
    reverseCurve: AppMotion.exit,
  );
  final leave = CurvedAnimation(
    parent: secondaryAnimation,
    curve: AppMotion.standard,
  );
  return FadeTransition(
    opacity: Tween<double>(begin: 1, end: 0.6).animate(leave),
    child: FadeTransition(
      opacity: enter,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(enter),
        child: child,
      ),
    ),
  );
}
