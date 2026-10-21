import 'package:hivelzon/features/reminder/application/reminder_scheduler.dart';
import 'package:hivelzon/features/reminder/domain/daily_reminder.dart';

/// İşletim sistemi bildirimlerinin bellek içi kopyası (H-042).
class FakeReminderScheduler implements ReminderScheduler {
  FakeReminderScheduler({
    this.status = ReminderPermission.unknown,
    this.grantOnRequest = true,
  });

  ReminderPermission status;
  bool grantOnRequest;

  int permissionRequests = 0;
  int permissionReads = 0;

  /// Kurulu tek hatırlatma: (saat, dakika, başlık, metin); yoksa `null`.
  (int, int, String, String)? scheduled;
  int scheduleCalls = 0;
  int cancelCalls = 0;

  @override
  Future<ReminderPermission> permission() async {
    permissionReads++;
    return status;
  }

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    status = grantOnRequest
        ? ReminderPermission.granted
        : ReminderPermission.denied;
    return grantOnRequest;
  }

  @override
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    scheduleCalls++;
    scheduled = (hour, minute, title, body);
  }

  @override
  Future<void> cancel() async {
    cancelCalls++;
    scheduled = null;
  }
}
