# H-043: Kalite ve iç beta hazırlığı

- **Durum:** Devam ediyor (2026-10-21)
- **Tür:** Uygulama (kod)
- **Faz:** 1.11 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-039 … H-042 · **Sonraki:** H-044

## Kapsam
- Erişilebilirlik, hata ve boş durumlar.
- Çökme raporlama (veri minimizasyonuyla).
- Simülatör ve yerel cihazda uçtan uca deneme. Mağaza ve TestFlight H-044'te.

- **H-031'den taşındı (kullanıcı kararı 2026-10-11):** düşük uçlu Android'de oynatıcı bellek/ısı ölçümü ve gerçek telefonda ses–yazı farkı ≤ 0,2 sn kontrolü.

## Kabul kriterleri
- Beta kontrol listesi tamam (mağaza maddeleri hariç).

## Test
```bash
cd mobile && flutter test && flutter build ipa --no-codesign
```

## Geri alma
Kendi dalında (`h-043-kalite-beta`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
2026-10-12: Gerçek cihaz denetimleri bu işte toplanır (kullanıcı kararı): düşük uçlu Android'de bellek/ısı ölçümü, gerçek telefonda ses–yazı farkı ≤ 0,2 sn, Android'de oynatıcı ve Drift veritabanının çalışması. Şimdiye kadarki doğrulamalar yalnızca iOS simülatöründe yapıldı.
2026-10-12 (H-054'ten): Ucuz Android telefonda 4G ağ koşuluyla test; hedefler: soğuk açılış, bölüm açılışı, harita kaydırma kare hızı (H-054 ölçümleri temel alınır).
2026-10-13 (H-055'ten): Gerçek iPhone ve Android'de "Söyle" alıştırmaları: cihazda tanıma, izin akışı (mikrofon izni sorulmadan dinleme başlarsa), Android İngilizce dil paketi yoksa davranış; iOS izin penceresinde Apple'ın sabit "ses Apple'a gönderilir" cümlesi (biz cihazda tanımayı zorunlu tutuyoruz) → metin ve hukuk incelemesi, gerekirse Türkçe InfoPlist.strings.
2026-10-21: **Kullanıcı onayı (plan + kararlar):** Yerel işler: Android ana manifestine INTERNET; yerel çökme kaydı (kişisel veri yok) + sakin Türkçe hata ekranı; sonsuz spinner ve eksik "tekrar dene" düzeltmeleri, oynatıcı hata metinleri tr_strings'e; hata/boş durum erişilebilirlik testleri (+ h063/h086/h091); Keşfet ve oynatıcıda "Hareketi azalt"; `docs/BETA-KONTROL-LISTESI.md`; cihaz derlemesi için yerel ağ adresi betiği. **Kararlar:** (1) Profil'de "Hata kaydını paylaş" (kullanıcı isterse sistem paylaşımıyla; son 200 satır); (2) yaş bilgisi okunamazsa Keşfet 20 dk sınırı uygulanır (güvenli taraf); (3) iOS geliştirme bölgesi tr + Türkçe InfoPlist.strings; (4) sürüm 0.1.0 (iç beta), her derlemede artan yapı numarası; (5) geçici sade uygulama simgesi ve açılış ekranı, asıl logo H-016; (6) Android imza anahtarı H-044'e.
