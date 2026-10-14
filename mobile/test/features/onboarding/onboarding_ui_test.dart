import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/app.dart';
import 'package:hivelzon/features/account/application/account_providers.dart';
import 'package:hivelzon/features/onboarding/application/onboarding_providers.dart';
import 'package:hivelzon/features/onboarding/data/onboarding_store.dart';
import 'package:hivelzon/features/player/data/subtitle_preference_store.dart';
import 'package:hivelzon/features/story/data/season_intro_repository.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/api/token_store.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../support/fake_api_server.dart';
import '../../support/fake_content_source.dart';
import '../../support/fake_video_platform.dart';
import '../../support/placement.dart';

/// H-039 açılış: uygulamanın tamamı bellek içi veritabanıyla açılır;
/// yönlendirme kapısı da sınanır.
void main() {
  late AppDatabase db;
  final bank = loadBank();
  final thisYear = DateTime.now().toUtc().year;

  setUp(() {
    db = AppDatabase.memory();
    VideoPlayerPlatform.instance = FakeVideoPlatform(
      durationFor: (_) => const Duration(seconds: 30),
    );
    SyncController.listenLifecycle = false;
  });
  tearDown(() async {
    SyncController.listenLifecycle = true;
    await db.close();
  });

  Future<void> settle(WidgetTester tester, [int frames = 12]) async {
    for (var i = 0; i < frames; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<String?> meta(WidgetTester tester, String key) async =>
      (await tester.runAsync(
        () => (db.select(
          db.appMeta,
        )..where((t) => t.key.equals(key))).getSingleOrNull(),
      ))?.value;

  Future<void> pumpApp(
    WidgetTester tester, {
    Size size = const Size(390, 844),
    double textScale = 1,
    bool reduceMotion = true,
  }) async {
    tester.view.physicalSize = size * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    if (reduceMotion) {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
    }
    final server = FakeApiServer();
    await tester.pumpWidget(
      ProviderScope(
        // Yeni kapsam: her açılışta durum veritabanından yeniden okunur.
        key: UniqueKey(),
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          legacyImportProvider.overrideWithValue(Future<void>.value()),
          contentSourceProvider.overrideWithValue(FakeContentSource()),
          seasonIntroRepositoryProvider.overrideWithValue(
            InMemorySeasonIntroRepository(),
          ),
          apiHttpClientProvider.overrideWithValue(server.client),
          tokenStoreProvider.overrideWithValue(MemoryTokenStore()),
          placementBankProvider.overrideWith((ref) async => bank),
        ],
        child: const HiVelzonApp(),
      ),
    );
    await settle(tester);
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  Finder step(String name) => find.byKey(ValueKey('onboarding-$name'));

  Future<void> tapKey(WidgetTester tester, String key) async {
    final f = find.byKey(ValueKey(key));
    await tester.ensureVisible(f);
    await tester.pump();
    await tester.tap(f);
    await settle(tester);
  }

  /// Karşılamadan seviye adımına kadar.
  Future<void> toLevel(
    WidgetTester tester, {
    required int birthYear,
    String name = '',
  }) async {
    expect(step('welcome'), findsOneWidget);
    await tapKey(tester, 'onboarding-start');
    expect(step('about'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('onboarding-birth-year')),
      '$birthYear',
    );
    if (name.isNotEmpty) {
      await tester.enterText(
        find.byKey(const ValueKey('onboarding-name')),
        name,
      );
    }
    await tapKey(tester, 'onboarding-about-next');
    expect(step('privacy'), findsOneWidget);
    // 13 altıysa "bir büyüğünle birlikte oku" notu.
    expect(
      find.byKey(const ValueKey('onboarding-under13-note')),
      thisYear - birthYear < 13 ? findsOneWidget : findsNothing,
    );
    await tapKey(tester, 'onboarding-privacy-next');
    expect(step('prefs'), findsOneWidget);
    await tapKey(tester, 'onboarding-prefs-next');
    expect(step('level'), findsOneWidget);
  }

  /// Ekrandaki sorunun doğru seçeneğine dokunur.
  Future<void> answerCorrectly(WidgetTester tester) async {
    final prompt = tester
        .widget<Text>(find.byKey(const ValueKey('placement-prompt')))
        .data!;
    final item = [
      ...bank.warmup,
      for (final s in bank.stages.values) ...s,
    ].firstWhere((i) => i.prompt == prompt);
    await tapKey(tester, 'placement-option-${item.answer}');
  }

  testWidgets('13 yaş altı: hesap hiç önerilmez, yaş kapısı kapanır; test '
      'atlanır; bitiş kalıcı ve açılış bir daha görünmez', (tester) async {
    await pumpApp(tester);
    expect(find.byType(NavigationBar), findsNothing);
    await toLevel(tester, birthYear: thisYear - 10, name: 'Ece');
    await tapKey(tester, 'onboarding-test-skip');
    expect(step('ready'), findsOneWidget);
    expect(find.text(OnboardingTexts.readyLocalChild), findsOneWidget);
    expect(find.text(OnboardingTexts.readyLocalTeen), findsNothing);
    expect(find.textContaining('hesap aç'), findsNothing);

    await tapKey(tester, 'onboarding-finish');
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Merhaba Ece!'), findsOneWidget);

    // Kayıtlar yalnızca cihazda: yaş eşikleri (doğum yılı değil), ad,
    // altyazı, bitiş.
    expect(await meta(tester, OnboardingStore.legacyBirthYearKey), isNull);
    expect(
      await meta(tester, OnboardingStore.adultFromYearKey),
      '${thisYear - 10 + 18}',
    );
    expect(
      await meta(tester, 'account.ageBlockedUntil'),
      '${thisYear - 10 + 13}',
    );
    expect(await meta(tester, SubtitlePreferenceStore.key), 'en_tr');
    expect(await meta(tester, OnboardingStore.completedKey), isNotNull);
    expect(await meta(tester, OnboardingStore.suggestedLevelKey), isNull);

    // Profil → Hesap satırı kapalı (hesap açma yolu yok).
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Profil'),
      ),
    );
    await settle(tester);
    expect(find.text(AccountTexts.rowValueBlocked), findsOneWidget);
    await unmount(tester);

    // Yeniden açılış: doğrudan sekmeler.
    await pumpApp(tester);
    expect(step('welcome'), findsNothing);
    expect(find.byType(NavigationBar), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('13+: hazır adımında hesap yalnızca sakin bir not; yaş kapısı '
      'yok; bilgilendirmede 13 altı notu yok', (tester) async {
    await pumpApp(tester);
    await tapKey(tester, 'onboarding-start');
    await tester.enterText(
      find.byKey(const ValueKey('onboarding-birth-year')),
      '${thisYear - 20}',
    );
    await tapKey(tester, 'onboarding-about-next');
    expect(find.byKey(const ValueKey('onboarding-under13-note')), findsNothing);
    // Taslak hukuk metni açılış içinden açılır ve geri dönülür.
    await tapKey(tester, 'onboarding-terms');
    expect(find.byKey(const ValueKey('legal-text')), findsOneWidget);
    expect(find.text(AccountTexts.legalDraftTitle), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await settle(tester);
    expect(step('privacy'), findsOneWidget);
    await tapKey(tester, 'onboarding-privacy-next');
    // Türkçe satır kapatılırsa yalnız İngilizce kaydedilir.
    await tapKey(tester, 'onboarding-turkish-line');
    await tapKey(tester, 'onboarding-prefs-next');
    await tapKey(tester, 'onboarding-test-skip');
    expect(find.text(OnboardingTexts.readyLocalTeen), findsOneWidget);
    expect(await meta(tester, 'account.ageBlockedUntil'), isNull);
    expect(await meta(tester, SubtitlePreferenceStore.key), 'en');
    await unmount(tester);
  });

  testWidgets('doğum yılı zorunlu ve denetlenir; geri düğmesi önceki adıma '
      'döner', (tester) async {
    await pumpApp(tester);
    await tapKey(tester, 'onboarding-start');
    await tapKey(tester, 'onboarding-about-next');
    expect(step('about'), findsOneWidget);
    expect(find.text(OnboardingTexts.birthYearEmpty), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('onboarding-birth-year')),
      '${thisYear + 1}',
    );
    await tapKey(tester, 'onboarding-about-next');
    expect(find.text(OnboardingTexts.birthYearOutOfRange), findsOneWidget);
    await tapKey(tester, 'onboarding-back');
    expect(step('welcome'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('yerleştirme testi: her an bırakılabilir; sonuç yalnızca '
      'öneri; en fazla 20 soru', (tester) async {
    await pumpApp(tester);
    await toLevel(tester, birthYear: thisYear - 20);

    // Bir soru cevapla, sonra bırak → hazır adımı, sonuç yazılmaz.
    await tapKey(tester, 'onboarding-test-start');
    expect(step('test'), findsOneWidget);
    expect(find.text(OnboardingTexts.questionLabel(1, 20)), findsNothing);
    expect(find.text('SORU 1 · EN FAZLA 20'), findsOneWidget);
    await tapKey(tester, 'placement-dont-know');
    expect(find.text('SORU 2 · EN FAZLA 20'), findsOneWidget);
    await tapKey(tester, 'placement-quit');
    expect(step('ready'), findsOneWidget);
    expect(await meta(tester, OnboardingStore.suggestedLevelKey), isNull);

    // Geri → seviye; bu kez sonuna kadar (hepsi doğru) → C1 önerisi.
    await tapKey(tester, 'onboarding-back');
    expect(step('level'), findsOneWidget);
    await tapKey(tester, 'onboarding-test-start');
    var asked = 0;
    while (step('test').evaluate().isNotEmpty) {
      await answerCorrectly(tester);
      asked++;
      expect(asked, lessThanOrEqualTo(20));
    }
    expect(asked, 20);
    expect(step('result'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('placement-result')),
        matching: find.text('C1'),
      ),
      findsOneWidget,
    );
    expect(find.text(OnboardingTexts.resultNote), findsOneWidget);
    expect(await meta(tester, OnboardingStore.suggestedLevelKey), 'C1');
    await tapKey(tester, 'onboarding-result-next');
    expect(step('ready'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('kendi tahmini ile başlayan ve "Bilmiyorum" diyen: sakin sonuç', (
    tester,
  ) async {
    await pumpApp(tester);
    await toLevel(tester, birthYear: thisYear - 30);
    await tapKey(tester, 'onboarding-guess-B1');
    await tapKey(tester, 'onboarding-test-start');
    while (step('test').evaluate().isNotEmpty) {
      await tapKey(tester, 'placement-dont-know');
    }
    expect(step('result'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('placement-result')),
        matching: find.text('A2'),
      ),
      findsOneWidget,
    );
    expect(find.text(OnboardingTexts.resultBody('A2')), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('önceden ilerlemesi olan kullanıcı açılışı görmez', (
    tester,
  ) async {
    await tester.runAsync(
      () => db
          .into(db.userStoryProgress)
          .insert(
            UserStoryProgressCompanion.insert(
              contentId: 'A1-001',
              status: const Value('IN_PROGRESS'),
              updatedAt: DateTime.utc(2026, 10, 1),
            ),
          ),
    );
    await pumpApp(tester);
    expect(step('welcome'), findsNothing);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(await meta(tester, OnboardingStore.completedKey), isNotNull);
    await unmount(tester);
  });

  testWidgets('açılış yeniden gösterilebilir (reset)', (tester) async {
    await tester.runAsync(() => OnboardingStore(db).markCompleted());
    await pumpApp(tester);
    expect(find.byType(NavigationBar), findsOneWidget);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(HiVelzonApp)),
    );
    await tester.runAsync(
      () => container.read(onboardingGateProvider.notifier).restart(),
    );
    await settle(tester);
    expect(step('welcome'), findsOneWidget);
    await unmount(tester);
  });

  group('erişilebilirlik ve büyük yazı', () {
    /// Her adımı sırayla açar ve [check] çağırır.
    Future<void> walk(
      WidgetTester tester,
      Future<void> Function(String step) check,
    ) async {
      await check('welcome');
      await tapKey(tester, 'onboarding-start');
      await tester.enterText(
        find.byKey(const ValueKey('onboarding-birth-year')),
        '${thisYear - 10}',
      );
      await check('about');
      await tapKey(tester, 'onboarding-about-next');
      await check('privacy');
      await tapKey(tester, 'onboarding-privacy-next');
      await check('prefs');
      await tapKey(tester, 'onboarding-prefs-next');
      await check('level');
      await tapKey(tester, 'onboarding-test-start');
      await check('test');
      // Okuma maddesi (metin kutusu) da denensin: A1'in 4. sorusu.
      for (var i = 0; i < 3; i++) {
        await answerCorrectly(tester);
      }
      await check('test-reading');
      // A1 3/4 ile geçilir; A2'de "Bilmiyorum" → öneri A1.
      for (var i = 0; i < 5; i++) {
        await tapKey(tester, 'placement-dont-know');
      }
      await check('result');
      await tapKey(tester, 'onboarding-result-next');
      await check('ready');
    }

    testWidgets('metin 1,3× büyütülünce küçük ekranda taşma yok', (
      tester,
    ) async {
      await pumpApp(tester, size: const Size(320, 568), textScale: 1.3);
      await walk(tester, (name) async {
        expect(tester.takeException(), isNull, reason: name);
      });
      await unmount(tester);
    });

    testWidgets('dokunma alanı ≥ 48, etiketli düğmeler, metin kontrastı', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await pumpApp(tester);
      await walk(tester, (name) async {
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        // Karşılamada metin illüstrasyonun dışında; kontrast her adımda.
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      });
      await unmount(tester);
      semantics.dispose();
    });

    testWidgets('hareket açıkken de akış çalışır (zamanlayıcı kalmaz)', (
      tester,
    ) async {
      await pumpApp(tester, reduceMotion: false);
      await walk(tester, (_) async {});
      await unmount(tester);
    });
  });
}
