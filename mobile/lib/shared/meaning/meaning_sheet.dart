import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'meaning_controller.dart';
import 'meaning_text.dart';

/// Anlam panelini alttan açar. Panel kapanınca (sürükleyerek, dışına dokunarak
/// ya da "Kapat" ile) dönen Future tamamlanır.
Future<void> showMeaningSheet(
  BuildContext context,
  MeaningController controller,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.sand,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    clipBehavior: Clip.antiAlias,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppTheme.radius),
      ),
    ),
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.66,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scroll) => ScaffoldMessenger(
        // Onay mesajı panelin içinde görünür (alttaki oynatıcıda değil).
        child: Scaffold(
          backgroundColor: AppColors.sand,
          body: MeaningSheet(controller: controller, scrollController: scroll),
        ),
      ),
    ),
  );
}

/// Kademeli anlam paneli (H-046). Keşfet'teki "Anlam" düğmesi de bunu kullanır.
class MeaningSheet extends StatelessWidget {
  const MeaningSheet({
    super.key,
    required this.controller,
    this.scrollController,
  });

  final MeaningController controller;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
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
                AppSpacing.sm,
                AppSpacing.xs,
                AppSpacing.xs,
                0,
              ),
              child: Column(
                children: [
                  const _Handle(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          t.speaker == null
                              ? 'Anlam'
                              : _speakerName(t.speaker!),
                          style: const TextStyle(
                            color: AppColors.seaBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      IconButton(
                        key: const ValueKey('meaning-close'),
                        tooltip: 'Kapat',
                        constraints: const BoxConstraints(
                          minWidth: 48,
                          minHeight: 48,
                        ),
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.ink,
                          semanticLabel: 'Paneli kapat',
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
                  AppSpacing.sm,
                  0,
                  AppSpacing.sm,
                  AppSpacing.md,
                ),
                children: [
                  const SizedBox(height: AppSpacing.xs),
                  _WordWrap(controller: c),
                  const SizedBox(height: AppSpacing.sm),
                  _MeaningPanel(controller: c),
                  if (t.hasTurkish) ...[
                    const SizedBox(height: AppSpacing.sm),
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
                  AppSpacing.sm,
                  AppSpacing.xs,
                  AppSpacing.sm,
                  AppSpacing.sm,
                ),
                child: _Actions(controller: c),
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
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.ink.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(2),
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
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.lighthouseYellow.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(AppTheme.radius),
            ),
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
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
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
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
        ? AppColors.seaBlue
        : blank
        ? Colors.transparent
        : Colors.white;
    final fg = selected ? Colors.white : AppColors.ink;
    return Semantics(
      button: !blank,
      selected: selected,
      label: blank ? 'boşluk' : '${word.bare}. Anlamı için dokun.',
      excludeSemantics: true,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radius),
          side: selected || blank
              ? BorderSide.none
              : BorderSide(
                  color: AppColors.seaBlue.withValues(
                    alpha: inChunk ? 0.08 : 0.18,
                  ),
                ),
        ),
        child: InkWell(
          onTap: blank ? null : onTap,
          borderRadius: BorderRadius.circular(AppTheme.radius),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                widthFactor: 1,
                child: Text(
                  word.w,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: blank ? AppColors.ink.withValues(alpha: 0.5) : fg,
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
    final w = controller.selectedWord;
    final chunk = controller.selectedChunk;
    final Widget child;
    if (w == null) {
      child = Text(
        controller.audio.canPlayWords
            ? 'Bir kelimeye dokun: anlamını gör ve sesini dinle.'
            : 'Bir kelimeye dokun: anlamını gör.',
        key: const ValueKey('meaning-hint'),
        style: TextStyle(
          fontSize: 16,
          color: AppColors.ink.withValues(alpha: 0.7),
        ),
      );
    } else {
      child = Column(
        key: ValueKey('meaning-selected-${controller.selected}'),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            w.bare,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.seaBlue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            w.gloss ?? 'Özel ad: Türkçesi aynı kalır.',
            key: const ValueKey('meaning-gloss'),
            style: const TextStyle(fontSize: 18, color: AppColors.ink),
          ),
          if (chunk != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              key: const ValueKey('meaning-chunk-panel'),
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lighthouseYellow.withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'KALIP',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${chunk.en} = ${chunk.tr}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ink,
                    ),
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
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
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
          minimumSize: const Size.fromHeight(48),
          foregroundColor: AppColors.seaBlue,
          side: BorderSide(color: AppColors.seaBlue.withValues(alpha: 0.4)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        icon: const Icon(Icons.translate_rounded),
        label: const Text('Türkçesini göster'),
      );
    }
    return Container(
      key: const ValueKey('meaning-tr'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.seaBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TÜRKÇESİ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: AppColors.seaBlue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            controller.text.tr!,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.controller});

  final MeaningController controller;

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
                  minimumSize: const Size.fromHeight(48),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                icon: const Icon(Icons.replay_rounded),
                label: const Text('Tekrar dinle'),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Semantics(
              button: true,
              toggled: c.slow,
              label: c.slow
                  ? 'Yavaş dinleme açık (0,75). Normale dönmek için dokun.'
                  : 'Yavaş dinle (0,75)',
              excludeSemantics: true,
              child: OutlinedButton(
                key: const ValueKey('meaning-slow'),
                onPressed: c.toggleSlow,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(72, 48),
                  backgroundColor: c.slow ? AppColors.seaBlue : Colors.white,
                  foregroundColor: c.slow ? Colors.white : AppColors.seaBlue,
                  side: BorderSide(
                    color: AppColors.seaBlue.withValues(alpha: 0.4),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('0,75x'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        OutlinedButton.icon(
          key: const ValueKey('meaning-save'),
          onPressed: () => unawaited(_save(context)),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            backgroundColor: Colors.white,
            foregroundColor: AppColors.seaBlue,
            side: BorderSide(color: AppColors.seaBlue.withValues(alpha: 0.4)),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: const Icon(Icons.bookmark_add_outlined),
          label: const Text('Deftere ekle'),
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
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
    } on Object catch (e) {
      debugPrint('[H046] deftere eklenemedi: $e');
      messenger?.showSnackBar(
        const SnackBar(
          content: Text('Şu an deftere eklenemedi. Biraz sonra tekrar dene.'),
          behavior: SnackBarBehavior.floating,
        ),
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
  'VOICE' => 'Telsizdeki ses',
  'NOTE' => 'Not',
  'CARD' || 'TASK' || 'TITLE' => 'Anlam',
  _ => s.isEmpty ? 'Anlam' : s[0] + s.substring(1).toLowerCase(),
};
