import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/notebook/domain/review_policy.dart';
import 'package:hivelzon/features/topic_sets/domain/hunt_review.dart';
import 'package:hivelzon/features/topic_sets/domain/topic_set.dart';
import 'package:hivelzon/shared/content/content_source.dart';
import 'package:hivelzon/shared/fsrs/fsrs.dart';
import 'package:hivelzon/shared/progress/story_progress.dart';

import '../../support/fake_content_source.dart';
import '../../support/fixtures.dart';

void main() {
  group('paket verisi', () {
    test('season.json → topicSets özeti (sırayla)', () {
      final info = SeasonInfo.fromJson({
        'season': 1,
        'title': 'S',
        'topicSets': jsonDecode(
          fixtureText('sets/topic_sets.json'),
        )['topicSets'],
      });
      expect(info.topicSets.map((s) => s.id), [
        'alex-room',
        'maya-shop',
        'harbour',
        'two-notes',
      ]);
      final first = info.topicSets.first;
      expect(first.titleTr, "Alex'in odası");
      expect(first.unlockAfter, 'A1-001');
      expect(first.unlockEpisode, 1);
      expect(first.path, 'sets/alex-room.json');
      expect(SeasonInfo.fromJson({'season': 1}).topicSets, isEmpty);
    });

    test('set: öğeler, bölgeler, ses kaynakları', () {
      final set = loadTopicSetFixture('alex-room');
      expect(set.items.length, inInclusiveRange(6, 10));
      final radio = set.items.firstWhere((i) => i.id == 'radio');
      expect(radio.findEn, 'Find the radio!');
      expect(radio.findTr, 'Telsizi bul');
      expect(radio.tr, 'telsiz');
      expect(radio.audio, isNotNull);
      expect(radio.exampleAudio, isNotNull);
      expect(
        set.items.firstWhere((i) => i.id == 'desk').hotspots.single,
        isA<PolygonShape>(),
      );
      final harbour = loadTopicSetFixture('harbour');
      final bus = harbour.items.firstWhere((i) => i.id == 'bus-stop');
      expect(bus.kind, NotebookKind.phrase);
      expect(bus.findEn, 'Find the bus stop!');
    });

    test('sezon yolu ayrıştırma', () {
      expect(seasonMediaPath(1, 'sets/a/b.webp'), '_season/S1/sets/a/b.webp');
      expect(parseSeasonMediaPath('_season/S1/sets/a/b.webp'), (
        1,
        'sets/a/b.webp',
      ));
      expect(parseSeasonMediaPath('stills/T1.webp'), isNull);
      final src = FakeContentSource();
      expect(
        resolveMediaUri(src, 'A1-001', '_season/S1/sets/a.webp').toString(),
        'http://test.invalid/_season/S1/sets/a.webp',
      );
      expect(
        resolveMediaUri(src, 'A1-001', 'stills/x.webp').toString(),
        'http://test.invalid/A1-001/stills/x.webp',
      );
    });
  });

  group('kilit', () {
    final sets = topicSetSummaries();

    test('set kendi bölümü bitince açılır; sakin kilit nedeni', () {
      final v = resolveTopicSets(sets, {
        'A1-001': const StoryProgress(
          contentId: 'A1-001',
          status: StoryStatus.completed,
        ),
        'A1-002': const StoryProgress(
          contentId: 'A1-002',
          status: StoryStatus.completed,
        ),
        'A1-003': const StoryProgress(
          contentId: 'A1-003',
          status: StoryStatus.inProgress,
        ),
      });
      expect(v.map((e) => e.unlocked), [true, true, false, false]);
      expect(v[2].lockReason, "Bölüm 3'ü bitirince açılır.");
      expect(v[3].lockReason, "Bölüm 4'ü bitirince açılır.");
      expect(v[0].lockReason, isNull);
    });

    test('hiç bölüm bitmediyse hepsi kilitli', () {
      final v = resolveTopicSets(sets, const {});
      expect(v.every((e) => !e.unlocked), isTrue);
      expect(v.first.lockReason, "Bölüm 1'i bitirince açılır.");
      expect(topicSetLockReason(null), 'İlgili bölümü bitirince açılır.');
    });
  });

  group('isabet denetimi', () {
    const rect = RectShape(0.2, 0.2, 0.2, 0.1);
    // "L" biçimli içbükey çokgen.
    const poly = PolygonShape([
      (0.1, 0.1),
      (0.5, 0.1),
      (0.5, 0.2),
      (0.2, 0.2),
      (0.2, 0.5),
      (0.1, 0.5),
    ]);

    test('dikdörtgen: içeride, kenarda, dışarıda', () {
      expect(rect.contains(0.3, 0.25), isTrue);
      expect(rect.contains(0.2, 0.2), isTrue);
      expect(rect.contains(0.41, 0.25), isFalse);
    });

    test('içbükey çokgen: girintideki nokta dışarıda', () {
      expect(poly.contains(0.15, 0.4), isTrue);
      expect(poly.contains(0.4, 0.15), isTrue);
      expect(poly.contains(0.4, 0.4), isFalse);
      expect(poly.contains(0.5, 0.15), isTrue); // kenar
    });

    test('piksel uzayında pay: küçük nesneye yakın dokunuş sayılır', () {
      // 400×800 px görsel; dikdörtgen x 80–160, y 160–240.
      final it = TopicSetItem(
        id: 'x',
        w: 'x',
        tr: 'x',
        findEn: 'Find',
        findTr: 'Bul',
        exampleEn: 'x',
        exampleTr: 'x',
        image: 'x.webp',
        hotspots: const [rect],
      );
      expect(it.hitAt(100, 200, width: 400, height: 800), isTrue);
      expect(it.hitAt(170, 200, width: 400, height: 800), isFalse);
      expect(
        it.hitAt(170, 200, width: 400, height: 800, tolerance: 14),
        isTrue,
      );
      expect(
        it.hitAt(190, 200, width: 400, height: 800, tolerance: 14),
        isFalse,
      );
    });

    test('gerçek set: her bölgenin merkezi kendi öğesine isabet eder', () {
      for (final id in ['alex-room', 'maya-shop', 'harbour', 'two-notes']) {
        final set = loadTopicSetFixture(id);
        for (final it in set.items) {
          final (l, t, r, b) = it.hotspots.first.bounds;
          final s = it.hotspots.first;
          // Dikdörtgende merkez; çokgende içeride bir köşe ortası denenir.
          final (cx, cy) = s is RectShape
              ? ((l + r) / 2, (t + b) / 2)
              : _inside(s as PolygonShape);
          expect(
            it.hitAt(cx * 393, cy * 695, width: 393, height: 695),
            isTrue,
            reason: '$id/${it.id}',
          );
        }
      }
    });
  });

  group('sahne avı oturumu', () {
    final set = loadTopicSetFixture('alex-room');
    const size = (393.0, 695.0);
    (double, double) center(TopicSetItem it) {
      final s = it.hotspots.first;
      final (l, t, r, b) = s.bounds;
      final (x, y) = s is RectShape
          ? ((l + r) / 2, (t + b) / 2)
          : _inside(s as PolygonShape);
      return (x * size.$1, y * size.$2);
    }

    HuntTap tapOn(HuntSession s, (double, double) p) =>
        s.tap(p.$1, p.$2, width: size.$1, height: size.$2);

    test('doğru, yanlış, ipucu ve Bilmiyorum; FSRS notları', () {
      final order = [
        set.items.firstWhere((i) => i.id == 'radio'),
        set.items.firstWhere((i) => i.id == 'clock'),
        set.items.firstWhere((i) => i.id == 'cup'),
        set.items.firstWhere((i) => i.id == 'boat'),
      ];
      final s = HuntSession(set, order: order);
      expect(s.total, 4);
      expect(s.position, 1);
      // 1) radio: tek yanlıştan sonra doğru → Good
      expect(tapOn(s, center(order[1])), HuntTap.miss);
      expect(s.showHint, isFalse);
      expect(tapOn(s, center(order[0])), HuntTap.correct);
      expect(s.resolved, isTrue);
      expect(tapOn(s, center(order[0])), HuntTap.ignored);
      s.next();
      // 2) clock: iki yanlış → ipucu → doğru → Again
      tapOn(s, center(order[2]));
      tapOn(s, center(order[2]));
      expect(s.showHint, isTrue);
      expect(tapOn(s, center(order[1])), HuntTap.correct);
      expect(s.showHint, isFalse);
      s.next();
      // 3) cup: Bilmiyorum → Again
      s.reveal();
      expect(s.revealed, isTrue);
      s.next();
      // 4) boat: ilk seferde → Good
      expect(tapOn(s, center(order[3])), HuntTap.correct);
      s.next();
      expect(s.finished, isTrue);
      expect(s.results.map((r) => r.foundAlone), [true, false, false, true]);
      expect(s.foundAlone, 2);
      expect(s.helped, 2);
    });

    test('ekran okuyucu seçenekleri: doğru öğe + en çok 3 başka', () {
      final s = HuntSession(set, random: math.Random(1));
      final c = s.choices(random: math.Random(2));
      expect(c.length, 4);
      expect(c.map((e) => e.id), contains(s.current!.id));
      expect(
        s.choose(c.firstWhere((e) => e.id != s.current!.id)),
        HuntTap.miss,
      );
      expect(s.choose(s.current!), HuntTap.correct);
    });

    test('sıra karışık ama bütün öğeler bir kez', () {
      final s = HuntSession(set, random: math.Random(3));
      expect(
        s.order.map((e) => e.id).toSet(),
        set.items.map((e) => e.id).toSet(),
      );
      expect(s.order.length, set.items.length);
    });
  });

  group('defter kartı ve FSRS', () {
    final set = loadTopicSetFixture('alex-room');

    test('kart: kırpılmış görsel, karakterin sesi, örnek cümle aralığı', () {
      final radio = set.toNotebookItem(
        set.items.firstWhere((i) => i.id == 'radio'),
      );
      expect(radio.source, NotebookSource.topicSet);
      expect(radio.contentId, 'A1-001');
      expect(radio.episodeTag, 'B1');
      expect(radio.imagePath, '_season/S1/sets/alex-room/radio.webp');
      expect(radio.key, 'word|radio');
      // Kelime ve örnek aynı kayıttan: tek dosya, kelime aralığı içinde.
      expect(radio.audio!.path, '_season/S1/sets/alex-room/radio.example.m4a');
      expect(radio.audio!.isRange, isTrue);
      expect(radio.audio!.start, greaterThan(0.5));
      expect(radio.exampleAudio!.start, 0);
      // Sesi olmayan öğe: ses düğmesi yok.
      final cup = set.toNotebookItem(
        set.items.firstWhere((i) => i.id == 'cup'),
      );
      expect(cup.hasAudio, isFalse);
      expect(cup.exampleAudio, isNull);
      // Yalnız kelime sesi (örnek cümle sesi yok): dosyanın tamamı, örnek yok.
      final harbour = loadTopicSetFixture('harbour');
      final fish = harbour.toNotebookItem(
        harbour.items.firstWhere((i) => i.id == 'fish'),
      );
      expect(fish.audio!.path, '_season/S1/sets/harbour/fish.m4a');
      expect(fish.audio!.start, 0);
      expect(fish.exampleAudio, isNull);
    });

    test('yalnızca defterdeki öğeler; pratik: FSRS\'e yazılmaz (H-089)', () {
      final now = DateTime.utc(2026, 10, 13, 12);
      NotebookEntry entry(int id, String w, {DateTime? last}) => NotebookEntry(
        NotebookItem(
          id: id,
          kind: NotebookKind.word,
          textEn: w,
          source: NotebookSource.topicSet,
        ),
        ReviewCardState(
          id: id,
          itemId: id,
          fsrs: FsrsCard(
            state: last == null ? FsrsState.learning : FsrsState.review,
            step: last == null ? 0 : null,
            stability: last == null ? null : 5,
            difficulty: last == null ? null : 5,
            due: now,
            lastReview: last,
          ),
          reps: last == null ? 0 : 3,
        ),
      );
      final items = {for (final i in set.items) i.id: i};
      final results = [
        HuntResult(item: items['radio']!, misses: 0, revealed: false),
        HuntResult(item: items['clock']!, misses: 3, revealed: false),
        HuntResult(item: items['cup']!, misses: 0, revealed: true),
        HuntResult(item: items['boat']!, misses: 0, revealed: false),
        HuntResult(item: items['sea']!, misses: 0, revealed: false),
      ];
      final out = huntOutcomes(
        results: results,
        entries: [
          entry(1, 'radio'),
          entry(2, 'clock', last: DateTime.utc(2026, 10, 1)),
          entry(3, 'cup'),
          entry(4, 'sea', last: now.subtract(const Duration(hours: 1))),
          // boat defterde yok → yazılmaz.
        ],
        now: now,
      );
      expect(out.map((o) => o.item.textEn), ['radio', 'clock', 'cup', 'sea']);
      expect(out.map((o) => o.correct), [true, false, false, true]);
      // Tanıma: not yok, kart değişmez (yalnız kanıt basamağı yazılır).
      expect(out.every((o) => o.practice), isTrue);
      expect(out.every((o) => o.taskType == TaskType.sceneHunt), isTrue);
      expect(out.every((o) => identical(o.after, o.before)), isTrue);
      expect(out[2].dontKnow, isTrue);
    });
  });
}

/// Çokgenin içinde bir nokta: ilk üç köşenin ağırlık merkezi ile kenar
/// ortalarından içeride olan ilk nokta.
(double, double) _inside(PolygonShape p) {
  final pts = p.points;
  final n = pts.length;
  final cx = pts.map((e) => e.$1).reduce((a, b) => a + b) / n;
  final cy = pts.map((e) => e.$2).reduce((a, b) => a + b) / n;
  if (p.contains(cx, cy)) return (cx, cy);
  for (var i = 0; i < n; i++) {
    final a = pts[i];
    final b = pts[(i + 1) % n];
    final c = pts[(i + 2) % n];
    final x = (a.$1 + b.$1 + c.$1) / 3;
    final y = (a.$2 + b.$2 + c.$2) / 3;
    if (p.contains(x, y)) return (x, y);
  }
  throw StateError('içeride nokta yok');
}
