# Veri dosyaları ve atıflar

## `cefrj-wordlist-v1.6.csv`

> The CEFR-J Wordlist Version 1.6. Compiled by Yukio Tono, Tokyo University of Foreign Studies. Retrieved from https://www.cefr-j.org/download.html on 11/10/26.

- **Lisans:** Telif Tono Laboratory'ye (TUFS) aittir. Kaynak belirtilerek araştırma, eğitim ve ticari amaçla ücretsiz kullanılabilir; türev liste serbesttir, atıf şarttır. Ayrıntı: `docs/LISANS-RAPORU.md` §2.1.
- **Türetme:** Özgün `CEFR-J Wordlist Ver1.6.xlsx` dosyasının `ALL_sep` sayfası (her satırda tek başsözcük). Yalnızca `headword`, `pos`, `CEFR` sütunları alındı; Core Inventory ve Threshold sütunları alınmadı (rapordaki öneri).
- **Biçim:** `#` ile başlayan ilk satırlar atıf başlığıdır; okuyucu bunları atlar.
- Uygulamanın "Lisanslar" ekranında da aynı atıf yer alır (H-042).

## `lexicon_ccbysa/octanove-vocabulary-profile-c1c2-1.0.csv`

> Octanove Vocabulary Profile C1/C2 v1.0 — Octanove Labs, Open Language Profiles. https://github.com/openlanguageprofiles/olp-en-cefrj (commit d4e45b75b3). Retrieved 2026-11-03. CC BY-SA 4.0.

C1 ve C2 kapsaması için (Kitaplık, H-066; dilbilgisi ve bölümlerde de C1/C2 seviyesinde). **CC BY-SA 4.0** olduğundan CEFR-J'den ve hiVelzon'un özgün içeriğinden **ayrı veri seti** olarak bu alt klasörde durur (`docs/LISANS-RAPORU.md` §2.3, §3). Lisans bildirimi ve değişiklikler: `lexicon_ccbysa/README.md`.

- **Eklendi:** 2026-11-03, kullanıcı onayıyla. Kaynak commit `d4e45b75b3` (olp-en-cefrj).
- **Kaynak:** Octanove Vocabulary Profile C1/C2 v1.0, Octanove Labs, Open Language Profiles: https://github.com/openlanguageprofiles/olp-en-cefrj (README "Terms of use"). Lisans: https://creativecommons.org/licenses/by-sa/4.0/
- **İçerik:** 2.136 veri satırı (C1 1.111, C2 1.025).
- **Biçim:** Özgün sütunlar `headword,pos,CEFR,notes`; eklenen `source` sütunu (her satırda `octanove`). Başta `#` ile başlayan iki atıf satırı (kaynak, commit, alınma tarihi, lisans, değişiklikler); okuyucu bunları atlar.
- **Kullanım:** `hvpipeline/cefr.py` C1/C2 için CEFR-J'nin tamamına bu listeyi ekler. Dosya kaldırılırsa C1/C2 kapsaması denetlenmez ("liste yok; kapsama denetlenmedi" uyarısı). Araçlar dosyayı kendileri indirmez.
- Uygulamanın "Lisanslar" ekranında atıf yer alır (H-042; `mobile/lib/l10n/tr_strings.dart`, `AboutTexts.sources`).

## `proper_nouns.txt`

hiVelzon evrenindeki özel adlar ve yer adları (kanon: `icerik/_evren/`). Kapsama hesabında sayılmaz (CLAUDE.md, kapsama kuralı). Satır başına bir sözcük, küçük harf. Yeni karakter ya da yer eklenince buraya da eklenir.
