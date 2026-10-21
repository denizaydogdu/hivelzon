# H-066: Kitap paketi ve içerik boru hattı

- **Durum:** Bitti (2026-10-14; pytest 151/151, bölüm lint 0 hata)
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

2026-10-14 (uygulama; sonradan `main`'e alındı ve kabul edildi):
- **Biçim kesinleşti:** `docs/KITAPLIK.md` §6 (kaynak klasör, `text.en.md` işaretleri, paket, book-lint kuralları, TTS kuralları). Şemalar: `tools/content-pipeline/schema/book.schema.json`, `pages.schema.json`.
- **Kod:** `hvpipeline/book.py` (kaynak ayrıştırma), `booklint.py`, `bookexport.py`, `tts.py`; CLI `book_lint.py`, `export_book.py`, `tts_book.py`; `align.py`'ye cümle düzeyi zamanlama (`locate`, `sentence_timings`, `concat_alignments`); `cefr.py`'de `LEVELS` A1–C2, `CEFRJ_LEVELS` A1–B2, Octanove ayrı dosya; `lint.py` kapsama kuralı ortak işleve (`coverage_issues`) ayrıldı. Dev sunucu: `/books/index.json`, `/books/<id>/…` (Range).
- **Test kitabı:** `tools/content-pipeline/tests/fixtures/books/A1-K99-the-test-box/` (sahte hizalama; `kitaplar/` altında değil). `tests/test_books.py`: lint, paket (sahte ve gerçek ffmpeg/ImageMagick), TTS (sahte istemci; gerçek API çağrısı yok), sunucu.
- **Doğrulama:** `tools/content-pipeline/.venv/bin/python -m pytest tools/content-pipeline` → 142 geçti, 9 atlandı (öncesi 112 + 9; atlananlar git dışı bölüm medyası). Bölüm denetimi `content_lint.py icerik/A1-0*` çıktısı değişiklikten önceki kodla JSON düzeyinde **birebir aynı** (13 bölüm, 0 hata, 46 uyarı).
- **Ücretli çağrı yapılmadı.** ElevenLabs'e istek atılmadı; anahtar hiçbir dosyaya yazılmadı.

**Octanove C1/C2 listesini ekleme (kullanıcı adımı; araçlar indirmez):**
1. Kaynak: https://github.com/openlanguageprofiles/olp-en-cefrj → `octanove-vocabulary-profile-c1c2-1.0.csv` (v1.0, ~2.136 satır, sütunlar `headword,pos,CEFR,notes`).
2. Lisans: **CC BY-SA 4.0** (https://creativecommons.org/licenses/by-sa/4.0/). README "Terms of use": "The Octanove Vocabulary Profile for C1/C2 levels can be used under a Creative Commons Attribution-ShareAlike 4.0 International License." (`docs/LISANS-RAPORU.md` §2.3.)
3. Dosyayı **ayrı veri seti** olarak şuraya koy: `tools/content-pipeline/data/lexicon_ccbysa/octanove-vocabulary-profile-c1c2-1.0.csv`. Başına atıf satırları ekle (`#` ile başlayan satırları okuyucu atlar), örnek:
   `# Octanove Vocabulary Profile C1/C2 v1.0 — Octanove Labs, Open Language Profiles. https://github.com/openlanguageprofiles/olp-en-cefrj. CC BY-SA 4.0.`
4. İsteğe bağlı ama önerilen: `source` sütunu ekle (her satırda `octanove`). Yoksa okuyucu `octanove` varsayar.
5. Aynı klasöre CC BY-SA 4.0 bildirimini ve `data/README.md`'deki atfı (orada taslağı var) ekle; uygulamanın Lisanslar ekranı H-042 ile güncellenir. Hukuk sorusu (§8 S2) açık kalır.
6. Doğrula: `tools/content-pipeline/.venv/bin/python tools/content-pipeline/book_lint.py <C1/C2 kitabı>` → "liste yok" uyarısı kalkar, kapsama yüzdesi görünür.

**Açık sorular:**
- UNCONFIRMED: eleven_v3 istek başına karakter sınırı 3.000 varsayıldı (`tts.MAX_CHARS`); güncel sınır ve kredi/karakter oranı ElevenLabs belgesinden doğrulanmalı.
- UNCONFIRMED: Seviye başına `speed` başlangıç değerleri (A2 0.95 … C2 1.05) tahmin; pilotta (H-069) book-lint'in ölçtüğü k/dk ile ayarlanır.
- Aylık karakter tavanı değeri kullanıcı kararı (ücretsiz plan kotası ya da ticari plan, H-006). Tavan tanımlanmadan `--execute` çalışmaz.
- Bölüm başlığı seslendiriliyor ("A New Home."); "Chapter one" gibi bir giriş istenirse metne eklenir.
- `kitaplar/_maliyet/elevenlabs-karakter.json` defteri depoda tutulacak (gizli değil); başka makinede çalışırken defter eşitlenmezse aylık sayım eksik kalır.
2026-10-14: `main`'e birleştirildi ve kapandı. Pilotta (H-069) kesinleşecekler: aylık karakter tavanı (`HIVELZON_TTS_MONTHLY_CHAR_CAP`, kullanıcı kararı), istek başına karakter sınırı ve kredi/karakter oranı (ElevenLabs belgelerinden doğrulanacak), A1 üstü anlatım hızları. C1/C2 için Octanove dosyası eklenince kapsama denetlenir (H-073'ten önce).

