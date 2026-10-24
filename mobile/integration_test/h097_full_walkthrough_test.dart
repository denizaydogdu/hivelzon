// H-097: bütün sayfaların simülatörde sırayla gezinme provası.
//
// Gerçek yerel içerik sunucusu (127.0.0.1:8787) ve gerçek reel kataloğu
// (backend 127.0.0.1:8080) kullanılır. Veritabanı **bellekte** açılır; cihazdaki
// kullanıcı verisine dokunulmaz. Açılış kapısı bitmiş sayılır; ilerleme, defter
// ve sezon durumu gezinme için önceden doldurulur.
//
//   python3 tools/dev-content-server/serve.py --port 8787 ...
//   cd mobile && SHOT_DIR=../.yerel/h097 flutter drive \
//     --driver=test_driver/integration_test.dart \
//     --target=integration_test/h097_full_walkthrough_test.dart \
//     -d EEE1613C-61A1-4B5F-8D5B-BED2170FC340 \
//     --dart-define=SHOT_PREFIX=h097
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hivelzon/app/app.dart';
import 'package:hivelzon/app/router.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/onboarding/application/onboarding_providers.dart';
import 'package:hivelzon/features/onboarding/data/onboarding_store.dart';
import 'package:hivelzon/features/player/data/progress_repository.dart';
import 'package:hivelzon/features/profile/data/user_profile_store.dart';
import 'package:hivelzon/shared/progress/story_progress.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:integration_test/integration_test.dart';

const prefix = String.fromEnvironment('SHOT_PREFIX', defaultValue: 'h097');

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('H-097 bütün sayfalar', (t) async {
    final errors = <String>[];
    late ProviderContainer container;

    Future<void> wait(Duration d) async {
      final end = DateTime.now().add(d);
      while (DateTime.now().isBefore(end)) {
        await t.pump(const Duration(milliseconds: 100));
      }
    }

    Future<void> waitFor(
      Finder f, {
      Duration timeout = const Duration(seconds: 40),
      bool required = true,
    }) async {
      final end = DateTime.now().add(timeout);
      while (DateTime.now().isBefore(end)) {
        await t.pump(const Duration(milliseconds: 200));
        if (f.evaluate().isNotEmpty) return;
      }
      if (required) {
        final e = t.takeException();
        if (e != null) debugPrint('[H097] waitFor istisnası: $e');
        throw TestFailure('Bulunamadı: $f');
      }
    }

    void check(String where) {
      final e = t.takeException();
      if (e != null) {
        errors.add('$where: $e');
        debugPrint('[H097] HATA $where: $e');
      }
    }

    Future<void> shot(String name) async {
      await wait(const Duration(milliseconds: 800));
      check('görüntü öncesi $name');
      await binding.takeScreenshot('$prefix-$name');
      debugPrint('[H097] görüntü: $prefix-$name');
    }

    GoRouter router() => container.read(routerProvider);

    Future<void> go(String path, Finder ready, {String? name}) async {
      router().go(path);
      await waitFor(ready);
      await wait(const Duration(milliseconds: 900));
      if (name != null) await shot(name);
      check('sayfa $path');
    }

    Future<void> tap(Finder f) async {
      await t.ensureVisible(f.first);
      await wait(const Duration(milliseconds: 300));
      await t.tap(f.first);
      await wait(const Duration(milliseconds: 700));
    }

    Future<void> tapKey(String key) => tap(find.byKey(ValueKey(key)));

    /// Kaydırılmış listelerde üst/alt kenara kırpılan satırları önce
    /// ortaya getirir, sonra normal dokunuşla açar.
    Future<void> tapVisible(Finder f) async {
      await t.ensureVisible(f.first);
      await wait(const Duration(milliseconds: 300));
      var rect = t.getRect(f.first);
      final size = t.view.physicalSize / t.view.devicePixelRatio;
      final scrollable = find
          .ancestor(of: f.first, matching: find.byType(Scrollable))
          .first;
      if (rect.top < 110) {
        await t.drag(scrollable, const Offset(0, 180));
        await wait(const Duration(milliseconds: 500));
        rect = t.getRect(f.first);
      } else if (rect.bottom > size.height - 130) {
        await t.drag(scrollable, const Offset(0, -180));
        await wait(const Duration(milliseconds: 500));
        rect = t.getRect(f.first);
      }
      await t.tap(f.first);
      await wait(const Duration(milliseconds: 700));
    }

    Future<void> dismissSheet(String key) async {
      final f = find.byKey(ValueKey(key));
      if (f.evaluate().isEmpty) return;
      Navigator.of(t.element(f)).pop();
      await wait(const Duration(milliseconds: 600));
    }

    Future<void> scrollBy(Finder scrollable, double dy) async {
      if (scrollable.evaluate().isEmpty) return;
      await t.drag(scrollable.first, Offset(0, dy));
      await wait(const Duration(milliseconds: 600));
    }

    // ------------------------------------------------------------ veri
    final db = AppDatabase.memory();
    final progress = InMemoryProgressRepository();
    final now = DateTime.now().toUtc();

    Future<void> meta(String key, String value) => db
        .into(db.appMeta)
        .insertOnConflictUpdate(
          AppMetaCompanion.insert(key: key, value: value),
        );

    await meta(OnboardingStore.completedKey, now.toIso8601String());
    await meta(OnboardingStore.suggestedLevelKey, 'A1');
    await meta(UserProfileStore.displayNameKey, 'Deniz');
    await meta(NotebookStore.dailyGoalKey, '10');
    await db
        .into(db.seasonState)
        .insertOnConflictUpdate(
          SeasonStateCompanion.insert(
            seasonId: const Value(1),
            introSeen: const Value(true),
            introSeenAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    for (final id in ['A1-001', 'A1-002', 'A1-003']) {
      await progress.markCompleted(
        id,
        gate: {
          GateItem.comprehension: {'walkthrough'},
          GateItem.targetPhrase: {'walkthrough'},
          GateItem.activeTask: {'walkthrough'},
        },
      );
    }
    await NotebookStore(db).addItems(const [
      NotebookItem(
        kind: NotebookKind.phrase,
        textEn: 'Where is the station?',
        textTr: 'İstasyon nerede?',
        exampleEn: 'Excuse me, where is the station?',
        exampleTr: 'Affedersiniz, istasyon nerede?',
        source: NotebookSource.autoTargetPhrase,
        contentId: 'A1-003',
        cueId: 'b3_08_alex',
      ),
    ]);

    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        progressRepositoryProvider.overrideWithValue(progress),
        legacyImportProvider.overrideWith((ref) async {}),
        onboardingGateProvider.overrideWith(_DoneOnboardingGate.new),
      ],
    );
    addTearDown(() async {
      // Okuyucu/ses çalar zamanlayıcıları kapsayıcı kapanmadan önce dursun.
      await t.pumpWidget(const SizedBox.shrink());
      await t.pump(const Duration(seconds: 1));
      container.dispose();
      await db.close();
    });

    await t.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const HiVelzonApp(),
      ),
    );
    await waitFor(
      find.byType(NavigationBar),
      timeout: const Duration(seconds: 60),
    );
    await wait(const Duration(seconds: 3));

    final nav = find.byType(NavigationBar);

    // ------------------------------------------------------------ 1. Ana Sayfa
    await shot('01-ana-sayfa');
    await tapKey('hi-bubble');
    await waitFor(find.byKey(const ValueKey('hi-panel')));
    await shot('02-hi-paneli');
    await dismissSheet('hi-panel');
    await scrollBy(find.byType(Scrollable).first, -500);
    await shot('03-ana-sayfa-alt');

    // ------------------------------------------------------------ 2. Keşfet
    await go(
      AppRoutes.discover,
      find.byKey(const ValueKey('discover-title')),
      name: '04-kesfet-bugun',
    );
    await waitFor(
      find.byKey(const ValueKey('discover-pages')),
      timeout: const Duration(seconds: 60),
      required: false,
    );
    await wait(const Duration(seconds: 3));
    await shot('05-kesfet-reel');
    for (final (key, name) in [
      ('chip-storyClips', '06-kesfet-hikaye-klipleri'),
      ('chip-cinema', '07-kesfet-sinema'),
      ('chip-sport', '08-kesfet-spor'),
      ('chip-book', '09-kesfet-kitap'),
    ]) {
      final chip = find.byKey(ValueKey(key));
      if (chip.evaluate().isEmpty) continue;
      await tap(chip);
      await wait(const Duration(seconds: 2));
      await shot(name);
    }
    await tapKey('chip-today');
    await wait(const Duration(seconds: 2));

    // ------------------------------------------------------------ 3. Hikâye
    await go(
      AppRoutes.story,
      find.byKey(const ValueKey('season-map')),
      name: '10-hikaye-haritasi',
    );
    await scrollBy(find.byType(Scrollable).first, -450);
    await shot('11-hikaye-odak-karti');
    await tapKey('map-node-4');
    await waitFor(find.byKey(const ValueKey('episode-sheet')));
    await shot('12-bolum-paneli');
    await dismissSheet('episode-sheet');

    await tapKey('season-intro-play-1');
    await waitFor(find.byKey(const ValueKey('season-intro')));
    await wait(const Duration(seconds: 2));
    await shot('13-sezon-jenerigi');
    router().go(AppRoutes.story);
    await waitFor(find.byKey(const ValueKey('season-map')));
    await wait(const Duration(milliseconds: 600));

    // Oynatıcı (A1-004): gerçek video; birkaç saniye yüklenmesini bekle.
    router().go(AppRoutes.play('A1-004'));
    await waitFor(
      find.byKey(const ValueKey('player-dim')),
      timeout: const Duration(seconds: 60),
    );
    await wait(const Duration(seconds: 3));
    await shot('14-oynatici');
    router().go(AppRoutes.story);
    await waitFor(find.byKey(const ValueKey('season-map')));
    await wait(const Duration(milliseconds: 600));

    // Kitaplık
    await tap(
      find.descendant(
        of: find.byKey(const ValueKey('story-sections')),
        matching: find.text('Kitaplık'),
      ),
    );
    await waitFor(find.byKey(const ValueKey('library-view')));
    await shot('15-kitaplik');
    await tapKey('book-card-A1-K01');
    await waitFor(
      find.byKey(const ValueKey('book-open-sheet')),
      timeout: const Duration(seconds: 15),
      required: false,
    );
    if (find.byKey(const ValueKey('book-open-sheet')).evaluate().isNotEmpty) {
      await shot('15b-kitap-acma-paneli');
      await tapKey('book-sheet-open');
    }
    await waitFor(find.byKey(const ValueKey('reader-pages')));
    await wait(const Duration(seconds: 2));
    await shot('16-okuyucu');
    await tapKey('reader-page-turkish');
    await waitFor(find.byKey(const ValueKey('page-turkish')));
    await shot('17-sayfa-turkcesi');
    await dismissSheet('page-turkish');
    await tapKey('reader-settings-button');
    await waitFor(find.byKey(const ValueKey('reader-settings')));
    await shot('18-okuyucu-ayarlari');
    await dismissSheet('reader-settings');
    await tapKey('reader-chapters-button');
    await waitFor(find.byKey(const ValueKey('reader-chapters')));
    await shot('19-okuyucu-bolumleri');
    await dismissSheet('reader-chapters');
    await shot('20-okuyucu-bolumler-sonrasi');
    // Sesli modda sayfa düğmesi yerine oynatma denetimleri vardır; sessiz
    // moda geçip sayfayı çevir.
    if (find.byKey(const ValueKey('reader-next')).evaluate().isEmpty) {
      final silent = find.descendant(
        of: find.byKey(const ValueKey('reader-mode')),
        matching: find.text('Sessiz'),
      );
      if (silent.evaluate().isNotEmpty) {
        await tap(silent);
        await wait(const Duration(milliseconds: 700));
      }
    }
    if (find.byKey(const ValueKey('reader-next')).evaluate().isNotEmpty) {
      await tapKey('reader-next');
      await wait(const Duration(milliseconds: 1000));
      await shot('20b-okuyucu-sayfa-2');
    }
    // Okuyucu, kitaplıktan `push` ile açıldı; doğal geri dönüş pop'tur.
    router().pop();
    // Hikâye sayfası kaydırılmış olabilir; başlık (story-sections) ekran
    // dışında kalabilir. Kitaplık görünümünün kendisini bekle.
    await waitFor(find.byKey(const ValueKey('library-view')));

    // Kitap sonu + anlama: aynı kitabı açıp son sayfaya kadar ilerle.
    await tapKey('book-card-A1-K01');
    await waitFor(
      find.byKey(const ValueKey('book-open-sheet')),
      timeout: const Duration(seconds: 15),
      required: false,
    );
    if (find.byKey(const ValueKey('book-open-sheet')).evaluate().isNotEmpty) {
      await tapKey('book-sheet-open');
    }
    await waitFor(find.byKey(const ValueKey('reader-pages')));
    await wait(const Duration(seconds: 2));
    if (find.byKey(const ValueKey('reader-next')).evaluate().isEmpty) {
      final silent = find.descendant(
        of: find.byKey(const ValueKey('reader-mode')),
        matching: find.text('Sessiz'),
      );
      if (silent.evaluate().isNotEmpty) {
        await tap(silent);
        await wait(const Duration(milliseconds: 700));
      }
    }
    for (var i = 0; i < 12; i++) {
      final next = find.byKey(const ValueKey('reader-next'));
      if (next.evaluate().isEmpty) break;
      await tap(next);
      await wait(const Duration(milliseconds: 450));
    }
    await wait(const Duration(milliseconds: 700));
    await shot('21-okuyucu-son-sayfa');
    await tapKey('reader-finish');
    await waitFor(
      find.byKey(const ValueKey('comprehension')),
      timeout: const Duration(seconds: 30),
      required: false,
    );
    if (find.byKey(const ValueKey('comprehension')).evaluate().isNotEmpty) {
      await shot('21-kitap-anlama');
      final skip = find.byKey(const ValueKey('comp-skip'));
      if (skip.evaluate().isNotEmpty) await tap(skip);
    }
    await waitFor(
      find.byKey(const ValueKey('end-of-book')),
      timeout: const Duration(seconds: 20),
      required: false,
    );
    if (find.byKey(const ValueKey('end-of-book')).evaluate().isNotEmpty) {
      await shot('22-kitap-sonu');
      await tapKey('end-back');
    } else {
      router().pop();
    }
    await waitFor(find.byKey(const ValueKey('library-view')));
    await wait(const Duration(milliseconds: 600));
    // Bölüm seçiciyi (Dilbilgisi) görmek için kitaplığı başa kaydır.
    await t.drag(
      find.byKey(const ValueKey('library-view')),
      const Offset(0, 1200),
    );
    await wait(const Duration(milliseconds: 700));
    await t.drag(
      find.byKey(const ValueKey('library-view')),
      const Offset(0, 1200),
    );
    await wait(const Duration(milliseconds: 700));

    // Dilbilgisi
    await tap(
      find.descendant(
        of: find.byKey(const ValueKey('story-sections')),
        matching: find.text('Dilbilgisi'),
      ),
    );
    await waitFor(find.byKey(const ValueKey('grammar-view')));
    await shot('23-dilbilgisi');
    await tapKey('lesson-tile-G-A1-01-to-be');
    await waitFor(find.byKey(const ValueKey('lesson-pages')));
    await wait(const Duration(seconds: 2));
    await shot('24-ders-karti');
    for (var i = 0; i < 20; i++) {
      final next = find.byKey(const ValueKey('lesson-next'));
      if (next.evaluate().isNotEmpty) {
        await tap(next);
        await wait(const Duration(milliseconds: 450));
        continue;
      }
      final finish = find.byKey(const ValueKey('lesson-finish'));
      if (finish.evaluate().isNotEmpty) {
        await tap(finish);
        await wait(const Duration(milliseconds: 800));
        await shot('25-ders-alistirma');
        break;
      }
      if (find.byKey(const ValueKey('practice-q1')).evaluate().isNotEmpty) {
        await shot('25-ders-alistirma');
        break;
      }
      break;
    }
    // ------------------------------------------------------------ 4. Konuş
    await go(
      AppRoutes.talk,
      find.byKey(const ValueKey('talk-screen')),
      name: '26-konus',
    );
    await tapKey('talk-task-hi-intro');
    await waitFor(find.byKey(const ValueKey('message-task')));
    await shot('27-konus-mesaj');
    await t.enterText(
      find.byKey(const ValueKey('message-field')),
      'My name is Deniz. I am from Türkiye.',
    );
    await wait(const Duration(milliseconds: 300));
    await tapKey('message-send');
    await wait(const Duration(milliseconds: 1000));
    await shot('28-konus-mesaj-sonuc');
    router().go(AppRoutes.talk);
    await waitFor(find.byKey(const ValueKey('talk-screen')));
    await wait(const Duration(milliseconds: 600));

    await tapKey('talk-task-maya-neighbour');
    await waitFor(find.byKey(const ValueKey('talk-start')));
    await shot('29-konus-sahne-giris');
    await tapKey('talk-start');
    await waitFor(find.byKey(const ValueKey('talk-choose')));
    await shot('30-konus-sahne-tur');
    await tapKey('talk-choose');
    await waitFor(find.byKey(const ValueKey('talk-opt-0')));
    await shot('31-konus-sahne-secenek');
    await tapKey('talk-opt-0');
    await waitFor(
      find.byKey(const ValueKey('talk-next')),
      timeout: const Duration(seconds: 15),
      required: false,
    );
    await shot('32-konus-sahne-geri-bildirim');
    router().go(AppRoutes.talk);
    await waitFor(find.byKey(const ValueKey('talk-screen')));
    await wait(const Duration(milliseconds: 600));

    // ------------------------------------------------------------ 5. Profil
    await go(
      AppRoutes.profile,
      find.byKey(const ValueKey('profile-list')),
      name: '33-profil',
    );
    await scrollBy(find.byKey(const ValueKey('profile-list')), -700);
    await shot('34-profil-alt');
    await scrollBy(find.byKey(const ValueKey('profile-list')), 700);

    for (final (key, sheet, name) in [
      ('profile-goal', 'daily-goal', '35-gunluk-hedef'),
      ('profile-name-row', 'profile-name', '36-ad'),
    ]) {
      final f = find.byKey(ValueKey(key));
      if (f.evaluate().isEmpty) continue;
      await tapVisible(f);
      await waitFor(find.byKey(ValueKey(sheet)));
      await shot(name);
      await dismissSheet(sheet);
    }

    await tapVisible(find.byKey(const ValueKey('profile-hi-privacy')));
    await waitFor(find.byKey(const ValueKey('hi-privacy')));
    await shot('37-hi-gizliligi');
    await scrollBy(find.byType(Scrollable).last, -900);
    await shot('38-hi-gizliligi-alt');
    router().go(AppRoutes.profile);
    await waitFor(find.byKey(const ValueKey('profile-list')));

    await tapVisible(find.byKey(const ValueKey('profile-account')));
    await waitFor(find.byKey(const ValueKey('account-screen')));
    await shot('39-hesap');
    await tapVisible(find.byKey(const ValueKey('account-email')));
    await waitFor(find.byKey(const ValueKey('sign-in-email')));
    await shot('40-giris');
    router().go(AppRoutes.profile);
    await waitFor(find.byKey(const ValueKey('profile-list')));

    router().go(AppRoutes.legal('kosullar'));
    await waitFor(find.byKey(const ValueKey('legal-text')));
    await shot('41-kosullar');
    router().go(AppRoutes.profile);
    await waitFor(find.byKey(const ValueKey('profile-list')));

    await tapVisible(find.byKey(const ValueKey('profile-about')));
    await waitFor(find.byKey(const ValueKey('about-screen')));
    await shot('42-hakkinda');
    await scrollBy(find.byType(Scrollable).last, -700);
    await shot('43-hakkinda-alt');

    // ------------------------------------------------------------ 6. Defter
    await go(
      AppRoutes.notebook,
      find.byKey(const ValueKey('notebook-tabs')),
      name: '44-defter',
    );
    for (final (label, name) in [
      ('İpucu panosu', '45-defter-ipuclari'),
      ('Konu setleri', '46-defter-setleri'),
    ]) {
      final tab = find.descendant(
        of: find.byKey(const ValueKey('notebook-tabs')),
        matching: find.text(label),
      );
      if (tab.evaluate().isEmpty) continue;
      await tap(tab);
      await wait(const Duration(milliseconds: 900));
      await shot(name);
    }
    final setCard = find.byKey(const ValueKey('topic-set-alex-room'));
    if (setCard.evaluate().isNotEmpty) {
      await tap(setCard);
      await waitFor(find.byKey(const ValueKey('topic-set-screen')));
      await shot('47-konu-seti');
      final hunt = find.byKey(const ValueKey('topic-set-hunt'));
      if (hunt.evaluate().isNotEmpty) {
        await tap(hunt);
        await waitFor(find.byKey(const ValueKey('scene-hunt')));
        await wait(const Duration(seconds: 2));
        await shot('48-sahne-avi');
        final dontKnow = find.byKey(const ValueKey('hunt-dont-know'));
        if (dontKnow.evaluate().isNotEmpty) {
          await tap(dontKnow);
          await wait(const Duration(milliseconds: 900));
          await shot('49-sahne-avi-sonuc');
        }
      }
      router().go(AppRoutes.notebook);
      await waitFor(find.byKey(const ValueKey('notebook-tabs')));
    }

    // ------------------------------------------------------------ 7. Tekrar
    router().go(AppRoutes.review);
    await waitFor(
      find.byKey(const ValueKey('review-progress-bar')),
      timeout: const Duration(seconds: 30),
      required: false,
    );
    await shot('50-tekrar');
    final dontKnow = find.byKey(const ValueKey('task-dont-know'));
    if (dontKnow.evaluate().isNotEmpty) {
      await tap(dontKnow);
      await waitFor(
        find.byKey(const ValueKey('review-feedback')),
        timeout: const Duration(seconds: 15),
        required: false,
      );
      await shot('51-tekrar-geri-bildirim');
      final cont = find.byKey(const ValueKey('review-continue'));
      if (cont.evaluate().isNotEmpty) {
        await tap(cont);
        await wait(const Duration(milliseconds: 800));
        await shot('52-tekrar-ozet');
      }
    }
    router().go(AppRoutes.home);
    await waitFor(nav);

    // ------------------------------------------------------------ 8. Tasarım
    router().go(AppRoutes.designShowcase);
    await waitFor(find.byKey(const ValueKey('showcase-list')));
    await wait(const Duration(seconds: 1));
    await shot('53-tasarim');
    await scrollBy(find.byKey(const ValueKey('showcase-list')), -900);
    await shot('54-tasarim-alt');

    router().go(AppRoutes.home);
    await waitFor(nav);
    await wait(const Duration(seconds: 1));

    expect(errors, isEmpty, reason: errors.join('\n'));
  });
}

/// Bu prova açılışı (H-039) sınamaz: kapı bitmiş sayılır.
class _DoneOnboardingGate extends OnboardingGateNotifier {
  @override
  OnboardingGate build() => OnboardingGate.done;
}
