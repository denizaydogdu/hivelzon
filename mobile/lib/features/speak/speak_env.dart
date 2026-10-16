import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/tr_strings.dart';
import '../../shared/speech/speak_widgets.dart';
import '../../shared/speech/speech_providers.dart';
import '../../shared/speech/speech_store.dart';
import '../notebook/application/notebook_providers.dart';
import '../hi/application/hi_providers.dart';
import '../hi/presentation/hi_cards.dart';

/// Ekranın "Söyle" ortamı (H-055): sağlayıcılardan tanıyıcı, izin akışı,
/// sonuç kaydı, Hi'nin notu ve hikâye içi taklidin kanıtı (H-093).
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
    practiced: (p) => unawaited(
      recordSpokenPractice(container, p).then<void>(
        (_) {},
        onError: (Object e) => debugPrint('[H093] kanıt yazılamadı: $e'),
      ),
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

/// Hikâye içi "Söyle" başarısı → "yardımla yaptı" (H-093;
/// `docs/KELIME-TEKRARI.md` §3.1). Anlam paneli (oynatıcı, Keşfet, kitap),
/// bölüm sonu hedef ifadeler ve karar anı yazılır; kelime tekrarı kendi
/// sonucunu yazar (`saveOutcome`), dilbilgisi alıştırması ifade değildir.
/// Bölüm sonu ve karar anında söylenen hedef ifadedir: kart henüz yoksa bölüm
/// bitince oluşacak kartın anahtarıyla yazılır.
Future<Set<String>> recordSpokenPractice(
  ProviderContainer container,
  SpokenPractice p,
) async {
  final target = switch (p.place) {
    SpeechPlace.episodeEnd || SpeechPlace.decision => true,
    SpeechPlace.meaning => false,
    SpeechPlace.review || SpeechPlace.grammar || SpeechPlace.talk => null,
  };
  if (target == null) return const {};
  final keys = await container
      .read(notebookStoreProvider)
      .recordSpokenPractice(
        p.expression,
        contentId: p.contentId,
        targetPhrase: target,
      );
  if (keys.isNotEmpty) container.invalidate(evidenceSummaryProvider);
  return keys;
}
