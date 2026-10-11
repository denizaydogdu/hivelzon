import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/app.dart';

void main() {
  testWidgets('5 sekme görünür ve Konuş sekmesi "Yakında" gösterir', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: HiVelzonApp()));
    await tester.pumpAndSettle();

    final nav = find.byType(NavigationBar);
    expect(nav, findsOneWidget);
    for (final label in ['Ana Sayfa', 'Keşfet', 'Hikâye', 'Konuş', 'Profil']) {
      expect(
        find.descendant(of: nav, matching: find.text(label)),
        findsOneWidget,
      );
    }
    expect(find.byType(NavigationDestination), findsNWidgets(5));
    expect(find.textContaining('Yakında'), findsNothing);

    await tester.tap(find.descendant(of: nav, matching: find.text('Konuş')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Yakında'), findsOneWidget);
  });
}
