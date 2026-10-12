import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/discover/presentation/discover_screen.dart';
import '../features/player/application/autoplay_driver.dart';
import '../features/player/application/player_session.dart';
import '../features/player/presentation/player_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/story/presentation/season_intro_screen.dart';
import '../features/story/presentation/story_screen.dart';
import '../features/talk/presentation/talk_screen.dart';
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

  /// Sezon jeneriği (tam ekran, H-050).
  static String seasonIntro(int season) => '/sezon/$season/jenerik';
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ShellScaffold(navigationShell: navigationShell),
        branches: [
          _branch(AppRoutes.home, const HomeScreen()),
          _branch(AppRoutes.discover, const DiscoverScreen()),
          _branch(AppRoutes.story, const StoryScreen()),
          _branch(AppRoutes.talk, const TalkScreen()),
          _branch(AppRoutes.profile, const ProfileScreen()),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

StatefulShellBranch _branch(String path, Widget screen) {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: path,
        pageBuilder: (context, state) => NoTransitionPage(child: screen),
      ),
    ],
  );
}
