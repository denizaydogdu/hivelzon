import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/profile/data/user_profile_store.dart';
import 'package:hivelzon/features/profile/presentation/profile_screen.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/haptics/haptics.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:hivelzon/shared/ui/ui.dart';

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

    Future<void> pump(WidgetTester tester, {double topInset = 0}) async {
      tester.view.physicalSize = const Size(1179, 2556);
      tester.view.devicePixelRatio = 3;
      tester.view.padding = FakeViewPadding(top: topInset * 3);
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

    Future<void> openSheet(WidgetTester tester, String key) async {
      final f = find.byKey(ValueKey(key));
      await tester.ensureVisible(f);
      await tester.pump();
      await tester.tap(f);
      await settle(tester);
    }

    testWidgets('başlık, istatistikler ve gruplar (adsız: "Merhaba!")', (
      tester,
    ) async {
      await pump(tester);
      await settle(tester);
      // H-089: kanıt yokken sakin davet cümlesi.
      expect(
        find.text(
          'Kelime tekrarında bir ifadeyi kendin hatırladığında burada görünür.',
        ),
        findsOneWidget,
      );
      expect(find.text('Merhaba!'), findsOneWidget);
      expect(find.byKey(const ValueKey('profile-stats')), findsOneWidget);
      expect(find.text('ifade'), findsOneWidget);
      expect(find.text('bölüm bitti'), findsOneWidget);
      expect(find.text('bu hafta tekrar'), findsOneWidget);
      expect(find.text('Öğrenme'), findsOneWidget);
      expect(find.text('Hesap ve gizlilik'), findsOneWidget);
      expect(find.text('Defter'), findsOneWidget);
      expect(find.text('Günlük hedef'), findsOneWidget);
      expect(find.text('Konu setleri'), findsOneWidget);
      expect(find.text('Hesap'), findsOneWidget);
      expect(find.text('Hi benim hakkımda ne biliyor?'), findsOneWidget);
      // Açıklamalar satır altı ipucu.
      expect(
        find.text('Bölüm bitince ifadeler buraya eklenir.'),
        findsOneWidget,
      );
      expect(find.text('Eklenmedi'), findsOneWidget);
      expect(find.text('Bugün küçük bir adım yeter.'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await settle(tester);
    });

    testWidgets('H-089: kanıta dayalı kazanımlar; sayılar "İçerik '
        'ilerlemesi" başlığında', (tester) async {
      await tester.runAsync(() async {
        final store = NotebookStore(db);
        NotebookItem it(String en) => NotebookItem(
          kind: NotebookKind.phrase,
          textEn: en,
          textTr: 'tr',
          source: NotebookSource.userSaved,
          createdAt: DateTime.utc(2026, 10, 1),
        );
        await store.addItems([
          it('Where is…?'),
          it('Excuse me.'),
          it('What time is it?'),
        ]);
        for (final (key, stage) in [
          ('phrase|where is…', 'recalled_later'),
          ('phrase|excuse me', 'own_use'),
          ('phrase|what time is it', 'helped'),
        ]) {
          await db
              .into(db.evidenceRecords)
              .insert(
                EvidenceRecordsCompanion.insert(
                  itemKey: key,
                  stage: stage,
                  at: DateTime.utc(2026, 10, 5),
                ),
              );
        }
        // "What time is it?" son hatırlamada gelmedi: yeniden öğrenmede.
        final id = (await store.entries())
            .firstWhere((e) => e.item.textEn == 'What time is it?')
            .card
            .id;
        await (db.update(db.reviewCards)..where((t) => t.id.equals(id))).write(
          ReviewCardsCompanion(
            state: const Value(3),
            step: const Value(0),
            reps: const Value(3),
            lastReview: Value(DateTime.utc(2026, 10, 6)),
          ),
        );
      });
      await pump(tester);
      await settle(tester);
      expect(find.text('Neler yapabiliyorsun'), findsOneWidget);
      expect(
        find.text('Birkaç gün sonra kendin hatırladın: “Where is…?”'),
        findsOneWidget,
      );
      expect(
        find.text('Türkçesinden kendin söyledin ya da yazdın: “Excuse me.”'),
        findsOneWidget,
      );
      expect(
        find.text('Yeniden çalışalım: “What time is it?”'),
        findsOneWidget,
      );
      expect(find.textContaining('Yardımla yaptın'), findsNothing);
      expect(find.text('İçerik ilerlemesi'), findsOneWidget);
      expect(find.textContaining('%'), findsNothing);
      for (final w in ['yanlış', 'başarısız', 'unuttun']) {
        expect(find.textContaining(w), findsNothing, reason: w);
      }
      await tester.pumpWidget(const SizedBox());
      await settle(tester);
    });

    test('kanıt cümlesi listesi: en çok iki ifade, kalanı sayıyla', () {
      expect(ProfileTexts.evidenceList(['A']), '“A”');
      expect(
        ProfileTexts.evidenceRevisit(['the radio']),
        'Yeniden çalışalım: “the radio”.',
      );
      expect(
        ProfileTexts.evidenceHelped(['Hi.', 'the radio']),
        'Yardımla yaptın: “Hi.” ve “the radio”. Sırada kendin hatırlamak var.',
      );
      expect(ProfileTexts.evidenceList(['A', 'B']), '“A” ve “B”');
      expect(
        ProfileTexts.evidenceList(['A', 'B', 'C', 'D']),
        '“A”, “B” ve 2 ifade daha',
      );
    });

    testWidgets('"Titreşim" anahtarı: varsayılan açık, kapatılınca kaydedilir '
        '(H-064)', (tester) async {
      await pump(tester);
      await settle(tester);
      final row = find.byKey(const ValueKey('profile-haptics-toggle'));
      await tester.ensureVisible(row);
      await tester.pump();
      expect(find.text('Titreşim'), findsOneWidget);
      // Öğrenme grubunda, "Söyle alıştırmaları"nın altında.
      expect(
        find.descendant(
          of: find.ancestor(
            of: find.text('Öğrenme'),
            matching: find.byType(SettingsGroup),
          ),
          matching: row,
        ),
        findsOneWidget,
      );
      bool switchValue() => tester
          .widget<Switch>(
            find.descendant(of: row, matching: find.byType(Switch)),
          )
          .value;
      expect(switchValue(), isTrue);
      await tester.tap(row);
      await settle(tester);
      expect(switchValue(), isFalse);
      expect(await HapticsStore(db).enabled(), isFalse);
      await tester.pumpWidget(const SizedBox());
      await settle(tester);
    });

    testWidgets('kaydırınca durum çubuğunun altına kum perdesi gelir; içerik '
        'saatin üstüne binmez (H-064)', (tester) async {
      await pump(tester, topInset: 59);
      await settle(tester);
      double opacity() => tester
          .widget<AnimatedOpacity>(
            find.byKey(const ValueKey('status-bar-scrim')),
          )
          .opacity;
      // En üstte illüstrasyon durum çubuğunun altında; perde yok.
      expect(opacity(), 0);
      final greeting = find.byKey(const ValueKey('profile-greeting'));
      // Selam satırını saatin hizasına (y ≈ 20) kaydır.
      final start = tester.getRect(greeting).top;
      await tester.timedDrag(
        find.byKey(const ValueKey('profile-list')),
        Offset(0, -(start - 20)),
        const Duration(seconds: 1),
      );
      await tester.pumpAndSettle();
      expect(opacity(), 1);
      final scrim = tester.getRect(
        find.byKey(const ValueKey('status-bar-scrim')),
      );
      expect(scrim.top, 0);
      expect(scrim.height, 59);
      expect(tester.getRect(greeting).top, lessThan(59));
      // Perde selamın üstünde (Stack'te sonra) çizilir ve dokunuşu alır.
      expect(greeting.hitTestable(at: Alignment.topLeft), findsNothing);
      // Geri en üste: perde kaybolur.
      await tester.drag(
        find.byKey(const ValueKey('profile-list')),
        const Offset(0, 600),
      );
      await tester.pumpAndSettle();
      expect(opacity(), 0);
      await tester.pumpWidget(const SizedBox());
      await settle(tester);
    });

    testWidgets('günlük hedef paneli: seçim kaydedilir, satır güncellenir', (
      tester,
    ) async {
      await pump(tester);
      await settle(tester);
      expect(find.text('10 dk'), findsOneWidget);
      await openSheet(tester, 'profile-goal');
      expect(find.byKey(const ValueKey('daily-goal')), findsOneWidget);
      expect(find.text('Günde ne kadar zaman ayırmak istersin?'), findsOne);
      await tester.tap(find.text('15 dk'));
      await settle(tester);
      expect(
        await tester.runAsync(() => NotebookStore(db).dailyGoalMinutes()),
        15,
      );
      expect(
        find.text('Kelime tekrarında günde en fazla 15 yeni ifade açılır.'),
        findsWidgets,
      );
      await tester.tap(find.byTooltip('Kapat'));
      await settle(tester);
      expect(find.byKey(const ValueKey('daily-goal')), findsNothing);
      expect(find.text('15 dk'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await settle(tester);
    });

    testWidgets('ad paneli: doğrula, kaydet, başlık selamı değişir', (
      tester,
    ) async {
      await pump(tester);
      await settle(tester);
      await openSheet(tester, 'profile-name-row');
      expect(find.text('Sana nasıl seslenelim?'), findsOneWidget);
      expect(
        find.text('İsteğe bağlı. Yalnızca bu cihazda saklanır.'),
        findsOneWidget,
      );

      // Geçersiz: rakam → hata, yazılmaz, panel açık kalır.
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

      // Geçerli: kırpılır, kaydedilir, panel kapanır.
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
      expect(find.byKey(const ValueKey('profile-name')), findsNothing);
      await tester.drag(
        find.byKey(const ValueKey('profile-list')),
        const Offset(0, 3000),
      );
      await settle(tester);
      expect(find.text('Merhaba Deniz'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('profile-avatar')),
          matching: find.text('D'),
        ),
        findsOneWidget,
      );

      // Yeniden açılınca kayıtlı ad alanda; en fazla 20 karakter.
      await openSheet(tester, 'profile-name-row');
      expect(find.widgetWithText(TextField, 'Deniz'), findsOneWidget);
      final field = tester.widget<TextField>(
        find.byKey(const ValueKey('profile-name')),
      );
      expect(field.maxLength, 20);
      await tester.pumpWidget(const SizedBox());
      await settle(tester);
    });
  });
}
