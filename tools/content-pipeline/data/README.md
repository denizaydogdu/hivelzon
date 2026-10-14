# Veri dosyaları ve atıflar

## `cefrj-wordlist-v1.6.csv`

> The CEFR-J Wordlist Version 1.6. Compiled by Yukio Tono, Tokyo University of Foreign Studies. Retrieved from https://www.cefr-j.org/download.html on 11/10/26.

- **Lisans:** Telif Tono Laboratory'ye (TUFS) aittir. Kaynak belirtilerek araştırma, eğitim ve ticari amaçla ücretsiz kullanılabilir; türev liste serbesttir, atıf şarttır. Ayrıntı: `docs/LISANS-RAPORU.md` §2.1.
- **Türetme:** Özgün `CEFR-J Wordlist Ver1.6.xlsx` dosyasının `ALL_sep` sayfası (her satırda tek başsözcük). Yalnızca `headword`, `pos`, `CEFR` sütunları alındı; Core Inventory ve Threshold sütunları alınmadı (rapordaki öneri).
- **Biçim:** `#` ile başlayan ilk satırlar atıf başlığıdır; okuyucu bunları atlar.
- Uygulamanın "Lisanslar" ekranında da aynı atıf yer alır (H-042).

## `lexicon_ccbysa/octanove-vocabulary-profile-c1c2-1.0.csv` (henüz depoda yok)

C1 ve C2 kapsaması için (Kitaplık, H-066). **CC BY-SA 4.0** olduğundan CEFR-J'den ve hiVelzon'un özgün içeriğinden **ayrı veri seti** olarak bu alt klasörde durur (`docs/LISANS-RAPORU.md` §2.3, §3).

- **Kaynak:** Octanove Vocabulary Profile C1/C2 v1.0, Octanove Labs, Open Language Profiles: https://github.com/openlanguageprofiles/olp-en-cefrj (README "Terms of use"). Lisans: https://creativecommons.org/licenses/by-sa/4.0/
- **Biçim:** Özgün sütunlar `headword,pos,CEFR,notes`. Önerilen ek sütun `source` (değer `octanove`); yoksa okuyucu `octanove` varsayar. `#` ile başlayan satırlar atıf başlığıdır.
- **Dosya yoksa:** C1/C2 kitap ve bölümlerinde kapsama denetlenmez; book-lint ve content-lint "liste yok; kapsama denetlenmedi" uyarısı verir. Araçlar bu dosyayı kendileri indirmez.
- **Ekleme adımları:** `yapilacaklar/H-066-kitap-paketi-boru-hatti.md` → Notlar.

## `proper_nouns.txt`

hiVelzon evrenindeki özel adlar ve yer adları (kanon: `icerik/_evren/`). Kapsama hesabında sayılmaz (CLAUDE.md, kapsama kuralı). Satır başına bir sözcük, küçük harf. Yeni karakter ya da yer eklenince buraya da eklenir.
