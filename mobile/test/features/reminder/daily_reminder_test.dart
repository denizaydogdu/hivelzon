import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/reminder/application/reminder_providers.dart';
import 'package:hivelzon/features/reminder/application/reminder_scheduler.dart';
import 'package:hivelzon/features/reminder/data/reminder_store.dart';
import 'package:hivelzon/features/reminder/domain/daily_reminder.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import '../../support/fake_reminder_scheduler.dart';

void main() {
  group('nextReminderAt', () {
    test('saat geçmediyse bugün, geçtiyse ya da tam o andaysa yarın', () {
      final now = DateTime(2026, 10, 21, 18, 30);
      expect(nextReminderAt(now, 19, 0), DateTime(2026, 10, 21, 19));
      expect(nextReminderAt(now, 18, 30), DateTime(2026, 10, 22, 18, 30));
      expect(nextReminderAt(now, 8, 15), DateTime(2026, 10, 22, 8, 15));
    });

    test('ay ve yıl sonu', () {
      expect(
        nextReminderAt(DateTime(2026, 12, 31, 23, 0), 7, 0),
        DateTime(2027, 1, 1, 7),
      );
    });
  });

  group('ReminderSettings', () {
    test('saat biçimi ve çözümü', () {
      expect(const ReminderSettings(hour: 7, minute: 5).timeLabel, '07:05');
      expect(ReminderSettings.parseTime('19:00'), (19, 0));
      expect(ReminderSettings.parseTime('7:30'), (7, 30));
      expect(ReminderSettings.parseTime('24:00'), isNull);
      expect(ReminderSettings.parseTime('12:60'), isNull);
      expect(ReminderSettings.parseTime('x'), isNull);
      expect(ReminderSettings.parseTime(null), isNull);
    });

    test('varsayılan: kapalı, 19:00', () {
      expect(ReminderSettings.off.enabled, isFalse);
      expect(ReminderSettings.off.timeLabel, '19:00');
    });
  });

  group('saat dilimi yedeği', () {
    setUpAll(tzdata.initializeTimeZones);

    test('UTC+3 → Europe/Istanbul; tam saatler Etc; öteki UTC', () {
      expect(
        locationForOffset(const Duration(hours: 3)).name,
        'Europe/Istanbul',
      );
      expect(locationForOffset(const Duration(hours: 1)).name, 'Etc/GMT-1');
      expect(locationForOffset(const Duration(hours: -5)).name, 'Etc/GMT+5');
      // Fark yoksa ya da tam saat değilse UTC (adı `UTC` / `Etc/UTC`).
      for (final o in [Duration.zero, const Duration(hours: 5, minutes: 30)]) {
        final l = locationForOffset(o);
        expect(
          l.currentTimeZone.offset,
          Duration.zero,
          reason: '$o → ${l.name}',
        );
      }
    });
  });

  group('DailyReminderService', () {
    late AppDatabase db;
    late FakeReminderScheduler os;
    late DailyReminderService service;

    setUp(() {
      db = AppDatabase.memory();
      os = FakeReminderScheduler();
      service = DailyReminderService(store: ReminderStore(db), scheduler: os);
    });
    tearDown(() => db.close());

    test('varsayılan kapalı: açılışta işletim sistemine dokunulmaz', () async {
      expect(await service.settings(), ReminderSettings.off);
      await service.sync();
      expect(os.permissionReads, 0);
      expect(os.permissionRequests, 0);
      expect(os.scheduleCalls, 0);
      expect(os.cancelCalls, 0);
    });

    test(
      'açınca izin sorulur; verilirse günde tek hatırlatma kurulur',
      () async {
        expect(await service.enable(), ReminderEnableResult.enabled);
        expect(os.permissionRequests, 1);
        expect(os.scheduled, (
          19,
          0,
          ReminderTexts.notificationTitle,
          ReminderTexts.notificationBody,
        ));
        expect((await service.settings()).enabled, isTrue);
      },
    );

    test('izin zaten varsa yeniden sorulmaz', () async {
      os.status = ReminderPermission.granted;
      await service.enable();
      expect(os.permissionRequests, 0);
      expect(os.scheduled, isNotNull);
    });

    test('izin verilmezse ayar kapalı kalır, hiçbir şey kurulmaz', () async {
      os.grantOnRequest = false;
      expect(await service.enable(), ReminderEnableResult.denied);
      expect(os.scheduled, isNull);
      expect((await service.settings()).enabled, isFalse);
    });

    test('saat değişince yeniden kurulur (öncekinin yerine)', () async {
      await service.enable();
      await service.setTime(8, 30);
      expect(os.scheduled?.$1, 8);
      expect(os.scheduled?.$2, 30);
      expect((await service.settings()).timeLabel, '08:30');
    });

    test('kapalıyken saat değişirse yalnız kaydedilir', () async {
      await service.setTime(7, 0);
      expect(os.scheduleCalls, 0);
      expect((await service.settings()).timeLabel, '07:00');
      expect((await service.settings()).enabled, isFalse);
    });

    test('kapatınca kaldırılır; saat hatırlanır', () async {
      await service.enable();
      await service.setTime(21, 15);
      await service.disable();
      expect(os.scheduled, isNull);
      final s = await service.settings();
      expect(s.enabled, isFalse);
      expect(s.timeLabel, '21:15');
    });

    test('açılışta yeniden kurulur (idempotent: tek hatırlatma)', () async {
      await service.enable();
      os.scheduled = null;
      await service.sync();
      await service.sync();
      expect(os.scheduled?.$1, 19);
      expect(os.scheduleCalls, 3);
    });

    test(
      'izin sonradan kapatıldıysa açılışta kurulmaz, ayar korunur',
      () async {
        await service.enable();
        os.status = ReminderPermission.denied;
        final before = os.scheduleCalls;
        await service.sync();
        expect(os.scheduleCalls, before);
        expect((await service.settings()).enabled, isTrue);
      },
    );

    test(
      '"Bu telefondaki verileri sil": kaldırılır, ayar varsayılana döner',
      () async {
        await service.enable();
        await service.setTime(6, 45);
        await service.clear();
        expect(os.scheduled, isNull);
        expect(await service.settings(), ReminderSettings.off);
        final keys = (await db.select(db.appMeta).get()).map((r) => r.key);
        expect(keys, isNot(contains(ReminderStore.enabledKey)));
        expect(keys, isNot(contains(ReminderStore.timeKey)));
      },
    );

    test('ayar yalnızca cihazda: app_meta, iki anahtar', () async {
      await service.enable();
      final rows = {
        for (final r in await db.select(db.appMeta).get()) r.key: r.value,
      };
      expect(rows[ReminderStore.enabledKey], '1');
      expect(rows[ReminderStore.timeKey], '19:00');
    });
  });

  test('bildirim metni sakin: suçlama, geri sayım ve hikâye ayrıntısı yok', () {
    final text =
        '${ReminderTexts.notificationTitle} ${ReminderTexts.notificationBody}'
            .toLowerCase();
    for (final banned in [
      'kaçır',
      'özle',
      'kaybet',
      'seri',
      'son şans',
      'acele',
      'bekliyor',
      'alex',
      'maya',
      'sinyal',
      '!',
    ]) {
      expect(text.contains(banned), isFalse, reason: banned);
    }
  });
}
