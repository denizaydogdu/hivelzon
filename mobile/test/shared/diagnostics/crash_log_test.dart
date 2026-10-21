// H-043: yerel çökme kaydı. Kişisel veri yok (mesaj saklanmaz, yığın
// temizlenir), son 200 satır, atomik dosya, "verileri sil" ile silinir;
// paylaşım yalnızca kullanıcı dokununca.
import 'dart:io';
import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';
import 'package:hivelzon/features/profile/presentation/crash_log_row.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/diagnostics/crash_log.dart';
import 'package:hivelzon/shared/diagnostics/crash_reporting.dart';

class _Boom implements Exception {
  _Boom(this.message);
  final String message;
  @override
  String toString() => message;
}

void main() {
  late Directory dir;
  var t = DateTime.utc(2026, 10, 21, 9);
  CrashLog make() => CrashLog(
    directory: () async => dir,
    appVersion: '0.1.0+7',
    clock: () => t,
  );

  setUp(() {
    dir = Directory.systemTemp.createTempSync('hv_crash_');
    t = DateTime.utc(2026, 10, 21, 9);
  });
  tearDown(() => dir.deleteSync(recursive: true));

  group('temizleme', () {
    test('adres, e-posta, belirteç, kimlik ve kullanıcı klasörü gider', () {
      const raw =
          'GET https://api.hi.velzon.tr/v1/sync?token=abc failed for '
          'deniz@example.com Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0In0.x9 '
          'id 123e4567-e89b-12d3-a456-426614174000 '
          '/Users/deniz/Library/x key=sk_live_51HxYz9876543210abcdef';
      final s = scrubDiagnosticText(raw);
      expect(s, isNot(contains('velzon.tr')));
      expect(s, isNot(contains('deniz@example.com')));
      expect(s, isNot(contains('eyJhbGciOiJIUzI1NiJ9')));
      expect(s, isNot(contains('123e4567')));
      expect(s, isNot(contains('/Users/deniz')));
      expect(s, isNot(contains('sk_live')));
      expect(s, contains('<adres>'));
      expect(s, contains('<e-posta>'));
    });

    test('kod konumları korunur', () {
      const frame =
          '#0      ReviewScreen._load (package:hivelzon/features/notebook/'
          'presentation/review_screen.dart:112:7)';
      expect(scrubDiagnosticText(frame), frame);
    });

    test('yığın en fazla 8 satır, satırlar kısaltılır', () {
      final frames = List.generate(
        20,
        (i) => '#$i  f$i (package:x/y.dart:$i:1)',
      ).join('\n');
      final stack = StackTrace.fromString('$frames\n#20 ${'a' * 400}');
      final lines = CrashLog.trimStack(stack);
      expect(lines, hasLength(CrashLog.maxFrames));
      expect(
        CrashLog.trimStack(StackTrace.fromString('x' * 400)).single.length,
        lessThanOrEqualTo(CrashLog.maxLineLength),
      );
    });
  });

  group('kayıt', () {
    test('satır: etiket, tür, yığın, sürüm, UTC; mesaj saklanmaz', () async {
      final log = make();
      await log.record(
        'zone',
        _Boom('deniz@example.com yazdı: "merhaba benim adım Deniz"'),
        StackTrace.fromString('#0 main (package:hivelzon/main.dart:1:1)'),
      );
      final e = (await log.entries()).single;
      expect(e.tag, 'zone');
      expect(e.type, '_Boom');
      expect(e.version, '0.1.0+7');
      expect(e.at, DateTime.utc(2026, 10, 21, 9));
      expect(e.stack.single, contains('package:hivelzon/main.dart'));
      final text = (await log.exportText())!;
      expect(text, isNot(contains('deniz')));
      expect(text, isNot(contains('merhaba')));
      final file = File('${dir.path}/diagnostics/crash_log.json');
      expect(file.readAsStringSync(), isNot(contains('deniz')));
    });

    test('son 200 satır tutulur; yeni örnek dosyadan okur', () async {
      final log = make();
      for (var i = 0; i < 205; i++) {
        t = t.add(const Duration(seconds: 1));
        await log.record(
          'flutter',
          StateError('x'),
          StackTrace.fromString('#0 f$i (package:x/y.dart:$i:1)'),
        );
      }
      final all = await make().entries();
      expect(all, hasLength(CrashLog.capacity));
      expect(all.first.stack.single, contains('f5 '));
      expect(all.last.stack.single, contains('f204 '));
      expect(
        File('${dir.path}/diagnostics/crash_log.json.tmp').existsSync(),
        isFalse,
      );
    });

    test('art arda aynı hata tek satırda sayılır', () async {
      final log = make();
      final st = StackTrace.fromString('#0 build (package:x/y.dart:1:1)');
      for (var i = 0; i < 50; i++) {
        await log.record('flutter', StateError('x'), st);
      }
      final all = await log.entries();
      expect(all, hasLength(1));
      expect(all.single.count, 50);
      expect((await log.exportText())!, contains('×50'));
    });

    test('bozuk dosya: baştan başlanır, fırlatmaz', () async {
      Directory('${dir.path}/diagnostics').createSync();
      File(
        '${dir.path}/diagnostics/crash_log.json',
      ).writeAsStringSync('{bozuk');
      final log = make();
      expect(await log.entries(), isEmpty);
      await log.record('zone', StateError('x'), null);
      expect(await log.entries(), hasLength(1));
    });

    test('klasöre ulaşılamazsa kayıt sessizce düşer (fırlatmaz)', () async {
      final log = CrashLog(
        directory: () async => throw const FileSystemException('yok'),
        appVersion: '0.1.0+1',
      );
      await log.record('zone', StateError('x'), null);
      await log.clear();
    });

    test('silme: satırlar ve dosya gider; boşken paylaşım metni yok', () async {
      final log = make();
      await log.record('zone', StateError('x'), null);
      await log.clear();
      expect(await log.entries(), isEmpty);
      expect(await log.exportText(), isNull);
      expect(
        File('${dir.path}/diagnostics/crash_log.json').existsSync(),
        isFalse,
      );
    });
  });

  group('yakalama', () {
    // Sahte zaman yok (gerçek dosya yazımı): düz `test`.
    test('Flutter, platform ve bölge hataları kayda yazılır', () async {
      final log = make();
      final before = FlutterError.onError;
      final dispatcher = PlatformDispatcher.instance;
      final prevPlatform = dispatcher.onError;
      final seen = <FlutterErrorDetails>[];
      FlutterError.onError = seen.add;
      addTearDown(() {
        FlutterError.onError = before;
        dispatcher.onError = prevPlatform;
      });
      CrashReporting.install(log, release: false);
      FlutterError.onError!(
        FlutterErrorDetails(
          exception: StateError('çizim'),
          stack: StackTrace.fromString('#0 a (package:x/y.dart:1:1)'),
        ),
      );
      expect(seen, hasLength(1));
      final handled = dispatcher.onError!(
        ArgumentError('platform'),
        StackTrace.empty,
      );
      expect(handled, isTrue);
      CrashReporting.onZoneError(UnsupportedError('bölge'), StackTrace.empty);
      final all = await log.entries();
      expect(all.map((e) => e.tag), ['flutter', 'platform', 'zone']);
    });
  });

  group('sakin hata kutusu', () {
    for (final (w, h) in [(320.0, 568.0), (120.0, 40.0)]) {
      testWidgets('$w × $h, metin 1,3×: taşma yok, ekran okuyucu etiketi', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        tester.view.physicalSize = Size(w, h) * 2;
        tester.view.devicePixelRatio = 2;
        tester.platformDispatcher.textScaleFactorTestValue = 1.3;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await tester.pumpWidget(const CalmErrorBox());
        expect(tester.takeException(), isNull);
        expect(find.bySemanticsLabel(CrashTexts.errorBoxTitle), findsOneWidget);
        if (w > 200) expect(find.text(CrashTexts.errorBoxBody), findsOneWidget);
        handle.dispose();
      });
    }
  });

  group('Profil → Hata kaydını paylaş', () {
    // Dosya okuma gerçek G/Ç: gerçek ve sahte zaman sırayla ilerler.
    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 10; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 5)),
        );
        await tester.pump();
      }
    }

    Future<List<String>> pumpRow(WidgetTester tester, CrashLog log) async {
      final shared = <String>[];
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            crashLogProvider.overrideWithValue(log),
            crashLogSharerProvider.overrideWithValue(
              (text, origin) async => shared.add(text),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(body: CrashLogShareRow()),
          ),
        ),
      );
      return shared;
    }

    testWidgets('kayıt yoksa sakin not; paylaşım açılmaz', (tester) async {
      final shared = await pumpRow(tester, make());
      await tester.tap(find.text(CrashTexts.shareRow));
      await settle(tester);
      expect(shared, isEmpty);
      expect(find.text(CrashTexts.shareEmpty), findsOneWidget);
    });

    testWidgets('kayıt varsa yalnız dokununca, düz metin paylaşılır', (
      tester,
    ) async {
      final log = make();
      await tester.runAsync(
        () => log.record('zone', StateError('x'), StackTrace.empty),
      );
      final shared = await pumpRow(tester, log);
      expect(shared, isEmpty);
      await tester.tap(find.text(CrashTexts.shareRow));
      await settle(tester);
      expect(shared, hasLength(1));
      expect(shared.single, contains('[zone] StateError · 0.1.0+7'));
    });
  });
}
