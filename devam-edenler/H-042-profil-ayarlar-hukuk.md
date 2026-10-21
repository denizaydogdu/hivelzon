# H-042: Profil, ayarlar, hukuki metinler, hesap silme arayüzü

- **Durum:** Devam ediyor (2026-10-21)
- **Tür:** Uygulama (kod)
- **Faz:** 1.10 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-038

## Kapsam
- Beceri ve ilerleme gösterimi.
- Bildirim ayarları, gizlilik.
- Lisans atıfları (CEFR-J vb.), KVKK aydınlatması (hukukçu metni gerekir).
- Hesap silme ve geri alma arayüzü.

## Kabul kriterleri
- Hesap silme ve geri alma arayüzden uçtan uca çalışıyor.

## Test
```bash
cd mobile && flutter test
```

## Geri alma
Kendi dalında (`h-042-profil-ayarlar-hukuk`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
2026-10-12: Profil'deki "Hi benim hakkımda ne biliyor?" görünümü H-048 kapsamındadır; bu iş yalnızca yerini ayırır. Hukuk metinleri ve lisans atıfları için kaynak: `docs/LISANS-RAPORU.md`; hukukçu soruları henüz gönderilmedi.
2026-10-13 (H-055'ten): Hukukçu sorusu: 13–17 yaş için cihazda konuşma tanıma (ses saklanmaz, gönderilmez) ve iOS izin penceresindeki Apple metni; KVKK aydınlatmasına "Söyle alıştırmaları" bölümü.
2026-10-13: Hukukçu sorusu: 13 yaş altının hesapsız, cihazda veriyle kullanımı (KVKK), mağaza aile politikaları ve ebeveyn kapısı gereksinimi.
2026-10-14: Profil ekranının yeniden tasarımı H-059'a taşındı; bu iş hukuk metinleri, bildirim ayarları ve hesap silme arayüzünün içeriğiyle kalır.
2026-10-21: **Kullanıcı onayı (plan):** (1) hesap silme/geri alma uçtan uca: oturum kapandıktan sonra da "silme bekliyor + kalıcı silme tarihi" görünür, geri almada yeni kod gerekçesi açıklanır, silme → yeniden giriş → geri alma testi; (2) Profil → "Hakkında ve lisanslar": sürüm, CEFR-J v1.6 zorunlu atfı, Octanove CC BY-SA, py-fsrs MIT, EnglishPractice MIT, yazı tipleri OFL, Flutter lisans sayfası; kullanım şartları ve gizlilik metni Profil'den de açılır (taslak işaretli); (3) günlük hatırlatma (H-013): aç/kapa + saat, günde en fazla 1, izin yalnız açınca, sakin ve spoilersiz metin, veri cihazda; `flutter_local_notifications` + `timezone` eklentisine izin verildi; (4) `docs/HUKUK-SORULARI.md`: hukukçuya tek seferde gidecek soru listesi. Profil'de CEFR seviyesi gösterilmez (K-08 vaat yasağı).
