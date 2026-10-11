import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/player/domain/episode.dart';
import 'package:hivelzon/features/player/presentation/widgets/task_view.dart';

import '../../support/fixtures.dart';

void main() {
  late List<(String, bool)> attempts;
  late int completed;
  late List<String> listened;

  Future<void> pumpTask(WidgetTester tester, String ep, String node) async {
    attempts = [];
    completed = 0;
    listened = [];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: TaskView(
              task: loadFixture(ep).node(node) as TaskNode,
              onAttempt: (i, ok) => attempts.add((i, ok)),
              onComplete: () => completed++,
              onListen: listened.add,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> tap(WidgetTester tester, String key) async {
    final f = find.byKey(ValueKey(key));
    await tester.ensureVisible(f);
    await tester.tap(f);
    await tester.pump();
  }

  testWidgets(
    'multiSelect (B2): eksik seçim nazik geri bildirim, sonra doğru',
    (tester) async {
      await pumpTask(tester, 'A1-002', 't-gorev');
      await tap(tester, 'task-option-a');
      await tap(tester, 'task-option-b');
      await tap(tester, 'task-check');
      expect(find.text('Bir daha bakalım.'), findsOneWidget);
      await tap(tester, 'task-option-c');
      await tap(tester, 'task-check');
      expect(attempts, [('i1', false), ('i1', true)]);
      await tap(tester, 'task-continue');
      expect(completed, 1);
    },
  );

  testWidgets('match (B4): sol-sağ eşleştirme', (tester) async {
    await pumpTask(tester, 'A1-004', 't-gorev');
    final item =
        (loadFixture('A1-004').node('t-gorev') as TaskNode).items.first;
    for (final (i, p) in item.pairs.indexed) {
      await tap(tester, 'task-left-$i');
      await tester.ensureVisible(find.text(p.right).last);
      await tester.tap(find.text(p.right).last);
      await tester.pump();
    }
    await tap(tester, 'task-check');
    expect(attempts.single.$2, isTrue);
    expect(find.text('Friday. 7 pm. Pier 3. — E.'), findsOneWidget);
  });

  testWidgets('fillBlank (B2): iki boşluk dolunca kontrol', (tester) async {
    await pumpTask(tester, 'A1-002', 't-kanit');
    await tester.enterText(
      find.byKey(const ValueKey('task-blank-name')),
      'Deniz',
    );
    await tester.enterText(
      find.byKey(const ValueKey('task-blank-from')),
      'İzmir',
    );
    await tester.pump();
    await tap(tester, 'task-check');
    expect(attempts.single.$2, isTrue);
  });

  testWidgets('choice (B4): feedback.wrong Hi balonu ve sesi', (tester) async {
    await pumpTask(tester, 'A1-004', 't-kanit');
    await tap(tester, 'task-option-b');
    expect(find.text('Saatten önce at: at two o\'clock.'), findsOneWidget);
    expect(listened, contains('audio/A1-004_b4_33_hi.m4a'));
    await tap(tester, 'task-option-a');
    expect(attempts, [('i1', false), ('i1', true)]);
  });
}
