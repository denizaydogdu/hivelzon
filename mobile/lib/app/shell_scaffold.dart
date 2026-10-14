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
      // H-064: dar ekranda büyük yazıda "Ana Sayfa" iki satıra bölünmesin;
      // etiket ölçeği en geniş etiketin tek satıra sığacağı değerde
      // sınırlanır (ikonlar değişmez).
      bottomNavigationBar: MediaQuery.withClampedTextScaling(
        maxScaleFactor: _navLabelScale(context),
        child: _navigationBar(),
      ),
    );
  }

  static const _labels = [
    TabTexts.home,
    TabTexts.discover,
    TabTexts.story,
    TabTexts.talk,
    TabTexts.profile,
  ];

  static double _navLabelScale(BuildContext context) {
    final mq = MediaQuery.of(context);
    final slot =
        (mq.size.width - mq.padding.left - mq.padding.right) / _labels.length;
    return AppTypography.navLabelFitScale(slot, _labels);
  }

  Widget _navigationBar() {
    return NavigationBar(
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
    );
  }
}
