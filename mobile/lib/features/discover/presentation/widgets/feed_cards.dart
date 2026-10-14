import 'package:flutter/material.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/ui/ui.dart';
import '../../domain/clip.dart';

/// Video olmayan akış kartlarının ortak zemini: kum rengi, ortalanmış,
/// küçük ekranda ve büyük yazıda kaydırılabilir.
class FeedCardFrame extends StatelessWidget {
  const FeedCardFrame({super.key, required this.child, this.semanticsLabel});

  final Widget child;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    return ColoredBox(
      color: AppPalette.sand,
      child: Semantics(
        container: true,
        label: semanticsLabel,
        child: LayoutBuilder(
          builder: (context, box) => SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppSpace.s16,
              pad.top + AppSpace.s24,
              AppSpace.s16,
              pad.bottom + AppSpace.s24,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: (box.maxHeight - pad.vertical - AppSpace.s48).clamp(
                  0,
                  double.infinity,
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Quiz kartı (K-15): klibin sorusu. Puan ve süre yok; yanlışta "Bir daha
/// bakalım." ve yeniden deneme, "Bilmiyorum" doğru cevabı gösterir.
class QuizCard extends StatefulWidget {
  const QuizCard({super.key, required this.clip, required this.onNext});

  final FeedClip clip;
  final VoidCallback onNext;

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  final Set<int> _tried = {};
  bool _done = false;
  bool _revealed = false;

  ClipQuiz get _quiz => widget.clip.quiz!;

  void _pick(int i) {
    if (_done || _tried.contains(i)) return;
    setState(() {
      _tried.add(i);
      if (_quiz.options[i].correct) _done = true;
    });
  }

  void _dontKnow() => setState(() {
    _done = true;
    _revealed = true;
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final quiz = _quiz;
    final correct = quiz.correctIndex;
    final wrongLast =
        !_done && _tried.isNotEmpty && !quiz.options[_tried.last].correct;
    final feedback = _done
        ? (_revealed ? DiscoverTexts.quizShown : DiscoverTexts.quizCorrect)
        : (wrongLast ? DiscoverTexts.quizTryAgain : null);
    return FeedCardFrame(
      key: const ValueKey('quiz-card'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CapsLabel(DiscoverTexts.quizLabel),
          const SizedBox(height: AppSpace.s8),
          Semantics(
            header: true,
            child: Text(quiz.promptTr, style: t.headlineSmall),
          ),
          const SizedBox(height: AppSpace.s4),
          Text(
            DiscoverTexts.quizFrom(widget.clip.titleTr),
            style: t.bodyMedium?.copyWith(color: AppPalette.ink500),
          ),
          const SizedBox(height: AppSpace.s24),
          for (final (i, o) in quiz.options.indexed) ...[
            _OptionButton(
              key: ValueKey('quiz-opt-$i'),
              text: o.text,
              state: _done && i == correct
                  ? _OptionState.correct
                  : _tried.contains(i)
                  ? _OptionState.tried
                  : _OptionState.idle,
              onTap: _done ? null : () => _pick(i),
            ),
            const SizedBox(height: AppSpace.s8),
          ],
          if (feedback != null) ...[
            const SizedBox(height: AppSpace.s8),
            Semantics(
              liveRegion: true,
              child: Text(
                feedback,
                key: const ValueKey('quiz-feedback'),
                style: t.titleMedium?.copyWith(
                  color: _done ? AppPalette.success : AppPalette.ink700,
                ),
              ),
            ),
          ],
          if (_done && quiz.explainTr != null) ...[
            const SizedBox(height: AppSpace.s4),
            Text(
              quiz.explainTr!,
              key: const ValueKey('quiz-explain'),
              style: t.bodyLarge?.copyWith(color: AppPalette.ink700),
            ),
          ],
          const SizedBox(height: AppSpace.s24),
          if (_done)
            FilledButton(
              key: const ValueKey('quiz-next'),
              style: AppButtonStyles.primary(),
              onPressed: widget.onNext,
              child: const Text(DiscoverTexts.next),
            )
          else
            DontKnowButton(
              key: const ValueKey('quiz-dont-know'),
              label: DiscoverTexts.dontKnow,
              expand: true,
              onPressed: _dontKnow,
            ),
        ],
      ),
    );
  }
}

enum _OptionState { idle, tried, correct }

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    super.key,
    required this.text,
    required this.state,
    required this.onTap,
  });

  final String text;
  final _OptionState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border, icon) = switch (state) {
      _OptionState.correct => (
        AppPalette.successSurface,
        AppPalette.success,
        AppPalette.success,
        Icons.check_circle_rounded,
      ),
      _OptionState.tried => (
        AppPalette.sand200,
        AppPalette.ink500,
        AppPalette.sand300,
        null,
      ),
      _OptionState.idle => (
        AppPalette.white,
        AppPalette.ink,
        AppPalette.sand300,
        null,
      ),
    };
    return Semantics(
      selected: state == _OptionState.correct,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: bg,
          disabledBackgroundColor: bg,
          foregroundColor: fg,
          disabledForegroundColor: fg,
          side: BorderSide(color: border, width: 1.5),
          minimumSize: const Size.fromHeight(AppTouch.primary),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpace.s16,
            vertical: AppSpace.s12,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          alignment: Alignment.centerLeft,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: fg),
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: AppSpace.s8),
              Icon(icon, color: fg, size: AppIconSize.md),
            ],
          ],
        ),
      ),
    );
  }
}

/// Bilgi kartlarının ortak düzeni (mola, bitiş, günlük süre): ikon, etiket,
/// başlık, metin ve düğmeler.
class _InfoBody extends StatelessWidget {
  const _InfoBody({
    required this.icon,
    required this.title,
    required this.lines,
    required this.actions,
    this.label,
  });

  final IconData icon;
  final String? label;
  final String title;
  final List<String> lines;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SoftEntrance(
          child: Center(
            child: ExcludeSemantics(
              child: Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: AppPalette.seaBlue50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: AppIconSize.xl,
                  color: AppPalette.seaBlue,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpace.s24),
        if (label != null) ...[
          Center(child: CapsLabel(label!)),
          const SizedBox(height: AppSpace.s8),
        ],
        Semantics(
          header: true,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: t.headlineSmall,
          ),
        ),
        for (final line in lines) ...[
          const SizedBox(height: AppSpace.s8),
          Text(
            line,
            textAlign: TextAlign.center,
            style: t.bodyLarge?.copyWith(color: AppPalette.ink700),
          ),
        ],
        const SizedBox(height: AppSpace.s32),
        for (final (i, a) in actions.indexed) ...[
          if (i > 0) const SizedBox(height: AppSpace.s12),
          a,
        ],
      ],
    );
  }
}

/// Mola kartı (~10 klipte bir): sakin bir ara ve günün tek adımı.
class BreakCard extends StatelessWidget {
  const BreakCard({
    super.key,
    required this.clipsWatched,
    required this.saved,
    required this.onHome,
    required this.onContinue,
  });

  final int clipsWatched;
  final int saved;
  final VoidCallback onHome;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => FeedCardFrame(
    key: const ValueKey('break-card'),
    child: _InfoBody(
      icon: Icons.self_improvement_rounded,
      label: DiscoverTexts.breakLabel,
      title: DiscoverTexts.breakTitle,
      lines: [
        DiscoverTexts.breakBody(clipsWatched, saved),
        DiscoverTexts.breakSuggestion,
      ],
      actions: [
        FilledButton(
          key: const ValueKey('break-home'),
          style: AppButtonStyles.primary(),
          onPressed: onHome,
          child: const Text(DiscoverTexts.breakHome),
        ),
        OutlinedButton(
          key: const ValueKey('break-continue'),
          style: AppButtonStyles.secondary(),
          onPressed: onContinue,
          child: const Text(DiscoverTexts.breakContinue),
        ),
      ],
    ),
  );
}

/// Akışın sonu: klipler tükendi, hikâye önerilir (sonsuz kaydırma yok).
class EndCard extends StatelessWidget {
  const EndCard({
    super.key,
    required this.moreLocked,
    required this.onStory,
    required this.onHome,
  });

  final bool moreLocked;
  final VoidCallback onStory;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) => FeedCardFrame(
    key: const ValueKey('end-card'),
    child: _InfoBody(
      icon: Icons.auto_stories_rounded,
      title: DiscoverTexts.endTitle,
      lines: [moreLocked ? DiscoverTexts.endBodyLocked : DiscoverTexts.endBody],
      actions: [
        FilledButton(
          key: const ValueKey('end-story'),
          style: AppButtonStyles.primary(),
          onPressed: onStory,
          child: const Text(DiscoverTexts.endStory),
        ),
        OutlinedButton(
          key: const ValueKey('end-home'),
          style: AppButtonStyles.secondary(),
          onPressed: onHome,
          child: const Text(DiscoverTexts.endHome),
        ),
      ],
    ),
  );
}

/// Günlük süre doldu (13–17 ve 13 altı): yalnızca dolunca görünür; izlerken
/// geri sayım yok (K-32).
class LimitCard extends StatelessWidget {
  const LimitCard({super.key, required this.onStory});

  final VoidCallback onStory;

  @override
  Widget build(BuildContext context) => FeedCardFrame(
    key: const ValueKey('limit-card'),
    child: _InfoBody(
      icon: Icons.nightlight_round,
      title: DiscoverTexts.limitTitle,
      lines: const [DiscoverTexts.limitBody, DiscoverTexts.limitAlso],
      actions: [
        FilledButton(
          key: const ValueKey('limit-story'),
          style: AppButtonStyles.primary(),
          onPressed: onStory,
          child: const Text(DiscoverTexts.limitStory),
        ),
      ],
    ),
  );
}
