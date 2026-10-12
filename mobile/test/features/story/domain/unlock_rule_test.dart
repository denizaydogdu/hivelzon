import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/story/domain/season_map.dart';
import 'package:hivelzon/features/story/domain/unlock_rule.dart';
import 'package:hivelzon/shared/content/content_source.dart';
import 'package:hivelzon/shared/progress/story_progress.dart';

StoryProgress _p(
  String id, {
  StoryStatus status = StoryStatus.notStarted,
  Set<GateItem> gate = const {},
  String? checkpoint,
}) => StoryProgress(
  contentId: id,
  status: status,
  gateItems: gate,
  lastCheckpointNodeId: checkpoint,
);

final _all = GateItem.values.toSet();

void main() {
  group('episodeAccess (K-26, K-29)', () {
    // (açıklama, N, paket var mı, kendi durumu, önceki bölüm, beklenen, eksikler)
    final table =
        <
          (
            String,
            int,
            bool,
            StoryProgress?,
            StoryProgress?,
            EpisodeAvailability,
            Set<GateItem>,
          )
        >[
          (
            'B1 her zaman açık',
            1,
            true,
            null,
            null,
            EpisodeAvailability.playable,
            {},
          ),
          (
            'B1 paketi yok → yakında',
            1,
            false,
            null,
            null,
            EpisodeAvailability.comingSoon,
            {},
          ),
          (
            'B2, B1 hiç oynanmadı',
            2,
            true,
            null,
            null,
            EpisodeAvailability.locked,
            _all,
          ),
          (
            'B2, B1 kapısı tamam',
            2,
            true,
            null,
            _p('A1-001', status: StoryStatus.completed, gate: _all),
            EpisodeAvailability.playable,
            {},
          ),
          (
            'B2, B1 bitti ama hedef ifade eksik',
            2,
            true,
            null,
            _p(
              'A1-001',
              status: StoryStatus.completed,
              gate: {GateItem.comprehension, GateItem.activeTask},
            ),
            EpisodeAvailability.locked,
            {GateItem.targetPhrase},
          ),
          (
            'B2, B1 yarım',
            2,
            true,
            null,
            _p('A1-001', status: StoryStatus.inProgress, checkpoint: 's03'),
            EpisodeAvailability.locked,
            _all,
          ),
          (
            'B3 daha önce başlanmış → tekrar her zaman açık',
            3,
            true,
            _p('A1-003', status: StoryStatus.inProgress),
            null,
            EpisodeAvailability.playable,
            {},
          ),
          (
            'B3 bitmiş → tekrar oyna açık',
            3,
            true,
            _p('A1-003', status: StoryStatus.completed),
            _p('A1-002'),
            EpisodeAvailability.playable,
            {},
          ),
          (
            'B5 paketi yok, B4 kapısı tamam → yakında (tarih yok)',
            5,
            false,
            null,
            _p('A1-004', status: StoryStatus.completed, gate: _all),
            EpisodeAvailability.comingSoon,
            {},
          ),
        ];
    for (final (name, n, available, own, prev, kind, missing) in table) {
      test(name, () {
        final a = episodeAccess(
          number: n,
          available: available,
          own: own,
          previous: prev,
        );
        expect(a.kind, kind);
        expect(a.missing, missing);
        if (kind == EpisodeAvailability.locked) expect(a.blockedBy, n - 1);
      });
    }
  });

  group('kilit nedeni (nazik, süre yok)', () {
    test('hiç oynanmamış önceki bölüm', () {
      expect(
        lockReason(EpisodeAccess.locked(blockedBy: 2, missing: _all)),
        "Önce Bölüm 2'yi tamamla. Kalan adımlar: anlama, hedef ifade ve görev.",
      );
    });
    test('tek eksik', () {
      expect(
        lockReason(
          const EpisodeAccess.locked(
            blockedBy: 1,
            missing: {GateItem.activeTask},
          ),
        ),
        "Önce Bölüm 1'i tamamla. Kalan adımlar: görev.",
      );
    });
    test('kilitli değilse neden yok', () {
      expect(lockReason(const EpisodeAccess.playable()), isNull);
      expect(lockReason(const EpisodeAccess.comingSoon()), isNull);
    });
    test('belirtme hâli ekleri', () {
      expect(
        [for (var n = 1; n <= 12; n++) accusativeNumber(n)],
        [
          "1'i",
          "2'yi",
          "3'ü",
          "4'ü",
          "5'i",
          "6'yı",
          "7'yi",
          "8'i",
          "9'u",
          "10'u",
          "11'i",
          "12'yi",
        ],
      );
      expect(accusativeNumber(20), "20'yi");
      expect(accusativeNumber(40), "40'ı");
    });
    test('hiçbir metinde süre ya da suçlama yok', () {
      final texts = [
        for (final m in [
          _all,
          {GateItem.targetPhrase},
        ])
          lockReason(EpisodeAccess.locked(blockedBy: 3, missing: m))!,
      ];
      for (final t in texts) {
        expect(
          t,
          isNot(matches(RegExp(r'gün|saat|dakika|kaçırdın|başaramadın'))),
        );
      }
    });
  });

  group('buildSeasonMap', () {
    List<PackageSummary> pkgs(List<String> ids) => [
      for (final id in ids)
        PackageSummary(
          id: id,
          title: id,
          season: 1,
          number: int.parse(id.substring(3)),
        ),
    ];
    SeasonInfo info(List<String> built) => SeasonInfo(
      season: 1,
      title: 'The Missing Signal',
      episodes: [
        for (var n = 1; n <= 12; n++)
          SeasonEpisode(
            number: n,
            contentId: 'A1-${n.toString().padLeft(3, '0')}',
            title: 'T$n',
            available: built.contains('A1-${n.toString().padLeft(3, '0')}'),
            mapX: 0.5,
            mapY: 1 - n / 13,
          ),
      ],
    );
    const four = ['A1-001', 'A1-002', 'A1-003', 'A1-004'];

    test('yeni kurulum: B1 sıradaki, B2–B4 kilitli, B5+ yakında', () {
      final m = buildSeasonMap(
        season: 1,
        info: info(four),
        packages: pkgs(four),
        progress: const {},
      );
      expect(m.total, 12);
      expect(m.completedCount, 0);
      expect(
        [for (final e in m.episodes) e.state],
        [
          MapNodeState.next,
          MapNodeState.locked,
          MapNodeState.locked,
          MapNodeState.locked,
          for (var i = 5; i <= 12; i++) MapNodeState.comingSoon,
        ],
      );
      expect(m.focus!.number, 1);
      expect(m.episodes[2].semanticsLabel, 'Bölüm 3, T3, kilitli');
    });

    test('B1 bitti: B2 sıradaki; B2 yarım: odak B2 (devam)', () {
      var m = buildSeasonMap(
        season: 1,
        info: info(four),
        packages: pkgs(four),
        progress: {
          'A1-001': _p('A1-001', status: StoryStatus.completed, gate: _all),
        },
      );
      expect(m.episodes[0].state, MapNodeState.completed);
      expect(m.episodes[1].state, MapNodeState.next);
      expect(m.episodes[2].state, MapNodeState.locked);
      expect(m.focus!.number, 2);
      expect(m.completedCount, 1);
      m = buildSeasonMap(
        season: 1,
        info: info(four),
        packages: pkgs(four),
        progress: {
          'A1-001': _p('A1-001', status: StoryStatus.completed, gate: _all),
          'A1-002': _p(
            'A1-002',
            status: StoryStatus.inProgress,
            checkpoint: 's03',
          ),
        },
      );
      expect(m.episodes[1].state, MapNodeState.inProgress);
      expect(m.focus!.number, 2);
      expect(m.focus!.progress.hasCheckpoint, isTrue);
    });

    test('katalog "available" dese de paket listede yoksa yakında', () {
      final m = buildSeasonMap(
        season: 1,
        info: info(four),
        packages: pkgs(['A1-001']),
        progress: const {},
      );
      expect(m.episodes[1].state, MapNodeState.comingSoon);
    });

    test('hepsi bitti: odak yok, ilk yakında bölüm', () {
      final m = buildSeasonMap(
        season: 1,
        info: info(four),
        packages: pkgs(four),
        progress: {
          for (final id in four)
            id: _p(id, status: StoryStatus.completed, gate: _all),
        },
      );
      expect(m.focus, isNull);
      expect(m.firstComingSoon!.number, 5);
      expect(m.completedCount, 4);
    });

    test('sezon paketi yoksa yalnızca sunucudaki paketler', () {
      final m = buildSeasonMap(
        season: 1,
        packages: pkgs(['A1-002', 'A1-001']),
        progress: const {},
      );
      expect([for (final e in m.episodes) e.number], [1, 2]);
      expect(m.title, 'Sezon 1');
      expect(m.episodes[0].x, kDefaultMapPositions[0].$1);
    });
  });
}
