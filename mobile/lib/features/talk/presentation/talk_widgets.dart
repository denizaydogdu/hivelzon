import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/design/design.dart';
import '../../../l10n/tr_strings.dart';
import '../../../shared/content/content_providers.dart';
import '../../../shared/speech/example_speech.dart';
import '../../../shared/speech/speech_providers.dart';
import '../../notebook/application/card_audio_player.dart';
import '../../notebook/domain/notebook_item.dart';
import '../../notebook/presentation/notebook_screen.dart' show createCardAudio;
import '../application/talk_providers.dart';
import '../domain/talk_task.dart';

/// Görevin görseli: bölüm paketindeki sahne görseli (kopyalanmaz). Açılamazsa
/// sakin bir yer tutucu.
class TalkImage extends ConsumerWidget {
  const TalkImage({super.key, required this.task, this.aspectRatio = 16 / 9});

  final TalkTask task;
  final double aspectRatio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final source = ref.watch(contentSourceProvider);
    const placeholder = ColoredBox(
      color: AppPalette.seaBlue100,
      child: Center(
        child: Icon(
          Icons.forum_outlined,
          color: AppPalette.seaBlue,
          size: AppIconSize.lg,
        ),
      ),
    );
    return ClipRRect(
      borderRadius: AppRadius.mdAll,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Image.network(
          source.mediaUri(task.imageEpisode, task.imagePath).toString(),
          key: ValueKey('talk-image-${task.id}'),
          fit: BoxFit.cover,
          alignment: const Alignment(0, -0.25),
          cacheWidth: 720,
          excludeFromSemantics: true,
          frameBuilder: (context, child, frame, sync) =>
              frame == null && !sync ? placeholder : child,
          errorBuilder: (_, _, _) => placeholder,
        ),
      ),
    );
  }
}

/// Karakter satırını seslendirir: bölüm kaydı varsa o (sezon paketinde
/// `talk/…m4a`), yoksa cihazın İngilizce sesi (H-064 yedeği; ağ yok).
/// ElevenLabs sesleri sonra eklenecek; ücretli üretim yapılmadı.
class TalkLineSpeaker {
  TalkLineSpeaker(WidgetRef ref)
    : _audio = createCardAudio(ref),
      _speech = ref.read(exampleSpeechProvider);

  final CardAudioPlayer _audio;
  final ExampleSpeech _speech;
  bool? _device;

  /// Cihaz sesi var mı (bir kez sorulur).
  Future<bool> deviceAvailable() async => _device ??= await _speech.available();

  Future<void> play(TalkLine line) async {
    await stop();
    final audio = line.audio;
    if (audio != null) {
      await _audio.play(
        NotebookItem(
          kind: NotebookKind.sentence,
          textEn: line.en,
          source: NotebookSource.userSaved,
          contentId: 'talk',
          audio: MediaClip('_season/S$kTalkSeason/$audio'),
        ),
      );
      return;
    }
    if (await deviceAvailable()) {
      await _speech.speak(line.en, speed: exampleSpeechSpeed('A1'));
    }
  }

  Future<void> stop() async {
    await _audio.stop();
    await _speech.stop();
  }

  void dispose() {
    unawaited(_speech.stop());
    _audio.dispose();
  }
}

/// Konuşma balonu: karakter (solda, beyaz) ya da kullanıcı (sağda, mavi).
class TalkBubble extends StatelessWidget {
  const TalkBubble({
    super.key,
    required this.speaker,
    required this.text,
    this.mine = false,
    this.translation,
    this.trailing,
  });

  final String speaker;
  final String text;
  final bool mine;
  final String? translation;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = mine ? AppPalette.white : AppPalette.ink;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.86,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpace.s12,
            AppSpace.s8,
            AppSpace.s12,
            AppSpace.s8,
          ),
          decoration: BoxDecoration(
            color: mine ? AppPalette.seaBlue : AppPalette.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(AppRadius.lg),
              topRight: const Radius.circular(AppRadius.lg),
              bottomLeft: Radius.circular(mine ? AppRadius.lg : AppRadius.sm),
              bottomRight: Radius.circular(mine ? AppRadius.sm : AppRadius.lg),
            ),
            boxShadow: mine ? null : AppShadows.level1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                speaker,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: mine ? AppPalette.white : AppPalette.orange700,
                  fontWeight: AppFonts.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                text,
                style: theme.textTheme.titleMedium?.copyWith(color: fg),
              ),
              if (translation != null) ...[
                const SizedBox(height: AppSpace.s4),
                Text(
                  translation!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: mine ? AppPalette.white : AppPalette.ink500,
                  ),
                ),
              ],
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}

/// Karakter satırı: balon + "Dinle" + "Türkçesi" (istenince).
class TalkLineView extends StatefulWidget {
  const TalkLineView({
    super.key,
    required this.speaker,
    required this.line,
    required this.player,
    this.keyPrefix = 'talk-line',
  });

  final String speaker;
  final TalkLine line;
  final TalkLineSpeaker player;
  final String keyPrefix;

  @override
  State<TalkLineView> createState() => _TalkLineViewState();
}

class _TalkLineViewState extends State<TalkLineView> {
  bool _tr = false;
  bool _canListen = false;

  @override
  void initState() {
    super.initState();
    _canListen = widget.line.audio != null;
    if (!_canListen) {
      unawaited(
        widget.player.deviceAvailable().then((ok) {
          if (mounted && ok) setState(() => _canListen = true);
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.keyPrefix;
    return TalkBubble(
      key: ValueKey('$p-bubble'),
      speaker: widget.speaker,
      text: widget.line.en,
      translation: _tr ? widget.line.tr : null,
      trailing: Wrap(
        spacing: AppSpace.s4,
        children: [
          if (_canListen)
            TextButton.icon(
              key: ValueKey('$p-listen'),
              onPressed: () => unawaited(widget.player.play(widget.line)),
              style: TextButton.styleFrom(
                minimumSize: const Size(AppTouch.min, AppTouch.min),
              ),
              icon: const Icon(Icons.volume_up_rounded),
              label: const Text(TalkTexts.listen),
            ),
          TextButton.icon(
            key: ValueKey('$p-tr'),
            onPressed: () => setState(() => _tr = !_tr),
            style: TextButton.styleFrom(
              minimumSize: const Size(AppTouch.min, AppTouch.min),
            ),
            icon: const Icon(Icons.translate_rounded),
            label: Text(_tr ? TalkTexts.hideTr : TalkTexts.showTr),
          ),
        ],
      ),
    );
  }
}
