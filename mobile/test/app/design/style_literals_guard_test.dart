import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// H-057 kabul kriteri: tasarım belirteçleri (`lib/app/design/**`,
/// `lib/app/theme.dart`) dışında yeni sabit renk (`Color(0x…)`) ya da
/// `fontSize:` yazılmaz.
///
/// Aşağıdaki taban çizgisi 2026-10-14'teki durumdur (H-057 sonrasında:
/// `Color(0x` 31 → 10, `fontSize:` 40 → 37). Sayılar yalnızca **azalabilir**:
/// ekran fazları (H-059…H-064) bir dosyayı temizleyince o dosyanın satırını
/// düşür ya da sil. Yeni dosyada (ör. `lib/shared/ui/`) sabit stil olmaz.
const _colorBaseline = <String, int>{
  'lib/features/story/presentation/widgets/map_painters.dart': 5,
  'lib/features/story/presentation/widgets/season_map_view.dart': 4,
  'lib/features/player/presentation/widgets/hi_avatar.dart': 1,
};

const _fontSizeBaseline = <String, int>{
  'lib/features/topic_sets/presentation/topic_set_screen.dart': 1,
  'lib/features/topic_sets/presentation/scene_hunt_screen.dart': 1,
  'lib/features/notebook/presentation/widgets/card_face.dart': 1,
  'lib/features/story/presentation/season_intro_screen.dart': 1,
  'lib/features/player/presentation/player_screen.dart': 3,
  'lib/features/player/presentation/widgets/opening_overlays.dart': 2,
  'lib/features/player/presentation/widgets/card_view.dart': 3,
  'lib/features/player/presentation/widgets/end_view.dart': 1,
  'lib/features/player/presentation/widgets/mission_sheet.dart': 1,
  'lib/features/player/presentation/widgets/decision_sheet.dart': 2,
  'lib/features/player/presentation/widgets/subtitle_overlay.dart': 2,
  'lib/features/player/presentation/widgets/task_view.dart': 3,
  'lib/features/player/presentation/widgets/player_top_bar.dart': 2,
  'lib/shared/meaning/meaning_sheet.dart': 13,
  'lib/shared/speech/speak_widgets.dart': 1,
};

bool _isTokenSource(String path) =>
    path.startsWith('lib/app/design/') || path == 'lib/app/theme.dart';

Map<String, int> _count(RegExp pattern) {
  final counts = <String, int>{};
  final files = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));
  for (final file in files) {
    final path = file.path.replaceAll(r'\', '/');
    if (_isTokenSource(path) || path.endsWith('.g.dart')) continue;
    final n = pattern.allMatches(file.readAsStringSync()).length;
    if (n > 0) counts[path] = n;
  }
  return counts;
}

List<String> _violations(Map<String, int> actual, Map<String, int> baseline) {
  return [
    for (final MapEntry(key: path, value: n) in actual.entries)
      if (n > (baseline[path] ?? 0)) '$path: $n (taban ${baseline[path] ?? 0})',
  ]..sort();
}

void main() {
  test('belirteç dışında yeni Color(0x…) yok', () {
    final actual = _count(RegExp(r'Color\(0x'));
    expect(
      _violations(actual, _colorBaseline),
      isEmpty,
      reason:
          'Renkleri lib/app/design/tokens.dart belirteçlerinden al '
          '(AppPalette, AppScrim).',
    );
  });

  test('belirteç dışında yeni fontSize: yok', () {
    final actual = _count(RegExp(r'fontSize:'));
    expect(
      _violations(actual, _fontSizeBaseline),
      isEmpty,
      reason:
          'Yazı boyutunu Theme.of(context).textTheme ya da AppTypography '
          'ile ver.',
    );
  });

  test('ortak bileşenler ve vitrin yalnız belirteç kullanır', () {
    final strict = RegExp(r'Color\(0x|fontSize:|FontWeight\.w[1-36-9]00');
    for (final dir in ['lib/shared/ui', 'lib/features/design_showcase']) {
      for (final f in Directory(
        dir,
      ).listSync(recursive: true).whereType<File>()) {
        expect(
          strict.hasMatch(f.readAsStringSync()),
          isFalse,
          reason: '${f.path}: sabit stil',
        );
      }
    }
  });

  test('taban çizgisi güncel (temizlenen dosya tabandan düşülür)', () {
    // Sayı tabanın altına indiyse tabanı da indir: kazanım geri gitmesin.
    final colors = _count(RegExp(r'Color\(0x'));
    final sizes = _count(RegExp(r'fontSize:'));
    final stale = [
      for (final MapEntry(key: p, value: n) in _colorBaseline.entries)
        if ((colors[p] ?? 0) < n) 'Color $p: ${colors[p] ?? 0} < $n',
      for (final MapEntry(key: p, value: n) in _fontSizeBaseline.entries)
        if ((sizes[p] ?? 0) < n) 'fontSize $p: ${sizes[p] ?? 0} < $n',
    ];
    expect(stale, isEmpty);
  });
}
