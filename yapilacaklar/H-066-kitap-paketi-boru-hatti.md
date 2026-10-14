# H-066: Kitap paketi ve içerik boru hattı

- **Durum:** Yapılacak
- **Tür:** Uygulama (araç)
- **Faz:** Kitaplık K1 (`docs/KITAPLIK.md` §9)
- **Bağımlılık:** H-065

## Kapsam
- `book.json` ve `pages.json` şeması: sayfa → cümle → kelime; başlangıç/bitiş sn; `tr`; `gloss`.
- `book-lint`:
  - kapsama A1–C2 (≥ %98 hedef, %95 alt sınır);
  - seviye başına cümle uzunluğu;
  - sözlük;
  - çeviri durumu.
- Octanove C1/C2 ayrı veri seti (CC BY-SA, `source` sütunu); C2 desteği.
- ElevenLabs TTS betiği:
  - zaman damgalı;
  - var olanı yeniden üretmez (idempotent);
  - üretimden önce bütçe ve karakter kontrolü;
  - maliyet kaydı;
  - anahtar repo dışında, yalnız çalışma anında okunur.
- Dışa aktarma: WebP, m4a (-16 LUFS), `manifest.json`.
- Dev içerik sunucusunda `/books/`.

## Kabul kriterleri
- Örnek bir kitapla paket uçtan uca üretilir.
- `book-lint` doğru hataları verir.
- pytest yeşil.

## Test
`tools/content-pipeline/.venv/bin/python -m pytest tools/content-pipeline`

## Geri alma
Kendi dalında; `git revert`.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Bir dinleme hikâyesi olsun; yatakta 'A2 bir hikâye aç' diyebileyim, okumadığım bir kitap sesli okunsun, ekranda renkli kitap gibi görünsün, okunan cümle işaretlensin, dokununca Türkçesi çıksın, durdurabileyim, sesi kapatıp kendim de okuyabileyim; okuduklarım ve yarıda kalanlar takip edilsin; her seviyeden 5, toplam 30 ilgi çekici kitap." Ek istek: bilmediği kelimeleri Defter'e ekleyip sonra çalışabilmeli. Kararlar (önerilenler onaylandı): önce 2 pilot kitap resimli, ElevenLabs önce pilotla, kısa kitap, bağımsız karışık türler. Ayrıntı: `docs/KITAPLIK.md`.
