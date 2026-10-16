import '../../player/presentation/widgets/hi_avatar.dart';
import '../domain/coach_rules.dart';

/// "Geç akşam" (yerel saat): 21.00–04.59. Bu saatte dinlenme önerisinde Hi
/// uykulu görünür.
bool isLateEvening(DateTime local) => local.hour >= 21 || local.hour < 5;

/// Hi panelinde önerinin türüne göre Hi'nin ifadesi (H-063):
/// - Hi'nin notu (tekrarlayan hata) → düşünen;
/// - dinlenme önerisi → geç akşamsa uykulu, değilse mutlu;
/// - hikâye, kitap ve sahne avı önerileri → mutlu;
/// - dilbilgisi önerisi → düşünen (bir yapıyı birlikte inceleme);
/// - tekrar ve defter → varsayılan (sakin).
HiExpression hiExpressionForSuggestion(
  HiSuggestionKind kind, {
  required DateTime now,
}) => switch (kind) {
  HiSuggestionKind.errorNote ||
  HiSuggestionKind.grammarSuggest => HiExpression.thinking,
  HiSuggestionKind.rest =>
    isLateEvening(now) ? HiExpression.sleepy : HiExpression.happy,
  HiSuggestionKind.continueEpisode ||
  HiSuggestionKind.startEpisode ||
  HiSuggestionKind.continueBook ||
  HiSuggestionKind.startBook ||
  HiSuggestionKind.sceneHunt ||
  HiSuggestionKind.talk => HiExpression.happy,
  HiSuggestionKind.review || HiSuggestionKind.notebook => HiExpression.neutral,
};
