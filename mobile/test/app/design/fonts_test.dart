import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/app/theme.dart';

import '../../support/app_fonts.dart';

/// TrueType `cmap` tablosundan (biçim 4 ya da 12) kod noktalarının glif
/// karşılığı var mı? Küçük ve bağımsız ayrıştırıcı: yazı tipi değişirse
/// Türkçe karakterlerin düşmediğini garanti eder.
Set<int> _mappedCodePoints(Uint8List bytes, Iterable<int> wanted) {
  final d = ByteData.sublistView(bytes);
  final numTables = d.getUint16(4);
  var cmap = -1;
  for (var i = 0; i < numTables; i++) {
    final rec = 12 + i * 16;
    final tag = String.fromCharCodes(bytes.sublist(rec, rec + 4));
    if (tag == 'cmap') cmap = d.getUint32(rec + 8);
  }
  expect(cmap, isNot(-1), reason: 'cmap tablosu yok');
  final found = <int>{};
  final n = d.getUint16(cmap + 2);
  for (var i = 0; i < n; i++) {
    final platform = d.getUint16(cmap + 4 + i * 8);
    final encoding = d.getUint16(cmap + 6 + i * 8);
    if (platform != 3 || (encoding != 1 && encoding != 10)) continue;
    final sub = cmap + d.getUint32(cmap + 8 + i * 8);
    final format = d.getUint16(sub);
    for (final cp in wanted) {
      if (format == 4 && cp <= 0xFFFF) {
        final segX2 = d.getUint16(sub + 6);
        final ends = sub + 14;
        final starts = ends + segX2 + 2;
        final deltas = starts + segX2;
        final offsets = deltas + segX2;
        for (var s = 0; s < segX2 ~/ 2; s++) {
          final end = d.getUint16(ends + s * 2);
          if (cp > end) continue;
          final start = d.getUint16(starts + s * 2);
          if (cp < start) break;
          final delta = d.getUint16(deltas + s * 2);
          final ro = d.getUint16(offsets + s * 2);
          int glyph;
          if (ro == 0) {
            glyph = (cp + delta) & 0xFFFF;
          } else {
            final at = offsets + s * 2 + ro + (cp - start) * 2;
            final g = d.getUint16(at);
            glyph = g == 0 ? 0 : (g + delta) & 0xFFFF;
          }
          if (glyph != 0) found.add(cp);
          break;
        }
      } else if (format == 12) {
        final groups = d.getUint32(sub + 12);
        for (var g = 0; g < groups; g++) {
          final at = sub + 16 + g * 12;
          if (cp >= d.getUint32(at) && cp <= d.getUint32(at + 4)) {
            found.add(cp);
            break;
          }
        }
      }
    }
  }
  return found;
}

const _turkish = 'çğıİöşüâÂÇĞÖŞÜîÎûÛ';

void main() {
  for (final path in [
    'assets/fonts/inter/Inter-Regular.ttf',
    'assets/fonts/inter/Inter-Medium.ttf',
    'assets/fonts/inter/Inter-Bold.ttf',
    'assets/fonts/nunito/Nunito-Regular.ttf',
    'assets/fonts/nunito/Nunito-Medium.ttf',
    'assets/fonts/nunito/Nunito-Bold.ttf',
  ]) {
    test('Türkçe karakterler: $path', () {
      final wanted = _turkish.runes.toSet();
      final found = _mappedCodePoints(File(path).readAsBytesSync(), wanted);
      final missing = wanted.difference(found).map(String.fromCharCode);
      expect(missing, isEmpty);
      // Ayrıştırıcının kendisi de denetlenir: Tibet harfi bu yazı tiplerinde yok.
      expect(
        _mappedCodePoints(File(path).readAsBytesSync(), [0x0F00]),
        isEmpty,
      );
    });
  }

  test('lisans dosyaları paketle birlikte (OFL)', () {
    for (final p in [
      'assets/fonts/inter/OFL.txt',
      'assets/fonts/nunito/OFL.txt',
    ]) {
      expect(File(p).readAsStringSync(), contains('SIL Open Font License'));
    }
  });

  testWidgets('tema: başlık Nunito 700, metin Inter, yalnız 400/500/700', (
    tester,
  ) async {
    final t = AppTheme.light().textTheme;
    for (final s in [t.headlineSmall, t.titleLarge, t.titleMedium]) {
      expect(s?.fontFamily, AppFonts.heading);
      expect(s?.fontWeight, FontWeight.w700);
    }
    for (final s in [t.bodyLarge, t.bodyMedium, t.labelLarge]) {
      expect(s?.fontFamily, AppFonts.body);
    }
    for (final s in [
      t.displayLarge, t.displayMedium, t.displaySmall, t.headlineLarge,
      t.headlineMedium, t.headlineSmall, t.titleLarge, t.titleMedium,
      t.titleSmall, t.bodyLarge, t.bodyMedium, t.bodySmall, t.labelLarge,
      t.labelMedium, t.labelSmall, //
    ]) {
      expect([
        FontWeight.w400,
        FontWeight.w500,
        FontWeight.w700,
      ], contains(s?.fontWeight));
      expect(s!.fontSize!, greaterThanOrEqualTo(12));
    }
  });

  testWidgets('Türkçe metin gerçek yazı tipiyle çizilir (Inter ≠ Nunito)', (
    tester,
  ) async {
    await loadAppFonts();
    const text = 'Çığlık öğrenci İzmir şâir';
    double widthOf(String family) {
      final p = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(fontFamily: family, fontSize: 20),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      return p.width;
    }

    final inter = widthOf('Inter');
    final nunito = widthOf('Nunito');
    // FlutterTest yazı tipinde her glif 1 em (20 px) olurdu.
    expect(inter, isNot(closeTo(text.length * 20.0, 0.5)));
    expect(nunito, isNot(closeTo(inter, 0.5)));
  });

  testWidgets('uygulama açık temaya sabit', (tester) async {
    final src = File('lib/app/app.dart').readAsStringSync();
    expect(src, contains('themeMode: ThemeMode.light'));
  });
}
