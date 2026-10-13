import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../l10n/tr_strings.dart';
import 'speak_controller.dart';
import 'speech_match.dart';
import 'speech_recognizer_port.dart';
import 'speech_store.dart';

/// Bir yerin "Söyle" için ihtiyacı (H-055). Ekranlar Riverpod'dan kurar
/// (`speakEnvOf`); paylaşılan widget'lar sağlayıcı bilmez.
class SpeakEnv {
  const SpeakEnv({
    required this.recognizer,
    required this.ensureReady,
    required this.record,
    this.whyAction,
  });

  final SpeechRecognizerPort recognizer;

  /// İlk kullanımda Türkçe açıklama + sistem izni. false: dinlenmez.
  final Future<bool> Function(BuildContext context) ensureReady;

  /// Yalnızca sonuç kaydı (transkript yok).
  final void Function(SpeechAttempt attempt) record;

  /// Hata kataloğu notunu açan eylem; not yoksa null ("Neden böyle?" gizli).
  final VoidCallback? Function(BuildContext context, String noteId)? whyAction;
}

/// İzin öncesi Türkçe açıklama. true: "Devam et".
Future<bool> showSpeechPermissionSheet(BuildContext context) async {
  final ok = await showModalBottomSheet<bool>(
    context: context,
    useSafeArea: true,
    backgroundColor: AppColors.sand,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppTheme.radius),
      ),
    ),
    builder: (context) => const SpeechPermissionSheet(),
  );
  return ok == true;
}

class SpeechPermissionSheet extends StatelessWidget {
  const SpeechPermissionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      key: const ValueKey('speech-permission-sheet'),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.mic_none_rounded,
            size: 48,
            color: AppColors.seaBlue,
          ),
          const SizedBox(height: AppSpacing.xs),
          Semantics(
            header: true,
            child: Text(
              SpeakTexts.permissionTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(SpeakTexts.permissionBody, style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(SpeakTexts.permissionNext, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            key: const ValueKey('speech-permission-continue'),
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
            child: const Text(SpeakTexts.permissionContinue),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextButton(
            key: const ValueKey('speech-permission-later'),
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            child: const Text(SpeakTexts.permissionLater),
          ),
        ],
      ),
    );
  }
}

/// Mikrofon düğmesi + sakin geri bildirim (H-055). Puan, yüzde, dalga biçimi
/// yok. En çok 2 deneme; sonra "Sorun değil. İfade şöyle: …".
///
/// [onAttempt]: her denemeden sonra (kayıt ve yerin kendi akışı için).
class SpeakPractice extends StatefulWidget {
  const SpeakPractice({
    super.key,
    required this.expected,
    required this.env,
    required this.place,
    this.contentId,
    this.label = SpeakTexts.say,
    this.onAttempt,
    this.keyPrefix = 'speak',
    this.dense = false,
  });

  final String expected;
  final SpeakEnv env;
  final SpeechPlace place;
  final String? contentId;
  final String label;
  final void Function(SpeakController controller)? onAttempt;
  final String keyPrefix;

  /// Satır içi (bölüm sonu listesi): küçük düğme.
  final bool dense;

  @override
  State<SpeakPractice> createState() => _SpeakPracticeState();
}

class _SpeakPracticeState extends State<SpeakPractice> {
  late SpeakController _c = _make();

  SpeakController _make() => SpeakController(
    expected: widget.expected,
    recognizer: widget.env.recognizer,
  )..addListener(_changed);

  @override
  void didUpdateWidget(SpeakPractice old) {
    super.didUpdateWidget(old);
    if (old.expected != widget.expected) {
      _c
        ..removeListener(_changed)
        ..dispose();
      _c = _make();
    }
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _c
      ..removeListener(_changed)
      ..dispose();
    super.dispose();
  }

  Future<void> _go() async {
    if (_c.listening) {
      unawaited(_c.stop());
      return;
    }
    if (!await widget.env.ensureReady(context)) return;
    final m = await _c.listen();
    if (m == null) return;
    widget.env.record(
      SpeechAttempt(
        place: widget.place,
        contentId: widget.contentId,
        itemRef: widget.expected,
        level: m.level,
        missingCount: m.missingWords.length,
        errorNoteId: _c.errorNoteId,
        at: DateTime.now().toUtc(),
      ),
    );
    widget.onAttempt?.call(_c);
  }

  @override
  Widget build(BuildContext context) {
    final c = _c;
    final theme = Theme.of(context);
    final p = widget.keyPrefix;
    final children = <Widget>[];
    if (!c.finished) {
      final label = c.listening
          ? SpeakTexts.stop
          : c.attempts == 0
          ? widget.label
          : SpeakTexts.sayAgain;
      final icon = Icon(
        c.listening ? Icons.graphic_eq_rounded : Icons.mic_rounded,
      );
      children.add(
        Semantics(
          liveRegion: c.listening,
          child: widget.dense
              ? OutlinedButton.icon(
                  key: ValueKey('$p-mic'),
                  onPressed: _go,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(48, 48),
                    foregroundColor: AppColors.seaBlue,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: AppColors.seaBlue.withValues(alpha: 0.4),
                    ),
                  ),
                  icon: icon,
                  label: Text(label),
                )
              : FilledButton.tonalIcon(
                  key: ValueKey('$p-mic'),
                  onPressed: _go,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  icon: icon,
                  label: Text(label),
                ),
        ),
      );
      if (c.listening) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              SpeakTexts.listening,
              key: ValueKey('$p-listening'),
              style: theme.textTheme.bodyMedium,
            ),
          ),
        );
      }
    }
    final feedback = _feedback(c);
    if (feedback != null && !c.listening) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Semantics(
            liveRegion: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  c.succeeded
                      ? Icons.check_circle_rounded
                      : Icons.lightbulb_outline_rounded,
                  color: c.succeeded
                      ? AppColors.seaBlue
                      : AppColors.eveningOrange,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    feedback,
                    key: ValueKey('$p-feedback'),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: c.succeeded ? FontWeight.w700 : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (c.revealed) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 32),
          child: Text(
            widget.expected,
            key: ValueKey('$p-reveal'),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
      );
    }
    final note = c.errorNoteId;
    final why = note == null || c.listening
        ? null
        : widget.env.whyAction?.call(context, note);
    if (why != null) {
      children.add(
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            key: ValueKey('$p-why'),
            onPressed: why,
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            icon: const Icon(Icons.lightbulb_outline_rounded),
            label: const Text(SpeakTexts.why),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  /// Geri bildirim cümlesi (puan yok, "yanlış" yok).
  static String? _feedback(SpeakController c) {
    final m = c.last;
    if (m == null) return null;
    if (c.succeeded) return SpeakTexts.full;
    if (c.revealed) return SpeakTexts.reveal;
    if (c.silent) return SpeakTexts.silence;
    if (m.level == SpeechMatchLevel.close) {
      return SpeakTexts.close(m.missingWords.single);
    }
    if (m.missingWords.isNotEmpty && m.missingWords.length <= 3) {
      return '${SpeakTexts.missing(m.missingWords)}. ${SpeakTexts.tryAgain}';
    }
    return SpeakTexts.tryAgain;
  }
}
