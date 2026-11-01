import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/app.dart';
import 'package:hivelzon/app/router.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/onboarding/presentation/app_tour.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/story/application/learn_section_provider.dart';
import 'package:hivelzon/features/story/data/learn_section_store.dart';
import 'package:hivelzon/features/story/data/season_intro_repository.dart';
import 'package:hivelzon/features/story/domain/learn_section.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';

import '../../support/fake_content_source.dart';
import '../../support/grammar_harness.dart';
import '../../support/onboarding.dart';

/// Kaydı elle bırakılan depo: okuma, açık seçimden sonra tamamlanabilir.
class _SlowStore implements LearnSectionStore {
  final loaded = Completer<LearnSection?>();
  LearnSection? saved;

  @override
  Future<LearnSection?> load() => loaded.future;

  @override
  Future<void> save(LearnSection section) async => saved = section;
}

/// H-103: alt menüde "Öğren"; içinde Hikâye · Kitaplık · Dilbilgisi; son
/// bölüm cihazda hatırlanır; derin bağlantı hatırlananı ezer.
void main() {
  Finder key(String k) => find.byKey(ValueKey(k));

  group('LearnSection', () {
    test('kodlar sabit; bilinmeyen kod null', () {
      expect(LearnSection.parse('hikaye'), LearnSection.story);
      expect(LearnSection.parse('kitaplik'), LearnSection.library);
      expect(LearnSection.parse('dilbilgisi'), LearnSection.grammar);
      expect(LearnSection.parse('macera'), isNull);
      expect(LearnSection.parse(null), isNull);
    });

    test('derin bağlantı yolu', () {
      expect(AppRoutes.learnAt(LearnSection.library), '/hikaye?bolum=kitaplik');
    });
  });

  group('DriftLearnSectionStore', () {
    test('yazılan son bölüm okunur; yeniden yazmak üzerine yazar', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final store = DriftLearnSectionStore(db);
      expect(await store.load(), isNull);
      await store.save(LearnSection.library);
      await store.save(LearnSection.library);
      expect(await store.load(), LearnSection.library);
      await store.save(LearnSection.grammar);
      expect(await store.load(), LearnSection.grammar);
    });
  });

  group('LearnSectionNotifier', () {
    test('kayıt yoksa Hikâye; kayıt varsa ona geçer', () async {
      final c = ProviderContainer(
        overrides: [
          learnSectionStoreProvider.overrideWithValue(
            InMemoryLearnSectionStore(LearnSection.grammar),
          ),
        ],
      );
      addTearDown(c.dispose);
      expect(c.read(learnSectionProvider), LearnSection.story);
      await Future<void>.delayed(Duration.zero);
      expect(c.read(learnSectionProvider), LearnSection.grammar);
    });

    test('kayıt gelmeden yapılan seçim kazanır ve yazılır', () async {
      final store = _SlowStore();
      final c = ProviderContainer(
        overrides: [learnSectionStoreProvider.overrideWithValue(store)],
      );
      addTearDown(c.dispose);
      c.read(learnSectionProvider);
      c.read(learnSectionProvider.notifier).select(LearnSection.library);
      store.loaded.complete(LearnSection.grammar);
      await Future<void>.delayed(Duration.zero);
      expect(c.read(learnSectionProvider), LearnSection.library);
      expect(store.saved, LearnSection.library);
    });

    test('okuma hatası Hikâye ile sürer', () async {
      final store = _SlowStore();
      final c = ProviderContainer(
        overrides: [learnSectionStoreProvider.overrideWithValue(store)],
      );
      addTearDown(c.dispose);
      c.read(learnSectionProvider);
      store.loaded.completeError(StateError('disk'));
      await Future<void>.delayed(Duration.zero);
      expect(c.read(learnSectionProvider), LearnSection.story);
    });
  });

  group('Öğren sekmesi (uygulama)', () {
    late InMemoryLearnSectionStore store;
    late ProviderContainer container;

    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
    }

    Future<void> pumpApp(WidgetTester tester, {LearnSection? saved}) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      store = InMemoryLearnSectionStore(saved);
      final db = AppDatabase.memory();
      addTearDown(db.close);
      container = ProviderContainer(
        overrides: [
          onboardingDoneOverride,
          appDatabaseProvider.overrideWithValue(db),
          legacyImportProvider.overrideWithValue(Future<void>.value()),
          contentSourceProvider.overrideWithValue(FakeContentSource()),
          progressRepositoryProvider.overrideWithValue(
            InMemoryProgressRepository(),
          ),
          seasonIntroRepositoryProvider.overrideWithValue(
            InMemorySeasonIntroRepository()..seenSeasons.add(1),
          ),
          learnSectionStoreProvider.overrideWithValue(store),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const HiVelzonApp(),
        ),
      );
      await settle(tester);
    }

    Future<void> openLearnTab(WidgetTester tester) async {
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(TabTexts.learn),
        ),
      );
      await settle(tester);
    }

    testWidgets('alt menüde "Öğren"; içinde Hikâye · Kitaplık · Dilbilgisi', (
      tester,
    ) async {
      await pumpApp(tester);
      final nav = find.byType(NavigationBar);
      expect(TabTexts.learn, 'Öğren');
      expect(
        find.descendant(of: nav, matching: find.text('Öğren')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: nav, matching: find.text('Hikâye')),
        findsNothing,
      );
      expect(
        find.descendant(of: nav, matching: find.byIcon(Icons.school_outlined)),
        findsOneWidget,
      );
      await openLearnTab(tester);
      expect(
        find.descendant(of: nav, matching: find.byIcon(Icons.school)),
        findsOneWidget,
      );
      final sections = key('story-sections');
      for (final t in ['Hikâye', 'Kitaplık', 'Dilbilgisi']) {
        expect(
          find.descendant(of: sections, matching: find.text(t)),
          findsOneWidget,
          reason: t,
        );
      }
      expect(find.text('Macera'), findsNothing);
      expect(key('season-map'), findsOneWidget);
    });

    testWidgets('son seçilen bölüm hatırlanır ve yazılır', (tester) async {
      await pumpApp(tester, saved: LearnSection.grammar);
      await openLearnTab(tester);
      expect(key('grammar-view'), findsOneWidget);
      expect(key('season-map'), findsNothing);
      await tester.tap(
        find.descendant(
          of: key('story-sections'),
          matching: find.text('Kitaplık'),
        ),
      );
      await settle(tester);
      expect(key('grammar-view'), findsNothing);
      expect(store.saved, LearnSection.library);
    });

    testWidgets('derin bağlantı hatırlananı ezer, doğru bölüme gider', (
      tester,
    ) async {
      await pumpApp(tester, saved: LearnSection.grammar);
      container.read(routerProvider).go(AppRoutes.learnAt(LearnSection.story));
      await settle(tester);
      expect(key('season-map'), findsOneWidget);
      expect(key('grammar-view'), findsNothing);
      expect(container.read(learnSectionProvider), LearnSection.story);
      // Bağlantı yolu sadeleşir (sorgu parametresi kalmaz).
      expect(
        container
            .read(routerProvider)
            .routerDelegate
            .currentConfiguration
            .uri
            .toString(),
        AppRoutes.learn,
      );
      // Aynı bağlantı, kullanıcı başka bölüme geçtikten sonra da çalışır.
      await tester.tap(
        find.descendant(
          of: key('story-sections'),
          matching: find.text('Dilbilgisi'),
        ),
      );
      await settle(tester);
      expect(key('grammar-view'), findsOneWidget);
      container.read(routerProvider).go(AppRoutes.learnAt(LearnSection.story));
      await settle(tester);
      expect(key('season-map'), findsOneWidget);
    });
  });

  testWidgets('320 × 568, metin 1,3×: simgeli üç bölüm tek satır, taşma '
      'yok, dokunma alanı ≥ 44', (tester) async {
    final h = GrammarHarness();
    addTearDown(h.dispose);
    await h.pump(tester, '/hikaye', size: const Size(320, 568), textScale: 1.3);
    expect(tester.takeException(), isNull);
    final sections = key('story-sections');
    for (final icon in [
      Icons.movie,
      Icons.menu_book_outlined,
      Icons.text_fields_outlined,
    ]) {
      expect(
        find.descendant(of: sections, matching: find.byIcon(icon)),
        findsOneWidget,
        reason: '$icon',
      );
    }
    for (final t in ['Hikâye', 'Kitaplık', 'Dilbilgisi']) {
      final text = find.descendant(of: sections, matching: find.text(t));
      final p = tester.renderObject<RenderParagraph>(text);
      expect(p.didExceedMaxLines, isFalse, reason: t);
      // Tek satır: yükseklik bir satırı aşmaz.
      final line = p.getFullHeightForCaret(const TextPosition(offset: 0));
      expect(p.size.height, lessThanOrEqualTo(line + 0.5), reason: t);
    }
    final box = tester.getSize(sections);
    expect(box.height, greaterThanOrEqualTo(44));
    expect(box.width, lessThanOrEqualTo(320));
    await tester.tap(
      find.descendant(of: sections, matching: find.text('Dilbilgisi')),
    );
    await h.settle(tester);
    expect(tester.takeException(), isNull);
    expect(
      find.descendant(of: sections, matching: find.byIcon(Icons.text_fields)),
      findsOneWidget,
    );
  });

  testWidgets('Hi turu Öğren sekmesini anlatır', (tester) async {
    final bodies = [for (final s in TourTexts.steps) s.body];
    expect(bodies, contains('Hikâye, Kitaplık ve Dilbilgisi burada.'));
    expect(bodies.join(' '), contains('Öğren'));
    expect(bodies.join(' '), isNot(contains('Hikâye, Konuş')));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: AppTourOverlay(onDone: () async {})),
      ),
    );
    await tester.pumpAndSettle();
    final i = bodies.indexOf('Hikâye, Kitaplık ve Dilbilgisi burada.');
    for (var n = 0; n < i; n++) {
      await tester.tap(find.byKey(const ValueKey('tour-next')));
      await tester.pumpAndSettle();
    }
    expect(find.text('Hikâye, Kitaplık ve Dilbilgisi burada.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
