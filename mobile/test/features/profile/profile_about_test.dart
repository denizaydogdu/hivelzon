import 'dart:io';

import 'package:flutter/foundation.dart' show LicenseRegistry;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/app_info.dart';
import 'package:hivelzon/app/router.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/app/third_party_licenses.dart';
import 'package:hivelzon/features/account/presentation/account_widgets.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/profile/presentation/about_screen.dart';
import 'package:hivelzon/features/profile/presentation/profile_screen.dart';
import 'package:hivelzon/features/reminder/application/reminder_providers.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';

import '../../support/fake_content_source.dart';
import '../../support/fake_reminder_scheduler.dart';

void main() {
  test('sürüm sabiti pubspec.yaml ile aynı', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final v = RegExp(
      r'^version:\s*(\S+)',
      multiLine: true,
    ).firstMatch(pubspec)!.group(1);
    expect(AppInfo.version, v);
    expect(AppInfo.display, '1.0.0 (1)');
  });

  test('taşınan kodun MIT bildirimleri Lisanslar sayfasında', () async {
    registerThirdPartyLicenses();
    final entries = await LicenseRegistry.licenses.toList();
    final packages = {for (final e in entries) ...e.packages};
    expect(packages, containsAll(['py-fsrs', 'EnglishPractice']));
    final fsrs = entries.firstWhere((e) => e.packages.contains('py-fsrs'));
    expect(
      fsrs.paragraphs.map((p) => p.text).join('\n'),
      contains('Copyright (c) 2022 Open Spaced Repetition'),
    );
  });

  group('Profil → Hakkında (H-042)', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase.memory());
    tearDown(() => db.close());

    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 20; i++) {
        await tester.runAsync(() => Future<void>.delayed(Duration.zero));
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    Future<void> pump(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1179, 2556);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final router = GoRouter(
        initialLocation: AppRoutes.profile,
        routes: [
          GoRoute(
            path: AppRoutes.profile,
            builder: (_, _) => const ProfileScreen(),
            routes: [
              GoRoute(path: 'hakkinda', builder: (_, _) => const AboutScreen()),
              GoRoute(
                path: 'hesap/metin/:kind',
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
            reminderSchedulerProvider.overrideWithValue(
              FakeReminderScheduler(),
            ),
          ],
          child: MaterialApp.router(
            theme: AppTheme.light(),
            routerConfig: router,
          ),
        ),
      );
      await settle(tester);
    }

    Future<void> tapKey(WidgetTester tester, String key) async {
      final f = find.byKey(ValueKey(key));
      await tester.ensureVisible(f);
      await tester.pump();
      await tester.tap(f);
      await settle(tester);
    }

    testWidgets('hatırlatma satırı Öğrenme grubunda; CEFR seviyesi yok', (
      tester,
    ) async {
      await pump(tester);
      expect(
        find.byKey(const ValueKey('profile-reminder-toggle')),
        findsOneWidget,
      );
      // K-08: Profil'de seviye gösterilmez.
      for (final level in ['A1', 'A2', 'B1', 'B2', 'C1', 'C2', 'CEFR']) {
        expect(find.textContaining(level), findsNothing, reason: level);
      }
    });

    testWidgets('kullanım koşulları ve aydınlatma Profil\'den açılır '
        '(taslak işaretli)', (tester) async {
      await pump(tester);
      expect(find.text(ProfileTexts.legalDraftHint), findsNWidgets(2));
      await tapKey(tester, 'profile-terms');
      expect(find.text(AccountTexts.termsTitle), findsOneWidget);
      expect(find.text(AccountTexts.legalDraft), findsOneWidget);
      await tester.pageBack();
      await settle(tester);
      await tapKey(tester, 'profile-privacy');
      expect(find.text(AccountTexts.privacyTitle), findsOneWidget);
      expect(find.text(AccountTexts.legalDraft), findsOneWidget);
    });

    testWidgets('"Hakkında ve lisanslar" açılır: sürüm ve lisans sayfası', (
      tester,
    ) async {
      await pump(tester);
      await tapKey(tester, 'profile-about');
      expect(find.byKey(const ValueKey('about-screen')), findsOneWidget);
      expect(find.byKey(const ValueKey('about-version')), findsOneWidget);
      await tapKey(tester, 'about-licenses');
      await tester.pumpAndSettle();
      expect(find.byType(LicensePage), findsOneWidget);
    });
  });
}
