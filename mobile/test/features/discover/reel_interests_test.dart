// H-094: "İlgi alanların" paneli (plan §4.3, §5).
//
// - Sinema / Spor / Kitap açılıp kapanır; en az biri açık kalır (son açık
//   konu kapatılmak istenirse sakin bir not çıkar, tercih değişmez).
// - Tercih cihazda (`discover.prefs.categories`) saklanır; yeniden açılışta
//   korunur.
// - Değişince bugünün seçkisi seviye değişimindeki aynı yolla yeniden
//   hazırlanır (`prefsSnapshot` uyuşmaz → yeni seçim). Kapalı konu
//   "Bugün"e girmez ama çipi görünür kalır ve havuzu açılır. Günlük izleme
//   sayacı ve öğrenme kayıtları silinmez.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/discover/application/discover_providers.dart';
import 'package:hivelzon/features/discover/data/discover_store.dart';
import 'package:hivelzon/features/discover/domain/discover_prefs.dart';
import 'package:hivelzon/features/discover/domain/feed.dart';
import 'package:hivelzon/features/discover/presentation/widgets/interests_section.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/storage/app_database.dart';

import '../../support/discover_harness.dart';

Finder _key(String k) => find.byKey(ValueKey(k));

Future<void> _tap(WidgetTester tester, DiscoverHarness h, String key) async {
  await tester.ensureVisible(_key(key));
  await h.settle(tester, rounds: 4);
  await tester.tap(_key(key));
  await h.settle(tester, rounds: 12);
}

List<String> _ids(DiscoverHarness h, WidgetTester tester) => [
  for (final e in h.feedState(tester).feed.whereType<VideoEntry>()) e.video.id,
];

bool _toggled(WidgetTester tester, String code) => tester
    .widget<Switch>(
      find.descendant(
        of: _key('interest-$code'),
        matching: find.byType(Switch),
      ),
    )
    .value;

Future<DiscoverHarness> _pump(WidgetTester tester) async {
  final h = DiscoverHarness(
    chip: DiscoverChip.today,
    withReels: true,
    suggestedLevel: 'A1',
  );
  addTearDown(h.dispose);
  await h.pump(tester);
  return h;
}

Future<void> _closePanel(WidgetTester tester, DiscoverHarness h) async {
  // Modal panelin dışına dokunmak paneli kapatır.
  await tester.tapAt(const Offset(10, 10));
  await h.settle(tester, rounds: 12);
}

void main() {
  testWidgets('panel seviye panelinin içinde; üç konu da açık başlar', (
    tester,
  ) async {
    final h = await _pump(tester);
    await _tap(tester, h, 'level-chip');
    expect(_key('interests-section'), findsOneWidget);
    for (final c in ['CIN', 'SPO', 'BOK']) {
      expect(_key('interest-$c'), findsOneWidget);
      expect(_toggled(tester, c), isTrue);
    }
    await h.unmount(tester);
  });

  testWidgets('konu kapatılır ve cihazda saklanır', (tester) async {
    final h = await _pump(tester);
    await _tap(tester, h, 'level-chip');
    await _tap(tester, h, 'interest-BOK');
    expect(_toggled(tester, 'BOK'), isFalse);
    expect(find.text(DiscoverTexts.interestOff), findsOneWidget);
    final prefs = await tester.runAsync(() => DiscoverStore(h.db).prefs());
    expect(prefs!.normalizedCategories(), ['CIN', 'SPO']);

    // Yeniden açılır.
    await _tap(tester, h, 'interest-BOK');
    expect(_toggled(tester, 'BOK'), isTrue);
    final again = await tester.runAsync(() => DiscoverStore(h.db).prefs());
    expect(again!.normalizedCategories(), ['CIN', 'SPO', 'BOK']);
    await h.unmount(tester);
  });

  testWidgets('son açık konu kapanmaz; sakin not gösterilir', (tester) async {
    final h = await _pump(tester);
    await _tap(tester, h, 'level-chip');
    await _tap(tester, h, 'interest-BOK');
    await _tap(tester, h, 'interest-SPO');
    expect(_key('interests-keep-one'), findsNothing);

    await _tap(tester, h, 'interest-CIN');
    expect(_toggled(tester, 'CIN'), isTrue);
    expect(_key('interests-keep-one'), findsOneWidget);
    expect(find.text(DiscoverTexts.interestsKeepOne), findsOneWidget);
    final prefs = await tester.runAsync(() => DiscoverStore(h.db).prefs());
    expect(prefs!.normalizedCategories(), ['CIN']);

    // Başka bir konu açılınca not kalkar.
    await _tap(tester, h, 'interest-SPO');
    expect(_key('interests-keep-one'), findsNothing);
    await h.unmount(tester);
  });

  testWidgets('tercih yeniden açılışta korunur', (tester) async {
    final h = await _pump(tester);
    await _tap(tester, h, 'level-chip');
    await _tap(tester, h, 'interest-SPO');
    await h.unmount(tester);

    await h.pump(tester);
    await _tap(tester, h, 'level-chip');
    expect(_toggled(tester, 'SPO'), isFalse);
    expect(_toggled(tester, 'CIN'), isTrue);
    expect(_toggled(tester, 'BOK'), isTrue);
    await _closePanel(tester, h);
    expect(_ids(h, tester).any((id) => id.contains('-SPO-')), isFalse);
    await h.unmount(tester);
  });

  testWidgets('kapalı konu Bugün\'e girmez; seçki yeniden hazırlanır, sayaç '
      've kayıtlar silinmez, konunun çipi açık kalır', (tester) async {
    final h = await _pump(tester);
    expect(_ids(h, tester), ['A1-R-CIN-01', 'A1-R-SPO-01', 'A1-R-BOK-01']);
    await h.watched(tester, 90);
    final store = DiscoverStore(h.db);
    await tester.runAsync(
      () => store.mergeProgress(
        'A1-R-BOK-01',
        contentVersion: 1,
        addSeconds: 12,
        completed: true,
        shownDay: '2026-10-14',
      ),
    );

    await _tap(tester, h, 'level-chip');
    await _tap(tester, h, 'interest-BOK');
    await _closePanel(tester, h);

    final ids = _ids(h, tester);
    expect(ids, hasLength(3));
    expect(ids.any((id) => id.contains('-BOK-')), isFalse);
    expect(ids.every((id) => id.startsWith('A1-')), isTrue);
    final set = await tester.runAsync(() => store.dailySet(h.clock));
    expect(set!.categories, ['CIN', 'SPO']);
    expect(set.items.map((i) => i.id), ids);

    // Sayaç ve öğrenme kaydı yerinde.
    expect(await tester.runAsync(() => store.watchedSeconds(h.clock)), 90);
    final progress = await tester.runAsync(
      () => store.reelProgress('A1-R-BOK-01'),
    );
    expect(progress!.completed, isTrue);
    expect(progress.watchedSeconds, 12);

    // Kitap çipi görünür; havuzu açılır (gezinme seçeneği).
    expect(_key('chip-book'), findsOneWidget);
    await _tap(tester, h, 'chip-book');
    expect(_ids(h, tester), ['A1-R-BOK-01', 'A1-R-BOK-02', 'A1-R-BOK-03']);
    await h.unmount(tester);
  });

  testWidgets('aynı tercihle yeniden açılış seçkiyi değiştirmez', (
    tester,
  ) async {
    final h = await _pump(tester);
    await _tap(tester, h, 'level-chip');
    await _tap(tester, h, 'interest-CIN');
    await _closePanel(tester, h);
    final first = _ids(h, tester);
    await h.unmount(tester);
    await h.pump(tester);
    expect(_ids(h, tester), first);
    await h.unmount(tester);
  });

  group('bölümün kendi durumları', () {
    Future<void> pumpSection(WidgetTester tester, DiscoverStore store) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [discoverStoreProvider.overrideWithValue(store)],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(
              body: SingleChildScrollView(child: DiscoverInterestsSection()),
            ),
          ),
        ),
      );
    }

    testWidgets('okunamazsa sakin hata + Tekrar dene', (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final store = _FailingStore(db);
      await pumpSection(tester, store);
      for (var i = 0; i < 10; i++) {
        await tester.runAsync(() => Future<void>.delayed(Duration.zero));
        await tester.pump();
      }
      expect(_key('interests-error'), findsOneWidget);
      expect(find.text(DiscoverTexts.interestsError), findsOneWidget);

      store.fail = false;
      await tester.tap(_key('interests-retry'));
      for (var i = 0; i < 10; i++) {
        await tester.runAsync(() => Future<void>.delayed(Duration.zero));
        await tester.pump();
      }
      expect(_key('interests-error'), findsNothing);
      expect(_key('interest-CIN'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('okunurken yükleniyor gösterilir', (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await pumpSection(tester, DiscoverStore(db));
      expect(_key('interests-loading'), findsOneWidget);
      for (var i = 0; i < 10; i++) {
        await tester.runAsync(() => Future<void>.delayed(Duration.zero));
        await tester.pump();
      }
      expect(_key('interests-loading'), findsNothing);
      await tester.pumpWidget(const SizedBox());
    });
  });
}

class _FailingStore extends DiscoverStore {
  _FailingStore(super.db);

  bool fail = true;

  @override
  Future<DiscoverPrefs> prefs() async {
    if (fail) throw StateError('okunamadı');
    return super.prefs();
  }
}
