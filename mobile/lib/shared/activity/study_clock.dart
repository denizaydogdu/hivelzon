import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/storage_providers.dart';
import 'active_time_meter.dart';
import 'daily_activity_store.dart';

final dailyActivityStoreProvider = Provider<DailyActivityStore>(
  (ref) => DailyActivityStore(
    ref.watch(appDatabaseProvider),
    ready: ref.watch(legacyImportProvider),
  ),
);

/// Uygulama boyunca tek ölçüm saati (H-074). Öğrenme ekranları
/// [StudyTimeScope] ile katılır; iç içe ekranlar (konu seti → sahne avı)
/// süreyi iki kez saymaz: tek saat, "en az bir öğrenme ekranı açık ve
/// uygulama ön planda" iken çalışır.
final studyClockProvider = Provider<StudyClock>((ref) {
  final clock = StudyClock(ref.watch(dailyActivityStoreProvider));
  ref.onDispose(clock.dispose);
  return clock;
});

/// Ölçülen süre yazıldıkça dinleyenlere haber verir (Ana Sayfa halkası).
class StudyClock extends ChangeNotifier {
  StudyClock(
    this._store, {
    DateTime Function()? clock,
    Duration idleCap = kStudyIdleCap,
    this.flushEvery = const Duration(seconds: 30),
  }) : _clock = clock ?? DateTime.now,
       _meter = ActiveTimeMeter(idleCap: idleCap);

  final DailyActivityStore _store;
  final DateTime Function() _clock;
  final ActiveTimeMeter _meter;

  /// Ekran açıkken biriken süre bu kadarı aşınca yazılır (uygulama
  /// kapanırsa en çok bu kadarı kaybolur).
  final Duration flushEvery;

  int _holders = 0;
  bool _foreground = true;
  bool _disposed = false;
  Future<void> _writing = Future<void>.value();

  DateTime _now() => _clock().toUtc();

  bool get running => _meter.running;

  /// Bir öğrenme ekranı açıldı.
  void enter() {
    _holders++;
    _update();
  }

  /// Öğrenme ekranı kapandı (son ekransa ölçüm durur ve yazılır).
  void leave() {
    if (_holders > 0) _holders--;
    _update();
  }

  /// Uygulama ön planda mı (`AppLifecycleState.resumed`).
  void setForeground(bool value) {
    if (_foreground == value) return;
    _foreground = value;
    _update();
  }

  /// Ekranda etkinlik var (dokunma, oynayan video, okunan cümle).
  void signal() {
    if (!_meter.running) return;
    _meter.signal(_now());
    if (_meter.pendingMs >= flushEvery.inMilliseconds) unawaited(flush());
  }

  void _update() {
    final want = _holders > 0 && _foreground && !_disposed;
    if (want && !_meter.running) {
      final now = _now();
      _meter.start(now);
      unawaited(
        _store.markMeasuredSince(now).catchError((Object e) {
          debugPrint('[H074] ölçüm başlangıcı yazılamadı: $e');
        }),
      );
    } else if (!want && _meter.running) {
      _meter.stop(_now());
      unawaited(flush());
    }
  }

  /// Biriken süreyi yazar (sıralı; aynı süre iki kez yazılmaz). Hata
  /// uygulamayı durdurmaz: süre geri konur, bir sonraki yazmada denenir.
  Future<void> flush() => _writing = _writing.then((_) async {
    final seconds = _meter.takeSeconds();
    if (seconds.isEmpty) return;
    try {
      await _store.addSeconds(seconds, _now());
    } on Object catch (e) {
      _meter.restore(seconds);
      debugPrint('[H074] süre yazılamadı: $e');
      return;
    }
    if (!_disposed) notifyListeners();
  });

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// Öğrenme ekranını ölçüme katar (H-074): ekran açık ve uygulama ön plandayken
/// süre sayılır; dokunmalar etkinlik işaretidir. Video ya da sesle ilerleyen
/// ekranlar ayrıca `ref.read(studyClockProvider).signal()` çağırır.
class StudyTimeScope extends ConsumerStatefulWidget {
  const StudyTimeScope({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<StudyTimeScope> createState() => _StudyTimeScopeState();
}

class _StudyTimeScopeState extends ConsumerState<StudyTimeScope>
    with WidgetsBindingObserver {
  late final StudyClock _clock;

  @override
  void initState() {
    super.initState();
    _clock = ref.read(studyClockProvider);
    final binding = WidgetsBinding.instance..addObserver(this);
    final state = binding.lifecycleState;
    if (state != null) _clock.setForeground(state == AppLifecycleState.resumed);
    _clock.enter();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _clock.setForeground(state == AppLifecycleState.resumed);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _clock.leave();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Listener(
    behavior: HitTestBehavior.translucent,
    onPointerDown: (_) => _clock.signal(),
    child: widget.child,
  );
}
