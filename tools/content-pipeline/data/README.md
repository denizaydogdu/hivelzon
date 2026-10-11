# Veri dosyaları ve atıflar

## `cefrj-wordlist-v1.6.csv`

> The CEFR-J Wordlist Version 1.6. Compiled by Yukio Tono, Tokyo University of Foreign Studies. Retrieved from https://www.cefr-j.org/download.html on 11/10/26.

- **Lisans:** Telif Tono Laboratory'ye (TUFS) aittir. Kaynak belirtilerek araştırma, eğitim ve ticari amaçla ücretsiz kullanılabilir; türev liste serbesttir, atıf şarttır. Ayrıntı: `docs/LISANS-RAPORU.md` §2.1.
- **Türetme:** Özgün `CEFR-J Wordlist Ver1.6.xlsx` dosyasının `ALL_sep` sayfası (her satırda tek başsözcük). Yalnızca `headword`, `pos`, `CEFR` sütunları alındı; Core Inventory ve Threshold sütunları alınmadı (rapordaki öneri).
- **Biçim:** `#` ile başlayan ilk satırlar atıf başlığıdır; okuyucu bunları atlar.
- Uygulamanın "Lisanslar" ekranında da aynı atıf yer alır (H-042).

## `proper_nouns.txt`

hiVelzon evrenindeki özel adlar ve yer adları (kanon: `icerik/_evren/`). Kapsama hesabında sayılmaz (CLAUDE.md, kapsama kuralı). Satır başına bir sözcük, küçük harf. Yeni karakter ya da yer eklenince buraya da eklenir.
