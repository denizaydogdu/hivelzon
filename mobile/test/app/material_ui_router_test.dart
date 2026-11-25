// H-117: flutter/material.dart → material_ui göçü. material_ui ayrı sınıflar
// getirir (ayrı MaterialApp, Theme, MaterialLocalizations). go_router 17.x
// yalnız eski MaterialApp'i tanır; material_ui uygulamasında `builder:`
// rotalarını geçişsiz (WidgetsApp) sayfayla ve yanlış HeroController ile kurar.
// Bu test (1) go_router'ın material_ui MaterialApp'ini tanıdığını (17.x'te
// kırmızı), (2) material_ui'nin yerelleştirme listesinin Türkçe Material
// metinlerini verdiğini (eski flutter_localizations delegeleri
// material_ui türlerine Türkçe vermez), (3) push edilen rotada uygulama
// temasının geldiğini doğrular. app.dart aynı delegeleri kullanır.
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('go_router material_ui ile Material sayfası, tema ve Türkçe '
      'yerelleştirme kurar', (tester) async {
    late BuildContext detailContext;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: Text('ana')),
          routes: [
            GoRoute(
              path: 'detay',
              builder: (context, state) {
                detailContext = context;
                return const Scaffold(body: Text('detay'));
              },
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);
    final theme = AppTheme.light();

    await tester.pumpWidget(
      MaterialApp.router(
        theme: theme,
        locale: const Locale('tr'),
        supportedLocales: const [Locale('tr')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        routerConfig: router,
      ),
    );
    router.push('/detay');
    await tester.pumpAndSettle();

    // `builder:` ile kurulan rota Material geçişli sayfa olmalı (go_router
    // uygulama türünü tanıdı); NoTransitionPage/WidgetsApp yolu değil.
    final route = ModalRoute.of(detailContext);
    expect(route, isA<MaterialRouteTransitionMixin<dynamic>>());

    expect(
      Theme.of(detailContext).colorScheme.primary,
      theme.colorScheme.primary,
    );
    expect(MaterialLocalizations.of(detailContext).backButtonTooltip, 'Geri');
  });
}
