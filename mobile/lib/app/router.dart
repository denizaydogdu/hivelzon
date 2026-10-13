import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/discover/presentation/discover_screen.dart';
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

  /// Tekrar oturumu (tam ekran, H-036).
  static const review = '/tekrar';

  /// Sezon jeneriği (tam ekran, H-050).
  static String seasonIntro(int season) => '/sezon/$season/jenerik';

  /// Konu seti (H-051): Defter'den ve bölüm sonundan açılır.
  static String topicSet(String id) => '/konu-seti/$id';

  /// Sahne avı (tam ekran, H-051).
  static String sceneHunt(String id) => '/konu-seti/$id/sahne-avi';
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: autoplayEnabled ? AppRoutes.story : AppRoutes.home,
    routes: [
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
        builder: (context, state) =>
            TopicSetScreen(setId: state.pathParameters['id']!),
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
        builder: (context, state, navigationShell) =>
            ShellScaffold(navigationShell: navigationShell),
        branches: [
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
                builder: (context, state) => const NotebookScreen(),
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
