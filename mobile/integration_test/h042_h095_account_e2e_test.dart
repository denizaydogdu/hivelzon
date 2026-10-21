// H-042 + H-095 uçtan uca doğrulama: geçici simülatör + yalıtılmış backend
// (port 8090, veritabanı hivelzon_e2e) + Mailpit (8027). Pilot ortamına
// dokunmaz. Betik: `integration_test/h042_h095_account_e2e.sh`.
//
// Her aşama ayrı `flutter drive` çalıştırmasıdır; aradaki kurulum silme işini
// betik yapar:
//   E2E_PHASE=1  temiz kurulum: hesapsız → A hesabını aç (taslak-2) →
//                deftere ifade + olay → "Şimdi eşitle" → sunucuda var
//   E2E_PHASE=2  temiz kurulum, eski uygulama (TERMS_VERSION=taslak-1):
//                açılış taslak-1 ile bitmiş → B hesabını aç (taslak-1) → eşitle
//   E2E_PHASE=3  aynı kurulum, güncel uygulama (taslak-2): B oturumu açık;
//                "metin güncellendi" kartı bir kez, onay istenmez, /me 200,
//                eşitleme sürer
//   E2E_PHASE=4  temiz kurulum: A ile giriş (veri gelir) → hesabı sil →
//                çıkış + "silinmek üzere" kartı ve tarih → yeni kodla giriş →
//                geri al → kart ve işaret yok, veri sunucuda
//   E2E_PHASE=5  temiz kurulum: A ile giriş → geri alınmış hesabın verisi gelir
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/app.dart';
import 'package:hivelzon/features/account/application/account_providers.dart';
import 'package:hivelzon/features/notebook/application/notebook_providers.dart';
import 'package:hivelzon/features/notebook/domain/notebook_item.dart';
import 'package:hivelzon/features/onboarding/application/onboarding_providers.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/meaning/learning_event_log.dart';
import 'package:hivelzon/shared/storage/app_database.dart';
import 'package:hivelzon/shared/storage/storage_providers.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';

const phase = int.fromEnvironment('E2E_PHASE', defaultValue: 1);
const email = String.fromEnvironment('E2E_EMAIL');
const mailpit = 'http://127.0.0.1:8027';

const phraseA = 'H042 e2e: see you at the harbour.';
const phraseB1 = 'H095 e2e: old texts, still syncing.';
const phraseB2 = 'H095 e2e: synced after the update.';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late WidgetTester t;

  void log(String s) => debugPrint('[H042-E2E] p$phase $s');

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
    await binding.takeScreenshot('p${phase}_$name');
  }

  Future<void> reveal(Finder f) async {
    for (var i = 0; i < 20 && f.evaluate().isEmpty; i++) {
      final lists = find.byType(Scrollable);
      if (lists.evaluate().isEmpty) break;
      await t.drag(lists.first, const Offset(0, -300));
      await wait(const Duration(milliseconds: 300));
    }
  }

  Future<void> tap(Finder f) async {
    await reveal(f);
    await waitFor(f);
    // Ortaya kaydır: kenarda kalırsa sabit başlığın altında kalıp dokunuş
    // başka yere gidebiliyor.
    final el = f.evaluate().first;
    if (Scrollable.maybeOf(el) != null) {
      unawaited(Scrollable.ensureVisible(el, alignment: 0.5));
    }
    await wait(const Duration(milliseconds: 500));
    await t.tap(f.first);
    await wait(const Duration(milliseconds: 700));
  }

  Future<void> tapKey(String key) => tap(find.byKey(ValueKey(key)));

  Future<void> tab(String label) => tap(
    find.descendant(of: find.byType(NavigationBar), matching: find.text(label)),
  );

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
        if (created.isAfter(after.subtract(const Duration(seconds: 2)))) {
          final code = RegExp(r'\b(\d{6})\b').firstMatch('${m['Snippet']}');
          if (code != null) return code.group(1)!;
        }
      }
      await wait(const Duration(seconds: 1));
    }
    throw TestFailure('Mailpit: kod gelmedi');
  }

  Future<dynamic> apiGet(String path) async {
    final auth = container.read(authServiceProvider);
    final api = container.read(apiClientProvider);
    final r = await auth.authorized(
      (b) => api.send('GET', path, bearer: b),
    );
    // /me e-posta içerir: loga yalnızca durum yazılır.
    final body = path == '/api/v1/me'
        ? 'status=${r.map['status']} scheduledPurgeAt=${r.map['scheduledPurgeAt']}'
        : jsonEncode(r.json);
    log('GET $path → HTTP ${r.status} $body');
    expect(r.status, 200);
    return r.json;
  }

  /// Sunucudaki satırlar (uygulamanın kendi oturumuyla, çekme ucundan).
  Future<({Map<String, int> counts, String raw})> server() async {
    final auth = container.read(authServiceProvider);
    final api = container.read(apiClientProvider);
    final counts = <String, int>{};
    final raw = StringBuffer();
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
      expect(r.status, 200);
      final changes = (r.map['changes'] as Map).cast<String, dynamic>();
      raw.write(jsonEncode(changes));
      changes.forEach((table, rows) {
        for (final row in rows as List) {
          if ((row as Map)['deleted'] != true) {
            counts[table] = (counts[table] ?? 0) + 1;
          }
        }
      });
      since = (r.map['nextSince'] as num).toInt();
      if (r.map['hasMore'] != true) break;
    }
    log('sunucu (pull): $counts');
    return (counts: counts, raw: raw.toString());
  }

  Future<List<String>> localPhrases() async {
    final db = container.read(appDatabaseProvider);
    final rows = await db
        .customSelect('SELECT text_en FROM notebook_items')
        .get();
    final out = rows.map((r) => r.read<String>('text_en')).toList();
    log('yerel defter: $out');
    return out;
  }

  Future<void> setMeta(String key, String value) async {
    final db = container.read(appDatabaseProvider);
    await db
        .into(db.appMeta)
        .insertOnConflictUpdate(
          AppMetaCompanion.insert(key: key, value: value),
        );
  }

  Future<void> addLearning(String phrase) async {
    await container.read(notebookStoreProvider).addItems([
      NotebookItem(
        kind: NotebookKind.phrase,
        textEn: phrase,
        textTr: 'e2e',
        contentId: 'A1-003',
        source: NotebookSource.userSaved,
      ),
    ]);
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
  }

  Future<void> openAccount() async {
    await tab('Profil');
    await tapKey('profile-account');
  }

  /// Hesap ekranındayken: e-posta + kod (+ kayıt bilgileri) → bitti.
  Future<void> codeFlow({
    required bool expectSignup,
    bool expectRestore = false,
    String? restoreDate,
  }) async {
    await waitFor(find.byKey(const ValueKey('sign-in-email')));
    await t.enterText(find.byKey(const ValueKey('sign-in-email')), email);
    final sentAt = DateTime.now().toUtc();
    await tapKey('sign-in-send');
    await waitFor(find.byKey(const ValueKey('sign-in-code')));
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
      for (final k in ['sign-in-terms', 'sign-in-privacy']) {
        await tap(
          find.descendant(
            of: find.byKey(ValueKey(k)),
            matching: find.byType(Checkbox),
          ),
        );
      }
      await shot('signup_filled');
      await tapKey('sign-in-create');
    }
    if (expectRestore) {
      await waitFor(find.byKey(const ValueKey('sign-in-restore')));
      expect(find.text(AccountTexts.restoreBody(restoreDate!)), findsOneWidget);
      await shot('restore_step');
      await tapKey('sign-in-restore');
    }
    await waitFor(find.byKey(const ValueKey('sign-in-done')), seconds: 60);
    await shot('sign_in_done');
    await tapKey('sign-in-finish');
    await waitFor(find.byKey(const ValueKey('account-email-masked')));
  }

  testWidgets('H-042/H-095 uçtan uca, aşama $phase', (tester) async {
    expect(email, isNotEmpty, reason: 'E2E_EMAIL gerekli');
    t = tester;
    container = ProviderContainer(
      overrides: [onboardingGateProvider.overrideWith(_DoneOnboardingGate.new)],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const HiVelzonApp(),
      ),
    );
    await wait(const Duration(seconds: 4));
    final config = container.read(apiConfigProvider);
    log(
      'API ${config.baseUrl} metin sürümü ${config.termsVersion}/'
      '${config.privacyNoticeVersion}',
    );
    expect(config.baseUrl.port, 8090, reason: 'yalıtılmış backend');

    switch (phase) {
      case 1:
        expect(accountViewOf(container.read).signedIn, isFalse);
        await shot('home_signed_out');
        await openAccount();
        await shot('account_signed_out');
        await tapKey('account-email');
        await codeFlow(expectSignup: true);
        await shot('account_signed_in');
        final c = await apiGet('/api/v1/me/consents');
        log('rıza durumu: ${jsonEncode(c)}');
        await addLearning(phraseA);
        await tapKey('account-sync-now');
        await waitFor(find.text('Eşitlendi.'));
        await shot('synced');
        final s = await server();
        expect(s.raw, contains(phraseA), reason: 'defter sunucuda');
        expect(s.counts['notebook_items'], greaterThanOrEqualTo(1));
        expect(s.counts['learning_events'], greaterThanOrEqualTo(1));
        await apiGet('/api/v1/me');

      case 2:
        // Eski uygulama: açılış taslak-1 bilgilendirmesiyle bitmiş.
        expect(config.termsVersion, 'taslak-1');
        await setMeta('onboarding.completedAt', '2026-10-14T10:00:00Z');
        await setMeta('onboarding.noticeVersion', 'taslak-1');
        await openAccount();
        await tapKey('account-email');
        await codeFlow(expectSignup: true);
        await shot('old_app_signed_in');
        await addLearning(phraseB1);
        await container.read(syncControllerProvider.notifier).syncNow();
        final s = await server();
        expect(s.raw, contains(phraseB1));

      case 3:
        // Güncel uygulama, aynı kurulum: B (taslak-1) oturumu açık.
        expect(config.termsVersion, 'taslak-2');
        expect(accountViewOf(container.read).signedIn, isTrue);
        await tab('Ana Sayfa');
        await waitFor(find.byKey(const ValueKey('home-legal-update')));
        await t.ensureVisible(find.byKey(const ValueKey('home-legal-update')));
        await shot('home_legal_update_card');
        expect(
          find.text(AccountTexts.legalUpdateTitle(terms: true, privacy: true)),
          findsOneWidget,
        );
        // Yeniden onay yok: onay kutusu yok.
        expect(find.byType(Checkbox), findsNothing);
        final me = await apiGet('/api/v1/me');
        expect(me['status'] ?? me['accountStatus'], 'ACTIVE');
        final c = await apiGet('/api/v1/me/consents');
        log('rıza durumu (eski sürüm): ${jsonEncode(c)}');
        final before = (await server()).counts['notebook_items'] ?? 0;
        await addLearning(phraseB2);
        await container.read(syncControllerProvider.notifier).syncNow();
        final s = await server();
        expect(s.raw, contains(phraseB2), reason: 'eşitleme durmadı');
        expect(s.counts['notebook_items'], before + 1);
        final ui = container.read(syncControllerProvider);
        log('eşitleme durumu: $ui');
        await openAccount();
        await shot('account_after_sync');
        await tab('Ana Sayfa');
        await waitFor(find.byKey(const ValueKey('home-legal-update')));
        await tapKey('home-legal-update-dismiss');
        await wait(const Duration(seconds: 1));
        expect(find.byKey(const ValueKey('home-legal-update')), findsNothing);
        await shot('home_after_dismiss');

      case 4:
        expect(accountViewOf(container.read).signedIn, isFalse);
        await openAccount();
        await tapKey('account-email');
        await codeFlow(expectSignup: false);
        await wait(const Duration(seconds: 2));
        expect(await localPhrases(), contains(phraseA), reason: 'veri geldi');
        final before = await server();
        await shot('account_before_delete');

        // Sil.
        await tapKey('account-delete');
        await shot('delete_confirm');
        await tapKey('account-confirm-ok');
        await waitFor(
          find.byKey(const ValueKey('account-pending-deletion-signed-out')),
        );
        expect(accountViewOf(container.read).signedIn, isFalse);
        final marker = await container.read(syncStoreProvider).pendingDeletion();
        expect(marker, isNotNull, reason: 'cihazda silme işareti');
        log('işaret: userId=${marker!.userId} purgeAt=${marker.purgeAt}');
        final days = marker.purgeAt.difference(DateTime.now().toUtc()).inDays;
        log('kalıcı silmeye gün: $days');
        expect(days, inInclusiveRange(29, 30));
        final date = AccountTexts.date(marker.purgeAt);
        expect(
          find.text(AccountTexts.signedOutPendingBody(date)),
          findsOneWidget,
        );
        await shot('signed_out_pending_card');
        // Veri cihazda kalır.
        expect(await localPhrases(), contains(phraseA));

        // Yeni kodla giriş → geri al.
        await tapKey('account-restore-signed-out');
        expect(find.text(AccountTexts.restoreWhyCode), findsOneWidget);
        await shot('restore_why_code');
        await codeFlow(
          expectSignup: false,
          expectRestore: true,
          restoreDate: date,
        );
        await shot('account_restored');
        expect(
          find.byKey(const ValueKey('account-pending-deletion-signed-out')),
          findsNothing,
        );
        expect(
          find.byKey(const ValueKey('account-pending-deletion')),
          findsNothing,
        );
        expect(
          await container.read(syncStoreProvider).pendingDeletion(),
          isNull,
        );
        final me = await apiGet('/api/v1/me');
        expect(me['status'] ?? me['accountStatus'], 'ACTIVE');
        final after = await server();
        expect(after.raw, contains(phraseA));
        expect(after.counts['notebook_items'], before.counts['notebook_items']);
        expect(
          after.counts['learning_events'],
          before.counts['learning_events'],
        );

      case 5:
        expect(accountViewOf(container.read).signedIn, isFalse);
        expect(await localPhrases(), isEmpty, reason: 'temiz kurulum');
        await openAccount();
        expect(
          find.byKey(const ValueKey('account-pending-deletion-signed-out')),
          findsNothing,
        );
        await tapKey('account-email');
        await codeFlow(expectSignup: false);
        await wait(const Duration(seconds: 2));
        expect(await localPhrases(), contains(phraseA), reason: 'veri geldi');
        await shot('fresh_device_data_back');
    }
    await wait(const Duration(seconds: 1));
  });
}

/// Bu test açılışı (H-039) sınamaz: kapı bitmiş sayılır.
class _DoneOnboardingGate extends OnboardingGateNotifier {
  @override
  OnboardingGate build() => OnboardingGate.done;
}
