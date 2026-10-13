import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Performans ölçüm günlüğü (H-054). Yalnızca debug ve profile derlemede
/// çalışır; yayın derlemesinde hiçbir şey yazmaz ve kare dinleyicisi kurmaz.
///
/// Satırlar `[H054]` ile başlar (simülatörde `log stream` ile toplanır):
/// - `başlangıç main=<epoch ms>`: Dart `main()` anı (duvar saati).
/// - `ilk kare <ms> (epoch …)`: `main()` → ilk karenin ekrana çizilmesi.
/// - `<olay> <ms>`: `main()`'den bu yana ([mark]) ya da bir kronometreyle.
/// - `sıcak açılış ilk kare <ms>`: ön plana dönüş → ilk yeni kare.
/// - `kare <etiket> n=… derleme ort/p90/en çok … çizim …`: [FrameStats]
///   etkin ekrandaki kare süreleri (`FrameTiming`), 2 sn'de bir özet.
abstract final class PerfLog {
  static bool get enabled => !kReleaseMode;

  static final Stopwatch _sinceMain = Stopwatch();
  static int _mainEpochMs = 0;
  static final Set<String> _once = {};

  /// `main()` başında çağrılır.
  static void start() {
    if (!enabled) return;
    _sinceMain.start();
    _mainEpochMs = DateTime.now().millisecondsSinceEpoch;
    debugPrint('[H054] başlangıç main=$_mainEpochMs');
    final binding = WidgetsFlutterBinding.ensureInitialized();
    binding.waitUntilFirstFrameRasterized.then((_) {
      final now = DateTime.now().millisecondsSinceEpoch;
      debugPrint(
        '[H054] ilk kare ${_sinceMain.elapsedMilliseconds} ms (epoch $now)',
      );
    });
    SchedulerBinding.instance.addTimingsCallback(FrameStats._onTimings);
    // Sıcak açılış: arka plandan dönüş → ilk yeni kare.
    _lifecycle = AppLifecycleListener(
      onResume: () {
        final t0 = DateTime.now().millisecondsSinceEpoch;
        debugPrint('[H054] ön plana döndü (epoch $t0)');
        SchedulerBinding.instance.addPostFrameCallback((_) {
          final now = DateTime.now().millisecondsSinceEpoch;
          debugPrint(
            '[H054] sıcak açılış ilk kare ${now - t0} ms (epoch $now)',
          );
        });
        SchedulerBinding.instance.scheduleFrame();
      },
    );
  }

  // ignore: unused_field
  static AppLifecycleListener? _lifecycle;

  /// `main()`'den bu yana geçen süreyle bir olay yazar ([once]: yalnızca ilk kez).
  static void mark(String event, {bool once = true}) {
    if (!enabled) return;
    if (once && !_once.add(event)) return;
    _print(event);
  }

  static void _print(String event) {
    debugPrint(
      '[H054] $event ${_sinceMain.elapsedMilliseconds} ms '
      '(epoch ${DateTime.now().millisecondsSinceEpoch})',
    );
  }

  /// Bu kare derlendikten hemen sonra [mark] (yalnızca ilk kez).
  static void markAfterFrame(String event) {
    if (!enabled || !_once.add(event)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => _print(event));
  }

  /// Kronometreli tek ölçüm (ör. bölüm açılışı → başlık videosunun ilk karesi).
  static void duration(String event, Duration d) {
    if (!enabled) return;
    debugPrint('[H054] $event ${d.inMilliseconds} ms');
  }
}

/// Kaydırma sırasındaki kare sürelerini toplar ([PerfScope] etiketler).
abstract final class FrameStats {
  static String? _tag;
  static final List<FrameTiming> _buf = [];
  static DateTime _flushAt = DateTime.now();

  static bool _ending = false;

  static void _onTimings(List<FrameTiming> timings) {
    final tag = _tag;
    if (tag == null) return;
    _buf.addAll(timings);
    if (_ending) {
      // Kaydırma bitti: son kareler de geldi (debug/profile'da en geç ~100 ms).
      _ending = false;
      flush();
      _tag = null;
    } else if (DateTime.now().difference(_flushAt) >=
        const Duration(seconds: 2)) {
      flush();
    }
  }

  static void _setTag(String? tag) {
    if (_tag != null && _tag != tag) flush();
    if (_tag != tag) _flushAt = DateTime.now();
    _tag = tag;
  }

  /// Toplanan kareleri özetler ve yazar.
  static void flush() {
    final tag = _tag;
    _flushAt = DateTime.now();
    if (tag == null || _buf.isEmpty) {
      _buf.clear();
      return;
    }
    final build = [for (final t in _buf) t.buildDuration.inMicroseconds / 1000];
    final raster = [
      for (final t in _buf) t.rasterDuration.inMicroseconds / 1000,
    ];
    final total = [for (final t in _buf) t.totalSpan.inMicroseconds / 1000];
    const budget = 1000 / 60;
    final slow = [
      for (var i = 0; i < _buf.length; i++)
        if (build[i] > budget || raster[i] > budget) i,
    ].length;
    debugPrint(
      '[H054] kare $tag n=${_buf.length} '
      'derleme ort ${_avg(build)} p90 ${_p90(build)} en çok ${_max(build)} ms; '
      'çizim ort ${_avg(raster)} p90 ${_p90(raster)} en çok ${_max(raster)} ms; '
      'toplam p90 ${_p90(total)} ms; 16,7 ms üstü $slow',
    );
    _buf.clear();
  }

  static String _avg(List<double> v) =>
      (v.reduce((a, b) => a + b) / v.length).toStringAsFixed(1);
  static String _max(List<double> v) => v.reduce(math.max).toStringAsFixed(1);
  static String _p90(List<double> v) {
    final s = [...v]..sort();
    return s[((s.length - 1) * 0.9).round()].toStringAsFixed(1);
  }
}

/// Altındaki kaydırılabilir alanın kaydırma karelerini [tag] ile etiketler
/// (yalnızca debug/profile). Kaydırma başlayınca toplama başlar; bitince
/// sonraki kare grubu geldiğinde özet yazılır (zamanlayıcı kurulmaz).
class PerfScope extends StatelessWidget {
  const PerfScope({super.key, required this.tag, required this.child});

  final String tag;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!PerfLog.enabled) return child;
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n is ScrollStartNotification || n is ScrollUpdateNotification) {
          FrameStats._ending = false;
          FrameStats._setTag(tag);
        } else if (n is ScrollEndNotification && FrameStats._tag == tag) {
          FrameStats._ending = true;
        }
        return false;
      },
      child: child,
    );
  }
}
