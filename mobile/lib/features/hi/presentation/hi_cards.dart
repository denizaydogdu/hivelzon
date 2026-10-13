import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/text/turkish.dart';
import '../../player/presentation/widgets/hi_avatar.dart';
import '../domain/hi_content.dart';

/// Hi'nin notu (hata kataloğu, F1): Türkçeyle karşılaştıran kısa açıklama ve
/// "Türkçeden aklına gelen → İngilizcede" örnekleri. Kırmızı ya da çarpı yok.
class HiNoteCard extends StatelessWidget {
  const HiNoteCard({super.key, required this.note});

  final ErrorNote note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      key: ValueKey('hi-note-${note.id}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const HiAvatar(size: 48),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    HiTexts.noteLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.seaBlue,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Semantics(
                    header: true,
                    child: Text(
                      note.labelTr,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(note.explanationTr, style: theme.textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.sm),
        for (final ex in note.examples) ...[
          Card(
            margin: EdgeInsets.zero,
            color: Colors.white,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    HiTexts.noteTurkish,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.ink.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    ex.wrong,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.ink.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    HiTexts.noteEnglish,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.seaBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    ex.right,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
      ],
    );
  }
}

/// Hi'nin konu tanıtımı kartı (oynatıcıda ve Defter'de aynı görünüm).
class HiTopicCard extends StatelessWidget {
  const HiTopicCard({
    super.key,
    required this.intro,
    this.onContinue,
    this.onSkip,
  });

  final TopicIntro intro;
  final VoidCallback? onContinue;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      key: ValueKey('topic-intro-${intro.id}'),
      margin: EdgeInsets.zero,
      color: AppColors.sand,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const HiAvatar(size: 48),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        upperTr(HiTexts.topicLabel),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppColors.seaBlue,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Semantics(
                        header: true,
                        child: Text(
                          intro.titleEn,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (onSkip != null)
                  TextButton(
                    key: const ValueKey('topic-intro-skip'),
                    onPressed: onSkip,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(48, 48),
                    ),
                    child: const Text(HiTexts.topicSkip),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            for (final l in intro.linesTr)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  l,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.ink,
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    intro.exampleEn,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    intro.exampleTr,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.ink.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
            if (onContinue != null) ...[
              const SizedBox(height: AppSpacing.sm),
              FilledButton(
                key: const ValueKey('topic-intro-continue'),
                onPressed: onContinue,
                style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
                child: const Text(HiTexts.topicContinue),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Future<void> _sheet(BuildContext context, Widget child, {Key? key}) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      backgroundColor: AppColors.sand,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radius),
        ),
      ),
      builder: (context) => SingleChildScrollView(
        key: key,
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                tooltip: CommonTexts.close,
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
            child,
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );

Future<void> showHiNote(BuildContext context, ErrorNote note) => _sheet(
  context,
  HiNoteCard(note: note),
  key: const ValueKey('hi-note-sheet'),
);

Future<void> showTopicIntro(BuildContext context, TopicIntro intro) => _sheet(
  context,
  HiTopicCard(intro: intro),
  key: const ValueKey('topic-intro-sheet'),
);
