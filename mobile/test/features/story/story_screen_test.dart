import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/story/presentation/story_screen.dart';
import 'package:hivelzon/shared/content/content_providers.dart';

import '../../support/fake_content_source.dart';

void main() {
  Future<void> pump(WidgetTester tester, FakeContentSource source) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [contentSourceProvider.overrideWithValue(source)],
        child: MaterialApp(theme: AppTheme.light(), home: const StoryScreen()),
      ),
    );
  }

  testWidgets('bölümler listelenir', (tester) async {
    await pump(tester, FakeContentSource());
    expect(find.text('Bölümler yükleniyor…'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('A Strange Message'), findsOneWidget);
    expect(find.text('The New Neighbour'), findsOneWidget);
    expect(find.textContaining('Sezon 1 · Bölüm 1'), findsOneWidget);
  });

  testWidgets('sunucu kapalı: hata ve tekrar dene', (tester) async {
    final source = FakeContentSource(fail: true);
    await pump(tester, source);
    await tester.pumpAndSettle();
    expect(find.text('Sunucu çalışmıyor'), findsOneWidget);
    source.fail = false;
    await tester.tap(find.byKey(const ValueKey('story-retry')));
    await tester.pumpAndSettle();
    expect(find.text('A Strange Message'), findsOneWidget);
    expect(source.listCalls, 2);
  });
}
