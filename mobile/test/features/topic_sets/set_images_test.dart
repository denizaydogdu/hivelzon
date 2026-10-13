import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/notebook/application/deck_sync.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/topic_sets/application/topic_set_providers.dart';
import 'package:hivelzon/shared/storage/app_database.dart';

import '../../support/fake_content_source.dart';

/// H-051 (H-036 iyileştirmesi): bölümden gelen kelime kartı, açık bir konu
/// setinde aynı kelime varsa setteki kırpılmış görseli kullanır.
void main() {
  late AppDatabase db;
  late NotebookStore store;
  late InMemoryProgressRepository progress;

  setUp(() {
    db = AppDatabase.memory();
    store = NotebookStore(db, clock: () => DateTime.utc(2026, 10, 13, 9));
    progress = InMemoryProgressRepository();
  });
  tearDown(() => db.close());

  NotebookItem word(String w, {String? image, String? audio}) => NotebookItem(
    kind: NotebookKind.word,
    textEn: w,
    textTr: 'tr',
    contentId: 'A1-002',
    imagePath: image,
    audio: audio == null ? null : MediaClip(audio, start: 1, end: 1.5),
    source: NotebookSource.lookup,
  );

  Future<NotebookItem> get(String w) async =>
      (await store.entries()).firstWhere((e) => e.item.textEn == w).item;

  test(
    'applySetImage: sahne görseli yerine nesne görseli; idempotent',
    () async {
      await store.addItems([
        word('sea', image: 'stills/s03.webp', audio: 'segments/s03.mp4'),
        word('harbour', image: 'stills/s05.webp'),
      ]);
      final set = loadTopicSetFixture('alex-room');
      final sea = set.toNotebookItem(
        set.items.firstWhere((i) => i.id == 'sea'),
      );
      expect(await store.applySetImage(sea), 1);
      var item = await get('sea');
      expect(item.imagePath, '_season/S1/sets/alex-room/sea.webp');
      expect(item.imageCrop, '0,0,1,1');
      // Bölümdeki ses korunur.
      expect(item.audio!.path, 'segments/s03.mp4');
      // İkinci çağrı bir şey değiştirmez; başka setin görseli üzerine yazılmaz.
      expect(await store.applySetImage(sea), 0);
      // Aynı kelime başka sette de olsa ilk uygulanan görsel kalır.
      await store.addItems([word('lighthouse', image: 'stills/x.webp')]);
      final harbour = loadTopicSetFixture('harbour');
      expect(
        await store.applySetImage(
          set.toNotebookItem(set.items.firstWhere((i) => i.id == 'lighthouse')),
        ),
        1,
      );
      expect(
        await store.applySetImage(
          harbour.toNotebookItem(
            harbour.items.firstWhere((i) => i.id == 'lighthouse'),
          ),
        ),
        0,
      );
      expect(
        (await get('lighthouse')).imagePath,
        '_season/S1/sets/alex-room/lighthouse.webp',
      );
      item = await get('sea');
      expect(item.imagePath, '_season/S1/sets/alex-room/sea.webp');
      // Defterde olmayan kelime için satır açılmaz.
      expect(
        await store.applySetImage(
          set.toNotebookItem(set.items.firstWhere((i) => i.id == 'cup')),
        ),
        0,
      );
      expect((await store.entries()).length, 3);
    },
  );

  test('DeckSync: yalnızca açık setlerin görselleri uygulanır', () async {
    // "radio" B1 setinde (alex-room), "note" B4 setinde (two-notes).
    await store.addItems([
      word('radio', image: 'stills/k1.webp'),
      word('note', image: 'stills/b4.webp'),
    ]);
    final sync = DeckSync(
      store: store,
      source: FakeContentSource(realSubtitles: true),
      progress: progress,
      lookups: (_) async => const [],
    );
    await sync.syncCompleted();
    expect((await get('radio')).imagePath, 'stills/k1.webp');

    // B1 bitti: alex-room açık; two-notes (B4) kilitli → "note" değişmez.
    await progress.markCompleted('A1-001', gate: const {});
    await sync.syncCompleted();
    expect(
      (await get('radio')).imagePath,
      '_season/S1/sets/alex-room/radio.webp',
    );
    expect((await get('note')).imagePath, 'stills/b4.webp');
  });

  test('TopicSetActions: ekleme var olan kartı ikinci kez eklemez', () async {
    final set = loadTopicSetFixture('maya-shop');
    final a = TopicSetActions(store);
    expect(await a.addToDeck(set, set.items.take(3)), 3);
    expect(await a.addToDeck(set, set.items), set.items.length - 3);
    final entries = await store.entries();
    expect(entries.length, set.items.length);
    expect(
      entries.every((e) => e.item.source == NotebookSource.topicSet),
      isTrue,
    );
    expect(entries.every((e) => e.card.isNew), isTrue);
  });
}
