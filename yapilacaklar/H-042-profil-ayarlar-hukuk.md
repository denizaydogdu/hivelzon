# H-042: Profil, ayarlar, hukuki metinler, hesap silme arayüzü

- **Durum:** Yapılacak (sırada; H-025 onaylandı 2026-10-11, sıra `docs/UYGULAMA-PLANI.md`'de)
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
