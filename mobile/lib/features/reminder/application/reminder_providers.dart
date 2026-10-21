import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/tr_strings.dart';
import '../../../shared/storage/storage_providers.dart';
import '../data/reminder_store.dart';
import '../domain/daily_reminder.dart';
import 'reminder_scheduler.dart';

/// Hatırlatmayı açma sonucu.
enum ReminderEnableResult { enabled, denied, failed }

/// Günlük hatırlatma kuralları (H-013, H-042):
/// - varsayılan kapalı; izin **yalnızca** kullanıcı açınca sorulur;
/// - izin verilmezse ayar kapalı kalır (sakin açıklama arayüzde);
/// - günde tek bildirim (aynı kimlik; yeniden kurmak öncekinin yerine geçer);
/// - açılışta ve uygulama öne gelince yeniden kurulur ([sync]): saat dilimi
///   değiştiyse yeni dilimde kurulur;
/// - "Bu telefondaki verileri sil" hatırlatmayı da kaldırır ([clear]).
class DailyReminderService {
  DailyReminderService({required this.store, required this.scheduler});

  final ReminderStore store;
  final ReminderScheduler scheduler;

  Future<ReminderSettings> settings() => store.read();

  Future<void> _schedule(ReminderSettings s) => scheduler.scheduleDaily(
    hour: s.hour,
    minute: s.minute,
    title: ReminderTexts.notificationTitle,
    body: ReminderTexts.notificationBody,
  );

  /// Kullanıcı açtı: izin sorulur; verilirse kaydedilir ve kurulur.
  Future<ReminderEnableResult> enable() async {
    try {
      final current = await store.read();
      var granted = await scheduler.permission() == ReminderPermission.granted;
      if (!granted) granted = await scheduler.requestPermission();
      if (!granted) return ReminderEnableResult.denied;
      final next = current.copyWith(enabled: true);
      await _schedule(next);
      await store.write(next);
      return ReminderEnableResult.enabled;
    } on Object catch (e) {
      debugPrint('[H042] hatırlatma kurulamadı: ${e.runtimeType}');
      return ReminderEnableResult.failed;
    }
  }

  /// Kullanıcı kapattı.
  Future<void> disable() async {
    final current = await store.read();
    await store.write(current.copyWith(enabled: false));
    try {
      await scheduler.cancel();
    } on Object catch (e) {
      debugPrint('[H042] hatırlatma kaldırılamadı: ${e.runtimeType}');
    }
  }

  /// Saat değişti (açıksa hemen yeni saatle kurulur).
  Future<void> setTime(int hour, int minute) async {
    final next = (await store.read()).copyWith(hour: hour, minute: minute);
    await store.write(next);
    if (!next.enabled) return;
    try {
      await _schedule(next);
    } on Object catch (e) {
      debugPrint('[H042] hatırlatma kurulamadı: ${e.runtimeType}');
    }
  }

  /// Açılışta / öne gelince: kayıtla işletim sistemini eşler (idempotent).
  /// Kapalıysa işletim sistemine hiç dokunulmaz (izin de okunmaz).
  Future<void> sync() async {
    try {
      final s = await store.read();
      if (!s.enabled) return;
      if (await scheduler.permission() == ReminderPermission.denied) return;
      await _schedule(s);
    } on Object catch (e) {
      debugPrint('[H042] hatırlatma yeniden kurulamadı: ${e.runtimeType}');
    }
  }

  /// "Bu telefondaki verileri sil": hatırlatma kaldırılır, ayar silinir.
  Future<void> clear() async {
    final was = await store.read();
    await store.clear();
    if (!was.enabled) return;
    try {
      await scheduler.cancel();
    } on Object catch (e) {
      debugPrint('[H042] hatırlatma kaldırılamadı: ${e.runtimeType}');
    }
  }
}

/// Testlerde sahte zamanlayıcıyla değiştirilir.
final reminderSchedulerProvider = Provider<ReminderScheduler>(
  (ref) => LocalNotificationsReminderScheduler(),
);

final reminderStoreProvider = Provider<ReminderStore>(
  (ref) => ReminderStore(
    ref.watch(appDatabaseProvider),
    ready: ref.watch(legacyImportProvider),
  ),
);

final dailyReminderServiceProvider = Provider<DailyReminderService>(
  (ref) => DailyReminderService(
    store: ref.watch(reminderStoreProvider),
    scheduler: ref.watch(reminderSchedulerProvider),
  ),
);

/// Profil satırının durumu: ayar + (yalnız açıkken) bildirim izni.
class ReminderView {
  const ReminderView(this.settings, {this.permission});

  final ReminderSettings settings;

  /// Açıkken okunur; kapalıyken `null` (işletim sistemine sorulmaz).
  final ReminderPermission? permission;

  bool get blocked =>
      settings.enabled && permission == ReminderPermission.denied;
}

final reminderViewProvider = FutureProvider.autoDispose<ReminderView>((
  ref,
) async {
  final service = ref.watch(dailyReminderServiceProvider);
  final s = await service.settings();
  if (!s.enabled) return ReminderView(s);
  try {
    return ReminderView(s, permission: await service.scheduler.permission());
  } on Object {
    return ReminderView(s, permission: ReminderPermission.unknown);
  }
});

/// Uygulama kökünde izlenir: açılışta ve uygulama öne gelince hatırlatma
/// kayıtla eşlenir (saat dilimi değiştiyse yeni dilimde yeniden kurulur).
/// Hatırlatma kapalıysa işletim sistemine dokunulmaz.
final reminderLifecycleProvider = Provider<void>((ref) {
  final service = ref.watch(dailyReminderServiceProvider);
  unawaited(service.sync());
  final listener = AppLifecycleListener(
    onResume: () => unawaited(service.sync()),
  );
  ref.onDispose(listener.dispose);
});
