import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/router.dart';
import 'package:hivelzon/features/onboarding/application/onboarding_providers.dart';
import 'package:hivelzon/features/onboarding/data/onboarding_store.dart';
import 'package:hivelzon/features/onboarding/domain/age.dart';
import 'package:hivelzon/features/onboarding/domain/placement.dart';
import 'package:hivelzon/features/onboarding/presentation/onboarding_screen.dart';
import 'package:hivelzon/shared/storage/app_database.dart';

import '../../support/placement.dart';

/// Motoru sonuna kadar oynatır: [correct] seviyeleri doğru, ötekiler
/// "Bilmiyorum". Sorulan soru sayısını döner.
int run(PlacementEngine e, bool Function(CefrLevel level, int i) correct) {
  var i = 0;
  while (!e.finished) {
    final item = e.current!;
    final ok = e.inWarmup || correct(e.level, i);
    e.answer(ok ? item.answer : null);
    i++;
    if (i > 100) fail('test bitmedi');
  }
  return e.asked;
}

void main() {
  group('soru havuzu (onaylı)', () {
    test('uygulama içindeki dosya okunur, her seviyede en az 4 madde', () {
      final bank = loadBank();
      expect(
        bank.draft,
        isFalse,
        reason: 'Kullanıcı onayladı (H-039, 2026-10-14)',
      );
      expect(bank.maxQuestions, 20);
      for (final l in CefrLevel.values) {
        expect(bank.stages[l]!.length, greaterThanOrEqualTo(4));
      }
      final ids = {
        for (final i in [
          ...bank.warmup,
          for (final s in bank.stages.values) ...s,
        ])
          i.id,
      };
      expect(ids.length, bank.warmup.length + 5 * 4, reason: 'kimlik tekil');
    });

    test('asset paketinden de yüklenir', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final raw = await rootBundle.loadString(placementBankAsset);
      expect(jsonDecode(raw), isA<Map<String, dynamic>>());
    });

    test('doğru seçenekler tek bir sıraya yığılmaz (ezberlenmez)', () {
      final bank = loadBank();
      final answers = {
        for (final s in bank.stages.values)
          for (final i in s) i.answer,
      };
      expect(answers.length, greaterThan(1));
    });
  });

  group('kademeli motor (K-06)', () {
    final bank = loadBank();

    test('her şey doğru → C1, en fazla 20 soru', () {
      final e = PlacementEngine(bank);
      final n = run(e, (_, _) => true);
      expect(e.result, CefrLevel.c1);
      expect(n, 20);
    });

    test('"Bilmiyorum" ile → A1, 4 soruda biter', () {
      final e = PlacementEngine(bank);
      final n = run(e, (_, _) => false);
      expect(e.result, CefrLevel.a1);
      expect(n, 4);
    });

    test('A1 ve A2 geçer, B1 de 2 doğru → B1', () {
      final e = PlacementEngine(bank);
      var b1 = 0;
      run(e, (level, _) {
        if (level.index < CefrLevel.b1.index) return true;
        if (level == CefrLevel.b1) return b1++ < 2;
        return false;
      });
      expect(e.result, CefrLevel.b1);
    });

    test('A2 geçer, B1 0–1 doğru → bir alt basamak (A2)', () {
      final e = PlacementEngine(bank);
      run(e, (level, _) => level.index <= CefrLevel.a2.index);
      expect(e.result, CefrLevel.a2);
    });

    test('kendi tahmini B2: önce 2 ısınma sorusu, sonra B2', () {
      final e = PlacementEngine(bank, selfLevel: CefrLevel.b2);
      expect(e.inWarmup, isTrue);
      e.answer(e.current!.answer);
      e.answer(null); // ısınma sayılmaz
      expect(e.inWarmup, isFalse);
      expect(e.level, CefrLevel.b2);
      final n = run(e, (_, _) => false);
      expect(e.result, CefrLevel.b1);
      expect(n, 6);
    });

    test('hiçbir yolda 20 sorudan fazla sorulmaz', () {
      for (final start in [null, ...CefrLevel.values]) {
        final e = PlacementEngine(bank, selfLevel: start);
        expect(run(e, (_, _) => true), lessThanOrEqualTo(20));
      }
    });
  });

  group('yaş (H-002)', () {
    final now = DateTime.utc(2026, 10, 14);

    test('takvim yılına göre: 13 altı, 13–17, 18+', () {
      expect(ageBandOf(2014, now), AgeBand.under13);
      expect(ageBandOf(2013, now), AgeBand.teen);
      expect(ageBandOf(2009, now), AgeBand.teen);
      expect(ageBandOf(2008, now), AgeBand.adult);
    });

    test('doğum yılı denetimi', () {
      expect(validateBirthYear('', now), BirthYearError.empty);
      expect(validateBirthYear('08', now), BirthYearError.format);
      expect(validateBirthYear('20a8', now), BirthYearError.format);
      expect(validateBirthYear('2027', now), BirthYearError.outOfRange);
      expect(validateBirthYear('1890', now), BirthYearError.outOfRange);
      expect(validateBirthYear(' 2008 ', now), isNull);
    });
  });

  group('kayıt (app_meta)', () {
    late AppDatabase db;
    late OnboardingStore store;
    setUp(() {
      db = AppDatabase.memory();
      store = OnboardingStore(db, clock: () => DateTime.utc(2026, 10, 14));
    });
    tearDown(() => db.close());

    test('yeni cihaz: açılış gerekir; bitince bir daha gerekmez', () async {
      expect(await store.needsOnboarding(), isTrue);
      await store.markCompleted();
      expect(await store.needsOnboarding(), isFalse);
    });

    test('ilk bitiş anı kalır (tekrar çağrı üzerine yazmaz)', () async {
      await store.markCompleted();
      final later = OnboardingStore(db, clock: () => DateTime.utc(2027, 1, 1));
      await later.markCompleted();
      final row = await (db.select(
        db.appMeta,
      )..where((t) => t.key.equals(OnboardingStore.completedKey))).getSingle();
      expect(row.value, startsWith('2026-10-14'));
    });

    test('önceden ilerleme varsa açılış atlanır ve işaretlenir', () async {
      await db
          .into(db.userStoryProgress)
          .insert(
            UserStoryProgressCompanion.insert(
              contentId: 'A1-001',
              updatedAt: DateTime.utc(2026, 10, 1),
            ),
          );
      expect(await store.needsOnboarding(), isFalse);
      await db.delete(db.userStoryProgress).go();
      // İşaret yazıldı: ilerleme silinse de açılış geri gelmez.
      expect(await store.needsOnboarding(), isFalse);
    });

    test('Profil\'de ad ya da günlük hedef varsa da eski kullanıcı', () async {
      await db
          .into(db.appMeta)
          .insert(
            AppMetaCompanion.insert(
              key: 'settings.dailyGoalMinutes',
              value: '15',
            ),
          );
      expect(await store.hasExistingUsage(), isTrue);
    });

    test('yeniden göster (reset) yalnızca işareti siler', () async {
      await store.setAgeThresholds(2012, DateTime.utc(2026, 10, 14));
      await store.markCompleted();
      await store.reset();
      expect(await store.needsOnboarding(), isTrue);
      expect(await store.adultFromYear(), 2030);
    });

    test('doğum yılı saklanmaz; yalnızca geçmemiş 18 eşiği kalır', () async {
      final now = DateTime.utc(2026, 10, 14);
      Future<String?> raw(String k) async => (await (db.select(
        db.appMeta,
      )..where((t) => t.key.equals(k))).getSingleOrNull())?.value;

      await db
          .into(db.appMeta)
          .insert(
            AppMetaCompanion.insert(
              key: OnboardingStore.legacyBirthYearKey,
              value: '2010',
            ),
          );
      await store.setAgeThresholds(2010, now); // 16 yaş
      expect(await store.adultFromYear(), 2028);
      expect(await raw(OnboardingStore.legacyBirthYearKey), isNull);

      await store.setAgeThresholds(1990, now); // yetişkin: yaş kaydı yok
      expect(await store.adultFromYear(), isNull);
      await store.setAgeThresholds(1990, now); // idempotent
      expect(await store.adultFromYear(), isNull);
    });
  });

  group('yönlendirme', () {
    test('açılış bitmeden her yol /acilis; istenen yer saklanır', () {
      expect(
        onboardingRedirect(OnboardingGate.needed, Uri.parse('/')),
        AppRoutes.onboarding,
      );
      expect(
        onboardingRedirect(OnboardingGate.checking, Uri.parse('/profil')),
        '/acilis?sonra=%2Fprofil',
      );
      expect(
        onboardingRedirect(OnboardingGate.needed, Uri.parse('/acilis')),
        isNull,
      );
      expect(
        onboardingRedirect(
          OnboardingGate.needed,
          Uri.parse('/acilis/metin/kosullar'),
        ),
        isNull,
      );
    });

    test('bittikten sonra /acilis istenen yere ya da Ana Sayfa\'ya', () {
      expect(
        onboardingRedirect(OnboardingGate.done, Uri.parse('/acilis')),
        AppRoutes.home,
      );
      expect(
        onboardingRedirect(
          OnboardingGate.done,
          Uri.parse('/acilis?sonra=%2Fprofil'),
        ),
        '/profil',
      );
      expect(
        onboardingRedirect(
          OnboardingGate.done,
          Uri.parse('/acilis?sonra=https%3A%2F%2Fx.y'),
        ),
        AppRoutes.home,
      );
      expect(onboardingRedirect(OnboardingGate.done, Uri.parse('/')), isNull);
      // Debug derlemede yeniden sınamak için.
      expect(
        onboardingRedirect(OnboardingGate.done, Uri.parse('/acilis?yeniden=1')),
        isNull,
      );
    });
  });
}
