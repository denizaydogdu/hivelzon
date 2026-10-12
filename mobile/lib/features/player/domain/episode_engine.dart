// Bölüm motoru: `scenes.json` grafiğini adım adım yürütür.
//
// Saf Dart (Flutter yok). Kurallar:
// - K-27/K-28: yanlış seçenek → tepki düğümü → aynı karar; bayrak en fazla 3.
// - K-29: kapı = anlama + hedef ifade + aktif görev; deneme sınırsız.
// - K-32: süre, can, ceza yok. Puanlamaya yalnızca ilk deneme girer.
// - §2.5: kontrol noktası sahne başıdır; devam etme kontrol noktasından olur.
// - H-050: bölüm her zaman başlık ekranıyla açılır; kaldığı yerden devamda da
//   önce başlık gelir, sonra kontrol noktasına geçilir (özet atlanır).

import 'episode.dart';

/// Kaydedilip geri yüklenebilen motor durumu.
class EngineSnapshot {
  const EngineSnapshot({
    required this.checkpointNodeId,
    required this.flags,
    required this.passedNodes,
    required this.contentVersion,
  });

  factory EngineSnapshot.fromJson(Map<String, dynamic> j) => EngineSnapshot(
    checkpointNodeId: j['checkpoint'] as String,
    flags: Map<String, String>.from(j['flags'] as Map? ?? const {}),
    passedNodes: Set<String>.from(j['passed'] as List? ?? const []),
    contentVersion: (j['contentVersion'] as num?)?.toInt() ?? 1,
  );

  final String checkpointNodeId;
  final Map<String, String> flags;
  final Set<String> passedNodes;
  final int contentVersion;

  Map<String, dynamic> toJson() => {
    'checkpoint': checkpointNodeId,
    'flags': flags,
    'passed': passedNodes.toList()..sort(),
    'contentVersion': contentVersion,
  };
}

class GateStatus {
  const GateStatus({
    required this.comprehension,
    required this.targetPhrase,
    required this.activeTask,
  });

  final bool comprehension;
  final bool targetPhrase;
  final bool activeTask;

  bool get open => comprehension && targetPhrase && activeTask;
}

class DecisionResult {
  const DecisionResult({
    required this.option,
    required this.correct,
    required this.firstAttempt,
  });

  final DecisionOption option;
  final bool correct;

  /// Bu karardaki ilk deneme miydi? (Puanlamaya yalnızca bu girer.)
  final bool firstAttempt;
}

class EpisodeEngine {
  /// [externalFlags]: bölüm kimliği → bayrak → değer (önceki bölümlerde yazılanlar).
  /// Bildirilmiş ama yazılmamış dış bayrak **yok** sayılır; kart kendi
  /// `lines` alanına düşer (BOLUM-PAKETI §2.4).
  EpisodeEngine(
    this.episode, {
    Map<String, Map<String, String>> externalFlags = const {},
    EngineSnapshot? resumeFrom,
  }) : _external = {
         for (final e in externalFlags.entries) e.key: Map.of(e.value),
       } {
    if (resumeFrom != null) {
      _flags.addAll(resumeFrom.flags);
      _passed.addAll(resumeFrom.passedNodes);
    }
    final resumeId = resumeFrom?.checkpointNodeId;
    final canResume =
        resumeId != null && episode.nodes[resumeId]?.checkpoint == true;
    if (canResume && episode.titleNode != null && resumeId != episode.start) {
      // Önce başlık; başlık bitince doğrudan kontrol noktası. Kayıt, başlık
      // sırasında çıkılırsa da aynı kontrol noktasını korur.
      _resumeTarget = resumeId;
      _lastCheckpoint = resumeId;
      _enter(episode.start);
    } else {
      _enter(canResume ? resumeId : episode.start);
    }
  }

  final Episode episode;
  final Map<String, Map<String, String>> _external;
  final Map<String, String> _flags = {};
  final Set<String> _passed = {};
  final Map<String, int> _hintLevels = {};
  final Map<String, bool> _firstAttempts = {};
  final List<String> _history = [];
  final List<String> _clueIds = [];
  final List<String> _questionIds = [];
  String? _currentId;
  String? _lastCheckpoint;
  String? _resumeTarget;

  // ------------------------------------------------------------ okuma

  EpisodeNode? get current =>
      _currentId == null ? null : episode.nodes[_currentId];

  bool get isFinished => _currentId == null;

  /// Bu oturumda girilen düğümler (sırayla).
  List<String> get history => List.unmodifiable(_history);

  String? get lastCheckpoint => _lastCheckpoint;

  Map<String, String> get flags => Map.unmodifiable(_flags);

  Set<String> get passedNodes => Set.unmodifiable(_passed);

  List<String> get collectedClueIds => List.unmodifiable(_clueIds);

  List<String> get openedQuestionIds => List.unmodifiable(_questionIds);

  /// Anahtar: karar düğümü ya da `görev/öğe`; değer: ilk denemede doğru mu.
  Map<String, bool> get firstAttempts => Map.unmodifiable(_firstAttempts);

  GateStatus get gateStatus {
    bool any(List<String> ids) => ids.any(_passed.contains);
    final g = episode.gate;
    return GateStatus(
      comprehension: any(g.comprehension),
      targetPhrase: any(g.targetPhrase),
      activeTask: any(g.activeTask),
    );
  }

  /// Bayrak değeri. [fromEpisode] verilir ve bu bölüm değilse dış bayrağa bakılır.
  String? flagValue(String flag, {String? fromEpisode}) {
    if (fromEpisode == null || fromEpisode == episode.info.id) {
      return _flags[flag];
    }
    return _external[fromEpisode]?[flag];
  }

  /// Kartın gösterilecek satırları: ilk uyan varyant, yoksa `lines`.
  List<CardLine> linesFor(CardNode card) {
    for (final v in card.variants) {
      final value = flagValue(v.when.flag, fromEpisode: v.when.episode);
      if (value != null && value == v.when.value) return v.lines;
    }
    return card.lines;
  }

  int hintLevel(String decisionId) => _hintLevels[decisionId] ?? 0;

  /// Şu anki karar düğümünde gösterilen ipucu (yoksa null).
  Hint? get currentHint {
    final node = current;
    if (node is! DecisionNode) return null;
    final level = hintLevel(node.id);
    return level == 0 ? null : node.hints[level - 1];
  }

  bool get canRequestHint {
    final node = current;
    return node is DecisionNode && hintLevel(node.id) < node.hints.length;
  }

  // ------------------------------------------------------------ yürütme

  /// Şu an atlanabilir bir "Önceki bölümde" özeti mi oynuyor?
  bool get canSkip => switch (current) {
    RecapNode(:final skippable) => skippable,
    _ => false,
  };

  /// Kaldığı yerden devamda başlıktan sonra gidilecek kontrol noktası.
  String? get resumeTarget => _resumeTarget;

  /// Segment, kart ve tepki düğümlerinden sonrakine geçer. Özet atlanınca da
  /// bu çağrılır (özetin `next`'i).
  void advance() {
    final node = _requireCurrent();
    switch (node) {
      case TitleNode(:final next):
        final target = _resumeTarget;
        _resumeTarget = null;
        _enter(target ?? next);
      case SegmentNode(:final next):
        _enter(next);
      case CardNode(:final next):
        _enter(next);
      case ReactionNode(:final next):
        _enter(next);
      case DecisionNode():
        throw StateError('Karar düğümü seçimle ilerler: ${node.id}');
      case TaskNode():
        throw StateError('Görev düğümü completeTask ile ilerler: ${node.id}');
    }
  }

  /// Karar seçimi. Doğruysa (ve bayrak varsa) bayrak yazılır, kapı ölçütü
  /// karşılanır; yanlışsa seçenek tepkiye gider, tepki aynı karara döner.
  DecisionResult choose(String optionId) {
    final node = _requireCurrent();
    if (node is! DecisionNode) {
      throw StateError('Şu anki düğüm karar değil: ${node.id}');
    }
    final option = node.option(optionId);
    if (option == null) throw ArgumentError('Seçenek yok: $optionId');
    final first = !_firstAttempts.containsKey(node.id);
    if (first) _firstAttempts[node.id] = option.correct;
    final flag = option.setFlag;
    if (flag != null &&
        (flag.episode == null || flag.episode == episode.info.id)) {
      _flags[flag.flag] = flag.value;
    }
    if (option.correct) _passed.add(node.id);
    _enter(option.next);
    return DecisionResult(
      option: option,
      correct: option.correct,
      firstAttempt: first,
    );
  }

  /// Bir sonraki ipucu düzeyine geçer (1 → 2 → 3). En üstte kalır.
  Hint? requestHint() {
    final node = _requireCurrent();
    if (node is! DecisionNode || node.hints.isEmpty) return null;
    final level = (hintLevel(node.id) + 1).clamp(1, node.hints.length);
    _hintLevels[node.id] = level;
    return node.hints[level - 1];
  }

  /// Görev öğesi denemesi; yalnızca ilki kaydedilir.
  void recordTaskAttempt(String itemId, {required bool correct}) {
    final node = _requireCurrent();
    if (node is! TaskNode) {
      throw StateError('Şu anki düğüm görev değil: ${node.id}');
    }
    _firstAttempts.putIfAbsent('${node.id}/$itemId', () => correct);
  }

  /// Görev doğru cevaba ulaştı: kapı ölçütü karşılanır, sonraki düğüme geçilir.
  void completeTask() {
    final node = _requireCurrent();
    if (node is! TaskNode) {
      throw StateError('Şu anki düğüm görev değil: ${node.id}');
    }
    _passed.add(node.id);
    _enter(node.next);
  }

  EngineSnapshot snapshot() => EngineSnapshot(
    checkpointNodeId: _lastCheckpoint ?? episode.start,
    flags: Map.of(_flags),
    passedNodes: Set.of(_passed),
    contentVersion: episode.info.contentVersion,
  );

  // ------------------------------------------------------------ yol

  /// Ana yol: başlangıçtan `next` ve ilk doğru seçenekle ilerleyen düğümler.
  List<String> get mainPath {
    final path = <String>[];
    final seen = <String>{};
    String? id = episode.start;
    while (id != null && seen.add(id)) {
      path.add(id);
      final n = episode.nodes[id];
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
    return path;
  }

  /// İlerleme noktaları: ana yoldaki kontrol noktaları (sahne başları).
  List<String> get progressCheckpoints => [
    for (final id in mainPath)
      if (episode.nodes[id]!.checkpoint) id,
  ];

  /// Şu an hangi sahne noktasındayız (0 tabanlı; bitince uzunluk).
  int get progressIndex {
    final cps = progressCheckpoints;
    if (isFinished) return cps.length;
    final i = cps.indexOf(_lastCheckpoint ?? '');
    return i < 0 ? 0 : i;
  }

  /// Ön ısıtma adayları: şu anki düğümden sonra oynayacak videolu düğümler.
  ///
  /// Karar düğümünde önce doğru seçeneklerin, sonra yanlışların hedefi gelir.
  /// Kart ve görevlerin üzerinden geçilir (bunlar yerel arayüzdür).
  List<VideoBearing> upcomingVideoNodes({int limit = 2}) {
    final out = <VideoBearing>[];
    final node = current;
    if (node == null) return out;

    void walk(String? from, Set<String> seen) {
      String? id = from;
      while (id != null && out.length < limit && seen.add(id)) {
        final n = episode.nodes[id];
        switch (n) {
          case final VideoBearing v when v.video != null:
            if (!out.contains(v)) out.add(v);
            return;
          case SegmentNode(:final next):
            id = next;
          case ReactionNode(:final next):
            id = next;
          case CardNode(:final next):
            id = next;
          case TaskNode(:final next):
            id = next;
          case DecisionNode(:final options):
            final ordered = [
              ...options.where((o) => o.correct),
              ...options.where((o) => !o.correct),
            ];
            for (final o in ordered) {
              walk(o.next, {...seen});
            }
            return;
          case null:
            return;
        }
      }
    }

    final String? start = switch (node) {
      TitleNode(:final next) => _resumeTarget ?? next,
      SegmentNode(:final next) => next,
      ReactionNode(:final next) => next,
      CardNode(:final next) => next,
      TaskNode(:final next) => next,
      DecisionNode() => node.id,
    };
    walk(start, node is DecisionNode ? {} : {node.id});
    return out;
  }

  // ------------------------------------------------------------ iç

  EpisodeNode _requireCurrent() {
    final n = current;
    if (n == null) throw StateError('Bölüm bitti');
    return n;
  }

  void _enter(String? id) {
    if (id == null) {
      _currentId = null;
      return;
    }
    final node = episode.nodes[id];
    if (node == null) throw StateError('Var olmayan düğüme geçiş: $id');
    _currentId = id;
    _history.add(id);
    if (node.checkpoint) _lastCheckpoint = id;
    if (node is CardNode) {
      if (node.kind == CardKind.clue) {
        for (final c in node.clueIds) {
          if (!_clueIds.contains(c)) _clueIds.add(c);
        }
      }
      final q = node.questionId;
      if (node.kind == CardKind.openQuestion &&
          q != null &&
          !_questionIds.contains(q)) {
        _questionIds.add(q);
      }
    }
  }
}
