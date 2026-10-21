import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/reminder/application/reminder_providers.dart';
import 'package:hivelzon/features/reminder/data/reminder_store.dart';
import 'package:hivelzon/features/reminder/domain/daily_reminder.dart';
import 'package:hivelzon/features/reminder/presentation/reminder_settings_row.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:hivelzon/shared/ui/ui.dart';

import '../../support/fake_reminder_scheduler.dart';

void main() {
  late AppDatabase db;
  late FakeReminderScheduler os;

  setUp(() {
    db = AppDatabase.memory();
    os = FakeReminderScheduler();
  });
  tearDown(() => db.close());

  Future<void> settle(WidgetTester tester, [int n = 12]) async {
    for (var i = 0; i < n; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          legacyImportProvider.overrideWithValue(Future<void>.value()),
          reminderSchedulerProvider.overrideWithValue(os),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16),
              child: SettingsGroup(children: [ReminderSettingsRow()]),
            ),
          ),
        ),
      ),
    );
    await settle(tester);
  }

  Switch toggle(WidgetTester tester) => tester.widget<Switch>(
    find.descendant(
      of: find.byKey(const ValueKey('profile-reminder-toggle')),
      matching: find.byType(Switch),
    ),
  );

  testWidgets('varsayılan kapalı; izin okunmaz, saat satırı yok', (
    tester,
  ) async {
    await pump(tester);
    expect(toggle(tester).value, isFalse);
    expect(find.text(ReminderTexts.hintOff), findsOneWidget);
    expect(find.byKey(const ValueKey('profile-reminder-time')), findsNothing);
    expect(os.permissionReads + os.permissionRequests, 0);
  });

  testWidgets('açınca izin sorulur, kurulur; saat satırı görünür', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('profile-reminder-toggle')));
    await settle(tester);
    expect(os.permissionRequests, 1);
    expect(os.scheduled?.$1, 19);
    expect(toggle(tester).value, isTrue);
    expect(find.text(ReminderTexts.hintOn('19:00')), findsOneWidget);
    expect(find.text(ReminderTexts.enabled('19:00')), findsOneWidget);
    expect(find.byKey(const ValueKey('profile-reminder-time')), findsOneWidget);
    expect(find.text('19:00'), findsOneWidget);

    // Kapat: kaldırılır.
    await tester.tap(find.byKey(const ValueKey('profile-reminder-toggle')));
    await settle(tester);
    expect(os.scheduled, isNull);
    expect(toggle(tester).value, isFalse);
    expect(find.text(ReminderTexts.disabled), findsOneWidget);
  });

  testWidgets('izin verilmezse sakin not, anahtar kapalı kalır', (
    tester,
  ) async {
    os.grantOnRequest = false;
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('profile-reminder-toggle')));
    await settle(tester);
    expect(toggle(tester).value, isFalse);
    expect(find.text(ReminderTexts.denied), findsOneWidget);
    expect(os.scheduled, isNull);
  });

  testWidgets('izin sonradan kapatıldıysa satır nedenini söyler', (
    tester,
  ) async {
    await ReminderStore(db).write(const ReminderSettings(enabled: true));
    os.status = ReminderPermission.denied;
    await pump(tester);
    expect(find.text(ReminderTexts.blocked), findsOneWidget);
    // Kapatılabilir.
    expect(toggle(tester).value, isTrue);
  });

  testWidgets('saat seçilince yeni saatle yeniden kurulur', (tester) async {
    await ReminderStore(db).write(const ReminderSettings(enabled: true));
    os.status = ReminderPermission.granted;
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('profile-reminder-time')));
    await tester.pumpAndSettle();
    expect(find.text(ReminderTexts.timePickerHelp), findsOneWidget);
    // Yazarak giriş moduna geç ve 08:30 yaz.
    await tester.tap(find.byIcon(Icons.keyboard_outlined));
    await tester.pumpAndSettle();
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '08');
    await tester.enterText(fields.at(1), '30');
    await tester.tap(find.text('OK'));
    await settle(tester);
    expect(os.scheduled?.$1, 8);
    expect(os.scheduled?.$2, 30);
    expect(find.text('08:30'), findsOneWidget);
    expect(find.text(ReminderTexts.timeChanged('08:30')), findsOneWidget);
  });
}
