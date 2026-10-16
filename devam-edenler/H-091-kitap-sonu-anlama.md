# H-091: Kitap sonunda kısa anlama ve yeniden anlatma

- **Durum:** Devam ediyor (2026-10-16)
- **Tür:** Uygulama + içerik
- **Faz:** F1 MVP — ürün incelemesi sonrası (2026-10-16)
- **Bağımlılık:** H-067, H-089

## Kapsam (ürün incelemesi §4 P2, §6; kullanıcı onayı 2026-10-16)
- Her kitabın sonunda **2 anlama sorusu** (kitap başına, seviyesine uygun) + **kısa yeniden anlatma önerisi** (kendi cümlenle 1–3 cümle; model özet ve öz değerlendirme; puan yok).
- Sayfa aralarına quiz konmaz; okuma kesilmez. Atlanabilir.
- Sonuç kitap ilerlemesinden ayrı "anlama" verisi olarak cihazda tutulur (hesap varsa eşitlenir); H-089 kanıt basamaklarına bağlanır.
- 30 kitap için sorular Claude taslağı → `book_lint` → editör onayı (H-028). Paket biçimi `docs/KITAPLIK.md`'de güncellenir.

## Kabul kriterleri
- 30 kitabın hepsinde 2 soru; `book_lint` 0 hata.
- Okuyucuda son sayfadan sonra anlama ekranı; atla/bitir; sonuç kaydedilir (test).

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında; `git revert`.
