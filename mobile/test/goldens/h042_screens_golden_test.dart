// H-042 ekran golden'ları ve erişilebilirlik denetimi: "Hakkında ve
// lisanslar", oturum kapalıyken "silinmek üzere" kartı, giriş → geri alma
// adımı ve günlük hatırlatma satırları (açık).
//
// Veriler sabit, yazı tipleri gömülü (`loadAppFonts`). Bilinçli görsel
// değişiklikten sonra:
//
//   cd mobile && flutter test --update-goldens test/goldens
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/app_info.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/account/application/account_providers.dart';
import 'package:hivelzon/features/account/presentation/account_screen.dart';
import 'package:hivelzon/features/account/presentation/sign_in_screen.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/profile/presentation/about_screen.dart';
import 'package:hivelzon/features/reminder/application/reminder_providers.dart';
import 'package:hivelzon/features/reminder/data/reminder_store.dart';
import 'package:hivelzon/features/reminder/domain/daily_reminder.dart';
import 'package:hivelzon/features/reminder/presentation/reminder_settings_row.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/api/token_store.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:hivelzon/shared/sync/sync_store.dart';
import 'package:hivelzon/shared/ui/ui.dart';

import '../support/app_fonts.dart';
import '../support/fake_api_server.dart';
import '../support/fake_content_source.dart';
import '../support/fake_reminder_scheduler.dart';
import '../support/golden.dart';

const _width = 390.0;

/// Sabit tarih (öğlen UTC: yerel gün saat diliminden etkilenmesin).
final _purge = DateTime.utc(2026, 11, 20, 12);
const _email = 'deniz@example.com';

/// Profil → Öğrenme grubundaki hatırlatma satırları (açık, 08:30).
class _ReminderGroup extends StatelessWidget {
  const _ReminderGroup();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(ProfileTexts.learningGroup)),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        SettingsGroup(
          title: ProfileTexts.learningGroup,
          children: [ReminderSettingsRow()],
        ),
      ],
    ),
  );
}

enum _Kind { about, pending, restore, reminder }

void main() {
  setUpAll(loadAppFonts);
  setUp(() => SyncController.listenLifecycle = false);
  tearDown(() => SyncController.listenLifecycle = true);

  Future<void> settle(WidgetTester tester, [int n = 10]) async {
    for (var i = 0; i < n; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> pumpScreen(
    WidgetTester tester,
    _Kind kind, {
    required double height,
    double width = _width,
    double textScale = 1,
  }) async {
    tester.view.physicalSize = Size(width * 2, height * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final server = FakeApiServer(clock: () => _purge);
    final os = FakeReminderScheduler(status: ReminderPermission.granted);
    if (kind == _Kind.restore) {
      server.seedAccount(_email, purgeAt: _purge);
    }
    if (kind == _Kind.reminder) {
      await tester.runAsync(
        () => ReminderStore(
          db,
        ).write(const ReminderSettings(enabled: true, hour: 8, minute: 30)),
      );
    }
    final Widget screen = switch (kind) {
      _Kind.about => const AboutScreen(),
      _Kind.pending => const AccountScreen(),
      _Kind.restore => const SignInScreen(),
      _Kind.reminder => const _ReminderGroup(),
    };
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
          reminderSchedulerProvider.overrideWithValue(os),
          if (kind == _Kind.pending || kind == _Kind.restore)
            pendingDeletionProvider.overrideWith(
              (ref) async => PendingDeletion(userId: 'u-1', purgeAt: _purge),
            ),
        ],
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
    if (kind == _Kind.pending) {
      final context = tester.element(find.byKey(const ValueKey('golden')));
      await tester.runAsync(
        () => precacheImage(AccountScreen.headerImage, context),
      );
    }
    await settle(tester);
    if (kind == _Kind.restore) {
      // Giriş: e-posta → kod → geri alma adımı (sunucu sahte).
      await tester.enterText(
        find.byKey(const ValueKey('sign-in-email')),
        _email,
      );
      await tester.ensureVisible(find.byKey(const ValueKey('sign-in-send')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('sign-in-send')));
      await settle(tester);
      await tester.enterText(
        find.byKey(const ValueKey('sign-in-code')),
        server.lastCode!,
      );
      await settle(tester, 20);
      expect(find.byKey(const ValueKey('sign-in-restore')), findsOneWidget);
      // Kod alanının odağı ve sayaç bitsin.
      FocusManager.instance.primaryFocus?.unfocus();
    }
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 61));
  }

  final screens = <String, (_Kind, double)>{
    'hakkinda': (_Kind.about, 1500),
    'hesap_silme_bekliyor': (_Kind.pending, 1000),
    'geri_al': (_Kind.restore, 844),
    'hatirlatma': (_Kind.reminder, 400),
  };

  for (final MapEntry(key: id, value: (kind, height)) in screens.entries) {
    testWidgets('golden: $id', (tester) async {
      await pumpScreen(tester, kind, height: height);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('golden')),
        matchesGoldenFile('images/h042_$id.png'),
      );
      await unmount(tester);
    }, skip: skipGoldensOffMac);

    testWidgets('$id: erişilebilirlik yönergeleri', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpScreen(tester, kind, height: height);
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
      await pumpScreen(tester, kind, height: height * 1.4, textScale: 1.3);
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });

    // H-064: en küçük hedef ekran.
    testWidgets('$id: 320 × 568, metin 1,3× büyütülünce taşma yok', (
      tester,
    ) async {
      await pumpScreen(tester, kind, width: 320, height: 568, textScale: 1.3);
      expect(tester.takeException(), isNull);
      await unmount(tester);
    });
  }

  testWidgets('Hakkında: sürüm, CEFR-J zorunlu atfı, bütün kaynaklar, '
      'lisans sayfası', (tester) async {
    await pumpScreen(tester, _Kind.about, height: 2400);
    expect(
      tester
          .widget<CapsLabel>(find.byKey(const ValueKey('about-version')))
          .text,
      AboutTexts.version(AppInfo.display),
    );
    expect(
      find.textContaining(
        'The CEFR-J Wordlist Version 1.6. Compiled by Yukio Tono, Tokyo '
        'University of Foreign Studies. Retrieved from '
        'https://www.cefr-j.org/download.html on 11/10/26.',
      ),
      findsOneWidget,
    );
    for (final needle in [
      'Creative Commons Attribution-ShareAlike 4.0',
      'Copyright (c) 2022 Open Spaced Repetition',
      'Copyright (c) 2026 recepyagmur',
      'SIL Open Font License 1.1',
    ]) {
      expect(find.textContaining(needle), findsOneWidget, reason: needle);
    }
    // K-08: seviye vaadi yok.
    expect(find.textContaining('seviyesine ulaş'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('about-licenses')));
    await tester.pumpAndSettle();
    expect(find.byType(LicensePage), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('silinmek üzere kartı: tarih ve geri alma düğmesi', (
    tester,
  ) async {
    await pumpScreen(tester, _Kind.pending, height: 1000);
    expect(
      find.text(AccountTexts.signedOutPendingBody(AccountTexts.date(_purge))),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('account-restore-signed-out')),
      findsOneWidget,
    );
    await unmount(tester);
  });
}
