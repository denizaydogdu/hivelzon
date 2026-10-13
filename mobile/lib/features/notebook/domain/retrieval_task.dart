// Hatırlama görevi üretimi (H-036). Saf Dart.

import 'dart:math' as math;

import 'notebook_item.dart';
import 'review_policy.dart';

/// Ekrana gelecek tek görev.
class RetrievalTask {
  const RetrievalTask({
    required this.type,
    required this.item,
    this.options = const [],
    this.correctIndex = -1,
    this.tokens = const [],
    this.answerTokens = const [],
  });

  final TaskType type;
  final NotebookItem item;

  /// Seçmeli görevlerde İngilizce seçenekler.
  final List<String> options;
  final int correctIndex;

  /// Dizme görevinde karışık kelimeler ve doğru sıra.
  final List<String> tokens;
  final List<String> answerTokens;

  bool isCorrectChoice(int index) => index == correctIndex;

  bool isCorrectOrder(List<String> picked) =>
      picked.length == answerTokens.length &&
      [
        for (var i = 0; i < picked.length; i++) picked[i] == answerTokens[i],
      ].every((ok) => ok);

  /// Yazma görevi: büyük/küçük harf, noktalama ve `…` önemsiz.
  bool isCorrectTyped(String input) {
    String n(String s) => normalizeEn(s).replaceAll('…', '').trim();
    return n(input).isNotEmpty && n(input) == n(item.textEn);
  }
}

/// Dizme görevi için kelimeler: ifade `…` içeriyorsa örnek cümle kullanılır.
List<String> arrangeTokens(NotebookItem item) {
  final source = item.textEn.contains('…') && item.exampleEn != null
      ? item.exampleEn!
      : item.textEn;
  return source.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
}

/// Kart için görev kurar. Çeldiriciler defterden: önce aynı tür, sonra aynı
/// bölüm, sonra diğerleri; aynı İngilizceyi taşıyan kart çeldirici olmaz.
RetrievalTask buildTask({
  required NotebookItem item,
  required ReviewCardState card,
  required List<NotebookItem> pool,
  required math.Random random,
  String level = 'A1',
}) {
  final distractors = _distractors(item, pool, random, 3);
  final tokens = arrangeTokens(item);
  final type = ReviewPolicy.chooseTask(
    stage: card.stage,
    hasAudio: item.hasAudio,
    multiWord: tokens.length >= 2,
    optionCount: distractors.length + 1,
    level: level,
  );
  switch (type) {
    case TaskType.pictureChoice || TaskType.listenChoice:
      final options = [item.textEn, ...distractors]..shuffle(random);
      return RetrievalTask(
        type: type,
        item: item,
        options: options,
        correctIndex: options.indexOf(item.textEn),
      );
    case TaskType.arrange:
      final shuffled = List.of(tokens);
      for (var i = 0; i < 5 && _same(shuffled, tokens); i++) {
        shuffled.shuffle(random);
      }
      if (_same(shuffled, tokens)) {
        shuffled.add(shuffled.removeAt(0));
      }
      return RetrievalTask(
        type: type,
        item: item,
        tokens: shuffled,
        answerTokens: tokens,
      );
    case TaskType.type || TaskType.selfCheck || TaskType.sceneHunt:
      return RetrievalTask(type: type, item: item);
  }
}

bool _same(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

List<String> _distractors(
  NotebookItem item,
  List<NotebookItem> pool,
  math.Random random,
  int n,
) {
  final own = normalizeEn(item.textEn);
  final seen = <String>{own};
  final candidates = <NotebookItem>[
    for (final p in pool)
      if (seen.add(normalizeEn(p.textEn))) p,
  ]..shuffle(random);
  int score(NotebookItem p) =>
      (p.kind == item.kind ? 0 : 2) + (p.contentId == item.contentId ? 0 : 1);
  // Kararlı sıralama: karışık sıra aynı puan içinde korunur.
  final ranked = [
    for (var s = 0; s < 4; s++) ...candidates.where((p) => score(p) == s),
  ];
  return [for (final p in ranked.take(n)) p.textEn];
}
