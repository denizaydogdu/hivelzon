import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/content/content_providers.dart';
import '../../../shared/state/safe_refresh.dart';
import '../../../shared/storage/storage_providers.dart';
import '../../onboarding/application/onboarding_providers.dart';
import '../../player/presentation/player_screen.dart';
import '../data/book_progress_store.dart';
import '../domain/book.dart';
import '../domain/book_progress.dart';
import 'book_audio.dart';

final bookProgressStoreProvider = Provider<BookProgressStore>(
  (ref) => BookProgressStore(
    ref.watch(appDatabaseProvider),
    ready: ref.watch(legacyImportProvider),
  ),
);

/// Sunucudaki kitaplar (`/books/index.json`). Otomatik yeniden deneme yok:
/// hata ekranı "Tekrar dene" ile kullanıcıya bırakılır.
final bookListProvider = FutureProvider.autoDispose<List<BookSummary>>(
  (ref) => ref.watch(contentSourceProvider).listBooks(),
  retry: (_, _) => null,
);

/// Kitap başına ilerleme (cihazdaki).
final bookProgressProvider =
    FutureProvider.autoDispose<Map<String, BookProgress>>(
      (ref) => ref.watch(bookProgressStoreProvider).all(),
      retry: (_, _) => null,
    );

/// Yerleştirme testinin önerdiği seviye (yoksa null → A1).
final suggestedLevelProvider = FutureProvider.autoDispose<String?>((ref) async {
  try {
    return await ref.watch(onboardingStoreProvider).suggestedLevel();
  } on Object {
    return null;
  }
}, retry: (_, _) => null);

/// Kitaplık ekranının verisi.
class LibraryData {
  const LibraryData({
    required this.books,
    required this.progress,
    required this.shelves,
  });

  final List<BookSummary> books;
  final Map<String, BookProgress> progress;
  final LibraryShelves shelves;
}

final libraryProvider = FutureProvider.autoDispose<LibraryData>((ref) async {
  final books = await ref.watch(bookListProvider.future);
  final progress = await ref.watch(bookProgressProvider.future);
  final level = await ref.watch(suggestedLevelProvider.future);
  return LibraryData(
    books: books,
    progress: progress,
    shelves: buildShelves(books, progress, suggestedLevel: level),
  );
}, retry: (_, _) => null);

/// Kitap sesi çalar (testlerde sahtesi verilir).
final bookAudioFactoryProvider = Provider<BookAudio Function()>((ref) {
  final factory = ref.watch(videoControllerFactoryProvider);
  return () => VideoPlayerBookAudio(factory: factory);
});

/// Okuyucunun saati (sn, tekdüze). Testlerde elle ilerletilir.
final readerClockProvider = Provider<double Function()?>((ref) => null);

/// "Bana bir kitap oku" seçimi (testlerde sabit tohum).
final libraryRandomProvider = Provider<math.Random>((ref) => math.Random());

/// İlerleme değişince Kitaplık ve Hi yenilenir.
void refreshLibrary(WidgetRef ref) =>
    invalidateAndFlush(ref, [bookProgressProvider, libraryProvider]);
