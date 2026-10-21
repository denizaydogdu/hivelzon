import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/account/application/account_providers.dart';
import 'package:hivelzon/features/onboarding/data/onboarding_store.dart';
import 'package:hivelzon/shared/storage/app_database.dart';

/// H-095: metin sürümü değişince yeniden onay yok; cihazda bir kez bildirim.
void main() {
  late AppDatabase db;
  late LegalUpdateNotice notice;
  late OnboardingStore onboarding;

  setUp(() {
    db = AppDatabase.memory();
    notice = LegalUpdateNotice(db);
    onboarding = OnboardingStore(db);
  });
  tearDown(() => db.close());

  Future<LegalUpdate> pending(String terms, String privacy) =>
      notice.pending(termsVersion: terms, privacyVersion: privacy);

  test('açılış bitmeden bildirim yok (açılış güncel metni gösterir)', () async {
    final u = await pending('taslak-2', 'taslak-2');
    expect(u.any, isFalse);
  });

  test('açılışta okunan eski sürüm: iki metin de yeni sayılır', () async {
    await onboarding.markCompleted();
    await onboarding.setNoticeVersion('taslak-1');
    final u = await pending('taslak-2', 'taslak-2');
    expect(u.terms, isTrue);
    expect(u.privacy, isTrue);
    // Açılış sürümü güncelse bildirim yok.
    expect((await pending('taslak-1', 'taslak-1')).any, isFalse);
  });

  test(
    'H-039 öncesi kullanıcı (sürüm kaydı yok): bir kez gösterilir',
    () async {
      await onboarding.markCompleted();
      expect((await pending('taslak-2', 'taslak-2')).any, isTrue);
      await notice.markSeen(
        termsVersion: 'taslak-2',
        privacyVersion: 'taslak-2',
      );
      expect((await pending('taslak-2', 'taslak-2')).any, isFalse);
    },
  );

  test('görüldükten sonra yalnızca değişen metin yeniden bildirilir; '
      'tekrar çağrı zararsız', () async {
    await onboarding.markCompleted();
    await notice.markSeen(termsVersion: 'taslak-2', privacyVersion: 'taslak-2');
    await notice.markSeen(termsVersion: 'taslak-2', privacyVersion: 'taslak-2');
    expect((await pending('taslak-2', 'taslak-2')).any, isFalse);
    final u = await pending('taslak-2', 'surum-3');
    expect(u.terms, isFalse);
    expect(u.privacy, isTrue);
  });
}
