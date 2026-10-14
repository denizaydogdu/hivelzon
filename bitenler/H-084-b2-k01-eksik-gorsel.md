# H-084: B2-K01 eksik bölüm başı görseli (kredi yüklenince)

- **Durum:** Bitti (2026-10-14; kredi yüklendi, p13 üretildi, 0,5 kr)
- **Tür:** İçerik üretimi (görsel)
- **Faz:** Kitaplık K7 (H-072'nin kalanı)
- **Bağımlılık:** Higgsfield kredi yüklemesi (kullanıcı)

## Kapsam
- B2 görselleri 15,06 krediye sığsın diye 31 görselin 30'u üretildi (2026-10-14).
- Eksik kalan: **B2-K01 Two Signatures, `images/p13.png`**, 4. bölüm "Letters" başı.
- Sahne tarifi `kitaplar/B2-K01-two-signatures/PROMPTS.md` görsel planında hazır: Mr Pons'un sahaf dükkânı, Lucía rafların arasında.
- Kapak işi referans verilerek üretilecek; maliyet 0,5 kr.
- Kayıt `PROMPTS.md`'ye işlenir; ardından paket yeniden üretilir: `export_book.py kitaplar/B2-K01-two-signatures`.

## Kabul kriterleri
- `book_lint.py kitaplar/B2-K01-*` "görsel 7/7" der.
- Görselde yazı yok; sürpriz ele verilmiyor.

## Test
`tools/content-pipeline/.venv/bin/python tools/content-pipeline/book_lint.py kitaplar/B2-K01-two-signatures`

## Geri alma
Görsel git dışı; paket yeniden üretilir.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı ("bunu ek iş olarak kayıt et, unutmayalım"). O zamana kadar bölüm kitabın renkli zemini ile gösterilir.
2026-10-14: Kullanıcı 500 kredi yükledi; p13 üretildi ve kontrol edildi (yazı yok, sürpriz yok). İş kapandı.
