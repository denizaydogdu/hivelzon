import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/shared/activity/active_time_meter.dart';
import 'package:hivelzon/shared/activity/daily_activity_store.dart';
import 'package:hivelzon/shared/activity/study_clock.dart';
import 'package:hivelzon/shared/storage/app_database.dart';

/// H-074: tek ölçüm saati ve öğrenme ekranı kapsamı.
void main() {
  late AppDatabase db;
  late DailyActivityStore store;
  late DateTime now;
  final t0 = DateTime(2026, 10, 14, 10);
  final day = localDayKey(t0);

  setUp(() {
    db = AppDatabase.memory();
    store = DailyActivityStore(db);
    now = t0;
  });
  tearDown(() => db.close());

  StudyClock newClock() => StudyClock(store, clock: () => now);

  void wait(int seconds) => now = now.add(Duration(seconds: seconds));

  test('ekran açık ve ön plandayken sayılır; arka planda sayılmaz', () async {
    final clock = newClock();
    addTearDown(clock.dispose);
    var notified = 0;
    clock
      ..addListener(() => notified++)
      ..enter();
    wait(20);
    clock.signal();
    wait(10);
    clock.setForeground(false); // arka plan: 30 sn yazılır
    await clock.flush();
    expect(await store.secondsOn(day), 30);
    expect(notified, 1);

    wait(15 * 60); // arka planda 15 dk
    clock.setForeground(true);
    wait(25);
    clock.leave(); // ekran kapandı
    await clock.flush();
    expect(await store.secondsOn(day), 55);
    expect(await store.measuredSince(), t0.toUtc());
  });

  test('iç içe ekranlar süreyi iki kez saymaz', () async {
    final clock = newClock();
    addTearDown(clock.dispose);
    clock.enter(); // konu seti
    wait(10);
    clock.enter(); // sahne avı
    wait(20);
    clock.leave();
    wait(5);
    clock.signal();
    clock.leave();
    await clock.flush();
    expect(await store.secondsOn(day), 35);
  });

  test('açık ekranda biriken süre ara ara yazılır', () async {
    final clock = newClock();
    addTearDown(clock.dispose);
    clock.enter();
    for (var i = 0; i < 4; i++) {
      wait(10);
      clock.signal();
    }
    await clock.flush(); // sıradaki yazmayı bekler
    // 40 sn ≥ 30 sn: ekran kapanmadan yazıldı.
    expect(await store.secondsOn(day), 40);
    expect(clock.running, isTrue);
  });

  test('aynı gün iki kaynak toplanır; bir günde en çok 24 saat', () async {
    await store.addSeconds({day: 100}, t0);
    await db.customStatement(
      "INSERT INTO daily_activity (day, source_id, active_seconds, updated_at) "
      "VALUES ('$day', 'other-device', 50, '2026-10-14T08:00:00.000Z')",
    );
    expect(await store.secondsOn(day), 150);
    await store.addSeconds({day: 90000}, t0);
    expect(await store.secondsOn(day), 86400 + 50);
    expect(await store.secondsOn('2026-10-13'), 0);
  });

  testWidgets('StudyTimeScope: açılınca başlar, dokunma işarettir, uygulama '
      'arka plana geçince ve ekran kapanınca durur', (tester) async {
    // Saat sahte zamanda çalışır: veritabanı yerine bellekteki kayıt.
    final mem = _MemoryStore(db);
    final clock = StudyClock(mem, clock: () => now);
    addTearDown(clock.dispose);
    final show = ValueNotifier(true);
    addTearDown(show.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [studyClockProvider.overrideWithValue(clock)],
        child: MaterialApp(
          home: ValueListenableBuilder<bool>(
            valueListenable: show,
            builder: (_, on, _) => on
                ? const StudyTimeScope(
                    child: Scaffold(body: Center(child: Text('ekran'))),
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
    expect(clock.running, isTrue);
    wait(40);
    await tester.tap(find.text('ekran'));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    expect(clock.running, isFalse);
    wait(600);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    expect(clock.running, isTrue);
    wait(15);
    show.value = false;
    await tester.pump();
    expect(clock.running, isFalse);
    await clock.flush();
    expect(mem.seconds, {day: 55});
  });
}

class _MemoryStore extends DailyActivityStore {
  _MemoryStore(super.db);

  final seconds = <String, int>{};

  @override
  Future<void> markMeasuredSince(DateTime at) async {}

  @override
  Future<void> addSeconds(Map<String, int> secondsByDay, DateTime now) async {
    secondsByDay.forEach((d, s) => seconds[d] = (seconds[d] ?? 0) + s);
  }
}
