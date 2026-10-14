import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/shared/activity/active_time_meter.dart';

/// H-074: gerçek süre ölçümünün saf hesabı.
void main() {
  final t0 = DateTime(2026, 10, 14, 10);
  DateTime at(int seconds) => t0.add(Duration(seconds: seconds));
  const day = '2026-10-14';

  test('işaretler arasındaki süre sayılır; saniye altı artık kaybolmaz', () {
    final m = ActiveTimeMeter()
      ..start(at(0))
      ..signal(at(30))
      ..signal(t0.add(const Duration(seconds: 45, milliseconds: 600)));
    expect(m.takeSeconds(), {day: 45});
    // 600 ms artık bekler; sonraki 400 ms ile tam saniye olur.
    m.stop(t0.add(const Duration(seconds: 46)));
    expect(m.takeSeconds(), {day: 1});
    expect(m.pendingMs, 0);
  });

  test('uzun süre dokunulmadıysa en çok 2 dk sayılır', () {
    final m = ActiveTimeMeter()
      ..start(at(0))
      ..signal(at(10 * 60)); // 10 dk sessizlik
    expect(m.takeSeconds(), {day: 120});
  });

  test('arka planda geçen süre sayılmaz', () {
    final m = ActiveTimeMeter()
      ..start(at(0))
      ..stop(at(20)) // uygulama arka plana geçti
      ..signal(at(300)) // durmuşken gelen işaret bir şey saymaz
      ..start(at(600)) // ön plana döndü
      ..signal(at(640));
    expect(m.takeSeconds(), {day: 60});
  });

  test('saat geri alınırsa aralık sayılmaz', () {
    final m = ActiveTimeMeter()
      ..start(at(100))
      ..signal(at(50))
      ..signal(at(60));
    expect(m.takeSeconds(), {day: 10});
  });

  test('gece yarısını aşan süre iki güne bölünür', () {
    final m = ActiveTimeMeter()
      ..start(DateTime(2026, 10, 14, 23, 59, 30))
      ..signal(DateTime(2026, 10, 15, 0, 0, 20));
    expect(m.takeSeconds(), {'2026-10-14': 30, '2026-10-15': 20});
  });

  test('yazılamayan süre geri konur', () {
    final m = ActiveTimeMeter()
      ..start(at(0))
      ..signal(at(40));
    final s = m.takeSeconds();
    m.restore(s);
    expect(m.takeSeconds(), {day: 40});
  });

  test('yerel gün anahtarı', () {
    expect(localDayKey(DateTime(2026, 1, 5, 23, 59)), '2026-01-05');
  });
}
