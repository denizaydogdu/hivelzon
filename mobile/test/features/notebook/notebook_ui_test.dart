import 'dart:math' as math;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/router.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/home/presentation/home_screen.dart';
import 'package:hivelzon/features/notebook/presentation/notebook_screen.dart';
import 'package:hivelzon/features/notebook/presentation/review_screen.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/profile/data/user_profile_store.dart';
import 'package:hivelzon/shared/content/content_providers.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:hivelzon/shared/ui/ui.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../support/fake_content_source.dart';
import '../../support/fake_video_platform.dart';

void main() {
  late AppDatabase db;
  late InMemoryProgressRepository progress;
  late FakeVideoPlatform platform;
  late InMemoryLearningEventLog events;

  setUp(() {
    db = AppDatabase.memory();
    progress = InMemoryProgressRepository();
    events = InMemoryLearningEventLog();
    platform = FakeVideoPlatform(
      durationFor: (_) => const Duration(seconds: 30),
    );
    VideoPlayerPlatform.instance = platform;
  });
  tearDown(() => db.close());

  Future<void> pump(
    WidgetTester tester,
    String initial, {
    double height = 2556,
  }) async {
    tester.view.physicalSize = Size(1179, height);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: initial,
      routes: [
        GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
        GoRoute(path: '/defter', builder: (_, _) => const NotebookScreen()),
        GoRoute(
          path: AppRoutes.review,
          builder: (_, _) => const ReviewScreen(),
        ),
        GoRoute(
          path: '/hikaye',
          builder: (_, _) => const Scaffold(body: Text('harita')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          legacyImportProvider.overrideWithValue(Future<void>.value()),
          contentSourceProvider.overrideWithValue(
            FakeContentSource(realSubtitles: true),
          ),
          progressRepositoryProvider.overrideWithValue(progress),
          learningEventLogProvider.overrideWithValue(events),
          reviewRandomProvider.overrideWithValue(math.Random(7)),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
  }

  /// Drift işlemleri gerçek mikro görevlerdir: birkaç kare boyunca bekle.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 20; i++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> tapKey(WidgetTester tester, String key) async {
    final f = find.byKey(ValueKey(key));
    await tester.ensureVisible(f);
    // Kaydırma bir sonraki karede uygulanır (H-088: tekrar satırı ekranın
    // altında olabilir).
    await tester.pump();
    await tester.tap(f);
    await settle(tester);
  }

  testWidgets(
    'Defter: B1 ifadeleri bölüm etiketiyle; arama; kart; ipucu panosu',
    (tester) async {
      await progress.markCompleted('A1-001', gate: const {});
      // Uzun ekran: listenin hepsi bir kerede çizilsin.
      await pump(tester, '/defter', height: 3600);
      await settle(tester);

      expect(find.text('Defter'), findsOneWidget);
      expect(
        find.text('5 ifadenin tekrar zamanı geldi · yaklaşık 2 dk'),
        findsOneWidget,
      );
      expect(find.text('Topladığın ifadeler (5)'), findsOneWidget);
      expect(
        find.text(
          'Bölümlerde öğrendiğin ifadeler burada. Birine dokununca kartı açılır.',
        ),
        findsOneWidget,
      );
      for (final p in [
        'Can you hear me?',
        'Yes, I can.',
        'Again, please.',
        'Where is…?',
        'Listen.',
      ]) {
        expect(find.text(p), findsOneWidget);
      }
      // H-052: altyazıda geçmeyen hedef ifade anlamıyla defterde.
      expect(find.text('Dinle.'), findsOneWidget);
      expect(find.text('B1'), findsNWidgets(5));

      await tester.enterText(
        find.byKey(const ValueKey('notebook-search')),
        'lütfen',
      );
      await settle(tester);
      expect(find.text('Again, please.'), findsOneWidget);
      expect(find.text('Yes, I can.'), findsNothing);
      await tester.enterText(find.byKey(const ValueKey('notebook-search')), '');
      await settle(tester);

      // Kart: görsel + ses + örnek cümle + Türkçesi; ses segmentten çalar.
      await tester.tap(find.text('Yes, I can.'));
      await settle(tester);
      expect(find.byKey(const ValueKey('card-detail')), findsOneWidget);
      expect(find.text('Yes, I can hear you.'), findsOneWidget);
      expect(find.text('Evet, seni duyabiliyorum.'), findsOneWidget);
      await tester.tap(
        find.descendant(
          of: find.byKey(const ValueKey('card-detail')),
          matching: find.byKey(const ValueKey('audio-phrase-phrase|yes i can')),
        ),
      );
      await settle(tester);
      // "Yes, I can" k1-ok segmentinde 0,0 sn'de başlar (kelime zamanı).
      expect(
        platform.seeks.where(
          (s) => s.$1.endsWith('A1-001/segments/k1-ok.720p.mp4'),
        ),
        isNotEmpty,
      );
      await tester.tap(find.byTooltip('Kapat').last);
      await settle(tester);

      // İpucu panosu: B1 ipuçları ve açık soru (spoiler'sız).
      await tester.tap(find.text('İpucu panosu'));
      await settle(tester);
      expect(
        find.text(
          'Hikâyede bulduğun ipuçları ve henüz cevabı olmayan sorular.',
        ),
        findsOneWidget,
      );
      expect(find.text('Old Station nerede?'), findsOneWidget);
      expect(find.text('AÇIK SORU · BÖLÜM 1'), findsOneWidget);
      expect(find.text('Telsiz mesajı (ses + metin)'), findsOneWidget);
      expect(find.text('Not: E. / old station / Friday / 7'), findsOneWidget);
      expect(find.textContaining('Kapıdaki'), findsNothing);
      await tester.pumpWidget(const SizedBox());
      await settle(tester);
    },
  );

  testWidgets('Defter boşken sakin boş durum', (tester) async {
    await pump(tester, '/defter');
    await settle(tester);
    expect(find.textContaining('Defterin henüz boş'), findsOneWidget);
    await tester.tap(find.text('İpucu panosu'));
    await settle(tester);
    expect(find.textContaining('Henüz ipucu yok'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await settle(tester);
  });

  testWidgets(
    'Tekrar: resimden seç (doğru/yanlış), Bilmiyorum → oturum sonunda yeniden',
    (tester) async {
      await progress.markCompleted('A1-001', gate: const {});
      await pump(tester, AppRoutes.review);
      await settle(tester);

      Future<void> choose(String text) async {
        final f = find.widgetWithText(OutlinedButton, text);
        await tester.ensureVisible(f);
        await tester.tap(f);
        await settle(tester);
      }

      Future<String> currentMeaning() async => (tester.widget<Text>(
        find.byKey(const ValueKey('task-meaning')),
      )).data!;

      // 1) Doğru seçim.
      expect(find.text('Kelime tekrarı · 1 / 5'), findsOneWidget);
      expect(find.byKey(const ValueKey('task-picture_choice')), findsOneWidget);
      expect(await currentMeaning(), 'Beni duyabiliyor musun?');
      expect(
        find.byType(OutlinedButton),
        findsNWidgets(5),
        reason: '4 seçenek + Bilmiyorum',
      );
      expect(find.widgetWithText(OutlinedButton, 'Bilmiyorum'), findsOneWidget);
      await choose('Can you hear me?');
      expect(find.text('Doğru!'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('card-face-phrase|can you hear me')),
        findsOneWidget,
      );
      expect(
        platform.seeks.where(
          (s) =>
              s.$1.endsWith('segments/s02.720p.mp4') &&
              s.$2 == const Duration(microseconds: 11027000),
        ),
        isNotEmpty,
        reason: 'kart sesi karakterin sesinden (s02, 11,027 sn)',
      );
      await tapKey(tester, 'review-continue');

      // 2) Yanlış seçim → kart oturum sonuna.
      expect(await currentMeaning(), 'Evet, (yapabiliyorum).');
      await choose('Again, please.');
      expect(find.text('Doğrusu bu.'), findsOneWidget);
      expect(find.text('Seçtiğin: Again, please.'), findsOneWidget);
      expect(
        find.text('Bu ifade oturumun sonunda yeniden gelecek.'),
        findsOneWidget,
      );
      await tapKey(tester, 'review-continue');
      expect(find.text('Kelime tekrarı · 3 / 6'), findsOneWidget);

      // 3) Bilmiyorum → nazik dil, kart oturum sonuna.
      await tapKey(tester, 'task-dont-know');
      expect(find.text('Sorun değil, birlikte bakalım.'), findsOneWidget);
      expect(find.textContaining('yanlış'), findsNothing);
      await tapKey(tester, 'review-continue');

      // 4) Doğru.
      await choose('Where is…?');
      await tapKey(tester, 'review-continue');

      // 5) Altyazıda geçmeyen hedef ifade (H-052): görsel + anlam.
      expect(find.text('Kelime tekrarı · 5 / 7'), findsOneWidget);
      expect(await currentMeaning(), 'Dinle.');
      await choose('Listen.');
      expect(find.text('Doğru!'), findsOneWidget);
      await tapKey(tester, 'review-continue');

      // 6–7) Oturum sonu: bilinemeyen iki kart yeniden.
      expect(find.text('Kelime tekrarı · 6 / 7'), findsOneWidget);
      expect(await currentMeaning(), 'Evet, (yapabiliyorum).');
      await choose('Yes, I can.');
      expect(find.text('Doğru!'), findsOneWidget);
      await tapKey(tester, 'review-continue');
      expect(await currentMeaning(), 'Bir daha, lütfen.');
      await choose('Again, please.');
      await tapKey(tester, 'review-continue');

      expect(find.text('Tekrar tamam'), findsOneWidget);
      expect(find.text('5 ifadeyi tekrar ettin.'), findsOneWidget);
      // H-061: yarın gelecekler özet istatistiğinde (`StatRow`).
      expect(
        tester
            .widget<StatTile>(find.byKey(const ValueKey('summary-tomorrow')))
            .count,
        2,
      );
      expect(find.textContaining('seri'), findsNothing);

      final logs = await tester.runAsync(() => db.select(db.reviewLogs).get());
      expect(logs!.map((l) => l.rating), [3, 1, 1, 3, 3, 3, 3]);
      expect(logs.map((l) => l.taskType).toSet(), {'picture_choice'});
      expect(logs[2].dontKnow, isTrue);
      // Yanlış cevaplar sürümlü hata türüyle olay olarak kaydedilir.
      final ev = await events.recent();
      expect(ev.map((e) => e.errorType?.code), ['recall', 'recall']);
      await tester.pumpWidget(const SizedBox());
      await settle(tester);
    },
  );

  testWidgets(
    'Tekrar: 2. tekrardaki kart "dinle-seç"; ses kendiliğinden çalar',
    (tester) async {
      await progress.markCompleted('A1-001', gate: const {});
      await pump(tester, '/defter');
      await settle(tester);
      // Bütün kartlar 2 kez tekrar edilmiş ve vadesi gelmiş olsun.
      await tester.runAsync(
        () => db
            .update(db.reviewCards)
            .write(
              ReviewCardsCompanion(
                state: const Value(2),
                step: const Value(null),
                stability: const Value(3),
                difficulty: const Value(5),
                reps: const Value(2),
                due: Value(DateTime.utc(2026, 1, 1)),
                lastReview: Value(DateTime.utc(2025, 12, 29)),
              ),
            ),
      );
      // "Listen." sesi yok (H-052): dinle-seç olamaz; bu testte sıraya girmesin.
      await tester.runAsync(() async {
        final listen = await (db.select(
          db.notebookItems,
        )..where((t) => t.textEn.equals('Listen.'))).getSingle();
        await (db.update(db.reviewCards)
              ..where((t) => t.itemId.equals(listen.id)))
            .write(ReviewCardsCompanion(due: Value(DateTime.utc(2099))));
      });
      await tester.pumpWidget(const SizedBox());
      await settle(tester);
      await pump(tester, AppRoutes.review);
      await settle(tester);
      expect(find.byKey(const ValueKey('task-listen_choice')), findsOneWidget);
      expect(find.byKey(const ValueKey('task-meaning')), findsNothing);
      expect(platform.seeks, isNotEmpty, reason: 'görev açılınca ses çalar');
      await tapKey(tester, 'task-listen');
      final playing = platform.seeks.last.$1;
      final phrase = {
        's02.720p.mp4': 'Can you hear me?',
        'k1-ok.720p.mp4': 'Yes, I can.',
        'k2-ok.720p.mp4': 'Again, please.',
        's05.720p.mp4': 'Where is…?',
      }.entries.firstWhere((e) => playing.endsWith(e.key)).value;
      final f = find.widgetWithText(OutlinedButton, phrase);
      await tester.ensureVisible(f);
      await tester.tap(f);
      await settle(tester);
      expect(find.text('Doğru!'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await settle(tester);
    },
  );

  testWidgets('Ana Sayfa: "Kelime tekrarı" sayısı cümle içinde (H-053)', (
    tester,
  ) async {
    await pump(tester, '/');
    await settle(tester);
    expect(find.text('Merhaba!'), findsOneWidget);
    expect(find.text('Bugünün planı'), findsOneWidget);
    expect(find.text('Kelime tekrarı'), findsOneWidget);
    // Defter boş: sakin durum cümlesi; satır yine tek dokunuşla açılır
    // (H-088).
    expect(
      find.text(
        'Bir bölümü bitirince ifadeler defterine eklenir; tekrar zamanları '
        'burada görünür.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('home-review-start')), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await settle(tester);

    await progress.markCompleted('A1-001', gate: const {});
    await pump(tester, '/');
    await settle(tester);
    expect(
      find.text('5 ifadenin tekrar zamanı geldi · yaklaşık 2 dk'),
      findsOneWidget,
    );
    await tapKey(tester, 'home-review-start');
    expect(find.byKey(const ValueKey('task-picture_choice')), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await settle(tester);
  });

  testWidgets('Ana Sayfa: tekrar zamanı gelmemişse sakin cümle', (
    tester,
  ) async {
    await progress.markCompleted('A1-001', gate: const {});
    await pump(tester, '/');
    await settle(tester);
    // Bütün kartlar yarına ertelenmiş gibi.
    await tester.runAsync(
      () => db
          .update(db.reviewCards)
          .write(
            ReviewCardsCompanion(
              state: const Value(2),
              step: const Value(null),
              stability: const Value(3),
              difficulty: const Value(5),
              reps: const Value(2),
              due: Value(DateTime.now().toUtc().add(const Duration(days: 1))),
              lastReview: Value(DateTime.now().toUtc()),
            ),
          ),
    );
    await tester.pumpWidget(const SizedBox());
    await settle(tester);
    await pump(tester, '/');
    await settle(tester);
    expect(
      find.text(
        'Şu an tekrar edilecek ifade yok. Yeni ifadeler bölüm bitince '
        'defterine eklenir.',
      ),
      findsOneWidget,
    );
    // H-088: Kelime tekrarı satırı her zaman tek dokunuşla açılır.
    expect(find.byKey(const ValueKey('home-review-start')), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await settle(tester);
  });

  testWidgets('Ana Sayfa: Profil\'de kaydedilen adla selam', (tester) async {
    await tester.runAsync(
      () => UserProfileStore(db).setDisplayName('  Deniz '),
    );
    await pump(tester, '/');
    await settle(tester);
    expect(find.text('Merhaba Deniz!'), findsOneWidget);
    expect(find.text('Bugün için önerimiz:'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await settle(tester);
  });
}
