import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:video_player/video_player.dart';

import '../../player/application/segment_player_pool.dart';

/// Keşfet video denetleyicileri (H-040): ekrandaki klip + sıradaki 1 klip
/// önceden açılır, ötekiler atılır. **Sert sınır:** aynı anda en çok
/// [maxLive] denetleyici yaşar (atılmayı bekleyenler dahil); yenisi ancak yer
/// açılınca kurulur.
///
/// Atılan denetleyici önce listeden çıkar ve dinleyicilere bildirilir (ekran
/// onun yerine ilk kareyi çizer); kendisi karenin sonunda atılır. Böylece
/// sökülmekte olan `VideoPlayer` atılmış denetleyiciye dokunmaz.
class ClipControllerCache extends ChangeNotifier {
  ClipControllerCache({
    required this.uriFor,
    VideoControllerFactory? factory,
    this.maxLive = 3,
    this.initTimeout = const Duration(seconds: 15),
  }) : _factory = factory ?? defaultVideoControllerFactory;

  final Uri Function(String path) uriFor;
  final int maxLive;
  final Duration initTimeout;
  final VideoControllerFactory _factory;

  final Map<String, _Slot> _slots = {};
  final Map<VideoPlayerController, Future<void>> _disposing = {};
  bool _closed = false;

  /// Ölçüm: aynı anda yaşayan en çok denetleyici (atılmayı bekleyen dahil).
  int peakLive = 0;

  /// Kurulan denetleyici sayısı (ölçüm ve testler).
  int created = 0;

  int get liveCount => _slots.length + _disposing.length;

  Iterable<String> get paths => _slots.keys;

  /// Hazır (başlatılmış) denetleyici; yoksa null.
  VideoPlayerController? ready(String path) {
    final s = _slots[path];
    return s != null && s.ready ? s.controller : null;
  }

  /// Açılamadı mı? ("Tekrar dene" ile [retry].)
  bool failed(String path) => _slots[path]?.failed ?? false;

  /// Denetleyiciyi döndürür (gerekirse kurar ve başlatılmasını bekler).
  /// Açılamazsa null; durum [failed] ile okunur.
  Future<VideoPlayerController?> acquire(String path) async {
    final slot = await _ensure(path);
    if (slot == null) return null;
    try {
      await slot.init;
      return identical(_slots[path], slot) ? slot.controller : null;
    } on Object {
      return null;
    }
  }

  /// Arka planda açar (yer yoksa bekler).
  void preload(String path) => unawaited(_ensure(path));

  /// [keep] dışındaki denetleyicileri atar.
  void retain(Set<String> keep) {
    for (final p in [..._slots.keys]) {
      if (!keep.contains(p)) _drop(p);
    }
  }

  /// Açılamayan denetleyiciyi atar; sonraki [acquire] yeniden kurar.
  void retry(String path) => _drop(path);

  Future<_Slot?> _ensure(String path) async {
    if (_closed) return null;
    final existing = _slots[path];
    if (existing != null) return existing;
    // Sert sınır: atılmayı bekleyenler bitsin; yine yer yoksa en eskisi.
    while (liveCount >= maxLive && _disposing.isNotEmpty) {
      await Future.wait(_disposing.values);
      if (_closed) return null;
      final again = _slots[path];
      if (again != null) return again;
    }
    if (liveCount >= maxLive && _slots.isNotEmpty) {
      _drop(_slots.keys.first);
      await Future.wait(_disposing.values);
      if (_closed) return null;
    }
    final controller = _factory(uriFor(path));
    created++;
    final slot = _Slot(controller);
    _slots[path] = slot;
    if (liveCount > peakLive) peakLive = liveCount;
    slot.init = controller
        .initialize()
        .timeout(initTimeout)
        .then((_) {
          slot.ready = true;
          if (!_closed) notifyListeners();
        })
        .catchError((Object e) {
          slot.failed = true;
          debugPrint('[H040] klip açılamadı ($path): $e');
          if (!_closed) notifyListeners();
          throw e;
        });
    slot.init.ignore();
    return slot;
  }

  void _drop(String path) {
    final s = _slots.remove(path);
    if (s == null) return;
    final c = s.controller;
    unawaited(c.pause().catchError((Object _) {}));
    if (!_closed) notifyListeners();
    // Kare bitince: ekrandaki VideoPlayer o sırada ilk kareye geçmiş olur.
    final done = SchedulerBinding.instance.endOfFrame.then((_) async {
      try {
        await c.dispose();
      } on Object {
        // Atılırken hata: yine de listeden çıkar.
      }
    });
    _disposing[c] = done.whenComplete(() => _disposing.remove(c));
  }

  @override
  void dispose() {
    _closed = true;
    final all = [for (final s in _slots.values) s.controller];
    _slots.clear();
    for (final c in all) {
      unawaited(c.dispose().catchError((Object _) {}));
    }
    super.dispose();
  }
}

class _Slot {
  _Slot(this.controller);

  final VideoPlayerController controller;
  late final Future<void> init;
  bool ready = false;
  bool failed = false;
}
