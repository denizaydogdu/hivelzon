// H-043 (kullanıcı kararı 2): yaş bilgisi okunamazsa Keşfet güvenli tarafta
// kalır, 13–17 varsayılanı (20 dk) uygulanır. Okunabiliyorsa eski kurallar
// (K-15) aynen geçerli. Okuma hatalarında ekran sonsuz iskelette kalmaz.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/discover/application/discover_providers.dart';
import 'package:hivelzon/features/discover/data/discover_store.dart';
import 'package:hivelzon/features/discover/domain/feed.dart';
import 'package:hivelzon/features/discover/presentation/discover_screen.dart';
import 'package:hivelzon/features/onboarding/application/onboarding_providers.dart';
import 'package:hivelzon/features/onboarding/data/onboarding_store.dart';
import 'package:hivelzon/features/onboarding/domain/age.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';

import '../../support/discover_harness.dart';

class _BrokenStore extends OnboardingStore {
  _BrokenStore(super.db);

  @override
  Future<int?> adultFromYear() async => throw StateError('okunamadı');
}

class _NoResumeStore extends DiscoverStore {
  _NoResumeStore(super.db);

  @override
  Future<String?> resumeId(DateTime now) async => throw StateError('okunamadı');
}

void main() {
  group('sağlayıcı', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase.memory());
    tearDown(() => db.close());

    ProviderContainer container({OnboardingStore? store}) {
      final c = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          legacyImportProvider.overrideWithValue(Future<void>.value()),
          discoverClockProvider.overrideWithValue(() => DateTime(2026, 10, 21)),
          if (store != null) onboardingStoreProvider.overrideWithValue(store),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('yaş bilgisi okunamazsa 20 dk sınır (güvenli taraf)', () async {
      final c = container(store: _BrokenStore(db));
      final limit = await c.read(discoverLimitProvider.future);
      expect(limit.limited, isTrue);
      expect(limit.daily, kTeenDailyLimit);
      expect(limit, same(DiscoverLimit.failSafe));
    });

    test(
      'yaş hiç girilmemişse (okuma başarılı) sınır yok: K-15 aynen',
      () async {
        final c = container();
        final limit = await c.read(discoverLimitProvider.future);
        expect(limit.limited, isFalse);
      },
    );

    test('13–17 kaydı okunursa 20 dk', () async {
      await OnboardingStore(db).setAgeThresholds(2011, DateTime(2026, 10, 21));
      final c = container();
      final limit = await c.read(discoverLimitProvider.future);
      expect(limit.daily, kTeenDailyLimit);
      expect(limit.band, AgeBand.teen);
    });

    test('ekran yardımcısı: hata → güvenli sınır, yükleniyor → null', () {
      expect(
        discoverLimitOrSafe(AsyncError(StateError('x'), StackTrace.empty)),
        same(DiscoverLimit.failSafe),
      );
      expect(discoverLimitOrSafe(const AsyncLoading()), isNull);
      expect(
        discoverLimitOrSafe(const AsyncData(DiscoverLimit.none)),
        same(DiscoverLimit.none),
      );
    });
  });

  group('ekran: sonsuz iskelet yok', () {
    testWidgets('hikâye klipleri: yaş okunamazsa akış 20 dk sınırla açılır', (
      tester,
    ) async {
      final h = DiscoverHarness();
      addTearDown(h.dispose);
      await h.pump(
        tester,
        overrides: [
          onboardingStoreProvider.overrideWithValue(_BrokenStore(h.db)),
        ],
      );
      expect(find.byKey(const ValueKey('discover-loading')), findsNothing);
      expect(find.byType(DiscoverFeed), findsOneWidget);
      expect(h.feedState(tester).widget.limit.daily, kTeenDailyLimit);
      await h.unmount(tester);
    });

    testWidgets('günlük set: kalınan yer okunamazsa baştan açılır', (
      tester,
    ) async {
      final h = DiscoverHarness(
        chip: DiscoverChip.today,
        withReels: true,
        suggestedLevel: 'A1',
      );
      addTearDown(h.dispose);
      await h.pump(
        tester,
        overrides: [
          discoverStoreProvider.overrideWithValue(_NoResumeStore(h.db)),
        ],
      );
      expect(find.byKey(const ValueKey('discover-loading')), findsNothing);
      expect(find.byType(DiscoverFeed), findsOneWidget);
      expect(h.feedState(tester).index, 0);
      await h.unmount(tester);
    });
  });
}
