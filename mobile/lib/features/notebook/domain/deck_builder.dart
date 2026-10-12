// Biten bölümden defter kartları, ipuçları ve bölüm bağları çıkarır (H-036).
// Saf Dart: girdi bölüm paketi (`scenes.json` + `subs/*.en.json`), çıktı
// veritabanına yazılacak taslaklar.

import '../../../shared/meaning/learning_event_log.dart';
import '../../player/domain/episode.dart';
import '../../player/domain/subtitles.dart';
import 'notebook_item.dart';

/// Ana yoldaki (ve yan daldaki) segmentlerin altyazıları: düğüm kimliği → iz.
typedef SubtitleIndex = Map<String, SubtitleTrack>;

/// Bakılan kelimenin sözlük anahtarı: küçük harf, düz kesme işareti, baştaki
/// ve sondaki noktalama atılır.
String glossaryKey(String w) => _bare(w.trim());

class DeckBuildResult {
  const DeckBuildResult(this.items, {this.skipped = const []});

  final List<NotebookItem> items;

  /// Türkçe anlamı bulunamadığı için atlanan hedef ifadeler.
  final List<String> skipped;
}

class ClueDraft {
  const ClueDraft({required this.clueId, required this.textTr, this.textEn});

  final String clueId;
  final String textTr;
  final String? textEn;
}

class StoryLinkDraft {
  const StoryLinkDraft({
    required this.contentId,
    required this.number,
    required this.openQuestionId,
    this.openQuestionTr,
    this.answers = const [],
    this.partialNotes = const {},
  });

  final String contentId;
  final int number;
  final String openQuestionId;
  final String? openQuestionTr;
  final List<String> answers;
  final Map<String, String> partialNotes;
}

/// Bölümün hedef ifadeleri ve bakılan kelimeler → defter kartları.
///
/// - Ses: karakterin kendi sesi (segment videosundan kelime zamanlarıyla
///   kesilir); altyazıda yoksa karar seçeneğinin ses dosyası.
/// - Örnek cümle: ifadenin geçtiği altyazı satırı (+ onaylı Türkçesi).
/// - Görsel: satırın segmentine en yakın sahne görseli (`stills/`).
/// - Türkçe anlam: `targetPhraseGloss`, yoksa satırın kalıp/kelime anlamı.
/// - Altyazıda ve karar anında geçmeyen hedef ifade (ör. B1 *Listen.*):
///   görsel + anlam, ses yok (H-052).
/// - Bakılan kelime yalnızca bölüm sözlüğündeyse (`episode.glossary`) karta
///   dönüşür (H-052).
DeckBuildResult buildEpisodeDeck(
  Episode episode, {
  required SubtitleIndex subtitles,
  List<LearningEvent> lookups = const [],
  DateTime? now,
}) {
  final info = episode.info;
  final at = (now ?? DateTime.now()).toUtc();
  final order = _segmentOrder(episode);
  final items = <NotebookItem>[];
  final keys = <String>{};
  final skipped = <String>[];

  void add(NotebookItem item) {
    if (keys.add(item.key)) items.add(item);
  }

  for (final phrase in info.targetPhrases) {
    final gloss = info.targetPhraseGloss[phrase];
    final hit = _findCue(order, subtitles, phrase);
    final kind = wordCount(phrase) > 1
        ? NotebookKind.phrase
        : NotebookKind.word;
    if (hit != null) {
      final (node, cue, from, to) = hit;
      final tr = gloss?.tr ?? _cueMeaning(cue, from, to);
      if (tr == null) {
        skipped.add(phrase);
        continue;
      }
      add(
        NotebookItem(
          kind: kind,
          textEn: phrase,
          textTr: tr,
          exampleEn: cue.text,
          exampleTr: cue.tr,
          contentId: info.id,
          cueId: cue.id,
          imagePath: imageNear(episode, node.id),
          audio: MediaClip(
            node.video,
            start: cue.words[from].start,
            end: cue.words[to].end,
          ),
          exampleAudio: MediaClip(
            node.video,
            start: cue.words.first.start,
            end: cue.words.last.end,
          ),
          source: NotebookSource.autoTargetPhrase,
          createdAt: at,
        ),
      );
      continue;
    }
    // Altyazıda yoksa: bu ifadeyi hedefleyen karar anı (doğru seçeneğin sesi).
    final decision = episode.nodes.values
        .whereType<DecisionNode>()
        .where((d) => d.targetPhrase == phrase)
        .firstOrNull;
    final option = decision?.options.where((o) => o.correct).firstOrNull;
    final tr = gloss?.tr;
    if (tr == null) {
      skipped.add(phrase);
      continue;
    }
    if (decision == null || option == null) {
      // Ne altyazıda ne karar anında: görsel + anlam; ses sonra (H-052).
      add(
        NotebookItem(
          kind: kind,
          textEn: phrase,
          textTr: tr,
          contentId: info.id,
          imagePath: imageNear(episode, episode.start),
          source: NotebookSource.autoTargetPhrase,
          createdAt: at,
        ),
      );
      continue;
    }
    add(
      NotebookItem(
        kind: kind,
        textEn: phrase,
        textTr: tr,
        exampleEn: option.text,
        contentId: info.id,
        cueId: decision.id,
        imagePath: decision.background ?? imageNear(episode, decision.id),
        audio: option.audio == null ? null : MediaClip(option.audio!),
        exampleAudio: option.audio == null ? null : MediaClip(option.audio!),
        source: NotebookSource.autoTargetPhrase,
        createdAt: at,
      ),
    );
  }

  final glossary = {for (final g in info.glossary) glossaryKey(g.word): g};
  for (final e in lookups) {
    if (e.contentId != info.id || e.target == LearningEvent.sentence) continue;
    final word = glossaryKey(e.target);
    final entry = glossary[word];
    if (entry == null) continue;
    final found = _findCueById(order, subtitles, e.sourceId);
    if (found == null) continue;
    final (node, cue) = found;
    final i = cue.words.indexWhere((w) => _bare(w.w) == word);
    if (i < 0) continue;
    final w = cue.words[i];
    final tr = w.gloss ?? entry.tr;
    if (tr == null) continue;
    add(
      NotebookItem(
        kind: NotebookKind.word,
        textEn: _bareDisplay(w.w, sentenceStart: i == 0),
        textTr: tr,
        exampleEn: cue.text,
        exampleTr: cue.tr,
        contentId: info.id,
        cueId: cue.id,
        imagePath: imageNear(episode, node.id),
        audio: MediaClip(node.video, start: w.start, end: w.end),
        exampleAudio: MediaClip(
          node.video,
          start: cue.words.first.start,
          end: cue.words.last.end,
        ),
        source: NotebookSource.lookup,
        createdAt: at,
      ),
    );
  }
  return DeckBuildResult(items, skipped: skipped);
}

/// Kullanıcının kaydettiği ifadeyi bölüm verisiyle zenginleştirir (görsel,
/// ses, örnek). Satır bulunamazsa eldeki bilgiyle döner.
NotebookItem enrichSaved(
  NotebookItem item,
  Episode episode, {
  required SubtitleIndex subtitles,
}) {
  final order = _segmentOrder(episode);
  final byId = item.cueId == null
      ? null
      : _findCueById(order, subtitles, item.cueId!);
  final hit = byId != null
      ? _rangeIn(byId, item.textEn)
      : _findCue(order, subtitles, item.textEn);
  if (hit == null) {
    final node = item.cueId == null ? null : episode.nodes[item.cueId!];
    return item.fillFrom(
      NotebookItem(
        kind: item.kind,
        textEn: item.textEn,
        source: item.source,
        imagePath: imageNear(episode, node?.id ?? episode.start),
      ),
    );
  }
  final (node, cue, from, to) = hit;
  return item.fillFrom(
    NotebookItem(
      kind: item.kind,
      textEn: item.textEn,
      source: item.source,
      exampleEn: cue.text,
      exampleTr: cue.tr,
      imagePath: imageNear(episode, node.id),
      audio: MediaClip(
        node.video,
        start: cue.words[from].start,
        end: cue.words[to].end,
      ),
      exampleAudio: MediaClip(
        node.video,
        start: cue.words.first.start,
        end: cue.words.last.end,
      ),
    ),
  );
}

/// Bölüm sonu ipucu kartından ipuçları (`C1 · Telsiz mesajı`).
List<ClueDraft> extractClues(Episode episode) {
  final out = <String, ClueDraft>{};
  final line = RegExp(r'^(C\d+)\s*·\s*(.+)$');
  final ids = <String>{...episode.info.links.cluesUnlocked};
  for (final n in episode.nodes.values.whereType<CardNode>()) {
    if (n.kind != CardKind.clue) continue;
    ids.addAll(n.clueIds);
    for (final l in n.lines) {
      final m = line.firstMatch(l.text.trim());
      if (m == null) continue;
      out[m.group(1)!] = ClueDraft(
        clueId: m.group(1)!,
        textTr: m.group(2)!.trim(),
        textEn: l.lang == Lang.en ? m.group(2)!.trim() : null,
      );
    }
  }
  for (final id in ids) {
    out.putIfAbsent(id, () => ClueDraft(clueId: id, textTr: 'İpucu $id'));
  }
  final list = out.values.toList()
    ..sort((a, b) => _num(a.clueId).compareTo(_num(b.clueId)));
  return list;
}

/// Bölümün bağları: açtığı soru (spoiler'sız metniyle) ve cevapladıkları.
StoryLinkDraft extractStoryLinks(Episode episode) {
  final info = episode.info;
  final q = info.links.openQuestion;
  String? text;
  final partial = <String, String>{};
  final partialLine = RegExp(r'^(Q\d+)\s+kısmen cevaplandı:\s*(.+)$');
  for (final n in episode.nodes.values.whereType<CardNode>()) {
    if (n.kind == CardKind.openQuestion && (n.questionId ?? q) == q) {
      text ??= n.lines
          .where((l) => l.style == 'heading' && l.lang == Lang.tr)
          .firstOrNull
          ?.text;
    }
    if (n.kind == CardKind.clue) {
      for (final l in n.lines) {
        final m = partialLine.firstMatch(l.text.trim());
        if (m != null) partial[m.group(1)!] = m.group(2)!.trim();
      }
    }
  }
  return StoryLinkDraft(
    contentId: info.id,
    number: info.number,
    openQuestionId: q,
    openQuestionTr: text,
    answers: info.links.answers,
    partialNotes: partial,
  );
}

/// Bir düğüme en yakın sahne görseli: karar anının sonucuysa o anın görseli;
/// değilse ileriye (`next` zinciri, en çok 5 adım), sonra dosyada geriye;
/// yoksa bölümdeki ilk görsel.
String? imageNear(Episode episode, String nodeId) {
  String? bg(EpisodeNode? n) => switch (n) {
    DecisionNode(:final background) => background,
    CardNode(:final background) => background,
    TaskNode(:final background) => background,
    _ => null,
  };
  String? next(EpisodeNode? n) => switch (n) {
    SegmentNode(:final next) => next,
    CardNode(:final next) => next,
    TaskNode(:final next) => next,
    ReactionNode(:final next) => next,
    _ => null,
  };
  // Karar anının sonucu olan segment: o anın görseli (aynı sahne).
  for (final d in episode.nodes.values.whereType<DecisionNode>()) {
    if (d.background != null && d.options.any((o) => o.next == nodeId)) {
      return d.background;
    }
  }
  String? id = nodeId;
  for (var i = 0; i < 6 && id != null; i++) {
    final n = episode.nodes[id];
    final b = bg(n);
    if (b != null) return b;
    id = next(n);
  }
  final idx = episode.nodeOrder.indexOf(nodeId);
  for (var j = idx - 1; j >= 0; j--) {
    final b = bg(episode.nodes[episode.nodeOrder[j]]);
    if (b != null) return b;
  }
  for (final n in episode.nodes.values) {
    final b = bg(n);
    if (b != null) return b;
  }
  return null;
}

/// Sözcük sırasını taşıyan segmentler: önce ana yol, sonra yan dallar.
/// Tepki (yanlış cevap) ve başlık/özet videoları alınmaz.
List<SegmentNode> _segmentOrder(Episode episode) {
  final out = <SegmentNode>[];
  final seen = <String>{};
  String? id = episode.start;
  while (id != null && seen.add(id)) {
    final n = episode.nodes[id];
    if (n is SegmentNode && n is! TitleNode && n is! RecapNode) out.add(n);
    id = switch (n) {
      SegmentNode(:final next) => next,
      CardNode(:final next) => next,
      TaskNode(:final next) => next,
      ReactionNode(:final next) => next,
      DecisionNode(:final options) =>
        options.where((o) => o.correct).firstOrNull?.next,
      null => null,
    };
  }
  for (final n in episode.nodes.values) {
    if (n is SegmentNode &&
        n is! TitleNode &&
        n is! RecapNode &&
        !seen.contains(n.id)) {
      out.add(n);
    }
  }
  return out;
}

typedef _CueHit = (SegmentNode, SubtitleCue, int, int);

/// İfadenin geçtiği ilk satır; satırın tamamı ifadeyse o tercih edilir.
_CueHit? _findCue(List<SegmentNode> order, SubtitleIndex subs, String phrase) {
  _CueHit? first;
  for (final node in order) {
    final track = subs[node.id];
    if (track == null) continue;
    for (final cue in track.cues) {
      final hit = _rangeIn((node, cue), phrase);
      if (hit == null) continue;
      final (_, _, from, to) = hit;
      if (from == 0 && to == cue.words.length - 1) return hit;
      first ??= hit;
    }
  }
  return first;
}

_CueHit? _rangeIn((SegmentNode, SubtitleCue) at, String phrase) {
  final (node, cue) = at;
  if (cue.words.isEmpty) return null;
  final idx = targetWordIndexes(cue, [phrase]).toList()..sort();
  if (idx.isEmpty) return null;
  var to = idx.first;
  while (idx.contains(to + 1)) {
    to++;
  }
  return (node, cue, idx.first, to);
}

(SegmentNode, SubtitleCue)? _findCueById(
  List<SegmentNode> order,
  SubtitleIndex subs,
  String cueId,
) {
  for (final node in order) {
    for (final cue in subs[node.id]?.cues ?? const <SubtitleCue>[]) {
      if (cue.id == cueId) return (node, cue);
    }
  }
  return null;
}

/// Satırın ifadeye denk gelen anlamı: kalıp, satırın tamamı ya da tek kelime.
String? _cueMeaning(SubtitleCue cue, int from, int to) {
  for (final c in cue.chunks) {
    if (c.startWord == from && c.endWord == to) return c.tr;
  }
  if (from == 0 && to == cue.words.length - 1 && cue.hasTurkish) return cue.tr;
  if (from == to) return cue.words[from].gloss;
  return null;
}

String _bare(String w) => w
    .toLowerCase()
    .replaceAll('’', "'")
    .replaceAll(RegExp(r"^[^\p{L}\p{N}]+|[^\p{L}\p{N}]+$", unicode: true), '');

const _alwaysCapital = {
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday',
  'january',
  'february',
  'march',
  'april',
  'may',
  'june',
  'july',
  'august',
  'september',
  'october',
  'november',
  'december',
  'i',
};

/// Kartta görünen kelime: noktalamasız; cümle başındaki büyük harf atılır
/// (gün, ay ve "I" hariç).
String _bareDisplay(String w, {required bool sentenceStart}) {
  final b = w.replaceAll(
    RegExp(r"^[^\p{L}\p{N}]+|[^\p{L}\p{N}]+$", unicode: true),
    '',
  );
  if (!sentenceStart || b.isEmpty || _alwaysCapital.contains(b.toLowerCase())) {
    return b;
  }
  return b[0].toLowerCase() + b.substring(1);
}

int _num(String id) => int.tryParse(id.replaceAll(RegExp(r'\D'), '')) ?? 0;
