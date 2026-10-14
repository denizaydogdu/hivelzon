# Dilbilgisi müfredatı (A1–C2, 71 konu)

> **Durum: ONAYLI (kullanıcının genel onayı 2026-10-14, H-076; her ders yayından önce öğretmen kontrolünden geçer)**
> İş: H-076 · Plan: `docs/DILBILGISI.md` §3–§4 · Tarih: 2026-10-14 · Sürüm: 0.1
> Bu belge konu listesidir, derslerin kendisi değildir. Ders kartları (`lesson.json`) H-077'den sonra, önce pilot 3 konu (H-079), sonra dalgalar hâlinde (H-080…H-082) yazılır.


## Kararlar (2026-10-14, kullanıcının genel onayıyla)
- Kelime sırası (G-A1-12) **ayrı konu** olarak kalır; A1 16 konu, toplam 71.
- Terim adı biçimi: **Türkçe ad + İngilizce terim** ("Geniş zaman (present simple)").
- S1'de geçen kalıplar ("It's raining", "I'm looking for…") şimdilik kısa notla anlatılır ve ilgili A2 dersine bağlanır.
- *-ed/-ing* sıfatları ve dolaylı sorular B1'de kalır. C2 üslup ve söylem konuları kabul.
- A2-K04 p09'daki "the biggest clouds Nia ever saw" cümlesi karşılaştırmayla yeniden yazıldı ("Soon they were bigger than all the clouds in Nia's books."). Örnek olarak kullanılmaz.
- **Pilot (H-079):** G-A1-01-to-be, G-A1-03-a-an, G-A1-13-third-person-s.
- Açık: Tono Lab'ın CEFR-J için yazılı teyidi bekleniyor (yalnız referans kullanım).

## Nasıl okunur

- **Kimlik:** `G-<SEVİYE>-<2 hane>-<kisa-ad>`. Numara seviye içindeki **önerilen sıradır**; kilit yoktur, her konu her zaman açıktır (`DILBILGISI.md` §3).
- **Önkoşul:** Bu konudan önce bilinmesi iyi olan konular. Öneri ve "Hikâyende geçenler" sıralaması için kullanılır, erişimi kısıtlamaz.
- **Türkçeyle karşılaştırma:** Türkçenin aynı anlamı nasıl kurduğu ve farkın neden zor olduğu. Ders kartı 4'ün ("Türkçede nasıl?") kaynağıdır.
- **Tipik hata:** Türk öğrencinin sık yaptığı hata → doğrusu. Utandırmayan dille sunulur.
- **Örnekler:** Konunun seviyesinde, bizim yazdığımız iki cümle. Ders yazılırken 3–5'e tamamlanır ve `grammar-lint` kapsama denetiminden geçer.
- **Hikâye bağı:** Yapının **gerçekten geçtiği** yerler. Bölüm için `bölüm kimliği + sahne + replik`, kitap için `kitap kimliği + sayfa (pNN) + cümle`. Bulunmayan yerde "henüz yok" yazılır.
- **Hata kataloğu:** A1 konularında, `icerik/_evren/hata-katalogu.json`'daki ilgili kayıt (Hi'nin hata notu bu konuya bağlanabilir).

### Hikâye bağları nasıl doğrulandı
- 2026-10-14'te `icerik/A1-000…A1-012/story.en.md` ve `kitaplar/A1-K01…K05`, `kitaplar/A2-K01…K05` `text.en.md` metinlerinde her yapı için düzenli ifadeyle arama yapıldı ve her alıntı metinden birebir alındı.
- Hi'nin Türkçe satırları, `[GÖRSEL]`/`[YAZI]` işaretleri ve başlık satırları sayılmadı. ✓/✗ ile başlayanlar karar anı seçenekleridir; ✗ seçenekler çoğu zaman Türk öğrencinin tipik hatasını bilerek taşır ve "Tipik hata" için en güçlü kanıttır.
- S1 bölümleri hâlâ `DRAFT`, kitaplar taslak. Metin değişirse bağ kayabilir; bu yüzden paket üretilirken `grammar-lint` her bağı yeniden çözmelidir (H-077, `DILBILGISI.md` §5).
- B1 ve üstü kitaplar henüz yazılmadı, S2+ yok. Bu yüzden B1–C2 konularının çoğunda bağ "henüz yok"; varsa A2 kitaplarındaki erken örnekler gösterildi.

### Kaynak ve lisans kuralları
- Sıra, CEFR-J Grammar Profile **yalnızca referans** alınarak ve S1'in `LANGUAGE_PROGRESSION.md` sırasıyla uyumlu kuruldu. Ham veri bu belgeye, uygulamaya ya da isteme konmadı (`docs/LISANS-RAPORU.md`; Tono Lab yazılı teyidi bekleniyor).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı. Konu adları, hedefler, karşılaştırma notları ve örnek cümleler kendi cümlemizdir.
- CEFR tanımlayıcıları alıntılanmadı; hedefler kendi ifademizle yazıldı.

## Önerilen pilot: 3 A1 konusu (H-079)

Üçü birlikte "Türk öğrencinin üç klasik A1 hatası" paketi olur: *I from Türkiye* · *I am student* · *He work*.

| # | Konu | Neden |
|---|---|---|
| 1 | **G-A1-01-to-be** | En sık yapı; prologda ve ilk dört bölümün hepsinde var. Türkçede "olmak" ek olarak geldiği ve çoğu zaman görünmediği için *I from Türkiye* hatası çok yaygın. Prologda tam bu hata ✗ seçenek olarak duruyor (A1-000 Sahne 1). Pilot kitap A1-K01'in ilk sayfası *to be* cümleleriyle açılıyor. Hata kataloğunda karşılığı var (`be-dropped`). Sonraki bütün konuların önkoşulu. |
| 2 | **G-A1-03-a-an** | Türkçede artikel yok; "bir" çoğu zaman düşer. *I am student* ✗ seçeneği prologda (A1-000 Sahne 1), "here is a map" B2'de (A1-002), "A note." B4'te (A1-004), "It is an old building" A1-K01 p01'de. Hata kataloğu: `articles`. *the* (G-A1-04) için zemin hazırlar; artikeli tek derste anlatmak yerine önce kolay yarısını pilotluyoruz. |
| 3 | **G-A1-13-third-person-s** | Türkçede kişi ekinin mantığı İngilizcenin tersi; *She go* Türk öğrencinin en kalıcı hatası. S1'de A1-002 Sahne 2'de ("He loves radios!") geçiyor, A1-005'te Hi'nin açık notu var. Pilot kitap A1-K01'de 31 satırda, A1 kitaplarının hepsinde yoğun. Hata kataloğu: `third-person-s`. |

**Alternatifler:** G-A1-10-prepositions-time (B4'ün doğrudan hedefi; *It's in seven o'clock* ✗ seçeneği A1-004'te) ve G-A1-15-there-is-are (A1-K01'de 11 kez; ama S1'de ilk kez B6'da geçiyor, B1–B4'te yok). Pilotun 3. konusu G-A1-13 yerine G-A1-10 seçilirse dört pilot bölümle bağ daha güçlü olur; G-A1-13'ün değeri ise daha yüksek.

## Özet tablo

| ID | Türkçe ad | Seviye | Önkoşul |
|---|---|---|---|
| G-A1-01-to-be | *am / is / are*: "olmak" fiili ★ pilot | A1 | — |
| G-A1-02-to-be-questions-negatives | *to be* ile soru ve olumsuz | A1 | A1-01 |
| G-A1-03-a-an | *a / an*: "bir"i söylemek ★ pilot | A1 | A1-01 |
| G-A1-04-the | *the*: ikimizin bildiği şey | A1 | A1-03 |
| G-A1-05-pronouns-possessives | *he / she / it*, *me / him / her*, *my / your / his / her*, *'s* | A1 | A1-01 |
| G-A1-06-this-that-plurals | *this / that / these / those* ve çoğul *-s* | A1 | A1-01, A1-03 |
| G-A1-07-can | *can / can't*: yetenek, rica, kısa cevap | A1 | A1-02 |
| G-A1-08-imperatives | Emir kipi: *Go / Turn / Don't…* | A1 | — |
| G-A1-09-prepositions-place | Yer edatları: *in / on / under / near / between / behind* | A1 | A1-01, A1-04 |
| G-A1-10-prepositions-time | Saat ve gün: *at / on / in*, *What time is it?* | A1 | A1-01, A1-09 |
| G-A1-11-present-simple | Geniş zaman (present simple): *I / you / we / they* | A1 | A1-05, A1-10 |
| G-A1-12-word-order-svo | Kelime sırası: özne + fiil + nesne | A1 | A1-11 |
| G-A1-13-third-person-s | *He / she / it* ile fiile *-s* ★ pilot | A1 | A1-05, A1-11 |
| G-A1-14-do-does | *do / does* ile soru ve olumsuz | A1 | A1-13 |
| G-A1-15-there-is-are | *there is / there are*: "var" demek | A1 | A1-03, A1-06, A1-09 |
| G-A1-16-have-has | *have / has*: sahiplik ve tarif | A1 | A1-13, A1-15 |
| G-A2-01-present-continuous | Şimdiki zaman: *am / is / are + -ing* | A2 | A1-01, A1-11 |
| G-A2-02-simple-vs-continuous | Geniş zaman mı, şimdiki zaman mı? | A2 | A2-01, A1-14 |
| G-A2-03-was-were | *was / were*: geçmişte "idi" | A2 | A1-02 |
| G-A2-04-past-simple-regular | Geçmiş zaman: düzenli fiiller (*-ed*) | A2 | A2-03 |
| G-A2-05-past-simple-irregular | Geçmiş zaman: düzensiz fiiller | A2 | A2-04 |
| G-A2-06-past-questions-negatives | *did / didn't* ile geçmişte soru ve olumsuz | A2 | A1-14, A2-05 |
| G-A2-07-countable-uncountable | Sayılabilen ve sayılamayan: *some / any / much / many / a lot of* | A2 | A1-03, A1-06 |
| G-A2-08-comparatives | Karşılaştırma: *-er / more … than* | A2 | A1-01 |
| G-A2-09-superlatives | En üstünlük: *the -est / the most* | A2 | A2-08, A1-04 |
| G-A2-10-going-to | *going to*: plan ve kanıta dayalı tahmin | A2 | A2-01 |
| G-A2-11-will | *will*: anlık karar, söz, tahmin | A2 | A2-10 |
| G-A2-12-adverbs | Zarflar: *always / usually / never* ve *-ly* | A2 | A1-11, A1-12 |
| G-A2-13-conjunctions | Bağlaçlar: *and / but / because / so* ve *when* | A2 | A2-04 |
| G-A2-14-have-to-must-should | *have to / must / should*: zorunluluk ve öneri | A2 | A1-08, A1-14 |
| G-A2-15-verb-patterns | Fiilden sonra fiil: *want to*, *like + -ing* | A2 | A1-11 |
| G-B1-01-present-perfect-experience | Present perfect (1): deneyim, *ever / never* | B1 | A2-05, A2-06 |
| G-B1-02-present-perfect-since-for | Present perfect (2): *since / for* | B1 | B1-01 |
| G-B1-03-present-perfect-vs-past | Present perfect mi, past simple mı? *just / already / yet* | B1 | B1-01, B1-02 |
| G-B1-04-past-continuous | Past continuous ve *when / while* | B1 | A2-01, A2-05 |
| G-B1-05-used-to | *used to*: geçmişteki alışkanlık | B1 | A2-06 |
| G-B1-06-future-forms | Gelecek: *will*, *going to*, şimdiki zamanla randevu | B1 | A2-10, A2-11 |
| G-B1-07-zero-first-conditional | Koşul cümleleri: 0 ve 1. tip | B1 | A2-11, A2-13 |
| G-B1-08-defining-relative-clauses | Tanımlayan sıfat cümlecikleri: *who / which / that* | B1 | A2-04, A1-05 |
| G-B1-09-gerund-infinitive | *-ing* mi, *to* mu? Fiil kalıpları (2) | B1 | A2-15 |
| G-B1-10-might-may-could | Olasılık: *might / may / could* | B1 | A1-07, B1-06 |
| G-B1-11-past-perfect | Past perfect: "olmuştu" | B1 | B1-01, A2-05 |
| G-B1-12-ing-ed-adjectives | *bored* mı *boring* mi? *-ed / -ing* sıfatları | B1 | A1-01 |
| G-B1-13-indirect-questions | Dolaylı sorular: *Can you tell me where…?* | B1 | A1-02, A1-14 |
| G-B1-14-articles-general-specific | Artikeller (2): genel mi, belirli mi? | B1 | A1-04, A2-07 |
| G-B2-01-passive | Edilgen yapı: *be + V3* | B2 | A2-05, B1-01 |
| G-B2-02-reported-statements | Dolaylı anlatım (1): *say / tell*, zaman kaydırma | B2 | B1-11 |
| G-B2-03-reported-questions-commands | Dolaylı anlatım (2): soru ve rica aktarma | B2 | B2-02, B1-13 |
| G-B2-04-second-conditional | 2. tip koşul: gerçek dışı şimdi | B2 | B1-07, A2-04 |
| G-B2-05-third-conditional | 3. tip koşul: olmayan geçmiş | B2 | B2-04, B1-11 |
| G-B2-06-wish-if-only | *wish / if only*: dilek ve pişmanlık | B2 | B2-04, B2-05 |
| G-B2-07-past-modals-deduction | Geçmişe dair çıkarım: *must have / can't have / might have* | B2 | B1-10, B1-01 |
| G-B2-08-present-perfect-continuous | Present perfect continuous: *have been + -ing* | B2 | B1-02, A2-01 |
| G-B2-09-non-defining-relatives | Tanımlamayan sıfat cümlecikleri: virgüllü *who / which / whose* | B2 | B1-08 |
| G-B2-10-causative | Ettirgen: *have / get something done* | B2 | B2-01 |
| G-B2-11-future-continuous-perfect | *will be doing / will have done* | B2 | B1-06, B1-01 |
| G-B2-12-contrast-linkers | Zıtlık: *although / despite / however / whereas* | B2 | A2-13, B1-09 |
| G-C1-01-inversion | Devrik yapı: *Never have I…, Not only…* | C1 | B1-01, B1-11 |
| G-C1-02-cleft-sentences | Vurgulu yapılar: *It was… that…, What I need is…* | C1 | B1-08 |
| G-C1-03-mixed-conditionals | Karışık koşul cümleleri | C1 | B2-04, B2-05 |
| G-C1-04-participle-clauses | Ortaç yan cümleleri: *Having finished…, Walking home…* | C1 | B1-08, B2-01 |
| G-C1-05-modal-nuances | Modal incelikleri: *needn't have, be supposed to, would rather* | C1 | B2-07, A2-14 |
| G-C1-06-impersonal-passive | Kişisiz edilgen: *It is said that…, He is believed to…* | C1 | B2-01, B2-02 |
| G-C1-07-unreal-past | Gerçek dışı geçmiş: *It's time…, as if…* | C1 | B2-06 |
| G-C1-08-ellipsis-substitution | Eksiltme ve yerine koyma: *So do I, I hope not* | C1 | A1-14, A1-07 |
| G-C2-01-fronting | Öne alma ve bilgi yapısı: *Little did she know…, Such was…* | C2 | C1-01, C1-02 |
| G-C2-02-nominalisation | Adlaştırma: resmî ve akademik yazı | C2 | B2-01, C1-04 |
| G-C2-03-hedging-stance | Yumuşatma ve tutum: *It would appear that…, arguably* | C2 | C1-05, C1-06 |
| G-C2-04-formal-subjunctive | Resmî dilek kipi ve *if*'siz şart: *Should you…, Had I known…* | C2 | C1-01, C1-03 |
| G-C2-05-cohesion-discourse | Bağdaşıklık ve söylem belirleyicileri | C2 | B2-12, C1-08 |
| G-C2-06-aspect-nuance | Görünüş incelikleri: *She's being rude, I was wondering…* | C2 | A2-02, B2-08 |

Dağılım: A1 16 · A2 15 · B1 14 · B2 12 · C1 8 · C2 6 = **71** (plandaki "A1 ~15"ten bir fazla; gerekçe "Onay için" madde 1'de).
Önkoşul sütununda `G-` öneki kısaltıldı (A1-01 = G-A1-01-to-be).

## Onay için

Kullanıcının bakması gerekenler:

1. **Sayı ve dağılım:** A1'de 15 yerine 16 konu var. Fazlalık **G-A1-12-word-order-svo**: `DILBILGISI.md` §1 kelime sırasını Türk öğrencinin ana zorluklarından biri sayıyor ve A1-008'de *Seven Friday. O'clock seven. Forget don't.* ✗ seçeneği tam bu hatayı taşıyor. İstersen G-A1-11 ile birleştirip 15'e indirebilirim.
2. **Pilot 3 konu:** Öneri G-A1-01, G-A1-03, G-A1-13 (gerekçe yukarıda). Alternatif: G-A1-13 yerine G-A1-10 (B4 ile bağ daha güçlü).
3. **A1 sırası:** Sıra S1'deki ilk görünüşe göre kuruldu (prolog → B4 önce). *there is/are* (S1·B6) ve *have/has* (S1·B7) bu yüzden sonda; A1 kitaplarında ise baştan beri yoğun. Kitap okuyanlar için "Hikâyende geçenler" bu konuları zaten öne çıkarır. Uygun mu?
4. **S1'deki kalıplar:** *It's raining* (B11), *I'm looking for…* (B12), *I'll take it* (B10), *She was here* (B5) S1'de kalıp olarak geçiyor; konuları A2'de. A1 bölüm panelinde bunlar için A2 dersi mi önerilsin, yoksa yalnız "kalıp notu" mu gösterilsin?
5. **Terim dili:** Konu adlarında İngilizce terim + Türkçe karşılık birlikte kullanıldı (ör. "Geniş zaman (present simple)"). "Geniş zaman" Türk okulunda yerleşik ama birebir eş değil; derste bu fark bir cümleyle söylenecek. `ARAYUZ-METINLERI.md` §2 terim listesine eklensin mi?
6. **Seviye sınırları:** *-ing / -ed* sıfatları (B1-12) ve dolaylı sorular (B1-13) bazı kaynaklarda A2'de. A2 kitabında (A2-K05 p03) geçtiği için A2'ye çekmek de mümkün. C1-08 (eksiltme) temel biçimiyle aslında A2–B1; C1'de üslup ve incelik olarak işleniyor.
7. **C2 konuları:** C2-03 ve C2-05 saf dilbilgisinden çok üslup ve söylem. C2 kitaplarının dil odağıyla (ironi, register, güvenilmez anlatıcı; `KATALOG.md` madde 6) uyumlu olduğu için seçildi. Uygun mu?
8. **Seviyeye göre sadeleştirme notu:** A2-K04 p09 *Soon they were the biggest clouds Nia ever saw.* cümlesi A2 sınırı yüzünden past perfect yerine past simple kullanıyor (Amerikan İngilizcesinde konuşma dilinde kabul görür, standart yazıda *had ever seen*). B1-01/B1-11 derslerinde bu cümleyi karşılaştırma için kullanmayı öneriyorum; öğretmen kontrolünde değerlendirilsin.
9. **Öğretmen kontrolü:** Her konunun kuralı, karşılaştırma notu ve tipik hata satırı yayından önce öğretmen ya da editör tarafından kontrol edilmeli (`DILBILGISI.md` §5). Bu belgede yalnız konu listesi var; kural anlatımı H-077 sonrası yazılacak.
10. **Lisans:** CEFR-J Grammar Profile yalnız sıra için referans alındı; Tono Lab yazılı teyidi hâlâ bekleniyor (`LISANS-RAPORU.md`). Teyit olumsuz gelirse sıra kendi gözlemimize (S1 ve kitaplar) dayandığı için değişmesi gerekmez.

---

## A1 (16 konu)

### G-A1-01-to-be · *am / is / are*: "olmak" fiili ★ pilot
- **Hedef:** Kendini ve başkasını tanıtırken *am / is / are*'ı doğru kişiyle kullanır.
- **Önkoşul:** —
- **Türkçeyle karşılaştırma:** Türkçede "olmak" çoğu zaman ek olarak gelir (öğrenci*yim*, İzmirli*yiz*) ve "o" için hiç görünmez ("O yorgun"). İngilizcede ayrı bir kelime şarttır; cümle fiilsiz kalamaz. Kişiye göre üç biçimi vardır.
- **Tipik hata:** *I from Türkiye.* → *I'm from Türkiye.* · *She very happy.* → *She is very happy.* (Tersi için bkz. G-A1-11: *I am agree*.)
- **Örnekler:** *I'm from İzmir.* · *My mother is a teacher.*
- **Hikâye bağı:**
  - A1-000 Sahne 1 (Pasaport kontrolü): ✓ "I'm from Türkiye." / ✗ "I from Türkiye."
  - A1-001 Sahne 1 (Cuma akşamı): VOICE "This is E." · ALEX "Who are you?"
  - A1-002 Sahne 1 (Tide & Pages): MAYA "Hi, Alex! I'm Maya." · ALEX "I'm your new neighbour."
  - A1-K01 p01: "Lina is eleven." · p03: "She is old and small."
- **Hata kataloğu:** `be-dropped`

### G-A1-02-to-be-questions-negatives · *to be* ile soru ve olumsuz
- **Hedef:** *am / is / are*'ı özneden önce getirerek soru, *not* ile olumsuz kurar; soru kelimesini başa koyar (*Where is…?*).
- **Önkoşul:** G-A1-01
- **Türkçeyle karşılaştırma:** Türkçede soru *mi* ekiyle kurulur, sıra değişmez; soru kelimesi yüklemin hemen önündedir ("İstasyon nerede?"). İngilizcede soru kelimesi başa, *be* özneden önceye geçer. Olumsuzda Türkçe "değil" sondadır; İngilizcede *not* hemen *be*'den sonra gelir.
- **Tipik hata:** *Where station?* / *Station where?* → *Where is the station?* · *You are new here?* (yalnız tonlamayla) → *Are you new here?* · *I not tired.* → *I'm not tired.*
- **Örnekler:** *Are you from Ankara? — No, I'm not.* · *Where is the bus stop?*
- **Hikâye bağı:**
  - A1-001 Sahne 3 (Harita): ALEX "Where is the old station?"
  - A1-002 Sahne 2 (Aile): ✓ "Excuse me, where is the old station?" / ✗ "Where station?"
  - A1-002 Sahne 3 (Harita): ALEX "Is it far?" · MAYA "No, it isn't."
  - A1-003 Sahne 1 (Sokakta): ✗ "Harbour where?"
  - A1-004 Sahne 1 (Tide & Pages): MAYA "What day is it today?"
  - A1-K04 p04: "Pip is not tired." · A1-K05 p04: "Is it the wind?"
- **Hata kataloğu:** `question-word-order`, `be-dropped`

### G-A1-03-a-an · *a / an*: "bir"i söylemek ★ pilot
- **Hedef:** Tekil, sayılabilir ismin önüne *a / an* koyar; meslek ve "bu ne?" cevabında unutmaz; *an*'ı sesli harfle başlayan **sesten** önce kullanır.
- **Önkoşul:** G-A1-01
- **Türkçeyle karşılaştırma:** Türkçede "bir" çoğu zaman söylenmez: "Ben öğrenciyim", "İşte harita". İngilizcede tekil sayılabilir isim yalnız duramaz: *a student*, *a map*. Meslek söylerken de gerekir. *a / an* seçimi harfe değil sese bakar (*an hour*, *a university*).
- **Tipik hata:** *I am student.* → *I'm a student.* · *It is old building.* → *It's an old building.* · *a umbrella* → *an umbrella*
- **Örnekler:** *I'm a student.* · *Can I have an apple, please?*
- **Hikâye bağı:**
  - A1-000 Sahne 1 (Pasaport kontrolü): ✓ "I'm a student." / ✗ "I am student."
  - A1-002 Sahne 3 (Harita): MAYA "Look, here is a map."
  - A1-004 Sahne 1 (Tide & Pages): ALEX "A note. From the old station."
  - A1-009 Sahne 1 (Sipariş): MAYA "Can I have an orange juice, please?" · A1-011 Sahne 3 (Hazırlık): MAYA "Take an umbrella, too."
  - A1-K01 p01: "It is an old building on a river." · p02: "In one box, there is a red pot."
- **Hata kataloğu:** `articles`

### G-A1-04-the · *the*: ikimizin bildiği şey
- **Hedef:** Konuşanın ve dinleyenin bildiği, daha önce söz edilen ya da tek olan şey için *the* kullanır; ilk söz edişte *a*, sonra *the* der.
- **Önkoşul:** G-A1-03
- **Türkçeyle karşılaştırma:** Türkçede *the*'nin karşılığı yoktur; belirlilik belirtme hâli (-ı: "Kitab*ı* aldım") ya da bağlamla anlaşılır. İngilizcede bir kelimeyle her seferinde işaretlenir. Türk öğrenci ya hiç kullanmaz ya da her yere koyar (genel anlam için bkz. G-B1-14).
- **Tipik hata:** *Where is old station?* → *Where is the old station?* · *I saw a man. A man was tall.* → *The man was tall.*
- **Örnekler:** *There is a cat in the garden. The cat is black.* · *Can you close the door, please?*
- **Hikâye bağı:**
  - A1-001 Sahne 1 (Cuma akşamı): VOICE "Meet me at the old station."
  - A1-002 Sahne 3 (Harita) "here is **a** map" ile Sahne 2'deki "**The** old station? It's near the harbour." karşılaştırması
  - A1-003 Sahne 1 (Sokakta): ✓ "Excuse me, where is the harbour?"
  - A1-K01 p01: "On the top floor, there is one door." · p04: "There is a light under the blue door!"
- **Hata kataloğu:** `articles`

### G-A1-05-pronouns-possessives · *he / she / it*, *me / him / her*, *my / your / his / her* ve *'s*
- **Hedef:** Özne, nesne ve iyelik zamirlerini kişiye ve cinsiyete göre seçer; *'s* ile sahiplik söyler (*Ravi's kite*).
- **Önkoşul:** G-A1-01
- **Türkçeyle karşılaştırma:** Türkçede tek "o" vardır, cinsiyet ayrımı yoktur. İngilizcede *he* (erkek), *she* (kadın), *it* (eşya, hayvan) ayrılır; "onu/ona" → *him / her*, "onun" → *his / her*. Türkçede iyelik ekle (kitab*ım*), İngilizcede isimden önce kelimeyle (*my book*). "Ali'nin" → *Ali's*.
- **Tipik hata:** Kadın için *he* (ya da tersi) · *She is name Ayşe.* → *Her name is Ayşe.* · *Sorry me.* ("kusura bakma"dan) → *Sorry.* / *Excuse me.*
- **Örnekler:** *This is my brother. He likes football.* · *Her name is Elif.*
- **Hikâye bağı:**
  - A1-000 Sahne 1 (Pasaport kontrolü): ✓ "My name is Aleyna Yıldız." / ✗ "Name Aleyna." · ALEX "Just call me Alex."
  - A1-001 Sahne 1 (Cuma akşamı): VOICE "Can you hear me?" · "Meet me at the old station."
  - A1-002 Sahne 2 (Aile): MAYA "This is my mother." · "He loves radios!"
  - A1-005 Sahne 2 (Pier 3): ✗ "I am late, sorry me."
  - A1-007 Sahne 2 (Tide & Pages): ✗ "He has white hair." (kadını tarif ederken)
  - A1-K01 p02: "Lina helps her." · "But her window is small." · A1-K03 p01: "Today, Ravi's red kite flies over the town."

### G-A1-06-this-that-plurals · *this / that / these / those* ve çoğul *-s*
- **Hedef:** Yakın–uzak ve tekil–çoğul ayrımıyla gösterir, tanıtır (*This is my…*); çoğulu *-s* ile yapar, sık düzensizleri tanır (*people, children*).
- **Önkoşul:** G-A1-01, G-A1-03
- **Türkçeyle karşılaştırma:** Türkçede sayıdan sonra çoğul eki gelmez ("iki kitap"); İngilizcede gelir (*two books*). Türkçe tanıtırken fiilsizdir ("Bu annem"); İngilizcede *is* şarttır. *these / those* çoğuldur ve *are* ister.
- **Tipik hata:** *two book* → *two books* · *This my friend.* → *This is my friend.* · *These is…* → *These are…*
- **Örnekler:** *This is my friend, Can.* · *Those shoes are new.*
- **Hikâye bağı:**
  - A1-001 Sahne 1 (Cuma akşamı): VOICE "This is E."
  - A1-002 Sahne 2 (Aile): MAYA "This is my mother." · "And this is my cousin, Sam."
  - A1-003 Sahne 3 (Old Station): ALEX "This is the old station!"
  - A1-010 Sahne 1 (Grant's Spare Parts): "Is this Mr Grant's shop?"
  - A1-K01 p01: "It has five floors." · A1-K02 p02: "This is the bread shop!" · A2-K03 p03: "These are the house rules," · A2-K04 p07: "What are those?"

### G-A1-07-can · *can / can't*: yetenek, rica ve kısa cevap
- **Hedef:** *can* + yalın fiille yapabildiğini, rica ve izni söyler; *Can you…?* sorusuna *Yes, I can. / No, I can't.* diye cevap verir.
- **Önkoşul:** G-A1-02
- **Türkçeyle karşılaştırma:** Türkçede "-ebil" eki fiile yapışır ("duyabiliyorum") ve kısa cevapta fiil tekrarlanır ("Evet, duyuyorum"). İngilizcede *can* ayrı kelimedir, kişiye göre değişmez, ardından *to* gelmez; kısa cevap sorudaki yardımcıyla verilir.
- **Tipik hata:** *Can you hear me? — Yes, I am.* → *Yes, I can.* · *She cans swim.* / *I can to swim.* → *She can swim.* / *I can swim.*
- **Örnekler:** *Can you help me, please?* · *My brother can't swim.*
- **Hikâye bağı:**
  - A1-001 Sahne 1 (Cuma akşamı): VOICE "Can you hear me?" · ✓ "Yes, I can hear you." / ✗ "Yes, I am."
  - A1-002 Sahne 1 (Tide & Pages): MAYA "Can I help you?" · Sahne 3 (Harita): "I can show you."
  - A1-007 Sahne 2 (Tide & Pages): MRS BROOKS "She can't walk fast."
  - A1-010 Sahne 3 (Tepede): ✗ "Yes, I am!" (aynı hata tekrar)
  - A1-K01 p04: "At night, Lina can't sleep." · A1-K04 p01: "Pip can do many things."
- **Hata kataloğu:** `can-short-answer`

### G-A1-08-imperatives · Emir kipi: *Go / Turn / Don't…*
- **Hedef:** Talimat, yol tarifi ve uyarıda cümleye yalın fiille başlar; olumsuzunu *Don't* ile yapar; *please* ve *Can you…?* ile yumuşatır.
- **Önkoşul:** —
- **Türkçeyle karşılaştırma:** Türkçede emir "Gel / Gelin", olumsuz "-me" ekiyle ("Gelme"). İngilizcede tek biçim vardır; olumsuz için başa *Don't* gelir. Türkçedeki "-in" nezaketinin eki yoktur; nezaket *please* ve soru biçimiyle kurulur.
- **Tipik hata:** *No go!* / *Not go!* → *Don't go!* · *Forget don't.* → *Don't forget.* · Rica ederken *Help me!* → *Can you help me, please?*
- **Örnekler:** *Go straight and turn left.* · *Don't open the window, please.*
- **Hikâye bağı:**
  - A1-001 Sahne 1 (Cuma akşamı): VOICE "Meet me at the old station."
  - A1-003 Sahne 1 (Sokakta): MAN "Go straight. Then turn left."
  - A1-004 Sahne 2 (Gün ve saat): MAYA "Look, a clock."
  - A1-008 Sahne 3 (Babaannenin notu): ✗ "Seven Friday. O'clock seven. Forget don't." (doğrusu "Don't forget.")
  - A1-011 Sahne 3 (Hazırlık): MAYA "Take an umbrella, too." · A1-012 Sahne 1 (Kapıda): ✓ "Can you help me, please?" / ✗ "Help me!"
  - A1-K03 p03: "Don't be sad." · A2-K02 p05: "Don't move," said Jonas.

### G-A1-09-prepositions-place · Yer edatları: *in / on / under / near / between / behind*
- **Hedef:** Bir şeyin nerede olduğunu edatla söyler; edatı ismin **önüne** koyar.
- **Önkoşul:** G-A1-01, G-A1-04
- **Türkçeyle karşılaştırma:** Türkçede yer, ismin sonundaki ekle (-de) ya da isimden sonra gelen kelimeyle ("limanın yakınında", "masanın altında") söylenir. İngilizcede sıra terstir: *near the harbour*, *under the table*. Türkçedeki tek "-de", İngilizcede *in / on / at* olarak ayrılır.
- **Tipik hata:** *the harbour near* → *near the harbour* · *in the desk* ("masada", üstünde anlamında) → *on the desk* · *between Pier 2 Pier 4* → *between Pier 2 and Pier 4*
- **Örnekler:** *The cat is under the table.* · *The bank is between the café and the school.*
- **Hikâye bağı:**
  - A1-002 Sahne 2 (Aile): MAYA "It's near the harbour."
  - A1-004 Sahne 3 (Yer): MAYA "It's between Pier 2 and Pier 4."
  - A1-006 Sahne 1 (Sam'in odası): MAYA "There is a radio on the desk." · SAM "And there is a box under the bed."
  - A1-K01 p01: "Who lives behind the blue door?" · A1-K05 p02: "The shop is under his flat."
- **Hata kataloğu:** `place-preposition`

### G-A1-10-prepositions-time · Saat ve gün: *at / on / in*, *What time is it?*
- **Hedef:** Saati *at*, günü *on*, gün bölümünü *in the morning / evening* ile söyler; saati sorar ve *It's … o'clock* ile cevaplar.
- **Önkoşul:** G-A1-01, G-A1-09
- **Türkçeyle karşılaştırma:** Türkçede tek bir ek yeter: "yedi*de*, cuma günü, akşam*leyin*". İngilizcede üç ayrı edat vardır. Saat söylerken Türkçede özne yoktur ("Saat yedi"); İngilizcede *It's* gerekir. Gün adları büyük harfle yazılır.
- **Tipik hata:** *It's in seven o'clock.* → *It's seven o'clock.* · *in seven* / *in two o'clock* → *at seven* / *at two o'clock* · *at Friday* → *on Friday*
- **Örnekler:** *My class starts at nine.* · *We play football on Saturday.*
- **Hikâye bağı:**
  - A1-004 Sahne 1 (Tide & Pages): MAYA "I have History at nine."
  - A1-004 Sahne 2 (Gün ve saat): ✓ "It's seven o'clock." / ✗ "It's in seven o'clock." · MAYA "On Friday at seven."
  - A1-004 Dil laboratuvarı: ✓ "At two o'clock." / ✗ "In two o'clock."
  - A1-006 Sahne 3 (Kayıt): VOICE "I'm at Lumen Point on Saturdays."
  - A1-K01 p03: "In the evening, Lina meets two neighbours." · p04: "At ten o'clock, the light goes off." · A1-K02 p01: "On Saturday, it is Ece's birthday."
- **Hata kataloğu:** `time-preposition`

### G-A1-11-present-simple · Geniş zaman (present simple): *I / you / we / they*
- **Hedef:** Rutini, alışkanlığı ve genel doğruları yalın fiille, *every day, on Fridays* gibi zaman ifadeleriyle anlatır.
- **Önkoşul:** G-A1-05, G-A1-10
- **Türkçeyle karşılaştırma:** Türkçede kişi fiilin ekinden anlaşılır ("çalışırım"), özne düşebilir; İngilizcede özne zorunludur. Türkçede rutin için "-iyor" da kullanılır ("Her gün yürüyorum"); İngilizcede rutin present simple ile söylenir. "Katılıyorum" gibi fiillerde Türkçe "ben … -im" kalıbı akla gelir ve gereksiz *am* eklenir.
- **Tipik hata:** *I am agree.* → *I agree.* · *I am work here.* → *I work here.* · *Every day I am walking.* → *I walk every day.*
- **Örnekler:** *I work in a café.* · *We watch films on Fridays.*
- **Hikâye bağı:**
  - A1-005 Sahne 3 (Jordan anlatıyor): JORDAN "I work here every day."
  - A1-008 Sahne 1 (Tepe yolunda): ALEX "I think it's a recording."
  - A1-K01 p01: "Lina and her mum live on floor four."
- **Hata kataloğu:** `agree-no-be`

### G-A1-12-word-order-svo · Kelime sırası: özne + fiil + nesne
- **Hedef:** Cümleyi özne + fiil + nesne (+ yer + zaman) sırasıyla kurar; fiili sona atmaz.
- **Önkoşul:** G-A1-11
- **Türkçeyle karşılaştırma:** Türkçe özne–nesne–yüklem sıralıdır ve sıra esnektir, çünkü görevi ekler gösterir ("Çayı ben içerim"). İngilizcede görevi **sıra** gösterir: fiil öznenin hemen ardından gelir, yer ve zaman çoğunlukla sondadır. Sıra değişirse anlam değişir (*The dog sees the cat* ≠ *The cat sees the dog*).
- **Tipik hata:** *I tea drink.* → *I drink tea.* · *Every day coffee I drink.* → *I drink coffee every day.* · *Seven Friday. O'clock seven.* → *Friday, seven o'clock.*
- **Örnekler:** *I drink tea in the morning.* · *Maya opens the shop at nine.*
- **Hikâye bağı:**
  - A1-001 Sahne 3 (Harita): kelime sıralama görevi "Where / is / the / old / station / ?"
  - A1-008 Sahne 3 (Babaannenin notu): ✗ "Seven Friday. O'clock seven. Forget don't."
  - A1-K01 p02: "Mum carries boxes into the flat." · A1-K02 p03: "He can see Mert's window."
- **Hata kataloğu:** `question-word-order` (soru sırası için)

### G-A1-13-third-person-s · *He / she / it* ile fiile *-s* ★ pilot
- **Hedef:** Geniş zamanda *he / she / it* ve tekil isimle fiile *-s / -es* ekler; *has, does, goes* gibi biçimleri bilir.
- **Önkoşul:** G-A1-05, G-A1-11
- **Türkçeyle karşılaştırma:** Türkçede fiil her kişide ek alır ama üçüncü tekil çoğu zaman eksizdir ("çalışırım / çalışır"). İngilizce tam tersidir: yalnız *he / she / it*'te ek vardır. Bu yüzden *-s* ya unutulur ya da yanlış kişiye eklenir (*they works*). Aynı anda *he / she* seçimi (G-A1-05) de gerekir.
- **Tipik hata:** *She go to school.* → *She goes to school.* · *He work every day.* → *He works every day.* · *They works.* → *They work.*
- **Örnekler:** *My father works in a bank.* · *She watches TV every evening.*
- **Hikâye bağı:**
  - A1-002 Sahne 2 (Aile): MAYA "He loves radios!"
  - A1-005 Sahne 3 (Jordan anlatıyor): JORDAN "She waits. She looks at the sea." (bu bölümde Hi'nin *-s* notu var)
  - A1-012 Sahne 4 (Not): TOM "She comes here every Saturday."
  - A1-K01 p01: "Lina runs up the steps." (A1-K01'de 31 satırda) · A1-K02 p01: "He lives in Ankara." · A1-K04 p02: "Every evening, Pip works in the house."
- **Hata kataloğu:** `third-person-s`

### G-A1-14-do-does · *do / does* ile soru ve olumsuz
- **Hedef:** Geniş zamanda soru ve olumsuzu *do / does* ile kurar; *does*'tan sonra fiili yalın bırakır; *What does she look like?* gibi kalıpları kullanır.
- **Önkoşul:** G-A1-13
- **Türkçeyle karşılaştırma:** Türkçede soru *mi*, olumsuz *-mez* ekiyle fiilin kendisindedir. İngilizcede anlamı olmayan bir yardımcı (*do / does*) gerekir ve *-s* yardımcıya geçer: *She works* → *Does she work?* Türkçede böyle bir yardımcı olmadığı için soru çoğu zaman yalnız tonlamayla sorulur.
- **Tipik hata:** *You know it?* → *Do you know it?* · *She doesn't works.* → *She doesn't work.* · *Where she lives?* → *Where does she live?* · Görünüş için *How is she?* → *What does she look like?*
- **Örnekler:** *Do you like coffee? — No, I don't.* · *Where does your sister live?*
- **Hikâye bağı:**
  - A1-007 Sahne 1 (Limanda Jordan): ✓ "What does she look like?" / ✗ "How is she?" · JORDAN "I don't know her name."
  - A1-009 Sahne 2 (Kayıt): ✓ "Do you know this voice?" / ✗ "You know it?"
  - A1-K01 p01: "It does not open." · A1-K03 p01: "Where does the kite go today?" · A1-K04 p03: "Robots don't sleep," says Pip. · A1-K05 p01: "What does she see?"

### G-A1-15-there-is-are · *there is / there are*: "var" demek
- **Hedef:** Bir yerde bir şeyin olduğunu ya da olmadığını *there is / are* ile söyler; tekil–çoğula göre seçer; *Is there…?* ile sorar.
- **Önkoşul:** G-A1-03, G-A1-06, G-A1-09
- **Türkçeyle karşılaştırma:** Türkçede "var / yok" tek kelimedir ve sondadır: "Masada bir telsiz var." İngilizcede yapı başa, yer sona gelir: *There is a radio on the desk.* "Var" sahiplik için de kullanıldığından *have* ile karışır: "Kedim var" → *I have a cat*, "Bahçede kedi var" → *There is a cat in the garden*.
- **Tipik hata:** *There is two boxes.* → *There are two boxes.* · *In the room have a bed.* → *There is a bed in the room.* · *There is a park?* → *Is there a park?*
- **Örnekler:** *There is a park near my house.* · *There are three cats in the garden.*
- **Hikâye bağı:**
  - A1-006 Sahne 1 (Sam'in odası): MAYA "There is a radio on the desk." · "There are cables everywhere!" · SAM "And there is a box under the bed."
  - A1-K01 p01: "On the top floor, there is one door." (A1-K01'de 11 satırda) · A1-K03 p02: "There are tall trees and green grass."
  - A2-K02 p04: "Is there a church up here?" asked Paloma. · A2-K05 p10: "There aren't any trees on the beach."
  - S1'de B1–B4'te geçmiyor.

### G-A1-16-have-has · *have / has*: sahiplik ve tarif
- **Hedef:** Sahipliği, aileyi, programı ve dış görünüşü *have / has* ile söyler; *he / she / it* ile *has* kullanır.
- **Önkoşul:** G-A1-13, G-A1-15
- **Türkçeyle karşılaştırma:** Türkçede sahiplik "var" ve iyelik ekiyle kurulur: "Onun beyaz saçları var." İngilizcede sahip olan kişi özne olur: *She has white hair.* "Saç" İngilizcede sayılamaz (*hair*, *hairs* değil). Yaş *have* ile değil *be* ile söylenir.
- **Tipik hata:** *She have a car.* → *She has a car.* · *Her hairs are white.* → *She has white hair.* · *I have 19 years.* → *I'm 19.*
- **Örnekler:** *I have two brothers.* · *My grandmother has a small garden.*
- **Hikâye bağı:**
  - A1-004 Sahne 1 (Tide & Pages): MAYA "I have History at nine."
  - A1-007 Sahne 1 (Limanda Jordan): JORDAN "She has short hair." · "She has a blue coat."
  - A1-012 Sahne 4 (Not): ALEX "She has white hair?"
  - A1-K01 p01: "Today she has a new home." · "It has five floors." · A1-K04 p01: "He has two arms and one wheel."

---

## A2 (15 konu)

### G-A2-01-present-continuous · Şimdiki zaman: *am / is / are + -ing*
- **Hedef:** Şu anda olan ve geçici durumları *be + -ing* ile anlatır.
- **Önkoşul:** G-A1-01, G-A1-11
- **Türkçeyle karşılaştırma:** Türkçe "-iyor" hem şu anı hem rutini anlatır. İngilizcede *-ing* yalnız şu an ve geçici durum içindir. Türkçede "-iyor" tek ek olduğundan *be* sık düşer.
- **Tipik hata:** *I am look for…* → *I'm looking for…* · *I looking.* → *I'm looking.* · *It is rain.* → *It's raining.*
- **Örnekler:** *I'm reading a book now.* · *Look, the children are playing in the park.*
- **Hikâye bağı:**
  - A1-011 Sahne 1 (Hava durumu): SPIKER "And it's raining in the evening." · ✗ "It is rain." (S1'de kalıp)
  - A1-012 Sahne 1 (Kapıda): ✓ "I'm looking for the old radio." / ✗ "I am look for the old radio." (S1'de kalıp)
  - A2-K02 p01: "Mrs Berg is talking." · p03: "Some clouds are coming."

### G-A2-02-simple-vs-continuous · Geniş zaman mı, şimdiki zaman mı?
- **Hedef:** Rutin ve genel doğruyu present simple, şu an ve geçici olanı present continuous ile ayırır; *know, like, want* gibi durum fiillerini *-ing*'siz kullanır.
- **Önkoşul:** G-A2-01, G-A1-14
- **Türkçeyle karşılaştırma:** Türkçe "-iyor" iki alanı da kapsar: "Seni anlıyorum", "Her sabah çay içiyorum". İngilizcede ilki *I understand you* (durum fiili), ikincisi *I drink tea every morning* (rutin) olur.
- **Tipik hata:** *I am knowing.* → *I know.* · *Every morning I am drinking tea.* → *I drink tea every morning.*
- **Örnekler:** *I usually walk to school, but today I'm taking the bus.* · *She likes music. She's listening to it now.*
- **Hikâye bağı:**
  - A1-005 Sahne 3 (Jordan anlatıyor): "I work here every day." ↔ A1-012 Sahne 1 (Kapıda): "I'm looking for the old radio."
  - A2-K03 p03: "At night, he always sleeps in the children's room." ↔ A2-K02 p01: "Mrs Berg is talking."

### G-A2-03-was-were · *was / were*: geçmişte "idi"
- **Hedef:** Geçmişteki durum, yer ve özellikleri *was / were* ile söyler; soru ve olumsuzunu kurar.
- **Önkoşul:** G-A1-02
- **Türkçeyle karşılaştırma:** Türkçede "-di" ek olarak gelir ("evdeydim"); İngilizcede ayrı kelimedir ve kişiye göre *was / were* olur. Türkçedeki "-di / -miş" ayrımı İngilizcede yoktur; ikisi de *was*.
- **Tipik hata:** *She here yesterday.* → *She was here yesterday.* · *They was…* → *They were…* · *I was go.* → *I went.*
- **Örnekler:** *I was at home yesterday.* · *Were you tired after the trip?*
- **Hikâye bağı:**
  - A1-005 Sahne 3 (Jordan anlatıyor): JORDAN "A woman was here!" (S1'de yalnız tanıma)
  - A1-006 Sahne 4 (Hangisi doğru?): ALEX "She was here." · A1-009 Sahne 2 (Kayıt): ROSA "The radio club was here."
  - A2-K03 p01: "Max was sixteen, and he wanted a guitar." · A2-K02 p01: "In the morning, the sky was blue and clear."

### G-A2-04-past-simple-regular · Geçmiş zaman: düzenli fiiller (*-ed*)
- **Hedef:** Bitmiş geçmiş olayları *-ed* ile anlatır; *-ed*'in üç okunuşunu tanır (*worked* /t/, *lived* /d/, *waited* /ɪd/).
- **Önkoşul:** G-A2-03
- **Türkçeyle karşılaştırma:** Türkçede geçmiş eki kişi ekiyle birlikte gelir ("çalıştım, çalıştılar"); İngilizcede *-ed* bütün kişilerde aynıdır. "Gördüm" ile "görmüş" ayrımı İngilizcede yoktur. Yazıma bakıp *worked*'ü "vörkıd" diye okumak sık görülür.
- **Tipik hata:** *Yesterday I walk to school.* → *walked* · *worked* sonunu ayrı hece okumak
- **Örnekler:** *We watched a film last night.* · *She opened the window and smiled.*
- **Hikâye bağı:**
  - A2-K04 p01: "She lived in Lunaria, a small town under a glass roof."
  - A2-K01 p01: "The day before the contest, the famous recipe disappeared."
  - A2-K03 p01: "…he listened carefully."
  - S1'de henüz yok (S2'de).

### G-A2-05-past-simple-irregular · Geçmiş zaman: düzensiz fiiller
- **Hedef:** Sık düzensiz fiillerin geçmiş biçimlerini (*went, saw, took, came, said*) tanır ve kullanır.
- **Önkoşul:** G-A2-04
- **Türkçeyle karşılaştırma:** Türkçede bütün fiiller aynı ekle geçmişe döner; düzensiz fiil yoktur. Bu yüzden yük tamamen yenidir. Derste hikâyede en sık geçenlerden başlanır.
- **Tipik hata:** *goed / taked* → *went / took* · *I go to the beach yesterday.* → *I went…*
- **Örnekler:** *I went to the beach on Saturday.* · *We saw a big ship near the sea.*
- **Hikâye bağı:**
  - A2-K01 p01: "Who took it?"
  - A2-K02 p01: "When the fog came down, the path disappeared."
  - A2-K05 p09: "He saw the sand, the black rocks, the café and many people."

### G-A2-06-past-questions-negatives · *did / didn't* ile geçmişte soru ve olumsuz
- **Hedef:** Geçmişte soru ve olumsuzu *did / didn't* ile kurar; *did*'den sonra fiili yalın bırakır.
- **Önkoşul:** G-A1-14, G-A2-05
- **Türkçeyle karşılaştırma:** Türkçede "gitmedim / gittin mi?" eklerle kurulur. İngilizcede geçmişlik *did*'e geçer, ana fiil yalına döner. Öğrenci geçmişi iki kez işaretler.
- **Tipik hata:** *I didn't went.* → *I didn't go.* · *Did you saw…?* → *Did you see…?* · *You went there?* (yalnız tonlama) → *Did you go there?*
- **Örnekler:** *Did you call your mum?* · *I didn't see the message.*
- **Hikâye bağı:**
  - A2-K05 p04: "Why did the photos stop?"
  - A2-K01 p04: "Limon didn't move." · p06: "Did you take the recipe card?" Elif asked him.

### G-A2-07-countable-uncountable · Sayılabilen ve sayılamayan: *some / any / much / many / a lot of*
- **Hedef:** İsmin sayılıp sayılamadığını ayırır; *some / any*, *much / many* ve *a lot of*'u doğru kullanır.
- **Önkoşul:** G-A1-03, G-A1-06
- **Türkçeyle karşılaştırma:** Türkçede neredeyse her şey sayılır ("iki su", "bilgiler", "tavsiyeler"). İngilizcede *water, information, advice, hair, homework* sayılamaz; *a / an* ve *-s* almaz. "Biraz" olumluda *some*, soru ve olumsuzda çoğu zaman *any* olur.
- **Tipik hata:** *informations / advices* → *information / advice* · *many water* → *a lot of water* · *I don't have some money.* → *I don't have any money.*
- **Örnekler:** *Can I have some water, please?* · *There aren't any eggs in the fridge.*
- **Hikâye bağı:**
  - A1-000 Sahne 1 (Pasaport kontrolü): OFFICER "I have some questions."
  - A1-009 Sahne 1 (Sipariş): "Some cake for you!" · SAM "And some milk, please?"
  - A1-K01 p02: "There is not much sun here." · A2-K05 p10: "There aren't any trees on the beach." · p09: "You have a lot of time."

### G-A2-08-comparatives · Karşılaştırma: *-er / more … than*
- **Hedef:** İki şeyi *-er* ya da *more* + sıfat + *than* ile karşılaştırır; *better / worse*'ü bilir.
- **Önkoşul:** G-A1-01
- **Türkçeyle karşılaştırma:** Türkçede "Ay'*dan* daha büyük": ölçüt sıfattan önce gelir, sıfat değişmez. İngilizcede sıfat değişir (*bigger*) ve ölçüt sonra gelir (*than the Moon*).
- **Tipik hata:** *more big* → *bigger* · *more better* → *better* · *bigger from me* → *bigger than me*
- **Örnekler:** *My brother is taller than me.* · *This book is more interesting than the film.*
- **Hikâye bağı:**
  - A2-K01 p09: "It's more sour than a lemon," said Bora.
  - A2-K04 p03: "The Earth was much bigger than the Moon."
  - A2-K05 p10: "Higher than the café, but lower than our hill."

### G-A2-09-superlatives · En üstünlük: *the -est / the most*
- **Hedef:** Bir grubun "en"ini *the -est / the most* ile söyler; grubu *in* ya da *of* ile belirtir.
- **Önkoşul:** G-A2-08, G-A1-04
- **Türkçeyle karşılaştırma:** Türkçede "en" tek kelimedir, sıfat değişmez, *the* yoktur. "Dünyanın en iyisi" → *the best in the world* (Türkçedeki tamlama yüzünden *of the world* denir).
- **Tipik hata:** *most big* → *the biggest* · *She is best student.* → *She is the best student.* · *the best of the world* → *the best in the world*
- **Örnekler:** *This is the biggest room in the house.* · *She's the best player in our team.*
- **Hikâye bağı:**
  - A2-K01 p01: "The most famous thing in the restaurant was a cake."
  - A2-K03 p07: "They said it was the best pancake in the world."
  - A2-K05 p08: "It's the brightest house on the hill." · A1-K05 p04: "This is the best time of his day."

### G-A2-10-going-to · *going to*: plan ve kanıta dayalı tahmin
- **Hedef:** Önceden verilmiş kararları ve gördüğüne dayanan tahminleri *be going to* ile söyler.
- **Önkoşul:** G-A2-01
- **Türkçeyle karşılaştırma:** Türkçede gelecek tek ektir ("-ecek"); plan mı tahmin mi, bağlamdan anlaşılır. İngilizcede plan için *going to* seçilir. *be* yine sık düşer.
- **Tipik hata:** *I going to visit…* → *I'm going to visit…* · *I'm going to went.* → *I'm going to go.*
- **Örnekler:** *I'm going to visit my grandmother this weekend.* · *Look at those clouds. It's going to rain.*
- **Hikâye bağı:**
  - A2-K02 p02: "Today we're going to walk to the lake," she said.
  - A2-K04 p02: "I'm going to smell it one day," she wrote back. · p04: "Is it going to rain?"
  - A2-K01 p16: "Next year, you're going to win."

### G-A2-11-will · *will*: anlık karar, söz ve tahmin
- **Hedef:** Konuşma anında verilen kararı, sözü, teklifi ve görüşe dayalı tahmini *will / won't* ile söyler.
- **Önkoşul:** G-A2-10
- **Türkçeyle karşılaştırma:** Türkçede anlık karar geniş zamanla bile söylenir ("Ben alırım!", "Ben hallederim"); İngilizcede *I'll*. *will* kişiye göre değişmez, ardından *to* gelmez.
- **Tipik hata:** *I will to go.* → *I'll go.* · Alışverişte karar verirken *I take it.* → *I'll take it.*
- **Örnekler:** *It's cold. I'll close the window.* · *Don't worry, I won't be late.*
- **Hikâye bağı:**
  - A1-010 Sahne 2 (Hangi anten?): "I'll take it." (S1'de kalıp)
  - A2 kitaplarında henüz yok (metinler gelecek için *going to*'yu kullanıyor).

### G-A2-12-adverbs · Zarflar: *always / usually / never* ve *-ly*
- **Hedef:** Sıklık zarflarını ana fiilden önce, *be*'den sonra yerleştirir; sıfattan *-ly* ile tarz zarfı yapar.
- **Önkoşul:** G-A1-11, G-A1-12
- **Türkçeyle karşılaştırma:** Türkçede "hep, genelde, hiç" cümlede serbestçe gezer; "yavaş*ça*" ekle yapılır. İngilizcede sıklık zarfının yeri sabittir (*I always walk*, *She is always late*); tarz zarfı fiilden ya da nesneden sonra gelir. "Hiç" olumsuz cümlede *never* ile ikinci bir olumsuz kullanılmaz.
- **Tipik hata:** *I go always.* → *I always go.* · *Speak slow.* → *Speak slowly.* · *I don't never…* → *I never…*
- **Örnekler:** *I usually get up at seven.* · *Please speak slowly.*
- **Hikâye bağı:**
  - A1-006 Sahne 2 (Sam hızlı konuşur): ✓ "Slowly, please."
  - A1-K05 p01: "She always looks down a little."
  - A2-K05 p02: "Usually, Mateo spent every summer in the water." · A2-K03 p01: "Max did the maths very quickly." · A2-K01 p04: "Elif picked him up slowly."

### G-A2-13-conjunctions · Bağlaçlar: *and / but / because / so* ve *when*
- **Hedef:** Cümleleri *and, but, because, so* ile bağlar; *when / before / after* ile zaman bildiren yan cümle kurar.
- **Önkoşul:** G-A2-04
- **Türkçeyle karşılaştırma:** Türkçede bağlama çoğunlukla ekle ve cümle sonunda yapılır: "Sis gel*ince* yol kayboldu", "yorgun ol*duğu için*". İngilizcede bağlaç cümlenin başına gelir ve iki cümle yer değiştirebilir. *when*'li yan cümlede gelecek için *will* kullanılmaz.
- **Tipik hata:** Yazıda tek başına *Because I was tired.* · *When I will arrive, I'll call you.* → *When I arrive…*
- **Örnekler:** *I was hungry, so I made a sandwich.* · *When I got home, my cat was asleep.*
- **Hikâye bağı:**
  - A1-K05 p01: "But every morning at seven, someone waves."
  - A2-K02 p02: "Listen carefully, because there are four rules." · p01: "When the fog came down, the path disappeared."
  - A2-K03 p01: "So when Mrs Bell from next door called him, he listened carefully."

### G-A2-14-have-to-must-should · *have to / must / should*: zorunluluk ve öneri
- **Hedef:** Zorunluluğu *have to / must*, yasağı *mustn't*, gereksizliği *don't have to*, öneriyi *should* ile söyler.
- **Önkoşul:** G-A1-08, G-A1-14
- **Türkçeyle karşılaştırma:** Türkçede "-meli" ve "zorunda" vardır. "-memeli" *mustn't*'e, "zorunda değil" *don't have to*'ya karşılık gelir; ama Türk öğrenci *mustn't*'i "zorunda değil" sanabilir. Modaldan sonra *to* gelmez.
- **Tipik hata:** *You must to go.* → *You must go.* · "Gelmek zorunda değilsin" için *You mustn't come.* → *You don't have to come.* · *She have to…* → *She has to…*
- **Örnekler:** *You should drink more water.* · *We don't have to go to school on Saturday.*
- **Hikâye bağı:**
  - A2-K02 p03: "We have to stay on the path," said Jonas. · "We should go back now," she said.
  - A2-K03 p03: "The children must have lunch at twelve." · p12: "You don't have to pay me," said Max quietly.
  - A2-K05 p03: "Should I answer?" asked Mateo.

### G-A2-15-verb-patterns · Fiilden sonra fiil: *want to*, *like + -ing*
- **Hedef:** *want / need / try*'dan sonra *to* + fiil, *like / love*'dan sonra *-ing* kullanır; *would like to* ile kibarca ister.
- **Önkoşul:** G-A1-11
- **Türkçeyle karşılaştırma:** Türkçede ikinci fiil "-mek / -meyi" ile isimleşir: "gitmek istiyorum", "okumayı severim". İngilizcede biçim (*to* ya da *-ing*) birinci fiile göre değişir. Ayrıntısı G-B1-09'da.
- **Tipik hata:** *I want go.* → *I want to go.* · *I would like go.* → *I would like to go.*
- **Örnekler:** *I want to learn English.* · *My sister likes dancing.*
- **Hikâye bağı:**
  - A1-K04 p06: "Do you want to sleep, too?"
  - A2-K01 p02: "This year, Elif wanted to enter with the lemon cake."
  - A2-K04 p01: "Nia was born on the Moon, and she wanted to see rain." · A2-K05 p15: "Do you want to try?"

---

## B1 (14 konu)

### G-B1-01-present-perfect-experience · Present perfect (1): deneyim, *ever / never*
- **Hedef:** Ne zaman olduğu önemli olmayan hayat deneyimlerini *have / has + V3* ile anlatır; *Have you ever…?* diye sorar.
- **Önkoşul:** G-A2-05, G-A2-06
- **Türkçeyle karşılaştırma:** Türkçede tek bir karşılığı yoktur; "Hiç Londra'ya gittin mi?" "-di" ile sorulur. İngilizcede zaman belirtilmeyen deneyim present perfect ister. Türkçedeki "-miş" (duyulan geçmiş) present perfect değildir; bu benzerlik yanıltır.
- **Tipik hata:** *Did you ever go to London?* (deneyim sorusu) → *Have you ever been to London?* · *I have went.* → *I have gone / been.* · *I have seen him yesterday.* → *I saw him yesterday.*
- **Örnekler:** *Have you ever eaten sushi?* · *I've never seen snow.*
- **Hikâye bağı:** henüz yok (A2 kitapları bilinçli olarak present perfect kullanmıyor). Karşılaştırma için aday: A2-K04 p09 "Soon they were the biggest clouds Nia ever saw." ("Onay için" madde 8).

### G-B1-02-present-perfect-since-for · Present perfect (2): *since / for*
- **Hedef:** Geçmişte başlayıp hâlâ süren durumu *have / has + V3* ve *since* (başlangıç anı) ya da *for* (süre) ile söyler.
- **Önkoşul:** G-B1-01
- **Türkçeyle karşılaştırma:** Türkçe bunu şimdiki ya da geniş zamanla söyler: "2019'dan beri buradayım", "Üç yıldır İngilizce öğreniyorum". Birebir çeviri yanlış zamana götürür. "-den beri" → *since*, "-dır" → *for*.
- **Tipik hata:** *I am here since 2019.* → *I have been here since 2019.* · *I know him for five years.* → *I've known him for five years.* · *since three years* → *for three years*
- **Örnekler:** *I've lived in Ankara since 2020.* · *She has had this phone for two years.*
- **Hikâye bağı:** henüz yok (present perfect yok). İlgili: A2-K05 p15 "For thirty years, she watched the sea from this tower." (*for* + süre, ama bitmiş geçmişte past simple; farkı göstermek için) · A1-012 Sahne 2 (Kulüp odası): "For many years!"

### G-B1-03-present-perfect-vs-past · Present perfect mi, past simple mı? *just / already / yet*
- **Hedef:** Belirli bir geçmiş zaman varsa past simple, sonucu şimdi önemliyse present perfect seçer; *just / already / yet*'i doğru yere koyar.
- **Önkoşul:** G-B1-01, G-B1-02
- **Türkçeyle karşılaştırma:** Türkçede ikisi de "-di"dir: "Anahtarımı kaybettim" (hâlâ yok) → *I've lost my keys*; "Dün kaybettim" → *I lost them yesterday*. Ayrımı zaman ifadesi ve şimdiye etkisi belirler. (Amerikan İngilizcesinde *I already ate* da kabul görür; ders İngiliz kullanımını esas alır ve bunu belirtir.)
- **Tipik hata:** *I have finished it yesterday.* → *I finished it yesterday.* · *When have you arrived?* → *When did you arrive?*
- **Örnekler:** *I've just finished my homework.* · *I finished it an hour ago.*
- **Hikâye bağı:** henüz yok.

### G-B1-04-past-continuous · Past continuous ve *when / while*
- **Hedef:** Geçmişte süren arka plan eylemini *was / were + -ing*, onu kesen olayı past simple ile anlatır.
- **Önkoşul:** G-A2-01, G-A2-05
- **Türkçeyle karşılaştırma:** Türkçe "-iyordu" birebir köprüdür ("Fotoğraf çekiyordum"). Zorluk, kısa ve ani olayı da *-ing* ile söylemek ve *was*'ı düşürmektir.
- **Tipik hata:** *I was walk.* → *I was walking.* · *When I was arriving, he called.* → *When I arrived, he called.*
- **Örnekler:** *I was reading when the lights went out.* · *While we were walking home, it started to rain.*
- **Hikâye bağı:**
  - A2-K02 p06: "I was taking photos," said Paloma. · p08: "The shapes were coming towards them."
  - A2-K04 p09: "It was getting easier."

### G-B1-05-used-to · *used to*: geçmişteki alışkanlık
- **Hedef:** Geçmişte olan ama artık olmayan alışkanlık ve durumları *used to* + fiil ile anlatır; *be used to* (alışkın olmak) ile karıştırmaz.
- **Önkoşul:** G-A2-06
- **Türkçeyle karşılaştırma:** Türkçe "-erdi" ("Eskiden balık tutardım") iyi bir köprüdür. Soru ve olumsuzda *did* + *use to* olur. "-e alışkın olmak" İngilizcede ayrı yapıdır: *be used to + -ing*.
- **Tipik hata:** *I was used to play.* → *I used to play.* · *Did you used to…?* → *Did you use to…?*
- **Örnekler:** *I used to live in a small village.* · *There used to be a cinema here.*
- **Hikâye bağı:** henüz yok (İngilizce metinlerde). Kanca adayı: A1-000 Sahne 2 (Harbour Lane 12), babaanne Nermin'in Türkçe repliği "Orada iyi çekerdi…" — "-erdi" ile *used to* karşılaştırması için doğal bir giriş.

### G-B1-06-future-forms · Gelecek: *will*, *going to*, şimdiki zamanla randevu
- **Hedef:** Kesinleşmiş randevuyu present continuous, planı *going to*, anlık kararı ve görüşe dayalı tahmini *will* ile söyler.
- **Önkoşul:** G-A2-10, G-A2-11
- **Türkçeyle karşılaştırma:** Türkçe hepsine "-ecek" diyebilir; ama "Yarın doktora gidiyorum" gibi "-iyor"lu randevu kullanımı İngilizceyle aynıdır, bu bir köprüdür.
- **Tipik hata:** Kararlaştırılmış randevuda *I will meet her at five.* → *I'm meeting her at five.* · *When I will finish…* → *When I finish…*
- **Örnekler:** *I'm seeing the doctor on Monday.* · *I think it will be sunny tomorrow.*
- **Hikâye bağı:**
  - A2-K05 p13: "I'm coming with you to the beach," said Mum. · p12: "The doctor was going to take off the cast on Friday."
  - A2-K02 p02: "Today we're going to walk to the lake," · A1-010 Sahne 2 (Hangi anten?): "I'll take it."

### G-B1-07-zero-first-conditional · Koşul cümleleri: 0 ve 1. tip
- **Hedef:** Genel doğruları *if* + present, present; gerçek olası durumları *if* + present, *will* ile kurar; *if, when, unless*'ı ayırır.
- **Önkoşul:** G-A2-11, G-A2-13
- **Türkçeyle karşılaştırma:** Türkçe "-se" ekinde gelecek eki yoktur ("Yağmur yağarsa evde kalırız"); İngilizcede de *if*'li tarafta *will* olmaz. Bu bir köprüdür, ama öğrenci "yağacaksa" diye düşünüp *if it will rain* der.
- **Tipik hata:** *If it will rain, we will stay home.* → *If it rains, …* · *Unless you don't hurry…* → *Unless you hurry…*
- **Örnekler:** *If you heat ice, it melts.* · *If it rains tomorrow, we'll stay at home.*
- **Hikâye bağı:**
  - A1-006 Sahne 3 (Kayıt): VOICE "If you have the radio, you are a friend."
  - A2-K02 p02: "If the fog comes, stop and stay together." · "If you are lost, listen."

### G-B1-08-defining-relative-clauses · Tanımlayan sıfat cümlecikleri: *who / which / that*
- **Hedef:** Bir ismi arkasından *who / which / that* ile tanımlar; nesne konumunda zamiri düşürebileceğini bilir.
- **Önkoşul:** G-A2-04, G-A1-05
- **Türkçeyle karşılaştırma:** Türkçede tanım isimden **önce** ve ortaçla (-en, -dığı) gelir: "yağmuru hiç görmemiş kız". İngilizcede isim önde, tanım arkada: *the girl who never saw rain*. Sıra tamamen terstir; ayrıca ortaç yerine ayrı bir kelime gerekir.
- **Tipik hata:** *the film what I saw* → *the film that I saw* · *The book that I read it.* → *The book that I read.* · *the man which* → *the man who*
- **Örnekler:** *The girl who lives next door is my friend.* · *This is the phone that I bought last week.*
- **Hikâye bağı:**
  - A2-K04 başlık: *The Girl Who Never Saw Rain* · A2-K03 başlık: *The Parrot Who Told Everything*
  - A2-K04 p02: "His letters were full of things Nia never saw." (zamirsiz)

### G-B1-09-gerund-infinitive · *-ing* mi, *to* mu? Fiil kalıpları (2)
- **Hedef:** *enjoy / avoid / finish + -ing* ile *decide / hope / plan + to* ayrımını yapar; *stop / remember / try*'daki anlam farkını bilir; *want someone to do* yapısını kurar.
- **Önkoşul:** G-A2-15
- **Türkçeyle karşılaştırma:** Türkçe iki biçim için de "-mek / -meyi" kullanır; *stop smoking* / *stop to smoke* farkını Türkçe ayrı fiillerle söyler ("bırakmak / durmak"). "Gelmeni istiyorum" yapısı İngilizcede *that* ile değil, nesne + *to* ile kurulur.
- **Tipik hata:** *I want that you help me.* → *I want you to help me.* · *I'm looking forward to see you.* → *to seeing you* · *I enjoy to swim.* → *I enjoy swimming.*
- **Örnekler:** *I enjoy cooking for my friends.* · *She decided to study abroad.*
- **Hikâye bağı:**
  - A2-K02 p08: "Paloma tried to remember Mrs Berg's rules." · p09: "Paloma started to laugh."
  - *-ing* tarafı henüz yok.

### G-B1-10-might-may-could · Olasılık: *might / may / could*
- **Hedef:** Emin olunmayan olasılıkları *might / may / could* ile söyler; *could*'un geçmiş yetenek anlamını ayırır.
- **Önkoşul:** G-A1-07, G-B1-06
- **Türkçeyle karşılaştırma:** Türkçe "-ebilir" hem yetenek hem olasılıktır ("Yağmur yağabilir"). İngilizcede olasılık için *can* çoğu zaman yanlış olur; *might* gerekir. "Belki" + *will* de doğal bir alternatiftir.
- **Tipik hata:** *It can rain tomorrow.* → *It might rain tomorrow.* · *Maybe it might rain.* (çift) · *might to go* → *might go*
- **Örnekler:** *Take an umbrella. It might rain later.* · *She may be at home now.*
- **Hikâye bağı:** olasılık anlamı henüz yok. Karşılaştırma için geçmiş yetenek: A2-K04 p01 "From her bedroom window, Nia could see the Earth."

### G-B1-11-past-perfect · Past perfect: "olmuştu"
- **Hedef:** Geçmişteki iki olaydan önce olanı *had + V3* ile gösterir.
- **Önkoşul:** G-B1-01, G-A2-05
- **Türkçeyle karşılaştırma:** Türkçe "-mişti" birebir köprüdür ("Vardığımda tren kalkmıştı"). Asıl risk aşırı kullanımdır: her geçmiş cümleye *had* koymak.
- **Tipik hata:** *When I arrived, the train left.* (sıra belirsiz) → *had left* · *I had went.* → *I had gone.*
- **Örnekler:** *When we got to the station, the train had left.* · *She had never seen the sea before that day.*
- **Hikâye bağı:** henüz yok (karşılaştırma için A2-K04 p09 "…Nia ever saw.", bkz. "Onay için" madde 8).

### G-B1-12-ing-ed-adjectives · *bored* mı *boring* mi? *-ed / -ing* sıfatları
- **Hedef:** Duyguyu yaşayanı *-ed* (*bored, surprised*), duyguya yol açanı *-ing* (*boring, surprising*) ile anlatır.
- **Önkoşul:** G-A1-01
- **Türkçeyle karşılaştırma:** Türkçede "sıkıldım" ve "sıkıcıyım" farklı kelimelerdir, ama sözlükte ikisi de "sıkmak" kökünden gelir ve *I'm boring* "sıkılıyorum" sanılır. Oysa *I'm boring* "Ben sıkıcıyım" demektir.
- **Tipik hata:** "Sıkıldım" için *I'm boring.* → *I'm bored.* · *I'm interesting in music.* → *I'm interested in music.*
- **Örnekler:** *The lesson was boring, so I was bored.* · *I'm interested in science.*
- **Hikâye bağı:**
  - A2-K05 p03: "I'm so boring," he told his mum. → "No, you're bored. Boring is different." (yapının kendisi hikâyede anlatılıyor)
  - A2-K02 p07: "They were very boring fish." · A1-K01 p06: "Lina is surprised." · A1-K03 p08: "He is tired."

### G-B1-13-indirect-questions · Dolaylı sorular: *Can you tell me where…?*
- **Hedef:** *Do you know…, Can you tell me…, I wonder…* ile kibar soru sorarken soru kelimesinden sonra düz cümle sırası kullanır; evet/hayır sorularında *if / whether* ekler.
- **Önkoşul:** G-A1-02, G-A1-14
- **Türkçeyle karşılaştırma:** Türkçede iç soru isimleşir: "İstasyonun nerede olduğunu biliyor musun?" İngilizcede sıra düz cümleye döner ve *do / does* düşer. Öğrenci doğrudan soruyu olduğu gibi içeri koyar.
- **Tipik hata:** *Do you know where is the station?* → *…where the station is?* · *Can you tell me what time does it open?* → *…what time it opens?*
- **Örnekler:** *Do you know where the post office is?* · *I don't know if she's at home.*
- **Hikâye bağı:** henüz yok. Kanca adayı: A1-002 Sahne 2 (Aile) "Excuse me, where is the old station?" cümlesinin dolaylı biçimiyle karşılaştırılması.

### G-B1-14-articles-general-specific · Artikeller (2): genel mi, belirli mi?
- **Hedef:** Genel anlamda çoğul ve sayılamayan isimleri *the*'siz, belirli olanları *the* ile kullanır; *go to school, by bus, the sea* gibi kalıpları bilir.
- **Önkoşul:** G-A1-04, G-A2-07
- **Türkçeyle karşılaştırma:** Türkçede genel anlam yalın isimle söylenir ("Hayat güzel", "Robotlar uyumaz"). Türk öğrenci "hayat"ı belirli sanıp *the life* der ya da A1'de öğrendiği *the*'yi her yere koyar.
- **Tipik hata:** *The life is beautiful.* → *Life is beautiful.* · Genel anlamda *I love the music.* → *I love music.* · *I go to the school by the bus.* → *I go to school by bus.*
- **Örnekler:** *Dogs are friendly animals.* · *The dog in the garden is ours.*
- **Hikâye bağı:**
  - A1-K04 p03: "Robots don't sleep," says Pip. · A2-K04 p02: "Rain is not only water," Leo wrote.
  - Belirli örnek için: A1-001 Sahne 1 (Cuma akşamı) "the old station".

---

## B2 (12 konu)

### G-B2-01-passive · Edilgen yapı: *be + V3*
- **Hedef:** Eylemi yapan önemsiz ya da bilinmiyorsa edilgen kurar; *be*'yi zamana göre çekimler; gerekirse *by* ile yapanı ekler.
- **Önkoşul:** G-A2-05, G-B1-01
- **Türkçeyle karşılaştırma:** Türkçede edilgenlik fiile eklenir (*yap-ıl-dı, kilit-len-di*); İngilizcede *be + V3* olarak iki parçadır. "Doğdum" Türkçede etkendir, İngilizcede edilgendir: *I was born*.
- **Tipik hata:** *I born in 2005.* / *I am born in 2005.* → *I was born in 2005.* · *The house built in 1990.* → *was built* · *It was happened.* → *It happened.*
- **Örnekler:** *This bridge was built in 1890.* · *The results will be announced next week.*
- **Hikâye bağı:**
  - A2-K04 p01: "Nia was born on the Moon, and she wanted to see rain."
  - A2-K02 p07: "The fish were called One, Two and Three."
  - Sıfat gibi kullanılan V3: A1-K01 p01 "It is locked." · A1-002 Sahne 2 (Aile): MAYA "It is closed."

### G-B2-02-reported-statements · Dolaylı anlatım (1): *say / tell*, zaman kaydırma
- **Hedef:** Başkasının sözünü *said / told* ile aktarır; gerektiğinde zamanı bir adım geri kaydırır, zamirleri ve zaman ifadelerini uyarlar.
- **Önkoşul:** G-B1-11
- **Türkçeyle karşılaştırma:** Türkçe aktarmada zaman çoğu zaman değişmez ("Soğuk *olduğunu* söyledi") ve isimleşme kullanılır. İngilizcede düz cümle kalır ama zaman geriye kayar: *Mum said it was cold.* *tell* kişi ister (*told me*), *say* istemez.
- **Tipik hata:** *She said me…* → *She told me…* · *She told that…* → *She said that…*
- **Örnekler:** *She said she was tired.* · *He told me he would call later.*
- **Hikâye bağı:**
  - A2-K04 p01: "Mum said it was cold."
  - A2-K03 p07: "They said it was the best pancake in the world."

### G-B2-03-reported-questions-commands · Dolaylı anlatım (2): soru ve rica aktarma
- **Hedef:** Soruları *asked* + *if / wh-* + düz sıra ile, rica ve emirleri *told / asked* + kişi + *to* ile aktarır.
- **Önkoşul:** G-B2-02, G-B1-13
- **Türkçeyle karşılaştırma:** Türkçe "Nerede oturduğumu sordu", "Beklememi söyledi" der; ikisi de isimleşmedir. İngilizcede soru düz sıraya döner, rica *to* + fiille aktarılır.
- **Tipik hata:** *She asked me where was I going.* → *…where I was going.* · *He said me to wait.* → *He told me to wait.*
- **Örnekler:** *She asked me where I lived.* · *The teacher told us to close our books.*
- **Hikâye bağı:** henüz yok.

### G-B2-04-second-conditional · 2. tip koşul: gerçek dışı şimdi
- **Hedef:** Gerçek olmayan ya da olasılığı düşük durumları *if* + past, *would* + fiil ile anlatır; *If I were you* ile öneri verir.
- **Önkoşul:** G-B1-07, G-A2-04
- **Türkçeyle karşılaştırma:** Türkçe "Zengin *olsam* dünyayı *gezerdim*" yapısı iyi bir köprüdür. Zorluk, İngilizcede *if*'li tarafın geçmiş biçimde olup şimdiyi anlatmasıdır.
- **Tipik hata:** *If I would have money…* → *If I had money…* · *If I am you…* → *If I were you…*
- **Örnekler:** *If I had more time, I would learn the guitar.* · *If I were you, I'd talk to her.*
- **Hikâye bağı:** henüz yok.

### G-B2-05-third-conditional · 3. tip koşul: olmayan geçmiş
- **Hedef:** Geçmişte gerçekleşmemiş bir koşulu ve sonucunu *if + had V3*, *would have V3* ile anlatır.
- **Önkoşul:** G-B2-04, G-B1-11
- **Türkçeyle karşılaştırma:** Türkçe "Erken *çıksaydım*, otobüsü *kaçırmazdım*" der: iki ek yeter. İngilizcede iki parçalı fiil zinciri gerekir ve ağır gelir.
- **Tipik hata:** *If I would have known…* → *If I had known…* · Yazıda *would of* → *would have*
- **Örnekler:** *If I had left earlier, I wouldn't have missed the bus.* · *She would have passed if she had studied.*
- **Hikâye bağı:** henüz yok.

### G-B2-06-wish-if-only · *wish / if only*: dilek ve pişmanlık
- **Hedef:** Şimdiki dileği *wish* + past, geçmiş pişmanlığı *wish + had V3*, başkasının davranışından yakınmayı *wish + would* ile söyler.
- **Önkoşul:** G-B2-04, G-B2-05
- **Türkçeyle karşılaştırma:** Türkçe "Keşke daha uzun *olsam*" der; İngilizcede zaman bir adım geri kayar: *I wish I were taller*.
- **Tipik hata:** *I wish I can…* → *I wish I could…* · *I wish I didn't say that.* (geçmiş pişmanlık) → *I wish I hadn't said that.*
- **Örnekler:** *I wish I lived near the sea.* · *I wish I hadn't said that.*
- **Hikâye bağı:** henüz yok.

### G-B2-07-past-modals-deduction · Geçmişe dair çıkarım: *must have / can't have / might have*
- **Hedef:** Kanıta dayanarak geçmiş hakkında çıkarım yapar; *should have* ile eleştiriyi ayırır.
- **Önkoşul:** G-B1-10, G-B1-01
- **Türkçeyle karşılaştırma:** Türkçe "Unutmuş *olmalı*" der → *She must have forgotten.* "Olamaz" ise *can't have* olur, *mustn't have* değil.
- **Tipik hata:** *She must forgot.* → *She must have forgotten.* · *He mustn't have seen me.* (çıkarım) → *He can't have seen me.*
- **Örnekler:** *The lights are off. They must have gone out.* · *She can't have seen us; she didn't wave.*
- **Hikâye bağı:** henüz yok. Karşılaştırma için zorunluluk anlamı: A2-K01 p15 "Feel the butter. It must be soft."

### G-B2-08-present-perfect-continuous · Present perfect continuous: *have been + -ing*
- **Hedef:** Geçmişte başlayıp süren ya da izi hâlâ görünen eylemi *have been + -ing* ile anlatır.
- **Önkoşul:** G-B1-02, G-A2-01
- **Türkçeyle karşılaştırma:** Türkçe "İki saattir *bekliyorum*" der; birebir çeviri *I am waiting for two hours* hatasına götürür.
- **Tipik hata:** *I am waiting for two hours.* → *I've been waiting for two hours.* · *I've been knowing her for years.* → *I've known her for years.*
- **Örnekler:** *I've been studying all morning.* · *It's been raining since Monday.*
- **Hikâye bağı:** henüz yok.

### G-B2-09-non-defining-relatives · Tanımlamayan sıfat cümlecikleri: virgüllü *who / which / whose*
- **Hedef:** Zaten bilinen bir isme virgüllerle ek bilgi ekler; bu yapıda *that* kullanmaz; *which* ile bütün cümleye yorum yapar.
- **Önkoşul:** G-B1-08
- **Türkçeyle karşılaştırma:** Türkçede ek bilgi çoğunlukla ayrı cümleyle ya da ortaçla verilir ("İzmir'de yaşayan teyzem doktor"). Virgülün anlamı değiştirmesi ve *that* yasağı yabancıdır.
- **Tipik hata:** *My brother, that lives in İzmir, …* → *My brother, who lives in İzmir, …* · Virgülsüz *He didn't call which was strange.*
- **Örnekler:** *My aunt, who lives in İzmir, is a doctor.* · *He didn't call, which was strange.*
- **Hikâye bağı:** henüz yok. Kanca adayı (virgüllü ek bilgi, açıklama öbeği): A2-K04 p01 "She lived in Lunaria, a small town under a glass roof."

### G-B2-10-causative · Ettirgen: *have / get something done*
- **Hedef:** Bir işi başkasına yaptırdığını *have / get* + nesne + V3 ile söyler.
- **Önkoşul:** G-B2-01
- **Türkçeyle karşılaştırma:** Türkçede ettirgen bir ektir: "Saçımı kes*tir*dim". İngilizcede *I cut my hair* "kendim kestim" demektir; yaptırma ayrı yapı ister.
- **Tipik hata:** Kuaförden sonra *I cut my hair.* → *I had my hair cut.* · *I made my car repair.* → *I had my car repaired.*
- **Örnekler:** *I had my hair cut yesterday.* · *We're getting the kitchen painted next week.*
- **Hikâye bağı:** henüz yok.

### G-B2-11-future-continuous-perfect · *will be doing / will have done*
- **Hedef:** Gelecekte belli bir anda sürecek eylemi *will be + -ing*, o ana kadar bitmiş olacak eylemi *will have + V3* ile anlatır.
- **Önkoşul:** G-B1-06, G-B1-01
- **Türkçeyle karşılaştırma:** Türkçede karşılıkları vardır: "uçuyor olacağım", "bitirmiş olacağım". Köprü kolaydır; zorluk *by* + zaman ifadesidir ("-e kadar" → *by*, *until* değil).
- **Tipik hata:** *By June I will finish.* → *By June I will have finished.* · *until June* (bitiş anlamında) → *by June*
- **Örnekler:** *This time tomorrow, I'll be flying to Berlin.* · *By June, she will have finished school.*
- **Hikâye bağı:** henüz yok.

### G-B2-12-contrast-linkers · Zıtlık: *although / despite / however / whereas*
- **Hedef:** Zıtlığı *although / even though* (+ cümle), *despite / in spite of* (+ isim ya da *-ing*), *however* (cümleler arası) ve *whereas* ile kurar.
- **Önkoşul:** G-A2-13, G-B1-09
- **Türkçeyle karşılaştırma:** Türkçe "-e rağmen"i hem isimle hem cümleyle kullanır ("yağmura rağmen / yağmur yağmasına rağmen"); İngilizcede iki ayrı yapı vardır. Türkçedeki "-mesine rağmen… ama" ikilisi İngilizcede çift bağlaç hatası doğurur.
- **Tipik hata:** *Although it was raining, but we went out.* → *but*'ı çıkar · *Despite it was cold…* → *Despite the cold…* / *Although it was cold…* · *despite of* → *despite*
- **Örnekler:** *Although it was late, we kept talking.* · *Despite the rain, the match continued.*
- **Hikâye bağı:** henüz yok.

---

## C1 (8 konu)

### G-C1-01-inversion · Devrik yapı: *Never have I…, Not only…*
- **Hedef:** Olumsuz ya da kısıtlayıcı bir ifade başa geldiğinde yardımcı fiili özneden önce getirerek vurgu yapar.
- **Önkoşul:** G-B1-01, G-B1-11
- **Türkçeyle karşılaştırma:** Türkçede vurgu kelime sırası ve sesle yapılır; Türkçedeki "devrik cümle" (yüklem önde) bambaşka bir şeydir. İngilizcede soru biçimine benzeyen bu yapı yalnız belirli ifadelerden sonra gelir.
- **Tipik hata:** *Never I have seen…* → *Never have I seen…* · *Not only he is…* → *Not only is he…*
- **Örnekler:** *Never have I seen such a beautiful sunset.* · *Not only did she win, but she also broke the record.*
- **Hikâye bağı:** henüz yok.

### G-C1-02-cleft-sentences · Vurgulu yapılar: *It was… that…, What I need is…*
- **Hedef:** Cümlenin bir parçasını *it*-cleft ya da *what*-cleft ile öne çıkarır.
- **Önkoşul:** G-B1-08
- **Türkçeyle karşılaştırma:** Türkçede vurgulanan öğe yüklemin hemen önüne alınır ("Kapıyı *Ali* açtı") ya da "-an … -dı" kurulur ("Kapıyı açan Ali'ydi"). İngilizcede sıra sabit olduğu için ayrı bir yapı gerekir.
- **Tipik hata:** *Was Ali that opened the door.* → *It was Ali who opened the door.* · *What I need it is…* → *What I need is…*
- **Örnekler:** *It was my grandmother who taught me to cook.* · *What I really need is a long holiday.*
- **Hikâye bağı:** henüz yok.

### G-C1-03-mixed-conditionals · Karışık koşul cümleleri
- **Hedef:** Geçmiş koşul–şimdiki sonuç ve kalıcı özellik–geçmiş sonuç ilişkilerini karışık koşulla anlatır.
- **Önkoşul:** G-B2-04, G-B2-05
- **Türkçeyle karşılaştırma:** Türkçe "O işi kabul *etseydim*, şimdi Londra'da *olurdum*" der ve doğal gelir; İngilizcede iki zaman katmanını ayrı ayrı seçmek gerekir.
- **Tipik hata:** *If I had taken the job, I would have been in London now.* → *…I would be in London now.*
- **Örnekler:** *If I had studied medicine, I would be a doctor now.* · *If she weren't so shy, she would have spoken at the meeting.*
- **Hikâye bağı:** henüz yok.

### G-C1-04-participle-clauses · Ortaç yan cümleleri: *Having finished…, Walking home…*
- **Hedef:** *-ing*, *-ed* ve *having + V3* ile yan cümleleri kısaltır; iki cümlenin öznesinin aynı olmasına dikkat eder.
- **Önkoşul:** G-B1-08, G-B2-01
- **Türkçeyle karşılaştırma:** Türkçe zarf-fiilleri (-ip, -ince, -erek, -dikten sonra) çok sık kullanır; bu Türk öğrenci için güçlü bir köprüdür. Asıl risk özne uyuşmazlığıdır: Türkçede sorun olmayan yapı İngilizcede anlamı bozar.
- **Tipik hata:** *Walking home, the rain started.* (yağmur yürümüyor) → *Walking home, I got caught in the rain.* · *After finish the work…* → *After finishing the work…*
- **Örnekler:** *Having finished the report, she went home.* · *Built in 1890, the bridge is still in use.*
- **Hikâye bağı:** henüz yok.

### G-C1-05-modal-nuances · Modal incelikleri: *needn't have, be supposed to, would rather*
- **Hedef:** Gereksiz yapılmış işi, yapılmamış gerekeni, beklentiyi ve tercihi modal incelikleriyle ayırır.
- **Önkoşul:** G-B2-07, G-A2-14
- **Türkçeyle karşılaştırma:** Türkçe "gerek yokmuş", "-meliydin", "-mesi gerekiyordu", "tercih ederim" gibi ayrı kalıplar kullanır. *didn't need to* ile *needn't have* arasındaki fark (yapıldı mı, yapılmadı mı) Türkçede tek kalıpla söylenir.
- **Tipik hata:** Eleştiride *You must have told me.* → *You should have told me.* · *I'd rather to stay.* → *I'd rather stay.*
- **Örnekler:** *You needn't have brought a gift.* · *We're supposed to be there at eight.*
- **Hikâye bağı:** henüz yok.

### G-C1-06-impersonal-passive · Kişisiz edilgen: *It is said that…, He is believed to…*
- **Hedef:** Söylenti, inanç ve raporları kişisiz edilgenle, mesafeli bir dille aktarır.
- **Önkoşul:** G-B2-01, G-B2-02
- **Türkçeyle karşılaştırma:** Türkçe bunu kolayca "-dığı söyleniyor" ya da "-mış" ile yapar. İngilizcede iki yapı vardır (*It is said that he is…* / *He is said to be…*) ve geçmiş için *to have done* gerekir.
- **Tipik hata:** *He is said that he is rich.* → *He is said to be rich.* / *It is said that he is rich.*
- **Örnekler:** *It is said that the castle is haunted.* · *The painting is believed to be over 300 years old.*
- **Hikâye bağı:** henüz yok.

### G-C1-07-unreal-past · Gerçek dışı geçmiş: *It's time…, would rather…, as if…*
- **Hedef:** *It's (high) time*, *would rather* + kişi ve *as if / as though* yapılarında geçmiş biçimle şimdiki gerçek dışılığı anlatır.
- **Önkoşul:** G-B2-06
- **Türkçeyle karşılaştırma:** Türkçe "Artık gitme vakti", "Gelmesen daha iyi", "Her şeyi biliyor*muş gibi*" der; geçmiş biçim gerekmez. İngilizcede geçmiş biçim burada zaman değil, gerçek dışılık bildirir.
- **Tipik hata:** *It's time we go.* → *It's time we went.* · *I'd rather you come tomorrow.* → *I'd rather you came tomorrow.*
- **Örnekler:** *It's time we went home.* · *She talks as if she knew everyone.*
- **Hikâye bağı:** henüz yok.

### G-C1-08-ellipsis-substitution · Eksiltme ve yerine koyma: *So do I, I hope not*
- **Hedef:** Tekrarı önlemek için *so, not, do, one* ve eksiltmeyi kullanır; *So do I / Neither can she* yapılarını doğru yardımcıyla kurar.
- **Önkoşul:** G-A1-14, G-A1-07
- **Türkçeyle karşılaştırma:** Türkçe "Ben de", "Bence de", "Umarım" der; tek kelime yeter. İngilizcede doğru yardımcı fiil seçilmeli ve devrik kurulmalıdır. "Ben de değilim" → *Neither am I*. (Temel biçimi A2–B1'dir; C1'de konuşma ve yazıdaki incelikli kullanımı işlenir.)
- **Tipik hata:** Olumsuzda *Me too.* → *Me neither.* / *Neither do I.* · *I think yes.* → *I think so.* · *I hope it.* → *I hope so.*
- **Örnekler:** *"I love this song." "So do I."* · *"Is it going to rain?" "I hope not."*
- **Hikâye bağı:** henüz yok.

---

## C2 (6 konu)

### G-C2-01-fronting · Öne alma ve bilgi yapısı: *Little did she know…, Such was…*
- **Hedef:** Bilgi akışını ve vurguyu öne alma, devrik yapı ve *such / so* yapılarıyla, metnin akışına uygun yönetir.
- **Önkoşul:** G-C1-01, G-C1-02
- **Türkçeyle karşılaştırma:** Türkçe bilinen bilgiyi başa, yeni bilgiyi yüklemin önüne alarak bilgi yapısını sırayla kolayca yönetir. İngilizcede sıra katı olduğu için bu iş özel yapılarla yapılır.
- **Tipik hata:** *Such the noise was that…* → *Such was the noise that…* · *Little she knew…* → *Little did she know…*
- **Örnekler:** *Little did she know that the letter would change everything.* · *Such was the noise that nobody heard the bell.*
- **Hikâye bağı:** henüz yok (C2 kitapları yazılınca, özellikle C2-K01 ve C2-K04 için aday).

### G-C2-02-nominalisation · Adlaştırma: resmî ve akademik yazı
- **Hedef:** Fiil ve sıfatları isme çevirerek (*decide → decision*) yoğun ve resmî cümleler kurar; gerektiğinde sade dile geri açar.
- **Önkoşul:** G-B2-01, G-C1-04
- **Türkçeyle karşılaştırma:** Türkçede adlaştırma eklerle çok doğaldır ("kararın ertelen*mesi*"). İngilizcede isim + edat zinciri ve doğru edat seçimi zordur; aşırı kullanım metni ağırlaştırır.
- **Tipik hata:** *the decision of postponing* → *the decision to postpone* · *the increasing of prices* → *the increase in prices*
- **Örnekler:** *The postponement of the meeting caused confusion.* · *There has been a sharp increase in demand.*
- **Hikâye bağı:** henüz yok.

### G-C2-03-hedging-stance · Yumuşatma ve tutum: *It would appear that…, arguably*
- **Hedef:** İddiayı yumuşatmak ya da tutum bildirmek için *seem, appear, tend to, arguably, presumably* gibi araçları seçer.
- **Önkoşul:** G-C1-05, G-C1-06
- **Türkçeyle karşılaştırma:** Türkçe "-dır" ekiyle hem kesinlik hem tahmin bildirir ("Yorulmuştur"), "galiba", "sanki" ile yumuşatır. Türk öğrenci İngilizcede ya fazla kesin konuşur ya da her cümleye *maybe* ekler.
- **Tipik hata:** *Maybe probably it is…* (çift) · Her cümlede *I think* · Kanıtsız *It is a fact that…*
- **Örnekler:** *It would appear that the plan has failed.* · *This is arguably her best novel.*
- **Hikâye bağı:** henüz yok.

### G-C2-04-formal-subjunctive · Resmî dilek kipi ve *if*'siz şart: *Should you…, Had I known…*
- **Hedef:** Resmî metinlerdeki *subjunctive*'i (*It is essential that he be…*) ve *if*'siz şart devriğini (*Should you need…, Had I known…*) tanır, uygun yerde kullanır.
- **Önkoşul:** G-C1-01, G-C1-03
- **Türkçeyle karşılaştırma:** Türkçede dilek ve şart ekle yapılır ("gel*sin*", "gerek*irse*"). İngilizcede *if*'in düşüp yardımcının başa gelmesi ve fiilin yalın kalması (*that he be*) yadırganır.
- **Tipik hata:** *Should you will need…* → *Should you need…* · *Had I know…* → *Had I known…*
- **Örnekler:** *Should you need any help, please contact us.* · *Had I known about the delay, I would have stayed at home.*
- **Hikâye bağı:** henüz yok.

### G-C2-05-cohesion-discourse · Bağdaşıklık ve söylem belirleyicileri
- **Hedef:** Uzun metinde fikirleri *that said, nonetheless, by contrast* gibi belirleyicilerle, gönderimle (*the former / the latter, this, such*) ve yerine koymayla akıcı biçimde bağlar.
- **Önkoşul:** G-B2-12, G-C1-08
- **Türkçeyle karşılaştırma:** Türkçe uzun düşünceyi eklerle tek cümlede bağlayabilir; İngilizcede ayrı cümleler ve bağlayıcılar gerekir. Türk öğrencinin yazısında ya *and* zinciri ya da her paragrafta *Moreover* görülür.
- **Tipik hata:** Karşıtlık yokken *On the other hand* · Her paragrafın başında *Firstly / Secondly*
- **Örnekler:** *The plan is expensive. That said, it may save money in the long term.* · *Both cities are popular; the former, however, is quieter.*
- **Hikâye bağı:** henüz yok.

### G-C2-06-aspect-nuance · Görünüş incelikleri: *She's being rude, I was wondering…*
- **Hedef:** Durum fiillerinin süreklilikle kazandığı anlamı (geçici davranış, duygu yoğunluğu) ve geçmiş sürekliliğin kibarlık işlevini kullanır.
- **Önkoşul:** G-A2-02, G-B2-08
- **Türkçeyle karşılaştırma:** Türkçe "Kaba *davranıyor*" (şu an) ile "Kaba*dır*" (kalıcı) ayrımını yapar; bu bir köprüdür. "Acaba yardım edebilir misiniz" kibarlığı İngilizcede *I was wondering if you could…* ile kurulur.
- **Tipik hata:** Resmî ricada *I wonder if you can help.* → *I was wondering if you could help.* · Geçici davranış için *He is rude today.* → *He's being rude today.*
- **Örnekler:** *You're being very quiet today.* · *I was wondering if you could help me.*
- **Hikâye bağı:** henüz yok. C2-K05'te babanın kusurlu İngilizcesi bilinçli korunuyor (`KATALOG.md` madde 6); kitap yazılınca C2 dersleri için karşılaştırma kaynağı olabilir.

---

## Ek: S1 bölümü → konu eşlemesi (bölüm paneli "Bu bölümdeki dilbilgisi" için öneri)

`content.json` → `grammarTargets` ve yukarıdaki doğrulanmış bağlardan türetildi. Paket alanı `grammarTopics` (`DILBILGISI.md` §7) bu tablodan üretilebilir. Panelde en fazla 2–3 konu gösterilmesi önerilir; ilk sıradaki, bölümün ana hedefidir.

| Bölüm | Ana konu | Ek konular |
|---|---|---|
| A1-000 Arrival | G-A1-01-to-be | G-A1-03-a-an, G-A1-05-pronouns-possessives |
| A1-001 A Strange Message | G-A1-07-can | G-A1-02-to-be-questions-negatives, G-A1-08-imperatives |
| A1-002 The New Neighbour | G-A1-06-this-that-plurals | G-A1-02-to-be-questions-negatives, G-A1-13-third-person-s |
| A1-003 Find the Station | G-A1-09-prepositions-place | G-A1-08-imperatives, G-A1-04-the |
| A1-004 The Note | G-A1-10-prepositions-time | G-A1-03-a-an, G-A1-09-prepositions-place |
| A1-005 Too Late? | G-A1-13-third-person-s | G-A1-11-present-simple, G-A2-03-was-were (tanıma) |
| A1-006 The Recording | G-A1-15-there-is-are | G-A1-09-prepositions-place |
| A1-007 Who Knows What? | G-A1-16-have-has | G-A1-05-pronouns-possessives, G-A1-14-do-does |
| A1-008 The First Reveal | G-A1-12-word-order-svo | G-A1-08-imperatives (tekrar bölümü) |
| A1-009 The Café on the Hill | G-A1-03-a-an | G-A2-07-countable-uncountable, G-A1-14-do-does |
| A1-010 Spare Parts | G-A1-06-this-that-plurals | G-A1-02-to-be-questions-negatives (*How much is/are*) |
| A1-011 Storm Warning | G-A1-08-imperatives | G-A2-01-present-continuous (kalıp) |
| A1-012 The Lighthouse | G-A1-07-can (*Can you…?* rica) | G-A2-01-present-continuous (kalıp) |
