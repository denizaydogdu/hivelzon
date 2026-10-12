import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/notebook/domain/review_policy.dart';
import 'package:hivelzon/shared/fsrs/fsrs.dart';

/// py-fsrs (referans, MIT) çıktısıyla eşdeğerlik (K-04). Veri:
/// `tools/fsrs-vectors/generate_vectors.py` → `test/fixtures/fsrs_vectors.json`.
void main() {
  final doc =
      jsonDecode(File('test/fixtures/fsrs_vectors.json').readAsStringSync())
          as Map<String, dynamic>;
  final params = [
    for (final p in doc['parameters'] as List) (p as num).toDouble(),
  ];
  const tol = 1e-9;

  test('referans parametreleri port ile aynı', () {
    expect(params, kFsrsDefaultParameters);
  });

  for (final c in (doc['cases'] as List).cast<Map<String, dynamic>>()) {
    test('vektör: ${c['name']}', () {
      final cfg = c['config'] as Map<String, dynamic>;
      Duration sec(Object v) => Duration(seconds: (v as num).toInt());
      final s = FsrsScheduler(
        parameters: params,
        desiredRetention: (cfg['desiredRetention'] as num).toDouble(),
        learningSteps: [
          for (final v in cfg['learningStepsSeconds'] as List) sec(v),
        ],
        relearningSteps: [
          for (final v in cfg['relearningStepsSeconds'] as List) sec(v),
        ],
        maximumInterval: cfg['maximumInterval'] as int,
      );
      var card = FsrsCard.newCard(DateTime.parse(c['start'] as String));
      for (final (i, r)
          in (c['reviews'] as List).cast<Map<String, dynamic>>().indexed) {
        final at = DateTime.parse(r['reviewAt'] as String);
        final where = '${c['name']} #$i';
        expect(
          s.retrievability(card, at),
          closeTo((r['retrievabilityBefore'] as num).toDouble(), tol),
          reason: '$where R',
        );
        card = s.review(card, _rating(r['rating'] as String), at);
        final e = r['expected'] as Map<String, dynamic>;
        expect(card.state.name, e['state'], reason: '$where state');
        expect(card.step, e['step'], reason: '$where step');
        final es = (e['stability'] as num).toDouble();
        final ed = (e['difficulty'] as num).toDouble();
        expect(card.stability, closeTo(es, es * tol), reason: '$where S');
        expect(card.difficulty, closeTo(ed, ed * tol), reason: '$where D');
        expect(
          card.due,
          DateTime.parse(e['due'] as String),
          reason: '$where due',
        );
      }
    });
  }

  test('uygulama ayarı vektörlerdeki "app" ayarıyla aynı', () {
    final app =
        (doc['cases'] as List).cast<Map<String, dynamic>>().firstWhere(
              (c) => (c['name'] as String).startsWith('app:'),
            )['config']
            as Map<String, dynamic>;
    final s = ReviewPolicy.scheduler();
    expect(s.desiredRetention, app['desiredRetention']);
    expect([
      for (final d in s.learningSteps) d.inSeconds,
    ], app['learningStepsSeconds']);
    expect([
      for (final d in s.relearningSteps) d.inSeconds,
    ], app['relearningStepsSeconds']);
    expect(s.enableFuzzing, isFalse);
  });

  test('roundHalfEven Python round() gibi', () {
    expect([0.5, 1.5, 2.5, 2.4999, 2.5001, 3.5].map(roundHalfEven), [
      0,
      2,
      2,
      2,
      3,
      4,
    ]);
  });
}

FsrsRating _rating(String r) => FsrsRating.values.byName(r);
