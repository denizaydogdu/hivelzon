// Tekrar kuralları (H-036): FSRS ayarı, günlük yeni kart sınırı, cevabın
// FSRS notuna çevrilmesi ve görev türünün seçimi. Saf Dart.

import '../../../shared/fsrs/fsrs.dart';
import '../../../shared/speech/speech_match.dart';

/// Hatırlama görevleri (kullanıcı kararı 2026-10-12: resimden seç → dinle-seç
/// → yaz/diz). H-055: cihazda tanıma varsa "Dinle ve söyle" de karışır.
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
  sceneHunt('scene_hunt'),

  /// "Dinle ve söyle" (H-055): karakterin sesini dinle, ifadeyi söyle.
  /// Yalnızca cihazda tanıma varsa, sesli kalıp/cümle kartında, orta-geç
  /// aşamada (bkz. [ReviewPolicy.chooseTask]).
  speak('speak');

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

  /// "Dinle ve söyle"nin en erken geldiği tekrar sayısı (H-055).
  static const int speakFromReps = 2;

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
  ///
  /// H-055 "Dinle ve söyle": [canSpeak] (cihazda tanıma var ve açık), ses var,
  /// kalıp/cümle ve kart uzun vade tekrarda iken `reps % 3 == 2` olduğunda
  /// (2., 5., 8. … tekrar) diğer görevlerin yerine gelir; böylece seçme,
  /// dizme ve söyleme karışık sırayla gelir.
  static TaskType chooseTask({
    required CardStage stage,
    required bool hasAudio,
    required bool multiWord,
    required int optionCount,
    String level = 'A1',
    bool canSpeak = false,
  }) {
    if (canSpeak &&
        hasAudio &&
        multiWord &&
        stage.state == FsrsState.review &&
        stage.reps >= speakFromReps &&
        stage.reps % 3 == 2) {
      return TaskType.speak;
    }
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

  /// "Dinle ve söyle" sonucu → FSRS notu (H-055; puan gösterilmez):
  ///
  /// - tam → Good; olgun kartta ilk denemede hızlı tam → Easy;
  /// - yakın (tek kelime duyulmadı) → Hard;
  /// - full ama ikinci denemede → Hard (kullanıcı kararı 2026-10-13).
  /// - 2 denemede de olmadı ya da "Bilmiyorum" → Again.
  ///
  /// "Geç" not vermez (kart sonraki oturumda yine gelir).
  static FsrsRating rateSpeech({
    required SpeechMatchLevel level,
    required Duration elapsed,
    required CardStage stage,
    int attempts = 1,
    Duration audioLength = Duration.zero,
  }) {
    switch (level) {
      case SpeechMatchLevel.no:
        return FsrsRating.again;
      case SpeechMatchLevel.close:
        return FsrsRating.hard;
      case SpeechMatchLevel.full:
        // İkinci denemede tam söylemek "zorlandı" sayılır (kullanıcı kararı 2026-10-13).
        if (attempts > 1) return FsrsRating.hard;
        final (fast, _) = thresholds(TaskType.speak);
        final think = elapsed - audioLength;
        if (stage.mature && attempts == 1 && think < fast) {
          return FsrsRating.easy;
        }
        return FsrsRating.good;
    }
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
    TaskType.speak => (const Duration(seconds: 6), const Duration(seconds: 25)),
  };
}
