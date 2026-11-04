import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/reminder/application/reminder_scheduler.dart';
import 'package:hivelzon/features/reminder/domain/daily_reminder.dart';

/// H-106 kanıtı: gerçek [LocalNotificationsReminderScheduler] iOS yolunda
/// (eklentinin Dart tarafı gerçek, yalnız yerel kanal sahte) Dart tarafında
/// `ArgumentError` atmaz. Eklentinin `ArgumentError` kaynakları: kimlik 32 bit
/// dışı (4201 değil), `matchDateTimeComponents` yokken geçmiş tarih (burada
/// `time` verilir) ve kanal kodlayıcısında desteklenmeyen tür.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pluginChannel = MethodChannel(
    'dexterous.com/flutter/local_notifications',
  );
  const deviceChannel = MethodChannel('tr.velzon.hivelzon/device');
  late List<MethodCall> calls;
  late Object? deviceTimeZone;

  TestDefaultBinaryMessenger messenger() =>
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    IOSFlutterLocalNotificationsPlugin.registerWith();
    calls = [];
    deviceTimeZone = 'Europe/Istanbul';
    messenger().setMockMethodCallHandler(pluginChannel, (c) async {
      calls.add(c);
      if (c.method == 'checkPermissions') {
        return <String, Object>{'isEnabled': true};
      }
      return true;
    });
    messenger().setMockMethodCallHandler(deviceChannel, (c) async {
      if (deviceTimeZone case final Exception e) throw e;
      return deviceTimeZone;
    });
  });

  tearDown(() {
    messenger().setMockMethodCallHandler(pluginChannel, null);
    messenger().setMockMethodCallHandler(deviceChannel, null);
    debugDefaultTargetPlatformOverride = null;
  });

  test('iOS: günlük hatırlatma tek kimlikle, her gün aynı saatte, cihaz '
      'diliminde kurulur', () async {
    final s = LocalNotificationsReminderScheduler();
    expect(await s.permission(), ReminderPermission.granted);
    await s.scheduleDaily(hour: 19, minute: 0, title: 't', body: 'b');

    expect(calls.map((c) => c.method), [
      'initialize',
      'checkPermissions',
      'cancel',
      'zonedSchedule',
    ]);
    final args = calls.last.arguments as Map<Object?, Object?>;
    expect(args['id'], LocalNotificationsReminderScheduler.notificationId);
    expect(args['timeZoneName'], 'Europe/Istanbul');
    expect(args['matchDateTimeComponents'], DateTimeComponents.time.index);
    expect(args['scheduledDateTime'] as String, endsWith('T19:00:00'));
  });

  test('iOS: cihaz dilimi tanınmazsa ya da okunamazsa yedek dilimle '
      'kurulur, hata atılmaz', () async {
    for (final zone in <Object?>[
      'GMT+0300',
      '',
      null,
      PlatformException(code: 'x'),
    ]) {
      calls.clear();
      deviceTimeZone = zone;
      final s = LocalNotificationsReminderScheduler();
      await s.scheduleDaily(hour: 7, minute: 5, title: 't', body: 'b');
      final args = calls.last.arguments as Map<Object?, Object?>;
      expect(calls.last.method, 'zonedSchedule', reason: '$zone');
      expect(args['timeZoneName'], isNotEmpty, reason: '$zone');
    }
  });
}
