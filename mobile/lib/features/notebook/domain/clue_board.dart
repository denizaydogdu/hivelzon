// İpucu panosu (H-036): açılan ipuçları ve açık sorular. Saf Dart.
//
// Spoiler'sız: yalnızca biten bölümlerin bağları ve görülen ipucu kartları
// kullanılır. Açık sorular `episode.links` alanlarından türetilir
// (`openQuestion` açar, `answers` kapatır; `Qn:partial` kısmi cevaptır).

class ClueItem {
  const ClueItem({
    required this.contentId,
    required this.clueId,
    required this.textTr,
    required this.unlockedAt,
  });

  final String contentId;
  final String clueId;
  final String textTr;
  final DateTime unlockedAt;
}

/// Biten bir bölümün bağ kaydı.
class StoryLinkRecord {
  const StoryLinkRecord({
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

class OpenQuestion {
  const OpenQuestion({
    required this.id,
    required this.textTr,
    required this.openedIn,
    required this.openedNumber,
    this.partialNote,
  });

  final String id;
  final String textTr;
  final String openedIn;
  final int openedNumber;

  /// Kısmi cevap (ör. "limanda"); yoksa null.
  final String? partialNote;
}

/// En çok kaç açık soru gösterilir (OYUN-TASARIMI §4.3).
const int kMaxOpenQuestions = 3;

/// Açık sorular: en yenisi önce, en çok [max].
List<OpenQuestion> deriveOpenQuestions(
  Iterable<StoryLinkRecord> links, {
  int max = kMaxOpenQuestions,
}) {
  final sorted = links.toList()..sort((a, b) => a.number.compareTo(b.number));
  final opened = <String, OpenQuestion>{};
  final closed = <String>{};
  final partial = <String, String>{};
  for (final l in sorted) {
    if (l.openQuestionId.isNotEmpty && l.openQuestionTr != null) {
      opened[l.openQuestionId] = OpenQuestion(
        id: l.openQuestionId,
        textTr: l.openQuestionTr!,
        openedIn: l.contentId,
        openedNumber: l.number,
      );
    }
    for (final a in l.answers) {
      final i = a.indexOf(':');
      if (i < 0) {
        closed.add(a);
      } else if (a.substring(i + 1) == 'partial') {
        final q = a.substring(0, i);
        partial[q] = l.partialNotes[q] ?? 'kısmen cevaplandı';
      }
    }
  }
  final out = [
    for (final q in opened.values)
      if (!closed.contains(q.id))
        OpenQuestion(
          id: q.id,
          textTr: q.textTr,
          openedIn: q.openedIn,
          openedNumber: q.openedNumber,
          partialNote: partial[q.id],
        ),
  ]..sort((a, b) => b.openedNumber.compareTo(a.openedNumber));
  return out.take(max).toList();
}

/// İpuçları bölüm bölüm (bölüm sırası artan, ipucu sırası korunur).
Map<String, List<ClueItem>> cluesByEpisode(Iterable<ClueItem> clues) {
  final out = <String, List<ClueItem>>{};
  final list = clues.toList()
    ..sort((a, b) {
      final c = a.contentId.compareTo(b.contentId);
      return c != 0 ? c : _n(a.clueId).compareTo(_n(b.clueId));
    });
  for (final c in list) {
    out.putIfAbsent(c.contentId, () => []).add(c);
  }
  return out;
}

int _n(String id) => int.tryParse(id.replaceAll(RegExp(r'\D'), '')) ?? 0;
