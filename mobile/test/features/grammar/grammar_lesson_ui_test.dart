import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/design/tokens.dart';
import 'package:hivelzon/features/grammar/data/grammar_progress_store.dart';
import 'package:hivelzon/features/grammar/domain/grammar_progress.dart';
import 'package:hivelzon/features/notebook/data/notebook_store.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/notebook/presentation/widgets/notebook_row.dart';

import '../../support/fake_content_source.dart';
import '../../support/grammar_harness.dart';

const _route = '/dilbilgisi/$kTestLessonId';

/// Ders ekranı (H-078): kart kart ilerleme, vurgulu Türkçe anlatım, örnek
/// sesleri, alıştırma (yanlış → açıklama → tekrar), "Hikâyede gör", kural
/// kartı → Defter, ilerleme, sessiz mod.
void main() {
  Finder key(String k) => find.byKey(ValueKey(k));

  testWidgets('kartlar sırayla; ilerleme kaydedilir; ders biter', (
    tester,
  ) async {
    final h = GrammarHarness();
    addTearDown(h.dispose);
    await h.pump(tester, _route);
    expect(key('lesson-card-c01'), findsOneWidget);
    expect(find.text('Kart 1 / 7'), findsOneWidget);
    expect(find.text('Üçüncü tekil -s'), findsOneWidget);
    expect(key('lesson-prev'), findsOneWidget);
    expect(
      tester.widget<IconButton>(key('lesson-prev')).onPressed,
      isNull,
      reason: 'ilk kartta geri yok',
    );

    await h.next(tester);
    expect(key('lesson-card-c02'), findsOneWidget);
    expect(find.text('Kart 2 / 7'), findsOneWidget);
    // Şemalar kodla çizilir.
    expect(find.bySemanticsLabel(RegExp('^Şema: open \\+ s')), findsOneWidget);
    var p = await tester.runAsync(
      () => GrammarProgressStore(h.db).get(kTestLessonId),
    );
    expect(p!.status, GrammarStatus.inProgress);
    expect(p.lastCard, 'c02');

    await tester.tap(key('lesson-prev'));
    await h.settle(tester);
    expect(find.text('Kart 1 / 7'), findsOneWidget);

    await h.next(tester, 6);
    expect(key('lesson-card-c07'), findsOneWidget);
    expect(key('lesson-finish'), findsOneWidget);
    await tester.tap(key('lesson-finish'));
    await h.settle(tester);
    expect(key('lesson-done'), findsOneWidget);
    expect(find.text('Dersi bitirdin'), findsOneWidget);
    expect(find.text('Dilbilgisine dön'), findsOneWidget);
    p = await tester.runAsync(
      () => GrammarProgressStore(h.db).get(kTestLessonId),
    );
    expect(p!.status, GrammarStatus.completed);
  });

  testWidgets('yarım ders kalınan karttan açılır', (tester) async {
    final h = GrammarHarness();
    addTearDown(h.dispose);
    await tester.runAsync(
      () => GrammarProgressStore(h.db).markCard(kTestLessonId, 'c04'),
    );
    await h.pump(tester, _route);
    expect(find.text('Kart 4 / 7'), findsOneWidget);
    expect(key('lesson-card-c04'), findsOneWidget);
    // Yanlış biçim nazikçe, açıklamasıyla.
    expect(key('wrong-c04-x1'), findsOneWidget);
    expect(find.text('She go to school.'), findsOneWidget);
    expect(find.text('Ek eksik.'), findsOneWidget);
  });

  testWidgets('Türkçe anlatım kendiliğinden okunur; okunan kelime vurgulu', (
    tester,
  ) async {
    final h = GrammarHarness();
    addTearDown(h.dispose);
    await h.pump(tester, _route);
    expect(h.audio.opened.last.path, endsWith('/audio/c01-tr.m4a'));
    expect(h.audio.playing, isTrue);
    // "Bu" 0,20 sn, "cümlede" 0,37 sn'de başlar.
    await h.listenFor(tester, 0.45);
    expect(key('narration-c01-0-1'), findsOneWidget);
    await h.listenFor(tester, 1.7); // ~2,15 sn: 2. cümle, "Fiilin"
    expect(key('narration-c01-1-0'), findsOneWidget);
    expect(find.text('Durdur'), findsOneWidget);
    await tester.tap(key('lesson-listen'));
    await h.settle(tester);
    expect(h.audio.playing, isFalse);
    expect(key('narration-c01'), findsOneWidget);
    expect(find.text('Dinle'), findsOneWidget);
  });

  testWidgets('örnek: sesi çalar, okunan kelime vurgulanır; kelimeye '
      'dokununca anlam paneli', (tester) async {
    final h = GrammarHarness();
    addTearDown(h.dispose);
    await h.pump(tester, _route);
    await h.next(tester, 2);
    expect(key('lesson-card-c03'), findsOneWidget);
    await tester.tap(key('play-c03-ex2'));
    await h.settle(tester, rounds: 3);
    expect(h.audio.opened.last.path, endsWith('/audio/c03-ex2.m4a'));
    await h.listenFor(tester, 0.3); // "goes" 0,25 sn
    final goes = tester.widget<Text>(
      find.descendant(of: key('ex-c03-ex2-w1'), matching: find.byType(Text)),
    );
    expect(goes.style?.backgroundColor, AppPalette.seaBlue100);
    // Hedef yapı işaretli (kalın, turuncu).
    final plays = tester.widget<Text>(
      find.descendant(of: key('ex-c03-ex1-w1'), matching: find.byType(Text)),
    );
    expect(plays.data, 'plays');
    expect(plays.style?.color, AppPalette.orange700);

    await tester.tap(key('ex-c03-ex2-w1'));
    await h.settle(tester);
    expect(key('meaning-word-1'), findsOneWidget);
    expect(find.text('O okula gider.'), findsWidgets);
    await tester.tap(key('meaning-save'));
    await h.settle(tester);
    final items = await tester.runAsync(() => NotebookStore(h.db).entries());
    final saved = items!.single.item;
    expect(saved.textEn, 'goes');
    expect(saved.source, NotebookSource.grammar);
    expect(notebookSourceLine(saved), 'Dilbilgisi: Üçüncü tekil -s');
  });

  testWidgets('alıştırma: yanlışta kısa açıklama, aynı soru yeniden; '
      'puan yok, "Geç" hep var', (tester) async {
    final h = GrammarHarness();
    addTearDown(h.dispose);
    await h.pump(tester, _route);
    await h.next(tester, 4);
    expect(key('practice-q1'), findsOneWidget);
    expect(find.text('Soru 1 / 4'), findsOneWidget);

    // Seç: yanlış → açıklama → tekrar dene → doğru.
    await tester.tap(key('opt-0'));
    await h.settle(tester, rounds: 3);
    expect(key('practice-feedback'), findsOneWidget);
    expect(find.text('Bir daha bakalım.'), findsOneWidget);
    expect(find.text('Tek kişi var; fiile ek gelir.'), findsOneWidget);
    await tester.tap(key('practice-retry'));
    await h.settle(tester, rounds: 3);
    expect(key('practice-feedback'), findsNothing);
    expect(key('practice-q1'), findsOneWidget);
    await tester.tap(key('opt-1'));
    await h.settle(tester, rounds: 3);
    expect(key('practice-correct'), findsOneWidget);
    expect(find.text('She goes to school.'), findsWidgets);
    await tester.ensureVisible(key('practice-next'));
    await tester.tap(key('practice-next'));
    await h.settle(tester, rounds: 3);

    // Boşluk: yanlış → "Geç" doğruyu gösterir, ilerlemeyi kilitlemez.
    expect(find.text('Soru 2 / 4'), findsOneWidget);
    await tester.enterText(key('fill-field'), 'play');
    await h.settle(tester, rounds: 3);
    await tester.tap(key('practice-check'));
    await h.settle(tester, rounds: 3);
    expect(find.text('Tek kişi var; ek unutulmasın.'), findsOneWidget);
    await tester.ensureVisible(key('practice-skip'));
    await tester.tap(key('practice-skip'));
    await h.settle(tester, rounds: 3);
    expect(find.text('Doğrusu: He plays football.'), findsOneWidget);
    await tester.ensureVisible(key('practice-next'));
    await tester.tap(key('practice-next'));
    await h.settle(tester, rounds: 3);

    // Sırala.
    expect(find.text('Soru 3 / 4'), findsOneWidget);
    for (final i in [2, 1, 0]) {
      await tester.tap(key('order-token-$i'));
      await h.settle(tester, rounds: 2);
    }
    await tester.ensureVisible(key('practice-check'));
    await tester.tap(key('practice-check'));
    await h.settle(tester, rounds: 3);
    expect(key('practice-correct'), findsOneWidget);
    await tester.ensureVisible(key('practice-next'));
    await tester.tap(key('practice-next'));
    await h.settle(tester, rounds: 3);

    // Söyle: cihazda tanıma yok → dinle ve sesli tekrar et.
    expect(find.text('Soru 4 / 4'), findsOneWidget);
    expect(find.text('Cümleyi dinle, sonra sesli tekrar et.'), findsOneWidget);
    expect(key('play-c05-q4'), findsOneWidget);
    expect(key('grammar-speak-mic'), findsNothing);
    await tester.ensureVisible(key('practice-next'));
    await tester.tap(key('practice-next'));
    await h.settle(tester, rounds: 3);
    expect(key('practice-done'), findsOneWidget);
    // Puan, yüzde, süre yok.
    expect(find.textContaining('%'), findsNothing);
    expect(find.textContaining('puan'), findsNothing);
  });

  testWidgets('alıştırma ilerlemeyi kilitlemez: soru yarımken sonraki kart', (
    tester,
  ) async {
    final h = GrammarHarness();
    addTearDown(h.dispose);
    await h.pump(tester, _route);
    await h.next(tester, 4);
    expect(key('practice-q1'), findsOneWidget);
    await h.next(tester);
    expect(key('lesson-card-c06'), findsOneWidget);
  });

  testWidgets('"Söyle" cihazda tanıma varsa görünür', (tester) async {
    final h = GrammarHarness();
    addTearDown(h.dispose);
    await h.pump(tester, _route, speech: true);
    await h.next(tester, 4);
    // Üç soru "Geç" ile geçilir.
    for (var i = 0; i < 3; i++) {
      await tester.ensureVisible(key('practice-skip'));
      await tester.tap(key('practice-skip'));
      await h.settle(tester, rounds: 3);
      await tester.ensureVisible(key('practice-next'));
      await tester.tap(key('practice-next'));
      await h.settle(tester, rounds: 3);
    }
    expect(find.text('Cümleyi dinle, sonra sen de söyle.'), findsOneWidget);
    expect(key('grammar-speak-mic'), findsOneWidget);
  });

  testWidgets('Hikâyede gör: kitap cümlesi sayfasında açılır', (tester) async {
    final h = GrammarHarness();
    addTearDown(h.dispose);
    await h.pump(tester, _route);
    expect(find.text('Kitap: The Test Box, s. 3'), findsOneWidget);
    await tester.tap(key('open-link-A1-K99'));
    await h.settle(tester);
    expect(find.text('s. 3 / 3'), findsOneWidget);
    expect(h.audio.playing, isFalse, reason: 'ders sesi durdu');
  });

  testWidgets('Hikâyede gör: kapalı bölümde sakin not; açık bölüm başından '
      'açılır', (tester) async {
    final locked = GrammarHarness();
    addTearDown(locked.dispose);
    await locked.pump(tester, _route);
    await locked.next(tester, 5);
    expect(key('lesson-card-c06'), findsOneWidget);
    expect(find.text('Bölüm: A1-901'), findsOneWidget);
    await tester.tap(key('open-link-A1-901'));
    await locked.settle(tester);
    expect(find.textContaining('henüz açık değil'), findsOneWidget);
    expect(locked.played, isEmpty);

    await tester.pumpWidget(const SizedBox());
    final h = GrammarHarness(episodeLink: 'A1-001');
    addTearDown(h.dispose);
    await h.pump(tester, _route);
    await h.next(tester, 5);
    expect(find.text('Bölüm: A Strange Message'), findsOneWidget);
    await tester.ensureVisible(key('open-link-A1-001'));
    await tester.tap(key('open-link-A1-001'));
    await h.settle(tester);
    expect(find.text('play:A1-001:null'), findsOneWidget);
  });

  testWidgets('kural kartı Defter\'e bir kez girer (FSRS kartıyla)', (
    tester,
  ) async {
    final h = GrammarHarness();
    addTearDown(h.dispose);
    await h.pump(tester, _route);
    await h.next(tester, 6);
    expect(
      find.text('Tek kişiden söz ederken fiile ek gelir.'),
      findsOneWidget,
    );
    await tester.ensureVisible(key('rule-add'));
    await tester.tap(key('rule-add'));
    await h.settle(tester);
    expect(find.text('Kural kartı defterine eklendi.'), findsOneWidget);
    final entries = await tester.runAsync(() => NotebookStore(h.db).entries());
    final e = entries!.single;
    expect(e.item.kind, NotebookKind.rule);
    expect(e.item.ruleTr, 'Tek kişiden söz ederken fiile ek gelir.');
    expect(notebookSourceLine(e.item), 'Dilbilgisi: Üçüncü tekil -s');
    expect(e.card.isNew, isTrue);

    // Yeniden açılınca (kalınan kart: kural) "zaten defterinde"; ikinci kayıt
    // yok.
    await tester.pumpWidget(const SizedBox());
    await h.pump(tester, _route);
    expect(key('lesson-card-c07'), findsOneWidget);
    expect(key('rule-add'), findsNothing);
    expect(find.text('Bu kural kartı zaten defterinde.'), findsOneWidget);
    final again = await tester.runAsync(() => NotebookStore(h.db).entries());
    expect(again, hasLength(1));
  });

  testWidgets('sessiz mod: ses çalmaz, ders tam okunur', (tester) async {
    final h = GrammarHarness();
    addTearDown(h.dispose);
    await h.pump(tester, _route);
    expect(h.audio.playing, isTrue);
    await tester.tap(key('lesson-sound'));
    await h.settle(tester);
    expect(h.audio.playing, isFalse);
    expect(key('lesson-listen'), findsNothing);
    expect(key('play-c01-ex1'), findsNothing);
    final opened = h.audio.opened.length;
    await h.next(tester, 2);
    expect(h.audio.opened, hasLength(opened));
    expect(key('example-c03-ex2'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('^He goes to school')), findsOneWidget);
  });

  testWidgets('sesi olmayan ders: düğmeler gizli, metin tam', (tester) async {
    final h = GrammarHarness(silent: true);
    addTearDown(h.dispose);
    await h.pump(tester, _route);
    expect(h.audio.opened, isEmpty);
    expect(key('lesson-listen'), findsNothing);
    expect(
      find.bySemanticsLabel(RegExp('^Bu cümlede ilginç bir şey var')),
      findsOneWidget,
    );
    expect(key('play-c01-ex1'), findsNothing);
  });

  testWidgets('İngilizce sesi eksik: örneğin çal düğmesi gizli, anlatım '
      'sesli', (tester) async {
    final h = GrammarHarness(noEnglishAudio: true);
    addTearDown(h.dispose);
    await h.pump(tester, _route);
    expect(h.audio.playing, isTrue);
    expect(key('lesson-listen'), findsOneWidget);
    expect(key('play-c01-ex1'), findsNothing);
    expect(key('example-c01-ex1'), findsOneWidget);
  });

  testWidgets('ders açılamazsa hata ve "Tekrar dene"', (tester) async {
    final h = GrammarHarness(grammarFails: true);
    addTearDown(h.dispose);
    await h.pump(tester, _route);
    expect(key('lesson-error'), findsOneWidget);
    h.source.grammarFails = false;
    await tester.tap(key('lesson-retry'));
    await h.settle(tester);
    expect(key('lesson-card-c01'), findsOneWidget);
  });

  testWidgets('hareketi azalt: kart geçişi anında', (tester) async {
    final h = GrammarHarness();
    addTearDown(h.dispose);
    await h.pump(tester, _route, reduceMotion: true);
    await tester.tap(key('lesson-next'));
    await tester.pump();
    await tester.pump();
    final pv = tester.widget<PageView>(key('lesson-pages'));
    expect(pv.controller!.page, 1.0);
    expect(find.text('Kart 2 / 7'), findsOneWidget);
  });
}
