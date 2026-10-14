import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/speech/speak_widgets.dart';
import '../../../../shared/ui/ui.dart';
import '../../../player/presentation/widgets/hi_avatar.dart';
import '../../application/lesson_controller.dart';
import '../../domain/grammar_lesson.dart';
import 'diagrams.dart';
import 'practice_view.dart';

/// Örnekteki kelimeye dokunuldu ([word] null: cümlenin tamamı).
typedef ExampleTap = void Function(GrammarExample example, int? word);

/// Kural kartının deftere eklenme durumu.
enum RuleSaveState { idle, saving, added, exists }

/// Tek ders kartı (H-078): Hi'nin Türkçe anlatımı (okunan kelime vurgulu),
/// şemalar, İngilizce örnekler (hedef yapı işaretli, sesli), "Türkçede
/// nasıl?" karşılaştırması, alıştırma, "Hikâyede gör" ve kural kartı.
class LessonCardView extends StatelessWidget {
  const LessonCardView({
    super.key,
    required this.lesson,
    required this.card,
    required this.controller,
    required this.onExampleTap,
    required this.onOpenLink,
    required this.linkSource,
    required this.ruleState,
    required this.onAddRule,
    this.speak,
  });

  final GrammarLesson lesson;
  final GrammarCard card;
  final LessonController controller;
  final ExampleTap onExampleTap;
  final void Function(GrammarStoryLink link) onOpenLink;

  /// "Bölüm: The New Neighbour" gibi kaynak satırı.
  final String Function(GrammarStoryLink link) linkSource;
  final RuleSaveState ruleState;
  final VoidCallback onAddRule;

  /// "Söyle" (H-055); null: cihazda tanıma yok.
  final SpeakEnv? speak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = controller;
    final active = c.card.id == card.id;
    final n = card.narration;
    final children = <Widget>[
      _CardHeader(card: card, speaking: active && c.narrationPlace != null),
      if (n != null) ...[
        const SizedBox(height: AppSpace.s12),
        _NarrationView(
          card: card,
          narration: n,
          place: active ? c.narrationPlace : null,
          emphasized: card.type == GrammarCardType.rule,
        ),
        if (active && c.canPlayNarration) ...[
          const SizedBox(height: AppSpace.s8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: _ListenButton(controller: c),
          ),
        ],
      ],
      for (final d in card.diagrams) ...[
        const SizedBox(height: AppSpace.s16),
        GrammarDiagramView(diagram: d),
      ],
      if (card.type == GrammarCardType.examples) ...[
        const SizedBox(height: AppSpace.s8),
        Text(
          GrammarTexts.examplesHint,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppPalette.ink500),
        ),
      ],
      if (card.wrong.isNotEmpty) ...[
        const SizedBox(height: AppSpace.s16),
        for (final w in card.wrong) _WrongView(wrong: w),
      ],
      for (final (i, e) in card.examples.indexed) ...[
        SizedBox(height: i == 0 ? AppSpace.s16 : AppSpace.s8),
        if (card.type == GrammarCardType.contrast && i == 0) ...[
          const CapsLabel(GrammarTexts.rightLabel, tone: CapsTone.blue),
          const SizedBox(height: AppSpace.s4),
        ],
        ExampleView(
          example: e,
          controller: c,
          onTap: (word) => onExampleTap(e, word),
        ),
      ],
      if (card.practice.isNotEmpty) ...[
        const SizedBox(height: AppSpace.s16),
        PracticeView(
          key: ValueKey('practice-${lesson.id}-${card.id}'),
          lessonId: lesson.id,
          items: card.practice,
          controller: c,
          speak: speak,
        ),
      ],
      for (final l in card.links) ...[
        const SizedBox(height: AppSpace.s12),
        _LinkView(link: l, source: linkSource(l), onOpen: () => onOpenLink(l)),
      ],
      if (card.type == GrammarCardType.rule) ...[
        const SizedBox(height: AppSpace.s24),
        _RuleButton(state: ruleState, onAdd: onAddRule),
      ],
    ];
    return Column(
      key: ValueKey('lesson-card-${card.id}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.card, required this.speaking});

  final GrammarCard card;
  final bool speaking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = GrammarTexts.cardLabel(card.type.name);
    final title = card.title;
    return Row(
      children: [
        // Hi küçük (H-063'ün HiAvatar'ı olduğu gibi); anlatırken parlar.
        Semantics(
          label: speaking ? GrammarTexts.hiSpeaking : GrammarTexts.hiLabel,
          child: ExcludeSemantics(
            child: HiAvatar(
              key: ValueKey('lesson-hi-${speaking ? 'on' : 'off'}'),
              size: AppSpace.s48,
              glow: speaking,
              pulseCycles: 2,
            ),
          ),
        ),
        const SizedBox(width: AppSpace.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CapsLabel(label),
              if (title != null && title != label) ...[
                const SizedBox(height: AppSpace.s4),
                Semantics(
                  header: true,
                  child: Text(title, style: theme.textTheme.titleLarge),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Türkçe anlatım: okunan cümle hafif, okunan kelime belirgin vurgulu.
class _NarrationView extends StatelessWidget {
  const _NarrationView({
    required this.card,
    required this.narration,
    required this.place,
    required this.emphasized,
  });

  final GrammarCard card;
  final Narration narration;
  final (int, int?)? place;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base =
        (emphasized
                ? theme.textTheme.titleLarge
                : AppTypography.lead.copyWith(fontWeight: AppFonts.regular))
            ?.copyWith(color: AppPalette.ink);
    final spans = <InlineSpan>[];
    for (final (si, s) in narration.sentences.indexed) {
      if (si > 0) spans.add(const TextSpan(text: ' '));
      final onSentence = place?.$1 == si;
      for (final (wi, w) in s.tokens.indexed) {
        if (wi > 0) {
          spans.add(
            TextSpan(
              text: ' ',
              style: onSentence
                  ? const TextStyle(backgroundColor: AppPalette.yellow50)
                  : null,
            ),
          );
        }
        final onWord = onSentence && place?.$2 == wi;
        spans.add(
          TextSpan(
            text: w,
            style: onWord
                ? const TextStyle(
                    backgroundColor: AppPalette.yellow200,
                    fontWeight: AppFonts.bold,
                  )
                : onSentence
                ? const TextStyle(backgroundColor: AppPalette.yellow50)
                : null,
          ),
        );
      }
    }
    return Semantics(
      container: true,
      label: narration.text,
      child: ExcludeSemantics(
        child: Text.rich(
          TextSpan(children: spans),
          key: ValueKey(
            'narration-${card.id}'
            '${place == null ? '' : '-${place!.$1}-${place!.$2}'}',
          ),
          style: base,
        ),
      ),
    );
  }
}

class _ListenButton extends StatelessWidget {
  const _ListenButton({required this.controller});

  final LessonController controller;

  @override
  Widget build(BuildContext context) {
    final playing = controller.clipKind == LessonClipKind.narration;
    return OutlinedButton.icon(
      key: const ValueKey('lesson-listen'),
      onPressed: () => unawaited(controller.toggleNarration()),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, AppTouch.min),
        backgroundColor: AppPalette.white,
      ),
      icon: Icon(playing ? Icons.stop_rounded : Icons.volume_up_rounded),
      label: Text(playing ? GrammarTexts.stop : GrammarTexts.listen),
    );
  }
}

/// İngilizce örnek: hedef yapı işaretli; çalarken okunan kelime vurgulu;
/// kelimeye dokununca anlam paneli. Sesi yoksa çal düğmesi görünmez.
class ExampleView extends StatelessWidget {
  const ExampleView({
    super.key,
    required this.example,
    required this.controller,
    required this.onTap,
  });

  final GrammarExample example;
  final LessonController controller;
  final ValueChanged<int?> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = controller;
    final e = example;
    final playing = c.playingId == e.id;
    final spoken = playing ? c.exampleWord : null;
    final style = AppTypography.lead.copyWith(color: AppPalette.ink);
    final spans = <InlineSpan>[];
    for (final (i, t) in e.tokens.indexed) {
      if (i > 0) spans.add(TextSpan(text: ' ', style: style));
      final on = spoken == i;
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: GestureDetector(
            key: ValueKey('ex-${e.id}-w$i'),
            behavior: HitTestBehavior.opaque,
            onTap: () => onTap(i),
            child: Text(
              t.text,
              style: style.copyWith(
                fontWeight: t.target ? AppFonts.bold : null,
                color: t.target ? AppPalette.orange700 : AppPalette.ink,
                backgroundColor: on
                    ? AppPalette.seaBlue100
                    : t.target
                    ? AppPalette.yellow100
                    : null,
                decoration: t.target ? TextDecoration.underline : null,
                decorationColor: AppPalette.eveningOrange,
                decorationThickness: 2,
              ),
            ),
          ),
        ),
      );
    }
    final canPlay = c.canPlay(e.audio);
    return Container(
      key: ValueKey('example-${e.id}'),
      decoration: const BoxDecoration(
        color: AppPalette.white,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.level1,
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpace.s12,
        AppSpace.s8,
        AppSpace.s4,
        AppSpace.s8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              container: true,
              button: true,
              label: e.tr == null ? e.en : '${e.en} ${e.tr}',
              hint: ReaderTexts.sentenceHint,
              onTap: () => onTap(null),
              child: ExcludeSemantics(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: AppTouch.min),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(TextSpan(children: spans)),
                      if (e.tr != null)
                        Text(
                          e.tr!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppPalette.ink500,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (canPlay)
            IconButton(
              key: ValueKey('play-${e.id}'),
              tooltip: GrammarTexts.playExample(e.en),
              onPressed: () => unawaited(
                playing
                    ? c.stop()
                    : c.playExample(
                        id: e.id,
                        text: e.en,
                        audio: e.audio,
                        words: e.words,
                        start: e.start,
                        end: e.end,
                        duration: e.duration,
                      ),
              ),
              color: AppPalette.seaBlue,
              icon: Icon(
                playing ? Icons.stop_circle_outlined : Icons.volume_up_rounded,
              ),
            ),
        ],
      ),
    );
  }
}

/// Yanlış biçim: nazikçe, üstü çizili değil; kısa Türkçe açıklamayla.
class _WrongView extends StatelessWidget {
  const _WrongView({required this.wrong});

  final WrongForm wrong;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      key: ValueKey('wrong-${wrong.id}'),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpace.s8),
      padding: const EdgeInsets.all(AppSpace.s12),
      decoration: const BoxDecoration(
        color: AppPalette.orange50,
        borderRadius: AppRadius.mdAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CapsLabel(GrammarTexts.wrongLabel),
          const SizedBox(height: AppSpace.s4),
          Text(
            wrong.en,
            style: AppTypography.lead.copyWith(color: AppPalette.ink700),
          ),
          if (wrong.tr != null)
            Text(
              wrong.tr!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppPalette.ink500,
              ),
            ),
        ],
      ),
    );
  }
}

/// "Hikâyede gör": gerçek cümle, kaynağı ve açma düğmesi.
class _LinkView extends StatelessWidget {
  const _LinkView({
    required this.link,
    required this.source,
    required this.onOpen,
  });

  final GrammarStoryLink link;
  final String source;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final episode = link.kind == StoryLinkKind.episode;
    return Container(
      key: ValueKey('link-${link.contentId}-${link.cueId ?? link.sentenceId}'),
      padding: const EdgeInsets.all(AppSpace.s12),
      decoration: const BoxDecoration(
        color: AppPalette.white,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.level1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ExcludeSemantics(
                child: Icon(
                  episode ? Icons.map_outlined : Icons.menu_book_rounded,
                  size: AppIconSize.md - AppSpace.s4,
                  color: AppPalette.orange700,
                ),
              ),
              const SizedBox(width: AppSpace.s8),
              Expanded(
                child: Text(
                  source,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppPalette.orange700,
                    fontWeight: AppFonts.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpace.s8),
          Text(
            '“${link.cueText ?? link.text}”',
            style: AppTypography.lead.copyWith(color: AppPalette.ink),
          ),
          const SizedBox(height: AppSpace.s8),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              key: ValueKey('open-link-${link.contentId}'),
              onPressed: onOpen,
              style: TextButton.styleFrom(
                minimumSize: const Size(0, AppTouch.min),
              ),
              icon: const Icon(Icons.open_in_new_rounded),
              label: Text(
                episode ? GrammarTexts.openEpisode : GrammarTexts.openBook,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RuleButton extends StatelessWidget {
  const _RuleButton({required this.state, required this.onAdd});

  final RuleSaveState state;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final saved = state == RuleSaveState.added || state == RuleSaveState.exists;
    if (saved) {
      return SoftEntrance(
        child: Container(
          key: const ValueKey('rule-saved'),
          padding: const EdgeInsets.all(AppSpace.s12),
          decoration: const BoxDecoration(
            color: AppPalette.successSurface,
            borderRadius: AppRadius.mdAll,
          ),
          child: Row(
            children: [
              const ExcludeSemantics(
                child: Icon(
                  Icons.bookmark_added_rounded,
                  color: AppPalette.success,
                ),
              ),
              const SizedBox(width: AppSpace.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state == RuleSaveState.added
                          ? GrammarTexts.ruleAdded
                          : GrammarTexts.ruleExists,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppPalette.success,
                      ),
                    ),
                    Text(
                      GrammarTexts.ruleNote,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppPalette.ink700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return FilledButton.icon(
      key: const ValueKey('rule-add'),
      onPressed: state == RuleSaveState.saving ? null : onAdd,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(AppTouch.primary),
      ),
      icon: const Icon(Icons.bookmark_add_outlined),
      label: const Text(GrammarTexts.addRule),
    );
  }
}
