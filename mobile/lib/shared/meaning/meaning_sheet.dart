import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/design/design.dart';
import '../../l10n/tr_strings.dart';
import '../speech/speak_widgets.dart';
import '../speech/speech_store.dart';
import '../ui/ui.dart';
import 'meaning_controller.dart';
import 'meaning_text.dart';

/// Anlam panelini alttan açar. Panel kapanınca (sürükleyerek, dışına dokunarak
/// ya da "Kapat" ile) dönen Future tamamlanır.
///
/// [speak]: cihazda tanıma varsa "Sen de söyle" (H-055); yoksa düğme yok.
/// Oynatıcı, Keşfet ve kitap okuyucu (H-067) ortak kullanır.
Future<void> showMeaningSheet(
  BuildContext context,
  MeaningController controller, {
  SpeakEnv? speak,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppPalette.sand,
    barrierColor: AppScrim.dimLight,
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.66,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scroll) => ScaffoldMessenger(
        // Onay mesajı panelin içinde görünür (alttaki oynatıcıda değil).
        child: Scaffold(
          backgroundColor: AppPalette.sand,
          body: MeaningSheet(
            controller: controller,
            scrollController: scroll,
            speak: speak,
          ),
        ),
      ),
    ),
  );
}

/// Kademeli anlam paneli (H-046). Keşfet'teki "Anlam" düğmesi de bunu kullanır.
///
/// H-062: renk, yazı ve boşluklar tasarım belirteçlerinden; seçili kelimenin
/// anlamı yumuşakça değişir ("Hareketi azalt" açıksa anında).
class MeaningSheet extends StatelessWidget {
  const MeaningSheet({
    super.key,
    required this.controller,
    this.scrollController,
    this.speak,
  });

  final MeaningController controller;
  final ScrollController? scrollController;

  /// "Sen de söyle" (H-055); null: gösterilmez.
  final SpeakEnv? speak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final c = controller;
        final t = c.text;
        return Column(
          children: [
            // Başlık ve "Kapat" sabit; içerik kayar.
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpace.s16,
                AppSpace.s8,
                AppSpace.s8,
                0,
              ),
              child: Column(
                children: [
                  const _Handle(),
                  Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text(
                            t.speaker == null
                                ? MeaningTexts.title
                                : _speakerName(t.speaker!),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppPalette.seaBlue,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        key: const ValueKey('meaning-close'),
                        tooltip: MeaningTexts.close,
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppPalette.ink,
                          semanticLabel: MeaningTexts.closeSemantics,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.s16,
                  0,
                  AppSpace.s16,
                  AppSpace.s24,
                ),
                children: [
                  const SizedBox(height: AppSpace.s8),
                  _WordWrap(controller: c),
                  const SizedBox(height: AppSpace.s16),
                  _MeaningPanel(controller: c),
                  if (t.hasTurkish) ...[
                    const SizedBox(height: AppSpace.s16),
                    _TurkishStep(controller: c),
                  ],
                ],
              ),
            ),
            // Eylemler sabit altta: kelime açıklaması uzasa da "Deftere ekle" görünür kalır.
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpace.s16,
                  AppSpace.s8,
                  AppSpace.s16,
                  AppSpace.s16,
                ),
                child: _Actions(controller: c, speak: speak),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Handle extends StatelessWidget {
  const _Handle();

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: AppSpace.s32,
      height: AppSpace.s4,
      margin: const EdgeInsets.only(bottom: AppSpace.s8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
    ),
  );
}

/// Kelime kutucukları; kalıplar yumuşak sarı zeminle gruplanır.
class _WordWrap extends StatelessWidget {
  const _WordWrap({required this.controller});

  final MeaningController controller;

  @override
  Widget build(BuildContext context) {
    final t = controller.text;
    final groups = <Widget>[];
    final chunks = t.displayChunks;
    var i = 0;
    var k = 0;
    while (i < t.words.length) {
      final chunk = k < chunks.length && chunks[k].startWord == i
          ? chunks[k]
          : null;
      if (chunk != null) {
        groups.add(
          Container(
            key: ValueKey('meaning-chunk-${chunk.startWord}'),
            padding: const EdgeInsets.all(AppSpace.s4),
            decoration: const BoxDecoration(
              color: AppPalette.yellow200,
              borderRadius: AppRadius.mdAll,
            ),
            child: Wrap(
              spacing: AppSpace.s4,
              runSpacing: AppSpace.s4,
              children: [
                for (var j = chunk.startWord; j <= chunk.endWord; j++)
                  _chip(j, inChunk: true),
              ],
            ),
          ),
        );
        i = chunk.endWord + 1;
        k++;
      } else {
        groups.add(_chip(i));
        i++;
      }
    }
    return Wrap(
      spacing: AppSpace.s8,
      runSpacing: AppSpace.s8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: groups,
    );
  }

  Widget _chip(int index, {bool inChunk = false}) => _WordChip(
    key: ValueKey('meaning-word-$index'),
    word: controller.text.words[index],
    selected: controller.selected == index,
    inChunk: inChunk,
    onTap: () => controller.selectWord(index),
  );
}

class _WordChip extends StatelessWidget {
  const _WordChip({
    super.key,
    required this.word,
    required this.selected,
    required this.inChunk,
    required this.onTap,
  });

  final MeaningWord word;
  final bool selected;
  final bool inChunk;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final blank = word.isBlank;
    final bg = selected
        ? AppPalette.seaBlue
        : blank
        ? Colors.transparent
        : AppPalette.white;
    final fg = selected
        ? AppPalette.white
        : blank
        ? AppPalette.ink500
        : AppPalette.ink;
    return Semantics(
      button: !blank,
      selected: selected,
      label: blank ? MeaningTexts.blank : MeaningTexts.wordSemantics(word.bare),
      excludeSemantics: true,
      child: PressScale(
        enabled: !blank,
        child: Material(
          color: bg,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.mdAll,
            side: selected || blank
                ? BorderSide.none
                : BorderSide(
                    color: inChunk
                        ? AppPalette.seaBlue100
                        : AppPalette.seaBlue200,
                  ),
          ),
          child: InkWell(
            onTap: blank ? null : onTap,
            borderRadius: AppRadius.mdAll,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppTouch.min,
                minWidth: AppTouch.min,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.s12),
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    word.w,
                    style: AppTypography.subtitle.copyWith(color: fg),
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

/// 1. adım: seçili kelimenin anlamı ve (varsa) kalıbın anlamı.
class _MeaningPanel extends StatelessWidget {
  const _MeaningPanel({required this.controller});

  final MeaningController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = controller.selectedWord;
    final chunk = controller.selectedChunk;
    final Widget child;
    if (w == null) {
      child = Text(
        controller.audio.canPlayWords
            ? MeaningTexts.hintWithAudio
            : MeaningTexts.hint,
        key: const ValueKey('meaning-hint'),
        style: theme.textTheme.bodyLarge?.copyWith(color: AppPalette.ink500),
      );
    } else {
      child = Column(
        key: ValueKey('meaning-selected-${controller.selected}'),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            w.bare,
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppPalette.seaBlue,
            ),
          ),
          const SizedBox(height: AppSpace.s4),
          Text(
            w.gloss ?? MeaningTexts.properNoun,
            key: const ValueKey('meaning-gloss'),
            style: AppTypography.lead.copyWith(
              color: AppPalette.ink,
              fontWeight: AppFonts.regular,
            ),
          ),
          if (chunk != null) ...[
            const SizedBox(height: AppSpace.s16),
            Container(
              key: const ValueKey('meaning-chunk-panel'),
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpace.s12),
              decoration: const BoxDecoration(
                color: AppPalette.yellow100,
                borderRadius: AppRadius.mdAll,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CapsLabel(MeaningTexts.chunkLabel),
                  const SizedBox(height: AppSpace.s4),
                  Text(
                    '${chunk.en} = ${chunk.tr}',
                    style: AppTypography.lead.copyWith(color: AppPalette.ink),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    }
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 72),
      padding: const EdgeInsets.all(AppSpace.s16),
      decoration: const BoxDecoration(
        color: AppPalette.white,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.level1,
      ),
      child: AnimatedSwitcher(
        duration: AppMotion.of(context, AppMotion.fast),
        switchInCurve: AppMotion.enter,
        switchOutCurve: AppMotion.exit,
        layoutBuilder: (current, previous) => Stack(
          alignment: Alignment.topLeft,
          children: [...previous, ?current],
        ),
        child: child,
      ),
    );
  }
}

/// 2. adım: "Türkçesini göster" → cümlenin tamamı.
class _TurkishStep extends StatelessWidget {
  const _TurkishStep({required this.controller});

  final MeaningController controller;

  @override
  Widget build(BuildContext context) {
    if (!controller.revealed) {
      return OutlinedButton.icon(
        key: const ValueKey('meaning-reveal'),
        onPressed: controller.reveal,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppTouch.min),
        ),
        icon: const Icon(Icons.translate_rounded),
        label: const Text(MeaningTexts.reveal),
      );
    }
    final panel = Container(
      key: const ValueKey('meaning-tr'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpace.s16),
      decoration: const BoxDecoration(
        color: AppPalette.seaBlue50,
        borderRadius: AppRadius.mdAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CapsLabel(MeaningTexts.turkishLabel, tone: CapsTone.blue),
          const SizedBox(height: AppSpace.s4),
          Text(
            controller.text.tr!,
            style: AppTypography.lead.copyWith(color: AppPalette.ink),
          ),
        ],
      ),
    );
    return SoftEntrance(child: panel);
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.controller, this.speak});

  final MeaningController controller;
  final SpeakEnv? speak;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                key: const ValueKey('meaning-replay'),
                onPressed: c.audio.canPlaySentence
                    ? () => unawaited(c.replay())
                    : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(AppTouch.min),
                ),
                icon: const Icon(Icons.replay_rounded),
                label: const Text(MeaningTexts.replay),
              ),
            ),
            const SizedBox(width: AppSpace.s8),
            Semantics(
              button: true,
              toggled: c.slow,
              label: c.slow ? MeaningTexts.slowOn : MeaningTexts.slowOff,
              excludeSemantics: true,
              child: OutlinedButton(
                key: const ValueKey('meaning-slow'),
                onPressed: c.toggleSlow,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(72, AppTouch.min),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpace.s16),
                  backgroundColor: c.slow
                      ? AppPalette.seaBlue
                      : AppPalette.white,
                  foregroundColor: c.slow
                      ? AppPalette.white
                      : AppPalette.seaBlue,
                ),
                child: const Text(MeaningTexts.slow),
              ),
            ),
          ],
        ),
        // "Sen de söyle" (H-055): dinlediğini söyle; puan yok, tekrar
        // takvimine işlenmez (yalnızca sonuç kaydı).
        if (speak != null) ...[
          const SizedBox(height: AppSpace.s8),
          SpeakPractice(
            key: ValueKey('meaning-speak-${c.text.sourceId}'),
            expected: c.text.en,
            env: speak!,
            place: SpeechPlace.meaning,
            contentId: c.text.contentId,
            label: SpeakTexts.meaningSay,
            keyPrefix: 'meaning-speak',
          ),
        ],
        const SizedBox(height: AppSpace.s8),
        OutlinedButton.icon(
          key: const ValueKey('meaning-save'),
          onPressed: () => unawaited(_save(context)),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(AppTouch.min),
            backgroundColor: AppPalette.white,
          ),
          icon: const Icon(Icons.bookmark_add_outlined),
          label: const Text(MeaningTexts.save),
        ),
      ],
    );
  }

  Future<void> _save(BuildContext context) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    try {
      final r = await controller.save();
      messenger
        ?..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(r.message),
            duration: const Duration(seconds: 2),
          ),
        );
    } on Object catch (e) {
      debugPrint('[H046] deftere eklenemedi: $e');
      messenger?.showSnackBar(
        const SnackBar(content: Text(MeaningTexts.saveFailed)),
      );
    }
  }
}

String _speakerName(String s) => switch (s) {
  'ALEX' => 'Alex',
  'HI' => 'Hi',
  'MAYA' => 'Maya',
  'MRS BROOKS' => 'Mrs Brooks',
  'MR GRANT' => 'Mr Grant',
  'VOICE' => MeaningTexts.speakerRadio,
  'NOTE' => MeaningTexts.speakerNote,
  'CARD' || 'TASK' || 'TITLE' => MeaningTexts.title,
  _ => s.isEmpty ? MeaningTexts.title : s[0] + s.substring(1).toLowerCase(),
};
