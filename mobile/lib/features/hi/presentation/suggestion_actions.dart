// Günlük planın eylemi (H-088): Ana Sayfa kartı, Hi önerisiyle aynı yere
// gider. Not önerisi notu açar; sayfa önerisi sayfayı iter ve dönünce plan,
// defter ve hikâye yenilenir.

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../notebook/application/notebook_providers.dart';
import '../../story/application/story_providers.dart';
import '../application/hi_providers.dart';
import '../domain/coach_rules.dart';
import 'hi_cards.dart';

/// Ana Sayfa'dan öneriyi açar. Defter önerisi Ana Sayfa sekmesindeki
/// Defter'i açar (sekme değişmez).
Future<void> openSuggestionFromHome(
  BuildContext context,
  WidgetRef ref,
  HiSuggestion s,
) async {
  final store = ref.read(hiStoreProvider);
  final type = s.errorType;
  if (type != null) {
    try {
      await store.markNoteRead(type);
    } on Object {
      // Not yine açılır; okundu işareti bir dahakine yazılır.
    }
  }
  final noteId = s.noteId;
  if (noteId != null) {
    final content = await ref.read(hiContentProvider.future);
    final note = content.note(noteId);
    if (!context.mounted) return;
    if (note != null) await showHiNote(context, note);
    if (context.mounted) refreshHi(ref);
    return;
  }
  var route = s.actionRoute;
  if (route == null) return;
  if (route == AppRoutes.notebook) route = AppRoutes.homeNotebook;
  if (!context.mounted) return;
  await context.push(route);
  if (!context.mounted) return;
  await refreshWhenVisible(context, ref);
  refreshNotebook(ref);
  refreshHi(ref);
}
