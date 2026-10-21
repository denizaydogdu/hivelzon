// 17 Ekim 2026 ürün incelemesi — Regresyon #2 (Konuş kısa mesaj).
//
// Bulgu: mesaj denetimi anlamı doğrulamadan görevi ve `own_use` kanıtını
// yazabiliyordu.
//
// - `Sorry late` → geçiyordu (hedef ifade yok).
// - `Sorry, I am early. Maya is late.` → geçiyordu; "Sorry, I'm late."
//   kullanılmış sayılıyordu (kelimeler farklı cümlelerden birleştiriliyordu).
// - `Friday seven` → geçiyordu (yer ve gerekli yapılar yok).
// - `On Friday at seven. Pier 99.` → geçiyordu (yanlış yer denetlenmiyordu).
// - `Sorry, I'm late. I will never do it again.` → reddediliyordu (tüm
//   mesajdaki `never` yasağı hedefi de vuruyordu).
//
// Bu dosya **doğru davranışı** bekler: anlam doğrulanmadan görev/kanıt
// yazılmaz; doğrulanan cevap ipucu görülmeden verildiyse `own_use`, ipucu ya
// da örnek görüldüyse `helped` yazılır.
//
// Kural uygulaması: `talk_match.dart` (cümle kapsamlı denetim, cümle içi hedef
// eşleşmesi) + `talk_message_view.dart` (yardım geçmişi) + içerik kuralları
// (`icerik/_evren/konusma/*.json`; ortak örnekler
// `test/fixtures/talk_check_vectors.json` — Python hattı da aynı).
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/domain/evidence_ladder.dart';
import 'package:hivelzon/features/talk/domain/talk_match.dart';
import 'package:hivelzon/features/talk/domain/talk_task.dart';

import '../support/fixtures.dart';
import '../support/talk_harness.dart';

/// Görev kataloğundan gerçek kural (içerik değişirse test de gerçeği sınar).
TalkTask _task(String id) {
  final cat = TalkCatalog.fromJson(
    (jsonDecode(fixtureText('talk.json')) as Map).cast<String, dynamic>(),
  );
  return cat.byId(id)!;
}

void main() {
  group('bulgu 1: anahtar kelime görevi tamamlamaz', () {
    final late = _task('late-maya').check!;
    final note = _task('meet-note').check!;

    test('`Sorry late` geçmez: hedef ifade (I\'m late) yok', () {
      final r = TalkMatcher.checkMessage('Sorry late', late)!;
      expect(r.passed, isFalse);
      expect(r.missing, contains("I'm late"));
    });

    test('`Sorry, I am early. Maya is late.` geçmez', () {
      final r = TalkMatcher.checkMessage(
        'Sorry, I am early. Maya is late.',
        late,
      )!;
      expect(r.passed, isFalse);
      expect(r.missing, contains("I'm late"));
    });

    test('`Friday seven` geçmez: yer (Pier 3) yok', () {
      final r = TalkMatcher.checkMessage('Friday seven', note)!;
      expect(r.passed, isFalse);
      expect(r.missing, contains('pier 3'));
    });

    test('`On Friday at seven. Pier 99.` geçmez: yanlış yer', () {
      final r = TalkMatcher.checkMessage('On Friday at seven. Pier 99.', note)!;
      expect(r.passed, isFalse);
      expect(r.missing, contains('pier 3'));
    });

    test('anlamı doğrulanan cevaplar geçer', () {
      expect(
        TalkMatcher.checkMessage("Sorry, Maya. I'm late.", late)!.passed,
        isTrue,
      );
      expect(
        TalkMatcher.checkMessage('Sorry, I am running late.', late)!.passed,
        isTrue,
      );
      expect(
        TalkMatcher.checkMessage('Pier 3. On Friday at seven.', note)!.passed,
        isTrue,
      );
      expect(
        TalkMatcher.checkMessage('Friday 7 pm, Pier 3', note)!.passed,
        isTrue,
      );
    });
  });

  group('bulgu 2: ayrı cümledeki olumsuzluk hedefi bozmaz', () {
    final late = _task('late-maya').check!;

    test('`Sorry, I\'m late. I will never do it again.` geçer', () {
      expect(
        TalkMatcher.checkMessage(
          "Sorry, I'm late. I will never do it again.",
          late,
        )!.passed,
        isTrue,
      );
    });

    test('hedef cümledeki olumsuzluk yine yasak', () {
      final r = TalkMatcher.checkMessage("Sorry, I'm not late.", late)!;
      expect(r.passed, isFalse);
      expect(r.forbidden, contains('not'));
    });

    test('`can\'t` (can + not) hedef cümlenin anlamını bozar', () {
      expect(
        TalkMatcher.checkMessage(
          "Sorry Maya, I can't come. I'm late.",
          late,
        )!.passed,
        isFalse,
      );
    });
  });

  group('bulgu 3: hedef ifade cümlelerden birleştirilmez', () {
    test('farklı cümlelerden "Sorry, I\'m late." çıkmaz', () {
      expect(
        TalkMatcher.usesPhrase(
          'Sorry, I am early. Maya is late.',
          "Sorry, I'm late.",
        ),
        isFalse,
      );
      // Mesaj yolu: aynı metin anlam denetiminden geçmediği için hiçbir hedef
      // yazılmaz (kanıt kapısı `checkMessage`).
      expect(
        TalkMatcher.checkMessage(
          'Sorry, I am early. Maya is late.',
          _task('late-maya').check,
        )!.passed,
        isFalse,
      );
    });

    test('tek cümlede ara kelime serbest', () {
      expect(
        TalkMatcher.usesPhrase('Sorry Maya, I am late.', "Sorry, I'm late."),
        isTrue,
      );
      expect(
        TalkMatcher.coveredTargets(
          ["Sorry, I'm late."],
          'Sorry, Maya. I am late.',
          _task('late-maya').check!,
        ),
        ["Sorry, I'm late."],
      );
    });
  });

  // 21 Ekim 2026 takip incelemesi (H-096): `checkMessage` gerekli kalıbı
  // bütün cümleleri birleştirerek arıyordu; "Sorry, I am. Late." `late-maya`
  // görevinden geçiyor ve ilk denemede own_use yazılabiliyordu.
  group('bulgu 5 (H-096): gerekli kalıp tek cümlede geçmeli', () {
    final late = _task('late-maya').check!;

    test('`Sorry, I am. Late.` geçmez', () {
      final r = TalkMatcher.checkMessage('Sorry, I am. Late.', late)!;
      expect(r.passed, isFalse);
      expect(r.missing, ["I'm late"]);
    });

    test('farklı gruplar farklı cümlelerde olabilir', () {
      expect(
        TalkMatcher.checkMessage("I'm late. Sorry about that.", late)!.passed,
        isTrue,
      );
    });

    test('kanıt yalnız geçerli eşleşen kalıplardan', () {
      expect(
        TalkMatcher.coveredTargets(
          ["Sorry, I'm late."],
          'Sorry, I am. Late.',
          late,
        ),
        isEmpty,
      );
      // Kural geçse de hedefin parçası ilgisiz bir cümleden alınmaz.
      expect(
        TalkMatcher.coveredTargets(
          ["Sorry, I'm late."],
          "Sorry! I'll be late. I am at home.",
          late,
        ),
        isEmpty,
      );
    });

    testWidgets('ilk denemede `Sorry, I am. Late.`: kanıt yok, ipucu', (
      tester,
    ) async {
      final h = TalkHarness(
        completed: const ['A1-001', 'A1-002', 'A1-003', 'A1-004', 'A1-005'],
      );
      addTearDown(h.dispose);
      await h.addTargets(["Sorry, I'm late."]);
      await h.pump(tester, '/konusma/late-maya');
      await tester.enterText(
        find.byKey(const ValueKey('message-field')),
        'Sorry, I am. Late.',
      );
      await h.tap(tester, 'message-send');
      expect(find.byKey(const ValueKey('message-hint')), findsOneWidget);
      final ev = await tester.runAsync(() => NotebookStore(h.db).evidence());
      expect(ev!["phrase|sorry i'm late"], isNull);
    });
  });

  group('bulgu 4: yardım görülmeden own_use yazılmaz', () {
    testWidgets('ipucu → doğru cevap: helped (own_use değil)', (tester) async {
      final h = TalkHarness(
        completed: const ['A1-001', 'A1-002', 'A1-003', 'A1-004', 'A1-005'],
      );
      addTearDown(h.dispose);
      await h.addTargets(["Sorry, I'm late."]);
      await h.pump(tester, '/konusma/late-maya');
      await tester.enterText(
        find.byKey(const ValueKey('message-field')),
        'Sorry late',
      );
      await h.tap(tester, 'message-send');
      expect(find.byKey(const ValueKey('message-hint')), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('message-field')),
        "Sorry, I'm late.",
      );
      await h.tap(tester, 'message-send');
      final ev = await tester.runAsync(() => NotebookStore(h.db).evidence());
      expect(ev!["phrase|sorry i'm late"]?.keys, [EvidenceStage.helped]);
      expect(find.textContaining('yardımla kullandın'), findsOneWidget);
    });

    testWidgets('örnek mesaj görüldükten sonra yazmak da helped', (
      tester,
    ) async {
      final h = TalkHarness(
        completed: const ['A1-001', 'A1-002', 'A1-003', 'A1-004', 'A1-005'],
      );
      addTearDown(h.dispose);
      await h.addTargets(["Sorry, I'm late."]);
      await h.pump(tester, '/konusma/late-maya');
      // Yanlış cevap → ipucu → "Örnek mesaja bak" → örneği yaz.
      await tester.enterText(
        find.byKey(const ValueKey('message-field')),
        'Sorry late',
      );
      await h.tap(tester, 'message-send');
      await h.tap(tester, 'message-show-model');
      await h.tap(tester, 'message-try-again');
      await tester.enterText(
        find.byKey(const ValueKey('message-field')),
        "Sorry, I'm late.",
      );
      await h.tap(tester, 'message-send');
      final ev = await tester.runAsync(() => NotebookStore(h.db).evidence());
      expect(ev!["phrase|sorry i'm late"]?.keys, [EvidenceStage.helped]);
    });

    testWidgets('ilk denemede doğru: own_use', (tester) async {
      final h = TalkHarness(
        completed: const ['A1-001', 'A1-002', 'A1-003', 'A1-004', 'A1-005'],
      );
      addTearDown(h.dispose);
      await h.addTargets(["Sorry, I'm late."]);
      await h.pump(tester, '/konusma/late-maya');
      await tester.enterText(
        find.byKey(const ValueKey('message-field')),
        "Sorry, I'm late.",
      );
      await h.tap(tester, 'message-send');
      final ev = await tester.runAsync(() => NotebookStore(h.db).evidence());
      expect(ev!["phrase|sorry i'm late"]?.keys, [EvidenceStage.ownUse]);
    });
  });
}
