import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/account/presentation/account_screen.dart';
import '../features/account/presentation/account_widgets.dart';
import '../features/account/presentation/sign_in_screen.dart';
import '../features/design_showcase/design_showcase_screen.dart';
import '../features/discover/presentation/discover_screen.dart';
import '../features/grammar/presentation/grammar_lesson_screen.dart';
import '../features/hi/presentation/hi_privacy_screen.dart';
import '../features/player/application/autoplay_driver.dart';
import '../features/player/application/player_session.dart';
import '../features/player/presentation/player_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/library/presentation/reader_screen.dart';
import '../features/notebook/presentation/notebook_screen.dart';
import '../features/notebook/presentation/review_screen.dart';
import '../features/onboarding/application/onboarding_providers.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/story/presentation/season_intro_screen.dart';
import '../features/story/presentation/story_screen.dart';
import '../features/talk/presentation/talk_screen.dart';
import '../features/topic_sets/presentation/scene_hunt_screen.dart';
import '../features/topic_sets/presentation/topic_set_screen.dart';
import '../shared/activity/study_clock.dart';
import 'design/transitions.dart';
import 'shell_scaffold.dart';

/// Sekme yolları (K-30): Ana Sayfa · Keşfet · Hikâye · Konuş · Profil.
abstract final class AppRoutes {
  static const home = '/';
  static const discover = '/kesfet';
  static const story = '/hikaye';
  static const talk = '/konus';
  static const profile = '/profil';

  /// Bölüm oynatıcısı (sekme iskeletinin dışında, tam ekran).
  /// [mode]: `resume` (kaldığı yerden) ya da `restart` (baştan); yoksa kayıt varsa sorulur.
  static String play(String contentId, {String? mode}) =>
      mode == null ? '/play/$contentId' : '/play/$contentId?mode=$mode';

  /// Profil → Defter (H-036).
  static const notebook = '/profil/defter';

  /// Defter → Konu setleri sekmesi (H-048: Hi'nin hızlı eylemi).
  static const notebookSets = '/profil/defter?sekme=setler';

  /// Profil → "Hi benim hakkımda ne biliyor?" (H-048).
  static const hiPrivacy = '/profil/hi';

  /// Profil → Hesap (H-038): isteğe bağlı hesap ve eşitleme.
  static const account = '/profil/hesap';

  /// Hesap aç / giriş yap (e-posta kodu).
  static const signIn = '/profil/hesap/giris';

  /// Hukuk metinleri (yer tutucu; H-042): `kosullar` | `aydinlatma`.
  static String legal(String kind) => '/profil/hesap/metin/$kind';

  /// Tekrar oturumu (tam ekran, H-036).
  static const review = '/tekrar';

  /// Sezon jeneriği (tam ekran, H-050).
  static String seasonIntro(int season) => '/sezon/$season/jenerik';

  /// Konu seti (H-051): Defter'den ve bölüm sonundan açılır.
  static String topicSet(String id) => '/konu-seti/$id';

  /// Sahne avı (tam ekran, H-051).
  static String sceneHunt(String id) => '/konu-seti/$id/sahne-avi';

  /// Kitap okuyucu (H-067; tam ekran). [listen]: sesli açılır ("Bana bir
  /// kitap oku"); yoksa kitabın kalınan yerinden, son kullanılan biçimle.
  static String book(String id, {bool listen = false}) =>
      listen ? '/kitap/$id?mod=dinle' : '/kitap/$id';

  /// Kitabı bir sayfada ve cümlede, sessiz açar (H-078: dilbilgisi dersinde
  /// "Hikâyede gör").
  static String bookAt(String id, {required String page, String? sentence}) =>
      Uri(
        path: '/kitap/$id',
        queryParameters: {'mod': 'oku', 'sayfa': page, 'cumle': ?sentence},
      ).toString();

  /// Dilbilgisi dersi (H-078; tam ekran). [then]: ardından sırayla açılacak
  /// dersler; [cont]: son dersten sonra "Bölümü başlat" (`bolum`) ya da
  /// "Kitabı aç" (`kitap`) sunulur (sayfa `true` ile kapanır).
  static String grammarLesson(
    String id, {
    List<String> then = const [],
    String? cont,
  }) => Uri(
    path: '/dilbilgisi/$id',
    queryParameters: {
      if (then.isNotEmpty) 'sonra': then.join(','),
      'devam': ?cont,
    },
  ).toString();

  /// Tasarım sistemi vitrini (H-057): yalnız debug derlemede.
  static const designShowcase = '/tasarim';

  /// İlk açılış ve yerleştirme (H-039; tam ekran, sekmesiz).
  static const onboarding = '/acilis';

  /// Açılıştaki hukuk metinleri (`kosullar` | `aydinlatma`).
  static String onboardingLegal(String kind) => '/acilis/metin/$kind';
}

/// Debug derlemede başlangıç yolu (`--dart-define=HV_START_ROUTE=/tasarim`);
/// ekran görüntüsü ve vitrin için. Release'de yok sayılır.
const _debugStartRoute = String.fromEnvironment('HV_START_ROUTE');

final routerProvider = Provider<GoRouter>((ref) {
  // H-039: açılış kapısı. Durum değişince yönlendirme yeniden değerlendirilir.
  // Otomatik oynatma (ölçüm) derlemesinde kapı yok.
  final gate = ValueNotifier<OnboardingGate>(OnboardingGate.done);
  if (!autoplayEnabled) {
    ref.listen<OnboardingGate>(
      onboardingGateProvider,
      (_, next) => gate.value = next,
      fireImmediately: true,
    );
  }
  ref.onDispose(gate.dispose);
  final router = GoRouter(
    refreshListenable: gate,
    redirect: (context, state) => onboardingRedirect(gate.value, state.uri),
    initialLocation: kDebugMode && _debugStartRoute.isNotEmpty
        ? _debugStartRoute
        : autoplayEnabled
        ? AppRoutes.story
        : AppRoutes.home,
    routes: [
      if (kDebugMode)
        GoRoute(
          path: AppRoutes.designShowcase,
          pageBuilder: (context, state) =>
              appPage(key: state.pageKey, child: const DesignShowcaseScreen()),
        ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: OnboardingScreen(next: state.uri.queryParameters['sonra']),
        ),
        routes: [
          GoRoute(
            path: 'metin/:kind',
            pageBuilder: (context, state) => appPage(
              key: state.pageKey,
              child: LegalTextScreen(kind: state.pathParameters['kind']!),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/play/:contentId',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: StudyTimeScope(
            child: PlayerScreen(
              contentId: state.pathParameters['contentId']!,
              startMode: PlayerStartMode.parse(
                state.uri.queryParameters['mode'],
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/kitap/:bookId',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: StudyTimeScope(
            child: ReaderScreen(
              key: ValueKey(state.pathParameters['bookId']),
              bookId: state.pathParameters['bookId']!,
              listen: state.uri.queryParameters['mod'] != 'oku',
              startPage: state.uri.queryParameters['sayfa'],
              startSentence: state.uri.queryParameters['cumle'],
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/dilbilgisi/:id',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: StudyTimeScope(
            child: GrammarLessonScreen(
              lessonIds: [
                state.pathParameters['id']!,
                for (final x
                    in (state.uri.queryParameters['sonra'] ?? '').split(','))
                  if (x.isNotEmpty) x,
              ],
              continueKind: GrammarContinue.parse(
                state.uri.queryParameters['devam'],
              ),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/sezon/:season/jenerik',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: SeasonIntroScreen(
            season: int.tryParse(state.pathParameters['season']!) ?? 1,
          ),
        ),
      ),
      GoRoute(
        path: '/konu-seti/:id',
        pageBuilder: (context, state) => appPage(
          key: state.pageKey,
          child: StudyTimeScope(
            child: TopicSetScreen(setId: state.pathParameters['id']!),
          ),
        ),
        routes: [
          GoRoute(
            path: 'sahne-avi',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: StudyTimeScope(
                child: SceneHuntScreen(setId: state.pathParameters['id']!),
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.review,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const StudyTimeScope(child: ReviewScreen()),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => ShellScaffold(
          navigationShell: navigationShell,
          location: state.uri.path,
        ),
        branches: [
          // Başka cihazdan veri gelince bütün sekmeler uygulama kökünden
          // yenilenir (H-056, `local_data_refresh.dart`).
          _branch(AppRoutes.home, const HomeScreen()),
          _branch(AppRoutes.discover, const DiscoverScreen()),
          _branch(AppRoutes.story, const StoryScreen()),
          _branch(AppRoutes.talk, const TalkScreen()),
          _branch(
            AppRoutes.profile,
            const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'defter',
                pageBuilder: (context, state) => appPage(
                  key: state.pageKey,
                  child: NotebookScreen(
                    initialTab: switch (state.uri.queryParameters['sekme']) {
                      'ipuclari' => 1,
                      'setler' => 2,
                      _ => 0,
                    },
                  ),
                ),
              ),
              GoRoute(
                path: 'hi',
                pageBuilder: (context, state) =>
                    appPage(key: state.pageKey, child: const HiPrivacyScreen()),
              ),
              GoRoute(
                path: 'hesap',
                pageBuilder: (context, state) =>
                    appPage(key: state.pageKey, child: const AccountScreen()),
                routes: [
                  GoRoute(
                    path: 'giris',
                    pageBuilder: (context, state) => appPage(
                      key: state.pageKey,
                      child: const SignInScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'metin/:kind',
                    pageBuilder: (context, state) => appPage(
                      key: state.pageKey,
                      child: LegalTextScreen(
                        kind: state.pathParameters['kind']!,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

StatefulShellBranch _branch(
  String path,
  Widget screen, {
  List<RouteBase> routes = const [],
}) {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: path,
        pageBuilder: (context, state) => NoTransitionPage(child: screen),
        routes: routes,
      ),
    ],
  );
}
