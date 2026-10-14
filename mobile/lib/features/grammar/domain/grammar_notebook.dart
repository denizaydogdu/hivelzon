// Dilbilgisi dersinden Defter'e (H-078). Saf Dart.

import '../../../shared/content/content_source.dart' show grammarMediaPath;
import '../../../shared/meaning/meaning_controller.dart' show SaveDecorator;
import '../../../shared/meaning/notebook_repository.dart';
import '../../notebook/domain/notebook_item.dart';
import 'grammar_lesson.dart';

/// Kural kartı: kural (Türkçe), bir örnek ve Türkçesi. FSRS tekrarına girer;
/// tekrarda örnek cümle sorulur (dizme, dinle-seç, yazma). Kaynak satırı
/// "Dilbilgisi: başlık". Kural kartı yoksa null.
NotebookItem? ruleNotebookItem(GrammarLesson lesson, {DateTime? now}) {
  final card = lesson.ruleCard;
  final example = card?.examples.firstOrNull;
  if (card == null || example == null) return null;
  return NotebookItem(
    kind: NotebookKind.rule,
    textEn: example.en,
    textTr: example.tr,
    exampleTr: card.narration?.text,
    contentId: lesson.id,
    cueId: card.id,
    source: NotebookSource.grammar,
    sourceTitle: lesson.titleTr,
    audio: example.audio == null
        ? null
        : MediaClip(grammarMediaPath(lesson.id, example.audio!)),
    createdAt: now?.toUtc(),
  );
}

/// Anlam panelinde "Deftere ekle" (örnek cümleden): kaynak dersin adı,
/// cümlenin Türkçesi ve örneğin sesi (kelimede aralık, cümlede dosyanın
/// tamamı).
SaveDecorator decorateGrammarSave(GrammarLesson lesson, GrammarExample e) =>
    (draft, {wordIndex, chunk}) {
      final path = e.audio == null
          ? null
          : grammarMediaPath(lesson.id, e.audio!);
      MediaClip? word;
      if (path != null && wordIndex != null && wordIndex < e.words.length) {
        final w = e.words[wordIndex];
        if (w.hasTiming) word = MediaClip(path, start: w.start, end: w.end);
      }
      final whole = path == null ? null : MediaClip(path);
      final sentence = draft.kind == SavedKind.sentence;
      return draft.copyWith(
        source: NotebookSource.grammar,
        sourceTitle: lesson.titleTr,
        contextTr: sentence ? null : e.tr,
        audio: sentence ? whole : word,
        contextAudio: sentence ? null : whole,
      );
    };
