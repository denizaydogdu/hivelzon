import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../l10n/tr_strings.dart';
import '../../domain/episode.dart';
import '../../domain/task_check.dart';
import 'player_ui.dart';

/// Görev etkileşimi: choice, multiSelect, order, match, fillBlank.
///
/// Öğeler sırayla gelir. Yanlışta nazik geri bildirim gösterilir, aynı öğe
/// tekrar denenir; süre yoktur (K-32). Puanlamaya ilk deneme girer ([onAttempt]).
class TaskView extends StatefulWidget {
  const TaskView({
    super.key,
    required this.task,
    required this.onAttempt,
    required this.onComplete,
    required this.onListen,
    this.onStemTap,
  });

  final TaskNode task;
  final void Function(String itemId, bool correct) onAttempt;
  final VoidCallback onComplete;
  final ValueChanged<String> onListen;

  /// Görev köküne dokunuldu (anlamı varsa; H-046). Seçenekler panel açmaz.
  final ValueChanged<TaskItem>? onStemTap;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  int _index = 0;
  bool _done = false;
  String? _feedback;
  int _wrongCount = 0;

  // Öğe durumu.
  final Set<String> _triedWrong = {};
  final Set<String> _selected = {};
  final List<int> _placed = [];
  final Map<String, String> _pairs = {};
  String? _pendingLeft;
  List<String> _rights = const [];
  final Map<String, TextEditingController> _blanks = {};

  TaskItem get _item => widget.task.items[_index];

  @override
  void initState() {
    super.initState();
    _resetItem();
  }

  @override
  void dispose() {
    for (final c in _blanks.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _resetItem() {
    _triedWrong.clear();
    _selected.clear();
    _placed.clear();
    _pairs.clear();
    _pendingLeft = null;
    _feedback = null;
    for (final c in _blanks.values) {
      c.dispose();
    }
    _blanks
      ..clear()
      ..addAll({for (final b in _item.blanks) b.id: TextEditingController()});
    final rights = [for (final p in _item.pairs) p.right];
    final shuffled = List.of(rights)..shuffle(Random(_item.id.hashCode));
    // Karıştırma sırayı değiştirmediyse bir kaydır (oynatıcı sağ tarafı karıştırır).
    if (shuffled.length > 1 && _sameOrder(shuffled, rights)) {
      shuffled.add(shuffled.removeAt(0));
    }
    _rights = shuffled;
  }

  static bool _sameOrder(List<String> a, List<String> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _submit(bool correct) {
    widget.onAttempt(_item.id, correct);
    if (correct) {
      setState(() {
        _feedback = null;
        if (_index + 1 < widget.task.items.length) {
          _index++;
          _resetItem();
        } else {
          _done = true;
        }
      });
      return;
    }
    final fb = widget.task.wrongFeedback;
    if (fb?.audio != null) widget.onListen(fb!.audio!);
    setState(() {
      _feedback =
          fb?.text ??
          kGentleRetryMessages[_wrongCount % kGentleRetryMessages.length];
      _wrongCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final task = widget.task;
    return PlayerPanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    task.prompt.tr,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.seaBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              if (task.audio != null)
                ListenButton(
                  onPressed: () => widget.onListen(task.audio!),
                  semanticLabel: 'Kaydı dinle',
                ),
            ],
          ),
          if (task.context != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                task.context!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.eveningOrange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (task.items.length > 1 && !_done)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                PlayerTexts.taskProgress(_index + 1, task.items.length),
                style: theme.textTheme.labelLarge,
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          if (_done) ..._result(theme) else ..._itemUi(theme),
          if (_feedback != null && !_done) ...[
            const SizedBox(height: AppSpacing.sm),
            _Feedback(text: _feedback!),
          ],
        ],
      ),
    );
  }

  List<Widget> _result(ThemeData theme) => [
    Row(
      children: [
        const Icon(Icons.check_circle_rounded, color: AppColors.seaBlue),
        const SizedBox(width: AppSpacing.xs),
        Text(
          'Harika, buldun!',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
    for (final l in widget.task.result)
      Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xs),
        child: Text(
          l.text,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.seaBlue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    const SizedBox(height: AppSpacing.sm),
    PrimaryAction(
      key: const ValueKey('task-continue'),
      label: PlayerTexts.continueAction,
      icon: Icons.arrow_forward_rounded,
      onPressed: widget.onComplete,
    ),
  ];

  Widget _stem(TaskItem item, TextStyle? style) {
    final text = Text(item.stem!, style: style);
    final tap = widget.onStemTap;
    if (tap == null || item.stemGloss == null) return text;
    return Semantics(
      button: true,
      label: '${item.stem}. Anlamını görmek için dokun.',
      excludeSemantics: true,
      child: InkWell(
        key: ValueKey('task-stem-${item.id}'),
        borderRadius: BorderRadius.circular(AppTheme.radius),
        onTap: () => tap(item),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.stem!,
              style: style?.copyWith(
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.dotted,
                decorationColor: AppColors.seaBlue.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _itemUi(ThemeData theme) {
    final item = _item;
    final stemStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w500,
    );
    switch (widget.task.kind) {
      case TaskKind.choice:
        return [
          if (item.stem != null) _stem(item, stemStyle),
          const SizedBox(height: AppSpacing.xs),
          for (final o in item.options)
            _OptionTile(
              key: ValueKey('task-option-${o.id}'),
              text: o.text,
              selected: false,
              dimmed: _triedWrong.contains(o.id),
              onTap: () {
                final ok = checkChoice(item, o.id);
                if (!ok) _triedWrong.add(o.id);
                _submit(ok);
              },
              onListen: o.audio == null
                  ? null
                  : () => widget.onListen(o.audio!),
            ),
        ];
      case TaskKind.multiSelect:
        return [
          if (item.stem != null) _stem(item, stemStyle),
          for (final o in item.options)
            _OptionTile(
              key: ValueKey('task-option-${o.id}'),
              text: o.text,
              selected: _selected.contains(o.id),
              checkbox: true,
              onTap: () => setState(() {
                _selected.contains(o.id)
                    ? _selected.remove(o.id)
                    : _selected.add(o.id);
              }),
              onListen: o.audio == null
                  ? null
                  : () => widget.onListen(o.audio!),
            ),
          const SizedBox(height: AppSpacing.xs),
          _checkButton(
            enabled: _selected.isNotEmpty,
            onPressed: () => _submit(checkMultiSelect(item, _selected)),
          ),
        ];
      case TaskKind.order:
        final remaining = [
          for (var i = 0; i < item.tokens.length; i++)
            if (!_placed.contains(i)) i,
        ];
        return [
          Container(
            constraints: const BoxConstraints(minHeight: 64),
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radius),
              border: Border.all(
                color: AppColors.seaBlue.withValues(alpha: 0.3),
              ),
            ),
            child: Semantics(
              label: 'Senin cümlen',
              child: Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final i in _placed)
                    _TokenChip(
                      key: ValueKey('task-placed-$i'),
                      text: item.tokens[i],
                      filled: true,
                      onTap: () => setState(() => _placed.remove(i)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final i in remaining)
                _TokenChip(
                  key: ValueKey('task-token-$i'),
                  text: item.tokens[i],
                  onTap: () => setState(() => _placed.add(i)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _checkButton(
            enabled: remaining.isEmpty,
            onPressed: () => _submit(
              checkOrder(item, [for (final i in _placed) item.tokens[i]]),
            ),
          ),
        ];
      case TaskKind.match:
        final usedRights = _pairs.values.toSet();
        return [
          Text(
            'Önce soldan bir parça, sonra sağdan eşini seç.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    for (final (i, p) in item.pairs.indexed)
                      _OptionTile(
                        key: ValueKey('task-left-$i'),
                        text: _pairs[p.left] == null
                            ? p.left
                            : '${p.left} → ${_pairs[p.left]}',
                        selected: _pendingLeft == p.left,
                        done: _pairs.containsKey(p.left),
                        onTap: () => setState(() {
                          _pairs.remove(p.left);
                          _pendingLeft = p.left;
                        }),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  children: [
                    for (final (i, r) in _rights.indexed)
                      _OptionTile(
                        key: ValueKey('task-right-$i'),
                        text: r,
                        selected: false,
                        dimmed: usedRights.contains(r),
                        onTap: _pendingLeft == null
                            ? null
                            : () => setState(() {
                                _pairs.removeWhere((_, v) => v == r);
                                _pairs[_pendingLeft!] = r;
                                _pendingLeft = null;
                              }),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          _checkButton(
            enabled: _pairs.length == item.pairs.length,
            onPressed: () => _submit(checkMatch(item, _pairs)),
          ),
        ];
      case TaskKind.fillBlank:
        final parts = splitBlankStem(item.stem ?? '');
        final children = <Widget>[];
        for (var i = 0; i < parts.length; i++) {
          if (parts[i].trim().isNotEmpty) {
            children.add(Text(parts[i].trim(), style: stemStyle));
          }
          if (i < item.blanks.length) {
            final b = item.blanks[i];
            children.add(
              SizedBox(
                width: 160,
                child: TextField(
                  key: ValueKey('task-blank-${b.id}'),
                  controller: _blanks[b.id],
                  onChanged: (_) => setState(() {}),
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: '…',
                    labelText: _blankLabel(b.id),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            );
          }
        }
        final filled = _blanks.values.every((c) => c.text.trim().isNotEmpty);
        return [
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: children,
          ),
          const SizedBox(height: AppSpacing.sm),
          _checkButton(
            enabled: filled,
            onPressed: () => _submit(
              checkFillBlank(item, {
                for (final e in _blanks.entries) e.key: e.value.text,
              }),
            ),
          ),
        ];
    }
  }

  static String _blankLabel(String id) => switch (id) {
    'name' => 'Adın',
    'from' => 'Nerelisin',
    _ => id,
  };

  Widget _checkButton({
    required bool enabled,
    required VoidCallback onPressed,
  }) => PrimaryAction(
    key: const ValueKey('task-check'),
    label: 'Kontrol et',
    onPressed: enabled ? onPressed : null,
  );
}

class _Feedback extends StatelessWidget {
  const _Feedback({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppPalette.yellow100,
          borderRadius: BorderRadius.circular(AppTheme.radius),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.lightbulb_outline_rounded,
              color: AppColors.seaBlue,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
    this.dimmed = false,
    this.done = false,
    this.checkbox = false,
    this.onListen,
  });

  final String text;
  final bool selected;
  final bool dimmed;
  final bool done;
  final bool checkbox;
  final VoidCallback? onTap;
  final VoidCallback? onListen;

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? AppColors.seaBlue
        : done
        ? AppPalette.seaBlue100
        : AppPalette.seaBlue50;
    final fg = selected ? Colors.white : AppColors.seaBlue;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Opacity(
        opacity: dimmed ? 0.5 : 1,
        child: Material(
          color: bg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radius),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    if (checkbox)
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.xs),
                        child: Icon(
                          selected
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank_rounded,
                          color: fg,
                        ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: fg,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    if (onListen != null)
                      ListenButton(
                        onPressed: onListen!,
                        semanticLabel: 'Dinle: $text',
                        filled: false,
                      )
                    else
                      const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TokenChip extends StatelessWidget {
  const _TokenChip({
    super.key,
    required this.text,
    required this.onTap,
    this.filled = false,
  });

  final String text;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: filled
          ? '$text, çıkarmak için dokun'
          : '$text, eklemek için dokun',
      excludeSemantics: true,
      child: Material(
        color: filled ? AppColors.seaBlue : AppPalette.seaBlue50,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radius),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Center(
                widthFactor: 1,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: filled ? Colors.white : AppColors.seaBlue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
