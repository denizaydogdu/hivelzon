// Bölüm paketi `scenes.json` modeli (schemaVersion 2, docs/BOLUM-PAKETI.md).
//
// schemaVersion 2 (H-050): her bölüm `title` düğümüyle açılır; B2+ ardından
// atlanabilir `recap` gelir. Başlık ve görev kartı yoktur (görev 🎯 panelinde).
// schemaVersion 1 paketleri de okunur (başlıksız eski açılış).
//
// Saf Dart: Flutter içe aktarımı yoktur; motor ve testler bu modeli kullanır.

import '../../../shared/meaning/meaning_text.dart';

/// Okunabilen `scenes.json` sürümleri.
const Set<int> kSupportedSchemaVersions = {1, 2};

/// Sezon paketindeki dosyaların düğüm `video` yolundaki öneki (H-050).
/// Ör. `season:jenerik-baslik.mp4` → `/packages/_season/S1/jenerik-baslik.mp4`.
const String kSeasonPathPrefix = 'season:';

/// `scenes.json` beklenmeyen biçimdeyse fırlatılır.
class EpisodeFormatException implements Exception {
  EpisodeFormatException(this.message);

  final String message;

  @override
  String toString() => 'EpisodeFormatException: $message';
}

Map<String, dynamic> _map(Object? v, String where) {
  if (v is Map<String, dynamic>) return v;
  if (v is Map) return v.cast<String, dynamic>();
  throw EpisodeFormatException('$where: nesne bekleniyordu');
}

List<dynamic> _list(Object? v) => v is List ? v : const [];

String _str(Map<String, dynamic> j, String key, String where) {
  final v = j[key];
  if (v is String) return v;
  throw EpisodeFormatException('$where.$key: metin bekleniyordu');
}

double? _num(Object? v) => v is num ? v.toDouble() : null;

List<String> _strings(Object? v) =>
    _list(v).whereType<String>().toList(growable: false);

/// Zamansız İngilizce metnin Türkçe anlamları (H-046): `tr`, `words`, `chunks`.
class Gloss {
  const Gloss({this.tr, this.words = const [], this.chunks = const []});

  static Gloss? fromJson(Object? tr, Object? words, Object? chunks) {
    final list = <MeaningWord>[
      for (final w in _list(words))
        if (w is Map && w['w'] is String)
          MeaningWord(w['w'] as String, gloss: w['gloss'] as String?),
    ];
    if (tr is! String && list.isEmpty) return null;
    return Gloss(
      tr: tr is String ? tr : null,
      words: list,
      chunks: PhraseChunk.listFromJson(chunks),
    );
  }

  final String? tr;
  final List<MeaningWord> words;
  final List<PhraseChunk> chunks;

  MeaningText toMeaning({
    required String contentId,
    required String sourceId,
    required String en,
    String? speaker,
  }) => MeaningText(
    contentId: contentId,
    sourceId: sourceId,
    en: en,
    tr: tr,
    speaker: speaker,
    words: words,
    chunks: chunks,
  );
}

/// Türkçe metin (isteğe bağlı İngilizce karşılığıyla).
class TextTr {
  const TextTr({required this.tr, this.en});

  factory TextTr.fromJson(Object? json, String where) {
    final j = _map(json, where);
    return TextTr(tr: _str(j, 'tr', where), en: j['en'] as String?);
  }

  final String tr;
  final String? en;
}

enum Lang {
  en,
  tr;

  static Lang parse(Object? v) => v == 'tr' ? Lang.tr : Lang.en;
}

class CardLine {
  const CardLine({
    required this.text,
    required this.lang,
    this.speaker,
    this.style,
    this.gloss,
  });

  factory CardLine.fromJson(Object? json) {
    final j = _map(json, 'line');
    return CardLine(
      text: _str(j, 'text', 'line'),
      lang: Lang.parse(j['lang']),
      speaker: j['speaker'] as String?,
      style: j['style'] as String?,
      gloss: Gloss.fromJson(j['tr'], j['words'], j['chunks']),
    );
  }

  final String text;
  final Lang lang;
  final String? speaker;

  /// İngilizce satırın Türkçe anlamları (yoksa null; panel açılmaz).
  final Gloss? gloss;

  /// `heading`, `body`, `highlight`, `caption` ya da null.
  final String? style;
}

/// Hi'nin (ya da bir karakterin) konuşma balonu.
class Bubble {
  const Bubble({
    required this.speaker,
    required this.lang,
    required this.text,
    this.audio,
  });

  factory Bubble.fromJson(Object? json) {
    final j = _map(json, 'bubble');
    return Bubble(
      speaker: _str(j, 'speaker', 'bubble'),
      lang: Lang.parse(j['lang']),
      text: _str(j, 'text', 'bubble'),
      audio: j['audio'] as String?,
    );
  }

  final String speaker;
  final Lang lang;
  final String text;
  final String? audio;
}

class FlagRef {
  const FlagRef({required this.flag, required this.value, this.episode});

  factory FlagRef.fromJson(Object? json) {
    final j = _map(json, 'flagRef');
    return FlagRef(
      flag: _str(j, 'flag', 'flagRef'),
      value: _str(j, 'value', 'flagRef'),
      episode: j['episode'] as String?,
    );
  }

  final String flag;
  final String value;

  /// Başka bölümün bayrağıysa o bölümün kimliği (ör. `A1-002`).
  final String? episode;
}

class EpisodeLinks {
  const EpisodeLinks({
    this.previously,
    required this.payoff,
    required this.openQuestion,
    required this.answers,
    required this.cluesUnlocked,
    required this.callbackPhrases,
  });

  factory EpisodeLinks.fromJson(Object? json) {
    final j = _map(json, 'episode.links');
    return EpisodeLinks(
      previously: j['previously'] as String?,
      payoff: (j['payoff'] as String?) ?? '',
      openQuestion: (j['openQuestion'] as String?) ?? '',
      answers: _strings(j['answers']),
      cluesUnlocked: _strings(j['cluesUnlocked']),
      callbackPhrases: _strings(j['callbackPhrases']),
    );
  }

  final String? previously;
  final String payoff;
  final String openQuestion;
  final List<String> answers;
  final List<String> cluesUnlocked;
  final List<String> callbackPhrases;
}

class EpisodeInfo {
  const EpisodeInfo({
    required this.id,
    required this.slug,
    required this.level,
    required this.season,
    required this.number,
    required this.title,
    required this.contentVersion,
    required this.aiLabel,
    required this.mission,
    required this.targetPhrases,
    required this.links,
    this.targetPhraseGloss = const {},
    this.prev,
    this.next,
    this.estimatedMinutes,
  });

  factory EpisodeInfo.fromJson(Object? json) {
    final j = _map(json, 'episode');
    return EpisodeInfo(
      id: _str(j, 'id', 'episode'),
      slug: (j['slug'] as String?) ?? '',
      level: (j['level'] as String?) ?? '',
      season: (j['season'] as num?)?.toInt() ?? 1,
      number: (j['number'] as num?)?.toInt() ?? 0,
      title: _str(j, 'title', 'episode'),
      contentVersion: (j['contentVersion'] as num?)?.toInt() ?? 1,
      aiLabel: (j['aiLabel'] as String?) ?? 'Yapay zekâ ile üretilmiştir',
      mission: TextTr.fromJson(j['mission'], 'episode.mission'),
      targetPhrases: _strings(j['targetPhrases']),
      targetPhraseGloss: {
        for (final g in _list(j['targetPhraseGloss']))
          if (g is Map && g['text'] is String)
            g['text'] as String: ?Gloss.fromJson(
              g['tr'],
              g['words'],
              g['chunks'],
            ),
      },
      links: EpisodeLinks.fromJson(j['links']),
      prev: j['prev'] as String?,
      next: j['next'] as String?,
      estimatedMinutes: _num(j['estimatedMinutes']),
    );
  }

  final String id;
  final String slug;
  final String level;
  final int season;
  final int number;
  final String title;
  final int contentVersion;
  final String aiLabel;
  final TextTr mission;
  final List<String> targetPhrases;

  /// Hedef ifadenin Türkçe anlamı (🎯 paneli, H-050). Anlamı olmayan ifade yoktur.
  final Map<String, Gloss> targetPhraseGloss;
  final EpisodeLinks links;
  final String? prev;
  final String? next;
  final double? estimatedMinutes;
}

class FlagDecl {
  const FlagDecl({required this.id, required this.values});

  final String id;
  final List<String> values;
}

class ExternalFlagDecl {
  const ExternalFlagDecl({
    required this.episode,
    required this.id,
    required this.values,
    this.defaultValue,
  });

  final String episode;
  final String id;
  final List<String> values;
  final String? defaultValue;
}

/// Bölüm kapısı (K-29): üç ölçütün hepsi gerekir.
class GateSpec {
  const GateSpec({
    required this.comprehension,
    required this.targetPhrase,
    required this.activeTask,
  });

  factory GateSpec.fromJson(Object? json) {
    final j = _map(json, 'gate');
    return GateSpec(
      comprehension: _strings(j['comprehension']),
      targetPhrase: _strings(j['targetPhrase']),
      activeTask: _strings(j['activeTask']),
    );
  }

  final List<String> comprehension;
  final List<String> targetPhrase;
  final List<String> activeTask;
}

// ---------------------------------------------------------------- düğümler

sealed class EpisodeNode {
  const EpisodeNode({required this.id, this.scene, this.checkpoint = false});

  final String id;
  final String? scene;
  final bool checkpoint;

  static EpisodeNode fromJson(Object? json) {
    final j = _map(json, 'node');
    final id = _str(j, 'id', 'node');
    final where = 'node[$id]';
    final scene = j['scene'] as String?;
    final checkpoint = j['checkpoint'] == true;
    switch (j['type']) {
      case 'title':
        return TitleNode(
          id: id,
          scene: scene,
          checkpoint: checkpoint,
          season: (j['season'] as num?)?.toInt() ?? 1,
          episode: (j['episode'] as num?)?.toInt() ?? 0,
          caption: _str(j, 'caption', where),
          title: _str(j, 'title', where),
          seasonVideo: _str(j, 'seasonVideo', where),
          seasonPoster: j['seasonPoster'] as String?,
          duration: _num(j['duration']) ?? 2.5,
          next: j['next'] as String?,
        );
      case 'recap':
        return RecapNode(
          id: id,
          scene: scene,
          checkpoint: checkpoint,
          video: _str(j, 'video', where),
          duration: _num(j['duration']) ?? 0,
          subtitles: j['subtitles'] as String?,
          skippable: j['skippable'] != false,
          next: j['next'] as String?,
        );
      case 'segment':
        return SegmentNode(
          id: id,
          scene: scene,
          checkpoint: checkpoint,
          video: _str(j, 'video', where),
          duration: _num(j['duration']) ?? 0,
          subtitles: j['subtitles'] as String?,
          poster: j['poster'] as String?,
          next: j['next'] as String?,
        );
      case 'decision':
        return DecisionNode(
          id: id,
          scene: scene,
          checkpoint: checkpoint,
          prompt: TextTr.fromJson(j['prompt'], '$where.prompt'),
          cue: j['cue'] == null ? null : DecisionCue.fromJson(j['cue']),
          background: j['background'] as String?,
          targetPhrase: j['targetPhrase'] as String?,
          options: _list(j['options']).map(DecisionOption.fromJson).toList(),
          hints: _list(j['hints']).map(Hint.fromJson).toList()
            ..sort((a, b) => a.level.compareTo(b.level)),
        );
      case 'reaction':
        return ReactionNode(
          id: id,
          scene: scene,
          checkpoint: checkpoint,
          video: j['video'] as String?,
          duration: _num(j['duration']),
          subtitles: j['subtitles'] as String?,
          bubble: j['bubble'] == null ? null : Bubble.fromJson(j['bubble']),
          next: _str(j, 'next', where),
        );
      case 'card':
        return CardNode(
          id: id,
          scene: scene,
          checkpoint: checkpoint,
          kind: CardKind.parse(j['kind'], where),
          title: j['title'] as String?,
          lines: _list(j['lines']).map(CardLine.fromJson).toList(),
          variants: _list(j['variants']).map(CardVariant.fromJson).toList(),
          audio: j['audio'] as String?,
          background: j['background'] as String?,
          autoAdvance: j['advance'] == 'auto',
          duration: _num(j['duration']),
          clueIds: _strings(j['clueIds']),
          questionId: j['questionId'] as String?,
          next: j['next'] as String?,
        );
      case 'task':
        final fb = j['feedback'];
        return TaskNode(
          id: id,
          scene: scene,
          checkpoint: checkpoint,
          kind: TaskKind.parse(j['kind'], where),
          role: (j['role'] as String?) ?? 'mission',
          prompt: TextTr.fromJson(j['prompt'], '$where.prompt'),
          context: j['context'] as String?,
          audio: j['audio'] as String?,
          background: j['background'] as String?,
          items: _list(j['items']).map(TaskItem.fromJson).toList(),
          result: _list(j['result']).map(CardLine.fromJson).toList(),
          wrongFeedback: fb is Map && fb['wrong'] != null
              ? Bubble.fromJson(fb['wrong'])
              : null,
          next: j['next'] as String?,
        );
      default:
        throw EpisodeFormatException('$where: bilinmeyen tür ${j['type']}');
    }
  }
}

/// Videosu olabilen düğümler (segment ve tepki).
abstract interface class VideoBearing {
  String get id;
  String? get video;
  String? get subtitles;
}

class SegmentNode extends EpisodeNode implements VideoBearing {
  const SegmentNode({
    required super.id,
    super.scene,
    super.checkpoint,
    required this.video,
    required this.duration,
    this.subtitles,
    this.poster,
    this.next,
  });

  @override
  final String video;
  final double duration;
  @override
  final String? subtitles;
  final String? poster;
  final String? next;
}

/// Bölüm başlık ekranı (H-050): her bölümün ilk düğümü.
///
/// Segment gibi oynar (ön ısıtma, ön başlatma ve bitince geçiş aynıdır); video
/// sezon paketindeki yazısız kısa animasyondur. Başlığı uygulama çizer.
class TitleNode extends SegmentNode {
  TitleNode({
    required super.id,
    super.scene,
    super.checkpoint,
    required this.season,
    required this.episode,
    required this.caption,
    required this.title,
    required this.seasonVideo,
    this.seasonPoster,
    required super.duration,
    super.next,
  }) : super(video: '$kSeasonPathPrefix$seasonVideo');

  final int season;
  final int episode;

  /// Ör. "SEZON 1 · BÖLÜM 2".
  final String caption;
  final String title;

  /// Sezon paketindeki dosya adı (ör. `jenerik-baslik.mp4`).
  final String seasonVideo;

  /// Videonun ilk karesi (sezon paketinde jpg). Video ilk karesi gelene dek
  /// gösterilir: bölüm açılışında boş ya da siyah kare olmaz.
  final String? seasonPoster;

  /// Afişin oynatıcı yolu (`season:` önekli) ya da null.
  String? get posterPath =>
      seasonPoster == null ? null : '$kSeasonPathPrefix$seasonPoster';
}

/// "Önceki bölümde" (H-050): başlıktan sonra gelen, atlanabilir kısa video.
class RecapNode extends SegmentNode {
  const RecapNode({
    required super.id,
    super.scene,
    super.checkpoint,
    required super.video,
    required super.duration,
    super.subtitles,
    super.next,
    this.skippable = true,
  });

  final bool skippable;
}

class DecisionCue {
  const DecisionCue({
    required this.speaker,
    required this.text,
    this.audio,
    this.gloss,
  });

  factory DecisionCue.fromJson(Object? json) {
    final j = _map(json, 'cue');
    return DecisionCue(
      speaker: (j['speaker'] as String?) ?? '',
      text: (j['text'] as String?) ?? '',
      audio: j['audio'] as String?,
      gloss: Gloss.fromJson(j['tr'], j['words'], j['chunks']),
    );
  }

  final String speaker;
  final String text;
  final String? audio;

  /// Karşı karakterin repliği dokunulabilir (H-046); seçenekler çevrilmez.
  final Gloss? gloss;
}

class DecisionOption {
  const DecisionOption({
    required this.id,
    required this.text,
    required this.lang,
    required this.correct,
    required this.next,
    this.icon,
    this.setFlag,
    this.audio,
  });

  factory DecisionOption.fromJson(Object? json) {
    final j = _map(json, 'option');
    return DecisionOption(
      id: _str(j, 'id', 'option'),
      text: _str(j, 'text', 'option'),
      lang: Lang.parse(j['lang']),
      correct: j['correct'] == true,
      next: _str(j, 'next', 'option'),
      icon: j['icon'] as String?,
      setFlag: j['setFlag'] == null ? null : FlagRef.fromJson(j['setFlag']),
      audio: j['audio'] as String?,
    );
  }

  final String id;
  final String text;
  final Lang lang;
  final bool correct;
  final String next;
  final String? icon;
  final FlagRef? setFlag;
  final String? audio;
}

class Hint {
  const Hint({
    required this.level,
    required this.kind,
    required this.tr,
    this.audio,
  });

  factory Hint.fromJson(Object? json) {
    final j = _map(json, 'hint');
    return Hint(
      level: (j['level'] as num?)?.toInt() ?? 1,
      kind: (j['kind'] as String?) ?? 'keyword',
      tr: _str(j, 'tr', 'hint'),
      audio: j['audio'] as String?,
    );
  }

  final int level;
  final String kind;
  final String tr;
  final String? audio;
}

class DecisionNode extends EpisodeNode {
  const DecisionNode({
    required super.id,
    super.scene,
    super.checkpoint,
    required this.prompt,
    required this.options,
    required this.hints,
    this.cue,
    this.background,
    this.targetPhrase,
  });

  final TextTr prompt;
  final DecisionCue? cue;
  final String? background;
  final String? targetPhrase;
  final List<DecisionOption> options;
  final List<Hint> hints;

  DecisionOption? option(String id) {
    for (final o in options) {
      if (o.id == id) return o;
    }
    return null;
  }
}

class ReactionNode extends EpisodeNode implements VideoBearing {
  const ReactionNode({
    required super.id,
    super.scene,
    super.checkpoint,
    required this.next,
    this.video,
    this.duration,
    this.subtitles,
    this.bubble,
  });

  @override
  final String? video;
  final double? duration;
  @override
  final String? subtitles;
  final Bubble? bubble;

  /// Tepki her zaman bir karara döner (K-28).
  final String next;
}

enum CardKind {
  title,
  mission,
  hi,
  line,
  note,
  message,
  clue,
  openQuestion;

  static CardKind parse(Object? v, String where) {
    for (final k in values) {
      if (k.name == v) return k;
    }
    throw EpisodeFormatException('$where: bilinmeyen kart türü $v');
  }
}

class CardVariant {
  const CardVariant({required this.when, required this.lines});

  factory CardVariant.fromJson(Object? json) {
    final j = _map(json, 'variant');
    return CardVariant(
      when: FlagRef.fromJson(j['when']),
      lines: _list(j['lines']).map(CardLine.fromJson).toList(),
    );
  }

  final FlagRef when;
  final List<CardLine> lines;
}

class CardNode extends EpisodeNode {
  const CardNode({
    required super.id,
    super.scene,
    super.checkpoint,
    required this.kind,
    required this.lines,
    this.title,
    this.variants = const [],
    this.audio,
    this.background,
    this.autoAdvance = false,
    this.duration,
    this.clueIds = const [],
    this.questionId,
    this.next,
  });

  final CardKind kind;
  final String? title;
  final List<CardLine> lines;
  final List<CardVariant> variants;
  final String? audio;
  final String? background;
  final bool autoAdvance;
  final double? duration;
  final List<String> clueIds;
  final String? questionId;
  final String? next;
}

enum TaskKind {
  choice,
  multiSelect,
  order,
  match,
  fillBlank;

  static TaskKind parse(Object? v, String where) {
    for (final k in values) {
      if (k.name == v) return k;
    }
    throw EpisodeFormatException('$where: bilinmeyen görev türü $v');
  }
}

class TaskOption {
  const TaskOption({
    required this.id,
    required this.text,
    required this.lang,
    required this.correct,
    this.audio,
  });

  factory TaskOption.fromJson(Object? json) {
    final j = _map(json, 'taskOption');
    return TaskOption(
      id: _str(j, 'id', 'taskOption'),
      text: _str(j, 'text', 'taskOption'),
      lang: Lang.parse(j['lang']),
      correct: j['correct'] == true,
      audio: j['audio'] as String?,
    );
  }

  final String id;
  final String text;
  final Lang lang;
  final bool correct;
  final String? audio;
}

class MatchPair {
  const MatchPair(this.left, this.right);

  final String left;
  final String right;
}

class Blank {
  const Blank({
    required this.id,
    required this.acceptAny,
    required this.accept,
  });

  final String id;
  final bool acceptAny;
  final List<String> accept;
}

class TaskItem {
  const TaskItem({
    required this.id,
    this.stem,
    this.options = const [],
    this.tokens = const [],
    this.answer = const [],
    this.pairs = const [],
    this.blanks = const [],
    this.stemGloss,
  });

  factory TaskItem.fromJson(Object? json) {
    final j = _map(json, 'taskItem');
    return TaskItem(
      id: _str(j, 'id', 'taskItem'),
      stem: j['stem'] as String?,
      stemGloss: Gloss.fromJson(j['stemTr'], j['stemWords'], j['stemChunks']),
      options: _list(j['options']).map(TaskOption.fromJson).toList(),
      tokens: _strings(j['tokens']),
      answer: _strings(j['answer']),
      pairs: _list(j['pairs']).map((p) {
        final m = _map(p, 'pair');
        return MatchPair(_str(m, 'left', 'pair'), _str(m, 'right', 'pair'));
      }).toList(),
      blanks: _list(j['blanks']).map((b) {
        final m = _map(b, 'blank');
        final accept = m['accept'];
        return Blank(
          id: _str(m, 'id', 'blank'),
          acceptAny: accept == 'any',
          accept: _strings(accept),
        );
      }).toList(),
    );
  }

  final String id;
  final String? stem;
  final List<TaskOption> options;
  final List<String> tokens;
  final List<String> answer;
  final List<MatchPair> pairs;
  final List<Blank> blanks;

  /// Görev kökünün Türkçe anlamları (H-046).
  final Gloss? stemGloss;
}

class TaskNode extends EpisodeNode {
  const TaskNode({
    required super.id,
    super.scene,
    super.checkpoint,
    required this.kind,
    required this.role,
    required this.prompt,
    required this.items,
    this.context,
    this.audio,
    this.background,
    this.result = const [],
    this.wrongFeedback,
    this.next,
  });

  final TaskKind kind;

  /// `comprehension`, `mission` ya da `evidence`.
  final String role;
  final TextTr prompt;
  final String? context;
  final String? audio;
  final String? background;
  final List<TaskItem> items;
  final List<CardLine> result;
  final Bubble? wrongFeedback;
  final String? next;
}

// ---------------------------------------------------------------- bölüm

class Episode {
  Episode({
    this.schemaVersion = 2,
    required this.info,
    required this.flags,
    required this.externalFlags,
    required this.gate,
    required this.start,
    required List<EpisodeNode> nodes,
  }) : nodes = {for (final n in nodes) n.id: n},
       nodeOrder = [for (final n in nodes) n.id];

  factory Episode.fromJson(Object? json) {
    final j = _map(json, 'scenes.json');
    final version = j['schemaVersion'];
    if (!kSupportedSchemaVersions.contains(version)) {
      throw EpisodeFormatException('Desteklenmeyen schemaVersion: $version');
    }
    final nodes = _list(j['nodes']).map(EpisodeNode.fromJson).toList();
    if (nodes.isEmpty) throw EpisodeFormatException('nodes boş');
    final episode = Episode(
      schemaVersion: version as int,
      info: EpisodeInfo.fromJson(j['episode']),
      flags: _list(j['flags']).map((f) {
        final m = _map(f, 'flag');
        return FlagDecl(
          id: _str(m, 'id', 'flag'),
          values: _strings(m['values']),
        );
      }).toList(),
      externalFlags: _list(j['externalFlags']).map((f) {
        final m = _map(f, 'externalFlag');
        return ExternalFlagDecl(
          episode: _str(m, 'episode', 'externalFlag'),
          id: _str(m, 'id', 'externalFlag'),
          values: _strings(m['values']),
          defaultValue: m['default'] as String?,
        );
      }).toList(),
      gate: GateSpec.fromJson(j['gate']),
      start: _str(j, 'start', 'scenes.json'),
      nodes: nodes,
    );
    if (!episode.nodes.containsKey(episode.start)) {
      throw EpisodeFormatException('start düğümü yok: ${episode.start}');
    }
    if (version == 2 && episode.nodes[episode.start] is! TitleNode) {
      throw EpisodeFormatException(
        'schemaVersion 2: başlangıç düğümü başlık değil: ${episode.start}',
      );
    }
    return episode;
  }

  final int schemaVersion;
  final EpisodeInfo info;
  final List<FlagDecl> flags;
  final List<ExternalFlagDecl> externalFlags;
  final GateSpec gate;
  final String start;
  final Map<String, EpisodeNode> nodes;

  /// Dosyadaki sıra (yalnızca okunabilirlik için).
  final List<String> nodeOrder;

  /// Başlık ekranı (schemaVersion 2'de her zaman başlangıç düğümü).
  TitleNode? get titleNode => switch (nodes[start]) {
    final TitleNode t => t,
    _ => null,
  };

  EpisodeNode node(String id) {
    final n = nodes[id];
    if (n == null) throw StateError('Düğüm yok: $id');
    return n;
  }
}
