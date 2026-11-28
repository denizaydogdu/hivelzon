import 'dart:async';

import 'package:flutter/foundation.dart';

import 'learning_event_log.dart';
import 'meaning_text.dart';
import 'notebook_repository.dart';

/// Panelin ses kaynağı. Oynatıcıda segmentten kesilir; Keşfet'te klipten.
abstract interface class MeaningAudio {
  /// Kelimeler tek tek çalınabilir mi (zaman damgası var mı)?
  bool get canPlayWords;

  /// Cümle (ya da kart sesi) çalınabilir mi?
  bool get canPlaySentence;

  Future<void> playWord(MeaningWord word, {required double speed});

  Future<void> playSentence({required double speed});

  Future<void> stop();
}

/// Sesi olmayan metin (ör. sessiz not kartı).
class SilentMeaningAudio implements MeaningAudio {
  const SilentMeaningAudio();

  @override
  bool get canPlayWords => false;

  @override
  bool get canPlaySentence => false;

  @override
  Future<void> playWord(MeaningWord word, {required double speed}) async {}

  @override
  Future<void> playSentence({required double speed}) async {}

  @override
  Future<void> stop() async {}
}

/// Deftere ekleme sonucu (onay mesajı için).
class SaveOutcome {
  const SaveOutcome(this.item, {required this.added});

  final SavedPhrase item;
  final bool added;

  String get message => added
      ? '"${item.en}" deftere eklendi.'
      : '"${item.en}" zaten defterinde.';
}

/// Kaydedilecek ifadeyi tamamlar (ör. Kitaplık: kaynak, görsel, kitap
/// sesinden kesilmiş telaffuz; H-067). [wordIndex] seçili kelime, [chunk]
/// seçili kalıp; ikisi de yoksa cümle kaydedilir.
typedef SaveDecorator =
    SavedPhrase Function(
      SavedPhrase draft, {
      int? wordIndex,
      PhraseChunk? chunk,
    });

/// Kademeli anlam paneli durumu (H-046):
/// 1) kelimeye dokun → anlam + ses, kalıp varsa kalıbın anlamı;
/// 2) "Türkçesini göster" → cümlenin tamamı;
/// "Tekrar dinle" (0,75x seçeneği) ve "Deftere ekle".
class MeaningController extends ChangeNotifier {
  MeaningController({
    required this.text,
    required this.audio,
    required LearningEventLog events,
    required NotebookRepository notebook,
    double speed = 1.0,
    DateTime Function()? now,
    this.decorate,
  }) : _events = events,
       _notebook = notebook,
       _speed = speed,
       _now = now ?? DateTime.now;

  final MeaningText text;
  final MeaningAudio audio;

  /// Kaydı tamamlayan isteğe bağlı işlev (Kitaplık).
  final SaveDecorator? decorate;
  final LearningEventLog _events;
  final NotebookRepository _notebook;
  final DateTime Function() _now;

  /// İngilizce ses (kelime ya da "Tekrar dinle") her başladığında artar:
  /// Türkçe sesi (H-109 Faz 3) durdurmak için; iki ses aynı anda çalmaz.
  final ValueNotifier<int> englishAudioStarts = ValueNotifier(0);

  int? _selected;
  bool _revealed = false;
  double _speed;
  bool _disposed = false;

  int? get selected => _selected;
  MeaningWord? get selectedWord =>
      _selected == null ? null : text.words[_selected!];
  PhraseChunk? get selectedChunk =>
      _selected == null ? null : text.chunkAt(_selected!);
  bool get revealed => _revealed;
  double get speed => _speed;
  bool get slow => _speed < 1.0;

  /// Kelimeye dokunuldu: anlamı göster, sesini çal, olayı kaydet.
  void selectWord(int index) {
    if (index < 0 || index >= text.words.length) return;
    final w = text.words[index];
    if (w.isBlank) return;
    _selected = index;
    notifyListeners();
    if (audio.canPlayWords && w.hasTiming) {
      englishAudioStarts.value++;
      unawaited(audio.playWord(w, speed: _speed));
    }
    _record(w.bare);
  }

  /// İkinci adım: cümlenin Türkçesi.
  void reveal() {
    if (_revealed || !text.hasTurkish) return;
    _revealed = true;
    notifyListeners();
    _record(LearningEvent.sentence);
  }

  Future<void> replay() {
    englishAudioStarts.value++;
    return audio.playSentence(speed: _speed);
  }

  void toggleSlow() {
    _speed = slow ? 1.0 : 0.75;
    notifyListeners();
  }

  /// Seçili kalıp → kalıp; seçili kelime → kelime; yoksa cümle.
  Future<SaveOutcome> save() async {
    final chunk = selectedChunk;
    final word = selectedWord;
    final SavedPhrase item;
    final at = _now().toUtc();
    if (chunk != null) {
      item = SavedPhrase(
        contentId: text.contentId,
        sourceId: text.sourceId,
        kind: SavedKind.phrase,
        en: chunk.en,
        tr: chunk.tr,
        context: text.en,
        savedAt: at,
      );
    } else if (word != null) {
      item = SavedPhrase(
        contentId: text.contentId,
        sourceId: text.sourceId,
        kind: SavedKind.word,
        en: word.bare,
        tr: word.gloss,
        context: text.en,
        savedAt: at,
      );
    } else {
      item = SavedPhrase(
        contentId: text.contentId,
        sourceId: text.sourceId,
        kind: SavedKind.sentence,
        en: text.en,
        tr: text.tr,
        savedAt: at,
      );
    }
    final d = decorate;
    final saved = d == null
        ? item
        : d(item, wordIndex: chunk == null ? _selected : null, chunk: chunk);
    final added = await _notebook.add(saved);
    return SaveOutcome(saved, added: added);
  }

  void _record(String target) {
    unawaited(
      _events
          .record(
            LearningEvent(
              contentId: text.contentId,
              sourceId: text.sourceId,
              target: target,
              at: _now().toUtc(),
            ),
          )
          .catchError(
            (Object e) => debugPrint('[H046] olay kaydedilemedi: $e'),
          ),
    );
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    englishAudioStarts.dispose();
    super.dispose();
  }
}
