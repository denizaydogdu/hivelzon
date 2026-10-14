import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';

import 'background_book_audio.dart';
import 'book_media_session.dart';

/// Uygulamanın tek kilit ekranı / bildirim oturumu (H-068): `audio_service`
/// (iOS `MPNowPlayingInfoCenter` + `MPRemoteCommandCenter`, Android
/// `MediaSession` + ön plan medya hizmeti) ve `audio_session` (iOS
/// `AVAudioSession` `playback` kategorisi, `spokenAudio` kipi; Android ses
/// odağı).
///
/// Yalnız kitap okuyucusu kullanır; bölüm, dilbilgisi ve Keşfet kendi
/// çalarlarıyla (arka planda duran `video_player`) kalır.
///
/// Bildirim sakin: kanal "Kitap dinleme", rozet yok, sessiz; düğmeler
/// 10 sn geri · oynat/duraklat · (varsa) sonraki bölüm. Android 13+ medya
/// oturumu bildirimi `POST_NOTIFICATIONS` izni istemez (sistem muafiyeti);
/// izin istenmez.
class AudioServiceBookSessionHost implements BookSessionHost {
  AudioServiceBookSessionHost._();

  static final instance = AudioServiceBookSessionHost._();

  static Future<_HiBookAudioHandler?>? _handler;

  /// `audio_service`'i başlatır (bir kez; `main()`'den beklemeden çağrılır,
  /// okuyucu gerekirse yine çağırır). Başlatılamazsa ses kilit ekranı
  /// olmadan çalar.
  static Future<void> start() => _start().then((_) {});

  static Future<_HiBookAudioHandler?> _start() => _handler ??= () async {
    try {
      return await AudioService.init(
        builder: () => _HiBookAudioHandler(instance._emit),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'tr.velzon.hivelzon.book',
          androidNotificationChannelName: 'Kitap dinleme',
          androidNotificationChannelDescription:
              'Kitap dinlerken oynat, duraklat ve 10 sn geri.',
          androidShowNotificationBadge: false,
          rewindInterval: Duration(seconds: 10),
        ),
      );
    } on Object catch (e) {
      debugPrint('[H068] audio_service başlatılamadı: $e');
      return null;
    }
  }();

  final _commands = StreamController<BookRemoteCommand>.broadcast();
  Object? _owner;
  bool _lastPlaying = false;
  bool _interrupted = false;
  bool _sessionReady = false;
  final List<StreamSubscription<Object?>> _subs = [];

  void _emit(BookRemoteCommand c) {
    if (_owner != null) _commands.add(c);
  }

  @override
  Object? get owner => _owner;

  @override
  Stream<BookRemoteCommand> get commands => _commands.stream;

  @override
  Future<void> prepare() async {
    unawaited(_start());
    final session = await AudioSession.instance;
    // Her seferinde: "Söyle" (konuşma tanıma) kategoriyi değiştirmiş olabilir.
    await session.configure(const AudioSessionConfiguration.speech());
    if (_sessionReady) return;
    _sessionReady = true;
    _subs
      ..add(
        session.interruptionEventStream.listen((e) {
          if (e.begin) {
            if (_lastPlaying) {
              _interrupted = true;
              _emit(BookRemoteCommand.pause);
            }
          } else {
            final resume =
                _interrupted && e.type != AudioInterruptionType.unknown;
            _interrupted = false;
            if (resume) _emit(BookRemoteCommand.play);
          }
        }),
      )
      ..add(
        session.becomingNoisyEventStream.listen((_) {
          // Kulaklık çıktı: hoparlörden okumaya devam etmez.
          _interrupted = false;
          if (_lastPlaying) _emit(BookRemoteCommand.pause);
        }),
      );
  }

  @override
  Future<void> setItem(
    Object owner,
    BookMediaInfo info,
    double? duration,
  ) async {
    _owner = owner;
    final h = await _start();
    if (h == null || !identical(_owner, owner)) return;
    h.mediaItem.add(
      MediaItem(
        id: '${info.bookTitle}/${info.chapterTitle}',
        title: info.chapterTitle,
        album: info.bookTitle,
        artist: info.bookTitle,
        artUri: info.artUri,
        duration: duration == null
            ? null
            : Duration(microseconds: (duration * 1e6).round()),
      ),
    );
  }

  @override
  Future<void> setState(
    Object owner, {
    required bool playing,
    required double position,
    required double speed,
    required bool hasNextChapter,
  }) async {
    if (!identical(_owner, owner)) return;
    _lastPlaying = playing;
    if (playing) _interrupted = false;
    final h = await _start();
    if (h == null || !identical(_owner, owner)) return;
    h.playbackState.add(
      PlaybackState(
        controls: [
          const MediaControl(
            androidIcon: 'drawable/audio_service_fast_rewind',
            label: '10 sn geri',
            action: MediaAction.rewind,
          ),
          if (playing)
            const MediaControl(
              androidIcon: 'drawable/audio_service_pause',
              label: 'Duraklat',
              action: MediaAction.pause,
            )
          else
            const MediaControl(
              androidIcon: 'drawable/audio_service_play_arrow',
              label: 'Dinle',
              action: MediaAction.play,
            ),
          if (hasNextChapter)
            const MediaControl(
              androidIcon: 'drawable/audio_service_skip_next',
              label: 'Sonraki bölüm',
              action: MediaAction.skipToNext,
            ),
        ],
        androidCompactActionIndices: hasNextChapter
            ? const [0, 1, 2]
            : const [0, 1],
        processingState: AudioProcessingState.ready,
        playing: playing,
        updatePosition: Duration(microseconds: (position * 1e6).round()),
        speed: speed,
      ),
    );
  }

  @override
  Future<void> release(Object owner) async {
    if (!identical(_owner, owner)) return;
    _owner = null;
    _lastPlaying = false;
    _interrupted = false;
    final h = await _start();
    if (h != null && _owner == null) {
      // `idle`: audio_service ön plan hizmetini durdurur, bildirim ve kilit
      // ekranı künyesi kalkar.
      h.playbackState.add(PlaybackState());
      h.mediaItem.add(null);
    }
    try {
      final session = await AudioSession.instance;
      // Başka uygulamanın sesi (müzik vb.) kaldığı yerden sürebilsin.
      await session.setActive(false);
    } on Object catch (e) {
      debugPrint('[H068] ses oturumu bırakılamadı: $e');
    }
  }
}

/// `audio_service` tutamağı: platform komutlarını okuyucuya iletir; çalmaz.
class _HiBookAudioHandler extends BaseAudioHandler {
  _HiBookAudioHandler(this._emit);

  final void Function(BookRemoteCommand) _emit;

  @override
  Future<void> play() async => _emit(BookRemoteCommand.play);

  @override
  Future<void> pause() async => _emit(BookRemoteCommand.pause);

  @override
  Future<void> rewind() async => _emit(BookRemoteCommand.back10);

  /// Kulaklığın "geri" düğmesi de 10 sn geri.
  @override
  Future<void> skipToPrevious() async => _emit(BookRemoteCommand.back10);

  @override
  Future<void> skipToNext() async => _emit(BookRemoteCommand.nextChapter);

  @override
  Future<void> stop() async => _emit(BookRemoteCommand.stop);

  /// Android: uygulama son kullanılanlardan kaydırıldı.
  @override
  Future<void> onTaskRemoved() async => _emit(BookRemoteCommand.stop);
}
