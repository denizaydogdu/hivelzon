# H-091: Kitap sonunda kısa anlama ve yeniden anlatma

- **Durum:** Bitti (2026-10-16); içerik editör onayı bekler (H-028)
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

## Notlar (2026-10-16, uygulama)
- **İçerik:** 30 kitabın `book.json`'ına `comprehension` yazıldı: 2 soru (3 seçenek, tek doğru, cevabın sayfası, Türkçe ipucu) + model özet (`modelEn`, `modelTr`). Claude taslağı; kullanıcı/editör onayı bekliyor (H-028). `book_lint` 30 kitap **0 hata**.
- **Araçlar:** şema `book.schema.json` → `comprehension`; book-lint `book-comprehension` (yapı, A1/A2 cümle sınırı, model özet 1–4 cümle; uzunluk uyarısı) ve `comprehension-vocab` (seviye listesi ya da kitap metni dışı sözcük; C1/C2 Octanove yoksa uyarı); `export_book.py` alanı pakete aynen taşır. Biçim: `docs/KITAPLIK.md` §6.6, uygulama §7.1.
- **Uygulama:** son sayfadan sonra `ComprehensionView` (Atla / Bitir), sonra kitap sonu. Drift **şema 9** `user_book_comprehension` (yalnız sayılar + öz değerlendirme; yazılan metin saklanmaz); eşitleme sırası 95, backend **V12**. H-089'a henüz bağlı değil.
- **Ana çalışma kopyasında yapılacak (birleştirmeden sonra):** paketler git dışı ve medya yalnız orada: `tools/content-pipeline/.venv/bin/python tools/content-pipeline/export_book.py kitaplar/*-K*` ardından `… book_lint.py kitaplar/*-K* --write-reports`.

2026-10-16: **Kullanıcı onayı:** 60 soru ve 30 örnek anlatım onaylandı (H-028 kullanıcı onayı; ünite sonu öğretmen kontrolü ayrıca).
