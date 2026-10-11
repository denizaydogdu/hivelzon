# HiVelzon — İçerik Mimarisi (sentez)

**Sürüm:** 0.2 · **Tarih:** 2026-10-11 · **Durum:** §14 önerileri kullanıcı tarafından onaylandı (H-026, 2026-10-11). K-17, K-18 ve K-19 açık.
**Ne bu belge:** İçeriğin nasıl yapılandırılacağı, uygulamada nerede ne görüneceği, nasıl üretilip yayınlanacağı ve kullanıcının seviyesinin nasıl takip edileceği için tek başvuru noktası.
**Ne değil:** Kod yazma onayı değil. Kod, migration, ücretli çağrı, Higgsfield üretimi ve yayın; plan onayından (H-001) önce yapılmaz.

## 0. Girdiler ve güvenilirlik

| Girdi | İçerik |
|---|---|
| `docs/ICERIK-STRATEJISI.md` | Kullanıcının bulduğu içerik stratejisi: içerik ağacı, A1–C1 ünite listeleri, durum makinesi, beceri matrisi, ustalık kuralı, ekranlar, veri modeli, API |
| Web araştırması (5 kol, 2026-10-11) | Müfredat ve lisanslar · seviye belirleme ve takip · ekranlar ve bilgi mimarisi · yayın ve dağıtım · içerik formatları ve seriler |
| `CLAUDE.md`, `docs/IS-PLANI.md`, `docs/SARTNAME.md` | Var olan kararlar ve kurallar |

Etiketler:
- **[Öneri]** Kullanıcı onayı gerekir.
- **[Karar gerekli]** §14'teki karar listesinde yer alır.
- **[doğrulanmadı]** Tek ya da ikincil kaynağa dayanır; yayın öncesinde birincil kaynaktan doğrulanmalıdır.

Fiyatlar ve politikalar 2026-10-11'de görülen hâlleridir; değişebilir.

---

## 1. Bir sayfada özet

1. **Öğrenme döngüsü:** Keşfet → Öğren → Uygula → Kanıt topla → Geri bildirim → Tekrar et → Yeni öneri.
   - İzlenme süresi öğrenme kanıtı sayılmaz.
2. **Müfredat omurgası lisans açısından güvenli olmalı:**
   - Kelime listesi için **CEFR-J** (ticari kullanım atıfla serbest [resmî metin doğrulanmadı]) ve **Octanove C1/C2** (CC BY-SA).
   - Dilbilgisi için **CEFR-J Grammar Profile**.
   - English Vocabulary Profile/English Grammar Profile (Cambridge), Oxford 3000/5000, Pearson GSE, COCA ve BNC yalnızca **referans**. Uygulamaya aktarılmaz.
3. **Seviye denetimi yapay zekâya bırakılamaz.**
   - LLM'den "A2 yaz" istendiğinde, metinlerin yalnızca %5–12,5'i istenen seviyede çıktı (Uchida 2025).
   - Bu yüzden şu hat gerekir: LLM taslağı → **deterministik denetçi** (kelime kapsama oranı, cümle uzunluğu, dilbilgisi kalıpları) → editör.
4. **Kapsama kuralı güncellenmeli:**
   - **Bütün seviyelerde** hedef: bilinen kelime ≥ %98. Alt sınır %95; buna yalnızca sözlük ve görsel destek varsa izin verilir.
   - CLAUDE.md'deki "A1–A2'de %5 bilinmeyen" kuralı bir alt sınırdır, hedef değildir.
5. **Hacim gerçekçi tutulmalı:**
   - A1–C1 için yaklaşık 160 hikâye gerekir. Bu, Cambridge'in seviye başına öngördüğü ders saatlerinin çok altındadır.
   - Uygulama **tamamlayıcı** olarak konumlanır. "C1'e ulaştırır" türü vaatler yapılmaz.
6. **Bir kelimenin öğrenilmesi için 8–20 karşılaşma gerekir.** Tek bir klip yetmez.
   - Haftanın hedef kelimeleri bütün serilerde tekrar eder: hikâye, klip, kelime kısası, shadowing, quiz ve aralıklı tekrar (SRS).
7. **Uygulama düzeni beş sekmedir:** Ana Sayfa · Keşfet · Öğren · Konuş · Profil.
   - Ana sayfa altı kartta biter; sonsuz kaydırma yoktur.
   - Akışta 4–5 klipte bir quiz kartı, yaklaşık 10 klipte bir **mola kartı** çıkar.
8. **Seviye takibi:**
   - MVP'de kural tabanlıdır: kademeli, atlanabilir, en fazla 20 soruluk bir yerleştirme testi ve beceri bazlı kanıt kaydı.
   - Seviye atlama "kapı testi" ile olur. Kelime tekrarında **FSRS** kullanılır (hedef hatırlama %90).
   - Veri biriktikçe Elo, ardından Rasch tabanlı uyarlamalı teste geçilir.
9. **Yayın hattı:** **İçerik kod olarak** yönetilir.
   - Git'teki `icerik/<id>/` → `content-lint` → içe aktarma → ince bir Spring onay ekranı → **Bunny Stream** → uygulama.
   - Kaba video maliyeti: 10 bin MAU'da ayda yaklaşık 20–40 USD.
10. **Sosyal medya:**
    - İlk aşamada elle yükleme yapılır. YouTube ve TikTok API'leri, denetimden geçmeden yalnızca gizli (private) yayın yapabiliyor.
    - Yapay zekâ etiketi her zaman konur.
    - AB Yapay Zekâ Yasası Madde 50 2 Ağustos 2026'dan beri yürürlükte. Türkiye'nin Ticari Reklam Yönetmeliği md. 18(8) de 1 Ağustos 2026'da yürürlüğe girdi.

---

## 2. Üç sistem

| Sistem | Ne yapar | Bu belgede |
|---|---|---|
| **İçerik fabrikası** | Brief → metin → çeviri → quiz → medya → kalite kontrolü → telif → onay → yayın | §3, §4, §9, §10, §11 |
| **Öğrenme deneyimi** | Ana sayfa, ders, kısa video, kelime, quiz, konuşma | §6 |
| **Öğrenme kanıtı** | Seviye tahmini, beceri profili, tekrar, ilerleme, öneri | §7, §8 |

---

## 3. Müfredat omurgası

### 3.1 Kelime ve dilbilgisi kaynakları (lisans)

| Kaynak | Lisans | Kullanım |
|---|---|---|
| **CEFR-J Wordlist** (A1–B2) | Araştırma ve ticari kullanım atıfla serbest. Kaynak: Open Language Profiles aynası, v1.5. Resmî cefr-j.org metni ve güncel sürüm (1.6?) [doğrulanmadı]. | **Omurga** |
| **CEFR-J Grammar Profile** | Kelime listesiyle aynı koşullar | **Omurga** |
| **Octanove C1/C2** | CC BY-SA 4.0 | C1 kelime omurgası. Uygulamaya gömülerek dağıtılırsa türev listeye share-alike koşulu uygulanır. |
| **NGSL / NAWL** | CC BY-SA 4.0 | Tamamlayıcı sıklık bandı. Atıf şart. |
| English Vocabulary Profile / English Grammar Profile (Cambridge) | Ticari kullanım Cambridge lisansı ister | Yalnızca referans |
| Oxford 3000/5000 | OUP telifi; ticari kullanım lisansla | Yalnızca referans |
| Pearson GSE | Ticari kullanım için Pearson ile iletişim gerekir | Yalnızca referans |
| COCA | Ücretli; sözleşmesi uygulamada sıra ve sıklık göstermeyi kısıtlar | Kaçınılmalı |
| BNC | Ticari kullanım yasak | Yalnızca referans |
| British Council/EAQUALS Core Inventory | © British Council/EAQUALS; yeniden kullanım lisansı yok | Planlamada referans; metni kopyalanmaz |
| CEFR Companion Volume (Avrupa Konseyi) | Çoğaltma için yazılı izin | Tanımlayıcılar **kendi cümlemizle** can-do hedeflerine çevrilir, atıf verilir |

- "Hakkında / Lisanslar" ekranında CEFR-J, Octanove ve NGSL atıfları yer alır.
- Kaynak kayıt kuralları için §12'ye bakın.
- Lisansların resmî metinden doğrulanması ayrı bir iştir: **H-027**.

### 3.2 Kapsama kuralı ve kelime havuzu (CLAUDE.md tablosu için öneri) [Karar gerekli: K-07]

**Araştırma bulguları:**
- Yardımsız okumada %98 bilinen kelime "en uygun", %95 "asgari" eşiktir (Hu & Nation 2000; Laufer & Ravenhorst-Kalovski 2010).
- Dinlemede %95 genelde yeterlidir (van Zeeland & Schmitt 2013).
- Hikâyelerimizde görsel, ses ve sözlük desteği olduğu için %95 alt sınır olarak savunulabilir.

**Önerilen kural:**
- Kümülatif CEFR-J listesine göre **token kapsaması ≥ %98** hedeftir. **%95** alt sınırdır; buna yalnızca seviye üstü kelimeler sözlükte açıklanmışsa ve görselle destekleniyorsa izin verilir.
- Kural **bütün seviyelere** uygulanır. Özel isimler sayılmaz.

**Kelime havuzu düzeltmesi:**
- Graded reader standartlarına göre B2 için 1.800–2.800 başlık kelime yeterlidir. CLAUDE.md'deki "B2 ~4.000" fazla yüksektir.
- Öneri:

| Seviye | Başlık kelime |
|---|---|
| A1 | ~550 |
| A2 | ~1.000 |
| B1 | ~1.600–2.000 |
| B2 | ~2.500–2.800 |
| C1 | ~3.800 |

- Bu değerler Penguin Readers ve Cambridge English Readers ölçeğiyle uyumludur.

### 3.3 Seviye başına hacim ve vaat [Karar gerekli: K-08]

**Ölçüt:** Bir seviyedeki toplam hikâye metni, aynı seviyedeki bir graded reader kitabının uzunluğu kadar olur.

| Seviye | Ünite | Hikâye | Toplam metin | Karşılaştırma |
|---|---|---|---|---|
| A1 | 10–12 | 30–40 × ~120 kelime | ~4.000 | Penguin L2 |
| A2 | 10–12 | ~40 × ~250 | ~10.000 | Penguin L3 |
| B1 | 10–12 | ~35 × ~450 | ~15.000 | Penguin L5 |
| B2 | 8–12 | ~30 × ~700 | ~21.000 | Penguin L7 |
| C1 | 8–12 | ~20 × ~1.100 | ~22.000 | Cambridge L6 |

- **Toplam:** yaklaşık 155–165 hikâye.
- **MVP:** A1–A2, 20 ders (plan). Bu, ilk 2–3 üniteye denk gelir.
- **Cambridge rehberli öğrenme saatleri (kümülatif):** A2 180–200, B1 350–400, B2 500–600, C1 700–800 saat.
  - Plandaki hacim seviye başına yaklaşık 4–12 saattir.
  - Bu yüzden uygulama **tamamlayıcıdır**.
  - Mağaza metninde ve uygulama içinde "X seviyesine ulaştırır" vaadi verilmez.

### 3.4 Ünite listeleri ve MEB eşlemesi

- **A1–C1 ünite başlıkları:** `ICERIK-STRATEJISI.md` §6'daki listeler (seviye başına 12 ünite) başlangıç olarak alınır.
- **MEB eşlemesi (Türkiye Yüzyılı Maarif Modeli, 2025):** Kaynak program yazarının sunumu; resmî PDF ile karşılaştırılmadı [doğrulanmadı].
  - İlkokul A1, ortaokul sonu A2, lise sonu B1. Program 8 ana temalı ve sarmal yapıda.
  - 13 yaş ve üstü kullanıcı kabaca 7–12. sınıf, yani A2.3–B1.4 aralığıdır.
- **[Öneri]** A2–B1 ünitelerine MEB tema etiketi eklensin (ör. "8. sınıf · Şehir"). Okul ile uyum bir avantaj olur. [Karar gerekli: K-20]

### 3.5 Ünite ve ders kalıbı

İki kaynaktaki kalıplar birleştirildi: kullanıcının dokuz adımlı ünite şablonu ve araştırmadaki hikâye temelli TBLT kalıbı.

1. **Isınma:** Bir tahmin sorusu ve görselli 5–8 anahtar kelime.
2. **Girdi:** Hikâye videosu, 3–4 bölüm. İngilizce ses ve İngilizce altyazı (bimodal).
3. **Anlama:** 3–5 soruluk quiz. Cevaplar açıklamalıdır.
4. **Biçime odak:**
   - Hikâyede geçen bir dilbilgisi noktası;
   - Türklerin sık yaptığı bir hatanın karşılaştırması ("Böyle de söyleyebilirsin").
5. **Kontrollü pratik:** Kelime ve kalıp alıştırması.
6. **Üretim (görev):**
   - Hikâyedeki senaryoda yapay zekâ rol yapma ya da sesli söyleme;
   - konuşma pratiği MVP'de yoksa yazılı veya seçmeli görev.
7. **Kanıt ve geri bildirim:** Görev kontrolü ve 1–3 gelişim noktası.
8. **Tekrar:** Kelimeler SRS destesine eklenir. Sonraki 2–3 ünitenin hikâyelerinde yeniden kullanılır (sarmal).
9. **Sonraki adım:** Bir sonraki ders ya da ilgili konuşma senaryosu.

Ünite başlığı Türkçe bir can-do cümlesi olur: "Bu ünitenin sonunda kafede sipariş verebileceksin."

### 3.6 Türklerin sık yaptığı hataların seviyelere dağılımı

| Seviye | Konular |
|---|---|
| A1 | *to be*, 3. tekil -s, SVO dizimi, özne zamirleri, a/an, /w/–/v/ ve /θ/–/ð/ farkındalığı |
| A2 | in/on/at, past simple, article'ların temel kullanımı |
| B1 | present perfect / past simple, genel ve belirli anlamda article |
| B2–C1 | false friends, eşdizimler, ünlü karşıtlıkları (/æ/–/e/, /æ/–/ʌ/) |

**Kaynak gücü:**
- **Literatürle desteklenenler:** article atlama, edat hataları, zaman ve görünüş hataları (yazılı anlam hatalarının %71,64'ü), telaffuz sorunları.
- **Zayıf ya da kaynaksız olanlar (editör deneyimiyle teyit edilmeli):** 3. tekil -s, "I am agree", false friends, ünlü uzunluğu.

**Ton:** Format adı "Bunu deme" değil, **"Böyle de söyleyebilirsin"** olur. Araştırmalar düzeltme formatının "tek doğru, ana dili gibi konuşmak" ideolojisini pekiştirdiğini ve izleyiciyi utandırdığını gösteriyor. Aksan tek başına hata sayılmaz.

---

## 4. İçerik türleri, seriler ve formatlar

### 4.1 İçerik hiyerarşisi

```text
Seviye (A1–C1)
  └── Ünite (can-do hedefi, 8–12 adet)
       └── Ders (4–6 adet; hikâye / diyalog / mikro ders)
            ├── Medya: video, ses, WebVTT altyazı, kelime zamanlama JSON'u
            ├── Hedefler: iletişim işlevi, dilbilgisi, kelimeler
            ├── Etkinlikler: pratik, quiz, görev
            ├── İsteğe bağlı konuşma senaryosu
            └── Türetilmiş 30 sn klipler (kaynak sahne ve sürüme bağlı)
```

### 4.2 Format × seviye matrisi

İşaretler: ✔ ana format · ○ destekleyici · – önerilmez

| Format (süre) | A1 | A2 | B1 | B2 | C1 | Üretim yolu |
|---|---|---|---|---|---|---|
| Seviyeli hikâye ve 30 sn kesiti | ✔ | ✔ | ✔ | ✔ | ✔ | Görsel + Ken Burns |
| Diyalog sahnesi (2 karakter, 20–40 sn) | ✔ | ✔ | ✔ | ○ | ○ | Görsel |
| Kelime/ifade kısası (1 ifade, 3 örnek) | ✔ | ✔ | ✔ | ✔ | ✔ (deyim/eşdizim) | Slayt, kredisiz |
| Dilbilgisi açıklayıcı ("30 sn'de X") | ○ | ✔ | ✔ | ✔ | ○ (nüans) | Slayt + öğretmen |
| Telaffuz ve minimal pair | ✔ | ✔ | ○ | ○ | – | Ses + yazı |
| "Böyle de söyleyebilirsin" (Türklerin hatası) | ✔ | ✔ | ✔ | ✔ | ○ | Slayt |
| Gerçek hayat senaryosu | ✔ | ✔ | ✔ | ○ | – | Görsel |
| Kültür notu (kurgusal) | – | ○ | ✔ | ✔ | ✔ | Görsel |
| Dinleme bulmacası ("Ne dedi?") | ✔ | ✔ | ✔ | ✔ | ✔ | Ses ağırlıklı |
| Shadowing (3 cümle × 2 tekrar) | ○ | ✔ | ✔ | ✔ | ○ | Ses + altyazı |
| "Bunu İngilizce nasıl dersin?" | ✔ | ✔ | ✔ | ✔ | ✔ | Slayt |

- Gerçek video klip yalnızca kancada ve kilit sahnede kullanılır (CLAUDE.md Higgsfield kural 4).
- Yazma görevi (rubrikli) MVP'de olmaz [Karar gerekli: K-11]. Gerekçe: yazmanın değerlendirilmesi LLM çağrısı ve maliyet gerektirir.

### 4.3 Seriler ve hikâye evreni [Karar gerekli: K-10]

| Seri | Format | Not |
|---|---|---|
| **Ana dizi: "Yeni gelen" evreni** | Seviyeli hikâyeler | Türkiyeli bir genç, kurgusal bir İngilizce şehre ya da okula gelir. Sabit 4–5 kişilik kadro. Her seviye bir "sezon" olur. Ortak kadro ve mekân yeni kelime yükünü düşürür (dar okuma/dinleme araştırması). extr@ dizisinin *desenidir*; özgün yazılır. |
| **Öğretmenin köşesi** | Dilbilgisi, "Böyle de söyleyebilirsin" | Sabit yapay zekâ öğretmen. İlk bölümde kendini yapay zekâ olarak tanıtır; sonradan "itiraf" edilmez (Lind 2024 [ikincil özet]). |
| **Günün ifadesi** | Kelime/ifade kısası | Seviye etiketli |
| **Kulak testi** | Dinleme bulmacası, minimal pair | Cevap sonda ya da uygulamadaki quizde |
| **Benimle söyle** | Shadowing | Cümleler ana diziden alınır |
| **İngilizce nasıl denir?** | Türkçe → İngilizce | Türkçe deyim ve günlük ifadeler |
| **Dünya notları** (B1+) | Kültür ve nezaket kalıpları | Kurgusal karakterlerle; gerçek kişi ya da marka yok |

**Kesişme kuralı:** Haftanın hedef kelimeleri bütün serilerde geçer. Hedef: kelime başına haftada **8 ve üzeri karşılaşma**.

**Açık sorular:**
- Kadro bütün seviyelerde ortak mı, yoksa her seviyenin kendi evreni mi olacak? A1 karakterinin C1'de konuşması tutarlılık sorunu yaratabilir.
- Öğretmen karakter gerçekçi mi, çizgi/animasyon mu olacak (§10.3, H-005)?

### 4.4 Seviye başına konu havuzu (13+ için güvenli)

- **A1:** kayıp kedi; yeni okulda ilk gün; kahvaltı ve pazar alışverişi; odamı tanıtıyorum; hava durumu ve kıyafet; doğum günü hazırlığı; park ve köpek; aile fotoğrafı.
- **A2:** okul gezisi; kaçırılan otobüs; ilk yemek tarifim; voleybol maçı; telefonu kaybetmek; kamp hafta sonu; komşunun papağanı; ikinci el bisiklet.
- **B1:** okul kulübü kurmak; trende kaybolan bavul; ilk yarı zamanlı iş; bilim fuarı; köyde kaybolan anahtar; hayvan barınağında gönüllülük; yabancı arkadaşla şehir turu.
- **B2:** uygulama geliştiren öğrenci ekibi; fotoğraf yarışmasında yanlış anlaşılma; müzede kaybolan tablo (şiddetsiz); takım kaptanlığı; çevre projesi; değişim öğrencisi olmak; gazete kulübünde haber doğrulama; sınav stresi.
- **C1:** yapay zekâ ve yaratıcılık tartışması; mülakat provası; fikir ayrılığını yönetmek; bir şehir efsanesini çürütmek; girişimcilik ve başarısızlık; çeviride kaybolan anlamlar; uzun yolculuk günlüğü.

`ICERIK-STRATEJISI.md` §6'daki iletişim üniteleri (otel, havaalanı, toplantı vb.) bu konularla birleştirilir: her ünite bir iletişim işlevi ve bir hikâye konusu taşır.

### 4.5 30 saniyelik kısa video şablonu (9:16)

| Saniye | İçerik |
|---|---|
| 0–1,5 | **Kanca:** bir soru ya da hikâyenin en gerilimli karesi. Gerekirse tek bir gerçek video klip burada kullanılır. Seviye rozeti ve seri adı. |
| 1,5–3 | **Söz:** "30 saniyede öğreneceksin: X" |
| 3–18 | **Öğretim çekirdeği:** Tek hedef. İngilizce ses ve altyazı; hedef kelimede küçük Türkçe karşılık. Yazılar kurguda eklenir, görsel modele yazdırılmaz (Higgsfield kural 7). |
| 18–23 | **Tekrar:** Hedef ifade bir kez daha, yavaş; büyük kart. |
| 23–27 | **Kendini test et:** "Hangisi doğru?" ya da "Duraklat ve söyle". Uygulamada bu an mini quize bağlanır. |
| 27–30 | **Kazanım ve CTA:** cevap; "Devamı ve quiz uygulamada"; bölüm numarası. Kalıcı "Yapay zekâ ile üretilmiştir" ibaresi. |

- **Süre:** A1–A2 30–40 sn, daha yavaş TTS. B2–C1 20–30 sn, doğal hız.
- **Ses:** Uygulamada -16 LUFS, sosyal medyada -14 LUFS (§9.6).

### 4.6 Altyazı politikası [Karar gerekli: K-03]

- **Araştırma:** İngilizce ses ve İngilizce altyazı (bimodal) kelime öğreniminde en iyi sonucu veriyor (Montero Perez 2013 meta-analizi). Çift altyazının etkisi tartışmalı ve seviyeye göre değişiyor.
- **[Öneri]**
  - Varsayılan: **EN altyazı + hedef kelimede küçük TR karşılık.**
  - TR satırı A1'de onboarding'de "açık" önerilir. A2 ve üstünde varsayılan kapalı; kullanıcı istediğinde açar.
  - Uygulamada altyazı **ayrı WebVTT dosyası** olarak verilir. Sosyal medyada videoya **gömülü** `.ass` altyazı kullanılır, çünkü videolar sessiz başlar.
  - Karaoke tarzı kelime vurgusu WebVTT ile yapılmaz. ElevenLabs hizalamasından üretilen **kelime zamanlama JSON'u** ve kendi altyazı widget'ımız gerekir. Hizalaması doğrulanmayan içerikte yalnızca satır vurgusu yapılır.

---

## 5. Kimlik, klasör ve meta veri [Karar gerekli: K-01]

İki öneri çakışıyor:

| | CLAUDE.md | `ICERIK-STRATEJISI.md` |
|---|---|---|
| Kök klasör | `icerik/` | `content/<seviye>/` |
| Kimlik | `A1-001-lost-cat` | `A2-TRAVEL-001-hotel-check-in` |

**[Öneri]** CLAUDE.md düzeni korunsun: `icerik/<SEVİYE>-<3 hane>-<kisa-baslik>/`.
- Konu kodu kimliğe değil, `content.json`'a yazılır. Gerekçe: kimlik değişmez; konu ise sonradan yeniden sınıflanabilir.
- Strateji belgesinden iki dosya eklenir:
  - **`content.json`:** makinece okunur meta veri.
  - **`rights-and-review.md`:** kaynaklar, lisans, güvenlik ve onay geçmişi.

**`content.json`'da zorunlu alanlar:**
- `contentId`, `slug`, `type`, `level`, `topic`, `meb_theme` (isteğe bağlı)
- `skills[]`, `communicativeFunction`, `grammarTargets[]`, `vocabularyTargets[]`
- `prerequisites[]`, `estimatedMinutes`, `version`, `status`, `publishAt`
- `aiGenerated`, `rightsStatus`, `seriesId`, `episode`
- `sourceStory` + `sourceScene` + `sourceVersion` (yalnızca klip ise)
- `coverage` (content-lint üretir)

**Medya dosyaları git'e konmaz.** Manifest'te içerik hash'leriyle tutulur, nesne depoda saklanır.

---

## 6. Uygulamada nerede ne görünecek

### 6.1 Sekmeler [Karar gerekli: K-02]

Şartname ve strateji belgesi aynı adları öneriyor: **Ana Sayfa · Keşfet · Öğren · Konuş · Profil**. Araştırma "Bugün · Öğren · Akış · Konuş · Ben" adlarını önerdi. **[Öneri]** İki belgede ortak olan adlar alınsın; Keşfet = kısa video akışı.

| Sekme | İçerik |
|---|---|
| **Ana Sayfa** | Tek ana eylem ve kısa plan (§6.2) |
| **Keşfet** | 30 sn'lik klip akışı; seviye filtreli; oturum sınırlı (§6.5) |
| **Öğren** | Üstte seviye seçici. İki görünüm: **Yol** (ünite yolu, varsayılan) ve **Kütüphane** (seviye, beceri, konu, süre, tür, tamamlanma ve kaydedilenler filtreleri) |
| **Konuş** | Senaryo kartları, kalan kota, geçmiş oturumlar. Kota dolsa da görünür kalır; durum ekranı gösterir. |
| **Profil** | İlerleme, Kelimelerim (SRS), hedef ve bildirim ayarları, ekran süresi ayarları, gizlilik, hesap, lisans atıfları |

### 6.2 Ana Sayfa (altı kart; sonsuz kaydırma yok)

1. **Devam et:** "A1 · Ünite 2 · The Lost Cat · 4 dk kaldı" ve tek büyük düğme.
2. **Günlük hedef halkası:**
   - Seri küçük ve nötr bir sayaçtır.
   - Seri koptuysa "yeniden başla" denir; kırık seri vurgulanmaz.
3. **Kelime tekrarı:** "Bugün 6 kelime · 2 dk".
4. **Konuşma önerisi:** Gerekçesiyle ("Son derste 'order' öğrendin") ve kalan kotayla.
5. **3 kısa video:** Sınırlı bir mini oturum açar, sonsuz akışa götürmez.
6. **Gerekçeli öneri:** Bir hikâye. Kullanıcı gizleyebilir.

```
┌───────────────────────────┐
│ Merhaba   🔥 5      A1    │
│ ┌───────────────────────┐ │
│ │ DEVAM ET              │ │
│ │ The Lost Cat · 4 dk   │ │
│ │      [ ▶ Devam ]      │ │
│ └───────────────────────┘ │
│ ◔ Bugün 6/10 dk           │
│ ▢ 6 kelime tekrarı (2 dk) │
│ ▢ Kafede sipariş · 1 hak  │
│ ▢ 3 kısa video            │
│ ▢ Önerilen: The Old Map   │
└AnaSayfa─Keşfet─Öğren─Konuş─Profil┘
```

### 6.3 Ünite yolu (Öğren › Yol)

- Yapı: seviye → ünite (Türkçe can-do başlığı) → ders düğümleri (●/○ ve süre) → ünite sonu görev ve tekrar.
- **Kilit esnek:** Sıradaki ders önerilir ama ders atlamak serbesttir. Ön koşulu tamamlanmamış ileri ders önerilmez.
- **Ünite sonu:** "Görev kontrolü". Seviye atlama "kapı testi"ne (§7.3) bağlanır.

### 6.4 Ders ekranı ve ders sonu

**Ders ekranı**
- **Üstte:** başlık, seviye, süre, hedefler ve "Yapay zekâ ile üretilmiştir" ibaresi.
- **Oynatıcı:**
  - hız 0,75 / 1 / 1,25;
  - 5 sn geri;
  - **Cümleyi tekrarla**;
  - **Satır sonunda dur** (shadowing).
- **Altyazı:** EN / EN+TR / kapalı. Kelimeye dokununca video durur ve alt sayfa açılır:
  - Türkçe karşılık, bağlamdaki anlam, örnek cümle, telaffuz sesi, **Kaydet** düğmesi.
  - Sözlükteki kelimelerin altı önceden çizilidir.
- **[Video | Metin] geçişi:** Transkriptte bir satıra dokununca video o satıra atlar.
- **Video bitince** otomatik olarak yeni videoya geçilmez; aktif alıştırma önerilir.
- **İçerik hata bildirimi:** ⚑ düğmesi.

**Ders sonu**
1. Tamamlanan görev.
2. Quiz sonucu ve açıklamalar.
3. Kaydedilen kelimeler.
4. Bir sonraki tekrar zamanı.
5. İlgili konuşma görevi.
6. Sonraki ders.

**Sonraya kalanlar:** A-B döngüsü, shadowing kaydı ve karşılaştırma, karaoke vurgusu (hizalama doğrulanana kadar).

```
┌───────────────────────────┐
│ ← The Lost Cat  A1 · 4dk  │
│ ┌───────────────────────┐ │
│ │       [video]         │ │
│ └───────────────────────┘ │
│ Tom [looks] for his cat.  │
│ Tom kedisini arıyor.      │
│ ⟲cümle  ⏸satır-sonu 0.75x │
│ [Video|Metin] EN·EN+TR·Kapalı │
└───────────────────────────┘
```

### 6.5 Keşfet akışı (13+ kitleye uygun) [Karar gerekli: K-15, H-014]

- **Oynatma:**
  - Kullanıcı Keşfet sekmesine kendisi girdiğinde video sesli başlar.
  - Ana sayfadaki "3 kısa video" kartından geçişte ilk klip sessiz başlar.
- **Kart eylemleri:** **Kaydet** · **Anlam** · **Tam hikâye** (kaynak sahneye gider) · **Bu içeriği önerme**. Altyazıda dokun-çevir çalışır.
- **Quiz kartı:** 4–5 klipte bir (dinle-seç ya da boşluk doldurma).
  - Video içi soruların öğrenmeyi artırdığı gösterilmiş; bir çalışma 703 öğrenciyle yapıldı.
- **Mola kartı:** Yaklaşık 10 klipte bir. Örnek: "Bugün 10 klip izledin, 4 ifade kaydettin. Tekrar yapalım mı?"
  - ICO Children's Code ve APA (2024) sonsuz kaydırma ile otomatik oynatmanın gençler için riskli olduğunu söylüyor.
- **13–17 yaş:** Varsayılan günlük akış sınırı (ör. 20 dk); kullanıcı ayarlardan değiştirebilir.
- **Yok:** beğeni sayısı, yorum, bildirimle akışa çağırma.
- **Teknik:**
  - Dikey `PageView`.
  - En fazla 3 açık controller (önceki, şimdiki, sonraki).
  - Klipler önbelleklenen kısa MP4 dosyaları olabilir; uzun dersler HLS ile oynatılır.

### 6.6 Konuş ekranı [H-007: MVP'de olup olmayacağı açık]

**Senaryo kartı**
- Rol ve hedef;
- **3 görev:** işaretlenebilir kutular (Speak deseni);
- 3 örnek ifade;
- seviye ve süre;
- mikrofon izni ve veri işleme açıklaması.

**Konuşma sırasında**
- Bas-konuş düğmesi.
- AI yanıtının metni ekranda görünür.
- Düğmeler: 🐢 yavaşlat · ↻ tekrar · TR çeviri · 💡 ipucu · ⚑ bildir.
- Anlık düzeltme yapılmaz (Babbel deseni).

**Bitiş ekranı**
- Ne iyi gitti.
- En fazla 3 düzeltme, Türkçe açıklamalı.
- 3 doğal ifade ve "Desteye ekle" düğmesi.
- Model güveni düşükse puan verilmez.

**Kota dolunca**
- Mesaj: "Bugünkü sesli pratik hakkın doldu. Yarın 00:00'da (TR saati) yenilenir."
- Alternatifler: [Metinle pratik] [Bu senaryonun hikâyesi] [Kelime tekrarı].
- Satın alma baskısı yapılmaz. Duolingo'nun "energy" sistemine gelen "para tuzağı" eleştirisi bunun ters örneği.

### 6.7 Profil › İlerleme

- **MVP:**
  - seviye çubuğu (ünitelerin yüzde kaçı bitti);
  - kelime sayacı: öğrenilen ve "olgun" (FSRS stability > 21 gün);
  - haftalık anlamlı oturum sayısı;
  - konuşma geçmişi;
  - birkaç rozet.
- **Beceri gösterimi:** Beceri radarı MVP'de **yoktur**, çünkü veri az olunca yanıltıcı olur. Bunun yerine kanıtı yeterli olan beceriler için metin gösterilir: "Dinleme: A2 içeriklerinde %78 (24 deneme)".
- **Gösterilmeyecekler:**
  - temelsiz "İngilizcen %73";
  - kısa sürede kesin B2/C1 iddiası;
  - sertifika izlenimi;
  - lig.

### 6.8 Onboarding

**Akış:**
1. Dil
2. **Yaş beyanı ve rızalar** (veri toplanmadan önce)
3. Hedef
4. **Hemen bir A1 mini hikâye klibi ve 1 soru (60–90 sn)**
5. Seviye testi (atlanabilir)
6. Hesap (misafir kullanımı kararına göre; H-009)
7. Ana Sayfa

- **Hedef:** İlk öğrenme anına 2 dakikadan kısa sürede ulaşmak.
- **Misafir modunda:** İlk klip için sunucuya kişisel veri gönderilmez.
- **Bildirim izni:** İlk gün değil, ilk dersten sonra istenir.

### 6.9 Erişilebilirlik ve Türkçe

- **Metin ölçekleme:** `MediaQuery.textScalerOf` kullanılır. `RichText` ile yazılan altyazıya ölçek elle aktarılır.
- **Ekran okuyucu ve dokunma:** Dokunulabilir kelimelere `Semantics` etiketi verilir. Dokunma hedefi en az 44–48 dp olur.
- **Türkçe büyük harf:** `toUpperCase()` i/İ ve ı/I dönüşümünde hata yapar. Türkçe metinde locale'e duyarlı dönüşüm kullanılır. İngilizce içerik TR locale'de büyük harfe çevrilmez ("LİSAN" hatası).
- **Metin uzunluğu:** Türkçe etiketler daha uzun olabilir. Düğmeler ve sekmeler test edilir.

### 6.10 Editör ekranı (MVP'de ince)

- **MVP'de:**
  - içerik kuyruğu;
  - önizleme ("önizleme" rolüyle uygulamada izleme);
  - kontrol listesi;
  - **Onayla / Zamanla / Kaldır** düğmeleri;
  - onay geçmişi;
  - kullanıcı hata bildirimleri.
- **Yetki:** Backend'de doğrulanır. Arayüzde düğmeyi gizlemek güvenlik sayılmaz.
- **Kapsam dışı:** Zengin metin düzenleme MVP'de yoktur; metin git'te düzenlenir (§9.1).

---

## 7. Seviye belirleme ve takip

### 7.1 İlkeler (`ICERIK-STRATEJISI.md` §9–§10 ile uyumlu)

- Sonuç "önerilen başlangıç seviyesi" olarak sunulur. Resmî sınav ya da sertifika değildir.
- Beceriler ayrı izlenir. **İçeriğin seviyesi** ile **kullanıcının tahmini seviyesi** ayrı kavramlardır.
- Tek bir yanlış cevap seviyeyi düşürmez; tek bir kolay quiz yükseltmez. Kanıt farklı içeriklerden ve farklı günlerden toplanır.
- Güven düşükse kesin bir iddiada bulunulmaz. Her değişiklik gerekçesiyle açıklanır.
- Kullanıcı seviyesini elle değiştirebilir ve testi atlayabilir.

### 7.2 Yerleştirme testi (MVP, kural tabanlı) [H-007 çelişkisinin çözümü için öneri]

**Başlangıç:** Kullanıcı kendi seviyesini seçer (A1…C1) ya da "bilmiyorum" der. Test bu noktadan başlar.

**Isınma:** Kaygıyı azaltmak için A1'den 2–3 soru sorulur.

**Kademeli ilerleme:**
- Her basamakta **4 soru** vardır: kelime, dilbilgisi, okuma ve bir kısa dinleme.
  - Dinleme sesi mevcut hikâye seslerinden kesilir; ek maliyet yoktur.
- 4 sorudan 3 ve üstü doğruysa → üst basamağa geçilir.
- 0–1 doğruysa → alt basamağa inilir ve test durur.
- 2 doğruysa → bu basamakta kalınır ve test durur.

**Sınırlar:**
- En fazla yaklaşık **20 soru**, süre yaklaşık **6–8 dk**.
- Plandaki "15–25 soru" ile şartnamedeki "kısa ve atlanabilir" yaklaşımı böylece uzlaşır.

**Sonuç:** "Önerilen başlangıç: A2". Testi atlayan kullanıcı kendi seçtiği seviyeden başlar.

**Madde havuzu:** Seviye başına en az 30–40 madde (tahmin).
- Vocabulary Size Test ve Vocabulary Levels Test maddeleri kullanılmaz; ticari lisansları belirsiz.
- Aynı yapıda, sıklık bantlarına göre **kendi maddelerimiz** yazılır.

**Güvenilirlik:** 5–10 dakikalık bir testin güvenilirliği için yayımlanmış bir rakam yok. Bu yüzden ilk haftanın ders performansı tahmini düzeltir.

### 7.3 Beceri puanları, ustalık ve seviye atlama

**Beceri puanı (MVP)**
- Beceriler: kelime, dilbilgisi, dinleme, okuma. Konuşma sonraki fazda eklenir.
- Her beceri için **son 20 denemenin** ağırlıklı doğruluk oranı tutulur.
- Her madde, ait olduğu beceri ve CEFR seviyesi ile etiketlidir.

**İlerleme durumları:** `NOT_STARTED`, `IN_PROGRESS`, `PRACTICED`, `COMPLETED`, `NEEDS_REVIEW`, `MASTERED`.
- `COMPLETED` = dersi bitirmek.
- `MASTERED` için hepsi gerekir: en az 3 deneme, en az 2 farklı gün, en az 2 görev türü, son denemelerde başarı, yardımsız hatırlama.

**Seviye atlama.** Aşağıdakilerin hepsi sağlanınca "B1'e geçmeye hazırsın" önerisi gösterilir. Geçişi kullanıcı onaylar.
- temel hikâyelerin en az %80'i tamamlanmış;
- quiz ortalaması en az %75;
- her becerinin son 20 denemesinde en az %70 doğruluk;
- 6–8 soruluk **kapı testi** geçilmiş.

**Seviye düşürme önerisi:** 2 hafta boyunca %50'nin altında kalınırsa bir alt seviye nazikçe önerilir.

**Yeniden değerlendirme:** Takvime bağlı zorunlu test yoktur. Seviye geçişinde kapı testi yapılır; 4 haftada bir isteğe bağlı mini kontrol sunulur.

Bütün eşikler **başlangıç tahminidir**. Beta verisiyle ayarlanmalıdır.

### 7.4 Kelime tekrarı (SRS) [Karar gerekli: K-04]

| | Strateji belgesi | Araştırma |
|---|---|---|
| Yöntem | Sabit aralıklar: 1 / 3 / 7 / 14 / 30 gün | **FSRS-6**, hedef hatırlama %90 (Anki'nin varsayılanı) |

**[Öneri]** FSRS kullanılsın.

- **Hesaplama sunucuda yapılır:** birden fazla cihaz ve tek doğru kaynak için.
- **Java tarafı:** Bakımı süren, saf Java bir kütüphane yok.
  - FSRS-6 formülleri py-fsrs'ten (MIT) Java'ya taşınır; kaynak belirtilir.
  - Lisanssız Kotlin portu kullanılmaz.
- **Çevrimdışı tekrar** gerekirse Dart `fsrs` paketi kullanılır. İki uygulamanın eşdeğerliği testle doğrulanmalı.
- **Düğmeler:** İki düğme: "Bildim / Bilmedim".
- **Dil:** "Unutmuşsun" yerine "Bu kelimeyi tekrar güçlendirelim".
- **Bağlam:** Aynı kelime farklı bağlamlarda sorulur.
- **Ayar:** Kullanıcı tekrar yoğunluğunu değiştirebilir.
- **Sabit aralıklar:** Yalnızca FSRS gelene kadar geçici çözüm olabilir.

### 7.5 Konuşma ve telaffuz değerlendirmesi

- **Azure Pronunciation Assessment:** İnsan puanlarıyla korelasyonu yalnızca ">0,5 Pearson" olarak veriliyor. Microsoft, ürünü kullanacak olanın kendi değerlendirmesini yapmasını öneriyor.
- **Üst sınır:** İnsan puanlayıcılar kendi aralarında r = 0,76–0,87 tutarlılık gösteriyor. Makineden beklenebilecek en iyi uyum budur.
- **Türk aksanı:** Türk aksanlı İngilizcede ASR doğruluğuna dair bir çalışma bulunamadı.
- **[Öneri]**
  - İlk aşamada yalnızca nitel geri bildirim verilir: anlaşılırlık ve görevin tamamlanması.
  - Telaffuz puanı ancak şu koşulla gösterilir: kendi Türk anadilli örneklemimizle (birkaç yüz kayıt) insan puanlarına karşı ölçülmüş olmalı.
  - O zaman da sayı yerine **bant** ve kelime düzeyinde ipucu verilir (H-015).

### 7.6 Faz B (veri biriktikçe)

1. **Elo:** Kullanıcı ve madde puanları birlikte güncellenir.
   - Başlangıç zorluğu CEFR etiketinden gelir (A1 = −2 … C1 = +2 logit).
   - K katsayısı belirsizlikle birlikte azalır (Pelánek 2016).
2. **Rasch kalibrasyonu:** Bir madde 200'den fazla cevap topladığında çevrimdışı yapılır.
   - Yerleştirme testi gerçek bir **uyarlamalı teste** dönüşür.
   - Durdurma kuralı: standart hata ≈ 0,4 logitin altına inince (tahmin).
3. **Gösterim:** "Tahminin: B1 (A2+ ile B1 arası)" gibi bir bant olarak.
4. **Ertelenenler:**
   - BKT: ince taneli dilbilgisi hedefleri için ileride düşünülebilir.
   - DKT/RNN: kullanıcı ölçeği büyüyene kadar gereksiz.

### 7.7 Öğrenme verisi modeli (taslak; kod onayından sonra kesinleşir)

- **`learning_events`:** Yalnızca eklenen tek olay tablosu.
  - Alanlar: `id` (UUIDv7), `user_id`, `occurred_at`, `event_type`, `object_type/id`, `content_version_id`, `skill`, `correct`, `score`, `hints_used`, `duration_ms`, `scoring_version`.
  - `client_event_id` UNIQUE'tir, böylece gönderim idempotent olur.
  - Tablo aylık partition'lanır.
  - Serbest metin, IP ve ses bu tabloya yazılmaz.
- **`assessment_items`:** `skill`, `cefr_level`, `freq_band`, `difficulty_logit`, `difficulty_se`, `exposure_count`, `status`.
- **`assessment_attempts`** ve **`assessment_responses`:** Türler PLACEMENT / GATE / CHECKIN. Sonuç bandı ve `algo_version` saklanır.
- **`user_skill_estimates`:** Birincil anahtar `(user_id, skill)`. Alanlar: `estimate`, `se`, `n_obs`, `algo_version`.
- **`user_level_history`:** Kaynak alanı PLACEMENT / SELF / GATE / SYSTEM_SUGGESTED değerlerini alır.
- **`user_content_progress`:** `(user, content_id, version_id)`, `status`, `last_position`.
- **`srs_cards`:** `stability`, `difficulty`, `due_at`, `reps`, `lapses`.
- **`srs_review_log`:** İleride FSRS parametre optimizasyonu için gerekir.

xAPI ya da Caliper gibi standartlara gerek yok; dışa entegrasyon yok. Gerekirse olay tablosundan dönüştürülür.

**Saklama [Öneri; hukukla doğrulanmalı]**
- Ham olaylar 12 ay sonra özetlenir ve silinir.
- Özet tablolar hesap silinene kadar tutulur.
- Hesap silindiğinde 30 günlük pencerenin sonunda hepsi silinir. Yalnızca anonim madde istatistikleri kalır.
- Periyodik imha 6 ayı geçmeyen aralıklarla yapılır [ikincil kaynak].

---

## 8. Kişiselleştirme (MVP: kural tabanlı)

**Öneri sırası:**
1. Yarım kalan ders
2. Zamanı gelen tekrar
3. Öğrenilen konuyu uygulayan görev
4. Müfredattaki sonraki ders
5. İlgi alanına uygun keşif klibi

**Kurallar:**
- Ön koşulu tamamlanmamış ileri ünite önerilmez.
- Kanıtı az olan beceri için kısa bir görev önerilir.
- Kullanıcının sürekli atladığı içerik türü çeşitlendirilir.
- Zorlanmada destek içeriği, sürekli başarıda daha zor içerik önerilir.
- Her önerinin görünür bir gerekçesi vardır.
- Kullanıcı başına LLM çağrısı gerekmez.

---

## 9. Üretim ve yayın hattı

### 9.1 İçerik yönetimi: üç yolun karşılaştırması [Karar gerekli: K-12, H-011]

| Yol | Tek kişilik ekip için değerlendirme |
|---|---|
| Headless CMS (Strapi, Directus, Payload, Sanity, Contentful) | İkinci bir çalışma ortamı ve şema getirir. Kimlik ve denetim kaydı ikiye bölünür. SaaS seçeneklerinde veri yurt dışında kalır. **MVP için gereksiz.** |
| Spring içinde tam yönetim paneli | Kimlik ve denetim kaydı yeniden kullanılır. Ama zengin metin editörü yazmak pahalıdır. |
| **İçerik kod olarak** + ince Spring onay ekranı | Git sürümleme, fark görme, geri alma ve PR incelemesini bedavaya verir. `icerik/` düzenine ve Claude Code iş akışına doğrudan uyar. **[Öneri]** |

İleride dışarıdan editör gelirse Directus var olan PostgreSQL şemasının üzerine oturabilir. Lisansı çalışan sayısına ve gelire göre ücretsizdir; adı kaynaklarda çelişkili.

### 9.2 Akış

1. **Brief.** Seviye, can-do hedefi, hedef kelime ve dilbilgisi, seri ve bölüm, format, süre.
2. **Taslak.** LLM, CEFR kısıtlarıyla yazar (videoGenerator `StoryWriter` deseni). Yanında Türkçe çeviri taslağı, sözlük ve quiz hazırlanır.
3. **`content-lint` (deterministik; yerelde ve CI'da).** Şunları denetler:
   - şema ve gerekli dosyalar;
   - CEFR-J token kapsaması (§3.2) ve cümle uzunluğu;
   - hedef dışı dilbilgisi;
   - seviye üstü kelimeler (sözlük adayları);
   - sözlük ↔ metin ve quiz ↔ metin tutarlılığı;
   - `PROMPTS.md` ve `rights-and-review.md`'nin varlığı;
   - yasaklı konu taraması.

   CVLA ya da cefrpy ikinci görüş olarak kullanılır. **LLM'in kendi seviye hükmüne güvenilmez.**
4. **İnsan kontrolü.** İngilizce doğallık, Türkçe çeviri, quiz cevapları, pedagoji.
   - Kritik kalite kontrolünü içeriği üreten yapmamalı.
   - Bu projede üretimi Claude yapar, onayı kullanıcı ya da editör verir (H-028).
5. **Medya.** Önce `generate cost` çalıştırılır ve **onay alınır**. Sonra:
   - görseller, TTS ve hizalama;
   - sahne zamanlaması (`SceneTimer`);
   - Ken Burns kurgusu;
   - loudnorm.

   Çıktılar:
   - uygulama için MP4/HLS, WebVTT ve kelime zamanlama JSON'u;
   - sosyal medya için gömülü altyazılı 9:16 kesit;
   - C2PA imzası.

   Hepsi içerik hash'iyle adlandırılmış, değişmez ve idempotent yüklemedir.
6. **İçe aktarma.** `POST /admin/content/import` → `content_version` kaydı → `IN_REVIEW`.
7. **Onay.** Editör içeriği uygulamada önizleme rolüyle izler, kontrol listesini işaretler ve onaylar. Onay **sürüme** bağlanır: kim, ne zaman, kontrol listesi hash'i.
8. **Zamanlama ve yayın.** `publish_at` (Europe/Istanbul). Katalog sorgusu `status = PUBLISHED AND publish_at <= now()` filtresiyle çalışır; cron işine gerek kalmaz.
9. **Yayın sonrası.** İlk 24–72 saatte izlenir: video başlatma hataları, quiz itirazları, seviye geri bildirimi, telif ve güvenlik bildirimleri.

### 9.3 Durum makinesi [Karar gerekli: K-05]

Strateji belgesi 10 ana ve 5 ek durum öneriyor: IDEA → BRIEF_APPROVED → DRAFT → LANGUAGE_REVIEW → PEDAGOGICAL_REVIEW → MEDIA_PRODUCTION → QA → APPROVED → SCHEDULED → PUBLISHED; ek olarak REJECTED, BLOCKED, REVIEW_REQUIRED, ARCHIVED, RETIRED.

**[Öneri]** Tek kişilik ekip için kısaltılmış hâli:

`DRAFT → IN_REVIEW → APPROVED → SCHEDULED → PUBLISHED → ARCHIVED`

Ayrıca **`WITHDRAWN`** durumu: acil yayından kaldırma, örneğin telif şikâyeti.

- İnceleme adımları ayrı durum olarak değil, **onay kontrol listesinin maddeleri** olarak tutulur: dil, pedagoji, medya kalite kontrolü, telif ve güvenlik.
- Ekip büyürse alt durumlara bölünebilir.
- `APPROVED` olmadan yayın yapılmaz. Bu kontrol backend'de yapılır.
- **AI'ın yayın yetkisi yoktur.**

### 9.4 Sürüm ve kullanıcı ilerlemesi

- **Değişmez sürümler:** `content` (kalıcı kimlik) + `content_version` (değişmez kayıt) + `published_version_id` işaretçisi. Geri almak işaretçiyi eski sürüme çevirmektir.
- **İlerleme ve quiz denemeleri** `(content_id, version_id)` ikilisiyle saklanır.
  - Küçük düzeltme: yeni sürüm açılır, tamamlanma bilgisi korunur.
  - Büyük değişiklik (quiz cevabı ya da sahne sırası): eski denemeler eski sürüm üzerinden geçerli kalır.
  - Kazanılmış ilerleme **asla geri alınmaz**.
- **Kelime kayıtları** `lemma`'ya bağlanır, sürüme bağlanmaz.
- **Geri çekilen içerik** boş ekran bırakmaz; yerine alternatif önerilir.

### 9.5 Video barındırma [Karar gerekli: K-13, H-012]

**Varsayımlar:**
- MAU başına ayda 30 dakika izleme;
- ~720p, ~1,5 Mbps;
- kütüphane ~500 dakika, ~10 GB.

**Kaba aylık maliyet** (2026-10-11'de görülen fiyatlar):

| Hizmet | 1k MAU | 10k MAU | Not |
|---|---|---|---|
| **Bunny Stream** | ~4 USD | ~17–35 USD | Kodlama ücretsiz. Depolama Frankfurt'ta, şirket AB'de. Dizin tokenı var. Türkiye'nin hangi fiyat bölgesine girdiği [doğrulanmadı]. |
| R2 + kendi ffmpeg HLS | ~0–1 USD | ~1–5 USD | Çıkış trafiği ücretsiz. Ama HLS kademeleri ve token Worker'ının bakımı bize kalır. |
| AWS (CloudFront sabit plan + MediaConvert) | ~20–25 USD | ~20–25 USD | Sabit plan bilgileri ikincil kaynaktan [doğrulanmadı]. |
| Mux | ~0 USD (ücretsiz kota) | ~140–200 USD | |
| Cloudflare Stream | ~35 USD | ~305 USD | |

**[Öneri]**
- MVP'de **Bunny Stream**, bir `VideoHostingPort` adaptörünün arkasında. Böylece ileride R2'ye geçmek kolay olur.
- Kısa ömürlü dizin tokenı kullanılır; token'a kullanıcı kimliği konmaz.
  - İçerik ücretsiz olduğu için asıl risk, başka sitelerin videoyu gömmesinin yarattığı trafik maliyetidir.
- **KVKK:** CDN, kullanıcı IP adreslerini işler; bu yurt dışına aktarım sayılır. Standart sözleşme imzalanır ve **5 iş günü içinde** Kurul'a bildirilir. Hukukçu teyidi gerekir.

### 9.6 Otomatik kalite kapıları

- **Ses yüksekliği:**
  - Uygulama için **-16 LUFS / -1 dBTP**, sosyal medya için **-14 LUFS**.
  - ffmpeg `loudnorm` iki geçişte çalıştırılır, `ebur128` ile ölçülür.
- **Altyazı senkronu (deterministik):**
  - Cue metinleri birleştirildiğinde hikâye metniyle aynı olmalı.
  - Cue'lar çakışmamalı ve ses süresini aşmamalı.
  - En kısa cue ≥ 1 sn.
  - A1'de okuma hızı ≤ 15 karakter/sn.
  - İsteğe bağlı olarak Whisper ile bağımsız hizalama; tolerans ±200 ms.
- **Güvenlik ve telif:**
  - Metin için LLM rubriği: 13+ yasaklı konular, marka, ünlü adı.
  - Görsel için logo, yazı ve gerçek yüz taraması.
  - Algısal hash ile tekrar eden görsel tespiti.
- **C2PA:**
  - `c2patool` ile son MP4 imzalanır (`trainedAlgorithmicMedia`).
  - Platformlar bu meta veriyi silebildiği için **görünür ibare de** şarttır.
- Otomatik kalite kontrolü insan onayının yerine geçmez.

### 9.7 Uygulama güncellemesi olmadan içerik

- **Mağaza kuralları:** Apple 2.5.2 ve Google Play yalnızca çalıştırılabilir kod indirmeyi yasaklıyor. Video, JSON ve metin indirmek serbest.
- **İçerik yükünde `schemaVersion`:** Eski uygulama sürümü bilmediği blok türlerini atlar.
- **`/api/v1/app-config`:** `minSupportedVersion` ve özellik bayraklarını döner. Bayraklar bir PostgreSQL tablosunda tutulur; Firebase Remote Config gerekmez.

---

## 10. Sosyal medya dağıtımı (H-017; yayın ayrıca onay ister)

### 10.1 Platform kuralları

| Platform | Durum |
|---|---|
| YouTube | Denetimden geçmemiş API projesinin yüklediği videolar **private** kalır. `containsSyntheticMedia` yalnızca **gerçekçi** içerik için zorunlu. **`madeForKids` beyanı zorunlu.** Çizgi hayvanlı A1 hikâyeleri "çocuklara yönelik" sayılabilir; bu durumda yorumlar ve kişiselleştirilmiş reklam kapanır. Hukuki karar gerekir. |
| TikTok | Denetlenmemiş istemci yalnızca `SELF_ONLY` paylaşabilir. AIGC etiketi var. C2PA ile otomatik etiket [doğrulanmadı]. |
| Instagram | Business veya Creator hesap gerekir. Reels 5–90 sn. `is_ai_generated` parametresi [tek kaynak]. |

**[Öneri]**
- İlk aşamada **elle yükleme**.
- API otomasyonu denetim sürecinden sonra kurulur; videoGenerator'daki publisher desenleri kullanılır.
- Yapay zekâ etiketi her zaman konur.

### 10.2 Derin bağlantı

- Firebase Dynamic Links 25.08.2025'te kapandı.
- **Ücretsiz yol:** `hi.velzon.tr` üzerinde Universal Links / App Links (`apple-app-site-association`, `assetlinks.json`).
  - Bu, alan adının ve küçük bir statik sitenin erken açılmasını gerektirir (H-016/H-017).
- **Deferred deep linking:**
  - Android'de Play Install Referrer ücretsiz.
  - iOS'ta ücretsiz ve güvenilir bir yol yok.
  - Ölçüm şirketlerinin SDK'ları cihaz kimliği toplar ve Families politikasıyla çakışabilir. **MVP'de yok.**

### 10.3 Yapay zekâ şeffaflığı (hukuki teyit gerekir)

- **AB Yapay Zekâ Yasası Madde 50** (2 Ağustos 2026'dan beri yürürlükte):
  - **50(1):** Konuşma pratiğinde kullanıcıya yapay zekâyla konuştuğu söylenir. Uygulama AB'de yayındaysa geçerli.
  - **50(4):** Foto-gerçekçi öğretmen karakteri "deepfake" kapsamına girebilir.
- **Türkiye — Ticari Reklam Yönetmeliği md. 18(8)** (yürürlük 01.08.2026): İnsandan ayırt edilemeyen bir yapay zekâ karakteri reklamda kullanılırsa bu açıkça belirtilmeli. Uygulamanın tanıtım videolarına uygulanabilir.
- **Araştırma:** Yapay zekâ ile üretilmiş derslerde öğrenme sonucu insan videosuyla aynı, ama keyif biraz daha düşük (ETH, 447 katılımcı).
  - Avatarın yapay zekâ olduğu **ortada** açıklanırsa güven düşüyor.
  - Bu yüzden etiket baştan ve tutarlı olmalı.
  - Çizgi/animasyon tarz hem etiket hem "gerçek öğretmen sanma" riskini azaltır (H-005).

---

## 11. Yayın ritmi [Karar gerekli: K-09]

**Seçenekler:**
- Strateji belgesi: haftada 2–3 uzun ders, B2/C1 dahil.
- Araştırma: tek kişilik ekip için sürdürülebilir tutarlılık hacimden önemli.

**[Öneri]**
- **İlk 4 hafta:** haftada 1 uzun hikâye + 3–4 kısa video (A1–A2).
- **Ölçüm sonrası:** haftada 1 hikâye + 1 ders + 7 kısa video. Bu, plan §5.4'teki ~13–17 saatlik emek tahminiyle uyumlu.
- Kısa videoların yaklaşık 5'i aynı hikâyeden türetilir; ayrı yazım gerekmez.
- Günlük öneriler var olan katalogdan seçilir. Her gün yeni içerik üretmek gerekmez.

**Hedef haftalık takvim:**

| Gün | Yayın | Kaynak |
|---|---|---|
| Pzt | Günün ifadesi | Slayt |
| Sal | Hikâye kesiti 1 | Haftanın hikâyesi |
| Çar | Böyle de söyleyebilirsin | Slayt + öğretmen |
| Per | Kulak testi | Hikâye sesi |
| Cum | Hikâye kesiti 2 | Aynı hikâye |
| Cmt | Benimle söyle | Hikâye cümleleri |
| Paz | Hafta özeti quizi / İngilizce nasıl denir? | Slayt |

**Üretim haftası:**
- **Pazartesi:** yazım, `content-lint`, onay.
- **Salı–Çarşamba:** toplu medya üretimi; maliyet onayıyla.
- **Perşembe:** kalite kontrolü.
- **Yayınlar:** `publish_at` ile önceden zamanlanır.

Her yayının kaydı: içerik kimliği ve sürümü, zaman, seviye, kanal, hedef, CTA, onaylayan, geri çekme planı.

---

## 12. Telif ve kaynak kaydı

`ICERIK-STRATEJISI.md` §5 aynen geçerlidir.

**Kurallar:**
- İnternette bulunmak yeniden yayınlama izni değildir. "Eğitim amacı" da tek başına izin sayılmaz.
- Rakip içerikleri, film/dizi/sosyal medya klipleri ve marka unsurları kullanılmaz.
- Açık lisanslarda ticari kullanım, türev eser ve atıf koşulları kontrol edilir.
- Hak sahipliği belirsizse içerik yayınlanmaz.

**Kayıt:** Her kaynak `rights-and-review.md` dosyasına ve `content_sources` tablosuna yazılır. Alanlar: URL, başlık, lisans, atıf metni, ticari kullanım izni, türev eser izni, kontrol tarihi, onaylayan.

**Hukuki risk:** Referans listelerdeki seviyeleri sistematik biçimde kopyalamak veritabanı hakkına takılabilir. Hukuk görüşü alınmalı (H-027).

---

## 13. Ölçümler

**Öğrenme**
- Haftalık **anlamlı öğrenme döngüsü** tamamlayan aktif kullanıcı (kuzey yıldızı). Döngü örnekleri: ders + quiz + geri bildirim; konuşma + geri bildirim; kelime + gecikmeli tekrar.
- Ders sonrası aktif alıştırma, gecikmeli tekrar başarısı, klipten derse geçiş, haftalık kelime karşılaşma sayısı.

**İçerik kalitesi**
- 1.000 oturum başına dil hatası bildirimi.
- Çeviri düzeltmeleri, quiz itirazları, altyazı ve ses hataları, geri çekmeler.
- Yayından önce yakalanan hata oranı.

**Maliyet:** Kullanıcı başına AI ve video maliyeti; kota yüzünden başarısız olan oturumlar.

**Kaçınılacaklar:** İzlenme süresini ve uygulama açılışını başarı saymak; doğrulanmamış skorları metrik olarak kullanmak.

---

## 14. Karar listesi

> **2026-10-11:** Kullanıcı aşağıdaki önerileri onayladı. Onaylananlar K-01…K-16 ve K-20; bağlayıcı özetleri CLAUDE.md'de. K-17 (faz yapısı), K-18 (onay ve kapasite) ve K-19 (lisans doğrulaması) karar değil, açık iş olarak devam ediyor.

Karar listesi H-026'ya bağlıdır. Bazı maddeler var olan işlere bağlanır.

| # | Karar | Seçenekler | Öneri | İlgili iş |
|---|---|---|---|---|
| K-01 | İçerik kimliği ve klasörü | `icerik/A1-001-…` / `content/A2/A2-TRAVEL-001-…` | `icerik/` korunur; konu `content.json`'a yazılır; `content.json` ve `rights-and-review.md` eklenir | H-026 |
| K-02 | Sekme adları | Ana Sayfa·Keşfet·Öğren·Konuş·Profil / Bugün·Öğren·Akış·Konuş·Ben | İlki (iki belgede ortak) | H-026 |
| K-03 | Altyazı varsayılanı | EN / EN+TR / EN + TR karşılık | EN + hedef kelimede TR; A1'de TR satırı önerilir | H-026 |
| K-04 | SRS | Sabit aralık / FSRS | FSRS (%90, sunucuda) | H-026 |
| K-05 | Durum makinesi | 10+5 durum / 6+1 | 6+1; inceleme adımları kontrol listesinde | H-026 |
| K-06 | Seviye testi | 15–25 uyarlamalı / kısa, atlanabilir | Kademeli, en fazla 20 soru, atlanabilir | H-007 |
| K-07 | Kapsama kuralı ve kelime havuzu | A1–A2'de %5 / bütün seviyelerde %98 hedef, %95 alt sınır | İkincisi; B2 havuzu 2.500–2.800 (CLAUDE.md tablosu güncellenir) | H-026 |
| K-08 | Hacim ve vaat | — | ~160 hikâye; "seviyeye ulaştırır" vaadi yok | H-026 |
| K-09 | Yayın ritmi | 2–3 ders/hafta / 1 hikâye + 3–4 kısa | İkincisiyle başla, ölçerek artır | H-026, H-004 |
| K-10 | Hikâye evreni | Ortak kadro / seviye başına evren | "Yeni gelen" ortak evren, her seviye bir sezon | H-026 |
| K-11 | Yazma görevi MVP'de mi? | Evet / hayır | Hayır (P1) | H-026 |
| K-12 | İçerik yönetimi | CMS / tam panel / içerik kod olarak | İçerik kod olarak + ince onay ekranı | H-011 |
| K-13 | Video barındırma | Bunny / R2 / Mux / Cloudflare / AWS | Bunny Stream (adaptör arkasında) | H-012 |
| K-14 | Sosyal medya | API / elle | Önce elle; API denetimden sonra | H-017 |
| K-15 | Akış sınırları | — | Her 4–5 klipte quiz, ~10 klipte mola, 13–17 yaş için 20 dk varsayılan | H-014 |
| K-16 | Seri (streak) | — | Kırık seri vurgulanmaz; dondurma ve onarma var; seri "anlamlı etkinlik" ile korunur, yalnızca video izlemek yetmez | H-013 |
| K-17 | Faz yapısı | Plan 4 / şartname 6 / strateji 8 faz | Tek yapıda birleştirilir | H-007, H-023 |
| K-18 | Onaylayan kişi ve kapasite | — | Pedagojik onay, editör sayısı, ilk 3 ayın kapasitesi, içerik bildirimlerini kim inceleyecek | H-028 |
| K-19 | Lisans doğrulaması | — | CEFR-J resmî metni; Cambridge'e yazılı soru; veritabanı hakkı | H-027 |
| K-20 | MEB tema etiketi | Evet / hayır | Evet (A2–B1) | H-026 |

---

## 15. Seçilmiş kaynaklar

**Müfredat**
- CEFR-J / Open Language Profiles: https://github.com/openlanguageprofiles/olp-en-cefrj
- NGSL: https://www.newgeneralservicelist.com/new-general-service-list
- EVP: https://englishprofile.org/?menu=english-vocabulary-profile
- COCA lisansı: https://wordfrequency.info/license.asp
- BNC lisansı: https://www.natcorp.ox.ac.uk/docs/licence.html
- Penguin Readers el kitabı: https://www.penguinreaders.co.uk/wp-content/uploads/2019/09/PR_ReadersHandbook_Main.pdf
- Laufer & Ravenhorst-Kalovski: https://nflrc.hawaii.edu/rfl/item/206
- Cambridge rehberli öğrenme saatleri: https://support.cambridgeenglish.org/hc/en-gb/articles/202838506-Guided-learning-hours
- Uchida 2025 (LLM ve CEFR): https://files.eric.ed.gov/fulltext/EJ1466280.pdf
- MEB 2025: https://ttkb.meb.gov.tr/www/ingilizce-dersi-ogretim-programlarinda-guncelleme-yapildi/icerik/795

**Seviye takibi**
- Duolingo yerleştirme testi: https://blog.duolingo.com/partial-credit-improvements-to-duolingos-placement-test/
- Half-life regression: https://aclanthology.org/P16-1174/
- Elo (Pelánek): https://www.fi.muni.cz/~xpelanek/publications/CAE-elo.pdf
- Rasch örneklem: https://www.rasch.org/rmt/rmt74m.htm
- FSRS: https://github.com/open-spaced-repetition/awesome-fsrs
- Azure telaffuz sınırları: https://learn.microsoft.com/en-us/azure/foundry/responsible-ai/speech-service/pronunciation-assessment/characteristics-and-limitations-pronunciation-assessment

**Ekranlar**
- Duolingo İngilizce kursu: https://blog.duolingo.com/how-duolingo-teaches-english
- Seri araştırması: https://udel.edu/udaily/2024/march/power-of-streaks-motivation-jackie-silverman
- APA sonsuz kaydırma: https://www.nbcnews.com/news/us-news/psychology-group-says-infinite-scrolling-social-media-features-are-par-rcna147876
- video_player: https://pub.dev/packages/video_player

**Yayın**
- Bunny Stream fiyatları: https://bunny.net/docs/stream/pricing
- Cloudflare Stream fiyatları: https://developers.cloudflare.com/stream/pricing/
- Mux fiyatları: https://www.mux.com/docs/pricing/video
- YouTube API değişiklik geçmişi: https://developers.google.com/youtube/v3/revision_history
- TikTok içerik paylaşım kuralları: https://developers.tiktok.com/doc/content-sharing-guidelines
- AB Yapay Zekâ Yasası şeffaflık: https://www.paulweiss.com/insights/client-memos/eu-finalises-transparency-rules-for-ai-generated-content
- Reklam yönetmeliği: https://celikhukuk.av.tr/reklamlarda-yapay-zeka-kullanimi-1-agustos-2026-yonetmeligi/

**Formatlar**
- Altyazı meta-analizi: https://doi.org/10.1016/j.system.2013.07.013
- Video içi sorular: https://dr.lib.iastate.edu/entities/publication/d9a2fcf8-8d8f-4784-b8e4-c5c9e28810e4
- Kelime karşılaşma sayısı: https://www.frontiersin.org/journals/psychology/articles/10.3389/fpsyg.2016.01396/pdf
- Dar okuma: https://scholarspace.manoa.hawaii.edu/handle/10125/66625
- AI video ve öğrenme (ETH): https://media-and-learning.eu/subject/artificial-intelligence/when-ai-took-over-my-teaching-videos-students-enjoyed-them-less-but-learned-the-same/
- extr@: https://en.wikipedia.org/wiki/Extra_(franchise)
