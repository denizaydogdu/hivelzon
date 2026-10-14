import 'package:flutter/material.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
import '../../domain/grammar_lesson.dart';

/// Kodla çizilen şema (H-078; görsel kredisi yok): zaman çizgisi, kutu–ok
/// ve renkli ek. Yazı büyütülünce satır kırılır, taşmaz. Ekran okuyucu
/// şemayı tek cümle olarak okur.
class GrammarDiagramView extends StatelessWidget {
  const GrammarDiagramView({super.key, required this.diagram});

  final GrammarDiagram diagram;

  @override
  Widget build(BuildContext context) {
    final (child, label) = switch (diagram) {
      TimelineDiagram d => (_Timeline(d), _timelineLabel(d)),
      BoxesDiagram d => (_Boxes(d), _boxesLabel(d)),
      SuffixDiagram d => (_Suffix(d), _suffixLabel(d)),
    };
    return Semantics(
      container: true,
      label: '${GrammarTexts.diagramLabel}: $label',
      excludeSemantics: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpace.s12),
        decoration: const BoxDecoration(
          color: AppPalette.seaBlue50,
          borderRadius: AppRadius.mdAll,
        ),
        child: child,
      ),
    );
  }

  static String _timelineLabel(TimelineDiagram d) =>
      [for (final p in d.points) '${_at(p.at)}: ${p.text}'].join(', ');

  static String _boxesLabel(BoxesDiagram d) => [
    for (final b in d.boxes)
      b.caption == null ? b.text : '${b.text} (${b.caption})',
  ].join(', ');

  static String _suffixLabel(SuffixDiagram d) => [
    for (final w in d.words) '${w.base} + ${w.suffix} = ${w.word}',
  ].join(', ');
}

String _at(TimelineAt at) => switch (at) {
  TimelineAt.past => GrammarTexts.timelinePast,
  TimelineAt.now => GrammarTexts.timelineNow,
  TimelineAt.future => GrammarTexts.timelineFuture,
};

/// Zaman çizgisi: geçmiş · şimdi · gelecek; her noktanın altında örnek.
class _Timeline extends StatelessWidget {
  const _Timeline(this.d);

  final TimelineDiagram d;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Çizgi ve noktalar.
        SizedBox(
          height: AppSpace.s24,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(height: 3, color: AppPalette.seaBlue300),
              Row(
                children: [
                  for (final at in TimelineAt.values)
                    Expanded(
                      child: Center(
                        child: Container(
                          width: AppSpace.s16,
                          height: AppSpace.s16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: d.points.any((p) => p.at == at)
                                ? AppPalette.lighthouseYellow
                                : AppPalette.white,
                            border: Border.all(
                              color: AppPalette.seaBlue,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.s4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final at in TimelineAt.values)
              Expanded(
                child: Column(
                  children: [
                    Text(
                      _at(at),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppPalette.ink500,
                      ),
                    ),
                    for (final p in d.points.where((p) => p.at == at))
                      Text(
                        p.text,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppPalette.ink,
                          fontWeight: AppFonts.bold,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Kutu–ok: cümlenin parçaları sırayla, altında görevleri ("özne").
class _Boxes extends StatelessWidget {
  const _Boxes(this.d);

  final BoxesDiagram d;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = <Widget>[];
    for (final (i, b) in d.boxes.indexed) {
      if (i > 0 && d.arrows) {
        items.add(
          const Padding(
            padding: EdgeInsets.only(top: AppSpace.s8),
            child: Icon(
              Icons.arrow_forward_rounded,
              size: AppIconSize.md - AppSpace.s4,
              color: AppPalette.seaBlue,
            ),
          ),
        );
      }
      items.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpace.s12,
                vertical: AppSpace.s8,
              ),
              decoration: BoxDecoration(
                color: i == 1 ? AppPalette.yellow100 : AppPalette.white,
                borderRadius: AppRadius.smAll,
                border: Border.all(
                  color: i == 1
                      ? AppPalette.lighthouseYellow
                      : AppPalette.seaBlue200,
                  width: 2,
                ),
              ),
              child: Text(
                b.text,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppPalette.ink,
                ),
              ),
            ),
            if (b.caption != null) ...[
              const SizedBox(height: AppSpace.s4),
              Text(
                b.caption!,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppPalette.ink500,
                ),
              ),
            ],
          ],
        ),
      );
    }
    return Wrap(
      spacing: AppSpace.s8,
      runSpacing: AppSpace.s8,
      alignment: WrapAlignment.center,
      children: items,
    );
  }
}

/// Renkli ek: kök + ek (`go` + `es`), ek turuncu zeminli.
class _Suffix extends StatelessWidget {
  const _Suffix(this.d);

  final SuffixDiagram d;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.titleLarge?.copyWith(color: AppPalette.ink);
    return Wrap(
      spacing: AppSpace.s16,
      runSpacing: AppSpace.s8,
      alignment: WrapAlignment.center,
      children: [
        for (final w in d.words)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(w.base, style: style),
              Container(
                margin: const EdgeInsets.only(left: 2),
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4),
                decoration: const BoxDecoration(
                  color: AppPalette.orange100,
                  borderRadius: AppRadius.smAll,
                ),
                child: Text(
                  w.suffix,
                  style: style?.copyWith(color: AppPalette.orange700),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
