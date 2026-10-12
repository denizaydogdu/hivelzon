import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/player/application/segment_player_pool.dart';
import 'package:video_player/video_player.dart';

class _FakeController extends VideoPlayerController {
  _FakeController(super.uri, {this.fail = false}) : super.networkUrl();

  final bool fail;
  bool disposed = false;

  @override
  Future<void> initialize() async {
    if (fail) throw StateError('ağ yok');
  }

  // initialize() ezildiği için super.dispose platforma gitmez.
  @override
  Future<void> dispose() async {
    disposed = true;
    await super.dispose();
  }
}

void main() {
  late List<_FakeController> created;
  late Set<String> failing;
  late SegmentPlayerPool pool;

  setUp(() {
    created = [];
    failing = {};
    pool = SegmentPlayerPool(
      uriFor: (p) => Uri.parse('http://t/$p'),
      factory: (uri) {
        final c = _FakeController(uri, fail: failing.contains(uri.path));
        created.add(c);
        return c;
      },
    );
  });

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 700));

  test('aynı yol aynı denetleyiciyi döndürür', () async {
    final a = await pool.acquire('a.mp4');
    final b = await pool.acquire('a.mp4');
    expect(identical(a, b), isTrue);
    expect(created, hasLength(1));
    expect(pool.isReady('a.mp4'), isTrue);
  });

  test(
    'en fazla 3 denetleyici; korunanlar atılmaz, en eski korunmayan atılır',
    () async {
      await pool.acquire('a.mp4');
      await pool.acquire('b.mp4');
      pool.preload(['c.mp4', 'd.mp4'], protect: {'a.mp4'});
      await settle();
      expect(pool.liveCount, 3);
      expect(pool.paths, containsAll(['a.mp4', 'c.mp4', 'd.mp4']));
      expect(created[1].disposed, isTrue, reason: 'b korunmuyordu');
      expect(created[0].disposed, isFalse);
    },
  );

  test('her yer korunuyorsa ön ısıtma yapılmaz', () async {
    await pool.acquire('a.mp4');
    await pool.acquire('b.mp4');
    await pool.acquire('c.mp4');
    pool.preload(['d.mp4'], protect: {'a.mp4', 'b.mp4', 'c.mp4'});
    expect(pool.paths, isNot(contains('d.mp4')));
    expect(pool.liveCount, 3);
  });

  test('başlatılamayan video havuzdan çıkar, yeniden denenebilir', () async {
    failing.add('/x.mp4');
    await expectLater(pool.acquire('x.mp4'), throwsStateError);
    expect(pool.paths, isNot(contains('x.mp4')));
    failing.clear();
    await pool.acquire('x.mp4');
    expect(pool.isReady('x.mp4'), isTrue);
  });

  test('kapatınca hepsi atılır', () async {
    await pool.acquire('a.mp4');
    await pool.acquire('b.mp4');
    await pool.dispose();
    expect(created.every((c) => c.disposed), isTrue);
    expect(pool.liveCount, 0);
  });
}
