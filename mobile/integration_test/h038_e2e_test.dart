// H-038 uçtan uca doğrulama (simülatör + yerel backend + Mailpit).
//
// Üç aşama, her biri ayrı `flutter drive` çalıştırması (aradaki veri
// kopyalama/silme işini kabuk betiği yapar, bkz. H-038 notları):
//   E2E_PHASE=1  A cihazı: hesapsız → hesap aç → ilk yükleme → değişiklik → eşitle
//   E2E_PHASE=2  B cihazı (veri silinmiş kurulum): giriş → veri geri gelir →
//                "Hi'nin kayıtlarını sil" → işaret sunucuda
//   E2E_PHASE=3  A cihazı yeniden: çekme → silme işareti uygulanır → çıkış
//
// Gerçek kullanıcı verisiyle çalışır; betik önce yedek alır, sonda geri koyar.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/app.dart';
import 'package:hivelzon/features/account/application/account_providers.dart';
import 'package:hivelzon/features/hi/application/hi_providers.dart';
import 'package:hivelzon/features/hi/data/hi_store.dart';
import 'package:hivelzon/features/notebook/application/notebook_providers.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';

const phase = int.fromEnvironment('E2E_PHASE', defaultValue: 1);
const email = String.fromEnvironment(
  'E2E_EMAIL',
  defaultValue: 'h038-e2e@example.com',
);
const mailpit = 'http://127.0.0.1:8027';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late WidgetTester t;

  void log(String s) => debugPrint('[H038-E2E] $s');

  Future<void> wait(Duration d) async {
    final end = DateTime.now().add(d);
    while (DateTime.now().isBefore(end)) {
      await t.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> waitFor(Finder f, {int seconds = 30}) async {
    final end = DateTime.now().add(Duration(seconds: seconds));
    while (DateTime.now().isBefore(end)) {
      await t.pump(const Duration(milliseconds: 200));
      if (f.evaluate().isNotEmpty) return;
    }
    throw TestFailure('Bulunamadı: $f');
  }

  Future<void> shot(String name) async {
    await wait(const Duration(milliseconds: 600));
    await binding.takeScreenshot(name);
  }

  /// Tembel listede aşağıda kalan öğe: görünene kadar kaydır.
  Future<void> reveal(Finder f) async {
    for (var i = 0; i < 20 && f.evaluate().isEmpty; i++) {
      final lists = find.byType(ListView);
      if (lists.evaluate().isEmpty) break;
      await t.drag(lists.first, const Offset(0, -300));
      await wait(const Duration(milliseconds: 300));
    }
  }

  Future<void> tap(Finder f) async {
    await reveal(f);
    await waitFor(f);
    await t.ensureVisible(f.first);
    await wait(const Duration(milliseconds: 300));
    await t.tap(f.first);
    await wait(const Duration(milliseconds: 700));
  }

  Future<void> tapKey(String key) => tap(find.byKey(ValueKey(key)));

  Future<void> tab(String label) => tap(
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label)),
  );

  /// Profil sekmesinin köküne dön (sekme yığınında açık sayfa kalmasın).
  Future<void> profileRoot() async {
    await tab('Profil');
    for (
      var i = 0;
      i < 4 && find.byType(BackButton).evaluate().isNotEmpty;
      i++
    ) {
      await tap(find.byType(BackButton));
    }
  }

  Future<String> codeFromMailpit(DateTime after) async {
    final end = DateTime.now().add(const Duration(seconds: 30));
    while (DateTime.now().isBefore(end)) {
      final r = await http.get(
        Uri.parse(
          '$mailpit/api/v1/search?query=${Uri.encodeQueryComponent('to:$email')}',
        ),
      );
      final msgs = (jsonDecode(r.body)['messages'] as List).cast<Map>();
      for (final m in msgs) {
        final created = DateTime.parse(m['Created'] as String);
        if (created.isAfter(after.subtract(const Duration(seconds: 5)))) {
          final code = RegExp(r'\b(\d{6})\b').firstMatch('${m['Snippet']}');
          if (code != null) return code.group(1)!;
        }
      }
      await wait(const Duration(seconds: 1));
    }
    throw TestFailure('Mailpit: kod gelmedi');
  }

  /// Sunucudaki satır sayıları (uygulamanın kendi oturumuyla, çekme ucundan).
  Future<Map<String, String>> serverCounts() async {
    final auth = container.read(authServiceProvider);
    final api = container.read(apiClientProvider);
    final counts = <String, int>{};
    final deleted = <String, int>{};
    var since = 0;
    while (true) {
      final r = await auth.authorized(
        (b) => api.send(
          'GET',
          '/api/v1/sync/pull',
          query: {'since': '$since', 'limit': '500'},
          bearer: b,
        ),
      );
      final changes = (r.map['changes'] as Map).cast<String, dynamic>();
      changes.forEach((table, rows) {
        for (final row in rows as List) {
          if ((row as Map)['deleted'] == true) {
            deleted[table] = (deleted[table] ?? 0) + 1;
          } else {
            counts[table] = (counts[table] ?? 0) + 1;
          }
        }
      });
      since = (r.map['nextSince'] as num).toInt();
      if (r.map['hasMore'] != true) break;
    }
    return {
      for (final k in {...counts.keys, ...deleted.keys})
        k: '${counts[k] ?? 0}${deleted[k] != null ? ' (+${deleted[k]} silme işareti)' : ''}',
    };
  }

  Future<Map<String, int>> localCounts() async {
    final db = container.read(appDatabaseProvider);
    final out = <String, int>{};
    for (final table in [
      'user_story_progress',
      'notebook_items',
      'review_cards',
      'review_logs',
      'learning_events',
      'hi_records',
      'speech_attempts',
      'sync_outbox',
    ]) {
      final r = await db
          .customSelect('SELECT count(*) AS n FROM $table')
          .getSingle();
      out[table] = r.read<int>('n');
    }
    return out;
  }

  Future<void> signIn({required bool expectSignup}) async {
    await tab('Profil');
    await tapKey('profile-account');
    await tapKey('account-email');
    await t.enterText(find.byKey(const ValueKey('sign-in-email')), email);
    final sentAt = DateTime.now().toUtc();
    await tapKey('sign-in-send');
    await waitFor(find.byKey(const ValueKey('sign-in-code')));
    await shot('p${phase}_code_sent');
    final code = await codeFromMailpit(sentAt);
    log('kod Mailpit\'ten okundu');
    await t.enterText(find.byKey(const ValueKey('sign-in-code')), code);
    if (expectSignup) {
      await waitFor(find.byKey(const ValueKey('sign-in-birth-year')));
      await t.enterText(
        find.byKey(const ValueKey('sign-in-birth-year')),
        '2000',
      );
      await wait(const Duration(milliseconds: 400));
      await shot('p${phase}_signup');
      for (final k in ['sign-in-terms', 'sign-in-privacy']) {
        await tap(
          find.descendant(
            of: find.byKey(ValueKey(k)),
            matching: find.byType(Checkbox),
          ),
        );
      }
      await shot('p${phase}_signup_filled');
      await tapKey('sign-in-create');
    }
    await waitFor(find.byKey(const ValueKey('sign-in-done')), seconds: 60);
    await shot('p${phase}_first_sync_done');
    await tapKey('sign-in-finish');
    await waitFor(find.byKey(const ValueKey('account-email-masked')));
    await shot('p${phase}_account_signed_in');
  }

  testWidgets('H-038 uçtan uca, aşama $phase', (tester) async {
    t = tester;
    container = ProviderContainer();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const HiVelzonApp(),
      ),
    );
    await wait(const Duration(seconds: 4));

    switch (phase) {
      case 0:
        // Yalnızca kurulum (betik ardından yedek veriyi kopyalar).
        log('kurulum tamam');
      case 1:
        expect(accountViewOf(container.read).signedIn, isFalse);
        log('A: hesapsız; yerel: ${await localCounts()}');
        await shot('p1_home_signed_out');
        await tab('Profil');
        await reveal(find.byKey(const ValueKey('profile-account')));
        await t.ensureVisible(find.byKey(const ValueKey('profile-account')));
        await shot('p1_profile_account_signed_out');
        await tapKey('profile-account');
        await shot('p1_account_signed_out');
        await tap(find.byType(BackButton));
        await wait(const Duration(seconds: 1));
        await tab('Ana Sayfa');
        log('A: GIRIS_BASLIYOR ${DateTime.now().toUtc().toIso8601String()}');
        await signIn(expectSignup: true);
        log('A: ilk yükleme sonrası yerel: ${await localCounts()}');
        log('A: sunucu: ${await serverCounts()}');

        // Değişiklik: deftere ifade, Hi kaydı, öğrenme olayı.
        await container.read(notebookStoreProvider).addItems([
          const NotebookItem(
            kind: NotebookKind.phrase,
            textEn: 'See you at the harbour.',
            textTr: 'Limanda görüşürüz.',
            contentId: 'A1-003',
            source: NotebookSource.userSaved,
          ),
        ]);
        await container
            .read(hiStoreProvider)
            .setBridgeState('e2e-order-coffee', BridgeState.done);
        await container
            .read(learningEventLogProvider)
            .record(
              LearningEvent(
                contentId: 'A1-003',
                sourceId: 's02-01',
                target: 'harbour',
                at: DateTime.now().toUtc(),
              ),
            );
        await tapKey('account-sync-now');
        await waitFor(find.text('Eşitlendi.'));
        await shot('p1_synced_again');
        log('A: değişiklik sonrası sunucu: ${await serverCounts()}');
        log('A: yerel: ${await localCounts()}');
      case 2:
        expect(accountViewOf(container.read).signedIn, isFalse);
        log('B: veri silinmiş kurulum; yerel: ${await localCounts()}');
        await shot('p2_home_empty');
        log('B: GIRIS_BASLIYOR ${DateTime.now().toUtc().toIso8601String()}');
        await signIn(expectSignup: false);
        log('B: giriş sonrası yerel: ${await localCounts()}');
        await tab('Ana Sayfa');
        await wait(const Duration(seconds: 2));
        await shot('p2_home_data_back');
        await profileRoot();
        await tapKey('profile-hi-privacy');
        await wait(const Duration(seconds: 1));
        await shot('p2_hi_privacy_before');
        await tapKey('hi-privacy-delete');
        await shot('p2_hi_delete_confirm');
        await tapKey('hi-privacy-confirm');
        await wait(const Duration(seconds: 4));
        await shot('p2_hi_privacy_after');
        // Gönderilmemiş bir şey kalmasın.
        await container.read(syncControllerProvider.notifier).syncNow();
        log('B: silme sonrası yerel: ${await localCounts()}');
        log('B: silme sonrası sunucu: ${await serverCounts()}');
        final db = container.read(appDatabaseProvider);
        final state = await db.select(db.syncState).getSingle();
        log('B: pendingSpeechDelete=${state.pendingSpeechDelete}');
      case 3:
        expect(accountViewOf(container.read).signedIn, isTrue);
        log('A: yeniden açıldı; yerel (çekmeden önce): ${await localCounts()}');
        await container.read(syncControllerProvider.notifier).syncNow();
        await wait(const Duration(seconds: 2));
        final local = await localCounts();
        log('A: çekme sonrası yerel: $local');
        final db = container.read(appDatabaseProvider);
        final kinds = await db.select(db.hiRecords).get();
        log(
          'A: hi_records: ${kinds.map((r) => '${r.kind}:${r.refId}').toList()}',
        );
        expect(local['learning_events'], 0);
        expect(local['speech_attempts'], 0);
        await profileRoot();
        await tapKey('profile-hi-privacy');
        await wait(const Duration(seconds: 1));
        await shot('p3_device_a_hi_privacy_after_reset');
        await tap(find.byType(BackButton));
        await wait(const Duration(seconds: 1));
        await tapKey('profile-account');
        await shot('p3_account_before_logout');
        await tapKey('account-sign-out');
        await tapKey('account-confirm-ok');
        await waitFor(find.byKey(const ValueKey('account-email')));
        await shot('p3_signed_out');
        expect(accountViewOf(container.read).signedIn, isFalse);
        log('A: çıkış sonrası yerel (veri kalır): ${await localCounts()}');
        await db.customUpdate(
          'UPDATE sync_state SET signed_out_reason = NULL',
          updates: {db.syncState},
        );
        expect(
          (await db.select(db.syncOutbox).get()).length,
          0,
          reason: 'çıkışta kuyruk boşalır',
        );
    }
    await wait(const Duration(seconds: 1));
  });
}
