import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/hi/presentation/hi_bubble.dart';
import '../l10n/tr_strings.dart';
import 'router.dart';
import 'theme.dart';

/// Alt sekme çubuklu ana iskelet. Beş sekmenin kök sayfasında sağ altta,
/// menünün üstünde Hi balonu durur (H-048).
class ShellScaffold extends StatelessWidget {
  const ShellScaffold({
    super.key,
    required this.navigationShell,
    this.location = '/',
  });

  final StatefulNavigationShell navigationShell;

  /// Şu anki yol (balon yalnızca sekme köklerinde).
  final String location;

  @override
  Widget build(BuildContext context) {
    final bubble = hiBubbleVisibleFor(location);
    return Scaffold(
      body: Stack(
        children: [
          // H-064 (balon katmanı): balon içeriğin üstünde yüzer; sayfaların
          // alt güvenli alanı büyümez, içerik balonun altından kayar.
          // Kaydırılan listeler payı yalnızca son dolgu olarak ekler
          // ([HiBubbleInset]). Keşfet tam ekran video: alt denetimler
          // (Kaydet / Anlam / Tam hikâye) balonun altında kalmasın diye
          // orada alt güvenli alan eskisi gibi balon kadar büyür (H-055).
          Positioned.fill(
            child: HiBubbleInset(
              visible: bubble,
              child: Builder(
                builder: (context) {
                  if (!bubble || location != AppRoutes.discover) {
                    return navigationShell;
                  }
                  final mq = MediaQuery.of(context);
                  return MediaQuery(
                    data: mq.copyWith(
                      padding: mq.padding.copyWith(
                        bottom: mq.padding.bottom + HiBubble.clearance,
                      ),
                    ),
                    child: navigationShell,
                  );
                },
              ),
            ),
          ),
          if (bubble)
            const Positioned(
              right: AppSpacing.sm,
              bottom: AppSpacing.sm,
              child: SafeArea(top: false, child: HiBubble()),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: TabTexts.home,
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: TabTexts.discover,
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories),
            label: TabTexts.story,
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: TabTexts.talk,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: TabTexts.profile,
          ),
        ],
      ),
    );
  }
}
