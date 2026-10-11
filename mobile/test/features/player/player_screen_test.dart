import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/player/domain/episode_engine.dart';
import 'package:hivelzon/features/player/presentation/player_screen.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../support/fake_content_source.dart';
import '../../support/fake_video_platform.dart';

void main() {
  late FakeVideoPlatform platform;
  late InMemoryProgressRepository repo;
  late FakeContentSource source;

  setUp(() {
    platform = FakeVideoPlatform(
      // Segment süreleri kısaltılır: test zamanı ilerletmeyi kolaylaştırır.
      durationFor: (uri) => uri.endsWith('.m4a')
          ? const Duration(milliseconds: 500)
          : const Duration(seconds: 1),
    );
    VideoPlayerPlatform.instance = platform;
    repo = InMemoryProgressRepository();
    source = FakeContentSource();
  });

  Future<void> pumpPlayer(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          contentSourceProvider.overrideWithValue(source),
          progressRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: PlayerScreen(contentId: 'A1-001'),
          ),
        ),
      ),
    );
  }

  /// Gerçek zamanlı olmayan beklemeler: video bitişleri ve kart zamanlayıcıları.
  Future<void> step(WidgetTester tester, [int ms = 1200]) async {
    for (var i = 0; i < ms ~/ 100; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> tapKey(WidgetTester tester, String key) async {
    final f = find.byKey(ValueKey(key));
    await tester.ensureVisible(f);
    await tester.tap(f);
    await step(tester, 300);
  }

  testWidgets('B1 baştan sona: karar, ipucu, tepki, görevler, bitiş', (
    tester,
  ) async {
    await pumpPlayer(tester);
    await step(tester, 1500); // s01 oynar ve biter
    await step(tester, 2800); // başlık kartı kendiliğinden geçer
    expect(find.text('Mesajdaki kişiyi ve yeri bul.'), findsOneWidget);
    expect(repo.checkpoints['A1-001']!.checkpointNodeId, 's01');
    await tapKey(tester, 'card-continue');
    await step(tester, 1500); // s02

    // Karar anı (T3).
    expect(find.text('Ne dersin?'), findsOneWidget);
    expect(find.text('Alex ne desin?'), findsOneWidget);
    expect(find.text('Hello? Hello? Can you hear me?'), findsOneWidget);
    expect(repo.checkpoints['A1-001']!.checkpointNodeId, 's02');

    // Hi ipucu (T4): 1 → 2, sonra tekrar dene.
    await tester.tap(find.text('Hi\'den ipucu al'));
    await step(tester, 300);
    expect(find.text('İpucu 1 / 3'), findsOneWidget);
    await tapKey(tester, 'hint-more');
    expect(find.text('İpucu 2 / 3'), findsOneWidget);
    expect(find.text('Can you…? → Yes, I can.'), findsOneWidget);
    await tapKey(tester, 'hint-retry');
    expect(find.text('Ne dersin?'), findsOneWidget);

    // Yanlış → tepki videosu → Hi balonu → aynı karar.
    await tapKey(tester, 'option-b');
    await step(tester, 1500);
    expect(find.byKey(const ValueKey('reaction-retry')), findsOneWidget);
    await tapKey(tester, 'reaction-retry');
    expect(find.text('Ne dersin?'), findsOneWidget);
    expect(find.text('Yes, I am.'), findsOneWidget);

    // Doğru → k1-ok → s03 → Hi kartı.
    await tapKey(tester, 'option-a');
    await step(tester, 1500);
    await step(tester, 1500);
    expect(
      find.textContaining('Tekrar dinlemek için İngilizce iste'),
      findsOneWidget,
    );
    await tapKey(tester, 'card-continue');
    await tapKey(tester, 'option-a'); // k2 doğru
    await step(tester, 1500); // k2-ok
    await step(tester, 1500); // s04

    // Anlama görevi: önce yanlış (nazik geri bildirim), sonra doğru; 2 öğe.
    expect(find.text('Mesajı dinle. Kişiyi ve yeri seç.'), findsOneWidget);
    await tapKey(tester, 'task-option-b');
    expect(find.text('Bir daha bakalım.'), findsOneWidget);
    await tapKey(tester, 'task-option-a');
    expect(find.text('2 / 2'), findsOneWidget);
    await tapKey(tester, 'task-option-a');
    expect(find.text('Meet me at the old station.'), findsOneWidget);
    await tapKey(tester, 'task-continue');
    await step(tester, 1500); // s05

    // Sıralama görevi: Where is the old station ?
    expect(find.text('Kelimeleri sırala: Alex ne soruyor?'), findsOneWidget);
    for (final i in [2, 0, 1, 5, 3, 4]) {
      await tapKey(tester, 'task-token-$i');
    }
    await tapKey(tester, 'task-check');
    await tapKey(tester, 'task-continue');
    await tapKey(tester, 'card-continue'); // h-04
    await step(tester, 1500); // s06
    expect(find.text('İpucu panosu'), findsOneWidget);
    await tapKey(tester, 'card-continue');
    expect(find.text('Bölümü bitir'), findsOneWidget);
    await tapKey(tester, 'card-continue');
    await step(tester, 500);

    expect(find.text('Görev tamam!'), findsOneWidget);
    expect(find.text('Old Station nerede?'), findsOneWidget);
    expect(find.textContaining('C2 · Not'), findsOneWidget);
    expect(repo.checkpoints, isEmpty, reason: 'bitince kayıt silinir');
    expect(repo.episodeFlags['A1-001'], isEmpty);
    await tester.pumpWidget(const SizedBox());
    await step(tester, 300);
  });

  testWidgets('kayıt varsa "Kaldığın yerden devam" sorulur', (tester) async {
    repo.checkpoints['A1-001'] = const EngineSnapshot(
      checkpointNodeId: 's05',
      flags: {},
      passedNodes: {'k1', 'k2', 't-gorev'},
      contentVersion: 1,
    );
    await pumpPlayer(tester);
    await step(tester, 300);
    expect(find.text('Kaldığın yerden devam'), findsOneWidget);
    expect(find.text('Baştan başla'), findsOneWidget);
    await tapKey(tester, 'resume-continue');
    await step(tester, 1500); // s05 oynar
    expect(find.text('Kelimeleri sırala: Alex ne soruyor?'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await step(tester, 300);
  });

  testWidgets('sunucu kapalıysa hata ve tekrar dene', (tester) async {
    source.fail = true;
    await pumpPlayer(tester);
    await step(tester, 300);
    expect(find.text('İçerik sunucusuna ulaşılamadı.'), findsOneWidget);
    source.fail = false;
    await tester.tap(find.text('Tekrar dene'));
    await step(tester, 1500);
    expect(find.text('İçerik sunucusuna ulaşılamadı.'), findsNothing);
    await tester.pumpWidget(const SizedBox());
    await step(tester, 300);
  });

  testWidgets('kapatınca onay sorulur ve kontrol noktası kaydedilir', (
    tester,
  ) async {
    await pumpPlayer(tester);
    await step(tester, 300);
    await tester.tap(find.byTooltip('Bölümden çık'));
    await step(tester, 300);
    expect(find.text('Bölümden çıkılsın mı?'), findsOneWidget);
    await tester.tap(find.text('Kal'));
    await step(tester, 300);
    expect(find.text('Bölümden çıkılsın mı?'), findsNothing);
    expect(repo.checkpoints['A1-001']!.checkpointNodeId, 's01');
    await tester.pumpWidget(const SizedBox());
    await step(tester, 300);
  });
}
