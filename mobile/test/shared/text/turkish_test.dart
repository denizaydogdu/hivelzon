import 'package:flutter_test/flutter_test.dart';
import 'package:hivelzon/l10n/tr_strings.dart';
import 'package:hivelzon/shared/text/turkish.dart';

void main() {
  test('Türkçe büyük harf: i → İ, ı → I', () {
    expect(upperTr('kilitli'), 'KİLİTLİ');
    expect(upperTr('sıradaki'), 'SIRADAKİ');
    expect(upperTr('Kelime tekrarı'), 'KELİME TEKRARI');
    expect(upperTr('Açık soru · Bölüm 1'), 'AÇIK SORU · BÖLÜM 1');
    expect(upperTr('Sezon 1 · Bölüm 12'), 'SEZON 1 · BÖLÜM 12');
    // Dart'ın kendi büyütmesi Türkçede yanlış: bu yüzden yardımcı var.
    expect('kilitli'.toUpperCase(), isNot(upperTr('kilitli')));
  });

  test('Türkçe küçük harf: İ → i, I → ı', () {
    expect(lowerTr('İSTASYON'), 'istasyon');
    expect(lowerTr('KAPALI'), 'kapalı');
    expect(lowerTr('İstanbul'), 'istanbul');
  });

  test('sayıya iyelik eki', () {
    expect(
      [for (var n = 0; n <= 12; n++) possessiveNumber(n)],
      [
        "0'ı",
        "1'i",
        "2'si",
        "3'ü",
        "4'ü",
        "5'i",
        "6'sı",
        "7'si",
        "8'i",
        "9'u",
        "10'u",
        "11'i",
        "12'si",
      ],
    );
    expect(possessiveNumber(40), "40'ı");
    expect(possessiveNumber(60), "60'ı");
  });

  test('Ana Sayfa metinleri: ad, sayı cümle içinde, süre tahmini', () {
    expect(HomeTexts.greeting(null), 'Merhaba!');
    expect(HomeTexts.greeting(''), 'Merhaba!');
    expect(HomeTexts.greeting('Ayşe'), 'Merhaba Ayşe!');
    expect(HomeTexts.reviewMinutes(0), 0);
    expect(HomeTexts.reviewMinutes(1), 1);
    expect(HomeTexts.reviewMinutes(3), 1);
    expect(HomeTexts.reviewMinutes(4), 2);
    expect(HomeTexts.reviewMinutes(20), 7);
    expect(
      HomeTexts.reviewDue(4, 2),
      '4 ifadenin tekrar zamanı geldi · yaklaşık 2 dk',
    );
    expect(HomeTexts.seasonProgress(0, 12), 'Bu sezonda 12 bölüm var.');
    expect(
      HomeTexts.seasonProgress(6, 12),
      "Bu sezonda 12 bölümden 6'sı bitti.",
    );
    expect(HomeTexts.episodeLabel(1, 2), 'SEZON 1 · BÖLÜM 2');
    expect(StoryTexts.sheetLabel(2, 'kilitli'), 'BÖLÜM 2 · KİLİTLİ');
  });
}
