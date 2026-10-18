// H-094 P0: bağımsız reel paketi (katalog + içerik), medya yolu çözümü ve
// Defter bağlantısı; eski hikâye kliplerinin bozulmadığının kanıtı.
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/discover/domain/reel.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/shared/content/content_source.dart';
import 'package:hivelzon/shared/meaning/notebook_repository.dart';

import '../../support/fake_content_source.dart';

void main() {
  group('reel kataloğu', () {
    test('index.json özetleri okunur', () {
      final cat = loadReelCatalogFixture();
      expect(cat.reels.map((r) => r.id), [
        'A1-R-BOK-01',
        'A1-R-CIN-01',
        'A1-R-SPO-01',
        'A2-R-BOK-01',
        'A2-R-CIN-01',
        'A2-R-SPO-01',
      ]);
      final first = cat.byId('A1-R-CIN-01')!;
      expect(first.category, 'CIN');
      expect(first.categoryTr, 'Sinema');
      expect(first.level, 'A1');
      expect(first.duration, 12.0);
      expect(first.sourceType, 'standalone');
      expect(first.contentVersion, 1);
      expect(first.isWithdrawn, isFalse);
    });

    test('kategoriye ve seviyeye göre süzülür', () {
      final cat = loadReelCatalogFixture();
      expect(cat.byCategory('CIN').map((r) => r.id), [
        'A1-R-CIN-01',
        'A2-R-CIN-01',
      ]);
      expect(cat.byCategory('CIN', level: 'A2').map((r) => r.id), [
        'A2-R-CIN-01',
      ]);
      expect(cat.byCategory('SPO', level: 'A2').map((r) => r.id), [
        'A2-R-SPO-01',
      ]);
      // Pilot: her seviyede üç konu (Sinema · Spor · Kitap) dolu olmalı.
      expect(cat.forLevel('A1').map((r) => r.id), [
        'A1-R-BOK-01',
        'A1-R-CIN-01',
        'A1-R-SPO-01',
      ]);
      expect(cat.forLevel('A2'), hasLength(3));
      expect(cat.forLevel('A2').map((r) => r.category).toSet(), {
        'CIN',
        'SPO',
        'BOK',
      });
    });

    test('geri çekilen içerik işaretlenir (sabit seçkide oynatılmaz)', () {
      final cat = ReelCatalog.fromJson({
        'schemaVersion': 1,
        'reels': [
          {'id': 'A1-R-CIN-02', 'category': 'CIN', 'level': 'A1', 'status': 'WITHDRAWN'},
        ],
      });
      expect(cat.byId('A1-R-CIN-02')!.isWithdrawn, isTrue);
    });

    test('bilinmeyen schemaVersion sessizce boş göstermez, açık hata verir', () {
      expect(
        () => ReelCatalog.fromJson({'schemaVersion': 2, 'reels': const []}),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('reel içeriği', () {
    test('Alanlar, hedef ve öğrenme hedefi okunur', () {
      final reel = loadReelFixture('A1-R-CIN-01');
      expect(reel.id, 'A1-R-CIN-01');
      expect(reel.titleTr, 'Gişede iki bilet');
      expect(reel.learningObjective, 'Kibarca bilet istemek');
      expect(reel.family, 'FAM-CIN-TICKETS');
      expect(reel.isStandalone, isTrue);
      expect(reel.target.en, 'Two tickets, please.');
      expect(reel.target.tr, 'İki bilet, lütfen.');
      expect(reel.target.cueId, 's02-02');
      // Bağımsız reel kendi kaynağıdır (bölüm kimliği taşımaz).
      expect(reel.sourceContentId, 'A1-R-CIN-01');
      expect(reel.sourceCueId, 's02-02');
      // Gerçek bağ yoksa "Tam hikâye" gizlenir.
      expect(reel.related, isEmpty);
    });

    test('Hedef satırı ve altyazı zamanları videonun başına görelidir', () {
      final reel = loadReelFixture('A1-R-CIN-01');
      expect(reel.subtitles.cues.map((c) => c.id), [
        's02-01',
        's02-02',
        's02-03',
      ]);
      final cue = reel.targetCue!;
      expect(cue.id, 's02-02');
      expect(cue.tr, 'İki bilet, lütfen.');
      expect(cue.words.map((w) => w.w), ['Two', 'tickets,', 'please.']);
    });

    test('Tek anlama sorusu: tek doğru cevap', () {
      final reel = loadReelFixture('A1-R-CIN-01');
      final p = reel.practice!;
      expect(p.promptTr, 'Kaç bilet isteniyor?');
      expect(p.correctIndex, 0);
      expect(p.options.map((o) => o.text), ['İki', 'Bir', 'Üç']);
      expect(p.options.where((o) => o.correct).length, 1);
    });

    test('Defter için taşınacak görsel/ses yolu paket içindedir', () {
      final reel = loadReelFixture('A1-R-CIN-01');
      expect(reel.image, 'stills/s02.webp');
      expect(reel.audio, 'audio/s02-02.m4a');
      expect(reel.poster, 'A1-R-CIN-01.webp');
      expect(reel.video, 'A1-R-CIN-01.mp4');
    });
  });

  group('medya yolu', () {
    test('reelMediaPath/parseReelMediaPath turu', () {
      final path = reelMediaPath('A1-R-CIN-01', 'stills/s02.webp');
      expect(path, '_reels/A1-R-CIN-01/stills/s02.webp');
      expect(parseReelMediaPath(path), ('A1-R-CIN-01', 'stills/s02.webp'));
      expect(parseReelMediaPath('stills/s02.webp'), isNull);
    });

    test('resolveMediaUri reel paketini tanır', () {
      final source = FakeContentSource();
      expect(
        resolveMediaUri(source, 'A1-R-CIN-01', '_reels/A1-R-CIN-01/audio/s02-02.m4a').toString(),
        'http://test.invalid/reels/A1-R-CIN-01/audio/s02-02.m4a',
      );
    });

    test('eski yollar bozulmaz: bölüm, sezon, kitap, ders', () {
      final source = FakeContentSource();
      // Bölüm paketi (hikâye klipleri aynı yolu kullanır).
      expect(
        resolveMediaUri(source, 'A1-001', 'stills/s02.webp').toString(),
        'http://test.invalid/A1-001/stills/s02.webp',
      );
      // Sezon paketi.
      expect(
        resolveMediaUri(source, 'A1-001', '_season/S1/sets/daily.json').toString(),
        'http://test.invalid/_season/S1/sets/daily.json',
      );
      // Kitap paketi.
      expect(
        resolveMediaUri(source, 'A1-K99', '_books/A1-K99/audio/c1.m4a').toString(),
        'http://test.invalid/books/A1-K99/audio/c1.m4a',
      );
      // Ders paketi.
      expect(
        resolveMediaUri(
          source,
          'G-A1-99-third-person-s',
          '_grammar/G-A1-99-third-person-s/audio/c07-ex1.m4a',
        ).toString(),
        'http://test.invalid/grammar/G-A1-99-third-person-s/audio/c07-ex1.m4a',
      );
    });
  });

  group('Defter bağlantısı (reel kaynağı)', () {
    /// P3'te Keşfet ekranının yapacağı: reel hedefini Defter'e eklerken
    /// kaynak kimliği + paket içi görsel/ses yollarını taşımak.
    SavedPhrase savedFromReel(Reel reel) => SavedPhrase(
      contentId: reel.sourceContentId,
      sourceId: reel.sourceCueId ?? '',
      kind: SavedKind.phrase,
      en: reel.target.en,
      tr: reel.target.tr,
      source: NotebookSource.userSaved,
      savedAt: DateTime.utc(2026, 10, 18),
      imagePath: reelMediaPath(reel.id, reel.image!),
      audio: MediaClip(reelMediaPath(reel.id, reel.audio!)),
    );

    test('görsel ve ses doğru reel paketine çözülür', () {
      final reel = loadReelFixture('A1-R-CIN-01');
      final item = savedFromReel(reel).toItem();
      final source = FakeContentSource();

      expect(item.contentId, 'A1-R-CIN-01');
      expect(item.cueId, 's02-02');
      expect(item.textEn, 'Two tickets, please.');
      expect(item.textTr, 'İki bilet, lütfen.');

      expect(
        resolveMediaUri(source, item.contentId!, item.imagePath!).toString(),
        'http://test.invalid/reels/A1-R-CIN-01/stills/s02.webp',
      );
      expect(
        resolveMediaUri(source, item.contentId!, item.audio!.path).toString(),
        'http://test.invalid/reels/A1-R-CIN-01/audio/s02-02.m4a',
      );
    });

    test('bağımsız reel bölüm etiketi taşımaz', () {
      final reel = loadReelFixture('A1-R-CIN-01');
      expect(savedFromReel(reel).toItem().episodeTag, isNull);
    });

    test('aynı ifade iki kez eklenmez (mevcut davranış korunur)', () async {
      final reel = loadReelFixture('A1-R-CIN-01');
      final repo = InMemoryNotebookRepository();
      expect(await repo.add(savedFromReel(reel)), isTrue);
      expect(await repo.add(savedFromReel(reel)), isFalse);
      expect(await repo.all(), hasLength(1));
    });
  });

  group('eski hikâye klipleri', () {
    test('clips.json 17 klip ile okunmaya devam eder', () {
      final cat = loadClipFixture();
      expect(cat.clips, hasLength(17));
      expect(cat.clips.first.id, 'S1-K01');
      expect(cat.clips.first.episodeId, 'A1-001');
    });

    test('klip katalogu reellerden bağımsız yüklenir', () async {
      final source = FakeContentSource()..withClips = true;
      final clips = await source.loadClips(1, 'clips.json');
      expect(clips.clips, hasLength(17));
      expect(source.reelListCalls, 0);
    });
  });
}
