import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/profile/data/user_profile_store.dart';
import 'package:hivelzon/features/profile/presentation/profile_screen.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';

import '../../support/fake_content_source.dart';

void main() {
  group('ad kuralı (H-053)', () {
    test('boşluk kırpılır, boş ad geçerli (isteğe bağlı)', () {
      expect(normalizeDisplayName('  Deniz  '), 'Deniz');
      expect(normalizeDisplayName('Ali    Can'), 'Ali Can');
      expect(normalizeDisplayName('   '), isNull);
      expect(validateDisplayName(''), isNull);
      expect(validateDisplayName('   '), isNull);
    });

    test('harf, boşluk, kesme, tire; en fazla 20 karakter', () {
      for (final ok in ['Deniz', 'Ayşe', 'İlkay', "D'Arcy", 'Ali-Can', 'Şü']) {
        expect(validateDisplayName(ok), isNull, reason: ok);
      }
      expect(validateDisplayName('a' * 20), isNull);
      expect(validateDisplayName('a' * 21), DisplayNameError.tooLong);
      expect(validateDisplayName('Deniz1'), DisplayNameError.invalidCharacters);
      expect(validateDisplayName('<b>'), DisplayNameError.invalidCharacters);
      expect(validateDisplayName('@deniz'), DisplayNameError.invalidCharacters);
    });
  });

  group('UserProfileStore', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase.memory());
    tearDown(() => db.close());

    test('kaydedilir, okunur, silinir (app_meta)', () async {
      final store = UserProfileStore(db);
      expect(await store.displayName(), isNull);
      await store.setDisplayName('  Deniz ');
      expect(await store.displayName(), 'Deniz');
      // Yeni depo nesnesi aynı veritabanından okur (kalıcılık).
      expect(await UserProfileStore(db).displayName(), 'Deniz');
      final rows = await db.select(db.appMeta).get();
      expect(rows.single.key, UserProfileStore.displayNameKey);
      await store.setDisplayName('');
      expect(await store.displayName(), isNull);
      expect(await db.select(db.appMeta).get(), isEmpty);
    });

    test('geçersiz ad yazılmaz', () async {
      final store = UserProfileStore(db);
      expect(() => store.setDisplayName('x' * 30), throwsArgumentError);
      expect(await store.displayName(), isNull);
    });
  });

  group('Profil ekranı', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase.memory());
    tearDown(() => db.close());

    Future<void> pump(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1179, 2556);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            legacyImportProvider.overrideWithValue(Future<void>.value()),
            contentSourceProvider.overrideWithValue(FakeContentSource()),
            progressRepositoryProvider.overrideWithValue(
              InMemoryProgressRepository(),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const ProfileScreen(),
          ),
        ),
      );
    }

    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 20; i++) {
        await tester.runAsync(() => Future<void>.delayed(Duration.zero));
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    testWidgets('bölüm başlıkları ve ad alanı; kaydet ve doğrula', (
      tester,
    ) async {
      await pump(tester);
      await settle(tester);
      expect(find.text('Profil'), findsOneWidget);
      expect(find.text('Sana nasıl seslenelim?'), findsOneWidget);
      expect(
        find.text('İsteğe bağlı. Yalnızca bu cihazda saklanır.'),
        findsOneWidget,
      );
      expect(find.text('Defter'), findsOneWidget);
      expect(find.text('Günlük hedef'), findsOneWidget);

      // Geçersiz: rakam → hata, yazılmaz.
      await tester.enterText(
        find.byKey(const ValueKey('profile-name')),
        'Deniz1',
      );
      await tester.tap(find.byKey(const ValueKey('profile-name-save')));
      await settle(tester);
      expect(
        find.text(
          'Yalnızca harf, boşluk, kesme işareti ve tire kullanabilirsin.',
        ),
        findsOneWidget,
      );
      expect(
        await tester.runAsync(() => UserProfileStore(db).displayName()),
        isNull,
      );

      // Geçerli: kırpılır ve kaydedilir.
      await tester.enterText(
        find.byKey(const ValueKey('profile-name')),
        '  Deniz ',
      );
      await tester.tap(find.byKey(const ValueKey('profile-name-save')));
      await settle(tester);
      expect(find.text('Adın kaydedildi.'), findsOneWidget);
      expect(
        await tester.runAsync(() => UserProfileStore(db).displayName()),
        'Deniz',
      );

      // Alan en fazla 20 karakter alır.
      final field = tester.widget<TextField>(
        find.byKey(const ValueKey('profile-name')),
      );
      expect(field.maxLength, 20);

      // Yeniden açılınca kayıtlı ad alanda.
      await tester.pumpWidget(const SizedBox());
      await settle(tester);
      await pump(tester);
      await settle(tester);
      expect(find.widgetWithText(TextField, 'Deniz'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await settle(tester);
    });
  });
}
