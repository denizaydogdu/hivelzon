// H-064: "Titreşim" ayarı ve bütün dokunsal geri bildirimin tek kapısı.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/shared/haptics/haptics.dart';
import 'package:hivelzon/shared/storage/app_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late List<String?> calls;

  setUp(() {
    db = AppDatabase.memory();
    calls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'HapticFeedback.vibrate') {
            calls.add(call.arguments as String?);
          }
          return null;
        });
  });
  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
    await db.close();
  });

  test('varsayılan açık; kapatılınca app_meta\'da kalır', () async {
    final store = HapticsStore(db);
    expect(await store.enabled(), isTrue);
    await store.setEnabled(false);
    expect(await HapticsStore(db).enabled(), isFalse);
    final row = (await db.select(db.appMeta).get()).single;
    expect(row.key, HapticsStore.enabledKey);
    expect(row.value, '0');
    await store.setEnabled(true);
    expect(await store.enabled(), isTrue);
  });

  test('açıkken tek hafif titreşim, kapalıyken hiç', () async {
    final store = HapticsStore(db);
    final haptics = Haptics(store);
    await haptics.success();
    expect(calls, ['HapticFeedbackType.lightImpact']);
    await store.setEnabled(false);
    await haptics.success();
    expect(calls, hasLength(1));
  });

  test('ayar okunamazsa sessiz geçer (hata fırlatmaz)', () async {
    final broken = Future<void>.error(StateError('veritabanı yok'))..ignore();
    final store = HapticsStore(db, ready: broken);
    await expectLater(Haptics(store).success(), completes);
    expect(calls, isEmpty);
  });

  test('HapticFeedback yalnızca Haptics içinden çağrılır', () {
    final offenders = [
      for (final f in Directory('lib').listSync(recursive: true))
        if (f is File &&
            f.path.endsWith('.dart') &&
            !f.path
                .replaceAll(r'\', '/')
                .endsWith('shared/haptics/haptics.dart') &&
            f.readAsStringSync().contains('HapticFeedback.'))
          f.path,
    ];
    expect(
      offenders,
      isEmpty,
      reason: 'Titreşim ayarına uymak için Haptics kullan',
    );
  });
}
