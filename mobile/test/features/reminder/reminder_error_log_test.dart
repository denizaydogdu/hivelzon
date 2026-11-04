import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/reminder/application/reminder_providers.dart';
import 'package:hivelzon/features/reminder/application/reminder_scheduler.dart';
import 'package:hivelzon/features/reminder/data/reminder_store.dart';
import 'package:hivelzon/features/reminder/domain/daily_reminder.dart';
import 'package:hivelzon/shared/storage/app_database.dart';

import '../../support/fake_reminder_scheduler.dart';

/// H-106: günlükte yalnız tür yazıldığı için açılıştaki `ArgumentError`
/// teşhis edilemedi. Özet kısa olmalı, kişisel veri ya da hata değerini
/// içermemeli, ama hangi parametre / hangi kod yeri olduğunu söylemeli.
void main() {
  group('reminderErrorSummary', () {
    test('ArgumentError: tür + parametre adı + sabit açıklama + atıldığı yer; '
        'değer yazılmaz', () {
      Object? caught;
      StackTrace? stack;
      try {
        throw ArgumentError.value(
          'gizli-deger@example.com',
          'scheduledDate',
          'Must be a date in the future',
        );
      } on Object catch (e, st) {
        caught = e;
        stack = st;
      }
      final s = reminderErrorSummary(caught, stack);
      expect(s, startsWith('ArgumentError'));
      expect(s, contains('name=scheduledDate'));
      expect(s, contains('Must be a date in the future'));
      // Yalnız paket yolları yazılır; makinedeki dosya yolu (kullanıcı adı) yok.
      expect(s, isNot(contains('/Users/')));
      expect(s, isNot(contains('file://')));
      expect(s, isNot(contains('gizli-deger')));
      expect(s, isNot(contains('@example.com')));
    });

    test('atıldığı kütüphane yeri yazılır (kanal kodlayıcısı örneği)', () {
      Object? caught;
      StackTrace? stack;
      try {
        const StandardMessageCodec().encodeMessage(Object());
      } on Object catch (e, st) {
        caught = e;
        stack = st;
      }
      final s = reminderErrorSummary(caught!, stack);
      expect(s, startsWith('ArgumentError'));
      expect(
        s,
        contains('@ package:flutter/src/services/message_codecs.dart:'),
      );
      expect(s, isNot(contains('Instance of')));
    });

    test('başka hatalarda hata metni yazılmaz (e-posta, yol, token)', () {
      final s = reminderErrorSummary(
        StateError('kullanici@example.com /Users/x token=abc'),
      );
      expect(s, 'StateError');
    });

    test('PlatformException: yalnız kod, mesaj ve ayrıntı yazılmaz', () {
      final s = reminderErrorSummary(
        PlatformException(
          code: 'invalid_time_zone',
          message: '/private/var/mobile/kullanici',
          details: 'kullanici@example.com',
        ),
      );
      expect(s, 'PlatformException code=invalid_time_zone');
    });

    test('uzun açıklama kısaltılır (en fazla 120 karakter)', () {
      final s = reminderErrorSummary(ArgumentError('x' * 500));
      expect(s.length, lessThan(160));
    });
  });

  group('DailyReminderService günlüğü', () {
    late AppDatabase db;
    late ReminderStore store;
    late List<String> logs;
    DebugPrintCallback? original;

    setUp(() async {
      db = AppDatabase.memory();
      store = ReminderStore(db);
      await store.write(
        const ReminderSettings(enabled: true, hour: 8, minute: 30),
      );
      logs = [];
      original = debugPrint;
      debugPrint = (m, {wrapWidth}) => logs.add('$m');
    });

    tearDown(() async {
      debugPrint = original!;
      await db.close();
    });

    test('açılış eşlemesi hata verirse günlükte tür ve kısa açıklama olur; '
        'uygulama düşmez, ayar değişmez', () async {
      final scheduler = _ThrowingScheduler(
        ArgumentError.value(4201, 'id', 'must fit within 32 bits'),
      );
      final service = DailyReminderService(store: store, scheduler: scheduler);

      await service.sync();

      expect(logs, hasLength(1));
      expect(
        logs.single,
        startsWith('[H042] hatırlatma yeniden kurulamadı: ArgumentError'),
      );
      expect(logs.single, contains('name=id'));
      expect(logs.single, contains('must fit within 32 bits'));
      expect(logs.single, isNot(contains('4201')));
      expect(
        await store.read(),
        const ReminderSettings(enabled: true, hour: 8, minute: 30),
      );
    });

    test('hatırlatma kapalıysa sync işletim sistemine dokunmaz, günlük boş '
        '(simülatördeki kayıt kapalıydı)', () async {
      await store.write(const ReminderSettings());
      final scheduler = _ThrowingScheduler(ArgumentError('olmamalı'));
      await DailyReminderService(store: store, scheduler: scheduler).sync();
      expect(scheduler.calls, 0);
      expect(logs, isEmpty);
    });
  });
}

class _ThrowingScheduler extends FakeReminderScheduler {
  _ThrowingScheduler(this.error) : super(status: ReminderPermission.granted);

  final Object error;
  int calls = 0;

  @override
  Future<ReminderPermission> permission() async {
    calls++;
    return super.permission();
  }

  @override
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    calls++;
    throw error;
  }
}
