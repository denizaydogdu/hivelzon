import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/router.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/account/application/account_providers.dart';
import 'package:hivelzon/features/account/presentation/account_screen.dart';
import 'package:hivelzon/features/account/presentation/account_widgets.dart';
import 'package:hivelzon/features/account/presentation/sign_in_screen.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/api/token_store.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:hivelzon/shared/ui/ui.dart';

import '../../support/fake_api_server.dart';
import '../../support/fake_content_source.dart';

void main() {
  late AppDatabase db;
  late FakeApiServer server;
  late MemoryTokenStore tokens;

  setUp(() {
    db = AppDatabase.memory();
    server = FakeApiServer();
    tokens = MemoryTokenStore();
    SyncController.listenLifecycle = false;
  });
  tearDown(() async {
    SyncController.listenLifecycle = true;
    await db.close();
  });

  Future<void> settle(WidgetTester tester, [int n = 20]) async {
    for (var i = 0; i < n; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> pump(WidgetTester tester, Widget home) async {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: '/start',
      routes: [
        GoRoute(
          path: '/start',
          builder: (_, _) => Scaffold(body: home),
        ),
        GoRoute(path: AppRoutes.home, builder: (_, _) => const SizedBox()),
        GoRoute(
          path: AppRoutes.account,
          builder: (_, _) => const AccountScreen(),
          routes: [
            GoRoute(path: 'giris', builder: (_, _) => const SignInScreen()),
            GoRoute(
              path: 'metin/:kind',
              builder: (_, s) =>
                  LegalTextScreen(kind: s.pathParameters['kind']!),
            ),
          ],
        ),
      ],
    );
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
          tokenStoreProvider.overrideWithValue(tokens),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
    await settle(tester);
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await settle(tester, 5);
  }

  Future<void> tapKey(WidgetTester tester, String key) async {
    final f = find.byKey(ValueKey(key));
    // Alana odaklanınca başlayan kaydırma bitsin, sonra göster ve dokun.
    await settle(tester, 4);
    await tester.ensureVisible(f);
    await tester.pump();
    await tester.tap(f);
    await settle(tester);
  }

  testWidgets('hesapsız: sakin davet, hiçbir istek yok', (tester) async {
    await pump(tester, const AccountRow());
    expect(find.text(AccountTexts.section), findsOneWidget);
    expect(find.text(AccountTexts.rowValueSignedOut), findsOneWidget);
    expect(
      find.text(
        'İlerlemen yalnızca bu telefonda. Kaybolmasın istersen hesap aç.',
      ),
      findsOneWidget,
    );
    await tapKey(tester, 'profile-account');
    expect(find.text(AccountTexts.intro), findsOneWidget);
    expect(find.text(AccountTexts.benefitLocal), findsOneWidget);
    expect(find.byKey(const ValueKey('account-email')), findsOneWidget);
    expect(server.requests, isEmpty);
    await unmount(tester);
  });

  testWidgets(
    '13 yaş altı: açıklama, bilgi gönderilmez, hesap kapısı kapanır',
    (tester) async {
      await pump(tester, const AccountRow());
      await tapKey(tester, 'profile-account');
      await tapKey(tester, 'account-email');
      await tester.enterText(
        find.byKey(const ValueKey('sign-in-email')),
        'kid@example.com',
      );
      await tapKey(tester, 'sign-in-send');
      expect(find.byKey(const ValueKey('sign-in-resend-wait')), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('sign-in-code')),
        server.lastCode!,
      );
      await settle(tester);
      expect(find.byKey(const ValueKey('sign-in-birth-year')), findsOneWidget);
      final verifies = server.requests
          .where((r) => r.endsWith('/verify'))
          .length;
      await tester.enterText(
        find.byKey(const ValueKey('sign-in-birth-year')),
        '${DateTime.now().year - 10}',
      );
      await tapKey(tester, 'sign-in-create');
      expect(find.text(AccountTexts.ageBlocked), findsOneWidget);
      // Doğum yılı sunucuya hiç gitmedi.
      expect(
        server.requests.where((r) => r.endsWith('/verify')).length,
        verifies,
      );
      expect(server.accounts, isEmpty);
      // Cihazda yalnızca hesabın açılabileceği yıl.
      final gate = await tester.runAsync(() => AgeGate(db).blockedUntil());
      expect(gate, DateTime.now().year + 3);
      await unmount(tester);

      await pump(tester, const AccountRow());
      expect(find.text(AccountTexts.ageBlocked), findsOneWidget);
      final row = tester.widget<SettingsRow>(
        find.byKey(const ValueKey('profile-account')),
      );
      expect(row.onTap, isNull);
      await unmount(tester);
    },
  );

  testWidgets('hesap aç → ilk eşitleme → hesap ekranı → çıkış', (tester) async {
    await db
        .into(db.userStoryProgress)
        .insert(
          UserStoryProgressCompanion.insert(
            contentId: 'A1-001',
            status: const Value('COMPLETED'),
            updatedAt: DateTime.utc(2026, 10, 12),
          ),
        );
    await pump(tester, const AccountRow());
    await tapKey(tester, 'profile-account');
    await tapKey(tester, 'account-email');
    // Geçersiz e-posta: istek yok.
    await tester.enterText(find.byKey(const ValueKey('sign-in-email')), 'x@');
    await tapKey(tester, 'sign-in-send');
    expect(find.text(AccountTexts.emailInvalid), findsOneWidget);
    expect(server.requests, isEmpty);

    await tester.enterText(
      find.byKey(const ValueKey('sign-in-email')),
      'deniz@example.com',
    );
    await tapKey(tester, 'sign-in-send');
    final field = tester.widget<TextField>(
      find.byKey(const ValueKey('sign-in-code')),
    );
    expect(field.autofillHints, contains(AutofillHints.oneTimeCode));
    expect(field.maxLength, 6);
    // Eşleşmeyen kod: sakin açıklama.
    await tester.enterText(
      find.byKey(const ValueKey('sign-in-code')),
      '000000',
    );
    await settle(tester);
    expect(find.text(AccountTexts.errorFor('OTP_INVALID')), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('sign-in-code')),
      server.lastCode!,
    );
    await settle(tester);
    await tester.enterText(
      find.byKey(const ValueKey('sign-in-birth-year')),
      '2000',
    );
    // Onaysız devam edilemez.
    await tapKey(tester, 'sign-in-create');
    expect(find.text(AccountTexts.consentMissing), findsOneWidget);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('sign-in-terms')),
        matching: find.byType(Checkbox),
      ),
    );
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('sign-in-privacy')),
        matching: find.byType(Checkbox),
      ),
    );
    await settle(tester);
    await tapKey(tester, 'sign-in-create');
    await settle(tester, 40);
    expect(find.text(AccountTexts.synced), findsOneWidget);
    expect(
      server.dataOf('deniz@example.com')['user_story_progress'],
      hasLength(1),
    );
    await tapKey(tester, 'sign-in-finish');
    expect(find.text('d•••@example.com'), findsOneWidget);
    expect(find.text('Eşitleme: az önce'), findsOneWidget);

    await tapKey(tester, 'account-sign-out');
    expect(find.text(AccountTexts.signOutBody), findsOneWidget);
    await tapKey(tester, 'account-confirm-ok');
    await settle(tester, 30);
    expect(find.byKey(const ValueKey('account-email')), findsOneWidget);
    expect(tokens.tokens, isNull);
    // Veri cihazda kaldı.
    final rows = await tester.runAsync(
      () => db.select(db.userStoryProgress).get(),
    );
    expect(rows, hasLength(1));
    await unmount(tester);
  });

  testWidgets('oturum güvenlik için kapandıysa sakin açıklama', (tester) async {
    await db
        .into(db.syncState)
        .insert(
          SyncStateCompanion.insert(
            signedOutReason: const Value('TOKEN_REUSED'),
          ),
        );
    await pump(tester, const AccountScreen());
    expect(
      find.text(AccountTexts.signedOutReason('TOKEN_REUSED')!),
      findsOneWidget,
    );
    await unmount(tester);
  });

  testWidgets(
    'Ana Sayfa kartı: ilerleme varsa görünür, "Şimdi değil" kapatır',
    (tester) async {
      await pump(tester, const AccountNudgeCard());
      expect(find.byKey(const ValueKey('home-account-nudge')), findsNothing);
      await unmount(tester);

      await db
          .into(db.userStoryProgress)
          .insert(
            UserStoryProgressCompanion.insert(
              contentId: 'A1-001',
              status: const Value('COMPLETED'),
              updatedAt: DateTime.utc(2026, 10, 12),
            ),
          );
      await pump(tester, const AccountNudgeCard());
      expect(find.text(AccountTexts.nudgeTitle), findsOneWidget);
      await tapKey(tester, 'home-account-nudge-later');
      expect(find.byKey(const ValueKey('home-account-nudge')), findsNothing);
      await unmount(tester);
      // 30 gün içinde yeniden görünmez.
      await pump(tester, const AccountNudgeCard());
      expect(find.byKey(const ValueKey('home-account-nudge')), findsNothing);
      expect(server.requests, isEmpty);
      await unmount(tester);
    },
  );
}
