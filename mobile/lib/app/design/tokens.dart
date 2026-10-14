import 'package:flutter/material.dart';

/// hiVelzon tasarım belirteçleri v2 (H-057, `tasarim/README.md`).
///
/// Renk, boşluk, köşe, gölge, ikon boyutu ve hareket değerlerinin **tek
/// kaynağı** budur. `lib/app/design/` ve `lib/app/theme.dart` dışında sabit
/// renk (`Color(0x…)`) ya da `fontSize:` yazılmaz
/// (`test/app/design/style_literals_guard_test.dart` denetler).
///
/// Kıyı paleti: deniz mavisi, fener sarısı, kum, akşam turuncusu.
abstract final class AppPalette {
  // Deniz mavisi (birincil).
  static const Color seaBlue50 = Color(0xFFEAF1F8);
  static const Color seaBlue100 = Color(0xFFDCE8F3);
  static const Color seaBlue200 = Color(0xFFB4CCE3);
  static const Color seaBlue300 = Color(0xFF7FA6CB);
  static const Color seaBlue = Color(0xFF1F4E79);
  static const Color seaBlue700 = Color(0xFF173D60);
  static const Color seaBlue900 = Color(0xFF0E2840);

  // Fener sarısı (ana eylem).
  static const Color yellow50 = Color(0xFFFFFBEF);
  static const Color yellow100 = Color(0xFFFFF4C9);
  static const Color yellow200 = Color(0xFFFBE3A0);
  static const Color lighthouseYellow = Color(0xFFF2B33D);
  static const Color yellow700 = Color(0xFFC98A12);

  // Kum (zemin).
  static const Color sand50 = Color(0xFFFCF9F3);
  static const Color sand = Color(0xFFF7F1E6);
  static const Color sand200 = Color(0xFFEFE5D2);
  static const Color sand300 = Color(0xFFE4D8BE);
  static const Color sand500 = Color(0xFFCDBB9A);

  // Akşam turuncusu (küçük vurgular).
  static const Color orange50 = Color(0xFFFDF0E4);
  static const Color orange100 = Color(0xFFFADDC2);
  static const Color eveningOrange = Color(0xFFE98A3C);

  /// Turuncu metin: kum ve beyaz üstünde AA (≥ 4,5:1).
  static const Color orange700 = Color(0xFFA9530F);

  // Mürekkep (nötr). Saf siyah yok.
  static const Color ink = Color(0xFF2B2B2B);
  static const Color ink700 = Color(0xFF4A4A4A);

  /// İkincil metin: kum üstünde AA.
  static const Color ink500 = Color(0xFF66615A);
  static const Color ink300 = Color(0xFFA29C92);
  static const Color ink200 = Color(0xFFD3CCC0);
  static const Color ink100 = Color(0xFFE9E3D8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Anlamsal renkler: ön plan (metin/ikon; beyaz ve yüzey üstünde AA) +
  // açık yüzey.
  static const Color success = Color(0xFF276B43);
  static const Color successSurface = Color(0xFFE6F3EA);
  static const Color warning = Color(0xFF8A5A00);
  static const Color warningSurface = Color(0xFFFFF4D6);
  static const Color info = seaBlue;
  static const Color infoSurface = seaBlue50;
  static const Color danger = Color(0xFFB3261E);
  static const Color dangerSurface = Color(0xFFFBE9E7);
}

/// Oynatıcı ve medya katmanlarının perde (scrim) renkleri: videonun üstünde
/// okunurluk için.
abstract final class AppScrim {
  /// Oynatıcı zemini (video yüklenirken).
  static const Color playerBackground = Color(0xFF101418);

  /// Altyazı ve kontrol kutusu (yarı saydam koyu).
  static const Color captionBox = Color(0xCC1B1B1B);

  /// Altyazının Türkçe satırı (beyaz, %90).
  static const Color captionText = Color(0xE6FFFFFF);

  /// Güçlü perde (karar anı, duraklatma).
  static const Color strong = Color(0x99000000);

  /// Görsel üstü yazı için alttan koyulaşan geçişin koyu ucu.
  static const Color gradientEnd = Color(0xB3000000);

  /// Video üstündeki yazının gölgesi.
  static const Color textShadow = Color(0x99000000);

  /// Panel ve kart gölgesi (oynatıcı üstünde, belirgin).
  static const Color panelShadow = Color(0x33000000);

  /// Kart gölgesi (video üstünde, daha koyu).
  static const Color cardShadow = Color(0x40000000);

  /// Haritadaki rozet gölgesi.
  static const Color badgeShadow = Color(0x55000000);
}

/// Hikâye haritasının renkleri (H-060): kodla çizilen yedek harita ve bölüm
/// düğümleri. Harita görseli yokken ya da açılamazken kullanılır.
abstract final class AppMapColors {
  /// Deniz (yüzey) ve derin deniz.
  static const Color sea = Color(0xFF2E6A9A);
  static const Color seaDeep = AppPalette.seaBlue;

  /// Kara, tepe ve tepe sırtı.
  static const Color land = Color(0xFFE9DCC2);
  static const Color hill = Color(0xFF8FA876);
  static const Color hillDark = Color(0xFF6F8C5C);

  /// Fenerin kırmızı bandı.
  static const Color lighthouseBand = Color(0xFFC0392B);

  /// Kilitli düğüm (soğuk gri; haritanın sıcak tonlarından ayrışır) ve
  /// kilit rozeti.
  static const Color nodeLocked = Color(0xFF5B6470);
  static const Color badgeLocked = Color(0xFF3A414A);

  /// Biten bölümün onay rozeti.
  static const Color badgeDone = AppPalette.success;

  /// Devam eden bölümün rozeti.
  static const Color badgeInProgress = AppPalette.eveningOrange;
}

/// Boşluklar: 4 px temelli, 8 px ızgara.
abstract final class AppSpace {
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s48 = 48;
  static const double s64 = 64;

  /// Sayfa yan boşluğu.
  static const double page = s16;
}

/// Köşe yarıçapları.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 20;

  /// Hap (pill) düğme ve rozetler.
  static const double full = 999;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius sheetTop = BorderRadius.vertical(
    top: Radius.circular(lg),
  );
}

/// Yumuşak gölge ölçeği (3 seviye). Gölge mürekkep renginden, düşük
/// opaklıkla; kum zeminde kartı belli belirsiz kaldırır.
abstract final class AppShadows {
  static const Color _tone = Color(0xFF3A3020);

  /// Kartlar, satır grupları.
  static const List<BoxShadow> level1 = [
    BoxShadow(color: Color(0x0F3A3020), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0D3A3020), blurRadius: 8, offset: Offset(0, 2)),
  ];

  /// Öne çıkan kart (hero), basılı durum öncesi.
  static const List<BoxShadow> level2 = [
    BoxShadow(color: Color(0x123A3020), blurRadius: 4, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x143A3020), blurRadius: 16, offset: Offset(0, 6)),
  ];

  /// Panel, alt sayfa, yüzen öğe.
  static const List<BoxShadow> level3 = [
    BoxShadow(color: Color(0x143A3020), blurRadius: 8, offset: Offset(0, 4)),
    BoxShadow(color: Color(0x1F3A3020), blurRadius: 28, offset: Offset(0, 12)),
  ];

  /// Material `elevation` kullanan bileşenlerin gölge rengi.
  static Color get materialShadow => _tone.withValues(alpha: 0.35);
}

/// İkon boyutları.
abstract final class AppIconSize {
  static const double sm = 16;
  static const double md = 24;
  static const double lg = 32;
  static const double xl = 48;
}

/// Dokunma hedefleri.
abstract final class AppTouch {
  /// En küçük dokunma alanı (ARAYUZ-METINLERI §1.12).
  static const double min = 48;

  /// Ana eylem düğmesi yüksekliği.
  static const double primary = 56;
}

/// Hareket dili (H-057): sakin, kısa, amaçlı. K-32 yasakları geçerli:
/// geri sayım, baskı, sürekli dikkat çeken titreşim yok.
/// "Hareketi azalt" açıksa ([reduced]) bileşenler durağan çizilir.
abstract final class AppMotion {
  /// Dokunma tepkisi, küçük durum değişimi.
  static const Duration fast = Duration(milliseconds: 150);

  /// Sayfa geçişi, panel açılışı, belirme.
  static const Duration base = Duration(milliseconds: 250);

  /// Dolan halka, sakin kutlama.
  static const Duration slow = Duration(milliseconds: 400);

  /// Listede sırayla belirmede öğeler arası gecikme.
  static const Duration stagger = Duration(milliseconds: 50);

  /// Sırayla belirmede en fazla bu kadar öğe gecikir (uzun listeler beklemez).
  static const int staggerMaxItems = 8;

  /// Standart (gir-çık).
  static const Curve standard = Curves.easeInOutCubic;

  /// Giriş: hızlı başlar, yumuşak durur.
  static const Curve enter = Curves.easeOutCubic;

  /// Çıkış.
  static const Curve exit = Curves.easeInCubic;

  /// Basınca küçülme oranı.
  static const double pressScale = 0.97;

  /// Belirmede kayma miktarı (öğe yüksekliğinin oranı).
  static const double slideOffset = 0.06;

  /// "Hareketi azalt" açık mı?
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// Hareket azaltılmışsa sıfır süre.
  static Duration of(BuildContext context, Duration d) =>
      reduced(context) ? Duration.zero : d;
}
