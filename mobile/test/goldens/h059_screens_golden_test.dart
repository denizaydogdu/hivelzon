// H-059 ekran golden'ları ve erişilebilirlik denetimi: Profil (adlı / adsız),
// Hesap (oturum kapalı / açık), "Hi benim hakkımda ne biliyor?", hukuk metni.
//
// Veriler sabit (sağlayıcılar geçersiz kılınır), yazı tipleri gömülü
// (`loadAppFonts`). Bilinçli görsel değişiklikten sonra:
//
//   cd mobile && flutter test --update-goldens test/goldens
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/account/application/account_providers.dart';
import 'package:hivelzon/features/account/presentation/account_screen.dart';
import 'package:hivelzon/features/account/presentation/account_widgets.dart';
import 'package:hivelzon/features/account/presentation/sign_in_screen.dart';
import 'package:hivelzon/features/hi/application/hi_providers.dart';
import 'package:hivelzon/features/hi/data/hi_store.dart';
import 'package:hivelzon/features/hi/domain/weekly_summary.dart';
import 'package:hivelzon/features/hi/presentation/hi_privacy_screen.dart';
import 'package:hivelzon/features/notebook/application/notebook_providers.dart';
import 'package:hivelzon/features/notebook/domain/review_session.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/notebook/domain/evidence_ladder.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/profile/application/profile_providers.dart';
import 'package:hivelzon/features/profile/presentation/profile_screen.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/api/token_store.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/meaning/error_taxonomy.dart';
import 'package:hivelzon/shared/speech/fake_speech_recognizer.dart';
import 'package:hivelzon/shared/speech/speech_providers.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:hivelzon/shared/ui/ui.dart';

import '../support/app_fonts.dart';
import '../support/golden.dart';
import '../support/fake_api_server.dart';
import '../support/fake_content_source.dart';

const _width = 390.0;

SyncStateRow _signedIn() => SyncStateRow(
  id: 1,
  accountUserId: 'u-1',
  emailMasked: 'd•••@example.com',
  accountStatus: 'ACTIVE',
  lastPullCursor: 0,
  lastSyncAt: DateTime.now().toUtc().subtract(const Duration(minutes: 2)),
  initialUploadDone: true,
  applying: false,
  pendingSpeechDelete: false,
);

final _knowledge = HiKnowledge(
  lookups: 12,
  errors: 4,
  errorCounts: {ErrorType.verbForm: 3, ErrorType.preposition: 1},
  bridgeDone: 1,
  bridgeDismissed: 0,
  notebookItems: 15,
  reviewAnswers: 22,
  completedEpisodes: 3,
  inProgressEpisodes: 1,
  speechAttempts: 7,
  speechFull: 5,
  // H-093: öğrenme kanıtları (ifade, basamak, tarih); öğlen UTC, yerel gün
  // saat diliminden etkilenmesin.
  evidence: [
    HiEvidence(
      text: 'Where is…?',
      stage: EvidenceStage.recalledLater,
      at: DateTime.utc(2026, 10, 14, 12),
    ),
    HiEvidence(
      text: 'Excuse me.',
      stage: EvidenceStage.ownUse,
      at: DateTime.utc(2026, 10, 13, 12),
    ),
    HiEvidence(
      text: 'Can you hear me?',
      stage: EvidenceStage.helped,
      at: DateTime.utc(2026, 10, 12, 12),
    ),
  ],
);

const _week = WeeklySummary(
  phrasesAdded: 4,
  phrasesReviewed: 6,
  episodesCompleted: 1,
  focus: ErrorType.verbForm,
  recalledLater: 2,
  helped: 3,
);

NotebookItem _phrase(String en) => NotebookItem(
  kind: NotebookKind.phrase,
  textEn: en,
  source: NotebookSource.autoTargetPhrase,
);

/// H-089: "Neler yapabiliyorsun" örneği (adlı profilde; adsızda boş durum).
final _evidence = EvidenceSummary(
  recalledLater: [_phrase('Where is…?'), _phrase('Excuse me.')],
  ownUse: [_phrase("I'm new here.")],
  revisit: [_phrase('What time is it?')],
  total: 15,
);

void main() {
  setUpAll(loadAppFonts);
  setUp(() => SyncController.listenLifecycle = false);
  tearDown(() => SyncController.listenLifecycle = true);

  Future<void> pumpScreen(
    WidgetTester tester,
    Widget screen, {
    required double height,
    double width = _width,
    String? name = 'Deniz',
    SyncStateRow? account,
    double textScale = 1,
    ImageProvider? image,
  }) async {
    tester.view.physicalSize = Size(width * 2, height * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final server = FakeApiServer();
    // Hesap durumu gerçek tablodan (eşitleme denetleyicisi de okur).
    if (account != null) {
      await tester.runAsync(() => db.into(db.syncState).insert(account));
    }
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          legacyImportProvider.overrideWithValue(Future<void>.value()),
          contentSourceProvider.overrideWithValue(FakeContentSource()),
          progressRepositoryProvider.overrideWithValue(
            InMemoryProgressRepository(),
          ),
          apiHttpClientProvider.overrideWithValue(server.client),
          tokenStoreProvider.overrideWithValue(MemoryTokenStore()),
          speechRecognizerProvider.overrideWithValue(FakeSpeechRecognizer()),
          speechStatusProvider.overrideWith((ref) async => SpeechStatus.ready),
          displayNameProvider.overrideWith((ref) async => name),
          dailyGoalProvider.overrideWith((ref) async => 10),
          reviewOverviewProvider.overrideWith(
            (ref) async => const ReviewOverview(
              dueReviews: 5,
              newAvailable: 0,
              totalItems: 15,
              newPerDay: 10,
            ),
          ),
          hiKnowledgeProvider.overrideWith((ref) async => _knowledge),
          evidenceSummaryProvider.overrideWith(
            (ref) async => name == null ? EvidenceSummary.empty : _evidence,
          ),
          weeklySummaryProvider.overrideWith((ref) async => _week),
        ],
        // Uygulama kökü gibi: eşitleme denetleyicisi baştan dinlenir.
        child: Consumer(
          builder: (context, ref, child) {
            ref.watch(syncControllerProvider);
            return child!;
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            home: Builder(
              builder: (context) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(textScale)),
                child: RepaintBoundary(
                  key: const ValueKey('golden'),
                  child: screen,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    if (image != null) {
      final context = tester.element(find.byKey(const ValueKey('golden')));
      await tester.runAsync(() => precacheImage(image, context));
    }
    for (var i = 0; i < 10; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.pumpAndSettle();
  }

  /// Ağacı kaldırır (eşitleme zamanlayıcısı dursun).
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  final screens =
      <
        String,
        (
          Widget,
          double, {
          String? name,
          SyncStateRow? account,
          ImageProvider? image,
        })
      >{
        'profil': (
          const ProfileScreen(),
          1480,
          name: 'Deniz',
          account: null,
          image: ProfileScreen.headerImage,
        ),
        'profil_adsiz': (
          const ProfileScreen(),
          1340,
          name: null,
          account: null,
          image: ProfileScreen.headerImage,
        ),
        'hesap_kapali': (
          const AccountScreen(),
          844,
          name: 'Deniz',
          account: null,
          image: AccountScreen.headerImage,
        ),
        'hesap_acik': (
          const AccountScreen(),
          844,
          name: 'Deniz',
          account: _signedIn(),
          image: null,
        ),
        'hi_gizlilik': (
          const HiPrivacyScreen(),
          1900,
          name: 'Deniz',
          account: null,
          image: null,
        ),
        'hukuk': (
          const LegalTextScreen(kind: 'aydinlatma'),
          844,
          name: 'Deniz',
          account: null,
          image: null,
        ),
      };

  for (final MapEntry(key: id, value: (screen, height, :name, :account, :image))
      in screens.entries) {
    testWidgets('golden: $id', (tester) async {
      await pumpScreen(
        tester,
        screen,
        height: height,
        name: name,
        account: account,
        image: image,
      );
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('golden')),
        matchesGoldenFile('images/h059_$id.png'),
      );
      await unmount(tester);
    }, skip: skipGoldensOffMac);

    testWidgets('$id: erişilebilirlik yönergeleri', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpScreen(
        tester,
        screen,
        height: height,
        name: name,
        account: account,
        image: image,
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      // Piksel ölçümü yazı tipi çizimine bağlı; yalnız macOS'ta (H-064).
      if (!skipGoldensOffMac) {
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      }
      handle.dispose();
      await unmount(tester);
    });

    testWidgets('$id: metin 1,3× büyütülünce taşma yok', (tester) async {
      await pumpScreen(
        tester,
        screen,
        height: height * 1.4,
        name: name,
        account: account,
        image: image,
        textScale: 1.3,
      );
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });

    // H-064: en küçük hedef ekran.
    testWidgets('$id: 320 × 568, metin 1,3× büyütülünce taşma yok', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        screen,
        width: 320,
        height: 568,
        name: name,
        account: account,
        image: image,
        textScale: 1.3,
      );
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });
  }

  // H-064 kalite turu: giriş ekranı ve Profil'in alt panelleri (günlük
  // hedef, ad) için de dokunma hedefi, etiket, kontrast ve küçük ekran.
  final extras = <String, (Widget, String?)>{
    'giris': (const SignInScreen(), null),
    'hedef_paneli': (const ProfileScreen(), 'profile-goal'),
    'ad_paneli': (const ProfileScreen(), 'profile-name-row'),
  };
  Future<void> openRow(WidgetTester tester, String? key) async {
    if (key == null) return;
    final row = find.byKey(ValueKey(key));
    await tester.ensureVisible(row);
    await tester.pumpAndSettle();
    await tester.tap(row);
    await tester.pumpAndSettle();
    expect(find.byType(AppSheet), findsOneWidget);
  }

  for (final MapEntry(key: id, value: (screen, row)) in extras.entries) {
    testWidgets('$id: erişilebilirlik yönergeleri', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpScreen(tester, screen, height: 844);
      await openRow(tester, row);
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
      await pumpScreen(tester, screen, width: 320, height: 568, textScale: 1.3);
      await openRow(tester, row);
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });
  }

  testWidgets('Hesap (açık): durum kartı, "Tehlikeli bölge" kırmızı satırlar', (
    tester,
  ) async {
    await pumpScreen(
      tester,
      const AccountScreen(),
      height: 844,
      account: _signedIn(),
    );
    expect(find.text('d•••@example.com'), findsOneWidget);
    expect(find.text('Eşitleme: son 2 dk önce'), findsOneWidget);
    expect(find.byKey(const ValueKey('account-sync-now')), findsOneWidget);
    expect(find.text(AccountTexts.dangerZone), findsOneWidget);
    for (final key in ['account-sign-out-wipe', 'account-delete']) {
      final row = tester.widget<SettingsRow>(find.byKey(ValueKey(key)));
      expect(row.destructive, isTrue, reason: key);
    }
    // Tehlikeli eylemler çıkış düğmesinin altında, ayrı grupta.
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('account-danger-zone'))).dy,
      greaterThan(
        tester.getTopLeft(find.byKey(const ValueKey('account-sign-out'))).dy,
      ),
    );
    await unmount(tester);
  });

  testWidgets('Hi gizlilik: hesapsız "Yalnızca bu telefonda", hesapla '
      '"Hesabına da eşitlenir"; konu çipleri ve sayılar', (tester) async {
    await pumpScreen(tester, const HiPrivacyScreen(), height: 1500);
    expect(find.byKey(const ValueKey('hi-privacy-local')), findsOneWidget);
    expect(find.text('Fiil yapısı · 3'), findsOneWidget);
    expect(find.text('Edat · 1'), findsOneWidget);
    expect(find.text('kez anlamına baktın'), findsOneWidget);
    final handle = tester.ensureSemantics();
    await tester.pump();
    // Sayı ve etiket ekran okuyucuda tek parça.
    expect(find.bySemanticsLabel('12 kez anlamına baktın'), findsOneWidget);
    handle.dispose();
    expect(
      find.text('En çok üzerinde çalıştığın konu: Fiil yapısı.'),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
    await pumpScreen(
      tester,
      const HiPrivacyScreen(),
      height: 1500,
      account: _signedIn(),
    );
    expect(find.byKey(const ValueKey('hi-privacy-account')), findsOneWidget);
    expect(find.byKey(const ValueKey('hi-privacy-local')), findsNothing);
    await unmount(tester);
  });

  testWidgets('hukuk metni: sürüm etiketi, taslak notu, başlıklı bölümler, '
      'okunur genişlik', (tester) async {
    tester.view.physicalSize = const Size(1600, 1400);
    await pumpScreen(
      tester,
      const LegalTextScreen(kind: 'kosullar'),
      height: 700,
    );
    tester.view.physicalSize = const Size(1600, 1400);
    await tester.pumpAndSettle();
    expect(find.text(AccountTexts.legalDraft), findsOneWidget);
    for (final (heading, body) in AccountTexts.termsSections) {
      expect(find.text(heading), findsOneWidget);
      expect(find.text(body), findsOneWidget);
    }
    expect(
      tester.getSize(find.text(AccountTexts.termsSections.last.$2)).width,
      lessThanOrEqualTo(LegalTextScreen.maxWidth),
    );
    await unmount(tester);
  });

  testWidgets('giriş: hata metni ana düğmenin hemen üstünde', (tester) async {
    await pumpScreen(tester, const SignInScreen(), height: 844);
    await tester.enterText(find.byKey(const ValueKey('sign-in-email')), 'x@');
    await tester.tap(find.byKey(const ValueKey('sign-in-send')));
    await tester.pumpAndSettle();
    final error = find.byKey(const ValueKey('sign-in-error'));
    expect(error, findsOneWidget);
    expect(find.text(AccountTexts.emailInvalid), findsOneWidget);
    expect(
      tester.getBottomLeft(error).dy,
      lessThanOrEqualTo(
        tester.getTopLeft(find.byKey(const ValueKey('sign-in-send'))).dy,
      ),
    );
    await unmount(tester);
  });
}
