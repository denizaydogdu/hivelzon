import 'dart:io';

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
import 'package:hivelzon/features/reminder/application/reminder_providers.dart';
import 'package:hivelzon/features/reminder/data/reminder_store.dart';
import 'package:hivelzon/features/reminder/domain/daily_reminder.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/api/api_client.dart';
import 'package:hivelzon/shared/api/auth_service.dart';
import 'package:hivelzon/shared/api/token_store.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/diagnostics/crash_log.dart';
import 'package:hivelzon/shared/diagnostics/crash_reporting.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:hivelzon/shared/sync/sync_store.dart';
import 'package:hivelzon/shared/ui/ui.dart';

import '../../support/fake_api_server.dart';
import '../../support/fake_reminder_scheduler.dart';
import '../../support/fake_content_source.dart';

void main() {
  late AppDatabase db;
  late FakeApiServer server;
  late MemoryTokenStore tokens;
  late FakeReminderScheduler reminders;
  late Directory crashDir;
  late CrashLog crashLog;

  setUp(() {
    crashDir = Directory.systemTemp.createTempSync('hv_crash_');
    crashLog = CrashLog(directory: () async => crashDir, appVersion: '0.1.0+1');
    db = AppDatabase.memory();
    server = FakeApiServer();
    tokens = MemoryTokenStore();
    reminders = FakeReminderScheduler();
    SyncController.listenLifecycle = false;
  });
  tearDown(() async {
    SyncController.listenLifecycle = true;
    await db.close();
    crashDir.deleteSync(recursive: true);
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
          reminderSchedulerProvider.overrideWithValue(reminders),
          crashLogProvider.overrideWithValue(crashLog),
        ],
        // Uygulama kökü gibi: eşitleme denetleyicisi baştan dinlenir.
        child: Consumer(
          builder: (context, ref, child) {
            ref.watch(syncControllerProvider);
            return child!;
          },
          child: MaterialApp.router(
            theme: AppTheme.light(),
            routerConfig: router,
          ),
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

  testWidgets('H-042 uçtan uca: hesabı sil → çıkışta "silinmek üzere" kartı '
      've tarih → yeni kodla giriş → geri al', (tester) async {
    // Hesap açık başlar (kayıt akışı yukarıdaki testte).
    final store = SyncStore(db);
    final auth = AuthService(
      api: ApiClient(
        client: server.client,
        baseUrl: Uri.parse('http://127.0.0.1:8080'),
        sleep: (_) async {},
      ),
      tokens: tokens,
      store: store,
    );
    await tester.runAsync(() async {
      await auth.startEmail('deniz@example.com');
      await auth.verify(
        'deniz@example.com',
        server.lastCode!,
        signup: const SignupDetails(
          birthYear: 2000,
          termsVersion: 'taslak-1',
          privacyNoticeVersion: 'taslak-1',
        ),
      );
    });
    await pump(tester, const AccountScreen());
    expect(find.text('d•••@example.com'), findsOneWidget);

    // 1) Sil: onay → istek → oturum kapanır.
    await tapKey(tester, 'account-delete');
    expect(find.text(AccountTexts.deleteBody), findsOneWidget);
    await tapKey(tester, 'account-confirm-ok');
    await settle(tester, 30);
    expect(server.requests, contains('DELETE /api/v1/me'));
    expect(tokens.tokens, isNull);
    final purge = server.accounts['deniz@example.com']!.purgeAt!;
    final date = AccountTexts.date(purge);

    // 2) Oturum kapalı: durum ve kalıcı silme tarihi görünür.
    expect(
      find.byKey(const ValueKey('account-pending-deletion-signed-out')),
      findsOneWidget,
    );
    expect(find.text(AccountTexts.signedOutPendingBody(date)), findsOneWidget);
    expect(find.byKey(const ValueKey('account-email')), findsOneWidget);
    // Cihazda e-posta yok; yalnızca işaret.
    final marker = await tester.runAsync(store.pendingDeletion);
    expect(marker!.purgeAt, purge);

    // 3) Geri al → giriş: yeni kodun gerekçesi.
    await tapKey(tester, 'account-restore-signed-out');
    expect(find.text(AccountTexts.restoreWhyCode), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('sign-in-email')),
      'deniz@example.com',
    );
    await tapKey(tester, 'sign-in-send');
    await tester.enterText(
      find.byKey(const ValueKey('sign-in-code')),
      server.lastCode!,
    );
    await settle(tester);

    // 4) Geri alma adımı: tarih ve kodun neden istendiği.
    expect(find.text(AccountTexts.restoreBody(date)), findsOneWidget);
    await tapKey(tester, 'sign-in-restore');
    await settle(tester, 40);
    expect(server.requests, contains('POST /api/v1/me/restore'));
    expect(server.accounts['deniz@example.com']!.status, 'ACTIVE');
    expect(find.byKey(const ValueKey('sign-in-done')), findsOneWidget);
    await tapKey(tester, 'sign-in-finish');

    // 5) Hesap etkin; kart ve işaret yok.
    expect(find.text('d•••@example.com'), findsOneWidget);
    expect(find.byKey(const ValueKey('account-delete')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('account-pending-deletion-signed-out')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('account-pending-deletion')),
      findsNothing,
    );
    expect(await tester.runAsync(store.pendingDeletion), isNull);
    await tester.runAsync(auth.dispose);
    await unmount(tester);
  });

  testWidgets('H-042: "Bu telefondaki verileri sil" hatırlatmayı da '
      'kaldırır; H-043: hata kaydı da silinir', (tester) async {
    final auth = AuthService(
      api: ApiClient(
        client: server.client,
        baseUrl: Uri.parse('http://127.0.0.1:8080'),
        sleep: (_) async {},
      ),
      tokens: tokens,
      store: SyncStore(db),
    );
    await tester.runAsync(() async {
      await auth.startEmail('deniz@example.com');
      await auth.verify(
        'deniz@example.com',
        server.lastCode!,
        signup: const SignupDetails(
          birthYear: 2000,
          termsVersion: 'taslak-1',
          privacyNoticeVersion: 'taslak-1',
        ),
      );
      await ReminderStore(
        db,
      ).write(const ReminderSettings(enabled: true, hour: 8, minute: 0));
      await crashLog.record('test', StateError('x'), StackTrace.current);
    });
    expect(await tester.runAsync(crashLog.entries), hasLength(1));
    reminders.scheduled = (8, 0, 'hiVelzon', '');
    await pump(tester, const AccountScreen());
    await tapKey(tester, 'account-sign-out-wipe');
    await tapKey(tester, 'account-confirm-ok');
    await settle(tester, 30);
    expect(reminders.scheduled, isNull);
    expect(reminders.cancelCalls, 1);
    final s = await tester.runAsync(() => ReminderStore(db).read());
    expect(s, ReminderSettings.off);
    // Dosya silme gerçek G/Ç: gerçek ve sahte zaman sırayla ilerler.
    for (var i = 0; i < 10; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 5)),
      );
      await tester.pump();
    }
    expect(await tester.runAsync(crashLog.entries), isEmpty);
    await tester.runAsync(auth.dispose);
    await unmount(tester);
  });

  testWidgets('H-042: geri almadan çıkılırsa kart kalır; Profil satırı da '
      'söyler', (tester) async {
    final purge = DateTime.now().toUtc().add(const Duration(days: 12));
    await tester.runAsync(
      () => SyncStore(db).recordPendingDeletion('u-1', purge),
    );
    await pump(tester, const AccountRow());
    expect(
      find.text(AccountTexts.pendingDeletion(AccountTexts.date(purge))),
      findsOneWidget,
    );
    await tapKey(tester, 'profile-account');
    expect(
      find.byKey(const ValueKey('account-pending-deletion-signed-out')),
      findsOneWidget,
    );
    expect(server.requests, isEmpty);
    await unmount(tester);
  });

  testWidgets('H-042: kalıcı silme tarihi geçtiyse kart görünmez', (
    tester,
  ) async {
    await tester.runAsync(
      () => SyncStore(db).recordPendingDeletion(
        'u-1',
        DateTime.now().toUtc().subtract(const Duration(minutes: 1)),
      ),
    );
    await pump(tester, const AccountScreen());
    expect(
      find.byKey(const ValueKey('account-pending-deletion-signed-out')),
      findsNothing,
    );
    expect(find.byKey(const ValueKey('account-email')), findsOneWidget);
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

  Future<void> setMeta(String key, String value) => db
      .into(db.appMeta)
      .insertOnConflictUpdate(AppMetaCompanion.insert(key: key, value: value));

  testWidgets('H-095: metin güncellendi kartı bir kez görünür, yeniden onay '
      'istemez', (tester) async {
    // Açılışta eski sürüm okunmuş; uygulamadaki sürüm yeni.
    await setMeta('onboarding.completedAt', '2026-10-14T10:00:00Z');
    await setMeta('onboarding.noticeVersion', 'taslak-1');
    expect(ApiConfig.defaultLegalVersion, isNot('taslak-1'));

    await pump(tester, const LegalUpdateCard());
    expect(find.byKey(const ValueKey('home-legal-update')), findsOneWidget);
    expect(
      find.text(AccountTexts.legalUpdateTitle(terms: true, privacy: true)),
      findsOneWidget,
    );
    expect(find.text(AccountTexts.legalUpdateBody), findsOneWidget);
    // Onay kutusu ya da kabul isteği yok; sunucuya istek gitmez.
    expect(find.byType(Checkbox), findsNothing);
    expect(server.requests, isEmpty);

    // Metni açmak sürümü görüldü sayar ve metne götürür.
    await tapKey(tester, 'home-legal-update-privacy');
    expect(find.text(AccountTexts.privacyTitle), findsOneWidget);
    expect(find.byType(LegalTextScreen), findsOneWidget);
    await unmount(tester);

    // Aynı sürüm için bir daha görünmez.
    await pump(tester, const LegalUpdateCard());
    expect(find.byKey(const ValueKey('home-legal-update')), findsNothing);
    await unmount(tester);
  });

  testWidgets('H-095: "Tamam" kapatır; yalnızca güncellenen metin anılır', (
    tester,
  ) async {
    await setMeta('onboarding.completedAt', '2026-10-14T10:00:00Z');
    await setMeta(
      LegalUpdateNotice.seenTermsKey,
      ApiConfig.defaultLegalVersion,
    );
    await setMeta(LegalUpdateNotice.seenPrivacyKey, 'taslak-1');
    await pump(tester, const LegalUpdateCard());
    expect(
      find.text(AccountTexts.legalUpdateTitle(terms: false, privacy: true)),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('home-legal-update-terms')), findsNothing);
    await tapKey(tester, 'home-legal-update-dismiss');
    expect(find.byKey(const ValueKey('home-legal-update')), findsNothing);
    await unmount(tester);
    await pump(tester, const LegalUpdateCard());
    expect(find.byKey(const ValueKey('home-legal-update')), findsNothing);
    expect(server.requests, isEmpty);
    await unmount(tester);
  });

  testWidgets('H-095: eski sürümü onaylamış hesap eşitlemeye devam eder', (
    tester,
  ) async {
    // Hesap eski metin sürümüyle açılmış; uygulama yeni sürümde.
    await setMeta('onboarding.completedAt', '2026-10-14T10:00:00Z');
    await setMeta('onboarding.noticeVersion', 'taslak-1');
    await pump(tester, const LegalUpdateCard());
    final container = ProviderScope.containerOf(
      tester.element(find.byType(LegalUpdateCard)),
    );
    final auth = container.read(authServiceProvider);
    final started = auth.startEmail('eski@example.com');
    await settle(tester);
    await started;
    final verified = auth.verify(
      'eski@example.com',
      server.lastCode!,
      signup: const SignupDetails(
        birthYear: 2000,
        termsVersion: 'taslak-1',
        privacyNoticeVersion: 'taslak-1',
      ),
    );
    await settle(tester);
    await verified;
    expect(find.byKey(const ValueKey('home-legal-update')), findsOneWidget);
    // Bildirim eşitlemeyi durdurmaz.
    final before = server.requests.length;
    final synced = container.read(syncControllerProvider.notifier).syncNow();
    await settle(tester);
    await synced;
    expect(
      server.requests.skip(before).where((r) => r.contains('/sync/')),
      isNotEmpty,
    );
    expect(find.byKey(const ValueKey('home-legal-update')), findsOneWidget);
    await unmount(tester);
  });
}
