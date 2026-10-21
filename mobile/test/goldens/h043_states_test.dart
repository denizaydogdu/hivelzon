// H-043 kalite turu: hata ve boş durumlar uygulamanın kabuğu içinde
// erişilebilirlik yönergelerine (dokunma hedefi, etiket, kontrast yalnız
// macOS'ta) ve en küçük hedef ekrana (320 × 568, metin 1,3×) karşı
// denetlenir; "Tekrar dene" düğmeleri gerçekten yeniden dener. Golden yok
// (ekranların golden'ları kendi dosyalarında).
//
// Kapsam: Hikâye haritası, Kitaplık, Dilbilgisi, Konuş, Keşfet (hata ve
// boş), Defter ve İpucu panosu, Hi gizlilik, Kelime tekrarı, sezon jeneriği,
// oynatıcı. Ayrıca h063 (Hi), h086 (sayfanın Türkçesi) ve h091 (kitap sonu
// anlama) ekranlarının erişilebilirlik ve taşma testleri.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/app.dart';
import 'package:hivelzon/app/router.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/hi/application/hi_providers.dart';
import 'package:hivelzon/features/notebook/application/notebook_providers.dart';
import 'package:hivelzon/features/player/presentation/widgets/hi_avatar.dart';
import 'package:hivelzon/features/story/data/season_intro_repository.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../support/app_fonts.dart';
import '../support/discover_harness.dart';
import '../support/fake_content_source.dart';
import '../support/fake_video_platform.dart';
import '../support/golden.dart';
import '../support/library_harness.dart';
import '../support/onboarding.dart';

/// Sağlayıcı kaç kez okundu ("Tekrar dene" gerçekten yeniden okuyor mu).
class _Calls {
  int n = 0;
}

class _Case {
  const _Case(
    this.route,
    this.expectKey, {
    this.source,
    this.overrides = _none,
    this.act,
    this.introSeen = true,
    this.shell = true,
  });

  final String route;
  final String expectKey;
  final void Function(FakeContentSource s)? source;
  final List<Override> Function(_Calls calls) overrides;
  final Future<void> Function(WidgetTester tester)? act;
  final bool introSeen;

  /// Sekme kabuğu içinde mi (alt sekme çubuğu da denetlenir).
  final bool shell;
}

Future<void> _settle(WidgetTester tester, [int frames = 20]) async {
  for (var i = 0; i < frames; i++) {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<void> Function(WidgetTester) _tapText(String text) => (tester) async {
  await tester.tap(find.text(text));
  await _settle(tester, 30);
};

Future<T> _fail<T>(_Calls c) async {
  c.n++;
  throw StateError('okunamadı');
}

List<Override> _none(_Calls _) => const [];

final _cases = <String, _Case>{
  'hikaye_hata': _Case(
    AppRoutes.story,
    'story-retry',
    source: (s) => s.fail = true,
  ),
  'kitaplik_hata': _Case(
    AppRoutes.story,
    'library-retry',
    source: (s) => s.booksFail = true,
    act: _tapText(LibraryTexts.segmentLibrary),
  ),
  'dilbilgisi_hata': _Case(
    AppRoutes.story,
    'grammar-retry',
    source: (s) => s.grammarFails = true,
    act: _tapText(GrammarTexts.segment),
  ),
  'konus_hata': _Case(
    AppRoutes.talk,
    'talk-error',
    source: (s) => s.talkFails = true,
  ),
  'defter_hata': _Case(
    AppRoutes.notebook,
    'notebook-retry',
    overrides: (c) => [notebookEntriesProvider.overrideWith((ref) => _fail(c))],
  ),
  'ipucu_hata': _Case(
    '${AppRoutes.notebook}?sekme=ipuclari',
    'clues-retry',
    overrides: (c) => [clueBoardProvider.overrideWith((ref) => _fail(c))],
  ),
  'hi_gizlilik_hata': _Case(
    AppRoutes.hiPrivacy,
    'hi-privacy-retry',
    overrides: (c) => [hiKnowledgeProvider.overrideWith((ref) => _fail(c))],
  ),
  'tekrar_hata': _Case(
    AppRoutes.review,
    'review-retry',
    shell: false,
    overrides: (c) => [reviewOverviewProvider.overrideWith((ref) => _fail(c))],
  ),
  'jenerik_hata': _Case(
    '/sezon/1/jenerik',
    'season-intro-retry',
    shell: false,
    introSeen: false,
    source: (s) => s.seasonFails = true,
  ),
  'oynatici_hata': _Case(
    '/play/A1-001',
    'player-dev-hint',
    shell: false,
    source: (s) => s.fail = true,
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

  Future<(FakeContentSource, _Calls)> pumpCase(
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
    // Hata baştan: harita, kitaplık ve sahneler kabukta önbelleğe girer.
    final source = FakeContentSource();
    c.source?.call(source);
    final calls = _Calls();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          onboardingDoneOverride,
          appDatabaseProvider.overrideWithValue(db),
          legacyImportProvider.overrideWithValue(Future<void>.value()),
          contentSourceProvider.overrideWithValue(source),
          seasonIntroRepositoryProvider.overrideWithValue(intro),
          ...c.overrides(calls),
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
    final target = find.byKey(ValueKey(c.expectKey));
    if (target.evaluate().isEmpty) {
      // Küçük ekranda hata kartı kaydırılınca görünür (tembel liste).
      await tester.scrollUntilVisible(
        target,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await _settle(tester, 5);
    }
    expect(target, findsWidgets);
    if (c.shell) expect(find.byType(NavigationBar), findsOneWidget);
    return (source, calls);
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
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

  group('"Tekrar dene" yeniden okur', () {
    for (final id in [
      'defter_hata',
      'ipucu_hata',
      'hi_gizlilik_hata',
      'tekrar_hata',
    ]) {
      testWidgets(id, (tester) async {
        final c = _cases[id]!;
        final (_, calls) = await pumpCase(tester, c);
        final before = calls.n;
        expect(before, greaterThan(0));
        final retry = find.byKey(ValueKey(c.expectKey));
        await tester.ensureVisible(retry);
        await tester.tap(retry);
        await _settle(tester, 30);
        expect(calls.n, greaterThan(before));
        // Yine okunamadı: sonsuz iskelet değil, aynı sakin hata.
        expect(find.byKey(ValueKey(c.expectKey)), findsWidgets);
        await unmount(tester);
      });
    }

    testWidgets('sezon jeneriği: içerik gelince oynar', (tester) async {
      final (source, _) = await pumpCase(tester, _cases['jenerik_hata']!);
      expect(find.text(SeasonIntroTexts.error), findsOneWidget);
      source.seasonFails = false;
      await tester.tap(find.byKey(const ValueKey('season-intro-retry')));
      await _settle(tester, 30);
      expect(find.text(SeasonIntroTexts.error), findsNothing);
      expect(find.byKey(const ValueKey('season-intro-retry')), findsNothing);
      await unmount(tester);
    });
  });

  group('Keşfet (hata ve boş)', () {
    for (final (id, fail) in [('kesfet_hata', true), ('kesfet_bos', false)]) {
      Future<DiscoverHarness> pump(
        WidgetTester tester, {
        Size size = const Size(390, 844),
        double textScale = 1,
      }) async {
        final h = DiscoverHarness(withClips: fail, clipsFail: fail);
        addTearDown(h.dispose);
        await h.pump(tester, size: size, textScale: textScale);
        expect(
          find.byKey(ValueKey(fail ? 'discover-retry' : 'discover-go-story')),
          findsOneWidget,
        );
        return h;
      }

      testWidgets('$id: erişilebilirlik yönergeleri', (tester) async {
        final handle = tester.ensureSemantics();
        final h = await pump(tester);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        if (!skipGoldensOffMac) {
          await expectLater(tester, meetsGuideline(textContrastGuideline));
        }
        handle.dispose();
        await h.unmount(tester);
      });

      testWidgets('$id: 320 × 568, metin 1,3× büyütülünce taşma yok', (
        tester,
      ) async {
        final h = await pump(
          tester,
          size: const Size(320, 568),
          textScale: 1.3,
        );
        expect(tester.takeException(), isNull);
        await h.unmount(tester);
      });
    }
  });

  group('h063 Hi ifadeleri', () {
    Future<void> pumpHi(
      WidgetTester tester,
      HiExpression e, {
      Size size = const Size(390, 844),
      double textScale = 1,
    }) async {
      tester.view.physicalSize = size * 2;
      tester.view.devicePixelRatio = 2;
      tester.platformDispatcher.textScaleFactorTestValue = textScale;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: Center(
              child: HiAvatar(size: 160, expression: e, pulseCycles: 1),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    for (final e in HiExpression.values) {
      testWidgets('Hi ${e.name}: yönergeler ve 320 × 568 · 1,3×', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await pumpHi(tester, e);
        expect(tester.takeException(), isNull);
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        if (!skipGoldensOffMac) {
          await expectLater(tester, meetsGuideline(textContrastGuideline));
        }
        handle.dispose();
        await pumpHi(tester, e, size: const Size(320, 568), textScale: 1.3);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('h086 sayfanın Türkçesi ve h091 kitap sonu anlama', () {
    final cases =
        <String, (String, Future<void> Function(WidgetTester, LibraryHarness))>{
          'h086_panel': (
            '/kitap/A1-K99',
            (tester, h) async {
              await h.listenFor(tester, 3.4);
              await tester.tap(
                find.byKey(const ValueKey('reader-page-turkish')),
              );
              await h.settle(tester);
            },
          ),
          'h091_anlama': (
            '/kitap/A1-K99?mod=oku',
            (tester, h) async {
              for (var i = 0; i < 2; i++) {
                await tester.tap(find.byKey(const ValueKey('reader-next')));
                await h.settle(tester);
              }
              await tester.tap(find.byKey(const ValueKey('reader-finish')));
              await h.settle(tester);
              expect(find.byKey(const ValueKey('comp-q1-o0')), findsOneWidget);
            },
          ),
        };

    Future<void> unmountLib(WidgetTester tester) async {
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 100));
    }

    for (final MapEntry(key: id, value: (location, act)) in cases.entries) {
      testWidgets('$id: erişilebilirlik yönergeleri', (tester) async {
        final handle = tester.ensureSemantics();
        final h = LibraryHarness(suggestedLevel: 'A1');
        addTearDown(h.dispose);
        await h.pump(tester, location);
        await act(tester, h);
        await h.settle(tester);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        if (!skipGoldensOffMac) {
          await expectLater(tester, meetsGuideline(textContrastGuideline));
        }
        handle.dispose();
        await unmountLib(tester);
      });

      testWidgets('$id: 320 × 568, metin 1,3× büyütülünce taşma yok', (
        tester,
      ) async {
        final h = LibraryHarness(suggestedLevel: 'A1');
        addTearDown(h.dispose);
        await h.pump(
          tester,
          location,
          size: const Size(320, 568),
          textScale: 1.3,
        );
        await act(tester, h);
        await h.settle(tester);
        expect(tester.takeException(), isNull);
        await unmountLib(tester);
      });
    }
  });
}
