import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/account/presentation/account_screen.dart';
import '../features/account/presentation/account_widgets.dart';
import '../features/account/presentation/sign_in_screen.dart';
import '../features/design_showcase/design_showcase_screen.dart';
import '../features/discover/presentation/discover_screen.dart';
import '../features/hi/presentation/hi_privacy_screen.dart';
import '../features/player/application/autoplay_driver.dart';
import '../features/player/application/player_session.dart';
import '../features/player/presentation/player_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/notebook/presentation/notebook_screen.dart';
import '../features/notebook/presentation/review_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/story/presentation/season_intro_screen.dart';
import '../features/story/presentation/story_screen.dart';
import '../features/talk/presentation/talk_screen.dart';
import '../features/topic_sets/presentation/scene_hunt_screen.dart';
import '../features/topic_sets/presentation/topic_set_screen.dart';
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

  /// Tasarım sistemi vitrini (H-057): yalnız debug derlemede.
  static const designShowcase = '/tasarim';
}

/// Debug derlemede başlangıç yolu (`--dart-define=HV_START_ROUTE=/tasarim`);
/// ekran görüntüsü ve vitrin için. Release'de yok sayılır.
const _debugStartRoute = String.fromEnvironment('HV_START_ROUTE');

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
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
        path: '/play/:contentId',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: PlayerScreen(
            contentId: state.pathParameters['contentId']!,
            startMode: PlayerStartMode.parse(state.uri.queryParameters['mode']),
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
          child: TopicSetScreen(setId: state.pathParameters['id']!),
        ),
        routes: [
          GoRoute(
            path: 'sahne-avi',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: SceneHuntScreen(setId: state.pathParameters['id']!),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.review,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const ReviewScreen(),
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
