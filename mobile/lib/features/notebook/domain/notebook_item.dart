// Defter kartının modeli (H-036). Saf Dart.

import '../../../shared/fsrs/fsrs.dart';
import 'review_policy.dart';

/// [rule]: dilbilgisi kural kartı (H-078). `textEn`/`textTr` kuralın
/// örneği ve Türkçesi (tekrarda sorulan), `exampleTr` kuralın kendisi
/// (Türkçe); `sourceTitle` dersin başlığı.
enum NotebookKind { word, phrase, sentence, rule }

/// Kart nereden geldi.
enum NotebookSource {
  /// Bitirilen bölümün hedef ifadesi (otomatik).
  autoTargetPhrase('auto_target_phrase'),

  /// Anlam panelinde "Deftere ekle".
  userSaved('user_saved'),

  /// Bölümde anlamına bakılan kelime (öğrenme olayı).
  lookup('lookup'),

  /// Konu setinden eklenen kelime (H-051: "Hepsini defterime ekle" ya da tek tek).
  topicSet('topic_set'),

  /// Kitaplık'ta okunan kitaptan eklenen ifade (H-067).
  book('book'),

  /// Dilbilgisi dersinin kural kartı (H-078: "Deftere kural kartı ekle").
  grammar('grammar');

  const NotebookSource(this.code);

  final String code;

  static NotebookSource parse(String v) =>
      values.firstWhere((s) => s.code == v, orElse: () => userSaved);
}

/// Bölüm paketindeki ses: segment videosundan bir aralık ya da tek dosya.
class MediaClip {
  const MediaClip(this.path, {this.start, this.end});

  final String path;

  /// Saniye (segmentin başına göre). Yoksa dosyanın tamamı çalınır.
  final double? start;
  final double? end;

  bool get isRange => start != null && end != null && end! > start!;

  Duration get length => isRange
      ? Duration(milliseconds: ((end! - start!) * 1000).round())
      : Duration.zero;
}

/// Defterdeki bir kelime, kalıp ya da cümle.
class NotebookItem {
  const NotebookItem({
    this.id,
    required this.kind,
    required this.textEn,
    required this.source,
    this.textTr,
    this.exampleEn,
    this.exampleTr,
    this.contentId,
    this.cueId,
    this.imagePath,
    this.imageCrop,
    this.audio,
    this.exampleAudio,
    this.createdAt,
    this.sourceTitle,
  });

  final int? id;
  final NotebookKind kind;
  final String textEn;
  final String? textTr;
  final String? exampleEn;
  final String? exampleTr;
  final String? contentId;
  final String? cueId;

  /// `stills/…webp` (bölüm paketinde; H-054 öncesi kayıtlarda `.jpg`).
  final String? imagePath;

  /// Normalleştirilmiş kırpma `x,y,w,h` (0–1); yoksa görselin tamamı.
  final String? imageCrop;

  /// İfadenin kendisi (karakterin sesi).
  final MediaClip? audio;

  /// Örnek cümlenin tamamı (aynı dosyada).
  final MediaClip? exampleAudio;
  final NotebookSource source;

  /// Kaynağın adı: kitaptan eklenende kitabın başlığı (H-067).
  final String? sourceTitle;

  /// UTC.
  final DateTime? createdAt;

  String get key => itemKey(kind, textEn);

  bool get hasAudio => audio != null;

  /// Dilbilgisi kural kartının kuralı (Türkçe); başka kartta null.
  String? get ruleTr => kind == NotebookKind.rule ? exampleTr : null;

  /// Bölüm etiketi: `A1-004` → `B4`.
  String? get episodeTag {
    final n = episodeNumber;
    return n == null ? null : 'B$n';
  }

  /// Bölüm numarası (`A1-004` → 4); bölümden gelmiyorsa null.
  int? get episodeNumber {
    if (source == NotebookSource.book || source == NotebookSource.grammar) {
      return null;
    }
    final m = RegExp(r'-(\d{3})$').firstMatch(contentId ?? '');
    return m == null ? null : int.parse(m.group(1)!);
  }

  /// Kitaptaki sayfa numarası (`cueId` `p03-s01` → 3); kitaptan değilse null.
  int? get bookPage {
    if (source != NotebookSource.book) return null;
    final m = RegExp(r'^p(\d{2,3})').firstMatch(cueId ?? '');
    return m == null ? null : int.parse(m.group(1)!);
  }

  /// Eksik görsel/ses bilgisini [other]'dan tamamlar (var olan alanlara dokunmaz).
  NotebookItem fillFrom(NotebookItem other) => NotebookItem(
    id: id,
    kind: kind,
    textEn: textEn,
    source: source,
    textTr: textTr ?? other.textTr,
    exampleEn: exampleEn ?? other.exampleEn,
    exampleTr: exampleTr ?? other.exampleTr,
    contentId: contentId ?? other.contentId,
    cueId: cueId ?? other.cueId,
    imagePath: imagePath ?? other.imagePath,
    imageCrop: imageCrop ?? other.imageCrop,
    audio: audio ?? other.audio,
    exampleAudio: exampleAudio ?? other.exampleAudio,
    sourceTitle: sourceTitle ?? other.sourceTitle,
    createdAt: createdAt,
  );
}

/// Kartın FSRS durumu (veritabanındaki `review_cards` satırı).
class ReviewCardState {
  const ReviewCardState({
    required this.id,
    required this.itemId,
    required this.fsrs,
    this.reps = 0,
    this.lapses = 0,
  });

  final int id;
  final int itemId;
  final FsrsCard fsrs;
  final int reps;
  final int lapses;

  bool get isNew => reps == 0;

  CardStage get stage => CardStage(
    reps: reps,
    state: fsrs.state,
    stability: fsrs.stability,
    lapses: lapses,
  );

  ReviewCardState copyWith({FsrsCard? fsrs, int? reps, int? lapses}) =>
      ReviewCardState(
        id: id,
        itemId: itemId,
        fsrs: fsrs ?? this.fsrs,
        reps: reps ?? this.reps,
        lapses: lapses ?? this.lapses,
      );
}

/// Defter listesindeki satır: ifade + kartı.
class NotebookEntry {
  const NotebookEntry(this.item, this.card);

  final NotebookItem item;
  final ReviewCardState card;
}

String itemKey(NotebookKind kind, String en) =>
    '${kind.name}|${normalizeEn(en)}';

/// Bölümün hedef ifadesinin defterdeki türü (deste kuralı): birden çok
/// kelime → kalıp, tek kelime → kelime. Hikâye içi "Söyle" kanıtı (H-093)
/// aynı anahtarı buradan hesaplar.
NotebookKind targetPhraseKind(String phrase) =>
    wordCount(phrase) > 1 ? NotebookKind.phrase : NotebookKind.word;

/// Hedef ifadenin defter anahtarı (bölüm bitince oluşan kartla aynı).
String targetPhraseKey(String phrase) =>
    itemKey(targetPhraseKind(phrase), phrase);

/// Karşılaştırma için İngilizce: küçük harf, tipografik kesme → `'`,
/// noktalama yok (`…` korunur), tek boşluk.
String normalizeEn(String s) {
  final t = s
      .toLowerCase()
      .replaceAll('’', "'")
      .replaceAll('...', '…')
      .replaceAll(RegExp(r"[^\p{L}\p{N}'…\s]", unicode: true), ' ')
      .replaceAll(RegExp(r'\s*…\s*'), '… ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  return t;
}

/// Kelime sayısı (`…` sayılmaz).
int wordCount(String s) => normalizeEn(
  s,
).replaceAll('…', ' ').split(' ').where((w) => w.isNotEmpty).length;
