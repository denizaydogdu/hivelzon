# HiVelzon — Lisans Doğrulama Raporu (H-027)

- **Hazırlanma tarihi:** 2026-10-11
- **Kapsam:** Müfredat omurgasında ve yardımcı araçlarda kullanılacak kelime/dilbilgisi listeleri, testler, yazılım kütüphaneleri ve MEB programı.
- **Yöntem:** Yalnızca web araştırması. Kimseyle yazışılmadı, form doldurulmadı, hesap açılmadı.
  - Lisans metinleri her kaynağın kendi sitesinden okundu.
  - JavaScript ile yüklenen sayfalar (English Profile) tarayıcıyla açılıp sitenin kendi yüklediği metinden okundu.
  - Erişimi engelleyen siteler (Avrupa Konseyi `rm.coe.int`, Text Inspector) için Internet Archive kopyası kullanıldı. Kullanılan arşiv tarihi her bulguda yazılıdır.
- **Kullanım bağlamı:** HiVelzon, Velzon Bilişim Teknolojileri Ltd. Şti.'nin ürünüdür. Ücretsizdir; reklam ve abonelik yoktur. Yine de **ticari kullanım** varsayılarak değerlendirildi.
- **Önemli:** Bu rapor hukuk görüşü değildir. "Kullanılabilir" kararı, lisans metninin açık ifadesine dayanır. Yoruma açık noktalar §8'de hukukçuya sorulacak sorular olarak ayrıca listelendi.
- **İşaretler:**
  - **[doğrulandı]:** Birincil kaynak okundu, alıntı aşağıda.
  - **[doğrulanmadı]:** Birincil kaynak okunamadı ya da ilgili hüküm bulunamadı. Tahmin yapılmadı.

---

## 1. Özet tablo

Tüm kontroller 2026-10-11 tarihinde yapıldı.

| # | Kaynak | Lisans / koşul | Karar | Atıf gerekli mi? | Birincil kaynak URL | Doğrulandı mı? |
|---|---|---|---|---|---|---|
| 1a | **CEFR-J Wordlist v1.6** (2020-03-24) | © Tono Lab, TUFS. Araştırma, eğitim ve ticari kullanım uygun atıfla ücretsiz. Türev liste serbest, atıf şart. | **Kullanılabilir** (omurga) | Evet | https://www.cefr-j.org/download.html | Evet |
| 1b | **CEFR-J Grammar Profile** (tam veri 2025-02-25) | Resmî sayfada yalnızca atıf biçimi ve sorumluluk reddi var. Açık bir ticari kullanım izni yok. OLP aynası (2018 sürümü) "ticari kullanım serbest" diyor. | **Kullanılabilir, koşullu.** Dilbilgisi sırası referans alınır. Ham veri uygulamaya gömülmez. Yazılı teyit önerilir. | Evet | https://www.cefr-j.org/download.html · https://github.com/openlanguageprofiles/olp-en-cefrj | Kısmen |
| 2 | **Octanove Vocabulary Profile C1/C2 v1.0** | CC BY-SA 4.0 | **Kullanılabilir.** Share-alike yükümlülüğü vardır. | Evet + lisans bağlantısı | https://github.com/openlanguageprofiles/olp-en-cefrj | Evet (lisans). Listenin nasıl üretildiği doğrulanmadı. |
| 3 | **NGSL 1.2 / NAWL 1.2** | CC BY-SA 4.0 | **Kullanılabilir.** Share-alike yükümlülüğü vardır. | Evet + lisans bağlantısı | https://www.newgeneralservicelist.com/new-general-service-list · …/new-academic-word-list | Evet |
| 4 | **English Vocabulary Profile / English Grammar Profile** (Cambridge) | Kişisel, ticari olmayan araştırma ve öğretim dışında kullanım yazılı izne bağlı. Cambridge bu verileri ticari amaçla lisanslamadığını açıkça yazıyor. | **Kullanılmaz.** Bu, önceki "yalnızca referans" kararından daha sıkıdır. | — | https://www.englishprofile.org/ (Terms of Use bölümü) | Evet |
| 5a | **Oxford 3000/5000** | OUP sitesi yalnızca "domestic and private use" için. Ticari kullanım lisans ister. | **Kullanılmaz** | — | https://www.oxfordlearnersdictionaries.com/terms-and-conditions | Evet |
| 5b | **Pearson GSE** | Ticari olmayan kullanım rehbere tabi. Ticari kullanım için önce Pearson'la iletişim gerekli. | **Kullanılmaz** (izin alınmadıkça) | (© Pearson) | https://www.pearson.com/languages/why-pearson/the-global-scale-of-english/using-the-gse.html | Evet |
| 5c | **COCA sıklık verisi** (wordfrequency.info) | Satın alınmış veri. Tam sıklık ve sıra gösterilemez, en fazla 20 bant. Veri kurum dışına dağıtılamaz. | **Kullanılmaz** | — | https://www.wordfrequency.info/license.asp | Evet |
| 5d | **BNC** | Ticari ürün ve hizmette, adil kullanım dışında kullanım hakkı verilmiyor. | **Kullanılmaz** (ürün içinde) | — | http://www.natcorp.ox.ac.uk/docs/licence.html | Evet |
| 6 | **CEFR Companion Volume** (Avrupa Konseyi, 2020) | © Council of Europe. Tüm hakları saklı. Çoğaltma ve çeviri yazılı izne bağlı. | **Yalnızca referans.** Tanımlayıcılar kopyalanmaz ve çevrilmez. Kendi can-do hedeflerimiz bağımsız yazılır. | Evet (kaynakça) | rm.coe.int PDF (arşiv kopyası 2026-01-10) | Evet |
| 7a | **cefrpy** 1.0.3 | Kod MIT. Gömülü veri CEFR-J, Google Books Ngram (CC BY 3.0) ve lisansı belirsiz bir kelime listesinden türetilmiş. | **Yalnızca editör aracı** (iç kullanım). Uygulamaya gömülmez. | Evet (MIT + CEFR-J + Google Ngram) | https://pypi.org/project/cefrpy/ · https://github.com/Maximax67/Words-CEFR-Dataset | Kod evet. Veri kısmen. |
| 7b | **CVLA 3.2** | Kullanım koşulları sayfası yok. Kamuya açık API yok. Yalnızca makaleye atıf isteniyor. | **Yalnızca iç, elle kontrol.** Otomatik veya toplu kullanılmaz. | Evet (analizde kullanılırsa) | https://cvla.langedu.jp/ | Koşul metni bulunamadı. Doğrulanmadı. |
| 7c | **Text Inspector** (web ve API) | Yalnızca kendi verisini kendi iç işi için işleyen kullanıcıya lisans. Üçüncü kişi yararına kullanım yasak. API ücretli (yılda £360'tan başlıyor). EVP aracı Cambridge verisine dayanıyor. | **Kullanılmaz** (boru hattında). En fazla editörün elle yaptığı iç kontrol. | — | textinspector.com Şartlar ve Koşullar PDF'i, Aralık 2023 (arşiv kopyası) | Genel şartlar evet. API'ye özel şartlar doğrulanmadı. |
| 8a | **Vocabulary Size Test** (Nation) | "Araştırmada kullanım için izin gerekmez." Ticari kullanım hakkında hüküm yok. | **Kullanılmaz** (maddeleri). Kendi maddelerimiz yazılır. | — | https://www.wgtn.ac.nz/lals/resources/paul-nations-resources/vocabulary-tests | Evet (ticari hüküm yok) |
| 8b | **Updated VLT** (Webb, Sasao, Ballance 2017) | "Araştırmada kullanım için izin gerekmez." Ticari kullanım hakkında hüküm yok. | **Kullanılmaz** (maddeleri) | — | Aynı sayfa | Evet (ticari hüküm yok) |
| 9a | **py-fsrs** 6.3.2 | MIT | **Kullanılabilir.** Java'ya taşırken MIT bildirimi korunur. | MIT bildirimi | https://github.com/open-spaced-repetition/py-fsrs/blob/main/LICENSE | Evet |
| 9b | **Dart `fsrs`** 2.0.1 | MIT | **Kullanılabilir** | MIT bildirimi | https://pub.dev/packages/fsrs/license | Evet |
| 10 | **MEB İngilizce dersi öğretim programları** (TYMM, 2025) | Resmî program. Sitede "MEB © - Tüm Hakları Saklıdır." | **Yalnızca referans ve tema etiketi.** Program metni kopyalanmaz. | Kaynak gösterilir | https://mufredat.meb.gov.tr/ProgramDetay.aspx?PID=1903 · …PID=1906 | Evet (seviye ve tema eşlemesi) |

### "CEFR-J omurga" kararı değişiyor mu?

**Hayır. Karar güçlenerek korunur.** Ancak dört düzeltme var:

1. **Sürüm:** Omurga, OLP aynasındaki v1.5 yerine resmî siteden indirilen **v1.6** (2020-03-24) olmalı. v1.5'ten v1.6'ya geçişte *being*, *having* ve *tonne* eklendi; birkaç tekrar kaydı birleştirildi.
2. **Grammar Profile:** Resmî sayfa ticari kullanımı açıkça düzenlemiyor. "Kelime listesiyle aynı koşullar" ifadesi resmî kaynakla doğrulanamadı; yalnızca OLP aynası bunu söylüyor. Bu yüzden:
   - Dilbilgisi sırası referans alınır.
   - Ham veri uygulamaya gömülmez.
   - Tono Lab'dan yazılı teyit istenmesi önerilir. Bu iş kullanıcıya bırakıldı.
3. **EVP/EGP:** "Yalnızca referans" kararı **"kullanılmaz"** olarak sıkılaştırılmalı. Cambridge'in koşulları, EVP'den elde edilen bilginin bile kişisel ve ticari olmayan amaç dışında kullanılmasını yazılı izne bağlıyor. Editörün seviye kararında EVP'ye bakması da buna girer.
4. **EVP izi:** CEFR-J Wordlist, yapım aşamasında EVP ile karşılaştırılmış ve EVP'de olup listede olmayan kelimeler eklenmiş. Bu durumun hukuki bir sonucu olup olmadığı hukukçuya soruldu (§8 S3).

---

## 2. Kaynak başına bulgular

### 2.1 CEFR-J Wordlist [doğrulandı]

- **Birincil kaynak:**
  - https://www.cefr-j.org/download.html (Japonca)
  - https://www.cefr-j.org/download_eng.html (İngilizce)
  - İndirilen dosya: `CEFRJ_wordlist_ver1.6.zip` → `CEFR-J Wordlist Ver1.6.xlsx`. Dosyanın README sayfası aynı metni içeriyor.
- **Güncel sürüm:** **Version 1.6, "2020.3.24 更新版"** (2020-03-24 güncellemesi). Sayfada v1.5 → v1.6 değişiklik günlüğü var. Soru "1.5 mi, 1.6 mı?" idi; **cevap 1.6**.
  - OLP GitHub aynası hâlâ v1.5 (README: "Retrieved from http://www.cefr-j.org/download.html on 1/20/2020").
- **Kapsam:** A1–B2. 7.801 madde (sözcük türüne göre ayrı), 6.868 başsözcük.
  - A1: 1.166 madde
  - A2: 1.411 madde
  - B1: 2.445 madde
  - B2: 2.779 madde
- **Lisans cümleleri:**
  - İngilizce: "The copyright of this wordlist belongs to Tono Laboratory at TUFS, but the list can be used for both research and commercial purposes with a proper acknowledgement of the source."
  - Japonca: 「適切な引用を行っていただければ研究教育および商用においても無償で利用できる。」 Anlamı: uygun atıfla araştırma, eğitim ve ticari kullanımda ücretsiz kullanılabilir.
  - Türev liste: 「本語彙表を改変して別の語彙表を作ることはかまわないが、必ず本語彙表を適切に引用しなければならない。」 Anlamı: listeyi değiştirip başka liste yapmak serbesttir, ama mutlaka atıf yapılmalıdır.
  - Ücret durumu: 「商用利用に関しては、監修などを行う場合には別途相談の上、必要な経費を請求する。」 Anlamı: ticari kullanımda **denetim/danışmanlık gibi hizmet istenirse** ayrıca görüşülüp ücret alınır. Bizim durumumuzda (yalnızca listeyi kullanmak) ücret doğmaz. Bu hüküm, ekibin danışmanlık hizmetine ilişkindir.
  - Sorumluluk reddi: liste "olduğu gibi" verilir; hatalar olabilir.
- **Zorunlu atıf biçimi:** "The CEFR-J Wordlist Version 1.6. Compiled by Yukio Tono, Tokyo University of Foreign Studies. Retrieved from http:XXX on dd/mm/yy."
- **Ek bilgi (hukuk sorusu S3 için):** "The results were compared with the English Vocabulary Profile and non-overlapping words were added to the list as supplement." Japonca metin de aynı şeyi söylüyor: 「English Vocabulary Profile との整合表を作成して、その差分を取り込む」 (EVP ile karşılaştırma tablosu yapıp farkı listeye ekledik).
- **Ek bilgi:** Listedeki "CoreInventory1/2" ve "Threshold" sütunları, British Council/EAQUALS Core Inventory ve Threshold Level kategorilerine göre Tono Lab'ın kendi eklediği etiketlerdir. [Öneri] Bu sütunlar uygulamaya taşınmasın, yalnızca headword, pos ve CEFR sütunları kullanılsın. Core Inventory'nin kendi koşulları bu araştırmada doğrulanamadı.
- **Karar: Kullanılabilir (omurga).**
  - Atıf verilir.
  - Uygulamaya gömülerek dağıtılabilir; share-alike yükümlülüğü yoktur.
  - Türetilmiş HiVelzon listesinde de kaynak belirtilir.
- **Gömülü dağıtım:** Lisans, ticari dağıtımı ve türev listeyi açıkça serbest bırakıyor. Tek koşul atıf. Uygulamadaki "Lisanslar" ekranında ve veri dosyasının başlığında atıf yer alır.

### 2.2 CEFR-J Grammar Profile [kısmen doğrulandı]

- **Birincil kaynak:** https://www.cefr-j.org/download.html, "CEFR-J Grammar Profile" bölümü.
- **Sürümler:**
  - 2020 Şubat yayını: madde listesi ve regex dosyası `20200220`, öğretmen sürümü, Perl betikleri.
  - **2025 Şubat yayını:** `CEFRJGP_FULL_20250225.zip`. İçinde `CEFR-J Grammar Profile full 20250225.xlsx` var. Sayfaları: ITEM LIST, EFL FULL, JEFLL, NICT JLE, 教科書2018/2025, 教員版 (öğretmen sürümü).
  - İndirilen Excel dosyasında lisans veya telif metni **yok** (tüm metin hücreleri tarandı).
- **Resmî sayfada lisans yerine yalnızca şunlar var:**
  - Atıf biçimi: "Ishii, Y. (2025). CEFR-J Grammar Profile 2025. [Data set]." Japonca açıklama: 「以下はAPA7の形式であるが、適宜変更して構わない」 (APA7 biçimidir, uygun şekilde değiştirilebilir).
  - Sorumluluk reddi: 「CEFR-J プロジェクトは提供データに誤りがないことを保証せず、これらのデータの利用に起因するいかなる損害や研究成果・製品・サービスへの批判に対しても一切責任を負わない。」 Anlamı: proje, verinin hatasız olduğunu garanti etmez; veriye dayanan **ürün ve hizmetlere** yöneltilen eleştirilerden sorumlu değildir. Bu ifade ticari kullanımı ima ediyor, ama **açık bir izin değil**.
- **İkincil kaynak (OLP aynası):** "CEFR-J vocabulary and grammar profile datasets can be used for research and commercial purposes with no charge, provided that you cite the dataset properly. The copyright belongs to Tono Laboratory at TUFS".
  - Bu metin 2018 sürümü (`20180315`) için yazılmış.
  - OLP, veriyi "kindly provided by the CEFR-J project" diye tanımlıyor.
  - Ancak resmî sitede aynı cümle Grammar Profile için **yok**.
- **Karar: Kullanılabilir, koşullu.**
  - Dilbilgisi maddelerinin seviye sırası, HiVelzon'un kendi dilbilgisi müfredatına **referans** olarak alınır.
  - "Present perfect B1" gibi madde adları dilbilimsel kategorilerdir. Açıklamalar ve örnek cümleler bizim yazdıklarımız olur.
  - Excel verisi (sıklık tabloları, regex'ler, öğretmen sürümü) uygulamaya **gömülmez**.
  - Tono Lab'dan ticari kullanım için yazılı teyit alınması önerilir. E-posta gönderilmedi; iş kullanıcıya bırakıldı.
- **Gömülü dağıtım:** Açık izin yok [doğrulanmadı]. Teyit gelene kadar ham veri dağıtılmaz.

### 2.3 Octanove Vocabulary Profile C1/C2 [lisans doğrulandı]

- **Birincil kaynak:** https://github.com/openlanguageprofiles/olp-en-cefrj, README "Terms of use" bölümü.
  - Open Language Profiles, Octanove Labs'ın yürüttüğü projedir. octanove.com ana sayfası "Open Language Profiles"a bağlantı veriyor.
- **Dosya:** `octanove-vocabulary-profile-c1c2-1.0.csv`, v1.0, yaklaşık 2.136 satır. Sütunlar: headword, pos, CEFR, notes.
- **Lisans cümlesi:** "The Octanove Vocabulary Profile for C1/C2 levels can be used under a Creative Commons Attribution-ShareAlike 4.0 International License."
- **Doğrulanamayanlar:**
  - Listenin hangi kaynak ve yöntemle üretildiği (örneğin EVP veya Oxford ile karşılaştırma yapılıp yapılmadığı) README'de yazmıyor [doğrulanmadı].
  - Octanove sitesinde ayrı bir lisans sayfası bulunamadı.
- **CC BY-SA 4.0'ın ilgili maddeleri** (https://creativecommons.org/licenses/by-sa/4.0/legalcode.en):
  - **Share-alike, §3(b):** "if You Share Adapted Material You produce … The Adapter's License You apply must be a Creative Commons license with the same License Elements, this version or later, or a BY-SA Compatible License."
  - **Veri tabanı hakkı, §4:** "if You include all or a substantial portion of the database contents in a database in which You have Sui Generis Database Rights, then the database in which You have Sui Generis Database Rights (but not its individual contents) is Adapted Material".
  - **Ek kısıtlama yasağı, §2(a)(5)(C):** "You may not offer or impose any additional or different terms or conditions on, or apply any Effective Technological Measures to, the Licensed Material if doing so restricts exercise of the Licensed Rights by any recipient".
- **Karar: Kullanılabilir (C1 omurgası).** Share-alike yükümlülüğü vardır.
- **Gömülü dağıtım:**
  - Listenin tamamı veya önemli bir kısmı uygulamaya ya da HiVelzon'un kelime veri tabanına girerse, **o veri tabanı CC BY-SA 4.0 ile paylaşılmak zorunda kalabilir**. Bu yükümlülük veri tabanının tamamını kapsar; tek tek kayıtları kapsamaz.
  - **[Öneri]** CC BY-SA kaynaklı kelime verisi (Octanove, NGSL/NAWL) ayrı bir veri seti olarak tutulsun. Kaynak sütunu (`source=octanove|ngsl|cefrj`) olsun. Bu veri seti açıkça CC BY-SA 4.0 ile etiketlensin.
  - Böylece CEFR-J verisi ve HiVelzon'un özgün içerikleri (hikâyeler, sorular, görseller) share-alike kapsamına çekilmez.
  - Uygulama kodunun ve özgün içeriğin bundan etkilenip etkilenmeyeceği hukukçuya sorulur (§8 S2).

### 2.4 NGSL 1.2 ve NAWL 1.2 [doğrulandı]

- **Birincil kaynaklar:**
  - https://www.newgeneralservicelist.com/new-general-service-list
  - https://www.newgeneralservicelist.com/new-academic-word-list
  - https://www.newgeneralservicelist.com/faqs-4
- **Sürüm:**
  - NGSL 1.2: "released in April of 2023". 2.809 kelime. Sıklık verisi yalnızca "NGSL 1.2 with basic statistics" dosyasında var. Günleri, ayları ve sayıları içeren 52 ek kelime ayrı bir dosyada.
  - NAWL 1.2: 957 kelime.
- **Lisans cümleleri:**
  - NGSL: "New General Service List by Browne, C., Culligan, B., and Phillips, J. is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License. Permissions beyond the scope of this license may be available at http://www.charlie-browne.com"
  - NAWL: "New Academic Word List by Browne, C., Culligan, B., and Phillips, J. is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License."
  - Liste sayfası: "All lists are released under Creative Commons and may be used commercially."
- **Atıf** (sitenin önerdiği biçim): "Browne, C., Culligan, B. (2013). The New General Service List. Retrieved from https://www.newgeneralservicelist.com". Lisans satırında üç yazar var (Browne, Culligan, Phillips). Atıfta üçü de yazılmalı.
- **Uyarı:** SSS sayfasına göre `newgeneralservicelist.org` alan adı artık projeye ait değil ve kumar içeriğine yönlendiriyor. Yalnızca `.com` kullanılmalı.
- **Ek bilgi:** Aynı sitede 13+ kitle için uygun olmayabilecek listeler de var (ör. Bible English List). Konu seçiminde değil, yalnızca sıklık bandında NGSL/NAWL kullanılmalı.
- **Karar: Kullanılabilir (tamamlayıcı sıklık bandı).** Atıf ve share-alike yükümlülükleri Octanove ile aynıdır (§2.3).
- **Gömülü dağıtım:** §2.3 ile aynı. [Öneri] Uygulamada yalnızca kelimenin bandı gösterilsin (ör. "NGSL ilk 1000"). Liste toptan gömülmesin. Gömülürse ayrı bir CC BY-SA veri seti olarak dağıtılsın.

### 2.5 English Vocabulary Profile ve English Grammar Profile (Cambridge) [doğrulandı]

- **Birincil kaynak:** https://www.englishprofile.org/.
  - Site JavaScript ile yükleniyor. Koşullar, sitenin kendi yüklediği sayfa içeriğinden okundu. İlgili bölümler: "English Vocabulary Profile Website Terms of Use", EGP Terms of Use, Contact us/Licences.
  - Altbilgide: "Copyright 2026 Cambridge University Press & Assessment", genel şartlar için https://www.cambridge.org/legal/website-terms-of-use.
- **Ana cümleler (EVP Terms of Use):**
  - "material contained in the EVP Site may be downloaded, viewed and printed for personal non commercial research and teaching purposes or internal circulation within your organisation only"
  - "not to use any extract from the EVP or research gained from access to the EVP in any way other than for personal non-commercial research and teaching purposes … without the prior written consent of Cambridge University Press"
  - "further use of research gained from EVP may be made (including … in commercial publications) subject to written consent being obtained in advance … 'commercial publications' shall include … any software programmes based on the EVP data"
  - EVP sayfası: "Terms of Use for this resource do not allow other organisations to promote commercial materials as 'English Profile informed' or allow the use of the English Vocabulary Profile for commercial purposes"
  - **Licences bölümü:** "Please note that we do not license out the English Vocabulary Profile data or the English Grammar Profile data for commercial purposes."
  - EGP Terms of Use aynı hükümleri EGP için tekrarlıyor ("not to use any extract from the EGP or research gained from access to the EGP …").
  - Hukuk ve yargı yeri: İngiliz hukuku ve İngiliz mahkemeleri.
  - İletişim: legalservices@cambridge.org (koşullar için), englishprofile@cambridge.org (genel).
- **Zorunlu atıf (izinli kullanımda):** "This publication/presentation/research report has made use of the English Vocabulary Profile. This resource is based on extensive research using the Cambridge Learner Corpus and is part of the English Profile programme…"
- **Karar: Kullanılmaz.**
  - Ürüne veri girmez.
  - "EVP'ye göre B1" gibi ifadeler kullanılmaz; "English Profile informed" ifadesi de kullanılmaz.
  - Editörlerin seviye kararlarında EVP'ye danışması da koşullara göre "research gained from access to the EVP" kapsamına girebilir. Bu yüzden içerik üretim sürecinde EVP **kaynak olarak kullanılmaz**.
  - Cambridge'e sorulacak soru için §6'daki taslak hazırlandı. Ancak "we do not license out … for commercial purposes" cümlesi, olumlu cevap olasılığının düşük olduğunu gösteriyor.
- **Gömülü dağıtım:** Yasak.

### 2.6 Diğer referans listeler (önceki bulguların teyidi)

**Oxford 3000/5000 [doğrulandı]**
- **Kaynak:** https://www.oxfordlearnersdictionaries.com/terms-and-conditions
- **Alıntı:** "You agree that we only make available the Oxford Learner's Dictionaries website and/or the Products for domestic and private use. You agree not to use the Products for any commercial, business or re-sale purposes".
  - Liste sayfasında (https://www.oxfordlearnersdictionaries.com/about/wordlists/oxford3000-5000) ayrı bir lisans hükmü yok.
- OUP'nin listeyi uygulama geliştiricilere lisansladığı bir örnek var (Cookie Langs, 2022, licenseglobal.com haberi). Demek ki ticari kullanım ancak lisansla mümkün.
- **Karar: Kullanılmaz.**

**Pearson GSE [doğrulandı]**
- **Kaynak:** https://www.pearson.com/languages/why-pearson/the-global-scale-of-english/using-the-gse.html
- **Alıntılar:**
  - "If you are … looking to use the GSE in a non-commercial context … we ask that you follow these guidelines."
  - "For anyone looking to use the GSE for commercial purposes, please contact us first."
  - Atıf biçimi: "The Global Scale of English and its components © Pearson."
  - Altbilgi: "All rights reserved, including those for text and data mining and training of artificial intelligence".
- **Karar: Kullanılmaz** (izin alınmadıkça). Metin ve veri madenciliği ile yapay zekâ eğitimi açıkça hak saklı tutuluyor. Yani GSE içeriği yapay zekâ istemlerine de konmaz.

**COCA sıklık verisi [doğrulandı]**
- **Kaynak:** https://www.wordfrequency.info/license.asp
- **Alıntılar:**
  - "end users cannot see the exact frequency of a word … or the exact rank order … But you can group words into frequency bands … the number of frequency bands must be limited to 20 or less."
  - "In no case can the word frequency data be distributed beyond the university or company that purchased the data."
  - Her satılan kopyaya parmak izi eklendiği ve ihlalde avukatların devreye gireceği yazıyor.
- **Karar: Kullanılmaz.** NGSL ve CEFR-J yeterli.

**BNC [doğrulandı]**
- **Kaynak:** http://www.natcorp.ox.ac.uk/docs/licence.html
- **Alıntı:** "(g) The BNC Consortium does not grant to the Licensee any rights whatsover to reproduce the BNC Texts or use all or any part of the BNC Texts in commercial products or services in any way other than would be permitted under the fair dealings provision of copyright law."
- **Karar: Kullanılmaz** (ürün içinde).

### 2.7 CEFR Companion Volume (Avrupa Konseyi, 2020) [doğrulandı]

- **Birincil kaynak:** https://rm.coe.int/common-european-framework-of-reference-for-languages-learning-teaching/16809ea0d4
  - Doğrudan erişim Cloudflare tarafından engellendi.
  - PDF, Internet Archive kopyasından okundu (2026-01-10, `web.archive.org/web/20260110214729id_/…`).
  - PDF meta verisi: oluşturma 2020-04-29, son değişiklik 2020-11-27.
- **Künye sayfası:** "All rights reserved. No part of this publication may be translated, reproduced or transmitted, in any form or by any means, electronic (CD-Rom, internet, etc.) or mechanical … without prior permission in writing from the Directorate of Communication (F-67075 Strasbourg Cedex or publishing@coe.int)." ve "© Council of Europe, April 2020".
- **Zorunlu atıf:** "Council of Europe (2020), Common European Framework of Reference for Languages: Learning, teaching, assessment – Companion volume, Council of Europe Publishing, Strasbourg, available at www.coe.int/lang-cefr."
- **Doğrulanamayanlar:**
  - Bir arama sonucuna göre Fransızca baskıda "500 kelimeye kadar alıntı, ticari amaç dışında serbest" ibaresi varmış. Bu, birincil kaynaktan okunmadı [doğrulanmadı]. İngilizce baskının künyesinde böyle bir istisna **yok**.
  - Avrupa Konseyi'nin genel telif sayfası (https://www.coe.int/en/web/portal/copyright-licensing-permissions) 403 verdi [doğrulanmadı].
- **Karar: Yalnızca referans.**
  - Tanımlayıcılar uygulamaya aynen konmaz, Türkçeye çevrilmez, yakın biçimde başka sözcüklerle de yazılmaz. Çeviri de açıkça izne bağlı.
  - HiVelzon'un can-do hedefleri, ünite içeriğinden **bağımsız** olarak yazılır. "CEFR seviyesi" ifadesi kullanılabilir; seviye adları (A1…C2) genel bir terimdir.
  - Kendi cümlemizle yazmanın yeterli olup olmadığı hukukçuya sorulur (§8 S5). Kesin görüş bu rapor kapsamında verilmez.
- **Gömülü dağıtım:** Tanımlayıcı metni dağıtılmaz.
- **Ek bulgu (CEFR-J can-do):** CEFR-J'nin kendi can-do tanımlayıcıları, indirme sırasında bir kullanım sözleşmesinin onaylanmasını gerektiriyor ("You can download the descriptors only if you agree to the license agreement"). Sözleşme metni kayıt formunun arkasında olduğu için okunmadı [doğrulanmadı].

### 2.8 Yardımcı araçlar

**cefrpy [kod doğrulandı, veri kısmen]**
- **Birincil kaynaklar:**
  - https://pypi.org/project/cefrpy/ (sürüm 1.0.3)
  - https://github.com/Maximax67/cefrpy (LICENSE: "MIT License, Copyright (c) 2024 Bielikov Maksym")
- **Verinin kaynağı (README "Acknowledgments"):** "I used them to create my initial SQLite version Words-CEFR-Dataset: Spacy, CEFR-J, LemmInflect, The Google Books Ngram Viewer (used 1-grams dataset, version 20200217), List of pos tags form Penn Treebank Project". Ayrıca "valid English words list" için infochimps kelime listesi (arşiv bağlantısı) kullanılmış.
- **Words-CEFR-Dataset** (https://github.com/Maximax67/Words-CEFR-Dataset):
  - MIT lisanslı.
  - Seviyeler hesaplanmış: CEFR-J seviyeleri ile Google 1-gram sıklıkları birleştirilip interpolasyonla tüm kelimelere seviye atanmış.
  - README, Octanove'un CC BY-SA olduğunu not ediyor ve onu **kullanmadığını** belirtiyor (gelecek iş olarak listelemiş).
- **Google Books Ngram verisi:** https://storage.googleapis.com/books/ngrams/books/datasetsv3.html → "This compilation is licensed under a Creative Commons Attribution 3.0 Unported License".
- **infochimps kelime listesinin lisansı:** [doğrulanmadı].
- **Karar: Yalnızca editör aracı** (iç ölçüm; "bu metinde seviye üstü kelime oranı" kontrolü).
  - Veritabanı uygulamaya gömülmez.
  - Ürettiği C1/C2 seviyeleri resmî bir listeye dayanmıyor; tahmindir. Bu yüzden omurga yerine konmaz.
- **Gömülü dağıtım:** Kod için MIT bildirimi yeterli. Veri için CEFR-J atfı ve Google Ngram CC BY 3.0 atfı gerekir. infochimps belirsiz olduğu için **gömülmez**.

**CVLA (CEFR-based Vocabulary Level Analyzer) [koşul metni bulunamadı]**
- **Birincil kaynak:** https://cvla.langedu.jp/ (CVLA 3.2, 2026-08-21).
  - Eski adres http://dd.kyushu-u.ac.jp/~uchida/cvla.html aynı sayfaya gidiyor.
- **Sayfada bulunanlar:**
  - Kullanım koşulları veya lisans sayfası yok. `/terms` ve `/about` adresleri 404 veriyor. Kamuya açık bir API belgesi yok.
  - Web aracı tek metinde 10–1000 kelime ve dosya modunda en fazla 30 dosya (her biri 10 KB) kabul ediyor.
  - Masaüstü sürüm sayfası: "Please use this software at your own risk."
  - cefr-j.org: 「分析にCVLAを使用した場合は、下記の論文を引用し、バージョンを明示していただきたい」 (Analizde CVLA kullanılırsa makaleye atıf yapılmalı ve sürüm belirtilmeli). Sorumluluk reddi: sonuçlar tahmindir; kısa metinlerde sapma büyüktür, yaklaşık 300 kelimeden uzun metinler daha kararlıdır.
- **Karar: Yalnızca iç, elle kontrol.**
  - Editör, hikâye taslağının seviyesini tek tek kontrol etmek için kullanabilir.
  - Otomatik veya toplu çağrı (betikle istek gönderme) yapılmaz. İzin metni olmadığı için bu konu [doğrulanmadı].
  - Sonuç uygulamada "CVLA'ya göre B1" diye gösterilmez.
- **Gömülü dağıtım:** Söz konusu değil.

**Text Inspector (web ve API) [genel şartlar doğrulandı, API'ye özel şartlar doğrulanmadı]**
- **Birincil kaynak:** textinspector.com bu ortamdan 403 verdi. Okunanlar:
  - Şartlar sayfasının arşiv kopyası (2026-04-28).
  - O sayfanın bağladığı "TextInspector.com-Terms-of-Use-December-2023.pdf" (arşiv kopyası, "Last updated 11/12/2023").
  - API sayfası (arşiv, 2026-06-12).
- **Alıntılar:**
  - 5.3(b): "only use the Licensed Software for processing your own data for your own internal business and/or research purposes only. You shall not permit any third party to use the Licensed Software nor use the Licensed Software on behalf of or for the benefit of any third party in any way whatsoever"
  - 5.3(e): "not incorporate, copy, duplicate, modify, distribute or otherwise use or share any content on our Website or in the Licensed Software with any other person … except for the purpose of using such content to include in your reports to your own clients"
  - Özet şartlar: "The tools in Text Inspector are free to use, except for the EVP tool."
  - API sayfası: "You will then have 30 days to test the API free of charge. After this our charges start from £360 per year for access to the API."
- **Karar: Kullanılmaz** (içerik boru hattında ve uygulamada).
  - Çıktılarının uygulamada gösterilmesi 5.3(e) ile çelişir.
  - EVP ve BNC/COCA tabanlı ölçümler zaten ticari kullanıma kapalı kaynaklara dayanıyor.
  - API'ye özel ek şartlar (API Terms) okunamadı [doğrulanmadı].

### 2.9 Vocabulary Size Test ve Updated VLT [doğrulandı: ticari hüküm yok]

- **Birincil kaynak:** https://www.wgtn.ac.nz/lals/resources/paul-nations-resources/vocabulary-tests ve VST bilgi PDF'i (`Vocabulary-Size-Test-information-and-specifications.pdf`).
- **Alıntılar:**
  - VST PDF'i: "Permission is not required to use these tests in research, although acknowledgement in any thesis or publication is appreciated."
  - UVLT: "Permission is not required to use the Updated Vocabulary Levels Test in research, although acknowledgement in any thesis or publication is appreciated. The reference is Webb, S., Sasao, Y., & Ballance, O. (2017). The updated vocabulary levels test… ITL, 168(1), 33–69."
  - Üst sayfa (https://www.wgtn.ac.nz/lals/resources/paul-nations-resources): "These resources may be used under the terms of the Creative Commons Attribution-ShareAlike 4.0 license or the GNU General Public License Version 2 or 3, as appropriate to the resource."
- **Yorum:**
  - Testlere özgü izin yalnızca **araştırma** için verilmiş.
  - Üst sayfadaki genel CC BY-SA/GPL ifadesi "as appropriate to the resource" diyor ve **hangi kaynağa hangi lisansın uygulandığını belirtmiyor**.
  - UVLT'nin yazarları Nation değil, Webb, Sasao ve Ballance. Makale ITL dergisinde (John Benjamins) yayımlanmış.
  - Ticari kullanım için açık bir hüküm bulunamadı.
- **Karar: Kullanılmaz** (maddeler). `ICERIK-MIMARISI.md` §7.2 kararı aynen geçerli: aynı yapıda, NGSL/CEFR-J bantlarına göre **kendi maddelerimiz** yazılır.
  - Test biçimi (çoktan seçmeli; bant başına örneklem) bir yöntemdir. Yöntemin kendisi lisansa konu olmaz ama bu da hukukçuya teyit ettirilir (§8 S7).
- **Ek bulgu:** CEFR-J CAN-DO Test örnekleri (cefr-j.org) için şu yazıyor: 「目的に応じてそのままでまたは適宜改変しての利用を許可する」 ve 「教育・研究・商用を問わず、必ず下記の引用を行うこと」. Anlamı: amaca göre olduğu gibi veya değiştirilerek kullanılabilir; eğitim, araştırma veya ticari kullanımda mutlaka atıf yapılmalı.
  - Bu, yerleştirme testi için kullanılabilir bir kaynak olabilir.
  - Ancak aynı yerde 「教育・研究用に無償公開する」 (eğitim ve araştırma için ücretsiz yayımlanmıştır) ifadesi de var. İki ifade birlikte belirsizlik yaratıyor (§8 S8).

### 2.10 FSRS [doğrulandı]

- **py-fsrs:**
  - https://github.com/open-spaced-repetition/py-fsrs/blob/main/LICENSE: "MIT License, Copyright (c) 2022 Open Spaced Repetition".
  - PyPI sürümü 6.3.2. Lisans alanında aynı MIT metni var.
- **Dart `fsrs`:**
  - https://pub.dev/packages/fsrs/license: "MIT License, Copyright (c) 2022 Open Spaced Repetition".
  - Sürüm 2.0.1 (2025-06-20). Depo: https://github.com/open-spaced-repetition/dart-fsrs.
- **MIT koşulu:** "The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software."
- **Taşırken (Java) yükümlülük:**
  - Formüller ve varsayılan parametreler py-fsrs'ten alınıp Java'ya yazılırsa, ilgili Java dosyalarının başına kaynak belirtilir: "Ported from py-fsrs (https://github.com/open-spaced-repetition/py-fsrs), Copyright (c) 2022 Open Spaced Repetition, MIT License". Repoya `THIRD_PARTY_NOTICES` dosyası konur ve MIT metni eklenir.
  - Dart paketi uygulamaya gömülürse, MIT metni "Lisanslar" ekranında yer alır. Flutter'ın `LicenseRegistry`/`showLicensePage` mekanizması paket lisanslarını otomatik toplar.
  - Algoritmanın kendisi (matematiksel model) ile kodun ifadesi arasındaki ayrım hukuk sorusudur. Ancak MIT bildirimini koymak her iki durumda da güvenli yoldur.
- **Karar: Kullanılabilir.**

### 2.11 MEB İngilizce dersi öğretim programları (Türkiye Yüzyılı Maarif Modeli, 2025) [doğrulandı]

- **Birincil kaynaklar:** Hepsi https://mufredat.meb.gov.tr/Programlar.aspx altında listeleniyor.
  - **[TYMM] İngilizce Dersi (2-8) (2025):** https://mufredat.meb.gov.tr/ProgramDetay.aspx?PID=1903 → `Dosyalar/202591011405337-26-08-ekli-english-regular.pdf` (1.114 sayfa, PDF oluşturma 2025-08-26).
  - **[TYMM] Ortaöğretim İngilizce Dersi (9-12) (2025):** …PID=1906 → `Dosyalar/202591214813382-ingilizce912.pdf` (741 sayfa, 2025-09-08).
  - Diğer programlar: Hazırlık 9-12 (PID=1905) ve Çoklu Yabancı Dil Eğitim Modeli İngilizce 5-8 (PID=1904).
  - TYMM portalı: https://tymm.meb.gov.tr/ogretim-programlari.
- **Seviye eşlemesi** (2-8 programı, "Alignment of the English Language Curriculum with the CEFR" bölümü):
  - "CEFR level A1 has been adapted as A1.1, A1.2, A1.3 in Years 2, 3 and 4 for Primary Education."
  - "CEFR level A2 has been adapted as A2.1, A2.2, A2.3, A2.4 in Years 5, 6, 7, and 8 for Lower Secondary Education."
  - "CEFR Level B1 has been adapted as B1.1, B1.2, B1.3, B1.4 in Years 9, 10, 11, and 12 for Upper Secondary Education."
  - Ek: Çoklu Yabancı Dil Modeli 5. sınıfta A2+B1, 6–8. sınıflarda B2.1–B2.3. Hazırlık programı A2+/B1. Hazırlık sonrası 9–12. sınıflar B2.1–B2.4.
  - 9-12 programı aynı eşlemeyi doğruluyor: "REGULAR UPPER-SECONDARY-YEAR 9 (LEVEL: B1.1)" … "YEAR 12 (LEVEL: B1.4)".
  - **Sonuç:** İlkokul A1, ortaokul A2, lise B1 eşlemesi resmî metinle **doğrulandı**. 13+ kullanıcının kabaca 7–12. sınıf, yani A2.3–B1.4 aralığında olduğu yorumu da tutarlı.
- **Temalar:**
  - Model tanımı: "The thematic sequence of the English Language Curriculum is based on eight main themes covering eight major concepts of life in all years and at all levels."
  - **Düzeltme:** 2–4. sınıf (A1) tablolarında **6 tema** var. 5–8. sınıflarda **8 tema** var.
  - 5. sınıfın 8 teması:
    1. School Life
    2. Classroom Life
    3. Personal Life
    4. Family Life
    5. Life in the Neighbourhood & City
    6. Life in the World
    7. Life in Nature
    8. Life in the Universe & Future
  - 8. sınıfta adlar genişliyor: "School Life & Education", "Classroom Life & Learning", "Personal Life & Well-Being", "Family Life & Home", "Life in the Neighbourhood & City & Social Life", "Life in the World and Culture", "Life in Nature & Global Problems", "Life in the Universe & Future".
  - 9–12'de de temalar aynı 8 ana kavram etrafında, sınıfa göre farklı adlarla sürüyor.
  - Ayrıca: "There will be two or four revision themes … before the first theme".
- **Telif:** mufredat.meb.gov.tr altbilgisi "MEB © - Tüm Hakları Saklıdır."
- **Karar: Yalnızca referans ve tema etiketi.**
  - Ünitelere "MEB 8. sınıf · Life in Nature & Global Problems" gibi etiket eklenebilir (K-20).
  - Program metni, kazanım cümleleri ve kelime kümeleri kopyalanmaz.
  - Resmî programların kamuya açık metinlerinin yeniden kullanımına ilişkin yasal durum hukukçuya sorulur (§8 S9).
  - Etiketlerde MEB logosu veya "MEB onaylı" ifadesi kullanılmaz.

---

## 3. Uygulama içi veri politikası (öneri)

Bu bölüm bir hukuk görüşü değildir; lisans metinlerinden çıkan teknik bir öneridir.

| Veri seti | Nerede tutulur | Uygulamaya gömülür mü? | Etiket |
|---|---|---|---|
| CEFR-J Wordlist v1.6 (headword, pos, CEFR) | Sunucu ve istemci | Evet | "CEFR-J Wordlist v1.6 (Tono Lab, TUFS)" |
| CEFR-J Grammar Profile | Yalnızca editör referansı | Hayır (teyide kadar) | — |
| Octanove C1/C2, NGSL 1.2, NAWL 1.2 | Ayrı veri seti (`lexicon_ccbysa`) | Gerekirse, **ayrı dosya** olarak ve CC BY-SA 4.0 bildirimiyle | CC BY-SA 4.0 + atıf |
| HiVelzon özgün içerikleri (hikâye, soru, görsel, ses) | Ayrı | Evet | © Velzon |
| EVP/EGP, Oxford, GSE, COCA, BNC | — | Hayır | — |

- Kelime kaydı başına `source` ve `license` alanları tutulsun. Bu, `ICERIK-MIMARISI.md` §12'deki `content_sources` tablosuyla uyumludur.
- Uygulama, kelimenin seviyesini "CEFR-J: B1" biçiminde gösterebilir. Octanove kaynaklıysa "Octanove: C1" yazılır.
- Kendi düzeltmemiz varsa "HiVelzon editörü" diye işaretlenir.

---

## 4. "Lisanslar / Hakkında" ekranı için atıf metinleri (taslak)

> **Kaynaklar ve lisanslar**
>
> HiVelzon'un kelime seviyeleri aşağıdaki açık kaynaklara dayanır. Teşekkür ederiz.
>
> **CEFR-J Wordlist Version 1.6.** Compiled by Yukio Tono, Tokyo University of Foreign Studies. Retrieved from https://www.cefr-j.org/download.html on 11/10/2026. © Tono Laboratory, TUFS. Uygun atıfla araştırma ve ticari kullanıma açıktır. HiVelzon bu listeyi temel alıp değiştirmiştir.
>
> **CEFR-J Grammar Profile** — Ishii, Y. (2025). *CEFR-J Grammar Profile 2025* [Data set]. https://www.cefr-j.org/download.html. (Yalnızca dilbilgisi sırası için referans alınmıştır.)
>
> **Octanove Vocabulary Profile C1/C2 v1.0** — Octanove Labs, Open Language Profiles. https://github.com/openlanguageprofiles/olp-en-cefrj. Lisans: Creative Commons Attribution-ShareAlike 4.0 International (https://creativecommons.org/licenses/by-sa/4.0/). HiVelzon'daki C1 kelime verisi bu listeden uyarlanmıştır ve aynı lisansla paylaşılır.
>
> **New General Service List 1.2 / New Academic Word List 1.2** — Browne, C., Culligan, B., & Phillips, J. https://www.newgeneralservicelist.com. Lisans: CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/). Değişiklik yapılmışsa: "Uyarlanmıştır."
>
> **FSRS (Free Spaced Repetition Scheduler)** — py-fsrs ve dart `fsrs`, Copyright (c) 2022 Open Spaced Repetition. MIT License. [Tam MIT metni]
>
> **Seviye sistemi** — Seviye adları (A1–C1), Avrupa Konseyi'nin *Common European Framework of Reference for Languages* (CEFR) çerçevesine göndermedir. Council of Europe (2020), *CEFR – Companion volume*, Council of Europe Publishing, Strasbourg, www.coe.int/lang-cefr. HiVelzon'un "yapabilirim" hedefleri HiVelzon tarafından yazılmıştır; Avrupa Konseyi tarafından onaylanmış değildir.
>
> **Okul programı etiketleri** — Ünite etiketleri, T.C. Millî Eğitim Bakanlığı İngilizce Dersi Öğretim Programları (Türkiye Yüzyılı Maarif Modeli, 2025) tema adlarına göndermedir. HiVelzon, MEB ile bağlantılı değildir.
>
> **Üçüncü taraf yazılım lisansları** — [Flutter `showLicensePage` otomatik listesi]

Notlar:
- Tarih biçimi CEFR-J'nin istediği "dd/mm/yy" olmalı. Sürüm indirildiğinde gerçek indirme tarihi yazılır.
- cefrpy, CVLA ve Text Inspector uygulamada kullanılmadığı için bu listeye girmez. cefrpy yalnızca iç araçta kullanılırsa, iç aracın README'sine MIT, CEFR-J ve Google Ngram (CC BY 3.0) atıfları yazılır.

---

## 5. Kaynak kayıt satırları (`content_sources` için hazır)

| source_id | title | license | commercial | derivatives | attribution | checked_at | approved_by |
|---|---|---|---|---|---|---|---|
| cefrj-wl-1.6 | CEFR-J Wordlist v1.6 | Tono Lab terms (atıfla serbest) | evet | evet (atıfla) | §4 metni | 2026-10-11 | [kullanıcı] |
| cefrj-gp-2025 | CEFR-J Grammar Profile 20250225 | açık lisans yok (yalnızca atıf/sorumluluk reddi) | belirsiz | belirsiz | §4 metni | 2026-10-11 | [kullanıcı] |
| octanove-c1c2-1.0 | Octanove VP C1/C2 | CC BY-SA 4.0 | evet | evet (SA) | §4 metni | 2026-10-11 | [kullanıcı] |
| ngsl-1.2 / nawl-1.2 | NGSL 1.2 / NAWL 1.2 | CC BY-SA 4.0 | evet | evet (SA) | §4 metni | 2026-10-11 | [kullanıcı] |
| py-fsrs / dart-fsrs | FSRS | MIT | evet | evet | MIT bildirimi | 2026-10-11 | [kullanıcı] |

---

## 6. Cambridge'e gönderilecek e-posta (TASLAK — GÖNDERİLMEDİ)

> Alıcı önerisi: englishprofile@cambridge.org. Koşullar sorusu için bilgi: legalservices@cambridge.org (EVP Terms of Use'da "Contact us" adresi).
> Göndermeden önce şirket bilgilerini ve imzayı kullanıcı kontrol etmelidir.

```
Subject: Permission enquiry – use of English Vocabulary Profile / English Grammar Profile in a free English-learning app

Dear English Profile team,

I am writing on behalf of Velzon Bilişim Teknolojileri Ltd. Şti., a software company
based in Türkiye. We are developing HiVelzon, a mobile application (iOS and Android)
that teaches English to Turkish-speaking learners from A1 to C1. The app is free of
charge for users and contains no advertising or subscriptions; however, as it is
published by a company, we treat it as a commercial use.

We have read the English Vocabulary Profile and English Grammar Profile Terms of Use,
including the statement that "we do not license out the English Vocabulary Profile data
or the English Grammar Profile data for commercial purposes". Before finalising our
curriculum, we would like to confirm our understanding and ask whether any of the
following would be possible with Cambridge University Press & Assessment's written
consent:

1. Consulting the EVP/EGP websites internally (by our editors) as one of several
   references when deciding the CEFR level of a word or grammar point, without copying
   EVP/EGP entries, definitions, examples or level data into our app or database.
2. Displaying, for a word in our app, a CEFR level that coincides with the EVP level,
   where that level was assigned by our editors using other openly licensed sources.
3. Any licensing arrangement (paid or unpaid) that would allow limited use of EVP/EGP
   level data in a free educational app, and, if so, the terms and the right contact.

If none of these uses is permitted, we will not use EVP/EGP in any part of our content
production and will rely only on openly licensed resources. We would be grateful for a
written answer either way so that we can document it in our rights records.

Thank you for your time and for making these resources available to teachers and
researchers.

Kind regards,

[Name Surname]
[Title]
Velzon Bilişim Teknolojileri Ltd. Şti.
[Address] · [Phone] · [E-mail]
```

---

## 7. Diğer önerilen yazılı teyitler (taslak yazılmadı, gönderilmedi)

- **Tono Lab (CEFR-J):**
  - Grammar Profile 2025 verisinin ticari bir uygulamada kullanım koşulları.
  - Wordlist v1.6'nın uygulamaya gömülerek dağıtımında atıf biçimi yeterli mi?
  - İletişim formu: http://www.cefr-j.org/mail/contact/
- **Satoru Uchida (CVLA):**
  - Ticari bir ürünün editoryal sürecinde CVLA'nın kullanım koşulları.
  - Otomatik veya toplu kullanım izni.
- **Nation / Webb (VST, UVLT):**
  - Yalnızca maddeleri kullanmak istenirse gerekir. Mevcut karar "kullanılmaz" olduğu için şimdilik gereksiz.

---

## 8. Hukukçuya sorulacak sorular

Bunlar hukuki görüş gerektiren sorulardır; rapor bu sorulara cevap vermez.

1. **S1 — Veri tabanı hakkı ve seviye bilgisi:** Referans listelerdeki (EVP, Oxford, GSE gibi) kelime-seviye eşleşmelerini sistematik olarak, kelime kelime karşılaştırıp kendi listemize aktarmak:
   - FSEK md. 39'daki veri tabanı hakkına (sui generis) takılır mı?
   - AB Veri Tabanı Direktifi'nin "önemli kısmın çıkarılması" ve "önemsiz kısımların tekrarlı, sistematik çıkarılması" hükümlerine takılır mı?
   - Tek tek kelimelerin seviyeleri bilgi (fakt) mıdır, yoksa korunan bir seçim ve düzenleme midir?
2. **S2 — CC BY-SA listesini uygulamaya gömmek:** Octanove, NGSL veya NAWL'ın tamamı ya da önemli kısmı HiVelzon kelime veri tabanına girerse:
   - (a) CC BY-SA 4.0 §4 uyarınca hangi veri tabanı "Adapted Material" sayılır?
   - (b) Share-alike, uygulama kodunu, özgün hikâyeleri, soruları ve CEFR-J kaynaklı kayıtları kapsar mı?
   - (c) Ayrı veri seti ve ayrı lisans bildirimi stratejisi (§3) yeterli mi?
   - (d) App Store/Google Play dağıtımı ve şifreli paketleme, §2(a)(5)(C)'deki "Effective Technological Measures" yasağıyla çelişir mi?
   - (e) Kullanıcıya liste dosyasının kendisini sunmak gerekir mi?
3. **S3 — EVP izi:** CEFR-J Wordlist yapılırken EVP ile karşılaştırılmış ve EVP'den farklar eklenmiş. Cambridge'in koşulları açısından CEFR-J'yi kullanan HiVelzon'a bir risk doğar mı?
4. **S4 — Editörün EVP'ye "bakması":** EVP koşullarındaki "research gained from access to the EVP" ifadesi, editörün EVP'ye bakıp kendi kararını vermesini de kapsar mı? Bu kapsamı içerik üretim talimatına nasıl yazmalıyız?
5. **S5 — CEFR Companion Volume:** Can-do tanımlayıcılarını "kendi cümlemizle" yeniden yazmak, telif hakkı açısından ne zaman serbest yaratım, ne zaman türev eser (çeviri veya uyarlama) sayılır? Avrupa Konseyi'nden izin almadan güvenli yazım için ölçüt nedir?
6. **S6 — CEFR-J "uygun atıf" koşulu:** Bir mobil uygulamada "Lisanslar" ekranındaki atıf ve veri dosyası başlığındaki atıf, CEFR-J'nin istediği "適切な引用" (uygun atıf) için yeterli mi? Japon hukuku mu uygulanır, Türk hukuku mu?
7. **S7 — Test yöntemi:** VST/VLT ile aynı biçimde (bant başına örneklem, çoktan seçmeli) ama kendi maddelerimizle yazılan bir yerleştirme testi, özgün testlerin hakkını ihlal eder mi?
8. **S8 — CEFR-J CAN-DO Test örnekleri:** "教育・研究用に無償公開" (eğitim ve araştırma için ücretsiz yayın) ile "教育・研究・商用を問わず必ず引用" (eğitim, araştırma ve ticari kullanımda mutlaka atıf) ifadeleri birlikte okunduğunda ticari uyarlama izni var mı?
9. **S9 — MEB programı:** MEB öğretim programlarının tema adlarını ve seviye eşlemesini uygulamada etiket olarak kullanmak serbest mi? FSEK md. 31 gibi resmî metin istisnaları bu programlara uygulanır mı? "MEB programıyla uyumlu" ifadesi reklam ve tüketici hukuku açısından sorun yaratır mı?
10. **S10 — Ücretsiz ama şirket ürünü:** Reklamsız ve abonesiz bir şirket uygulaması, "non-commercial" lisanslar (EVP "personal non-commercial", GSE "non-commercial context") açısından her durumda ticari mi sayılır? Önerimiz, her durumda ticari varsaymaktır.
11. **S11 — Yapay zekâ istemleri:** Lisanslı listeleri (EVP, Oxford, GSE) bir LLM'e istem olarak verip seviye kontrolü yaptırmak, kopyalama veya veri madenciliği sayılır mı? Pearson'ın altbilgisi TDM ve yapay zekâ eğitimini açıkça hak saklı tutuyor.
12. **S12 — MIT port:** py-fsrs'ten Java'ya formül taşırken, kaynak kodda MIT bildirimini korumak yeterli mi? Algoritmanın kendisi için ayrı bir koruma söz konusu mu?

---

## 9. Açık kalanlar

| # | Konu | Durum | Önerilen adım |
|---|---|---|---|
| A1 | CEFR-J Grammar Profile'ın açık ticari lisansı | Resmî sayfada yok [doğrulanmadı] | Tono Lab'a yazılı soru (kullanıcı gönderir) |
| A2 | Octanove C1/C2 listesinin nasıl üretildiği (EVP veya Oxford ile karşılaştırma var mı?) | [doğrulanmadı] | Octanove'a soru veya kaynak makale araştırması |
| A3 | CEFR Companion Volume'un Fransızca baskısındaki "500 kelime" istisnası; Avrupa Konseyi genel telif sayfası | Sayfa 403 verdi [doğrulanmadı] | Farklı ağdan veya tarayıcıdan tekrar okuma |
| A4 | Text Inspector API'ye özel şartlar | Okunamadı [doğrulanmadı] | Gerekmiyor (karar: kullanılmaz) |
| A5 | CVLA kullanım koşulları | Sayfa yok [doğrulanmadı] | Yazara soru (otomasyon gerekirse) |
| A6 | cefrpy'nin kullandığı infochimps kelime listesinin lisansı | [doğrulanmadı] | Veri gömülmediği sürece gerekmiyor |
| A7 | CEFR-J can-do tanımlayıcılarının indirme sözleşmesi | Formun arkasında [doğrulanmadı] | Kullanıcı kayıt olup okuyabilir |
| A8 | British Council/EAQUALS Core Inventory koşulları | Bu turda okunamadı [doğrulanmadı] | `ICERIK-MIMARISI.md` §3.1'deki "yalnızca referans" kararı korunur |
| A9 | Cambridge'den yazılı cevap | Taslak hazır (§6), gönderilmedi | Kullanıcı gönderirse cevap bu rapora eklenir |
| A10 | Hukuk görüşü (§8) | Bekliyor | Hukukçuya iletilir |

### `ICERIK-MIMARISI.md` §3.1'e önerilen düzeltmeler (bu iş kapsamında dosyaya dokunulmadı)

- CEFR-J Wordlist satırı: "v1.5" → "**v1.6 (2020-03-24)**, resmî metin doğrulandı (H-027)".
- CEFR-J Grammar Profile satırı: "Kelime listesiyle aynı koşullar" → "**Resmî sayfada açık lisans yok**; dilbilgisi sırası referans, ham veri gömülmez; teyit bekleniyor".
- EVP/EGP satırı: "Yalnızca referans" → "**Kullanılmaz**. Cambridge ticari lisans vermiyor; editör danışması da kapsam içinde olabilir".
- Pearson GSE satırı: "Yalnızca referans" → "**Kullanılmaz** (izin alınmadıkça)".
- §3.4 MEB satırı: "[doğrulanmadı]" kaldırılır. "A1 için 6 tema, 5–12. sınıflar için 8 tema" notu eklenir.
- §7.2: VST/VLT notu "ticari lisansları belirsiz" yerine "**yalnızca araştırma izni var; ticari hüküm yok**" olur.
