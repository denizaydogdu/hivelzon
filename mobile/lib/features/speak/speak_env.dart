import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/tr_strings.dart';
import '../../shared/speech/speak_widgets.dart';
import '../../shared/speech/speech_providers.dart';
import '../hi/application/hi_providers.dart';
import '../hi/presentation/hi_cards.dart';

/// Ekranın "Söyle" ortamı (H-055): sağlayıcılardan tanıyıcı, izin akışı,
/// sonuç kaydı ve Hi'nin notu.
SpeakEnv speakEnvOf(BuildContext context) {
  final container = ProviderScope.containerOf(context, listen: false);
  return SpeakEnv(
    recognizer: container.read(speechRecognizerProvider),
    ensureReady: (ctx) => ensureSpeechReady(ctx, container),
    record: (a) => unawaited(
      container
          .read(speechStoreProvider)
          .record(a)
          .catchError((Object e) => debugPrint('[H055] sonuç yazılamadı: $e')),
    ),
    whyAction: (ctx, id) {
      final note = container.read(hiContentProvider).value?.note(id);
      if (note == null) return null;
      return () => unawaited(showHiNote(ctx, note));
    },
  );
}

/// Dinlemeden önce: izin verilmişse hemen; ilk kullanımda önce Türkçe
/// açıklama, sonra sistem izni. Reddedilirse "Söyle" gizlenir (durum yenilenir).
Future<bool> ensureSpeechReady(
  BuildContext context,
  ProviderContainer container,
) async {
  final status = await container.read(speechStatusProvider.future);
  if (status == SpeechStatus.ready) return true;
  if (status != SpeechStatus.needsPermission || !context.mounted) return false;
  final go = await showSpeechPermissionSheet(context);
  if (!go) return false;
  await container.read(speechStoreProvider).markPermissionAsked();
  final granted = await container
      .read(speechRecognizerProvider)
      .requestPermission();
  container.invalidate(speechStatusProvider);
  debugPrint('[H055] izin ${granted ? 'verildi' : 'verilmedi'}');
  if (!granted && context.mounted) {
    ScaffoldMessenger.maybeOf(
      context,
    )?.showSnackBar(const SnackBar(content: Text(SpeakTexts.permissionDenied)));
  }
  return granted;
}
