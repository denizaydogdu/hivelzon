# HiVelzon — İçerik Stratejisi, Müfredat, Yayın Sistemi ve Öğrenme Takibi
**Codex ürün şartnamesi | Sürüm 1.0 | Araştırma: 11 Ekim 2026**  
**Platform:** Flutter iOS/Android + Spring Boot 4 + PostgreSQL  
**Kapsam:** A1–C1 İngilizce öğrenme; ücretsiz kullanım; günlük kotalı AI konuşma

> **Depo notu (2026-10-11):** Bu belge kullanıcı tarafından sohbete yapıştırıldı ve olduğu gibi kaydedildi. Claude'un web araştırmasıyla birleştirilmiş sentez ve var olan belgelerle (CLAUDE.md, `IS-PLANI.md`, `SARTNAME.md`) çelişkiler `docs/ICERIK-MIMARISI.md`'de ele alınır.

> **Önemli:** Bu belge kodlama onayı değildir. Codex önce repository'yi, `docs/IS-PLANI.md`, `yapilacaklar/IS-SIRASI.md` ve ilgili iş dosyalarını incelemeli, yalnızca plan hazırlayıp kullanıcı onayını beklemelidir. Onaydan önce kod, migration, ücretli AI çağrısı, medya üretimi veya yayın yapılmamalıdır.

## 0. Kaynakları ve kararları ayırma

- **[MEVCUT KARAR]** Proje rehberinden: Flutter, Spring Boot 4, PostgreSQL; A1–C1; ücretsiz model; hazır ders videoları; günlük kotası olan AI konuşma; etkinlikler; kişiselleştirme; 30 saniyelik kısa video akışı; insan editör onayı; AI üretim maliyeti öncesi açık onay ve bütçe sınırı.
- **[WEB ARAŞTIRMASI]** CEFR, British Council ve Busuu gibi kaynaklarda gözlemlenen resmî yaklaşım.
- **[ÖNERİ]** HiVelzon için ürün/teknik tasarım; kullanıcı onayına sunulmalı.
- **[AÇIK KARAR]** Proje sahibi, pedagojik uzman veya hukuk danışmanının netleştirmesi gereken konu.

Bu belge internetten ders/video kopyalama talimatı değildir. İçerikler özgün hazırlanmalı veya açıkça lisanslanmış/kullanım izni alınmış materyallerden üretilmelidir.

# 1. Ürün vizyonu

HiVelzon kullanıcıya sadece video izletmemeli; kullanıcıya ne öğrendiğini, hangi beceride geliştiğini ve sırada ne yapması gerektiğini açıklamalıdır.

**Öğrenme döngüsü:**

`Keşfet → Öğren → Uygula → Kanıt topla → Geri bildirim → Tekrar et → Yeni içerik öner`

Üç bağlı sistem gerekir:
1. **İçerik fabrikası:** Brief, metin, çeviri, quiz, medya, QA, telif, onay ve yayın.
2. **Öğrenme deneyimi:** Ana sayfa, ders, kısa video, kelime, quiz, konuşma.
3. **Öğrenme kanıtı:** Seviye tahmini, beceri profili, tekrar, ilerleme ve öneriler.

Başarı sadece ekran süresi veya video izlenmesi değildir. Önerilen ana metrik: haftalık anlamlı öğrenme döngüsünü tamamlayan aktif kullanıcı sayısı.

# 2. Web araştırması ve ürün çıkarımları

## 2.1 Avrupa Konseyi — CEFR
Kaynaklar:
- https://www.coe.int/en/web/common-european-framework-reference-languages
- https://www.coe.int/en/web/common-european-framework-reference-languages/cefr-descriptors
- https://www.coe.int/en/web/common-european-framework-reference-languages/cefr-companion-volume-and-its-language-versions

CEFR yalnızca gramer listesinden ibaret değildir; dinleme, okuma, konuşma, yazma, etkileşim ve gerçek iletişim görevlerini kapsayan tanımlayıcılar sunar. HiVelzon, “hangi grameri bitirdi?” sorusunun yanında “hangi görevi yapabiliyor?” sorusunu da izlemelidir.

## 2.2 British Council LearnEnglish
Kaynaklar:
- https://learnenglish.britishcouncil.org/level
- https://learnenglish.britishcouncil.org/getting-started
- https://www.britishcouncil.org.tr/en/english/websites/free-online-materials

British Council seviye testini yaklaşık gösterge olarak tanımlar ve materyalleri seviyeye/beceriye göre düzenler. HiVelzon da ilk test sonucunu **“önerilen başlangıç seviyesi”** diye sunmalı; resmî sertifika veya kesin seviye iddiası vermemelidir.

## 2.3 Busuu Conversations
Kaynaklar:
- https://help.busuu.com/hc/en-us/articles/21862192336402-What-are-Busuu-Conversations-and-how-can-they-help-me-learn-a-language
- https://www.busuu.com/en/languages/speak-fluently-with-busuu-conversations
- https://www.busuu.com/en/it-works/courses

Busuu konuşma senaryolarını CEFR seviyesi ve hedefle ilişkilendirir; kullanıcıya öğrendiği kelime/grameri gerçekçi senaryoda uygulama imkânı verir; geri bildirim konuşma sonunda sunulabilir. HiVelzon’un konuşma pratiği boş bir sohbet kutusu olmamalı: her senaryonun hedefi, seviyesi ve değerlendirme ölçütü bulunmalıdır.

## 2.4 Ürün ilkeleri
1. Kısa klip, tam öğrenme değil; tam derse giriş noktasıdır.
2. Her dersin açık iletişim hedefi olmalıdır.
3. AI taslağı, dil öğretimi veya çeviri doğruluğunun kanıtı değildir.
4. Seviye tek bir etikete indirgenmemeli; beceriler ayrı izlenmelidir.
5. Ücretsiz ürünün AI/medya maliyeti kota, bütçe, önbellek ve kontrollü üretimle yönetilmelidir.

# 3. İçerik türleri ve hiyerarşisi

| Tür | Amaç | Aktif öğrenme |
|---|---|---|
| Hikâye videosu | Dinleme ve bağlam | Anlama quiz'i |
| Diyalog | Günlük iletişim | Rol yapma |
| Mikro ders | Gramer/iletişim işlevi | 3–5 soruluk alıştırma |
| Kelime/ifade kartı | Kalıp öğrenme | Hatırlama ve cümle kurma |
| 30 sn klip | Keşif ve tekrar | Kaydet, anlamı gör, tam derse git |
| Telaffuz alıştırması | Ses farkındalığı | Dinle, kaydet, karşılaştır |
| AI konuşma senaryosu | Etkileşim ve üretim | Görev hedefini tamamlama |
| Okuma/yazma görevi | Anlama ve üretim | Rubrikli değerlendirme |
| Tekrar oturumu | Kalıcılık | Aktif hatırlama |
| Etkinlik | Düzenli pratik | Günlük/haftalık küçük hedef |

Önerilen içerik ağacı:

```text
CEFR Level
  └── Learning Path
       └── Unit
            └── Lesson
                 ├── Story / Dialogue / Reading
                 ├── Video / Audio / Subtitles
                 ├── Vocabulary + Grammar + Communicative function
                 ├── Practice activities
                 ├── Quiz / Evidence task
                 └── Optional speaking scenario
                      └── Derived 30-second clips
```

## 3.1 Her içerikte zorunlu metadata
- `content_id`, `slug`, başlık, açıklama, `content_type`
- CEFR hedefi ve alt beceriler
- İletişim amacı, gramer odağı, hedef kelime/ifadeler
- Tahmini süre ve ön koşullar
- İngilizce metin, Türkçe çeviri, TTS, altyazı ve medya varlıkları
- Quiz, cevap açıklamaları ve değerlendirme rubriği
- İçerik sürümü, durum, editör/onaylayan, yayın zamanı
- Telif/lisans durumu, kaynak URL'leri, AI üretim beyanı
- Güvenlik kontrolü, kalite kontrolü ve son inceleme tarihi
- Klip ise kaynak hikâye/sahne/sürüm bağlantısı

## 3.2 İçerik durum makinesi
`IDEA → BRIEF_APPROVED → DRAFT → LANGUAGE_REVIEW → PEDAGOGICAL_REVIEW → MEDIA_PRODUCTION → QA → APPROVED → SCHEDULED → PUBLISHED`

Ek durumlar: `REJECTED`, `BLOCKED`, `REVIEW_REQUIRED`, `ARCHIVED`, `RETIRED`.

`APPROVED` olmadan yayınlanmamalıdır. AI metin üretebilir; AI'ın yayın yetkisi olmamalıdır.

# 4. İçerik üretim ve yayın operasyonu

## 4.1 Roller
- Product Owner: kapsam, öncelik, bütçe
- Curriculum Designer: CEFR ve müfredat
- Content Writer: özgün metin
- English Editor: doğal ve doğru İngilizce
- Turkish Editor: çeviri ve açıklamalar
- Pedagogy Reviewer: seviye ve ölçme uygunluğu
- Media Producer: TTS, görsel, altyazı, video
- Safety/Rights Reviewer: telif, güvenlik, marka, AI beyanı
- Publisher/Admin: onaylı sürümü yayınlar
- Analyst: kalite ve öğrenme metrikleri

Küçük ekipte roller birleştirilebilir; ancak kritik kalite kontrolünü yalnızca içeriği üreten kişi yapmamalıdır.

## 4.2 Standart üretim hattı
1. **Brief:** Seviye, görev, hedef kelime/gramer, süre, format, kullanıcı segmenti.
2. **Özgün metin:** Hikâye/diyalog; seviye ve kelime karmaşıklığı kontrolü.
3. **Türkçe destek:** `story.tr.md` insan kontrolünden geçer.
4. **Öğrenme görevleri:** 3–5 soru, cevap ve açıklama; ana fikir ve hedef dil unsurunu kapsar.
5. **Medya:** Sahne planı, görsel, TTS, altyazı, video.
6. **QA:** Dil, seviye, çeviri, quiz, ses, altyazı, güvenlik ve telif.
7. **Yayın onayı:** Sürüm dondurulur, onaylayan ve tarih kaydedilir.
8. **Yayın sonrası inceleme:** Teknik hata, kullanıcı bildirimi ve öğrenme metrikleri takip edilir.

## 4.3 Dosya yapısı

```text
content/
  A2/
    A2-TRAVEL-001-hotel-check-in/
      content.json
      story.en.md
      story.tr.md
      glossary.md
      quiz.md
      PROMPTS.md
      rights-and-review.md
      scenes/
      audio/
      images/
      clips/
      subtitles/
      final/
```

`content.json` örneği:

```json
{
  "contentId": "A2-TRAVEL-001",
  "slug": "hotel-check-in",
  "type": "story_video",
  "level": "A2",
  "skills": ["listening", "reading", "spoken_interaction", "vocabulary"],
  "communicativeFunction": "check_into_a_hotel",
  "grammarTargets": ["polite_requests"],
  "vocabularyTargets": ["reservation", "available", "key_card"],
  "estimatedMinutes": 5,
  "status": "DRAFT",
  "version": 1,
  "aiGenerated": true,
  "humanReviewed": false,
  "rightsStatus": "PENDING"
}
```

Bu örnek; kesin veri modeli değildir. Repository incelendikten sonra doğrulanmalıdır.

## 4.4 Yayın öncesi kalite kapıları
- İngilizce doğal ve doğru
- CEFR hedefiyle uyumlu
- Türkçe çeviri insan tarafından kontrol edilmiş
- Quiz ve cevap açıklamaları doğru
- TTS, altyazı ve görsel eşleşmesi kontrol edilmiş
- Telif/lisans ve güvenlik onaylı
- AI üretim/maliyet kayıtları mevcut
- Editör ve yayın onayı kaydedilmiş

Otomatik QA, insan onayının yerine geçmez.

# 5. İnternet kaynaklarından araştırma ve telif

## 5.1 Kaynak sınıfları
- CEFR ve pedagojik referanslar
- British Council gibi resmî öğrenme kaynakları
- Açık lisanslı materyaller
- Lisans şartları uygun sözlük/telaffuz kaynakları
- Kullanıcı araştırmaları ve beta geri bildirimi
- Rakip uygulama incelemesi (ürün deneyimini anlamak için)

## 5.2 Kurallar
- İnternette bulunmak, yeniden yayınlama izni anlamına gelmez.
- Rakip uygulamaların metinleri, videoları, görselleri, sesleri, quiz'leri ve marka unsurları kopyalanmamalı.
- Film/dizi/YouTube/sosyal medya klipleri açık izin/lisans olmadan kullanılmamalı.
- “Eğitim amacı” tek başına telif izni değildir.
- Açık lisansın ticari kullanım, türev eser ve atıf şartları kontrol edilmeli.
- Kaynak kaydı: URL, başlık, lisans türü, atıf, ticari kullanım izni, kontrol tarihi ve onaylayan.
- Gerçek marka, ünlü veya telifli karakter taklidi engellenmeli.
- Hak sahipliği belirsizse içerik yayınlanmamalı.

Önerilen `content_sources` alanları:
`id`, `content_id`, `source_url`, `source_title`, `license_type`, `attribution_text`, `commercial_use_allowed`, `derivative_work_allowed`, `checked_at`, `reviewed_by`, `status`.

# 6. A1–C1 müfredat planı

CEFR seviyeleri geniş yeterlik tanımlarıdır. Aşağıdaki plan HiVelzon için öneridir; resmî sınav veya sertifika eşdeğeri değildir.

## A1 — Temel iletişim
**Hedef:** Tanıdık ifadeleri anlama, kendini tanıtma, basit soru-cevap.
Üniteler:
1. Selamlaşma ve kendini tanıtma
2. Ülkeler, şehirler, diller
3. Aile ve arkadaşlar
4. Günlük rutin
5. Saat, günler, tarih
6. Yiyecek ve kafede sipariş
7. Ev ve odalar
8. Şehirde yön sorma
9. Alışveriş ve fiyat
10. Yardım isteme
11. Hava durumu ve kıyafet
12. Genel görev kontrolü

Dil kaynakları: `to be`, personal pronouns, present simple, `have/has`, `there is/are`, temel sorular, `can/can't`, çoğul, temel edatlar ve başlangıç `a/an/the`.
Görev kanıtı: kendini tanıtma, basit kişisel sorular, sipariş verme, konum anlatma.

## A2 — Günlük rutin ve basit geçmiş/gelecek
Üniteler: hafta sonu/geçmiş deneyim, seyahat planı, otel girişi, restoran istekleri, sağlık ve günlük ihtiyaçlar (teşhis vermeden), iş/okul günü, ev/mahalle, karşılaştırma, alışveriş sorunu, havaalanı, davet/plan, genel kontrol.
Dil kaynakları: past simple, `going to`, temel `will`, comparatives/superlatives, `some/any`, `should`, `because/but/so/when`, kibar istekler.
Görev kanıtı: geçmiş olayı anlatma, gezi planlama, otel rezervasyonu açıklama, yardım isteme.

## B1 — Bağımsız günlük iletişim
Üniteler: deneyimler, iş hayatı, seyahat aksaklıkları, film/kitap görüşü, hedefler, alışkanlıklar, problem/çözüm, eğitim/teknoloji, olay özeti, davet ve nazik ret, e-posta, genel kontrol.
Dil kaynakları: present perfect vs past simple, past continuous, `used to`, first conditional, relative clauses temelleri, modals, time conjunctions, bağlaçlarla uzun cümle.
Görev kanıtı: deneyim anlatma, görüşü gerekçelendirme, iş deneyimini özetleme, sorun/çözüm anlatma, kısa e-posta.

## B2 — Akıcı ve ayrıntılı iletişim
Üniteler: toplantı/müzakere, sunum, haber/konu tartışması, teknoloji, şikâyet çözümü, kariyer, karşı görüş, belirsizlik, ayrıntılı hikâye, profesyonel e-posta, eşdizimler, genel kontrol.
Dil kaynakları: passive voice, reported speech, second/third conditional, modal perfect, relative clauses, discourse markers, collocations/phrasal verbs.
Görev kanıtı: argüman kurma, toplantıda görüş belirtme, seçenekleri karşılaştırma, karmaşık sorunu anlatma, profesyonel mesaj.

## C1 — Esnek ve nüanslı kullanım
Üniteler: görüş ayrılıkları, ikna/retorik, profesyonel sunum, akademik argüman, ima/ton, kültürlerarası iletişim, karmaşık olay, register, deyimler/eşdizimler, uzun metin özeti, eleştirel değerlendirme, genel kontrol.
Dil kaynakları: inversion, cleft sentences, modal nüansları, söylem işaretleyicileri, register, örtük anlam, argüman tutarlılığı.
Görev kanıtı: karmaşık konuyu yapılandırmak, görüşleri adil özetlemek, bağlama uygun üslup seçmek, uzun içeriği özetlemek.

## 6.1 Ünite şablonu
1. Warm-up / ön bilgiyi hatırlatma
2. Input / hikâye, video, diyalog veya okuma
3. Notice / hedef ifadeyi fark etme
4. Practice / kontrollü alıştırma
5. Produce / kendi cümlesi veya konuşması
6. Check / quiz veya görev kanıtı
7. Feedback / açıklama ve öneri
8. Review / tekrar planı
9. Next step / sonraki ders veya konuşma

# 7. Yayın takvimi

Yayın temposu kalite ve editör kapasitesine göre belirlenmelidir. Örnek MVP ritmi (öneri):
- Haftada 2–3 yeni uzun ders/hikâye
- Her uzun içerikten 2–4 klip; yalnızca tek başına anlaşılırsa
- Haftada 1 konuşma senaryosu veya yeni varyant
- Haftalık tekrar/quiz paketi
- Günlük öneriler mevcut katalogdan seçilebilir; her gün yeni içerik üretmek şart değildir.

## 7.1 Örnek haftalık plan

| Gün | Ana içerik | Klip | Aktif öğrenme |
|---|---|---|---|
| Pazartesi | A1/A2 günlük diyalog | Bir ifade | İfadeyi kaydet |
| Salı | B1 hikâye | 30 sn sahne | Anlama sorusu |
| Çarşamba | Kelime/gramer mikro dersi | Sık hata | 3 soru |
| Perşembe | AI konuşma senaryosu | Kullanılan kalıp | Senaryoyu başlat |
| Cuma | B2/C1 içerik | Eşdizim/doğal ifade | Cümle kur |
| Cumartesi | Haftalık tekrar | Eski içerik klibi | Kelime hatırlama |
| Pazar | Ünite kontrolü | İsteğe bağlı keşif | İlerleme özeti |

Her yayın kaydı: içerik ID/sürüm, zaman dilimi, seviye, kanal, hedef, CTA, onaylayan, geri çekme planı ve başarı metriği.

# 8. Uygulamada nerede ne görünecek?

## 8.1 Ana navigasyon
Önerilen beş sekme: **Ana Sayfa, Keşfet, Öğren, Konuş, Profil.**

## 8.2 Ana Sayfa sıralaması
1. Günlük hedef ve baskı kurmayan mesaj
2. Yarım kalan ders (“Devam et”)
3. Tek ana kişisel öneri
4. Tekrar zamanı gelen 3–5 kelime/konu
5. Son dersle ilişkili konuşma görevi
6. Seviyeye uygun yeni içerikler
7. Haftalık anlamlı öğrenme özeti

Ana sayfa sonsuz video akışına dönüşmemeli.

## 8.3 Keşfet — 30 saniyelik klip
Gösterilecekler:
- Video ve okunabilir İngilizce altyazı
- İsteğe bağlı Türkçe anlam
- Seviye ve öğrenme hedefi
- “Kaydet”, “Anlamını gör”, “Tam derse git”, “Bu içeriği önerme”
- Altyazı ve veri kullanımı tercihleri

Akış kuralları:
- İzlenme, öğrenme kanıtı değildir.
- Aynı klip art arda gösterilmemeli.
- “İlgilenmiyorum” tercihi önerileri etkilemeli.
- Klip kaynak hikâye/sahne/sürümle bağlantılı olmalı.
- Otomatik oynatma ve veri tüketimi kullanıcı kontrolünde olmalı.

## 8.4 Öğren — katalog
Filtreler: A1–C1, beceri, konu, süre, içerik türü, tamamlanma, kaydedilenler.
Öğrenme yolu: ünite adı, “sonunda yapabileceklerin”, ders sırası, ön koşul, ünite sonu görev kontrolü.

## 8.5 Ders oynatıcı
Başlık/seviye, video/audio, altyazı dili, hız, metin, dokunulabilir kelime açıklaması, kaldığı yer, ilerleme, sonraki adım ve hata bildirimi. Video bittiğinde otomatik olarak yeni videoya geçmek yerine aktif alıştırma öner.

## 8.6 Ders sonu
1. Tamamlanan görev
2. Quiz sonucu ve cevap açıklamaları
3. Öğrenilen kelimeler
4. Sonraki tekrar zamanı
5. İlgili konuşma/üretim görevi
6. Sonraki ders

## 8.7 Konuşma ekranı
Senaryo başlığı/hedefi, CEFR seviyesi, süre, ipucu/örnek ifade, mikrofon izni ve veri işleme açıklaması, başlat/durdur, kalan günlük kota, hata durumunda tekrar dene/yazılı alternatif ve oturum sonu geri bildirim.

## 8.8 Profil ve ilerleme
Beceri profili, tamamlanan görevler, güçlü alanlar, tekrar gereken konular, haftalık özet, hedef/bildirim ayarları, gizlilik ve hesap işlemleri.

## 8.9 Editör/backoffice
İçerik kuyruğu, metin/çeviri, CEFR metadata, quiz, medya/altyazı QA, telif kaynakları, prompt/maliyet, onay geçmişi, yayın takvimi, kullanıcı bildirimleri, performans ve arşiv/geri çekme.

Yetkilendirme backend'de yapılmalı; UI'da butonu gizlemek güvenlik değildir.

# 9. Kullanıcı seviyesini belirleme

## 9.1 Başlangıç testi
1. Hedef seçimi: günlük hayat, iş, seyahat, akademik vb.
2. İsteğe bağlı seviye testi.
3. Kolaydan zora soru sırası; istenirse cevap eminliği.
4. Okuma/kelime/gramer ilk tahmini.
5. Kısa dinleme görevi.
6. İsteğe bağlı kısa konuşma/yazma örneği.
7. Önerilen başlangıç seviyesi ve belirsizlik.
8. İlk hafta gerçek ders performansıyla tahmini güncelleme.
9. Kullanıcı seviyeyi değiştirebilir veya testi atlayabilir.

Testi atlayan kullanıcı doğrudan bir örnek dersle başlayabilmeli.

## 9.2 Tek seviye yerine beceri matrisi
Örnek şema (gerçek kullanıcı verisi değil):

```text
overall_recommended_level: B1 (provisional)
listening: B1, confidence=medium, evidence_count=8
reading: B1, confidence=high, evidence_count=12
spoken_interaction: A2/B1 boundary, confidence=low, evidence_count=2
spoken_production: A2, confidence=low, evidence_count=1
writing: not_enough_evidence
grammar_topics_to_review:
  - present_perfect_vs_past_simple
```

Kullanıcıya sade anlat:
- “Önerilen başlangıç seviyen B1.”
- “Dinleme için daha fazla kanıtımız var.”
- “Konuşma tahminini netleştirmek için iki kısa görev öneriyoruz.”
- “Bu resmî sınav sonucu veya sertifika değildir.”

## 9.3 Seviye güncelleme kuralları
- Tek yanlış cevap seviye düşürmez.
- Tek kolay quiz seviye yükseltmez.
- Farklı içeriklerde ve günlerde kanıt toplanır.
- Beceriler ayrı izlenir.
- İçeriğin seviyesi ve kullanıcının tahmini seviyesi farklı kavramlardır.
- Düşük güvenle kesin seviye iddiası verilmez.
- Kullanıcı elle seviye seçebilir.
- Değişiklik açıklanır: “Son üç dinleme görevinde ana fikri tutarlı bulduğun için B1 dinleme içeriği öneriyoruz.”

# 10. Öğrenme ilerlemesini ölçme

## 10.1 Kanıt türleri
Quiz doğruluğu, dinleme/okuma anlama, kelime tanıma, gecikmeli hatırlama, konuşma görevi tamamlama, iletişim hedefi, dilbilgisi, yazma rubriği ve yalnızca güvenilir ölçülebiliyorsa telaffuz/akıcılık.

Video izlenme süresi tek başına öğrenme kanıtı değildir.

## 10.2 Evidence event
Alanlar: `user_id`, `activity_id`, `content_id`, `skill`, `level`, `attempt_number`, `result`, `score`, `duration`, `hints_used`, `completed_at`, `scoring_version`, `confidence`, `retention_policy`.

## 10.3 İlerleme durumları
- `NOT_STARTED`
- `IN_PROGRESS`
- `PRACTICED`
- `COMPLETED`
- `NEEDS_REVIEW`
- `MASTERED`

`COMPLETED` dersi bitirmektir; `MASTERED` farklı günlerde, farklı görev biçimlerinde kalıcı başarı kanıtıdır.

Örnek başlangıç ustalık kuralı (pedagojik testle ayarlanmalı): en az 3 ayrı deneme, en az 2 farklı gün, en az 2 görev türü, son denemelerde yeterli başarı ve yardımsız hatırlama. Bu resmî CEFR standardı değildir.

## 10.4 Tekrar sistemi
Önerilen başlangıç aralıkları: ilk öğrenmeden kısa süre sonra, 1 gün, 3 gün, 7 gün, ardından başarıya göre 14/30 gün.
- Yanlış cevapta aralık kısalır.
- Kolay hatırlamada aralık uzayabilir.
- Aynı kelime farklı bağlamlarda sorulur.
- “Unutmuşsun” yerine “Bu kelimeyi tekrar güçlendirelim” denir.
- Kullanıcı tekrar yoğunluğunu ayarlayabilir.

## 10.5 İlerleme ekranı
Göster: haftalık anlamlı oturumlar, beceri tahmini ve güven, tamamlanan iletişim görevleri, kalıcı kelimeler, tekrar gereken konular, sonraki hedef ve son değerlendirmeden beri değişim.
Kaçınılacaklar: temelsiz “İngilizcen %73”, kısa sürede kesin B2/C1 iddiası, sadece süreye göre “akıcı oldun”, resmî sertifika izlenimi.

# 11. Kişiselleştirme ve sonraki içeriği seçme

## Girdiler
Hedef, beceri tahminleri/güveni, son ders, tekrar zamanı, ön koşullar, kaydedilenler, “ilgilenmiyorum” tercihi, günlük hedef ve içerik kalite durumu.

## Öneri sırası
1. Yarım kalan ders
2. Zamanı gelen tekrar
3. Öğrenilen konuyu uygulayan görev
4. Müfredattaki sonraki ders
5. İlgi alanına uygun keşif klibi

## MVP algoritması
- Ön koşul tamamlanmadıysa ileri üniteyi önermemek.
- Tekrar zamanı geldiyse kısa tekrar önermek.
- Yeni öğrenilen ifadeyi konuşma senaryosunda kullandırmak.
- Kanıtı az beceri için kısa görev önermek.
- Sürekli atlanan içerik türünü çeşitlendirmek veya tercih sormak.
- Zor içerikte başarısızlık varsa destek içeriği önermek.
- Çok kolay içerikte sürekli başarı varsa daha yüksek zorluk denemek.

Başlangıçta açıklanabilir kural tabanlı sistem yeterli olabilir; her kullanıcı için pahalı LLM çağrısı şart değildir.

# 12. AI konuşma pratiği

## Senaryo kartı
Başlık, CEFR, iletişim hedefi, süre, hedef ifadeler, başarı ölçütü, zorluk, prompt/model sürümü ve güvenlik politikası.

Örnek **A2 — Otelde giriş**:
- Hedef: Rezervasyonu söylemek, basit soruları anlamak, istekte bulunmak.
- İfadeler: “I have a reservation”, “Could I have…?”, “What time is breakfast?”
- Başarı: Kullanıcı en az iki iletişim hedefini tamamlar ve genel amaç anlaşılır.
- Hata yaklaşımı: Konuşmayı sürekli kesme; oturum sonunda 1–3 gelişim noktası sun.

## Geri bildirim
1. Ne iyi gitti?
2. En fazla 1–3 gelişim noktası
3. Daha doğal alternatif ifade
4. Kısa Türkçe açıklama
5. Yeni bağlamda tekrar görevi
6. Ses/model güveni düşükse puan vermeme veya belirsizliği açıklama

Aksan farklılığı tek başına hata değildir. Telaffuz puanı yalnızca teknik olarak güvenilir ölçülebiliyorsa kullanılmalı. Ham ses varsayılan olarak kalıcı saklanmamalı. Kota dolunca ücretsiz metin/okuma/kelime alternatifi gösterilmeli; kullanıcıya ücretli plan baskısı yapılmamalı.

# 13. Kısa video sistemi

Her 30 saniyelik klip:
- Tek öğrenme hedefi taşır.
- Bağlamı tek başına anlaşılır.
- İngilizce altyazılıdır; Türkçe destek isteğe bağlıdır.
- Kaydet, anlamı gör, mini soru ve tam derse geç eylemleri sunar.
- Kaynak hikâye/sahne/sürüm bağlantısı taşır.
- Telif, AI üretim ve editör onayı metadata'da tutulur.

Klip seçim ölçütleri: anlaşılabilirlik, hedef ifade netliği, ses/altyazı kalitesi, seviye, tam derse bağlantı, telif ve güvenlik onayı.

Ölçümler: başlatma/tamamlama, altyazı açma, kelime kaydetme, anlamı görme, mini quiz, tam derse geçiş, “ilgilenmiyorum”, rapor ve içerik sonrası başarı. Çok izlenmek öğretici olduğunun kanıtı değildir.

# 14. Etkinlikler
Örnek: 5 günlük dinleme, haftada 10 kelimeyi bağlamda kullanma, 3 konuşma senaryosu, bir hikâyenin ana fikrini bulma, eski kelimeleri tekrar etme.
- Atlanabilir olmalı.
- Streak kaybı için cezalandırıcı dil kullanılmamalı.
- Farklı seviyedeki kullanıcılar adaletsiz sıralanmamalı.
- Liderlik tablosu MVP için gerekli değil.
- Bildirimler ölçülü ve kapatılabilir olmalı.
- Ödül, yalnızca uygulamayı açmaya değil gerçek öğrenme görevine bağlanmalı.

# 15. Editör paneli, sürüm ve geri çekme

Panel bölümleri: içerik kuyruğu, metadata, İngilizce, Türkçe, kelime listesi, quiz, medya/altyazı QA, telif/kaynaklar, prompt/maliyet, onay geçmişi, yayın takvimi, kullanıcı bildirimleri, performans, arşiv/geri çekme.

Onay akışı: yazar → İngilizce editörü → pedagojik inceleme → medya QA → telif/güvenlik → publisher.

- Yayınlanan içerik üzerine yazılmaz; yeni sürüm açılır.
- Geçmiş ilerleme hangi içerik sürümüne ait olduğunu korur.
- Kritik dil/telif sorunu varsa hızlı geri çekme olmalı.
- Geri çekilen içerik boş ekran oluşturmamalı; alternatif önerilmeli.
- İçerik değişikliği eski quiz sonuçlarını sessizce değiştirmemeli.
- Her onayda rol, kişi, tarih ve not kaydedilmeli.

# 16. Veri modeli taslağı

Repository incelenmeden migration yazılmamalıdır.

## İçerik
`content_items`: id, slug, title, description, type, CEFR, status, version, duration, AI flag, rights status, created/approved by, publish date.
`content_objectives`: content, objective type/code/label.
`content_versions`: content, version number, change note, review status, timestamps.
`content_assets`: type, storage key, MIME, duration, dimensions, checksum, rights.
`content_sources`: URL, title, license, attribution, commercial/derivative permission, checked date.
`content_reviews`: content/version, review type, reviewer, status, notes, date.
`content_publications`: content/version, channel, scheduled/published/unpublished times, status.

## Müfredat
`learning_paths`, `learning_units`, `lessons`, `lesson_prerequisites`, `lesson_activities`, `quiz_questions`, `vocabulary_items`, `content_vocabulary`, `speaking_scenarios`.

## Kullanıcı öğrenme verisi
`user_skill_estimates`: user, skill, estimated level, confidence, evidence count, last assessed, algorithm version.
`learning_evidence`: user, activity/content, skill, level, score/result, hints, duration, confidence, scoring version, time.
`user_content_progress`: user, content/version, status, last position, start/completion.
`user_vocabulary_progress`: user, vocabulary item, mastery estimate, review due, last result, review count.
`user_learning_goals`: user, goal, daily minutes, target level.
`speaking_sessions`: user, scenario, start/end, status, quota, feedback version, retention date.

Ham ses/transkript için ayrı erişim ve saklama politikası gerekir; yalnızca gerçekten gerekli ve uygun hukuki dayanak/izin varsa saklanmalıdır.

# 17. API taslağı

Kesin URL'ler mevcut repository standardına göre belirlenmeli.

| Method | Endpoint örneği | Amaç |
|---|---|---|
| GET | `/api/v1/content/home` | Ana sayfa kişisel sırası |
| GET | `/api/v1/content/items` | Filtreli katalog |
| GET | `/api/v1/content/items/{id}` | İçerik detayı |
| GET | `/api/v1/learning-paths/{id}` | Ünite/ders sırası |
| POST | `/api/v1/placement/attempts` | Yerleştirme testi |
| GET | `/api/v1/me/skill-estimates` | Beceri tahminleri |
| POST | `/api/v1/learning-evidence` | Kanıt kaydetme |
| POST | `/api/v1/lessons/{id}/complete` | Ders tamamlanması |
| GET | `/api/v1/me/reviews/due` | Tekrar listesi |
| POST | `/api/v1/me/reviews` | Tekrar sonucu |
| GET | `/api/v1/feed/clips` | Kısa video akışı |
| POST | `/api/v1/clips/{id}/save` | Klip kaydetme |
| POST | `/api/v1/speaking/sessions` | Kota kontrollü oturum |
| POST | `/api/v1/speaking/sessions/{id}/turns` | Konuşma turu |
| POST | `/api/v1/speaking/sessions/{id}/finish` | Geri bildirim |
| GET | `/api/v1/me/progress/summary` | Öğrenme özeti |
| GET | `/api/v1/admin/content` | Editör kuyruğu |
| POST | `/api/v1/admin/content/{id}/reviews` | İnceleme |
| POST | `/api/v1/admin/content/{id}/publish` | Yayın |

Gereksinimler: authentication, role authorization, validation, pagination, rate limit, standart hata kodları, AI kota/maliyet/idempotency kontrolü, audit log. Yayın endpoint'i `APPROVED` durumunu backend'de kontrol etmeli. Mobil istemci admin yetkisi veya sağlayıcı anahtarı taşımamalı.

# 18. Maliyet ve kapasite
- Günlük kullanıcı kotası.
- Sağlayıcı/model bazında birim maliyet.
- Aylık bütçe tavanı ve uyarı eşikleri.
- Ücretli üretim öncesi maliyet tahmini ve açık onay.
- Aynı içerik için gereksiz yeniden üretimi engelleme.
- TTS/transkript/metadata önbellekleme.
- Uzun işler için arka plan kuyruğu.
- Kontrollü retry ve sağlayıcı kesintisinde alternatif aktivite.
- Admin için toplam/kullanıcı başı maliyet raporu.
- Aylık tavan yoksa ücretli üretim varsayılan kapalı.
- Tahmin yoksa maliyet uydurulmaz; tahmini ve gerçek maliyet ayrı tutulur.

# 19. Güvenlik, çocuklar, gizlilik ve erişilebilirlik

Bu bölüm hukuk görüşü değildir. KVKK, çocuk kullanıcılar, mağaza politikaları ve hedef pazarlardaki yükümlülükler uzman tarafından doğrulanmalıdır.

Google Play Families politikası hedef yaş, çocukların kişisel verileri, mikrofon/cihaz verisi ve SDK'lar için özel kurallar açıklar:
https://support.google.com/googleplay/android-developer/answer/9893335?hl=en

- Mikrofon izni konuşma özelliği başlatılırken açıklanır.
- Mikrofon reddedilse de video/okuma kullanılabilir.
- Ham ses varsayılan olarak kalıcı saklanmaz.
- Transkriptler kişisel veri içerebilir; erişim ve retention tanımlanır.
- IP/port/saat audit verileri amaç ve süreyle sınırlandırılır.
- Analitik event'lerinde token, e-posta, tam ses veya gereksiz transkript bulunmaz.
- 13+ hedefi ve mağaza yaş sınıflandırması doğrulanır.
- AI öğretmeni manipülatif/bağımlılık kuran dil kullanmaz.
- Kullanıcı yüklemesi MVP'de açık değildir.
- Altyazı, ekran okuyucu etiketleri, sistem yazı boyutu ve net hata durumları desteklenir.
- Telif/AI şeffaflığı ve içerik bildirme mekanizması bulunur.

# 20. Kalite ve başarı metrikleri

## İçerik kalitesi
Dil hatası bildirimi/1.000 oturum, çeviri düzeltmesi, quiz itirazı, altyazı/ses hatası, seviye geri bildirimi, geri çekme sayısı ve yayın öncesi bulunan hata oranı.

## Öğrenme/ürün
Onboarding, ilk ders, ders sonrası aktif alıştırma, gecikmeli tekrar, kelimeyi yeni bağlamda kullanma, klipten derse geçiş, konuşma görevi tamamlama, görev hedefi, haftalık anlamlı oturum, kullanıcı başı AI maliyeti ve kota nedeniyle başarısız oturum.

**Kuzey yıldızı metriği:** Haftada en az bir anlamlı öğrenme döngüsünü tamamlayan aktif kullanıcı. Örnek döngü: ders + quiz + geri bildirim; konuşma + geri bildirim; kelime öğrenimi + gecikmeli tekrar.

# 21. Test ve yayın öncesi kontrol

## İçerik
- CEFR ve iletişim hedefi tutarlı.
- İngilizce doğal, Türkçe çeviri insan kontrolünden geçmiş.
- Hedef kelime/gramer içerikte kullanılıyor.
- Quiz cevapları ve açıklamaları doğru.
- TTS, altyazı ve görsel eşleşmesi kontrol edilmiş.
- Lisans, güvenlik, prompt/maliyet ve onay kayıtları var.
- Mobil ekranda metin okunabilir.

## Teknik
- Migration temiz veritabanında çalışıyor.
- Admin olmayan kullanıcı yayın yapamıyor.
- Onaysız içerik katalogda görünmüyor.
- İlerleme içerik sürümüyle ilişkilendiriliyor.
- Kota eşzamanlı isteklerde aşılmıyor.
- AI hatası kontrollü yönetiliyor.
- Secret/kişisel veri loglanmıyor.
- iOS/Android temel akışları ve erişilebilirlik test edildi.

Yayın sonrası ilk 24–72 saatte teknik hata, video başlatma, quiz şikâyeti, seviye geri bildirimi, AI maliyeti ve güvenlik/telif bildirimleri izlenmeli.

# 22. Yol haritası

## Faz 0 — Repository keşfi
Mevcut uygulama, plan, iş sırası, auth, admin, medya depolama, AI sağlayıcı ve testleri incele. `videoGenerator` desenlerini sadece oku; başka projeyi değiştirme. Çelişkileri ve riskleri raporla. Planı hazırla, kod yazma, onay bekle.

## Faz 1 — İçerik modeli ve katalog
Metadata, CEFR/beceri hedefleri, durum makinesi, API, editör onaylı örnek içerikler, katalog.

## Faz 2 — Ders ve aktif öğrenme
Video/metin/altyazı, kelime, quiz, ilerleme ve içerik bildirimi.

## Faz 3 — Kısa video
Kaynak hikâye bağlantısı, klip akışı, kaydet/tam derse geç, ölçümler.

## Faz 4 — Seviye ve beceri takibi
Yerleştirme, evidence event, beceri tahminleri, ilerleme ekranı, tekrar.

## Faz 5 — AI konuşma
Senaryolar, sağlayıcı adaptörü, kota/maliyet guard, oturum sonu geri bildirim, retention.

## Faz 6 — Editör paneli
İnceleme kuyruğu, sürüm/onay, takvim, maliyet/kalite raporu, geri çekme.

## Faz 7 — Beta ve mağaza
Kullanıcı testleri, içerik analizi, güvenlik/erişilebilirlik, mağaza beyanları, hukuk incelemesi, yayın onayı.

# 23. Codex çalışma talimatı

1. Repository ağacı ve `git status` incele; mevcut değişiklikleri silme.
2. `docs/IS-PLANI.md` dosyasını oku.
3. Önce `yapilacaklar/IS-SIRASI.md` ve mevcut iş sırasını oku.
4. `yapilacaklar/`, `devam-edenler/`, `bitenler/`, `hatalar/`, `ogrenilenler/` klasörlerini repo kurallarına göre incele.
5. Mevcut veri modeli, API, admin paneli, medya ve auth durumunu doğrula.
6. Bu belgede önerilenleri mevcut özellikmiş gibi raporlama.
7. Rakip içeriklerini kopyalama.
8. İçerik lisans, seviye, gizlilik ve AI maliyeti risklerini listele.
9. Çelişkileri “mevcut durum / rehber kararı / öneri” olarak sun.
10. `docs/IS-PLANI.md` ve iş listesi için güncelleme öner.
11. **Kod, migration, harici API çağrısı, AI üretimi, medya üretimi veya yayın yapma.**
12. Planı kullanıcıya sun ve açık onay bekle.

Onay sonrası küçük ve test edilebilir işler yap; gerçek test sonucunu raporla; editör onayını bypass etme; ücretli üretimden önce maliyet ve onay kontrolünü uygula; başka repository'yi değiştirme; hassas verileri loglama.

# 24. Açık kararlar
1. İlk yayında yetişkinler mi, 13+ mı hedeflenecek?
2. Yazma görevi MVP'de mi, sonraki fazda mı?
3. Günlük AI kotası kaç dakika/oturum/tur?
4. Konuşma, ASR ve TTS sağlayıcıları hangileri?
5. Ham ses hiç saklanmayacak mı?
6. Seviye testi kaç soru ve hangi beceriler?
7. Misafir kullanım olacak mı?
8. Mevcut editör paneli var mı?
9. Medya depolama/CDN altyapısı var mı?
10. İlk 3 ayın içerik kapasitesi ve editör sayısı?
11. Günlük/haftalık yayın hedefi?
12. Aylık AI/medya bütçesi ve durdurma eşiği?
13. Kısa videoda otomatik oynatma varsayılanı?
14. İçerik bildirimlerini kim inceleyecek?
15. Hangi ülkelerde yayınlanacak ve yaş hedefi ne?
16. CEFR müfredatını kim pedagojik olarak onaylayacak?

# 25. MVP kabul kriterleri

### İçerik
- Her içerik CEFR, beceri ve iletişim hedefi taşıyor.
- İngilizce ve Türkçe insan kontrolünden geçmiş.
- Quiz, medya, altyazı, lisans ve güvenlik kontrolleri tamam.
- Yayın durumu backend tarafından doğrulanıyor.
- Sürüm ve onay geçmişi tutuluyor.

### Öğrenme
- Kullanıcı test alabiliyor veya atlayabiliyor.
- Beceri bazlı kanıt tutuluyor.
- Tek soruyla seviye değişmiyor.
- Tamamlandı ve ustalaşıldı ayrılıyor.
- Tekrar zamanı gelen konular gösteriliyor.
- İlerleme açıklanabilir ve bir sonraki adıma bağlı.

### Operasyon ve güvenlik
- Editör onay, yayın takvimi ve geri çekme çalışıyor.
- Maliyet ve prompt kayıtları mevcut.
- Admin yetkileri backend'de doğrulanıyor.
- Mikrofon ve transkript politikası uygulanıyor.
- Secret/PII loglanmıyor.
- Yaş hedefi, gizlilik ve mağaza beyanları gözden geçirilmiş.

# 26. Kaynakça

Araştırma tarihi: **11 Ekim 2026**. Sayfalar ve özellikler değişebileceği için yayın öncesinde yeniden doğrulanmalıdır.

1. Council of Europe — CEFR: https://www.coe.int/en/web/common-european-framework-reference-languages
2. Council of Europe — CEFR descriptors: https://www.coe.int/en/web/common-european-framework-reference-languages/cefr-descriptors
3. Council of Europe — CEFR Companion Volume: https://www.coe.int/en/web/common-european-framework-reference-languages/cefr-companion-volume-and-its-language-versions
4. British Council — Level test: https://learnenglish.britishcouncil.org/level
5. British Council — Getting started: https://learnenglish.britishcouncil.org/getting-started
6. British Council Türkiye — Free materials: https://www.britishcouncil.org.tr/en/english/websites/free-online-materials
7. Busuu — Conversations support: https://help.busuu.com/hc/en-us/articles/21862192336402-What-are-Busuu-Conversations-and-how-can-they-help-me-learn-a-language
8. Busuu — Conversations product page: https://www.busuu.com/en/languages/speak-fluently-with-busuu-conversations
9. Busuu — Courses and CEFR: https://www.busuu.com/en/it-works/courses
10. Google Play — Families policies: https://support.google.com/googleplay/android-developer/answer/9893335?hl=en
11. Cambridge English — CEFR: https://www.cambridgeenglish.org/exams-and-tests/cefr/

---

## Sonuç

HiVelzon için içerik üretimi, uygulama deneyimi ve öğrenme takibi tek bir sistemin parçaları olarak tasarlanmalıdır. İçerik özgün ve lisanslı olmalı; yayın öncesi insan kontrolünden geçmeli; kullanıcının ilerlemesi izlenme süresi yerine gerçek görev kanıtlarına dayanmalı; öneriler kullanıcının beceri profili ve tekrar ihtiyacına bağlanmalıdır. İlk teknik adım kod değil, repository keşfi ve onaylanabilir bir uygulama planıdır.
