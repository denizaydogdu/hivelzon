/// Günlük hatırlatma (H-013, H-042): günde en fazla 1, saati kullanıcı
/// seçer, varsayılan kapalı. Veri yalnızca cihazda (`app_meta`); eşitlenmez.
class ReminderSettings {
  const ReminderSettings({
    this.enabled = false,
    this.hour = defaultHour,
    this.minute = defaultMinute,
  }) : assert(hour >= 0 && hour < 24),
       assert(minute >= 0 && minute < 60);

  static const defaultHour = 19;
  static const defaultMinute = 0;
  static const off = ReminderSettings();

  final bool enabled;
  final int hour;
  final int minute;

  /// `19:00` biçimi (kayıt ve gösterim).
  String get timeLabel =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  ReminderSettings copyWith({bool? enabled, int? hour, int? minute}) =>
      ReminderSettings(
        enabled: enabled ?? this.enabled,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
      );

  /// `HH:mm` çözümü; geçersizse `null`.
  static (int, int)? parseTime(String? raw) {
    final m = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(raw ?? '');
    if (m == null) return null;
    final h = int.parse(m.group(1)!);
    final min = int.parse(m.group(2)!);
    if (h > 23 || min > 59) return null;
    return (h, min);
  }

  @override
  bool operator ==(Object other) =>
      other is ReminderSettings &&
      other.enabled == enabled &&
      other.hour == hour &&
      other.minute == minute;

  @override
  int get hashCode => Object.hash(enabled, hour, minute);

  @override
  String toString() => 'ReminderSettings($enabled, $timeLabel)';
}

/// Bildirim izni (işletim sistemi).
enum ReminderPermission { granted, denied, unknown }

/// Seçilen saatin bir sonraki ilk anı (yerel saatte): bugün o saat
/// geçmediyse bugün, geçtiyse yarın. Saat dilimi kaymaları için takvim
/// alanlarıyla kurulur (süre eklenmez).
DateTime nextReminderAt(DateTime nowLocal, int hour, int minute) {
  var at = DateTime(nowLocal.year, nowLocal.month, nowLocal.day, hour, minute);
  if (!at.isAfter(nowLocal)) {
    at = DateTime(
      nowLocal.year,
      nowLocal.month,
      nowLocal.day + 1,
      hour,
      minute,
    );
  }
  return at;
}
