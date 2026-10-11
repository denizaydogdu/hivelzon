// Görev öğelerinin cevap denetimi (docs/BOLUM-PAKETI.md §2.2, görev öğeleri).
//
// Saf Dart. Süre sınırı yoktur (K-32); yanlışta aynı öğe tekrar denenir.

import 'episode.dart';

/// `choice`: tam bir doğru seçenek.
bool checkChoice(TaskItem item, String optionId) {
  for (final o in item.options) {
    if (o.id == optionId) return o.correct;
  }
  return false;
}

/// `multiSelect`: bütün doğru seçenekler, yanlış hiçbiri.
bool checkMultiSelect(TaskItem item, Set<String> selected) {
  final correct = {
    for (final o in item.options)
      if (o.correct) o.id,
  };
  return correct.isNotEmpty &&
      selected.length == correct.length &&
      selected.containsAll(correct);
}

/// `order`: parçalar `answer` sırasında.
bool checkOrder(TaskItem item, List<String> tokens) {
  if (tokens.length != item.answer.length) return false;
  for (var i = 0; i < tokens.length; i++) {
    if (tokens[i] != item.answer[i]) return false;
  }
  return true;
}

/// `match`: her sol parça kendi sağ parçasıyla eşleşmiş.
bool checkMatch(TaskItem item, Map<String, String> leftToRight) {
  if (leftToRight.length != item.pairs.length) return false;
  for (final p in item.pairs) {
    if (leftToRight[p.left] != p.right) return false;
  }
  return true;
}

/// Tek bir boşluğun cevabı kabul ediliyor mu?
bool checkBlank(Blank blank, String answer) {
  final a = normalizeAnswer(answer);
  if (a.isEmpty) return false;
  if (blank.acceptAny) return true;
  return blank.accept.any((x) => normalizeAnswer(x) == a);
}

/// `fillBlank`: bütün boşluklar kabul ediliyor.
bool checkFillBlank(TaskItem item, Map<String, String> answers) {
  for (final b in item.blanks) {
    if (!checkBlank(b, answers[b.id] ?? '')) return false;
  }
  return item.blanks.isNotEmpty;
}

/// Büyük-küçük harf, baştaki/sondaki boşluk ve noktalama önemsenmez.
String normalizeAnswer(String s) => s
    .toLowerCase()
    .replaceAll(RegExp('[.,!?;:…“”"]'), '')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();

/// `fillBlank` gövdesini `___` yerlerinden böler: ["Hello! My name is ", ". I'm from ", "."].
List<String> splitBlankStem(String stem) => stem.split('___');
