# H-098: Canlı arayüz geri bildirimi düzeltmeleri

- **Durum:** Bitti (2026-10-26)
- **Tür:** Mobil arayüz + kullanıcı denemesi
- **Bağımlılık:** H-039, H-040, H-064, H-067, H-078

## Kapsam

Kullanıcının iOS simülatöründe yaptığı canlı denemeden çıkan yedi arayüz
geri bildirimi uygulandı:

1. Karşılama ekranı sıcak gradyan, dalga zemini, Hi kartı ve yeni özgün
   Higgsfield illüstrasyonuyla zenginleştirildi.
2. Açılış bilgilendirmesindeki "Yapay zekâ" maddesi hukukçu görüşü gereği
   kaldırıldı.
3. Seviye çipleri açıklamalı dikey seçeneklere dönüştürüldü; A1–C1 seçen
   kullanıcı teste girmeden doğrudan başlıyor, test ikincil seçenek olarak
   kalıyor.
4. Açılış tamamlandıktan sonra yalnız bir kez gösterilen, atlanabilir dört
   adımlı Hi turu eklendi.
5. Keşfet'in siyah üst şeridi diğer ekranlarla uyumlu kum/deniz mavisi
   tasarıma geçirildi.
6. Keşfet sorularında yanlış seçenek kırmızı durum ve açık "Yanlış" metniyle
   gösteriliyor.
7. Hikâye içindeki Kitaplık ve Dilbilgisi bölüm seçicisi kaydırmada sabit
   tutuluyor.

## Kod incelemesinde kapatılan riskler

- Tur perdesinin alttaki sekmelere dokunmayı geçirmesi engellendi.
- Tur kapanış yazımı başarısız olduğunda düğmelerin kilitli kalması önlendi.
- Tur önbelleği onboarding tamamlanınca yenileniyor.
- Seviye başlangıcında çift dokunma koruması eklendi.
- Kitaplık/Dilbilgisi'nin artık kullanılmayan `header` parametreleri kaldırıldı.
- Gizlilik maddesi/simge sayısı için geliştirme zamanı doğrulaması eklendi.

## Higgsfield üretimi

- Model: GPT Image 2.5, 2K, high, 16:9.
- Kaynak: mevcut `hosgeldin.webp` karakter ve sahne referansı.
- Uygulama varlığı: `mobile/assets/illustrations/hosgeldin-higgsfield.webp`
  (1600×900, WebP, yaklaşık 314 KB).
- Gerçek harcama: **16,39 kredi**; kalan hesap bakiyesi **483,72 kredi**.

## Doğrulama

- `flutter analyze`: temiz.
- `flutter test`: **1474/1474**.
- Yeni tur golden'ı: `mobile/test/goldens/images/h039_tur.png`.
- 320×568 ve 1,3× metinde tur taşma/perde testi geçti.
- Kitaplık ve Dilbilgisi sabit seçici regresyon testleri geçti.
- WishSay iPhone simülatöründe yeni karşılama görseli ve kırpması doğrulandı.

## Geri alma

Karşılama görseli `OnboardingScreen.welcomeImage` üzerinden eski
`assets/illustrations/hosgeldin.webp` varlığına döndürülebilir. Diğer maddeler
birbirinden bağımsız dosya değişiklikleridir.
