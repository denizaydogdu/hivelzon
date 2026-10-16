// Öğrenme kanıtı basamakları (H-089). Saf Dart.
//
// Her ifade için dört basamak: Gördü → Yardımla yaptı → Kendi kullandı →
// Birkaç gün sonra hatırladı. Yalnızca basamak ve ilk ulaşıldığı an tutulur
// (`expression_evidence`: ifade anahtarı, basamak, an); içerik metni, ses ya
// da tanıma yazısı tutulmaz. Kurallar: `docs/KELIME-TEKRARI.md` §3.

import '../../../shared/fsrs/fsrs.dart';
import 'notebook_item.dart';
import 'review_policy.dart';
import 'review_session.dart';

/// Basamaklar, küçükten büyüğe.
enum EvidenceStage {
  /// Gördü: ifade deftere girdi (bölüm sonu, anlamına bakma, kaydetme, konu
  /// seti, kitap, dilbilgisi). Ayrıca saklanmaz; defterdeki ifadenin
  /// eklenme anıdır.
  seen('seen'),

  /// Yardımla yaptı: ilk başarılı pratik (seçenekten seçme, dinleyip seçme,
  /// kelimeleri dizme, dinleyip tekrar etme, sahne avında kendin bulma).
  helped('helped'),

  /// Kendi kullandı: Türkçe anlamdan, sesi duymadan ve seçenek görmeden
  /// İngilizcesini yazdı ya da söyledi ve sonuç denetlendi (yazma doğru;
  /// söylemede tam ya da yalnız bir kelime duyulmadı). İfade bölümdeki
  /// sahnesinden ayrı, yeni bir bağlamda (resim + Türkçe anlam) üretilir.
  ownUse('own_use'),

  /// Birkaç gün sonra hatırladı: uzun vade kartında (pratikle ısınmadan)
  /// yardımsız hatırlama başarılı ve ifade en az [EvidenceRules.laterAfter]
  /// önce görüldü. Kendini yoklama ("Bildim") da sayılır.
  recalledLater('recalled_later');

  const EvidenceStage(this.code);

  final String code;

  static EvidenceStage? parse(String code) {
    for (final s in values) {
      if (s.code == code) return s;
    }
    return null;
  }
}

/// Bir ifadenin kanıtları: basamak → ilk ulaşıldığı an (UTC).
class ExpressionEvidence {
  const ExpressionEvidence({required this.seenAt, this.reached = const {}});

  final DateTime seenAt;

  /// Saklanan basamaklar (`seen` dışında).
  final Map<EvidenceStage, DateTime> reached;

  /// En yüksek basamak (basamaklar sırayla gelmek zorunda değildir: kendini
  /// yoklamayla "sonra hatırladı" denetlenen üretimden önce gelebilir).
  EvidenceStage get highest {
    var h = EvidenceStage.seen;
    for (final s in reached.keys) {
      if (s.index > h.index) h = s;
    }
    return h;
  }

  bool has(EvidenceStage s) => s == EvidenceStage.seen || reached[s] != null;
}

abstract final class EvidenceRules {
  /// "Birkaç gün sonra": ilk görüldükten en az 2 gün sonra.
  static const Duration laterAfter = Duration(days: 2);

  /// Bir tekrar sonucunun ulaştırdığı basamaklar ([seenAt]: ifadenin deftere
  /// eklendiği an). Var olan basamaklar yazılırken korunur (ilk an kalır).
  static Set<EvidenceStage> fromOutcome(
    ReviewOutcome o, {
    required DateTime seenAt,
  }) => fromResult(
    taskType: o.taskType,
    correct: o.correct,
    rating: o.rating,
    stateBefore: o.before.isNew ? null : o.before.fsrs.state,
    at: o.reviewedAt,
    seenAt: seenAt,
  );

  /// [rating] null → pratik. [stateBefore] null → kart yeniydi.
  static Set<EvidenceStage> fromResult({
    required TaskType taskType,
    required bool correct,
    required FsrsRating? rating,
    required FsrsState? stateBefore,
    required DateTime at,
    required DateTime seenAt,
  }) {
    if (!correct) return const {};
    if (rating == null || !taskType.isRecall) {
      return const {EvidenceStage.helped};
    }
    if (rating == FsrsRating.again) return const {};
    return {
      if (taskType.isCheckedProduction) EvidenceStage.ownUse,
      if (stateBefore == FsrsState.review &&
          !at.toUtc().isBefore(seenAt.toUtc().add(laterAfter)))
        EvidenceStage.recalledLater,
    };
  }
}

/// Profil için kanıta dayalı küçük özet (H-089). Listeler en yeniden eskiye.
class EvidenceSummary {
  const EvidenceSummary({
    this.recalledLater = const [],
    this.ownUse = const [],
    this.helped = const [],
    this.revisit = const [],
    this.total = 0,
  });

  static const empty = EvidenceSummary();

  /// En yüksek basamağı "sonra hatırladı" olan ifadeler.
  final List<NotebookItem> recalledLater;

  /// En yüksek basamağı "kendi kullandı" olanlar.
  final List<NotebookItem> ownUse;

  /// En yüksek basamağı "yardımla yaptı" olanlar.
  final List<NotebookItem> helped;

  /// Yeniden çalışılacaklar: son hatırlamada gelmedi (yeniden öğrenmede).
  final List<NotebookItem> revisit;

  /// Defterdeki ifade sayısı.
  final int total;

  bool get hasEvidence =>
      recalledLater.isNotEmpty || ownUse.isNotEmpty || helped.isNotEmpty;
}

/// Defter + kanıtlar → özet. [evidence]: ifade anahtarı → basamak → an.
EvidenceSummary summarizeEvidence(
  List<NotebookEntry> entries,
  Map<String, Map<EvidenceStage, DateTime>> evidence,
) {
  final recalled = <(DateTime, NotebookItem)>[];
  final own = <(DateTime, NotebookItem)>[];
  final helped = <(DateTime, NotebookItem)>[];
  final revisit = <(DateTime, NotebookItem)>[];
  for (final e in entries) {
    final reached = evidence[e.item.key] ?? const {};
    final ev = ExpressionEvidence(
      seenAt: e.item.createdAt ?? DateTime.utc(1970),
      reached: reached,
    );
    final h = ev.highest;
    if (h != EvidenceStage.seen) {
      final at = reached[h]!;
      (switch (h) {
        EvidenceStage.recalledLater => recalled,
        EvidenceStage.ownUse => own,
        _ => helped,
      }).add((at, e.item));
    }
    // Yeniden öğrenmedeki ya da tekrar edilmiş ama hâlâ öğrenmedeki kart:
    // son hatırlamada gelmedi.
    final c = e.card;
    if (!c.isNew &&
        (c.fsrs.state == FsrsState.relearning ||
            c.fsrs.state == FsrsState.learning)) {
      revisit.add((c.fsrs.lastReview ?? c.fsrs.due, e.item));
    }
  }
  List<NotebookItem> sorted(List<(DateTime, NotebookItem)> l) {
    l.sort((a, b) => b.$1.compareTo(a.$1));
    return [for (final (_, i) in l) i];
  }

  return EvidenceSummary(
    recalledLater: sorted(recalled),
    ownUse: sorted(own),
    helped: sorted(helped),
    revisit: sorted(revisit),
    total: entries.length,
  );
}
