// Konuş görevleri (H-090): yönlendirmeli sahneler ve kısa mesaj yazma.
// Saf Dart. Veri sezon paketindeki `talk.json`'dan gelir (içerik hattı:
// `tools/content-pipeline/hvpipeline/talk.py`; kaynak `icerik/_evren/konusma/`).
//
// Yapay zekâ sohbeti değildir (H-007): karakterin satırları ve kabul edilen
// cevaplar önceden yazılmıştır; editör onayı bekler (H-028).

import '../../../shared/progress/story_progress.dart';

enum TalkKind {
  scene('scene'),
  message('message');

  const TalkKind(this.code);

  final String code;

  static TalkKind parse(Object? v) =>
      values.firstWhere((k) => k.code == v, orElse: () => scene);
}

/// Karakterin bir satırı. [audio]: bölüm kaydından aynen alınmış ses
/// (sezon paketinde `talk/…m4a`); yoksa cihazın İngilizce sesi okur.
class TalkLine {
  const TalkLine({
    required this.en,
    required this.tr,
    this.audio,
    this.nameTr,
  });

  factory TalkLine.fromJson(Map<String, dynamic> j) => TalkLine(
    en: j['en'] as String,
    tr: j['tr'] as String,
    audio: j['audio'] as String?,
    nameTr: j['nameTr'] as String?,
  );

  final String en;
  final String tr;
  final String? audio;

  /// Konuşan sahnenin karakteri değilse adı (ör. kapanışta "Mrs Brooks").
  final String? nameTr;
}

/// Kabul edilmeyen ama yakın seçenek ve kibar tepkisi (K-28: tepkiden sonra
/// aynı tura dönülür).
class TalkDistractor {
  const TalkDistractor({required this.en, required this.reactionTr});

  factory TalkDistractor.fromJson(Map<String, dynamic> j) => TalkDistractor(
    en: j['en'] as String,
    reactionTr: j['reactionTr'] as String,
  );

  final String en;
  final String reactionTr;
}

class TalkTurn {
  const TalkTurn({
    required this.id,
    required this.line,
    required this.promptTr,
    required this.accept,
    this.distractors = const [],
    this.targets = const [],
  });

  factory TalkTurn.fromJson(Map<String, dynamic> j) => TalkTurn(
    id: j['id'] as String,
    line: TalkLine.fromJson((j['line'] as Map).cast()),
    promptTr: j['promptTr'] as String,
    accept: [for (final a in j['accept'] as List) a as String],
    distractors: [
      for (final d in (j['distractors'] as List? ?? const []))
        TalkDistractor.fromJson((d as Map).cast()),
    ],
    targets: [for (final t in (j['targets'] as List? ?? const [])) t as String],
  );

  final String id;

  /// Karakterin satırı.
  final TalkLine line;

  /// Kullanıcının ne söyleyeceği (Türkçe görev cümlesi).
  final String promptTr;

  /// Aynı anlama gelen, kabul edilen cevaplar; ilki örnek cevaptır.
  final List<String> accept;
  final List<TalkDistractor> distractors;

  /// Bu turda çalışılan hedef ifadeler (bölümlerin hedef ifadeleri).
  final List<String> targets;

  String get model => accept.first;
}

/// Mesaj denetimi (H-090): her [all] grubundan en az bir kelime ya da kalıp
/// geçmeli; [none] kelimelerinden (anlamı tersine çevirenler) hiçbiri
/// olmamalı. Kalıplar kelime sırasıyla ve bitişik aranır.
class MessageCheck {
  const MessageCheck({required this.all, this.none = const [], this.hintTr});

  factory MessageCheck.fromJson(Map<String, dynamic> j) => MessageCheck(
    all: [
      for (final g in j['all'] as List)
        [for (final a in g as List) a as String],
    ],
    none: [for (final n in (j['none'] as List? ?? const [])) n as String],
    hintTr: j['hintTr'] as String?,
  );

  final List<List<String>> all;
  final List<String> none;
  final String? hintTr;
}

class TalkTask {
  const TalkTask({
    required this.id,
    required this.kind,
    required this.level,
    required this.order,
    required this.status,
    required this.unlockAfter,
    required this.titleTr,
    required this.imageEpisode,
    required this.imagePath,
    this.unlockEpisode,
    this.introTr,
    this.characterName,
    this.turns = const [],
    this.outro,
    this.taskTr,
    this.to,
    this.model,
    this.check,
    this.selfCheckTr = const [],
    this.targets = const [],
  });

  factory TalkTask.fromJson(Map<String, dynamic> j) {
    final image = (j['image'] as Map).cast<String, dynamic>();
    final character = j['character'] is Map
        ? (j['character'] as Map).cast<String, dynamic>()
        : null;
    return TalkTask(
      id: j['id'] as String,
      kind: TalkKind.parse(j['kind']),
      level: (j['level'] as String?) ?? 'A1',
      order: (j['order'] as num?)?.toInt() ?? 0,
      status: (j['status'] as String?) ?? 'DRAFT',
      unlockAfter: j['unlockAfter'] as String,
      unlockEpisode: (j['unlockEpisode'] as num?)?.toInt(),
      titleTr: j['titleTr'] as String,
      imageEpisode: image['episode'] as String,
      imagePath: image['path'] as String,
      introTr: j['introTr'] as String?,
      characterName: character?['nameTr'] as String?,
      turns: [
        for (final t in (j['turns'] as List? ?? const []))
          TalkTurn.fromJson((t as Map).cast()),
      ],
      outro: j['outro'] is Map
          ? TalkLine.fromJson((j['outro'] as Map).cast())
          : null,
      taskTr: j['taskTr'] as String?,
      to: j['to'] as String?,
      model: j['model'] is Map
          ? TalkLine.fromJson((j['model'] as Map).cast())
          : null,
      check: j['check'] is Map
          ? MessageCheck.fromJson((j['check'] as Map).cast())
          : null,
      selfCheckTr: [
        for (final s in (j['selfCheckTr'] as List? ?? const [])) s as String,
      ],
      targets: [
        for (final t in (j['targets'] as List? ?? const [])) t as String,
      ],
    );
  }

  final String id;
  final TalkKind kind;
  final String level;
  final int order;

  /// İçerik durumu (`DRAFT` → editör onayı bekliyor, H-028).
  final String status;

  /// Bu bölüm bitince açılır (`A1-009`).
  final String unlockAfter;
  final int? unlockEpisode;
  final String titleTr;

  /// Bölüm paketindeki görsel (`A1-009` + `stills/B9-04-k1-pov.webp`).
  final String imageEpisode;
  final String imagePath;

  // sahne
  final String? introTr;
  final String? characterName;
  final List<TalkTurn> turns;
  final TalkLine? outro;

  // mesaj
  final String? taskTr;

  /// Mesajın alıcısı ("Maya", "Hi", "Notlar").
  final String? to;
  final TalkLine? model;

  /// Güvenilir kural yoksa null: örnek cevap + öz değerlendirme.
  final MessageCheck? check;
  final List<String> selfCheckTr;

  /// Görevin hedef ifadeleri (sahnede turların hedefleri).
  final List<String> targets;

  bool get isScene => kind == TalkKind.scene;

  /// Yaklaşık süre (dk): sahne tur başına ~40 sn, mesaj ~2 dk.
  int get minutes => isScene ? (turns.length * 2 / 3).ceil().clamp(2, 4) : 2;
}

class TalkCatalog {
  const TalkCatalog(this.tasks);

  static const empty = TalkCatalog([]);

  factory TalkCatalog.fromJson(Map<String, dynamic> j) {
    final tasks = [
      for (final t in (j['tasks'] as List? ?? const []))
        TalkTask.fromJson((t as Map).cast()),
    ]..sort((a, b) => a.order.compareTo(b.order));
    return TalkCatalog(tasks);
  }

  final List<TalkTask> tasks;

  TalkTask? byId(String id) => tasks.where((t) => t.id == id).firstOrNull;
}

/// Görevin listedeki durumu.
class TalkTaskView {
  const TalkTaskView(this.task, {required this.unlocked, this.doneAt});

  final TalkTask task;
  final bool unlocked;

  /// İlk bitirildiği an (UTC); bitmediyse null.
  final DateTime? doneAt;

  bool get done => doneAt != null;
}

/// Kilit: ilgili bölüm bitince açılır (konu setleriyle aynı kural, H-051).
List<TalkTaskView> resolveTalkTasks(
  TalkCatalog catalog,
  Map<String, StoryProgress> progress,
  Map<String, DateTime> done,
) => [
  for (final t in catalog.tasks)
    TalkTaskView(
      t,
      unlocked: progress[t.unlockAfter]?.status == StoryStatus.completed,
      doneAt: done[t.id],
    ),
];
