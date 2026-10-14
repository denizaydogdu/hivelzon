/// Kademeli yerleştirme testi (H-039, K-06; `docs/ICERIK-MIMARISI.md` §7.2).
///
/// Saf Dart: soru havuzu (`assets/placement/placement_bank.json`, TASLAK,
/// H-028 onayı bekliyor) ve kural tabanlı motor. Ağ ve yapay zekâ yok.
///
/// Kurallar:
/// - Başlangıç: kullanıcının kendi tahmini ya da "bilmiyorum" (→ A1).
/// - Isınma: başlangıç A1'in üstündeyse önce 2 kolay soru (sayılmaz).
/// - Her basamakta 4 soru: 3–4 doğru → üst basamak; 2 doğru → bu basamakta
///   kal ve dur; 0–1 doğru → bir alt basamak ve dur.
/// - En fazla [PlacementBank.maxQuestions] soru (varsayılan 20).
/// - "Bilmiyorum" doğru sayılmaz; utandırmaz, yalnızca sıradaki soruya geçer.
/// - Sonuç yalnızca "önerilen başlangıç seviyesi"dir (K-08: vaat yok).
library;

/// CEFR seviyeleri (A1…C1). Kısaltma uluslararası addır; arayüzde olduğu
/// gibi gösterilir.
enum CefrLevel {
  a1('A1'),
  a2('A2'),
  b1('B1'),
  b2('B2'),
  c1('C1');

  const CefrLevel(this.code);

  final String code;

  static CefrLevel? parse(String? code) {
    for (final l in values) {
      if (l.code == code) return l;
    }
    return null;
  }

  CefrLevel? get next => index + 1 < values.length ? values[index + 1] : null;
  CefrLevel? get previous => index > 0 ? values[index - 1] : null;
}

/// Madde türü: kelime, dilbilgisi ya da okuma.
enum PlacementKind {
  vocabulary,
  grammar,
  reading;

  static PlacementKind parse(String v) => switch (v) {
    'vocabulary' => vocabulary,
    'reading' => reading,
    'grammar' => grammar,
    _ => throw FormatException('bilinmeyen madde türü: $v'),
  };
}

class PlacementItem {
  const PlacementItem({
    required this.id,
    required this.kind,
    required this.prompt,
    required this.options,
    required this.answer,
    this.text,
    this.instructionTr,
  });

  factory PlacementItem.fromJson(Map<String, dynamic> j) {
    final options = [for (final o in j['options'] as List) o as String];
    final answer = j['answer'] as int;
    if (options.length < 2 || answer < 0 || answer >= options.length) {
      throw FormatException('geçersiz madde: ${j['id']}');
    }
    return PlacementItem(
      id: j['id'] as String,
      kind: PlacementKind.parse(j['kind'] as String),
      prompt: j['prompt'] as String,
      options: options,
      answer: answer,
      text: j['text'] as String?,
      instructionTr: j['instructionTr'] as String?,
    );
  }

  final String id;
  final PlacementKind kind;

  /// İngilizce soru ya da boşluklu cümle.
  final String prompt;

  /// Okuma maddesinin İngilizce metni.
  final String? text;

  /// Türkçe yönerge (yoksa türün genel yönergesi kullanılır).
  final String? instructionTr;
  final List<String> options;

  /// Doğru seçeneğin sırası.
  final int answer;
}

class PlacementBank {
  const PlacementBank({
    required this.warmup,
    required this.stages,
    this.maxQuestions = 20,
    this.draft = true,
  });

  factory PlacementBank.fromJson(Map<String, dynamic> j) {
    final stages = <CefrLevel, List<PlacementItem>>{};
    final raw = j['stages'] as Map<String, dynamic>;
    for (final MapEntry(:key, :value) in raw.entries) {
      final level = CefrLevel.parse(key);
      if (level == null) throw FormatException('bilinmeyen seviye: $key');
      stages[level] = [
        for (final i in value as List)
          PlacementItem.fromJson(i as Map<String, dynamic>),
      ];
    }
    for (final l in CefrLevel.values) {
      if ((stages[l]?.length ?? 0) < PlacementEngine.stageSize) {
        throw FormatException('${l.code} için en az 4 madde gerekir');
      }
    }
    return PlacementBank(
      warmup: [
        for (final i in (j['warmup'] as List? ?? const []))
          PlacementItem.fromJson(i as Map<String, dynamic>),
      ],
      stages: stages,
      maxQuestions: j['maxQuestions'] as int? ?? 20,
      draft: j['status'] != 'APPROVED',
    );
  }

  final List<PlacementItem> warmup;
  final Map<CefrLevel, List<PlacementItem>> stages;
  final int maxQuestions;

  /// Onaylanmamış havuz (H-028). Arayüz bunu göstermez; kayıt içindir.
  final bool draft;
}

/// Testin akışı. Bir soru gösterilir, [answer] ile cevaplanır; [finished]
/// olunca [result] önerilen başlangıç seviyesidir.
class PlacementEngine {
  PlacementEngine(this.bank, {CefrLevel? selfLevel})
    : _level = selfLevel ?? CefrLevel.a1 {
    _warmupLeft = _level == CefrLevel.a1
        ? 0
        : bank.warmup.length.clamp(0, warmupSize);
  }

  static const stageSize = 4;
  static const warmupSize = 2;

  final PlacementBank bank;

  CefrLevel _level;
  int _warmupLeft = 0;
  int _warmupIndex = 0;
  int _stageIndex = 0;
  int _stageCorrect = 0;
  int _asked = 0;
  CefrLevel? _result;
  CefrLevel? _lastPassed;

  bool get finished => _result != null;

  /// Önerilen başlangıç seviyesi (bitince).
  CefrLevel? get result => _result;

  /// Şu an sorulan basamak (ısınmada başlangıç basamağı).
  CefrLevel get level => _level;

  bool get inWarmup => _warmupLeft > 0;

  /// Şimdiye kadar sorulan soru sayısı (ısınma dahil).
  int get asked => _asked;

  /// Ekranda "Soru N" için (1'den başlar).
  int get questionNumber => _asked + 1;

  PlacementItem? get current {
    if (finished) return null;
    if (inWarmup) return bank.warmup[_warmupIndex];
    return bank.stages[_level]![_stageIndex];
  }

  /// [option] seçilen seçeneğin sırası; `null` = "Bilmiyorum".
  void answer(int? option) {
    final item = current;
    if (item == null) return;
    final correct = option != null && option == item.answer;
    _asked++;
    if (inWarmup) {
      _warmupLeft--;
      _warmupIndex++;
    } else {
      if (correct) _stageCorrect++;
      _stageIndex++;
      if (_stageIndex >= stageSize) _closeStage();
    }
    if (!finished && _asked >= bank.maxQuestions) {
      // Sınır: o ana kadar geçilen en yüksek basamak (yoksa başlangıç).
      _result = _lastPassed ?? _level;
    }
  }

  void _closeStage() {
    final score = _stageCorrect;
    _stageIndex = 0;
    _stageCorrect = 0;
    if (score >= 3) {
      _lastPassed = _level;
      final up = _level.next;
      if (up == null) {
        _result = _level;
      } else {
        _level = up;
      }
    } else if (score == 2) {
      _result = _level;
    } else {
      _result = _level.previous ?? CefrLevel.a1;
    }
  }
}
