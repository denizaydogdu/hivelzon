import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../../l10n/tr_strings.dart';
import '../domain/daily_reminder.dart';

/// İşletim sisteminin yerel bildirimleri (H-042). Testlerde sahtesi
/// kullanılır; uygulama [LocalNotificationsReminderScheduler] kullanır.
abstract interface class ReminderScheduler {
  /// İzni sormadan okur.
  Future<ReminderPermission> permission();

  /// İzni sorar (yalnızca kullanıcı hatırlatmayı açınca). Verildi mi?
  Future<bool> requestPermission();

  /// Her gün [hour]:[minute] (cihazın yerel saati) için **tek** bildirim
  /// kurar; öncekinin yerine geçer (aynı kimlik, idempotent).
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required String title,
    required String body,
  });

  /// Kurulu hatırlatmayı kaldırır (yoksa bir şey yapmaz).
  Future<void> cancel();
}

/// `flutter_local_notifications` + `timezone` ile günlük yerel bildirim.
///
/// - Kesin alarm izni istenmez: Android'de `inexactAllowWhileIdle` (birkaç
///   dakika kayabilir; günde bir hatırlatma için yeterli).
/// - İzin açılışta sorulmaz (`DarwinInitializationSettings` istekleri
///   kapalı); yalnızca [requestPermission] çağrılınca.
/// - Saat dilimi cihazdan okunur (`tr.velzon.hivelzon/device`); okunamazsa
///   cihazın şu anki farkına göre seçilir.
class LocalNotificationsReminderScheduler implements ReminderScheduler {
  LocalNotificationsReminderScheduler({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _ready;

  /// Uygulamadaki tek hatırlatmanın kimliği.
  static const notificationId = 4201;
  static const channelId = 'daily_reminder';
  static const _device = MethodChannel('tr.velzon.hivelzon/device');

  Future<void> _init() => _ready ??= () async {
    tzdata.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }();

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  IOSFlutterLocalNotificationsPlugin? get _ios => _plugin
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >();

  @override
  Future<ReminderPermission> permission() async {
    await _init();
    if (_android case final a?) {
      final on = await a.areNotificationsEnabled();
      return on == null
          ? ReminderPermission.unknown
          : (on ? ReminderPermission.granted : ReminderPermission.denied);
    }
    if (_ios case final i?) {
      final o = await i.checkPermissions();
      if (o == null) return ReminderPermission.unknown;
      // iOS hiç sorulmamışla reddedileni ayırmaz. Bu yalnızca hatırlatma
      // açıkken (izin bir kez verilmişken) okunur: kapalıysa sonradan
      // ayarlardan kapatılmıştır.
      return o.isEnabled
          ? ReminderPermission.granted
          : ReminderPermission.denied;
    }
    return ReminderPermission.unknown;
  }

  @override
  Future<bool> requestPermission() async {
    await _init();
    if (_android case final a?) {
      return await a.requestNotificationsPermission() ?? false;
    }
    if (_ios case final i?) {
      return await i.requestPermissions(alert: true, sound: true) ?? false;
    }
    return false;
  }

  @override
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await _init();
    final location = await _localLocation();
    final now = tz.TZDateTime.now(location);
    final next = nextReminderAt(
      DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second),
      hour,
      minute,
    );
    await _plugin.cancel(id: notificationId);
    await _plugin.zonedSchedule(
      id: notificationId,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime(
        location,
        next.year,
        next.month,
        next.day,
        hour,
        minute,
      ),
      notificationDetails: NotificationDetails(
        android: const AndroidNotificationDetails(
          channelId,
          ReminderTexts.channelName,
          channelDescription: ReminderTexts.channelDescription,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: const DarwinNotificationDetails(presentBadge: false),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancel() async {
    await _init();
    await _plugin.cancel(id: notificationId);
  }

  Future<tz.Location> _localLocation() async {
    try {
      final name = await _device.invokeMethod<String>('timeZone');
      if (name != null && name.isNotEmpty) return tz.getLocation(name);
    } on Object catch (e) {
      debugPrint('[H042] saat dilimi okunamadı: ${e.runtimeType}');
    }
    return locationForOffset(DateTime.now().timeZoneOffset);
  }
}

/// Cihaz saat dilimi okunamazsa: şu anki farka uyan bir konum. Türkiye
/// (H-018) için `Europe/Istanbul`; yoksa sabit fark (`Etc/GMT-3` = UTC+3).
@visibleForTesting
tz.Location locationForOffset(Duration offset) {
  if (offset == const Duration(hours: 3)) {
    return tz.getLocation('Europe/Istanbul');
  }
  if (offset.inMinutes % 60 == 0 && offset.inHours.abs() <= 12) {
    final h = offset.inHours;
    if (h == 0) return tz.UTC;
    // IANA "Etc" adlarında işaret terstir.
    return tz.getLocation('Etc/GMT${h > 0 ? '-' : '+'}${h.abs()}');
  }
  return tz.UTC;
}
