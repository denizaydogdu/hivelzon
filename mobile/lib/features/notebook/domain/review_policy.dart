// Tekrar kuralları (H-036): FSRS ayarı, günlük yeni kart sınırı, cevabın
// FSRS notuna çevrilmesi ve görev türünün seçimi. Saf Dart.

import '../../../shared/fsrs/fsrs.dart';
import '../../../shared/speech/speech_match.dart';

/// Kelime tekrarı görevleri (H-036, H-055, H-089).
///
/// H-089: görevler iki türdür. **Hatırlama** ([isRecall]) yardımsız geri
/// çağırmadır: Türkçe anlamdan İngilizceyi kendin üretirsin (yazarak,
/// söyleyerek ya da aklından söyleyip kartı açarak); sesi önce duymazsın,
/// seçenek görmezsin. FSRS'e yalnızca hatırlama yazılır. **Pratik** (taklit
/// ve tanıma: seçenekten seçmek, dinleyip seçmek, verilen kelimeleri dizmek,
/// dinleyip tekrar etmek, sahne avı) FSRS'e yazılmaz; yalnızca kanıt
/// basamağına "yardımla yaptı" olarak işlenir (`docs/KELIME-TEKRARI.md`).
enum TaskType {
  /// Resim + Türkçe anlam → doğru İngilizce ifadeyi seç (4 seçenek). Pratik.
  pictureChoice('picture_choice'),

  /// Karakterin sesini dinle → doğru ifadeyi seç (4 seçenek). Pratik.
  listenChoice('listen_choice'),

  /// Türkçe anlam + resim → verilen kelimeleri sıraya diz. Pratik.
  arrange('arrange'),

  /// Türkçe anlam + resim → kelimeyi yaz (tek kelime). Hatırlama.
  type('type'),

  /// Türkçe anlam + resim → İngilizcesini aklından söyle, sonra kartı aç:
  /// "Bildim / Bilmiyorum". Hatırlama (kendi değerlendirmen).
  selfCheck('self_check'),

  /// Konu setinin sahne avı (H-051): kelimeyi sahne görselinde bul. Tekrar
  /// oturumu bu görevi seçmez. Pratik (tanıma).
  sceneHunt('scene_hunt'),

  /// "Dinle ve söyle" (H-055): karakterin sesini dinle, ifadeyi tekrar et.
  /// Taklittir; pratik.
  speak('speak'),

  /// "Söyle" (H-089): Türkçe anlamdan İngilizcesini **sesi duymadan**
  /// söyle. Yalnızca cihazda tanıma varsa, kalıp/cümle kartında. Hatırlama.
  speakRecall('speak_recall');

  const TaskType(this.code);

  final String code;

  /// Yardımsız geri çağırma mı (FSRS'e yazılır). Değilse pratik.
  bool get isRecall => switch (this) {
    TaskType.type || TaskType.selfCheck || TaskType.speakRecall => true,
    _ => false,
  };

  /// Sonucu nesnel olarak denetlenen üretim (yazma ya da söyleme): kanıt
  /// basamağında "kendin kullandın" yalnız bunlardan gelir.
  bool get isCheckedProduction =>
      this == TaskType.type || this == TaskType.speakRecall;

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
  /// (Anki'deki "mature" eşiği). Yalnızca olgun kartta, nesnel üretimde
  /// hızlı doğru = Easy.
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

  /// Görev türü (H-089).
  ///
  /// **Hatırlama** — vadesi gelen uzun vade kartı (`review`) ya da pratikten
  /// sonra oturum sonunda gelen soru ([recallOnly]). Önce yardım yok:
  /// - genç kart (A1'de 4'ten, A2+'da 3'ten az tekrar) → kendini yokla;
  /// - üretim aşaması: tek kelime → yaz; kalıp/cümle ve cihazda tanıma
  ///   açık → sesi duymadan söyle; değilse kendini yokla.
  ///
  /// **Pratik** — yeni, öğrenme ve yeniden öğrenme kartı. Önce destekli
  /// görev, başarılı olursa aynı oturumun sonunda hatırlama sorusu gelir:
  /// - yeni / hiç tekrar edilmemiş → resimden seç;
  /// - yeniden gelen (en az 1 tekrar): tanıma açık, ses var, kalıp/cümle ve
  ///   tek sayılı tekrarda → dinle ve söyle; ses varsa → dinle-seç; kalıp/
  ///   cümle → diz; yoksa resimden seç;
  /// - seçenek üretilemiyorsa (defterde tek kart) kalıp/cümle → diz; tek
  ///   kelimede pratik yok, doğrudan hatırlama.
  static TaskType chooseTask({
    required CardStage stage,
    required bool hasAudio,
    required bool multiWord,
    required int optionCount,
    String level = 'A1',
    bool canSpeak = false,
    bool recallOnly = false,
  }) {
    final review = !stage.isNew && stage.state == FsrsState.review;
    if (recallOnly || review) {
      return chooseRecallTask(
        stage: stage,
        multiWord: multiWord,
        level: level,
        canSpeak: canSpeak,
      );
    }
    return choosePracticeTask(
          stage: stage,
          hasAudio: hasAudio,
          multiWord: multiWord,
          optionCount: optionCount,
          canSpeak: canSpeak,
        ) ??
        chooseRecallTask(
          stage: stage,
          multiWord: multiWord,
          level: level,
          canSpeak: canSpeak,
        );
  }

  /// Üretimin (yazma / sesi duymadan söyleme) başladığı tekrar sayısı.
  static int productionFromReps(String level) => level.startsWith('A1') ? 4 : 3;

  static TaskType chooseRecallTask({
    required CardStage stage,
    required bool multiWord,
    String level = 'A1',
    bool canSpeak = false,
  }) {
    if (stage.reps < productionFromReps(level)) return TaskType.selfCheck;
    if (!multiWord) return TaskType.type;
    return canSpeak ? TaskType.speakRecall : TaskType.selfCheck;
  }

  /// Destekli görev; uygun pratik yoksa null.
  static TaskType? choosePracticeTask({
    required CardStage stage,
    required bool hasAudio,
    required bool multiWord,
    required int optionCount,
    bool canSpeak = false,
  }) {
    final choices = optionCount >= 2;
    if (stage.reps > 0) {
      if (canSpeak && hasAudio && multiWord && stage.reps.isOdd) {
        return TaskType.speak;
      }
      if (hasAudio && choices) return TaskType.listenChoice;
    }
    if (choices && (stage.reps == 0 || !multiWord)) {
      return TaskType.pictureChoice;
    }
    if (multiWord) return TaskType.arrange;
    return null;
  }

  /// Hatırlama cevabı → FSRS notu (H-089).
  ///
  /// - yanlış ya da "Bilmiyorum" → Again;
  /// - doğru → Good. **Yavaş cevap artık Hard sayılmaz** (okuma, yazma ve
  ///   ekran okuyucu hızı hafızayı ölçmez; erişilebilirlik);
  /// - olgun kartta, nesnel üretimde (yaz / söyle) hızlı doğru → Easy.
  ///   Kendini yoklamada hız ölçülmez (Good).
  ///
  /// Pratik görevleri not almaz ([ReviewSession] FSRS'e yazmaz); burada
  /// çağrılırlarsa doğru cevap en çok Hard döner.
  static FsrsRating rate({
    required TaskType type,
    required bool correct,
    required Duration elapsed,
    required CardStage stage,
    Duration audioLength = Duration.zero,
  }) {
    if (!correct) return FsrsRating.again;
    if (!type.isRecall) return FsrsRating.hard;
    final (fast, _) = thresholds(type);
    final think = elapsed - audioLength;
    if (type.isCheckedProduction && stage.mature && think < fast) {
      return FsrsRating.easy;
    }
    return FsrsRating.good;
  }

  /// "Söyle" (sesi duymadan, [TaskType.speakRecall]) sonucu → FSRS notu:
  ///
  /// - tam → Good; olgun kartta ilk denemede hızlı tam → Easy;
  /// - tam ama ikinci denemede → Hard (kullanıcı kararı 2026-10-13);
  /// - yakın, yalnızca bir kelime duyulmadı → Hard;
  /// - yakın ama anlamı değiştiren fazla kelime var ([changedWords] dolu,
  ///   H-087: olumsuzluk, kip, sayı, soru) → **Again**: hatırlamada anlam
  ///   değişmişse doğru sayılmaz (H-089);
  /// - 2 denemede de olmadı ya da "Bilmiyorum" → Again.
  ///
  /// "Geç" not vermez (kart sonraki oturumda yine gelir).
  static FsrsRating rateSpeech({
    required SpeechMatchLevel level,
    required Duration elapsed,
    required CardStage stage,
    int attempts = 1,
    List<String> changedWords = const [],
    Duration audioLength = Duration.zero,
  }) {
    switch (level) {
      case SpeechMatchLevel.no:
        return FsrsRating.again;
      case SpeechMatchLevel.close:
        return changedWords.isEmpty ? FsrsRating.hard : FsrsRating.again;
      case SpeechMatchLevel.full:
        // İkinci denemede tam söylemek "zorlandı" sayılır (kullanıcı kararı 2026-10-13).
        if (attempts > 1) return FsrsRating.hard;
        final (fast, _) = thresholds(TaskType.speakRecall);
        final think = elapsed - audioLength;
        if (stage.mature && think < fast) return FsrsRating.easy;
        return FsrsRating.good;
    }
  }

  /// "Dinle ve söyle" (taklit) başarılı mı: tam, ya da yalnızca bir kelime
  /// duyulmadı (anlamı değiştiren ek yoksa). FSRS'e yazılmaz (H-089).
  static bool speechPracticeSucceeded(
    SpeechMatchLevel level, {
    List<String> changedWords = const [],
  }) => switch (level) {
    SpeechMatchLevel.full => true,
    SpeechMatchLevel.close => changedWords.isEmpty,
    SpeechMatchLevel.no => false,
  };

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
    TaskType.speak || TaskType.speakRecall => (
      const Duration(seconds: 6),
      const Duration(seconds: 25),
    ),
  };
}
