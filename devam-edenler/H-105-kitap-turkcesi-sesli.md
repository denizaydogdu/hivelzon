# H-105: Kitaplarda "Sayfanın Türkçesi"ni Alania ile sesli okuma

- **Durum:** Devam ediyor — A1 + A2 + B1 sesli (2026-11-03), kod ve testler yeşil; B2/C1/C2 üretimi, kullanıcının dinlemesi, editör kontrolü ve commit bekliyor
- **Tür:** İçerik hattı (Alania TTS + Duyu) + mobil arayüz
- **Öncelik:** Orta (Alania kampanyası 14 Kasım 2026'ya kadar ücretsiz ve sınırsız)
- **Bağımlılık:** H-086 (Sayfanın Türkçesi), H-083 ("Türkçe konuşan her yer Alania"), H-104 (desen ve ders)
- **Kullanıcı onayı:** 2026-11-03

## Kapsam

Kitap okuyucunun "Sayfanın Türkçesi" panelindeki metin Hi'nin sesiyle (PatientDesk Alania `alania2-f1`) okunur.

**Ürün kuralı:** İngilizce dinleme/okuma önde kalır. Türkçe ses **yalnız panel açıkken ve kullanıcı dokununca** çalar;
otomatik oynatma yok; İngilizce anlatımla aynı anda çalmaz (biri başlayınca öteki durur); okuyucu akışı değişmez.

**Birim: sayfa başına bir ses** (gerekçe): Panel sayfa sayfa açılır ve tek düğme taşır; uygulama tek dosya çalar
(bölüm sesi gibi zaman çizelgesi, sayfa çevirme, arka plan oturumu gerekmez). Metin, mobil `Book.turkishOf` ile
aynı kural: bölümün ilk sayfasında başlığın Türkçesi önce (sonuna seste durak için nokta), sonra cümlelerin
`ceviri.tr.json` Türkçesi; Türkçesi olmayan cümle atlanır. Duyu hizalaması yine üretilir ve depoda tutulur;
**okunan Türkçe cümle vurgusu yapılmadı** (panel listesi ile ses zamanlarını eşlemek ek durum yönetimi ister;
hizalama hazır olduğu için ileride ek ücret gerekmez).

## Yapılanlar

- `hvpipeline/booktr.py`: sayfa metni (`page_turkish`), rol/ses (`book.json → narrationTr.role`, varsayılan `hi`,
  `icerik/_evren/sesler.json`), kitap söyleniş sözlüğü (`narrationTr.pronunciations`; büyük/küçük harfe duyarlı;
  `sesler.json`'daki genel İngilizce sözlük **kullanılmaz** — "at" → "et" Türkçe "at"ı bozardı), plan, durum
  (`ok`/`no-audio`/`stale`/`none`) ve denetim.
- `tts_book_tr.py` (CLI): kuru çalışma varsayılan; `--execute` aylık tavan (`HIVELZON_TR_TTS_MONTHLY_CHAR_CAP`)
  ister; `--page`, `--force`, `--strict`, `--suspects` (Duyu dökümünde şüpheli kelimeler). Kayıt `<kitap>/PROMPTS.md`,
  defter `kitaplar/_maliyet/patientdesk-karakter.json`. Anahtar yalnız `--execute` ile, yazdırılmaz.
- `hvpipeline/tts_tr.py`: **Duyu boşluk onarımı** (`duyu_gaps`/`fill_gaps`): Duyu uzun seste ortadaki ya da sondaki
  ~20 sn'yi yazıya dökmeyebiliyor (ses tamam; sessizlik yok). Kelimeler arası, baştaki ya da sondaki > 3 sn boşluk
  ayrıca dökülüp zamanı kaydırılarak eklenir (ek Duyu saniyesi deftere). Bu oturumda 9 sayfada gerekti.
- Dosyalar: `kitaplar/<id>/audio/tr/<sayfa>.mp3` (git dışı, -16 LUFS), `<sayfa>.align.json` (depoda),
  `audio/tr/_raw/` (git dışı; `.gitignore` `kitaplar/**/_raw/`).
- Paket (`bookexport.py`, `export_book.py`): `audio/tr/<sayfa>.m4a` (sayfa başına -16 LUFS), `pages.json` sayfada
  `trAudio`/`trDuration` (şemada isteğe bağlı); manifest `trAudio` özeti ve `trMissing`. Eksik/eskimiş Türkçe ses
  UYARI'dır, `--require-media` ile de hata değildir; eskimiş ses pakete girmez.
- `book_lint`: `book-tr-audio` (eski metin, sahipsiz dosya), `book-tr-align` (zayıf hizalama), `book-media` (ses bu
  ortamda yok) uyarıları; rol hatası hata. CI medyasızdır: yalnız uyarı üretir, kırılmaz.
- Şema: `book.schema.json` `narrationTr`, `pages.schema.json` `trAudio`/`trDuration`.
- Mobil: `BookPage.trAudio`; panelde açıklamanın altında `HiListenButton` (H-104 bileşeni; `bookId` ile kitap
  paketinden, `beforePlay` İngilizceyi duraklatır, `stopOn`/`shouldStop` İngilizce başlarsa Türkçeyi durdurur) +
  "Türkçesini dinle". Panel açılınca İngilizce zaten durur (H-086); panel kapanınca Türkçe durur, İngilizce kaldığı
  yerden sürer. Metin `ReaderTexts.pageTurkishListen`; `ARAYUZ-METINLERI.md` §4.7, `KITAPLIK.md` §6.4 ve §7.

## Üretim (2026-11-03, 0 TL kampanya; ElevenLabs 0)

| Seviye | Kitap | Sayfa | Karakter | Süre |
|---|---|---|---|---|
| A1 | 5 | 54 | 19.893 | 23,6 dk |
| A2 | 5 | 76 | 39.246 | 46,0 dk |
| B1 | 5 | 96 | 78.352 | 85,4 dk |
| **Toplam** | 15 | 226 | **137.491** | 155 dk |

- Defterde bu oturum ≈ 138.100 karakter (A2-K05 p05 söyleniş düzeltmesiyle bir kez yeniden: 609); ay toplamı
  140.050 (H-104 dahil). Tarife karşılığı ≈ 120 TL olurdu; kampanya ücretsiz.
- Ses düzeyi -16,4…-16,7 LUFS (mp3), pakette -16,0; 226 dosyada boş/sıfır süreli yok (en kısa 14,4 sn).
- `--strict` uyarıları (Duyu, kulakla dinlenmeli): A1-K03 p10 ("Yine mi" duyulmadı), A2-K04 p11, B1-K01 p08 ve
  p19 (skor 0,96–0,98). Boşluk onarımlı sayfalar: A1-K01 p11, A2-K02 p13, A2-K05 p05, B1 6 sayfa (skor 1,0).

**Söyleniş sözlüğü** (`book.json → narrationTr.pronunciations`): A2-K01 Theo→Tiyo; A2-K03 Max→Meks, Bell→Bel,
Finn→Fin; A2-K05 Ines→İnes, ynlş→yanlış, nmr→numara, lütfn→lütfen (SMS kısaltması); B1-K01 Brandt→Brant,
Ilse→İlse; B1-K03 Ellie→Eli, Gus→Gas, Meera→Mira, web→veb; B1-K04 Ines→İnes; B1-K05 Noah→Noa, Ruby→Rubi.

**Kulakla dinlenmesi gerekenler** (Duyu dökümüne göre): A2-K04 "Nia" ("Niye" duyuldu; gerekirse Nia→Niya),
A2-K04 p16 "Edda" ("Eldaney"), A2-K04 p12 "Tıp tıp", A2-K02 p15 "Ding", A2-K03 p01/p11 "Max" ("Meks"/"Maxyer"),
A2-K01 "Theo" (Tio), A1-K04 p09 "Onuncu" ("10."). Tam liste: `tts_book_tr.py kitaplar/A1-K* kitaplar/A2-K* kitaplar/B1-K* --suspects`.
Düzeltme: `narrationTr.pronunciations` değiştir → `--execute` (yalnız o terimin geçtiği sayfalar yeniden üretilir).

## Kalan seviyeler (devam komutu)

B2 129.770 + C1 215.951 + C2 264.303 = **610.024 karakter** (≈ 340 sayfa; ölçülen hızla ~6–7 saat). Önce B2:

```bash
P=tools/content-pipeline/.venv/bin/python
HIVELZON_TR_TTS_MONTHLY_CHAR_CAP=1500000 $P tools/content-pipeline/tts_book_tr.py kitaplar/B2-K* --execute --strict
HIVELZON_TR_TTS_MONTHLY_CHAR_CAP=1500000 $P tools/content-pipeline/tts_book_tr.py kitaplar/C1-K* --execute --strict
HIVELZON_TR_TTS_MONTHLY_CHAR_CAP=1500000 $P tools/content-pipeline/tts_book_tr.py kitaplar/C2-K* --execute --strict
```

İdempotent: kesilirse aynı komut kaldığı yerden sürer (güncel sayfalar atlanır, ödenmiş ham ses `_raw/`'dan).
Önce B2–C2 kitaplarına `narrationTr` (rol + söyleniş sözlüğü) eklenmeli (şu an yalnız A1–B1'de; yoksa varsayılan
`hi` rolü ve sözlüksüz okunur). 14 Kasım'dan sonra tarife 0,75 TL/1.000 karakter: kalan için ≈ 458 TL + Duyu; o
tarihten sonra üretim ayrı maliyet onayı ister.

## Kabul kriterleri

- [x] A1 + A2 (ve B1) bütün sayfaların Türkçesi Alania ile sesli; ElevenLabs çağrılmadı.
- [x] Araç kuru çalışma varsayılan, tavan şart, idempotent, defter + PROMPTS kaydı; pytest sahte istemciyle.
- [x] Paket `audio/tr/*.m4a` + `pages.json trAudio`; eksik ses uyarı (zorunlu değil); book_lint denetliyor (0 hata).
- [x] Uygulamada panelde "Türkçesini dinle": ses yoksa yok, yalnız dokununca, İngilizceyle çakışmaz, 320×568 1,3× taşma yok, dokunma ≥ 44, ekran okuyucu etiketi.
- [ ] Kullanıcı sesleri dinler (yukarıdaki şüpheli satırlar).
- [ ] B2, C1, C2 üretimi (14 Kasım'a kadar).
- [ ] Editör kontrolü (H-028).

## Test komutları

```bash
P=tools/content-pipeline/.venv/bin/python
$P -m pytest tools/content-pipeline                          # 417
$P tools/content-pipeline/tts_book_tr.py kitaplar/A1-K* kitaplar/A2-K* kitaplar/B1-K*   # kuru: hepsi güncel
$P tools/content-pipeline/book_lint.py kitaplar/*-K*         # 30 kitap 0 hata
$P tools/content-pipeline/export_book.py kitaplar/A1-K*      # "Türkçe sayfa sesi: 11/11 sayfa pakette"
cd mobile && flutter analyze && flutter test                 # 1517
```

## Geri alma

`book.json → narrationTr` silinirse varsayılan rol kullanılır (ses değişmez). `kitaplar/*/audio/tr/` silinirse paket
`trAudio` taşımaz ve uygulama düğmeyi göstermez. Kod geri alınırsa eski paket biçimi aynen çalışır (yeni alanlar
isteğe bağlı); `tts_tr.py` boşluk onarımı yalnız Duyu'ya ek çağrı yapar, mevcut hizalamaları değiştirmez.
