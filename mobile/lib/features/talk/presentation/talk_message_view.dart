import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/ui/ui.dart';
import '../../hi/application/hi_providers.dart';
import '../../notebook/application/notebook_providers.dart';
import '../application/talk_providers.dart';
import '../domain/talk_match.dart';
import '../domain/talk_task.dart';
import 'talk_widgets.dart';

enum _Stage { writing, passed, retry, selfCheck, done }

/// Kısa mesaj yazma (H-090): 1–2 cümle. Güvenilir hoşgörülü kural varsa
/// (gerekli kelimeler, anlamı tersine çeviren kelime yok) uygulama denetler;
/// geçmezse sakin ipucu + "Düzelt" ya da örnek mesaj. Kural yoksa örnek
/// mesaj + öz değerlendirme. Kesin puan yok.
///
/// Yazılan mesaj yalnızca bu ekranın belleğinde durur; hiçbir yere yazılmaz.
class TalkMessageView extends ConsumerStatefulWidget {
  const TalkMessageView({super.key, required this.task});

  final TalkTask task;

  @override
  ConsumerState<TalkMessageView> createState() => _TalkMessageViewState();
}

class _TalkMessageViewState extends ConsumerState<TalkMessageView> {
  final _text = TextEditingController();
  _Stage _stage = _Stage.writing;
  MessageCheckResult? _check;
  List<String> _used = const [];

  /// Görev denemesi boyunca yardım görüldü mü (ipucu ya da örnek mesaj).
  /// Görüldüyse geçen cevap **yardımlı** sayılır: `own_use` yazılmaz
  /// (17 Ekim 2026 regresyonu; sahne ekranındaki `_sawHelp` ile aynı kural).
  bool _sawHelp = false;

  TalkTask get _task => widget.task;

  @override
  void initState() {
    super.initState();
    _text.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    FocusScope.of(context).unfocus();
    final text = _text.text.trim();
    if (text.isEmpty) return;
    final r = TalkMatcher.checkMessage(text, _task.check);
    if (r == null) {
      setState(() => _stage = _Stage.selfCheck);
      return;
    }
    if (!r.passed) {
      setState(() {
        _check = r;
        _stage = _Stage.retry;
        // İpucu gösterildi: bundan sonraki doğru cevap yardımlı sayılır.
        _sawHelp = true;
      });
      return;
    }
    // Kural mesajın **anlamını** doğruladı; hedef ifade yalnız geçerli
    // eşleşen kalıplardan kurulur (H-096: mesajın bütün kelimelerine
    // bakılmaz).
    final used = TalkMatcher.coveredTargets(_task.targets, text, _task.check);
    setState(() {
      _check = r;
      _used = used;
      _stage = _Stage.passed;
    });
    final actions = ref.read(talkActionsProvider);
    // Anlam denetiminden geçti; ipucu/örnek görülmediyse "kendi kullandı"
    // (H-089). Yardım görüldüyse "yardımla" yazılır: own_use üretilmez.
    await actions.recordUse(used, own: !_sawHelp);
    await _finish();
  }

  Future<void> _finish() async {
    await ref.read(talkActionsProvider).markDone(_task.id);
    if (!mounted) return;
    ref.invalidate(evidenceSummaryProvider);
    refreshHi(ref);
    refreshTalk(ref);
  }

  Future<void> _similar() async {
    setState(() => _stage = _Stage.done);
    await _finish();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final model = _task.model;
    final c = <Widget>[
      TalkImage(task: _task),
      const SizedBox(height: AppSpace.s16),
      Text(
        _task.taskTr ?? '',
        key: const ValueKey('message-task'),
        style: theme.textTheme.bodyLarge,
      ),
      const SizedBox(height: AppSpace.s12),
      if (_task.to != null)
        Text(
          TalkTexts.to(_task.to!),
          style: theme.textTheme.labelLarge?.copyWith(color: AppPalette.ink500),
        ),
      const SizedBox(height: AppSpace.s8),
      TextField(
        key: const ValueKey('message-field'),
        controller: _text,
        enabled: _stage == _Stage.writing || _stage == _Stage.retry,
        minLines: 2,
        maxLines: 4,
        maxLength: 160,
        textCapitalization: TextCapitalization.sentences,
        autocorrect: false,
        decoration: const InputDecoration(
          labelText: TalkTexts.fieldLabel,
          hintText: TalkTexts.fieldHint,
          filled: true,
          fillColor: AppPalette.white,
        ),
      ),
      Text(
        TalkTexts.privacy,
        style: theme.textTheme.bodySmall?.copyWith(color: AppPalette.ink500),
      ),
      const SizedBox(height: AppSpace.s16),
    ];
    switch (_stage) {
      case _Stage.writing:
        c.add(
          FilledButton.icon(
            key: const ValueKey('message-send'),
            onPressed: _text.text.trim().isEmpty ? null : _send,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(AppTouch.primary),
            ),
            icon: const Icon(Icons.send_rounded),
            label: const Text(TalkTexts.send),
          ),
        );
      case _Stage.retry:
        final r = _check!;
        final lines = [
          if (r.forbidden.isNotEmpty) TalkTexts.forbidden(r.forbidden),
          if (r.missing.isNotEmpty) TalkTexts.missing(r.missing),
          ?_task.check?.hintTr,
        ];
        c
          ..add(
            InfoCard(
              key: const ValueKey('message-hint'),
              tone: InfoTone.info,
              icon: Icons.lightbulb_outline_rounded,
              title: SpeakTexts.closeTitle,
              body: lines.join(' '),
            ),
          )
          ..add(const SizedBox(height: AppSpace.s12))
          ..add(
            FilledButton.icon(
              key: const ValueKey('message-send'),
              onPressed: _text.text.trim().isEmpty ? null : _send,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(AppTouch.primary),
              ),
              icon: const Icon(Icons.edit_rounded),
              label: const Text(TalkTexts.send),
            ),
          )
          ..add(const SizedBox(height: AppSpace.s8))
          ..add(
            OutlinedButton(
              key: const ValueKey('message-show-model'),
              onPressed: () => setState(() {
                _stage = _Stage.selfCheck;
                // Örnek mesaj açıldı: yardım görüldü.
                _sawHelp = true;
              }),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(AppTouch.min),
              ),
              child: const Text(TalkTexts.showModel),
            ),
          );
      case _Stage.selfCheck:
        c
          ..add(
            Semantics(
              header: true,
              child: Text(
                TalkTexts.selfCheckTitle,
                style: theme.textTheme.titleMedium,
              ),
            ),
          )
          ..add(const SizedBox(height: AppSpace.s4))
          ..add(
            Text(TalkTexts.selfCheckIntro, style: theme.textTheme.bodyMedium),
          )
          ..add(const SizedBox(height: AppSpace.s8))
          ..add(_modelCard(theme, model));
        for (final s in _task.selfCheckTr) {
          c.add(
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.s8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ExcludeSemantics(
                    child: Icon(
                      Icons.check_box_outline_blank_rounded,
                      color: AppPalette.seaBlue,
                    ),
                  ),
                  const SizedBox(width: AppSpace.s8),
                  Expanded(child: Text(s, style: theme.textTheme.bodyLarge)),
                ],
              ),
            ),
          );
        }
        c
          ..add(const SizedBox(height: AppSpace.s16))
          ..add(
            FilledButton(
              key: const ValueKey('message-similar'),
              onPressed: _similar,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(AppTouch.primary),
              ),
              child: const Text(TalkTexts.similar),
            ),
          )
          ..add(const SizedBox(height: AppSpace.s8))
          ..add(
            OutlinedButton(
              key: const ValueKey('message-try-again'),
              onPressed: () => setState(() => _stage = _Stage.writing),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(AppTouch.min),
              ),
              child: const Text(TalkTexts.tryAgain),
            ),
          );
      case _Stage.passed:
      case _Stage.done:
        c
          ..add(
            Row(
              children: [
                const ExcludeSemantics(
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppPalette.success,
                  ),
                ),
                const SizedBox(width: AppSpace.s8),
                Expanded(
                  child: Text(
                    _stage == _Stage.passed
                        ? TalkTexts.passed
                        : TalkTexts.messageDone,
                    key: const ValueKey('message-done'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppPalette.success,
                    ),
                  ),
                ),
              ],
            ),
          )
          ..add(const SizedBox(height: AppSpace.s12))
          ..add(_modelCard(theme, model));
        if (_used.isNotEmpty) {
          c
            ..add(const SizedBox(height: AppSpace.s8))
            ..add(
              Text(
                _sawHelp ? TalkTexts.endHelped(_used) : TalkTexts.endOwn(_used),
                key: const ValueKey('message-own'),
                style: theme.textTheme.bodyMedium,
              ),
            );
        }
        c
          ..add(const SizedBox(height: AppSpace.s24))
          ..add(
            FilledButton(
              key: const ValueKey('talk-back'),
              onPressed: () => Navigator.of(context).maybePop(),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(AppTouch.primary),
              ),
              child: const Text(TalkTexts.backToTalk),
            ),
          );
    }
    return Scaffold(
      backgroundColor: AppPalette.sand,
      appBar: AppBar(title: Text(_task.titleTr)),
      body: SafeArea(
        top: false,
        child: ListView(
          key: const ValueKey('talk-message'),
          padding: const EdgeInsets.fromLTRB(
            AppSpace.page,
            AppSpace.s8,
            AppSpace.page,
            AppSpace.s32,
          ),
          children: c,
        ),
      ),
    );
  }

  Widget _modelCard(ThemeData theme, TalkLine? model) {
    if (model == null) return const SizedBox.shrink();
    return Container(
      key: const ValueKey('message-model'),
      padding: const EdgeInsets.all(AppSpace.s12),
      decoration: BoxDecoration(
        color: AppPalette.white,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.level1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CapsLabel(TalkTexts.modelLabel),
          const SizedBox(height: AppSpace.s4),
          Text(model.en, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpace.s4),
          Text(
            model.tr,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppPalette.ink500,
            ),
          ),
        ],
      ),
    );
  }
}
