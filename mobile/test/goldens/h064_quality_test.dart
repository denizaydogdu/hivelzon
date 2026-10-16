// H-064 kalite turu: başka dosyada denetlenmeyen ekranlar uygulamanın
// kabuğu içinde (alt sekme çubuğu ve Hi balonu dahil) erişilebilirlik
// yönergelerine ve en küçük hedef ekrana (320 × 568, metin 1,3×) karşı
// denetlenir. Golden yok; ekranların golden'ları kendi dosyalarında.
//
// Kapsam haritası (her ekranın dokunma hedefi / etiket / kontrast ve
// 320 × 568 · 1,3× taşma testi nerede):
// - Açılış: test/features/onboarding/onboarding_ui_test.dart
// - Ana Sayfa, harita, bölüm paneli: h060_screens_golden_test.dart
// - Defter, ipucu panosu, konu setleri, kelime tekrarı, konu seti, sahne
//   avı: h061_screens_golden_test.dart
// - Oynatıcı, karar, görev paneli, anlam paneli, bölüm sonu: h062
// - Keşfet: h040_discover_golden_test.dart
// - Kitaplık, okuyucu, kitap sonu: h067_screens_golden_test.dart
// - Dilbilgisi listesi, ders, alıştırma, ders sonu: h078
// - Profil, Hesap, Hi gizlilik, hukuk metni, giriş, günlük hedef ve ad
//   panelleri: h059_screens_golden_test.dart
// - Bu dosya: sekme kökleri kabukla birlikte, Hi paneli, Konuş, sezon
//   jeneriği.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/app.dart';
import 'package:hivelzon/app/router.dart';
import 'package:hivelzon/features/story/data/season_intro_repository.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../support/app_fonts.dart';
import '../support/fake_content_source.dart';
import '../support/fake_video_platform.dart';
import '../support/golden.dart';
import '../support/onboarding.dart';

class _Case {
  const _Case(this.route, this.expectKey, {this.act, this.introSeen = true});

  final String route;

  /// Doğru ekranın açıldığını gösteren öğe.
  final String expectKey;
  final Future<void> Function(WidgetTester tester)? act;

  /// Hikâye sekmesinde jenerik izlenmiş sayılır (harita açılır).
  final bool introSeen;
}

Future<void> _settle(WidgetTester tester, [int frames = 20]) async {
  for (var i = 0; i < frames; i++) {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<void> _openHiPanel(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey('hi-bubble')));
  await _settle(tester, 30);
}

final _cases = <String, _Case>{
  'kabuk_ana_sayfa': const _Case(AppRoutes.home, 'home-continue'),
  'kabuk_hikaye': const _Case(AppRoutes.story, 'season-map'),
  'kabuk_profil': const _Case(AppRoutes.profile, 'profile-list'),
  'konus': const _Case(AppRoutes.talk, 'talk-screen'),
  'hi_paneli': const _Case(AppRoutes.home, 'hi-panel', act: _openHiPanel),
  'sezon_jenerigi': const _Case(
    '/sezon/1/jenerik',
    'season-intro',
    introSeen: false,
  ),
};

void main() {
  setUpAll(loadAppFonts);

  late AppDatabase db;
  setUp(() {
    db = AppDatabase.memory();
    VideoPlayerPlatform.instance = FakeVideoPlatform(
      durationFor: (_) => const Duration(seconds: 30),
    );
  });
  tearDown(() => db.close());

  Future<void> pumpCase(
    WidgetTester tester,
    _Case c, {
    Size size = const Size(390, 844),
    double textScale = 1,
  }) async {
    tester.view.physicalSize = size * 3;
    tester.view.devicePixelRatio = 3;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    final intro = InMemorySeasonIntroRepository();
    if (c.introSeen) intro.seenSeasons.add(1);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingDoneOverride,
          appDatabaseProvider.overrideWithValue(db),
          legacyImportProvider.overrideWithValue(Future<void>.value()),
          contentSourceProvider.overrideWithValue(FakeContentSource()),
          seasonIntroRepositoryProvider.overrideWithValue(intro),
        ],
        child: const HiVelzonApp(),
      ),
    );
    await _settle(tester);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(HiVelzonApp)),
    );
    container.read(routerProvider).go(c.route);
    await _settle(tester, 30);
    await c.act?.call(tester);
    expect(find.byKey(ValueKey(c.expectKey)), findsWidgets);
    // Sekme köklerinde alt sekme çubuğu da denetlenir.
    if (c.route != '/sezon/1/jenerik') {
      expect(find.byType(NavigationBar), findsOneWidget);
    }
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    // Sahte videonun (30 sn) ve açma zaman aşımının (15 sn) zamanlayıcıları.
    await tester.pump(const Duration(seconds: 31));
  }

  for (final MapEntry(key: id, value: c) in _cases.entries) {
    testWidgets('$id: erişilebilirlik yönergeleri', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpCase(tester, c);
      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      // Piksel ölçümü yazı tipi çizimine bağlı; yalnız macOS'ta.
      if (!skipGoldensOffMac) {
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      }
      handle.dispose();
      await unmount(tester);
    });

    testWidgets('$id: 320 × 568, metin 1,3× büyütülünce taşma yok', (
      tester,
    ) async {
      await pumpCase(tester, c, size: const Size(320, 568), textScale: 1.3);
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });
  }
}
