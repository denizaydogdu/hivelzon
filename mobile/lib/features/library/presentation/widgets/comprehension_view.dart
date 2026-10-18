import 'package:flutter/material.dart';

import '../../../../app/design/design.dart';
import '../../../../l10n/tr_strings.dart';
import '../../../../shared/ui/ui.dart';
import '../../domain/book.dart';
import '../../domain/book_comprehension.dart';

/// Anlama ekranının sonucu (yalnız sayılar; yazılan metin yok).
class ComprehensionOutcome {
  const ComprehensionOutcome({
    required this.answered,
    required this.firstTryCorrect,
    required this.retellDone,
    this.selfCheck,
  });

  final int answered;
  final int firstTryCorrect;
  final bool retellDone;
  final RetellSelfCheck? selfCheck;
}

/// Kitap sonu anlama (H-091): son sayfadan sonra, kitap sonundan önce.
///
/// İki çoktan seçmeli soru (yanlış seçimde sakin ipucu, ikinci yanlışta
/// doğrusu gösterilir) ve isteğe bağlı yeniden anlatma: kullanıcı 1–3
/// cümle söyler ya da yazar, örnek anlatımı açar ve kendini değerlendirir.
/// Yazılan metin bu ekrandan çıkmaz. Puan, süre ve suçlama yok (K-32).
///
/// **Örnek özeti açmak yeniden anlatma değildir**: `retellDone` yalnız gerçek
/// bir denemeyle (yazılan anlatım) ya da kullanıcının kendini değerlendirmesiyle
/// oluşur; `selfCheck` hangi beyan olduğunu ayrıca taşır (17 Ekim 2026
/// regresyonu).
class ComprehensionView extends StatefulWidget {
  const ComprehensionView({
    super.key,
    required this.book,
    required this.comprehension,
    required this.colors,
    required this.onSkip,
    required this.onFinish,
  });

  final Book book;
  final BookComprehension comprehension;
  final BookColors colors;
  final VoidCallback onSkip;
  final ValueChanged<ComprehensionOutcome> onFinish;

  @override
  State<ComprehensionView> createState() => _ComprehensionViewState();
}

class _ComprehensionViewState extends State<ComprehensionView> {
  /// Soru başına seçilen seçenekler (sırasıyla).
  late final List<List<int>> _picks = [
    for (final _ in widget.comprehension.questions) <int>[],
  ];
  final _retell = TextEditingController();
  bool _modelShown = false;
  bool _turkishShown = false;
  RetellSelfCheck? _selfCheck;

  @override
  void dispose() {
    _retell.dispose();
    super.dispose();
  }

  bool _resolved(int q) {
    final question = widget.comprehension.questions[q];
    final picks = _picks[q];
    return picks.contains(question.answer) ||
        picks.length >= question.options.length - 1;
  }

  void _pick(int q, int option) {
    if (_resolved(q) || _picks[q].contains(option)) return;
    setState(() => _picks[q].add(option));
  }

  int? _pageNumber(ComprehensionQuestion q) {
    final id = q.pageId;
    if (id == null) return null;
    for (final p in widget.book.pages) {
      if (p.id == id) return p.number;
    }
    return null;
  }

  void _finish() {
    final qs = widget.comprehension.questions;
    var answered = 0;
    var first = 0;
    for (var i = 0; i < qs.length; i++) {
      if (_resolved(i)) answered++;
      if (_picks[i].isNotEmpty && _picks[i].first == qs[i].answer) first++;
    }
    widget.onFinish(
      ComprehensionOutcome(
        answered: answered,
        firstTryCorrect: first,
        // Yeniden anlatma **yapıldı** sayılır: kullanıcı bir anlatım denedi
        // (metin yazdı) ya da örnekle karşılaştırıp kendini değerlendirdi.
        // Yalnız örnek özeti açmak yetmez (17 Ekim 2026 regresyonu).
        retellDone: _retell.text.trim().isNotEmpty || _selfCheck != null,
        selfCheck: _selfCheck,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = widget.colors;
    final qs = widget.comprehension.questions;
    return SingleChildScrollView(
      key: const ValueKey('comprehension'),
      padding: const EdgeInsets.fromLTRB(
        AppSpace.page,
        AppSpace.s8,
        AppSpace.page,
        AppSpace.s32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(child: CapsLabel(ComprehensionTexts.label)),
              Semantics(
                button: true,
                label: ComprehensionTexts.skipHint,
                excludeSemantics: true,
                child: TextButton(
                  key: const ValueKey('comp-skip'),
                  onPressed: widget.onSkip,
                  style: TextButton.styleFrom(
                    foregroundColor: colors.text,
                    minimumSize: const Size(AppTouch.min, AppTouch.min),
                  ),
                  child: const Text(ComprehensionTexts.skip),
                ),
              ),
            ],
          ),
          Semantics(
            header: true,
            child: Text(
              ComprehensionTexts.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colors.text,
              ),
            ),
          ),
          const SizedBox(height: AppSpace.s8),
          Text(
            ComprehensionTexts.intro,
            style: theme.textTheme.bodyLarge?.copyWith(color: colors.text),
          ),
          for (var i = 0; i < qs.length; i++) ...[
            const SizedBox(height: AppSpace.s24),
            SoftEntrance(index: i, child: _question(context, i, qs.length)),
          ],
          const SizedBox(height: AppSpace.s32),
          SoftEntrance(index: qs.length, child: _retellSection(context)),
          const SizedBox(height: AppSpace.s32),
          FilledButton.icon(
            key: const ValueKey('comp-finish'),
            onPressed: _finish,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(AppTouch.primary),
            ),
            icon: const Icon(Icons.check_rounded),
            label: const Text(ComprehensionTexts.finish),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child, Key? key}) => Container(
    key: key,
    padding: const EdgeInsets.all(AppSpace.s16),
    decoration: BoxDecoration(
      color: widget.colors.surface,
      borderRadius: AppRadius.mdAll,
    ),
    child: child,
  );

  Widget _question(BuildContext context, int i, int total) {
    final theme = Theme.of(context);
    final colors = widget.colors;
    final q = widget.comprehension.questions[i];
    final picks = _picks[i];
    final resolved = _resolved(i);
    final page = _pageNumber(q);
    final firstRight = picks.isNotEmpty && picks.first == q.answer;
    String? feedback;
    if (picks.isNotEmpty) {
      if (picks.last == q.answer) {
        feedback = ComprehensionTexts.correct;
      } else if (resolved) {
        feedback = ComprehensionTexts.reveal(page);
      } else {
        feedback = ComprehensionTexts.tryAgain(page);
      }
    }
    return _card(
      key: ValueKey('comp-q${i + 1}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            ComprehensionTexts.questionOf(i + 1, total),
            style: theme.textTheme.labelLarge?.copyWith(color: colors.muted),
          ),
          const SizedBox(height: AppSpace.s4),
          Text(
            q.prompt,
            style: theme.textTheme.titleMedium?.copyWith(color: colors.text),
          ),
          if (q.promptTr != null) ...[
            const SizedBox(height: AppSpace.s4),
            Text(
              q.promptTr!,
              style: theme.textTheme.bodyMedium?.copyWith(color: colors.muted),
            ),
          ],
          const SizedBox(height: AppSpace.s12),
          for (final (k, option) in q.options.indexed) ...[
            if (k > 0) const SizedBox(height: AppSpace.s8),
            _option(
              key: ValueKey('comp-q${i + 1}-o$k'),
              text: option,
              state: k == q.answer && resolved
                  ? _OptionState.right
                  : picks.contains(k)
                  ? _OptionState.tried
                  : _OptionState.open,
              enabled: !resolved && !picks.contains(k),
              onTap: () => _pick(i, k),
            ),
          ],
          if (feedback != null) ...[
            const SizedBox(height: AppSpace.s12),
            Semantics(
              liveRegion: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      resolved
                          ? (firstRight || picks.last == q.answer
                                ? Icons.check_circle_outline_rounded
                                : Icons.lightbulb_outline_rounded)
                          : Icons.lightbulb_outline_rounded,
                      size: AppIconSize.md,
                      color: colors.accent,
                    ),
                  ),
                  const SizedBox(width: AppSpace.s8),
                  Expanded(
                    child: Text(
                      feedback,
                      key: ValueKey('comp-q${i + 1}-feedback'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _option({
    required Key key,
    required String text,
    required _OptionState state,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colors = widget.colors;
    final (border, fill, icon) = switch (state) {
      _OptionState.right => (
        colors.accent,
        colors.highlight,
        Icons.check_rounded,
      ),
      _OptionState.tried => (
        colors.muted.withValues(alpha: 0.4),
        colors.background,
        Icons.remove_rounded,
      ),
      _OptionState.open => (
        colors.muted.withValues(alpha: 0.5),
        colors.background,
        null,
      ),
    };
    final semantics = switch (state) {
      _OptionState.right => '$text, ${ComprehensionTexts.optionCorrect}',
      _OptionState.tried => '$text, ${ComprehensionTexts.optionTried}',
      _OptionState.open => text,
    };
    return Semantics(
      button: true,
      enabled: enabled,
      label: semantics,
      excludeSemantics: true,
      child: PressScale(
        enabled: enabled,
        child: Material(
          key: key,
          color: fill,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.mdAll,
            side: BorderSide(
              color: border,
              width: state == _OptionState.right ? 2 : 1,
            ),
          ),
          child: InkWell(
            onTap: enabled ? onTap : null,
            customBorder: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: AppTouch.min),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpace.s12,
                  vertical: AppSpace.s12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        text,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: state == _OptionState.tried
                              ? colors.muted
                              : colors.text,
                        ),
                      ),
                    ),
                    if (icon != null) ...[
                      const SizedBox(width: AppSpace.s8),
                      Icon(icon, size: AppIconSize.md, color: colors.accent),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _retellSection(BuildContext context) {
    final theme = Theme.of(context);
    final colors = widget.colors;
    final c = widget.comprehension;
    return _card(
      key: const ValueKey('comp-retell'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CapsLabel(ComprehensionTexts.retellLabel, tone: CapsTone.blue),
          const SizedBox(height: AppSpace.s4),
          Text(
            ComprehensionTexts.retellTitle,
            style: theme.textTheme.titleMedium?.copyWith(color: colors.text),
          ),
          const SizedBox(height: AppSpace.s4),
          Text(
            ComprehensionTexts.retellBody,
            style: theme.textTheme.bodyMedium?.copyWith(color: colors.text),
          ),
          const SizedBox(height: AppSpace.s12),
          TextField(
            key: const ValueKey('comp-retell-field'),
            controller: _retell,
            minLines: 2,
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            // Öğrenilen dil İngilizce; öneri ve kayıt yok.
            enableSuggestions: false,
            autocorrect: false,
            style: theme.textTheme.bodyLarge?.copyWith(color: colors.text),
            decoration: InputDecoration(
              labelText: ComprehensionTexts.retellField,
              hintText: ComprehensionTexts.retellHint,
              filled: true,
              fillColor: colors.background,
              border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
            ),
          ),
          const SizedBox(height: AppSpace.s12),
          if (!_modelShown)
            OutlinedButton.icon(
              key: const ValueKey('comp-show-model'),
              onPressed: () => setState(() => _modelShown = true),
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.text,
                minimumSize: const Size.fromHeight(AppTouch.min),
              ),
              icon: const Icon(Icons.visibility_outlined),
              label: const Text(ComprehensionTexts.showModel),
            )
          else ...[
            Semantics(
              header: true,
              child: Text(
                ComprehensionTexts.modelTitle,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colors.muted,
                ),
              ),
            ),
            const SizedBox(height: AppSpace.s4),
            Text(
              c.modelEn,
              key: const ValueKey('comp-model-en'),
              style: theme.textTheme.bodyLarge?.copyWith(color: colors.text),
            ),
            if (c.modelTr != null) ...[
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  key: const ValueKey('comp-model-tr-toggle'),
                  onPressed: () =>
                      setState(() => _turkishShown = !_turkishShown),
                  style: TextButton.styleFrom(
                    foregroundColor: colors.text,
                    minimumSize: const Size(AppTouch.min, AppTouch.min),
                  ),
                  icon: Icon(
                    _turkishShown
                        ? Icons.expand_less_rounded
                        : Icons.translate_rounded,
                  ),
                  label: const Text(ComprehensionTexts.modelTurkish),
                ),
              ),
              if (_turkishShown)
                Text(
                  c.modelTr!,
                  key: const ValueKey('comp-model-tr'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.muted,
                  ),
                ),
            ],
            const SizedBox(height: AppSpace.s16),
            Text(
              ComprehensionTexts.selfCheckTitle,
              style: theme.textTheme.titleSmall?.copyWith(color: colors.text),
            ),
            const SizedBox(height: AppSpace.s8),
            Wrap(
              spacing: AppSpace.s8,
              runSpacing: AppSpace.s8,
              children: [
                for (final (s, label) in const [
                  (RetellSelfCheck.all, ComprehensionTexts.selfAll),
                  (RetellSelfCheck.some, ComprehensionTexts.selfSome),
                  (RetellSelfCheck.notYet, ComprehensionTexts.selfNotYet),
                ])
                  ChoiceChip(
                    key: ValueKey('comp-self-${s.code}'),
                    label: Text(label),
                    selected: _selfCheck == s,
                    onSelected: (_) => setState(() => _selfCheck = s),
                  ),
              ],
            ),
            if (_selfCheck != null) ...[
              const SizedBox(height: AppSpace.s8),
              Semantics(
                liveRegion: true,
                child: Text(
                  switch (_selfCheck!) {
                    RetellSelfCheck.all => ComprehensionTexts.replyAll,
                    RetellSelfCheck.some => ComprehensionTexts.replySome,
                    RetellSelfCheck.notYet => ComprehensionTexts.replyNotYet,
                  },
                  key: const ValueKey('comp-self-reply'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.text,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

enum _OptionState { open, tried, right }
