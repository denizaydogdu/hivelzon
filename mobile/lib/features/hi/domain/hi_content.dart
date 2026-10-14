// Hi-A içerik verisi (H-048): sezon paketindeki `hi.json`. Saf Dart.
//
// Kaynak: `icerik/_evren/hata-katalogu.json`, `konu-tanitimlari.json`,
// `kopru-gorevleri.json` ve onaylı çevirilerden üretilen "Bu ne demek?"
// dizini (`tools/content-pipeline/hvpipeline/hi.py`). Yapay zekâ yok.

import '../../../shared/meaning/error_taxonomy.dart';
import '../../notebook/domain/notebook_item.dart';

/// Hata kataloğundaki not ("Hi'nin notu"; Türkçeye göre koçluk, F1).
class ErrorNote {
  const ErrorNote({
    required this.id,
    required this.errorType,
    required this.labelTr,
    required this.explanationTr,
    this.examples = const [],
    this.relatedPhrases = const [],
    this.audio,
  });

  factory ErrorNote.fromJson(Map<String, dynamic> j) => ErrorNote(
    id: j['id'] as String,
    errorType: ErrorType.parse(j['errorType'] as String?) ?? ErrorType.other,
    labelTr: j['labelTr'] as String,
    explanationTr: j['explanationTr'] as String,
    examples: [
      for (final e in (j['examples'] as List? ?? const []))
        (wrong: (e as Map)['wrong'] as String, right: e['right'] as String),
    ],
    relatedPhrases: [
      for (final p in (j['relatedPhrases'] as List? ?? const [])) p as String,
    ],
    audio: j['audio'] as String?,
  );

  final String id;
  final ErrorType errorType;
  final String labelTr;
  final String explanationTr;
  final List<({String wrong, String right})> examples;

  /// Bu notun ilgili olduğu hedef ifadeler (kelime tekrarında "Neden yanlış?").
  final List<String> relatedPhrases;

  /// Hi'nin Türkçe sesi (H-083): sezon paketine göre yol, ör.
  /// `hi/note-be-dropped.m4a`. Yoksa yalnız metin.
  final String? audio;
}

/// Yanlış karar seçeneğinin hata türü (ve varsa notu).
class DecisionError {
  const DecisionError({
    required this.contentId,
    required this.node,
    required this.option,
    required this.errorType,
    this.entry,
  });

  factory DecisionError.fromJson(Map<String, dynamic> j) => DecisionError(
    contentId: j['contentId'] as String,
    node: j['node'] as String,
    option: j['option'] as String,
    errorType: ErrorType.parse(j['errorType'] as String?) ?? ErrorType.other,
    entry: j['entry'] as String?,
  );

  final String contentId;
  final String node;
  final String option;
  final ErrorType errorType;
  final String? entry;

  /// Öğrenme olayındaki kaynak kimliği: `k2#b`.
  String get sourceId => '$node#$option';
}

/// Hi'nin konu tanıtımı: segment bitince bir kez gösterilen kısa kart.
class TopicIntro {
  const TopicIntro({
    required this.id,
    required this.contentId,
    required this.node,
    required this.titleEn,
    required this.linesTr,
    required this.exampleEn,
    required this.exampleTr,
    this.cue,
    this.audio,
  });

  factory TopicIntro.fromJson(Map<String, dynamic> j) {
    final t = (j['trigger'] as Map).cast<String, dynamic>();
    return TopicIntro(
      id: j['id'] as String,
      contentId: j['contentId'] as String,
      node: t['node'] as String,
      cue: t['cue'] as String?,
      titleEn: j['titleEn'] as String,
      linesTr: [for (final l in j['linesTr'] as List) l as String],
      exampleEn: j['exampleEn'] as String,
      exampleTr: j['exampleTr'] as String,
      audio: j['audio'] as String?,
    );
  }

  final String id;
  final String contentId;

  /// Kartın gösterileceği segment (bitince) ve tetikleyen altyazı satırı.
  final String node;
  final String? cue;
  final String titleEn;
  final List<String> linesTr;
  final String exampleEn;
  final String exampleTr;

  /// Hi'nin Türkçe sesi (H-083): sezon paketine göre yol, ör.
  /// `hi/intro-can-questions.m4a`.
  final String? audio;
}

/// Gerçek hayat köprü görevi (F4): isteğe bağlı yan görev.
class BridgeTask {
  const BridgeTask({
    required this.id,
    required this.contentId,
    required this.titleTr,
    required this.textTr,
    this.phraseEn,
    this.audio,
  });

  factory BridgeTask.fromJson(Map<String, dynamic> j) => BridgeTask(
    id: j['id'] as String,
    contentId: j['contentId'] as String,
    titleTr: j['titleTr'] as String,
    textTr: j['textTr'] as String,
    phraseEn: j['phraseEn'] as String?,
    audio: j['audio'] as String?,
  );

  final String id;
  final String contentId;
  final String titleTr;
  final String textTr;
  final String? phraseEn;

  /// Hi'nin Türkçe sesi (H-083): sezon paketine göre yol, ör.
  /// `hi/bridge-bt-a1-001.m4a`.
  final String? audio;
}

/// "Bu ne demek?" dizinindeki bir ifade (onaylı çeviriden).
class LookupEntry {
  const LookupEntry({
    required this.en,
    required this.tr,
    required this.kind,
    required this.contentId,
    this.alt = const [],
    this.exampleEn,
    this.exampleTr,
    this.audio,
    this.exampleAudio,
  });

  factory LookupEntry.fromJson(Map<String, dynamic> j) {
    MediaClip? clip(Object? c) => c is Map
        ? MediaClip(
            c['path'] as String,
            start: (c['start'] as num?)?.toDouble(),
            end: (c['end'] as num?)?.toDouble(),
          )
        : null;
    return LookupEntry(
      en: j['en'] as String,
      tr: j['tr'] as String,
      kind: j['kind'] as String? ?? 'word',
      contentId: j['contentId'] as String,
      alt: [for (final a in (j['alt'] as List? ?? const [])) a as String],
      exampleEn: j['exampleEn'] as String?,
      exampleTr: j['exampleTr'] as String?,
      audio: clip(j['audio']),
      exampleAudio: clip(j['exampleAudio']),
    );
  }

  final String en;
  final String tr;

  /// `word` | `phrase`
  final String kind;
  final String contentId;
  final List<String> alt;
  final String? exampleEn;
  final String? exampleTr;
  final MediaClip? audio;
  final MediaClip? exampleAudio;

  NotebookItem toNotebookItem() => NotebookItem(
    kind: kind == 'word' ? NotebookKind.word : NotebookKind.phrase,
    textEn: en,
    textTr: tr,
    exampleEn: exampleEn,
    exampleTr: exampleTr,
    contentId: contentId,
    audio: audio,
    exampleAudio: exampleAudio,
    source: NotebookSource.lookup,
  );
}

/// Sezon paketindeki Hi verisi. Taslak durumu (`DRAFT`) bilgi içindir.
class HiContent {
  const HiContent({
    this.errorCatalog = const [],
    this.decisionErrors = const [],
    this.topicIntros = const [],
    this.bridgeTasks = const [],
    this.lookup = const [],
  });

  factory HiContent.fromJson(Map<String, dynamic> j) => HiContent(
    errorCatalog: [
      for (final e in (j['errorCatalog'] as List? ?? const []))
        ErrorNote.fromJson((e as Map).cast<String, dynamic>()),
    ],
    decisionErrors: [
      for (final e in (j['decisionErrors'] as List? ?? const []))
        DecisionError.fromJson((e as Map).cast<String, dynamic>()),
    ],
    topicIntros: [
      for (final e in (j['topicIntros'] as List? ?? const []))
        TopicIntro.fromJson((e as Map).cast<String, dynamic>()),
    ],
    bridgeTasks: [
      for (final e in (j['bridgeTasks'] as List? ?? const []))
        BridgeTask.fromJson((e as Map).cast<String, dynamic>()),
    ],
    lookup: [
      for (final e in (j['lookup'] as List? ?? const []))
        LookupEntry.fromJson((e as Map).cast<String, dynamic>()),
    ],
  );

  static const empty = HiContent();

  final List<ErrorNote> errorCatalog;
  final List<DecisionError> decisionErrors;
  final List<TopicIntro> topicIntros;
  final List<BridgeTask> bridgeTasks;
  final List<LookupEntry> lookup;

  ErrorNote? note(String? id) =>
      id == null ? null : errorCatalog.where((e) => e.id == id).firstOrNull;

  /// Bir hata türünün ilk notu (olaydan not bulunamazsa).
  ErrorNote? noteForType(ErrorType type) =>
      errorCatalog.where((e) => e.errorType == type).firstOrNull;

  DecisionError? decisionError(String contentId, String sourceId) =>
      decisionErrors
          .where((d) => d.contentId == contentId && d.sourceId == sourceId)
          .firstOrNull;

  /// Bir ifadeyle ilgili not (kelime tekrarında "Neden yanlış?").
  ErrorNote? noteForPhrase(String en) {
    final key = normalizeEn(en);
    for (final n in errorCatalog) {
      for (final p in n.relatedPhrases) {
        if (normalizeEn(p) == key) return n;
      }
    }
    return null;
  }

  BridgeTask? bridgeTaskFor(String contentId) =>
      bridgeTasks.where((t) => t.contentId == contentId).firstOrNull;
}
