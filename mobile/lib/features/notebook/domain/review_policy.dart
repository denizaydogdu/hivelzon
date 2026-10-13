// Tekrar kuralları (H-036): FSRS ayarı, günlük yeni kart sınırı, cevabın
// FSRS notuna çevrilmesi ve görev türünün seçimi. Saf Dart.

import '../../../shared/fsrs/fsrs.dart';

/// Hatırlama görevleri (kullanıcı kararı 2026-10-12: resimden seç → dinle-seç
/// → yaz/diz). Konuşma (mikrofon) MVP'de yok.
enum TaskType {
  /// Resim + Türkçe anlam → doğru İngilizce ifadeyi seç (4 seçenek).
  pictureChoice('picture_choice'),

  /// Karakterin sesini dinle → doğru ifadeyi seç (4 seçenek).
  listenChoice('listen_choice'),

  /// Türkçe anlam + resim → kelimeleri sıraya diz (kalıp/cümle).
  arrange('arrange'),

  /// Türkçe anlam + resim → kelimeyi yaz (tek kelime).
  type('type'),

  /// Seçenek üretilemiyorsa: kartı düşün, sonra "Bildim / Bilmiyorum".
  selfCheck('self_check'),

  /// Konu setinin sahne avı (H-051): kelimeyi sahne görselinde bul. Tekrar
  /// oturumu bu görevi seçmez; sonuç yalnızca sahne avından yazılır.
  sceneHunt('scene_hunt');

  const TaskType(this.code);

  final String code;

  static TaskType parse(String code) =>
      values.firstWhere((t) => t.code == code, orElse: () => selfCheck);
}

/// Kartın tekrar geçmişinden görev seçimi için gereken özet.
class CardStage {
  const CardStage({
    required this.reps,
    required this.state,
    this.stability,
    this.lapses = 0,
  });

  /// Toplam inceleme sayısı (0 = yeni).
  final int reps;
  final FsrsState state;
  final double? stability;
  final int lapses;

  bool get isNew => reps == 0;

  /// Olgun kart: uzun vadede tekrar edilen ve kararlılığı ≥ 21 gün olan
  /// (Anki'deki "mature" eşiği). Yalnızca olgun kartta hızlı doğru = Easy.
  bool get mature =>
      state == FsrsState.review && (stability ?? 0) >= ReviewPolicy.matureDays;
}

abstract final class ReviewPolicy {
  /// K-04: hedef hatırlama.
  static const double desiredRetention = 0.90;

  /// Öğrenme ve yeniden öğrenme adımı. Tek adım seçildi: "Bilmiyorum" denen
  /// kart oturumun sonunda yeniden sorulur; orada doğru bilinirse adım biter
  /// ve kart ertesi güne (≥ 1 gün) planlanır (kullanıcı kararı 2026-10-12).
  static const Duration learningStep = Duration(minutes: 10);

  static const double matureDays = 21;

  /// Günlük hedef (dk, H-013) → günde en fazla yeni kart.
  static const Map<int, int> newCardsPerDayByGoal = {5: 5, 10: 10, 15: 15};

  static const int defaultDailyGoalMinutes = 10;

  /// Bir oturumda en fazla kart (tekrarlar dahil değil).
  static const int sessionMaxCards = 20;

  /// Oturumda bir kartın sona kaç kez yeniden ekleneceği.
  static const int maxRequeuesPerCard = 2;

  static int newCardsPerDay(int goalMinutes) =>
      newCardsPerDayByGoal[goalMinutes] ??
      newCardsPerDayByGoal[defaultDailyGoalMinutes]!;

  static FsrsScheduler scheduler() => FsrsScheduler(
    desiredRetention: desiredRetention,
    learningSteps: const [learningStep],
    relearningSteps: const [learningStep],
  );

  /// Görev türü: aşamaya, ses/görsel varlığına ve ifade uzunluğuna göre.
  ///
  /// - yeni, öğrenme/yeniden öğrenme ya da 2'den az tekrar → resimden seç;
  /// - 2–3 tekrar ve ses var → dinle-seç (ses yoksa resimden seç);
  /// - 4+ tekrar → üretim: kalıp/cümlede kelimeleri diz, tek kelimede yaz.
  ///   A2 ve üstünde üretim 3. tekrardan başlar.
  /// - seçenek üretilemiyorsa (defterde tek kart) → kendini yokla.
  static TaskType chooseTask({
    required CardStage stage,
    required bool hasAudio,
    required bool multiWord,
    required int optionCount,
    String level = 'A1',
  }) {
    final productionAt = level.startsWith('A1') ? 4 : 3;
    final production =
        stage.state == FsrsState.review && stage.reps >= productionAt;
    if (production) return multiWord ? TaskType.arrange : TaskType.type;
    if (optionCount < 2) return TaskType.selfCheck;
    final learning = stage.isNew || stage.state != FsrsState.review;
    if (learning || stage.reps < 2) return TaskType.pictureChoice;
    return hasAudio ? TaskType.listenChoice : TaskType.pictureChoice;
  }

  /// Cevap → FSRS notu.
  ///
  /// - yanlış ya da "Bilmiyorum" → Again;
  /// - doğru ama yavaş → Hard;
  /// - doğru → Good;
  /// - olgun kartta hızlı doğru → Easy.
  ///
  /// Dinleme görevinde sesin süresi düşünme süresine eklenmez.
  static FsrsRating rate({
    required TaskType type,
    required bool correct,
    required Duration elapsed,
    required CardStage stage,
    Duration audioLength = Duration.zero,
  }) {
    if (!correct) return FsrsRating.again;
    final (fast, slow) = thresholds(type);
    final think = elapsed - audioLength;
    if (think > slow) return FsrsRating.hard;
    if (stage.mature && think < fast) return FsrsRating.easy;
    return FsrsRating.good;
  }

  /// (hızlı, yavaş) eşikleri.
  static (Duration, Duration) thresholds(TaskType type) => switch (type) {
    TaskType.pictureChoice || TaskType.listenChoice => (
      const Duration(seconds: 4),
      const Duration(seconds: 15),
    ),
    TaskType.arrange ||
    TaskType.type => (const Duration(seconds: 8), const Duration(seconds: 30)),
    TaskType.selfCheck => (
      const Duration(seconds: 3),
      const Duration(seconds: 20),
    ),
    TaskType.sceneHunt => (
      const Duration(seconds: 5),
      const Duration(seconds: 20),
    ),
  };
}
