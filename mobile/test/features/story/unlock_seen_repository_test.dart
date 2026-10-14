import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/story/data/unlock_seen_repository.dart';
import 'package:hivelzon/shared/storage/app_database.dart';

/// H-060: açılan bölümün "görüldü" işareti cihazda (`app_meta`), idempotent.
void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.memory());
  tearDown(() => db.close());

  Future<Map<String, String>> meta() async => {
    for (final r in await db.select(db.appMeta).get()) r.key: r.value,
  };

  test('ilk çağrı görülmemişleri döndürür ve işaretler; ikinci çağrı boş, '
      'tarih değişmez', () async {
    var now = DateTime.utc(2026, 10, 14, 9);
    final repo = DriftUnlockSeenRepository(db, clock: () => now);
    expect(await repo.claimUnseen(['A1-001', 'A1-002']), {'A1-001', 'A1-002'});
    final first = await meta();
    expect(first.keys, {'story.unlockSeen.A1-001', 'story.unlockSeen.A1-002'});
    expect(first['story.unlockSeen.A1-002'], now.toIso8601String());

    now = now.add(const Duration(days: 1));
    expect(await repo.claimUnseen(['A1-001', 'A1-002']), isEmpty);
    // Yeni bölüm açılınca yalnız o döner; eski işaretler aynı kalır.
    expect(await repo.claimUnseen(['A1-001', 'A1-002', 'A1-003']), {'A1-003'});
    final second = await meta();
    expect(second['story.unlockSeen.A1-002'], first['story.unlockSeen.A1-002']);
    expect(second['story.unlockSeen.A1-003'], now.toIso8601String());
  });

  test('aynı anda iki çağrı: bölüm yalnızca bir kez "yeni" sayılır', () async {
    final repo = DriftUnlockSeenRepository(db);
    final results = await Future.wait([
      repo.claimUnseen(['A1-002']),
      repo.claimUnseen(['A1-002']),
    ]);
    expect(results.where((r) => r.contains('A1-002')).length, 1);
  });

  test('boş liste: veritabanına dokunmaz', () async {
    final repo = DriftUnlockSeenRepository(db);
    expect(await repo.claimUnseen(const []), isEmpty);
    expect(await meta(), isEmpty);
  });
}
