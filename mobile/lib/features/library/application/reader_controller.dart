import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../shared/meaning/meaning_controller.dart';
import '../../../shared/meaning/meaning_text.dart';
import '../domain/book.dart';
import 'book_audio.dart';
import 'book_media_session.dart';

enum ReaderMode { listen, silent }

/// Uyku zamanlayıcısı: kapalı, bölüm sonunda ya da 10 / 20 / 30 dk sonra.
enum SleepOption {
  off(null),
  endOfChapter(null),
  min10(10),
  min20(20),
  min30(30);

  const SleepOption(this.minutes);

  final int? minutes;
}

/// Kitapta bir yer: sayfa sırası (0'dan) ve sayfadaki cümle (−1: başlık).
class ReaderPlace {
  const ReaderPlace(this.pageIndex, this.sentenceIndex);

  final int pageIndex;
  final int sentenceIndex;

  @override
  bool operator ==(Object other) =>
      other is ReaderPlace &&
      other.pageIndex == pageIndex &&
      other.sentenceIndex == sentenceIndex;

  @override
  int get hashCode => Object.hash(pageIndex, sentenceIndex);

  @override
  String toString() => 'ReaderPlace($pageIndex, $sentenceIndex)';
}

/// Okuyucunun durumu ve ses eşlemesi (H-067).
///
/// **Vurgu eşlemesi:** çalarken her [tickInterval]'da (50 ms) ses konumu
/// tahmin edilir: son örnek + geçen süre × hız. Her [sampleEvery] adımda
/// (200 ms) çalardan taze örnek alınır. Böylece vurgulanan cümle ses
/// konumunun en fazla ~0,1 sn gerisinde kalır (kabul: ≤ 0,2 sn). Saat
/// ([clock], sn) testte elle ilerletilir.
///
/// **Sesli mod:** okunan cümle vurgulanır; sayfa sonunda sayfa çevrilir;
/// bölüm bitince sıradaki bölüm açılır; kitap bitince [onFinished].
/// **Sessiz mod:** ses durur; kullanıcı sayfayı kendi çevirir; uzun basılan
/// cümle tek başına seslendirilir ([playSentenceOnly]).
class ReaderController extends ChangeNotifier {
  ReaderController({
    required this.book,
    required BookAudio audio,
    required this.mediaUri,
    this.onPlace,
    this.onFinished,
    double Function()? clock,
    ReaderMode mode = ReaderMode.listen,
    ReaderPlace? start,
    this.tickInterval = const Duration(milliseconds: 50),
    this.sampleEvery = 4,
    bool wordHighlight = false,
  }) : _audio = audio,
       _clock = clock ?? _stopwatchClock(),
       _wordHighlight = wordHighlight,
       _mode = book.canListen ? mode : ReaderMode.silent {
    final s = start ?? const ReaderPlace(0, -1);
    final pi = s.pageIndex.clamp(0, book.pages.length - 1);
    final si = s.sentenceIndex < 0 && !book.isChapterStart(pi)
        ? 0
        : s.sentenceIndex.clamp(-1, book.pages[pi].sentences.length - 1);
    _place = ReaderPlace(pi, si);
    _pageIndex = pi;
    // Kitabın bir kısmı seslendirilmiş, açılan bölümün sesi yok: sessiz
    // açılır, ekran bir kez sakin not gösterir.
    if (_mode == ReaderMode.listen &&
        !book.chapterCanListen(book.pages[pi].chapterId)) {
      _mode = ReaderMode.silent;
      _chapterAudioMissing = true;
    }
    // H-068: arka planda çalan ses kilit ekranı komutlarını okuyucuya iletir.
    final session = _audio;
    if (session is BookMediaSession) {
      _remote = (session as BookMediaSession).commands.listen(_onRemote);
    }
  }

  static double Function() _stopwatchClock() {
    final sw = Stopwatch()..start();
    return () => sw.elapsedMicroseconds / 1e6;
  }

  final Book book;
  final Uri Function(String path) mediaUri;

  /// Kalınan yer değişti (ilerleme kaydı). Sayfa numarası 1'den.
  final void Function(BookChapter chapter, ReaderPlace place, double? sec)?
  onPlace;

  /// Kitap bitti (son cümle okundu ya da sessiz modda "Kitabı bitir").
  final VoidCallback? onFinished;
  final Duration tickInterval;
  final int sampleEvery;

  final BookAudio _audio;
  final double Function() _clock;
  StreamSubscription<BookRemoteCommand>? _remote;

  ReaderMode _mode;
  late ReaderPlace _place;
  late int _pageIndex;
  int? _word;
  bool _playing = false;
  bool _wordHighlight;
  double _speed = 1.0;
  SleepOption _sleep = SleepOption.off;
  double? _sleepDeadline;
  bool _sleepFired = false;
  bool _finished = false;
  bool _audioFailed = false;
  bool _chapterAudioMissing = false;
  bool _disposed = false;

  /// Açık bölüm sesi ([book.chapters] sırası).
  int? _loadedChapter;

  /// Son konum örneği ve alındığı an (saat).
  double _sample = 0;
  double _sampleAt = 0;
  int _ticks = 0;
  Timer? _timer;

  /// Her atlamada artar: eski örnek yeni konumun üstüne yazılmasın.
  int _seekGen = 0;

  /// Bölüm ya da sayfa değişirken eşleme bekler.
  int _busy = 0;

  /// Tek cümle / kelime çalınıyorsa bitiş (sn); vurgu izleme kapalı mı.
  double? _stopAt;
  bool _tracking = true;

  // ------------------------------------------------------------ durum

  ReaderMode get mode => _mode;
  bool get canListen => book.canListen && !_audioFailed;
  bool get audioFailed => _audioFailed;

  /// Ekrandaki bölüm sesli okunabilir mi (kitap bölüm bölüm
  /// seslendirilebilir; sesi olmayan bölüm sessiz okunur).
  bool get chapterCanListen =>
      canListen && book.chapterCanListen(book.pages[_pageIndex].chapterId);

  /// Sesi olmayan bölüme gelindi (sesli okuma sessize geçti ya da "Sesli"
  /// seçildi); ekran bir kez sakin not gösterir ve [clearChapterAudioNotice]
  /// çağırır.
  bool get chapterAudioMissing => _chapterAudioMissing;

  void clearChapterAudioNotice() {
    if (!_chapterAudioMissing) return;
    _chapterAudioMissing = false;
    _notify();
  }

  /// Bu bölümün sesi yok: ses durur, sessiz moda geçilir, not işaretlenir.
  Future<void> _silenceForChapter() async {
    if (_playing) await pause();
    _stopAt = null;
    _mode = ReaderMode.silent;
    _chapterAudioMissing = true;
    _notify();
  }

  bool get isPlaying => _playing;
  double get speed => _speed;
  SleepOption get sleep => _sleep;
  bool get wordHighlight => _wordHighlight;

  /// Uyku zamanlayıcısı sesi durdurdu (ekran bir kez sakin not gösterir).
  bool get sleepFired => _sleepFired;
  bool get finished => _finished;

  /// Ekrandaki sayfa.
  int get pageIndex => _pageIndex;
  BookPage get page => book.pages[_pageIndex];

  /// Kalınan / okunan cümle.
  ReaderPlace get place => _place;

  /// Vurgulanan cümle (sesli modda ya da tek cümle çalarken); yoksa null.
  ReaderPlace? get highlighted =>
      _mode == ReaderMode.listen || _stopAt != null ? _place : null;

  /// Vurgulanan kelime (kelime vurgusu açıksa).
  int? get highlightedWord => _wordHighlight ? _word : null;

  /// Okunan kelime (vurgu kapalı da olsa; okunan yeri izleme için).
  int? get spokenWord => _mode == ReaderMode.listen ? _word : null;

  BookChapter get chapter => book.chapterOf(page);

  /// Tahmini ses konumu (sn, bölüm sesinin başına göre).
  double get estimatedPosition =>
      _playing ? _sample + (_clock() - _sampleAt) * _speed : _sample;

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  // ------------------------------------------------------------ ses

  ChapterTrack _trackOf(ReaderPlace p) =>
      book.track(book.pages[p.pageIndex].chapterId);

  int _chapterIndexOf(ReaderPlace p) =>
      book.chapterIndexOf(book.pages[p.pageIndex].chapterId);

  TrackItem? _itemOf(ReaderPlace p) {
    for (final i in _trackOf(p).items) {
      if (i.pageIndex == p.pageIndex && i.index == p.sentenceIndex) return i;
    }
    return null;
  }

  Future<bool> _ensureChapter(int chapterIndex) async {
    if (_loadedChapter == chapterIndex) return true;
    final path = book.chapters[chapterIndex].audio;
    if (path == null) return false;
    try {
      await _audio.open(mediaUri(path));
      await _audio.setSpeed(_speed);
      _loadedChapter = chapterIndex;
      _publishMediaInfo(chapterIndex);
      return true;
    } on Object catch (e) {
      debugPrint('[H067] kitap sesi açılamadı: $path ($e)');
      _audioFailed = true;
      _mode = ReaderMode.silent;
      _playing = false;
      _notify();
      return false;
    }
  }

  /// Kilit ekranı künyesi: kitap, bölüm, kapak; sıradaki bölümün sesi varsa
  /// "Sonraki bölüm" düğmesi (H-068).
  void _publishMediaInfo(int chapterIndex) {
    final a = _audio;
    if (a is! BookMediaSession) return;
    final next = chapterIndex + 1 < book.chapters.length
        ? book.chapters[chapterIndex + 1]
        : null;
    final cover = book.cover;
    unawaited(
      (a as BookMediaSession).setMediaInfo(
        BookMediaInfo(
          bookTitle: book.title,
          chapterTitle: book.chapters[chapterIndex].title,
          artUri: cover == null ? null : mediaUri(cover),
          hasNextChapter: next != null && book.chapterCanListen(next.id),
        ),
      ),
    );
  }

  /// Kilit ekranı / bildirim / kulaklık komutu ya da sistem kesintisi.
  void _onRemote(BookRemoteCommand c) {
    if (_disposed) return;
    switch (c) {
      case BookRemoteCommand.play:
        unawaited(play());
      case BookRemoteCommand.pause:
      case BookRemoteCommand.stop:
        unawaited(pause());
      case BookRemoteCommand.back10:
        unawaited(back10());
      case BookRemoteCommand.nextChapter:
        unawaited(nextChapter());
    }
  }

  /// Sıradaki bölüm (kilit ekranındaki "Sonraki bölüm"); çalıyorsa sürer.
  Future<void> nextChapter() async {
    final ci = _chapterIndexOf(
      _mode == ReaderMode.listen ? _place : ReaderPlace(_pageIndex, 0),
    );
    if (ci >= book.chapters.length - 1) return;
    await goToChapter(ci + 1);
  }

  /// Uygulama öne döndü (H-068): ses arka planda sürmüş olabilir. Konum
  /// duvar saatinden değil çalardan taze alınır; vurgu, sayfa, bölüm sonu ve
  /// uyku zamanlayıcısı hemen eşlenir.
  Future<void> resync() async {
    if (_disposed) return;
    if (!_playing || _busy > 0) {
      _notify();
      return;
    }
    final gen = _seekGen;
    try {
      final p = await _audio.position();
      if (_disposed || !_playing || gen != _seekGen) return;
      _sample = p;
      _sampleAt = _clock();
    } on Object catch (e) {
      debugPrint('[H068] konum okunamadı: $e');
    }
    tick();
    _notify();
  }

  Future<void> _seek(double sec) async {
    _seekGen++;
    _sample = sec < 0 ? 0 : sec;
    _sampleAt = _clock();
    await _audio.seek(_sample);
  }

  void _startTimer() {
    _timer ??= Timer.periodic(tickInterval, (_) => tick());
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _startPlayback() async {
    _sampleAt = _clock();
    _playing = true;
    _startTimer();
    _notify();
    await _audio.play();
  }

  /// Sesli modda okumayı başlatır ya da sürdürür (okunan cümlenin başından).
  Future<void> play() async {
    if (_disposed || !canListen) return;
    if (_finished) _finished = false;
    _sleepFired = false;
    if (!book.chapterCanListen(book.pages[_place.pageIndex].chapterId)) {
      await _silenceForChapter();
      return;
    }
    _mode = ReaderMode.listen;
    _stopAt = null;
    _tracking = true;
    final item = _itemOf(_place);
    if (!await _ensureChapter(_chapterIndexOf(_place))) return;
    final start = item?.sentence.start ?? 0;
    // Duraklatılan yerden devam: aynı cümledeyse konum korunur.
    final cur = _sample;
    final end = item?.sentence.end ?? start;
    if (cur < start - 0.05 || cur > end + 0.05) await _seek(start);
    if (_sleep.minutes != null && _sleepDeadline == null) {
      _sleepDeadline = _clock() + _sleep.minutes! * 60;
    }
    await _startPlayback();
  }

  Future<void> pause() async {
    if (!_playing) return;
    _sample = estimatedPosition;
    _playing = false;
    _stopTimer();
    _notify();
    await _audio.pause();
  }

  Future<void> togglePlay() => _playing ? pause() : play();

  /// 10 sn geri (bölümün başından öteye gitmez).
  Future<void> back10() async {
    if (!canListen || _mode != ReaderMode.listen) return;
    final now = estimatedPosition;
    await _seek(now - 10);
    _applyPosition(_sample, save: true);
    _notify();
  }

  static const speeds = [0.75, 1.0, 1.25];

  Future<void> setSpeed(double s) async {
    _sample = estimatedPosition;
    _sampleAt = _clock();
    _speed = s;
    _notify();
    await _audio.setSpeed(s);
  }

  /// 0,75 → 1 → 1,25 → 0,75.
  Future<void> cycleSpeed() =>
      setSpeed(speeds[(speeds.indexOf(_speed) + 1) % speeds.length]);

  void setSleep(SleepOption o) {
    _sleep = o;
    _sleepFired = false;
    _sleepDeadline = o.minutes == null || !_playing
        ? null
        : _clock() + o.minutes! * 60;
    _notify();
  }

  void setWordHighlight(bool on) {
    _wordHighlight = on;
    _notify();
  }

  /// Sesli ↔ sessiz. Sessize geçince ses durur; sesliye geçince ekrandaki
  /// sayfanın kalınan cümlesinden okunur.
  Future<void> setMode(ReaderMode m) async {
    if (m == _mode) return;
    if (m == ReaderMode.listen && !canListen) return;
    if (m == ReaderMode.listen && !chapterCanListen) {
      // Sesi olmayan bölümde "Sesli": not çıkar, sessiz kalır.
      _chapterAudioMissing = true;
      _notify();
      return;
    }
    _mode = m;
    if (m == ReaderMode.silent) {
      await pause();
      _stopAt = null;
    } else {
      if (_place.pageIndex != _pageIndex) {
        _place = ReaderPlace(_pageIndex, _firstOn(_pageIndex));
      }
      await play();
    }
    _notify();
  }

  int _firstOn(int pageIndex) => book.isChapterStart(pageIndex) ? -1 : 0;

  /// Kullanıcı sayfayı çevirdi (kaydırma, düğme ya da bölüm listesi).
  Future<void> goToPage(int index) async {
    final i = index.clamp(0, book.pages.length - 1);
    if (i == _pageIndex && _place.pageIndex == i) return;
    _pageIndex = i;
    _place = ReaderPlace(i, _firstOn(i));
    _word = null;
    _report();
    if (_mode == ReaderMode.listen && canListen && !chapterCanListen) {
      // Sesli okurken sesi olmayan bölüme geçildi.
      await _silenceForChapter();
      return;
    }
    if (_mode == ReaderMode.listen && canListen) {
      final wasPlaying = _playing;
      final item = _itemOf(_place);
      _busy++;
      try {
        if (await _ensureChapter(_chapterIndexOf(_place))) {
          await _seek(item?.sentence.start ?? 0);
          if (wasPlaying) await _audio.play();
        }
      } finally {
        _busy--;
      }
    }
    _notify();
  }

  Future<void> goToChapter(int chapterIndex) async {
    final c = book.chapters[chapterIndex.clamp(0, book.chapters.length - 1)];
    if (c.pageIds.isEmpty) return;
    await goToPage(book.pageIndexOf(c.pageIds.first));
  }

  /// Sessiz mod: yalnız bu cümle seslendirilir (vurguyla), sonra durur.
  Future<void> playSentenceOnly(ReaderPlace p) async {
    if (!canListen) return;
    final s = book.sentenceAt(p.pageIndex, p.sentenceIndex);
    if (!s.hasTiming) return;
    if (!await _ensureChapter(_chapterIndexOf(p))) return;
    _place = p;
    _word = null;
    _tracking = true;
    _stopAt = s.end;
    await _seek(s.start!);
    await _startPlayback();
  }

  /// Anlam panelindeki ses: [start]–[end] aralığı (vurgu ve sayfa oynamaz).
  Future<void> playRange(
    ReaderPlace p,
    double start,
    double end, {
    double speed = 1.0,
  }) async {
    if (!canListen) return;
    if (!await _ensureChapter(_chapterIndexOf(p))) return;
    _tracking = false;
    _stopAt = end;
    if (speed != _speed) await setSpeed(speed);
    await _seek(start);
    await _startPlayback();
  }

  // ------------------------------------------------------------ anlam paneli

  double? _resumeAt;
  double? _resumeSpeed;

  /// Panel açılmadan önce: ses durur, yer saklanır. Çalıyor muydu?
  Future<bool> pauseForSheet() async {
    final was = _playing && _stopAt == null;
    await pause();
    _resumeAt = _sample;
    _resumeSpeed = _speed;
    return was;
  }

  /// Panel kapandı: kaldığı yerden sürer (çalıyorduysa).
  Future<void> resumeAfterSheet(bool wasPlaying) async {
    await pause();
    _stopAt = null;
    _tracking = true;
    if (_resumeSpeed != null && _resumeSpeed != _speed) {
      await setSpeed(_resumeSpeed!);
    }
    final at = _resumeAt;
    _resumeAt = null;
    _resumeSpeed = null;
    if (!wasPlaying || at == null) {
      _notify();
      return;
    }
    if (await _ensureChapter(_chapterIndexOf(_place))) {
      await _seek(at);
      await _startPlayback();
    }
  }

  /// Panel için ses: kelime ve cümle kitap sesinden kesilir.
  MeaningAudio meaningAudio(ReaderPlace p) => _BookMeaningAudio(this, p);

  // ------------------------------------------------------------ sessiz okuma

  /// "Baştan oku": ilk sayfa, ses durur.
  Future<void> restart() async {
    await pause();
    _finished = false;
    _pageIndex = 0;
    _place = ReaderPlace(0, _firstOn(0));
    _word = null;
    _sample = 0;
    _report();
    _notify();
  }

  /// Sessiz modda son sayfadan sonra "Kitabı bitir".
  void finish() {
    if (_finished) return;
    _finished = true;
    unawaited(pause());
    onFinished?.call();
    _notify();
  }

  // ------------------------------------------------------------ eşleme

  /// Bir adım: ses konumundan vurgu, sayfa, bölüm sonu ve uyku zamanlayıcısı.
  @visibleForTesting
  void tick() {
    if (!_playing || _disposed || _busy > 0) return;
    _ticks++;
    if (_ticks % sampleEvery == 0) unawaited(_takeSample());
    final t = estimatedPosition;
    final stopAt = _stopAt;
    if (stopAt != null && t >= stopAt) {
      _stopAt = null;
      _tracking = true;
      unawaited(pause());
      return;
    }
    if (_sleepDeadline != null && _clock() >= _sleepDeadline!) {
      _fireSleep();
      return;
    }
    final track = _trackOf(_place);
    if (_tracking && stopAt == null && (_audio.isCompleted || t >= track.end)) {
      unawaited(_chapterEnded());
      return;
    }
    if (_tracking) _applyPosition(t, save: _mode == ReaderMode.listen);
  }

  Future<void> _takeSample() async {
    final gen = _seekGen;
    try {
      final p = await _audio.position();
      if (!_playing || _disposed || gen != _seekGen) return;
      _sample = p;
      _sampleAt = _clock();
    } on Object catch (e) {
      debugPrint('[H067] konum okunamadı: $e');
    }
  }

  /// [t] anındaki cümleyi vurgular; sayfa değiştiyse çevirir.
  void _applyPosition(double t, {required bool save}) {
    final track = _trackOf(_place);
    final item = track.items[track.indexAt(t)];
    final next = ReaderPlace(item.pageIndex, item.index);
    final word = ChapterTrack.wordAt(item.sentence, t);
    var changed = false;
    if (next != _place) {
      _place = next;
      changed = true;
      if (save) _report(sec: item.sentence.start);
    }
    if (_mode == ReaderMode.listen && item.pageIndex != _pageIndex) {
      _pageIndex = item.pageIndex;
      changed = true;
    }
    if (word != _word) {
      _word = word;
      // Kelime vurgusu kapalıyken de: okunan yeri izleme uzun cümlede
      // kelimeyi izler.
      changed = true;
    }
    if (changed) _notify();
  }

  void _report({double? sec}) {
    final p = book.pages[_place.pageIndex];
    onPlace?.call(
      book.chapterOf(p),
      _place,
      sec ?? book.sentenceAt(_place.pageIndex, _place.sentenceIndex).start,
    );
  }

  void _fireSleep() {
    _sleepDeadline = null;
    _sleep = SleepOption.off;
    _sleepFired = true;
    unawaited(pause());
  }

  /// Sleep notu görüldü.
  void clearSleepNotice() {
    if (!_sleepFired) return;
    _sleepFired = false;
    _notify();
  }

  Future<void> _chapterEnded() async {
    _busy++;
    try {
      await _advanceChapter();
    } finally {
      _busy--;
    }
  }

  Future<void> _advanceChapter() async {
    final ci = _chapterIndexOf(_place);
    await pause();
    if (ci >= book.chapters.length - 1) {
      _finished = true;
      onFinished?.call();
      _notify();
      return;
    }
    final next = book.chapters[ci + 1];
    final pi = book.pageIndexOf(next.pageIds.first);
    _place = ReaderPlace(pi, -1);
    _pageIndex = pi;
    _word = null;
    _sample = 0;
    _report(sec: 0);
    if (!book.chapterCanListen(next.id)) {
      // Sıradaki bölümün sesi henüz yok: sessiz moda geçilir, bölümün ilk
      // sayfasında kalınır; ekran bir kez sakin not gösterir.
      if (_sleep == SleepOption.endOfChapter) _sleep = SleepOption.off;
      await _silenceForChapter();
      return;
    }
    if (_sleep == SleepOption.endOfChapter) {
      _sleep = SleepOption.off;
      _sleepFired = true;
      _notify();
      return;
    }
    if (!await _ensureChapter(ci + 1)) return;
    await _seek(0);
    await _startPlayback();
  }

  @override
  void dispose() {
    _disposed = true;
    _stopTimer();
    unawaited(_remote?.cancel());
    unawaited(_audio.dispose());
    super.dispose();
  }
}

/// Anlam panelinin sesi: kitap sesinden kelime ve cümle aralığı.
class _BookMeaningAudio implements MeaningAudio {
  _BookMeaningAudio(this._c, this._p);

  final ReaderController _c;
  final ReaderPlace _p;

  BookSentence get _s => _c.book.sentenceAt(_p.pageIndex, _p.sentenceIndex);

  @override
  bool get canPlayWords => _c.canListen && _s.hasTiming;

  @override
  bool get canPlaySentence => _c.canListen && _s.hasTiming;

  @override
  Future<void> playWord(MeaningWord word, {required double speed}) async {
    if (!word.hasTiming) return;
    await _c.playRange(_p, word.start!, word.end!, speed: speed);
  }

  @override
  Future<void> playSentence({required double speed}) async {
    final s = _s;
    if (!s.hasTiming) return;
    await _c.playRange(_p, s.start!, s.end!, speed: speed);
  }

  @override
  Future<void> stop() => _c.pause();
}
