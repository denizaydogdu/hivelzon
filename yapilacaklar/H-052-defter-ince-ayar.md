# H-052: Defter ince ayarı ("Listen." ve sözlük filtresi)

- **Durum:** Yapılacak (sırada; H-051'den önce, küçük iş)
- **Tür:** İçerik + boru hattı + uygulama
- **Bağımlılık:** H-036

## Kapsam (kullanıcı kararı 2026-10-12)
- B1 hedef ifadesi "Listen." hiçbir altyazıda yok: `ceviri.tr.json`'a anlam ("Dinle.") eklenir; kart görsel + anlamla desteye girer. Ses: yerel TTS (iç kullanım) ya da sonraki seslendirmede.
- Bölüm sözlüğü (content.json `glossary` / seviye üstü kelimeler) pakete eklenir; altyazıda bakılan kelimelerden yalnızca sözlükteki seviye kelimeleri karta dönüşür. Paketler kredisiz yeniden üretilir.
- content-lint: her hedef ifadenin anlamı var mı denetlenir.

## Kabul kriterleri
- B1 destesinde 5 hedef ifade; sözlük dışı bakılan kelime karta dönüşmüyor (test).
- pytest + flutter test yeşil.
