import 'dart:async';
import 'dart:collection';

import 'package:video_player/video_player.dart';

typedef VideoControllerFactory = VideoPlayerController Function(Uri uri);

VideoPlayerController defaultVideoControllerFactory(Uri uri) =>
    VideoPlayerController.networkUrl(uri);

/// Segment videoları için küçük denetleyici havuzu (en fazla [maxControllers]).
///
/// Oynayan segment sürerken sıradakiler önceden başlatılır (ön ısıtma). Böylece
/// segment geçişinde ağdan açma ve çözücü kurulumu beklenmez. Korunan
/// denetleyiciler (ekrandaki ve altındaki son kare) asla atılmaz.
class SegmentPlayerPool {
  SegmentPlayerPool({
    required this.uriFor,
    this.maxControllers = 3,
    this.initTimeout = const Duration(seconds: 15),
    VideoControllerFactory? factory,
  }) : _factory = factory ?? defaultVideoControllerFactory;

  final Uri Function(String path) uriFor;
  final int maxControllers;
  final Duration initTimeout;
  final VideoControllerFactory _factory;

  // Ekleme sırası = en eski önce (LRU için yeniden eklenir).
  final LinkedHashMap<String, _Entry> _entries = LinkedHashMap();
  bool _disposed = false;

  int get liveCount => _entries.length;

  Iterable<String> get paths => _entries.keys;

  /// Denetleyici hazır (başlatılmış) mı?
  bool isReady(String path) => _entries[path]?.ready ?? false;

  /// Denetleyiciyi döndürür; yoksa oluşturur ve başlatılmasını bekler.
  Future<VideoPlayerController> acquire(
    String path, {
    Set<String> protect = const {},
  }) async {
    final entry = _ensure(path, protect: {...protect, path});
    // LRU: en yeni kullanılan sona.
    _entries
      ..remove(path)
      ..[path] = entry;
    try {
      await entry.init;
      return entry.controller;
    } catch (_) {
      // Başarısız giriş atılır; bir sonraki deneme yeniden oluşturur.
      if (identical(_entries[path], entry)) _drop(path);
      rethrow;
    }
  }

  /// Verilen yolları arka planda başlatır (yer yoksa korunmayan en eskiyi atar).
  void preload(Iterable<String> paths, {Set<String> protect = const {}}) {
    final keep = {...protect, ...paths};
    for (final p in paths) {
      if (_entries.containsKey(p)) continue;
      if (_entries.length >= maxControllers && !_evictOne(keep)) return;
      _ensure(p, protect: keep).init.ignore();
    }
  }

  _Entry _ensure(String path, {required Set<String> protect}) {
    if (_disposed) throw StateError('Havuz kapatıldı');
    final existing = _entries[path];
    if (existing != null) return existing;
    while (_entries.length >= maxControllers && _evictOne(protect)) {}
    final controller = _factory(uriFor(path));
    final entry = _Entry(controller);
    entry.init = controller
        .initialize()
        .timeout(initTimeout)
        .then((_) => entry.ready = true);
    _entries[path] = entry;
    return entry;
  }

  bool _evictOne(Set<String> protect) {
    for (final p in _entries.keys) {
      if (!protect.contains(p)) {
        _drop(p);
        return true;
      }
    }
    return false;
  }

  void _drop(String path) {
    final e = _entries.remove(path);
    if (e == null) return;
    // Biraz sonra at: ekrandaki VideoPlayer o sırada sökülmüş olur; bitişte
    // eklentinin pause().then(seekTo) zinciri de tamamlanır.
    Future<void>.delayed(const Duration(milliseconds: 600), () async {
      try {
        await e.controller.dispose();
      } catch (_) {}
    });
  }

  /// Hata sonrası yeniden deneme için bir girişi zorla atar.
  void evict(String path) => _drop(path);

  Future<void> dispose() async {
    _disposed = true;
    final all = _entries.values.toList();
    _entries.clear();
    for (final e in all) {
      try {
        await e.controller.dispose();
      } catch (_) {}
    }
  }
}

class _Entry {
  _Entry(this.controller);

  final VideoPlayerController controller;
  late final Future<void> init;
  bool ready = false;
}
