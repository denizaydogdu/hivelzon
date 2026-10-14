// Kitaptan Defter'e ekleme (H-067). Saf Dart.
//
// Kayıtta: kelime (ya da kalıp, cümle), Türkçesi, kitaptaki örnek cümle ve
// Türkçesi, **kitap sesinden kelime zamanıyla kesilmiş telaffuz** (ek üretim
// yok), görsel (sayfanın resmi, yoksa kapak) ve kaynak "Kitap: <başlık>, s. N"
// (başlık `sourceTitle`, sayfa cümle kimliğinden). Aynı ifade ikinci kez
// eklenmez (defter anahtarı `kind|ifade`).

import '../../../shared/content/content_source.dart' show bookMediaPath;
import '../../../shared/meaning/meaning_text.dart';
import '../../../shared/meaning/notebook_repository.dart';
import '../../notebook/domain/notebook_item.dart';
import 'book.dart';

/// Kitap kaydının görseli: sayfanın resmi, yoksa kitabın kapağı.
String? bookItemImage(Book book, int pageIndex) {
  final image = book.pages[pageIndex].image ?? book.cover;
  return image == null ? null : bookMediaPath(book.id, image);
}

/// Anlam panelinin taslağını kitap bilgisiyle tamamlar
/// (`MeaningController.decorate`).
SavedPhrase decorateBookSave(
  Book book,
  int pageIndex,
  int sentenceIndex,
  SavedPhrase draft, {
  int? wordIndex,
  PhraseChunk? chunk,
}) {
  final s = book.sentenceAt(pageIndex, sentenceIndex);
  final chapter = book.chapterOf(book.pages[pageIndex]);
  final audioPath = chapter.audio == null
      ? null
      : bookMediaPath(book.id, chapter.audio!);
  MediaClip? clip(double? start, double? end) =>
      audioPath == null || start == null || end == null || end <= start
      ? null
      : MediaClip(audioPath, start: start, end: end);
  final sentenceClip = clip(s.start, s.end);
  MediaClip? own;
  if (chunk != null &&
      chunk.startWord < s.words.length &&
      chunk.endWord < s.words.length) {
    own = clip(s.words[chunk.startWord].start, s.words[chunk.endWord].end);
  } else if (wordIndex != null && wordIndex < s.words.length) {
    own = clip(s.words[wordIndex].start, s.words[wordIndex].end);
  } else if (draft.kind == SavedKind.sentence) {
    own = sentenceClip;
  }
  final isSentence = draft.kind == SavedKind.sentence;
  return draft.copyWith(
    source: NotebookSource.book,
    sourceTitle: book.title,
    contextTr: isSentence ? null : s.tr,
    imagePath: bookItemImage(book, pageIndex),
    audio: own,
    contextAudio: isSentence ? null : sentenceClip,
  );
}

/// Kelimeye uzun basınca tek dokunuşla ekleme (panel açılmaz). Kelimenin
/// içinde olduğu kalıp değil, kelimenin kendisi eklenir.
SavedPhrase bookWordSave(
  Book book,
  int pageIndex,
  int sentenceIndex,
  int wordIndex, {
  required DateTime now,
}) {
  final s = book.sentenceAt(pageIndex, sentenceIndex);
  final w = s.words[wordIndex];
  final draft = SavedPhrase(
    contentId: book.id,
    sourceId: s.id,
    kind: SavedKind.word,
    en: w.bare,
    tr: w.gloss,
    context: s.text,
    savedAt: now.toUtc(),
  );
  return decorateBookSave(
    book,
    pageIndex,
    sentenceIndex,
    draft,
    wordIndex: wordIndex,
  );
}
