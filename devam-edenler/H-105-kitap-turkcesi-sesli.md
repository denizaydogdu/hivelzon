# H-105: Kitaplarda "Sayfanın Türkçesi"ni Alania ile sesli okuma

- **Durum:** Devam ediyor — **üretim bitti, 30 kitabın tamamı sesli** (626 sayfa; A1–B1 2026-11-03, commit `d2d81c0`, CI `41690063999` yeşil; B2/C1/C2 ve söyleniş düzeltmeleri 2026-11-03/04, commit `fd56543`, CI `41798860052` yeşil); kullanıcının kulakla kontrolü ve editör kontrolü bekliyor; kabulden önce `bitenler/`e taşınmaz
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

## B2–C2 üretimi ve söyleniş düzeltmeleri (2026-11-03/04, 0 TL kampanya; ElevenLabs 0)

| Seviye | Kitap | Sayfa | Karakter | Süre |
|---|---|---|---|---|
| B2 | 5 | 115 | 129.770 | 139 dk |
| C1 | 5 | 138 | 215.951 | 229 dk |
| C2 | 5 | 147 | 264.303 | 278 dk |
| **Toplam B2–C2** | 15 | 400 | **610.024** | ≈ 646 dk |

- **30 kitap / 626 sayfa / 747.515 karakter** sesli; kuru çalışma hepsini güncel gösteriyor. Defter 2026-11 toplamı **764.686**
  karakter (H-104 + söyleniş düzeltmeleri + ilk dakikalarda yanlışlıkla iki kopya çalışan betikten birkaç tekrar dahil;
  kampanya nedeniyle 0 TL, tarife karşılığı ≈ 574 TL olurdu). Aylık tavan 1.500.000 ile çalıştırıldı.
- 400 dosyada boş/sıfır süreli yok (en kısa 56,9 sn); mp3 -16,5…-16,6 LUFS, pakette -16,0. Duyu boşluk onarımı 60 kez.
- Geçici sunucu hataları (`RemoteDisconnected`, okuma zaman aşımı) C1'de 2, C2'de 1 kez; komut kaldığı yerden sürdü,
  kalıcı hata yok.
- Söyleniş sözlükleri (`book.json → narrationTr.pronunciations`): B2-K01 Lucía→Lusiya, Tomás→Tomas, Castell→Kastel,
  Roig→Roç; B2-K02 Jonah→Couna, Price→Prays, Dr→Doktor; B2-K03 Costa→Kosta; B2-K04 Lindqvist→Lindkvist, Hale→Heyl;
  B2-K05 Sophie/Soph, Daniel→Denyıl, Byrne, Doyle, Tommy, Kelly, Kilbrannock; C1 kitaplarında 5–22 ad/yer (Calderbury,
  Glasswater, Gwen→Guen, Howard→Hauırd, Brindle Umbrellas, Wrenmouth→Renmıt, Ilan→İlan …); C2-K01'de 64 terim (kitaptaki
  İngilizce sözcükler: lonely/too/will/me/are/you, crepuscular, octopi …), C2-K05'te 32 terim ("I am agree", "The Last
  Ferry", "I can't bear to spend you", "Not to be opened until…" gibi İngilizce cümleler Türkçe harflerle).
- **Alania tekrar cümlesi düşürüyor (ders):** Sayfada art arda iki kez geçen kısa cümlenin biri bazen okunmuyor
  (A1-K03 p10 "Yine mi!", C1-K05 p21 "Bir cep sözlüğü yüzünden.", C1-K03 p08 "Bunu duyuyorum."). Duyu dökümünde
  süresi ~0 olan "missing" dizileriyle bulundu; aynı metinle ödenmiş ham ses önbellekte olduğu için, ilgili ifade
  kendisiyle aynı söylenişle sözlüğe eklenip (istek anahtarı değişir) yeniden üretildi; üçünde de iki kez okunuyor.
- `--strict` uyarıları (Duyu; çoğu sayıların rakamla yazılması ya da İngilizce adların İngilizce yazımı): B2 4 sayfa,
  C1 25, C2 31 (skor 0,93–0,99). Kulakla dinlenmesi önerilenler: B2-K02 "Jonah" (Duyu "Kuna" duyuyor; gerekirse
  Couna→Cona), C1-K03 "Gwen" (yer yer "Güven"), B2-K05 "Daniel" ("Danielle"), C2-K01 p03/p18 İngilizce kelime dizileri,
  C2-K05 p17/p30 ("I am agree", "Other Half of Sentence").

**Kulakla kontrol listesi (2026-11-04, `fd56543` sonrası, tek yer):**
- **Yazım denemesi (2026-11-04, commit edilmedi;** kısa deneme sesleri, 2–4 yazım × 1–2 kez, 0 TL; Konuş + kitap denemeleri toplam 7.599 karakter / 74 Alania çağrısı deftere elle eklendi):
  - B2-K02 "Jonah": Couna (2/2 "Duna…kuna") · Cona ("Kona") · Coonı/Counı ("Jona/Joana/Juna") · **Cöuna** (2/2 "Jonah")
    → **uygulandı**, 23 sayfa yeniden: sayfalarda "Kuna" 46 → 0; Duyu artık "Jonah/Joana/Jona"; ortalama skor 0,978 → 0,993.
  - A2-K02 "Ding": sözlüksüz (2/2 "Dink") · Diing ("Dink", bir denemede tek "Ding") · **Diiing** (3 denemenin 2'sinde
    "Ding. Ding.") → **uygulandı**; p04/p15'te 3/3 "Ding".
  - A2-K04 "Nia": Niya (1/2 "Niye") · Nii-ya (2/2 "Niye") · Nıya (1/2 "Nıya") · **sözlüksüz "Nia"** (2/2 "Nia") →
    **Nia sözlükten çıkarıldı**; 16 sayfa: "Niye" 4 → 2 (+1 "Nihat"), skor 0,990 → 0,991. Kalan "Niye"ler büyük olasılıkla
    Duyu'nun Türkçe kelimeye benzetmesi.
  - C1-K03 "Gwen": Guen ("Güen/Gen/güyen") · Gven ve Guven ("Güven") · Güen ("Güven") · Guenn ("Gen") · Gu-en (1/2 "Guen")
    → açık iyileşme yok, **Guen kaldı** (Duyu sınırı: "Güven"e benzetiyor).
  - B2-K05 "Daniel": Denyıl, Denyel, Daniyel ve sözlüksüz, hepsi "Danielle" → **Denyıl kaldı** (Duyu sınırı).
- **Kulakla kontrolde kalan:** C1-K03 "Gwen", B2-K05 "Daniel", A2-K04 "Nia" (2 yer), C2-K01 p03 ve p18, C2-K05 p17 ve p30;
  Jonah ve Ding için tek bir dinleme yeterli.
- Düzeltme gerekirse `narrationTr.pronunciations` değiştirilip `--execute` (yalnız ilgili sayfalar; kampanya 14 Kasım 2026'ya kadar).

**A1–B1 söyleniş düzeltmeleri (önce → sonra, Duyu dökümü):**
- A1-K03 p10 "Yine mi!" okunmuyordu (ses "Ravi"den 0,13 sn sonra bitiyordu) → **düzeldi** (iki kelime tam eşleşti).
- A2-K04 Edda→**Eda**: "Elda/Eldaney" → "Eda" (**düzeldi**). Nia→**Niya**: Duyu yine 4 yerde "Niye" yazıyor
  (**belirsiz**, kulak kararı). "Tıp tıp" (p12): zaman aralığı (3,7 sn) okunduğunu gösteriyor; Duyu tekrarları birleştiriyor,
  değişiklik gerekmedi.
- A2-K02 Ding→**Diing**: Duyu yine "Dink/deyin" (**düzelmedi** ya da Duyu kaynaklı; kulak kararı).
- A2-K03 "Max" (Meks) ve A2-K01 "Theo" (Tio), A1-K04 "Onuncu" (Duyu "10." yazıyor), B1-K01 p08/p19 (on biri→11,
  "Bay Hofer"→"Bayhofer"), A2-K04 p11 ("hiç de"→"işte"): Duyu yazım farkı; ses doğru görünüyor, yeniden üretilmedi.

## Kabul kriterleri

- [x] A1 + A2 (ve B1) bütün sayfaların Türkçesi Alania ile sesli; ElevenLabs çağrılmadı.
- [x] Araç kuru çalışma varsayılan, tavan şart, idempotent, defter + PROMPTS kaydı; pytest sahte istemciyle.
- [x] Paket `audio/tr/*.m4a` + `pages.json trAudio`; eksik ses uyarı (zorunlu değil); book_lint denetliyor (0 hata).
- [x] Uygulamada panelde "Türkçesini dinle": ses yoksa yok, yalnız dokununca, İngilizceyle çakışmaz, 320×568 1,3× taşma yok, dokunma ≥ 44, ekran okuyucu etiketi.
- [ ] Kullanıcı sesleri dinler (yukarıdaki şüpheli satırlar).
- [x] B2, C1, C2 üretimi (2026-11-04; 400 sayfa, 610.024 karakter, 0 TL; commit `fd56543`).
- [ ] Editör kontrolü (H-028).

## Test komutları

```bash
P=tools/content-pipeline/.venv/bin/python
$P -m pytest tools/content-pipeline                          # 417
$P tools/content-pipeline/tts_book_tr.py kitaplar/A1-K* kitaplar/A2-K* kitaplar/B1-K*   # kuru: hepsi güncel
$P tools/content-pipeline/book_lint.py kitaplar/*-K*         # 30 kitap 0 hata (205 uyarı, 2026-11-04)
$P tools/content-pipeline/export_book.py kitaplar/A1-K*      # "Türkçe sayfa sesi: 11/11 sayfa pakette"
cd mobile && flutter analyze && flutter test                 # 1517
```

## Geri alma

`book.json → narrationTr` silinirse varsayılan rol kullanılır (ses değişmez). `kitaplar/*/audio/tr/` silinirse paket
`trAudio` taşımaz ve uygulama düğmeyi göstermez. Kod geri alınırsa eski paket biçimi aynen çalışır (yeni alanlar
isteğe bağlı); `tts_tr.py` boşluk onarımı yalnız Duyu'ya ek çağrı yapar, mevcut hizalamaları değiştirmez.
