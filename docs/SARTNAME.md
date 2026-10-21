# HiVelzon — Ürün, Teknik Mimari ve Uygulama Şartnamesi
**Codex için ürün gereksinimleri ve uygulama planı**  
**Sürüm:** 0.1 — Araştırma taslağı  
**Tarih:** 11 Ekim 2026  
**Durum:** Planlama / kullanıcı onayı bekleniyor  
**Platform:** iOS + Android  
**Birincil dil:** Türkçe arayüz, İngilizce öğrenme içeriği  
**Ürün:** HiVelzon — Velzon Bilişim Teknolojileri Ltd. Şti.

> **Önemli çalışma kuralı:** Bu belge kod yazma izni değildir. İlk adım mevcut depoyu ve iş takip belgelerini inceleyip planı güncellemektir. Kullanıcı `docs/IS-PLANI.md` planını açıkça onaylamadan uygulama kodu, veritabanı migration'ı, harici servis çağrısı veya içerik üretimi başlatılmamalıdır.

> **Depo notu (2026-10-11):** Bu belge kullanıcı tarafından sohbete yapıştırıldı ve olduğu gibi kaydedildi. `docs/IS-PLANI.md` ile çelişen noktalar CLAUDE.md'deki "Plan ile şartname arasındaki çelişkiler" bölümünde listelenir; telaffuz puanı (H-015) dışındakiler karara bağlandı.

> **Güncel karar notları (2026-10-12):** Bu belgenin gövdesi kullanıcının taslağı olarak değiştirilmeden duruyor. Aşağıdaki bölümler sonradan verilen kararlarla **geçersiz kaldı ya da daraldı**; çelişkide `CLAUDE.md` karar tabloları geçerlidir.
> - **Çalışma kuralı (üstteki not) ve "Durum":** Uygulama planı onaylandı (H-025, `docs/UYGULAMA-PLANI.md`); Faz 1 (MVP) kodlaması sürüyor. İş planının son onayı H-001'de.
> - **§5.1 P0 "AI konuşma pratiği" ve "konuşma sonrası geri bildirim":** MVP'de yok; v1'de (F2) Hi-B ile gelir (H-007, H-047). Hi-A (kural tabanlı koç, AI yok) MVP'de (H-048).
> - **§16 Faz 0–5:** Birleşik 4 faza bağlandı: F0 kararlar + pilot · F1 MVP · F2 v1 · F3 v2 (K-17).
> - **§4.2 günlük hedef 5/10/15 dk:** Bu belgedeki seçenek kabul edildi (H-013); günde en fazla 1 hatırlatma.
> - **Yaş (§12, §18/10):** her yaş kullanır; hesap 13+, 13 altı hesapsız tam kullanım (veri yalnız cihazda); AI sohbeti 18+, 13–17 rehberli (H-002 2026-10-13 güncellemesi, H-047). Hukukçu teyit etti (2026-10-21): veli onayı gerekmez, doğum yılı beyanı yeterli.
> - **Ürün yönü:** Ders kataloğu yerine oyunlaştırılmış, sürekli hikâye (*The Missing Signal*; H-029, `docs/OYUN-TASARIMI.md`). Sekmeler: Ana Sayfa · Keşfet · Hikâye · Konuş · Profil (K-30).
> - **Altyazı biçimi:** Uygulamada WebVTT değil, zaman damgalı JSON'dan uygulamanın çizdiği altyazı; satıra dokununca Türkçe anlam paneli (K-03, H-046). Sosyal medyada gömülü `.ass`.
> - **Bölüm açılışı:** Her bölüm doğrudan başlıkla açılır; açılışta görev kartı yok, görev 🎯 panelinde (H-050).
> - **AI etiketi (§8, §12):** Uygulama içi videolara gömülmez, bölüm başında ~4 sn not; sosyal medya ve uygulama dışı videolarda gömülü (CLAUDE.md Higgsfield kuralı 6, K-14).
> - **Yerel geliştirme:** Sunucu, Bunny Stream ve mağaza hesapları en sona bırakıldı (H-044); o zamana kadar her şey yerelde.
> - **§10 veri modeli:** Taslaktır, H-037'de kesinleşir. Bilinen eksikler: `refresh_tokens` tablosu ve roller (kullanıcı / editör / yönetici) tanımlı değil; hesap silme durumu burada `DELETION_PENDING`, `docs/IS-PLANI.md` §9.4'te `PENDING_DELETION` yazıyor; tek ad H-037'de seçilecek.
> - **§10/§11 kimlik ve hesap kısmı (2026-10-13):** H-037 Bölüm 1 ile geçersiz kaldı: parolasız e-posta kodu, `refresh_tokens`, roller USER/EDITOR/ADMIN, `PENDING_DELETION`, rızalar ve `audit_log`; güncel şema `backend/src/main/resources/db/migration/V2__identity_core.sql`, güncel API `backend/README.md`.
> - **Hukukçu cevapları (2026-10-21, H-095; `docs/HUKUK-SORULARI.md` → "Cevaplar"):** (1) Kullanım koşulları ya da KVKK aydınlatma metninin sürümü değişince **yeniden onay istenmez**; eski sürümü onaylamış hesap hiçbir yerde engellenmez (eşitleme, giriş, rıza), uygulama Ana Sayfa'da her yeni sürümde bir kez sakin bir bildirim gösterir (yalnızca cihazda, `app_meta`); ilk onayın kaydı olduğu gibi kalır. (2) Denetim kaydı (IP/port/saat) olay tarihinden **2 yıl**, rıza kayıtları hesap kalıcı silindikten sonra **2 yıl** saklanır, süre dolunca zamanlanmış iş siler (§12.1, §12.2). (3) Aydınlatma metni ve kullanım koşulları Claude taslağı; hukukçu gözden geçirecek.
> - Diğer kararlar: yalnızca Türkiye (H-018), reklam yok (H-020), misafir prolog + B1 (H-009), çevrimdışı F3 (H-010), AI tavanı 300 USD/ay (H-003), içerik onayı Claude üretir + kullanıcı onaylar (H-028).

---

## 1. Belgenin amacı ve kaynakların ayrımı

Bu belge, yüklenen **HiVelzon — Proje Rehberi** içindeki mevcut ürün kararlarını daha uygulanabilir gereksinimlere dönüştürür; ayrıca benzer dil öğrenme uygulamalarının kamuya açık özelliklerini inceleyerek öneriler ekler.

Bilgiler üç sınıfa ayrılır:

- **[KARAR]** Proje rehberinde açıkça belirtilen karar; onay alınmadan değiştirilmemeli.
- **[ARAŞTIRMA]** Rakip ürünlerin kamuya açık sayfalarında açıklanan özellikler. Bu özelliklerin her ülke, cihaz veya abonelikte aynı şekilde sunulduğu varsayılmamalı.
- **[ÖNERİ]** HiVelzon için önerilen tasarım veya teknik çözüm; plan onayında karara bağlanmalı.

### 1.1 Değiştirilmeyecek temel kararlar

- [KARAR] iOS ve Android için mobil uygulama.
- [KARAR] Flutter istemci, Spring Boot 4 backend, PostgreSQL veri tabanı.
- [KARAR] Ürün tamamen ücretsiz olacak; ücretli abonelik temel iş modeli olarak tasarlanmayacak.
- [KARAR] Hedef aralık A1–C1, CEFR tabanlı İngilizce öğrenimi.
- [KARAR] Ürünün dört ayağı: hazır ders videoları, günlük kotası olan AI konuşma pratiği, kişiselleştirme/etkinlikler/hazır video varyantları ve 30 saniyelik kısa video akışı.
- [KARAR] Kullanıcı planı onaylamadan kod yazılmayacak.
- [KARAR] `videoGenerator` ayrı projedir. Önce okunur; desenler gerekiyorsa kaynak belirtilerek HiVelzon'a taşınır. İki repo birbirine bağlanmaz ve `videoGenerator` projesi bu görev kapsamında değiştirilmez.
- [KARAR] Higgsfield üretiminden önce maliyet hesaplanır, kullanıcıya gösterilir ve onay alınır. Prompt/model/parametre/tarih/job ID/kredi kaydı tutulur; aylık harcama tavanı aşılmaz.
- [KARAR] Hikâye içeriği insan kontrolünden geçmeden yayınlanmaz.
- [KARAR] İçerik güvenliği hedefi 13+; şiddet, cinsellik, siyaset, din, gerçek markalar, ünlüler ve telifli karakterler kullanılmaz.
- [KARAR] Hesap silme 30 gün geri alınabilir olacak; kimlik doğrulama, denetim ve onay kayıtları hiVelzon'un kendi tasarımıyla yapılacak.

### 1.2 Bu belgenin kapsamı

Dahil:
- Ürün konumlandırması ve rakip karşılaştırması
- MVP kapsamı ve fazlandırma
- Mobil ekranlar ve temel kullanıcı akışları
- Ders, hikâye, kısa video ve konuşma pratiği gereksinimleri
- İçerik üretim/yayın iş akışı
- Backend mimarisi, veri modeli ve API taslağı
- Güvenlik, mahremiyet, maliyet kontrolü, gözlemlenebilirlik
- Test stratejisi ve kabul kriterleri
- Codex için repo inceleme ve planlama talimatları

Şimdilik kapsam dışı:
- `hi.velzon.tr` web sitesi (gelecek faz)
- Canlı yayın
- `videoGenerator` projesinde değişiklik
- Kullanıcıya özel sıfırdan video üretimi
- Ücretli abonelik veya paywall
- Onay alınmadan gerçek Higgsfield üretimi ya da sosyal medya yayını

---

## 2. Ürün vizyonu ve değer önerisi

### 2.1 Vizyon

HiVelzon, Türkçe konuşan kullanıcıların İngilizceyi A1'den C1'e kadar **hikâye, video, kelime bağlamı ve düşük baskılı AI konuşma pratiği** üzerinden geliştirmesini sağlayan, ücretsiz ve mobil öncelikli bir öğrenme ürünü olacaktır.

### 2.2 Önerilen ürün vaadi

**“İngilizceyi izle, hikâyelerle anla, konuşarak geliştir.”**

Bu vaat üç farklı öğrenme modunu birleştirir:
1. **İzle:** Kısa, seviyelendirilmiş video ve 30 saniyelik keşif akışı.
2. **Anla:** İngilizce hikâye, Türkçe destek, sözlük, altyazı ve mini quiz.
3. **Konuş:** Yapay zekâ ile gerçek hayata yakın senaryolarda pratik ve oturum sonrası geri bildirim.

### 2.3 Farklılaşma hipotezi

Rakiplerde kısa ders, oyunlaştırma, AI konuşma ve telaffuz geri bildirimi gibi özellikler zaten mevcut. HiVelzon tek bir özelliğin benzersiz olduğunu iddia etmemeli. Farklılaşma hipotezi, bu özellikleri **ücretsiz kullanım + A1–C1 seviyeli AI hikâye videoları + 30 saniyelik keşif akışı + Türk öğrencilere özel hata açıklamaları + maliyeti denetlenen üretim hattı** şeklinde bir araya getirmektir.

Bu bir ürün hipotezidir; kullanıcı testleriyle doğrulanmalıdır.

---

## 3. Pazar ve benzer uygulama incelemesi

Araştırma, ürünlerin resmî siteleri, destek sayfaları ve mağaza sayfalarındaki kamuya açık açıklamalara dayanır. “Popüler” ifadesi burada küresel ölçekte bilinen ve aktif ürünler için kullanılır; indirme sıralaması veya pazar payı hakkında bağımsız doğrulama yapılmadıkça kesin sıralama iddiası değildir.

### 3.1 Karşılaştırma

| Uygulama | Kamuya açık öne çıkan yaklaşım | HiVelzon için öğrenim | Birebir kopyalanmaması gereken nokta |
|---|---|---|---|
| **Duolingo** | Kısa dersler, oyunlaştırma, ilerleme ve hatırlatmalar; AI ile kişiselleştirme ve bazı kurslarda AI video görüşmesi | Günlük küçük hedefler, görünür ilerleme, öğrenme alışkanlığını destekleyen hafif oyunlaştırma | Rekabetçi streak baskısını öğrenme kalitesinin önüne koymak; ücretli özelliklere bağlı deneyimi aynen almak |
| **Busuu** | Yapılandırılmış kısa dersler, CEFR düzeyleri, gerçek yaşam senaryoları, AI konuşma ve telaffuz pratiği | Konuşma senaryosunu seviyeye bağlamak; ders içinde öğrenilen dili hemen kullandırmak | İnsan topluluğu düzeltmeleri ve ücretli paket özelliklerini ürünün ilk sürümüne gereksiz yere taşımak |
| **Babbel / Babbel Speak** | Derslerde konuşma tanıma, telaffuz geri bildirimi, gerçekçi AI senaryoları; kullanıcıyı konuşma sırasında sürekli kesmek yerine oturum sonunda değerlendirme | Konuşma sırasında akışı koru; düzeltmeleri çoğunlukla oturum sonunda ver; gerektiğinde tekrar, yavaşlatma ve ipucu sun | Ses analizi doğruluğunu sağlayamayacakken kesin telaffuz puanı iddiası |
| **ELSA Speak** | Ses, vurgu, tonlama, akıcılık, dilbilgisi ve kelime kullanımına yönelik ayrıntılı AI geri bildirimi; kişiselleştirilmiş çalışma önerileri | “Yanlış” demekle kalmayıp hangi ses/kelime/ölçütte sorun olduğunu ve nasıl düzeltileceğini açıkla | Model yeterliliği ve değerlendirme güvenilirliği kanıtlanmadan CEFR/IELTS düzeyinde kesin skor üretmek |
| **Speak** | Öğren–tekrar et–gerçek konuşmada uygula döngüsü; ses odaklı AI rol oyunları ve kişiselleştirme | Ders kelimelerini sonraki konuşma senaryolarında tekrar kullan; konuşma pratiğini ayrı bir laboratuvar gibi hissettirme | Sınırsız AI kullanımını ücretsiz sunma varsayımı; HiVelzon günlük kota ve maliyet kontrolü kullanmalı |
| **Cake** | Günlük ifade klipleri, kısa video içeriği, ifadeleri kaydetme ve tekrar, telaffuz koçu | Kısa videoyu sadece tüketim değil, ifade kaydetme ve aktif tekrar noktasına bağla | Telif hakkı belirsiz film, ünlü veya sosyal medya kliplerini kaynak izni olmadan kullanmak |
| **Beelinguapp** | Hikâye/audiobook, eş zamanlı iki dilde metin, sesli takip, sözlük, quiz ve kelime kartları | HiVelzon hikâye ekranında İngilizce ve Türkçe desteğini isteğe bağlı göster; kelimeye dokunma, ses ve quiz'i tek akışta birleştir | Türkçe çeviriyi otomatik üretip editör kontrolü olmadan yayımlamak |

### 3.2 Kaynaklı gözlemler

- Duolingo resmî sayfası kısa dersleri, oyunlaştırmayı, okuma-yazma-dinleme-konuşma becerilerini ve kişiselleştirmeyi vurgular. 2025 Duocon duyurusunda bazı kurslar için AI video görüşmesi, gerçek zamanlı destek ve görüşme sonrası değerlendirme anlatılmıştır.  
  Kaynak: https://www.duolingo.com/ — https://investors.duolingo.com/news-releases/news-release-details/duolingo-unveils-major-product-updates-turn-learning-real-world
- Busuu uygulama sayfası yapılandırılmış kısa dersler, gerçek yaşam konuşmaları ve topluluk desteğini açıklar. Busuu Conversations destek sayfası, CEFR düzeyine göre senaryo seçimi ve üretken AI ile gerçekçi konuşma pratiğini açıklar.  
  Kaynak: https://www.busuu.com/en/mobile — https://help.busuu.com/hc/en-us/articles/21862192336402-What-are-Busuu-Conversations-and-how-can-they-help-me-learn-a-language
- Babbel Speak, gerçek yaşam senaryolarında AI konuşma partneri, ipucu/çeviri/yavaşlatma ve konuşma sonrası geri bildirim yaklaşımını anlatır. Babbel konuşma tanıma sayfası da konuşma alıştırmalarında anlık geri bildirimden söz eder.  
  Kaynak: https://support.babbel.com/hc/en-us/articles/25875402999826-Babbel-Speak — https://support.babbel.com/hc/en-gb/articles/19211305815570-Speech-recognition
- ELSA Speak, telaffuz, vurgu, tonlama ve akıcılık üzerine AI geri bildirimi ve kişiselleştirilmiş öneriler sunduğunu belirtir.  
  Kaynak: https://elsaspeak.com/en/faqs/how-does-elsa-s-pronunciation-feedback-work — https://elsaspeak.com/en/speech-analyzer
- Speak, gerçek hayatta kullanılan ifadeleri öğrenme, tekrar ve AI ile karşılıklı konuşma şeklinde üç aşamalı bir yöntem tanımlar.  
  Kaynak: https://www.speak.com/
- Cake'in App Store sayfası kısa ifadeler, günlük klipler, konuşma/dinleme, kaydedilen cümleler ve AI telaffuz koçu özelliklerini listeler.  
  Kaynak: https://apps.apple.com/tr/app/cake-learn-english-korean/id1350420987
- Beelinguapp, hikâye ve haberleri iki dilde yan yana gösterme, sesli dinleme, kelime listesi ve quiz yaklaşımını anlatır.  
  Kaynak: https://beelinguapp.com/ — https://beelinguapp.com/courses/learn-english

### 3.3 Rakiplerden türetilen HiVelzon ürün ilkeleri

1. **Kısa oturum, net hedef:** Kullanıcı uygulamayı açınca 3–10 dakikada tamamlanabilir bir öğrenme eylemi görmeli.
2. **Pasif izlemeyi aktif öğrenmeye çevir:** Video sonrasında en az bir anlam sorusu, kelime kaydetme veya konuşma görevi sun.
3. **Önce akıcılık, sonra düzeltme:** AI konuşma sırasında yalnızca iletişimi engelleyen durumlarda müdahale etmeli; detaylı geri bildirim çoğunlukla oturum sonunda gösterilmeli.
4. **Hatanın nedenini açıkla:** Örneğin “I am agree” yerine “I agree” denmesinin nedeni Türkçe açıklamayla verilmeli.
5. **Kişiselleştirme görünür ve anlaşılır olmalı:** Önerilen içerik, önceki ders, seviye, ilgi alanı ve tekrarlanması gereken kelimelerle gerekçelendirilmeli.
6. **Güvenilir ölçüm:** Telaffuz puanı, dil seviyesi veya öğrenme ilerlemesi gerçek model kabiliyetiyle uyumlu olmalı; belirsizlik saklanmamalı.
7. **Ücretsiz model maliyetsiz model değildir:** AI kullanımına kota, önbellek, maliyet izleme ve servis kesintisi halinde alternatif akış gerekir.

---

## 4. Kullanıcı segmentleri ve öğrenme hedefleri

### 4.1 İlk hedef segmentler

- **Başlangıç (A1–A2):** Temel cümleleri anlama, gündelik kelime, yavaş ve net anlatım, Türkçe destek.
- **Orta seviye (B1–B2):** Doğal konuşma, daha uzun hikâyeler, bağlaçlar, iş/seyahat senaryoları, hata örüntülerinin azaltılması.
- **İleri seviye (C1):** Doğal hız, deyimler/eşdizimler, üslup ve nüans, tartışma ve ayrıntılı anlatım.
- **Düzenli kısa içerik tüketenler:** 30 saniyelik videodan yeni ifade öğrenip tam derse geçmek isteyenler.
- **Konuşmaktan çekinenler:** İnsan karşısında utanmadan AI ile pratik yapmak isteyenler.

### 4.2 İlk açılış ve seviye belirleme

İlk açılış akışı:
1. Dil ve gizlilik bilgilendirmesi.
2. Kullanıcı hedefi: günlük konuşma, iş, seyahat, sınav/akademik veya genel İngilizce.
3. Günlük hedef: 5, 10 veya 15 dakika.
4. İsteğe bağlı kısa seviye belirleme; atlama seçeneği bulunur.
5. Başlangıç seviyesine göre ilk ders ve bir kısa video önerisi.

Seviye testi kesin sınav veya resmî sertifika gibi sunulmamalıdır. Sonuç “önerilen başlangıç seviyesi” olarak adlandırılmalı; kullanıcı ayarlardan değiştirebilmelidir.

---

## 5. Ürün kapsamı ve önceliklendirme

### 5.1 P0 — İlk kullanılabilir sürüm (MVP)

- [ ] Güvenli kayıt/giriş ve misafir keşfi kararı
- [ ] Onboarding, hedef ve önerilen seviye
- [ ] Ana sayfa: devam et, günlük hedef, önerilen ders
- [ ] A1–C1 filtreli hazır ders/hikâye kataloğu
- [ ] Video oynatıcı: altyazı, hız seçimi, duraklatma, yeniden oynatma
- [ ] Hikâye okuma ekranı: İngilizce metin, isteğe bağlı Türkçe, kelime açıklaması
- [ ] Kelimeyi kişisel listeye ekleme ve temel tekrar
- [ ] Ders sonunda 3–5 soruluk quiz ve açıklamalı sonuç
- [ ] 30 saniyelik kısa video akışı; beğeni yerine “kaydet”, “ilgilenmiyorum”, “tam derse geç” gibi öğrenme eylemleri öncelikli
- [ ] Günlük kotası olan AI konuşma pratiğinin ilk senaryo seti
- [ ] Konuşma oturumu sonrası geri bildirim
- [ ] İçerik editör onay paneli veya mevcut projede doğrulanacak eşdeğer backoffice akışı
- [ ] Kullanıcı onayları, gizlilik metinleri, hesap silme talebi ve 30 günlük geri alma
- [ ] Hata takibi, temel metrikler ve AI maliyet kaydı
- [ ] Erişilebilirlik ve boş/yükleniyor/hata durumları

### 5.2 P1 — MVP sonrasında

- [ ] Daha gelişmiş kişiselleştirilmiş öğrenme yolu
- [ ] Kelime tekrarını aralıklı tekrar mantığıyla geliştirme
- [ ] Kullanıcı performansına göre ders varyantları
- [ ] Etkinlikler ve öğrenme serileri
- [ ] İndirme/çevrimdışı içerik (depolama ve telif kararlarına bağlı)
- [ ] Konuşma pratiğinde daha fazla senaryo ve ayrıntılı ölçüm
- [ ] Kullanıcıya ait ilerleme raporu
- [ ] Bildirim tercihleri ve ölçülü hatırlatmalar

### 5.3 P2 — Sonraki değerlendirme

- `hi.velzon.tr` tanıtım sitesi
- Sosyal medya yayın hattı entegrasyonu; ayrıca onay gerektirir
- Daha gelişmiş konuşma değerlendirmesi
- Yeni dil desteği
- Kurumsal/öğretmen araçları
- Kullanıcıların kendi içeriklerini üretmesi veya paylaşması (moderasyon ve güvenlik değerlendirmesi olmadan eklenmemeli)

### 5.4 MVP dışında tutulacaklar

- Kullanıcı başına sıfırdan AI video üretimi
- Canlı yayın
- Ücretli abonelik, kredi satışı veya paywall
- Kullanıcıların herkese açık serbest metin/video yüklemesi
- İlk sürümde sosyal takipçi sayısı, sonsuz etkileşim metrikleri veya öğrenme dışı sosyal ağ özellikleri

---

## 6. Öğrenme deneyimi ve ekran gereksinimleri

### 6.1 Alt navigasyon önerisi

En fazla beş ana bölüm:
1. **Ana Sayfa**
2. **Keşfet** (30 saniyelik kısa videolar)
3. **Öğren** (seviyeler, hikâyeler, dersler)
4. **Konuş** (AI pratik)
5. **Profil** (hedefler, kelimeler, ilerleme, gizlilik)

Bu navigasyon bir öneridir; kullanılabilirlik testinde doğrulanmalıdır.

### 6.2 Ana sayfa

Gösterilecekler:
- “Devam et” kartı
- Günlük öğrenme hedefi ve bugün tamamlanan süre
- Bir önerilen hikâye/ders
- Bir önerilen konuşma senaryosu
- Son kaydedilen kelimelerden kısa tekrar
- Kullanıcı hedefi ve seviyesine uygun içerik

Kurallar:
- Ana sayfa bir reklam/sonsuz akış ekranı gibi davranmamalı.
- Kullanıcıyı tek bir ana eyleme yönlendirmeli.
- Günlük hedef tamamlanmadığında utandırıcı veya cezalandırıcı dil kullanılmamalı.

### 6.3 Ders/hikâye ayrıntısı

- Başlık, CEFR seviyesi, tahmini süre, konu ve öğrenme hedefleri.
- Video ve metin arasında geçiş.
- İngilizce altyazı aç/kapat.
- Türkçe çeviriyi aç/kapat; varsayılan davranış onboarding tercihine bağlı.
- Kelimeye dokununca Türkçe karşılık, bağlamdaki anlam ve kısa örnek.
- Ses hızı: normal ve en az bir yavaş seçenek.
- Sahne/satır ilerlemesi ve kaldığı yerden devam.
- Video metnindeki kelime vurgusu, özellikle A1–B1 seviyesinde, yalnızca zamanlama doğrulanabiliyorsa kullanılmalı.
- Tamamlandı durumu sadece video sonuna gelmeye değil, en az bir öğrenme etkileşimine bağlanabilir; kesin kural analitik sonuçlarla seçilmeli.

### 6.4 30 saniyelik kısa video akışı

Her klip:
- Uzun hikâyeden veya editör onaylı içerikten türetilir; ayrı hikâye yazılmaz.
- Kendi başına anlaşılır olmalı.
- Bir ifade/kelime/dilbilgisi hedefi taşımalı.
- İngilizce altyazı içermeli; Türkçe destek tercihe bağlı olmalı.
- “Bu ifadeyi kaydet”, “anlamını gör”, “tam hikâyeyi aç”, “bu seviyeden daha fazla göster” eylemleri sunmalı.
- Otomatik oynatma, sessiz başlama, veri tüketimi ve erişilebilirlik ayarları değerlendirilmelidir.
- Klip sonundaki “devamı uygulamada” çağrısı isteğe bağlıdır ve öğrenme deneyimini kesmemelidir.
- Telif/izin ve AI ile üretildi bildirimi içerik metadatasında tutulmalıdır.

**Önemli:** Kısa video akışı tek başına ürünün öğrenme ölçüsü olmamalıdır. İzlenme süresi yanında kelime kaydetme, quiz tamamlama ve tam derse geçiş gibi öğrenme sinyalleri izlenmelidir.

### 6.5 AI konuşma pratiği

İlk senaryo örnekleri:
- Kafede sipariş verme
- Havaalanında yön sorma
- Otele giriş
- Kendini tanıtma
- İş görüşmesinde kendini anlatma
- Günlük planlar hakkında konuşma

Her senaryoda:
1. Seviye, hedef ve beklenen görev gösterilir.
2. Gerekirse örnek ifade ve ipucu verilir.
3. Kullanıcı konuşur; uygulama izinli mikrofon kaydını işler.
4. AI bağlam içinde cevap verir.
5. Oturum sonunda geri bildirim gösterilir.
6. Hedef kelime ve hatalardan mini tekrar önerilir.

Geri bildirim alanları:
- Anlaşılırlık / görevi tamamlama
- Kelime seçimi
- Dilbilgisi
- Telaffuz veya akıcılık (yalnızca teknik olarak güvenilir biçimde ölçülebiliyorsa)
- Kullanılabilecek daha doğal alternatif cümle
- En fazla 1–3 öncelikli gelişim noktası

Geri bildirim yargılayıcı olmamalı. “Kötü konuşuyorsun” gibi etiketler yasak. “Anlam netti; şu ifadeyi daha doğal söyleyebilirsin” biçimi tercih edilir.

**Günlük kota:** Kesin sayı proje rehberinde belirlenmemiştir. MVP planında kullanıcı başına günlük oturum/dakika/AI çağrısı kotası önerilmeli ve kullanıcı onayına sunulmalıdır. Kota bittiğinde:
- Açık ve sakin bir açıklama göster.
- Ücretsiz alternatif olarak hikâye, video veya çevrimdışı alıştırma öner.
- Kullanıcıya ücretli plana geçiş baskısı yapma.
- Kota sıfırlanma zamanını yerel saatle açıkça belirt.

### 6.6 Kişiselleştirme

Kişiselleştirme, kullanıcı başına yeni video üretmek değil; mevcut içeriklerin uygun varyantlarını ve önerilerini seçmektir.

Öneri girdileri:
- Kullanıcının CEFR başlangıç seviyesi
- Seçtiği hedef (iş, seyahat, günlük konuşma vb.)
- Tamamlanan dersler ve quiz sonuçları
- Kaydettiği kelimeler
- Tekrarlayan hata örüntüleri
- İçerik ilgileri ve gizlilik/kişiselleştirme tercihleri

Öneri kuralları:
- Her önerinin bir gerekçesi olmalı: “Son derste öğrendiğin ifadeyi tekrar etmek için”.
- Kullanıcı öneriyi gizleyebilmeli veya ilgi alanını değiştirebilmeli.
- Kişiselleştirme için gerekli olmayan hassas veriler toplanmamalı.
- İlk sürümde kurallar tabanlı öneriler yeterli olabilir; AI tabanlı öneri daha sonra ölçülebilir faydayla eklenmeli.

---

## 7. CEFR hikâye standardı ve içerik şeması

Aşağıdaki tablo, proje rehberindeki başlangıç önerisini korur. Editör gerekçeli biçimde ayarlayabilir.

| Seviye | Hikâye uzunluğu | Kelime havuzu | Cümle / yapı | Dilbilgisi odağı | TTS hızı | Video süresi |
|---|---:|---:|---|---|---|---|
| A1 | 80–150 kelime | ~500 temel kelime | ≤8 kelime; tek yan cümle yok | Present simple, *to be*, *there is/are*, *can* | 100–110 kelime/dk | 30–60 sn |
| A2 | 150–300 kelime | ~1.000 | ≤12 kelime; *and/but/because* | Past simple, *going to*, karşılaştırma | 115–125 | 60–90 sn |
| B1 | 300–600 kelime | ~2.000 | Bağlaçlı birleşik cümle | Present perfect, 1. tip koşul, *used to* | 130–140 | 1,5–3 dk |
| B2 | 500–900 kelime | ~4.000 | Karmaşık cümle serbest | Edilgen, dolaylı anlatım, 2./3. tip koşul | 145–155 | 3–5 dk |
| C1 | 800–1.500 kelime | Geniş; deyim ve eşdizimler | Doğal, üslup çeşitliliği | Inversion, cleft, modal nüansları, deyimler | 160+ | 4–8 dk |

Kurallar:
- Hikâyede seviyenin üstündeki kelimeler sözlükte açıklanır.
- A1–A2 seviyesinde bilinmeyen kelime oranı %5'i geçmemelidir.
- Türk öğrencilerde sık görülen hatalar (ör. “I am agree”, üçüncü tekil şahıs `-s`, `the` kullanımı) uygun içeriklerde bağlam içinde ele alınabilir; hata öğretimi yanlış biçimi pekiştirmemeli.
- Her içerik güvenlik ve telif kontrolünden geçer.
- 30 saniyelik kesit uzun hikâyeden çıkarılır; yeni bir bağımsız hikâye gibi yazılmaz.

### 7.1 İçerik dosya yapısı

Örnek: `icerik/A1-001-lost-cat/`

```text
story.en.md        # İngilizce metin, sahne sahne
story.tr.md        # İnsan kontrolünden geçmiş Türkçe çeviri
glossary.md        # Seviye üstü kelimeler, karşılık ve örnek
quiz.md            # 3–5 soru ve cevap anahtarı
PROMPTS.md         # Prompt/model/parametre/tarih/job ID/kredi
audio/             # TTS
images/            # Sahne görselleri
clips/             # Video parçaları
subs/              # en.srt, tr.srt, gerekiyorsa .ass
final/             # uygulama ve sosyal medya çıktıları
```

### 7.2 İçerik yayın kontrol listesi

- [ ] CEFR seviyesi ve hedef dilbilgisi uygun
- [ ] Kelime ve cümle uzunluğu kılavuza uygun
- [ ] A1–A2 bilinmeyen kelime oranı kontrol edildi
- [ ] Türkçe çeviri insan tarafından gözden geçirildi
- [ ] Sözlük anlamları bağlama uygun
- [ ] Quiz cevapları doğrulandı
- [ ] TTS telaffuzu ve hız seviyeyle uyumlu
- [ ] Altyazı senkronizasyonu kontrol edildi
- [ ] Görsel-sahne uyumu doğrulandı
- [ ] Ses seviyesi, boşluklar ve geçişler kontrol edildi
- [ ] Telif, marka, kişi benzerliği ve yaş uygunluğu kontrol edildi
- [ ] AI ile üretildi bilgisi gerektiği yerde mevcut
- [ ] Prompt ve maliyet kaydı mevcut
- [ ] Mobilde portre/yatay oranlar ve güvenli alanlar kontrol edildi
- [ ] Editör onayı kaydedildi

---

## 8. Görsel/video üretim hattı ve maliyet kontrolü

### 8.1 Önerilen varsayılan yol

1. Seviye kısıtlı hikâye taslağı üret.
2. Hikâye, kelime ve dilbilgisi denetimi.
3. Sahne listesi ve görsel prompt'ları.
4. Görsel üretimi.
5. TTS üretimi ve kelime/ses hizalaması.
6. Sahne zamanları ve altyazı üretimi.
7. Ken Burns veya benzeri yerel kurgu ile video üretimi.
8. Otomatik kalite kontrolleri.
9. İnsan editör onayı.
10. Yayına alma.

Proje rehberinde belirtilen maliyet yaklaşımı korunur: varsayılan olarak görseller + yerel Ken Burns kurgusu + TTS + altyazı; gerçek video klipler yalnızca seçili sahnelerde. Bu yaklaşım güncel fiyat garantisi değildir; üretimden önce o anki gerçek maliyet hesaplanmalıdır.

### 8.2 videoGenerator'dan yararlanma

Önce şu sınıflar ve belgeler okunmalı:
- `service/StoryWriter`
- `service/SceneImageService`
- `service/TranslationService`
- `api/ElevenLabsClient`
- `processor/SceneTimer`
- `processor/SubtitleRenderer`
- `processor/KenBurnsRenderer`
- `processor/AudioProcessor`, `FFmpegWrapper`
- `job/JobPipeline`, `Job`, `JobStore`
- `job/BudgetGuard`, `CostTracker`
- `channel/ChannelProfile`
- `web/BackofficeServer`
- `CLAUDE.md`, `README.md`, `thoughts/`

Kurallar:
- Önce oku, sonra uygun desenleri taşı.
- HiVelzon Spring Boot 4 mimarisine göre uyarlama yap; saf Java SE sınıflarını otomatik olarak bağımlılık kabul etme.
- Kod taşınırsa kaynak dosya/sınıf ve değişiklik gerekçesi kaydedilir.
- İki repository arasında runtime bağımlılığı kurulmaz.
- `videoGenerator` üzerinde değişiklik veya oradan dış yayın için ayrıca kullanıcı onayı gerekir.
- Çalışan `videoGenerator` JVM'i etkileyebilecek `mvn package` gibi işlemler bu oturumda yapılmaz.

### 8.3 Higgsfield üretim kontrolü

Her ücretli üretimden önce:
1. Model ve parametreler seçilir.
2. `generate cost` veya güncel maliyet tahmin yöntemi çalıştırılır.
3. Tekli/toplu işin toplam maliyeti gösterilir.
4. Kullanıcıdan açık onay alınır.
5. Aylık harcama tavanı kontrol edilir.
6. Onaydan sonra üretim başlatılır.
7. Gerçek harcama ve job bilgileri kaydedilir.

`PROMPTS.md` kaydı:
- içerik ID
- prompt ve prompt sürümü
- model/versiyon
- parametreler
- oluşturma tarihi
- job ID
- tahmini maliyet
- gerçek harcanan kredi
- kullanıcı onayı referansı
- üretilen dosya yolları
- editör değerlendirmesi
- telif/AI açıklama kontrolü

Maliyet kontrolleri:
- Aylık tavanı konfigürasyondan oku; kod içine sabit gömme.
- Tavan yoksa ücretli üretimi varsayılan olarak kapalı tut.
- Aynı içerik için mevcut dosya varsa yeniden üretme.
- Yeniden denemelerde idempotency kullan.
- Yarım kalan işleri kaldığı adımdan sürdür.
- Kredi azaldığında kullanıcıya bir kez uyarı göster; sürekli plan yükseltme mesajı verme.
- Maliyet/servis verisi mevcut değilse tahmin uydurma; kullanıcıdan veya sağlayıcıdan güncel fiyatı doğrula.

---

## 9. Teknik mimari

### 9.1 Üst düzey yapı

```text
Flutter iOS / Android
        |
        | HTTPS + JSON API
        v
Spring Boot 4 backend
  ├── Authentication & Consent
  ├── User Profile & Learning Goals
  ├── Course / Story / Lesson Catalog
  ├── Video Metadata & Playback Progress
  ├── Vocabulary & Review
  ├── Quiz & Learning Progress
  ├── Speaking Sessions & Feedback
  ├── Recommendation Rules
  ├── Content Review / Publishing
  ├── Usage Quota & Cost Guard
  ├── Audit / Account Deletion
  └── Observability
        |
        +---- PostgreSQL
        +---- Object Storage / CDN (video, audio, images)
        +---- AI / TTS / speech providers via provider adapters
        +---- Background job runner (when required)
```

### 9.2 Mimari ilkeler

- Başlangıçta modüler monolit tercih edilebilir; mikroservisler yalnızca ayrı ölçekleme veya bağımsız dağıtım ihtiyacı kanıtlanınca değerlendirilir.
- Controller katmanı HTTP doğrulama/yanıtıyla sınırlı; iş kuralları servis katmanında.
- DTO ile domain/persistence entity ayrımı korunur.
- Veritabanı migration'ları sürümlenir.
- Harici AI sağlayıcıları için arayüz/adaptör kullanılır; sağlayıcıya özel kod domain katmanına yayılmaz.
- Sağlayıcı anahtarları yalnızca sunucu tarafında tutulur; mobil uygulamaya konmaz.
- Video dosyaları PostgreSQL içinde blob olarak tutulmaz; nesne depolama/CDN kullanılır.
- Üretim işleri kuyruk/arka plan göreviyle yürütülür; API isteği boyunca uzun AI üretimi bekletilmez.
- İşler idempotent olmalı; tekrar çağrılar çift ücret/çift yayın oluşturmamalı.
- Her harici ücretli çağrı öncesi quota ve bütçe kontrolü yapılır.
- Hassas veriler loglara yazılmaz.

### 9.3 Önerilen backend modülleri

1. `identity`: kullanıcı, oturum, onay, hesap silme
2. `profile`: hedefler, seviye, ilgi alanları
3. `content`: hikâye, ders, sahne, video/audio metadata
4. `learning`: ilerleme, quiz, kelime listesi, tekrar
5. `speaking`: oturum, tur, transkript, geri bildirim, kota
6. `feed`: kısa video seçimi ve kullanıcı tercihleri
7. `recommendation`: kural tabanlı öneriler
8. `admin`: içerik inceleme ve yayın
9. `generation`: içerik üretim işleri, prompt kaydı, maliyet
10. `audit`: denetim olayları ve erişim kayıtları

Bu modüller ilk aşamada aynı uygulama içinde paketler olarak kalabilir.

---

## 10. Veri modeli taslağı

Aşağıdaki model başlangıç taslağıdır; mevcut repo incelendikten ve kullanıcı planı onayladıktan sonra kesinleştirilmelidir.

### 10.1 Temel tablolar

> *Not (2026-10-12, H-023): Bu listede `refresh_tokens` (oturum yenileme) tablosu ve kullanıcı rolleri (kullanıcı / editör / yönetici) yok. H-037'de (backend çekirdek) tanımlanacak.*

**`users`**
- `id` UUID
- `email` veya mevcut kimlik doğrulama yönteminin gerekli alanı
- `status` (ACTIVE, DELETION_PENDING, DELETED, SUSPENDED) — *Not (2026-10-12): `docs/IS-PLANI.md` §9.4'te `PENDING_DELETION` yazıyor; tek ad H-037'de seçilecek.*
- `created_at`, `updated_at`, `last_login_at`
- gerekli olmayan kişisel alanları ekleme

**`user_consents`**
- `id`, `user_id`
- `consent_type`, `document_version`
- `granted_at`, `withdrawn_at`
- `locale`, `source`
- onay metni sürümünün doğrulanabilir referansı

**`user_profiles`**
- `user_id`
- `current_level` (A1–C1)
- `goal_type`
- `daily_goal_minutes`
- `preferred_subtitle_mode`
- `interests` (kontrollü liste; gereksiz serbest metin toplama)
- `created_at`, `updated_at`

**`stories`**
- `id`, `slug`, `title`
- `cefr_level`, `topic`, `status`
- `word_count`, `estimated_duration_seconds`
- `learning_objectives`
- `translation_status`, `review_status`
- `content_version`, `published_at`
- `ai_generated_disclosure`, `rights_review_status`

**`story_scenes`**
- `id`, `story_id`, `scene_order`
- `text_en`, `text_tr`
- `audio_asset_id`, `image_asset_id`, `start_ms`, `end_ms`

**`assets`**
- `id`, `asset_type`, `storage_key`, `mime_type`
- `duration_ms`, `width`, `height`, `file_size_bytes`
- `checksum`, `created_at`
- erişim/retention bilgileri

**`lessons`**
- `id`, `story_id`, `lesson_type`, `status`
- `estimated_minutes`, `created_at`

**`quizzes` / `quiz_questions` / `quiz_attempts`**
- soru, seçenekler, doğru cevap, açıklama
- kullanıcı denemesi, puan, tamamlanma zamanı
- kullanıcıya ait öğrenme verisi için retention kuralı

**`vocabulary_items`**
- `id`, `lemma`, `part_of_speech`, `level`
- `definition_tr`, `example_en`, `example_tr`
- `review_status`

**`user_vocabulary`**
- `user_id`, `vocabulary_item_id`
- `saved_at`, `review_due_at`, `last_result`, `review_count`

**`learning_progress`**
- `user_id`, `lesson_id`
- `status`, `last_position_seconds`, `completed_at`
- `quiz_score`, `updated_at`

**`short_clips`**
- `id`, `story_id`, `asset_id`
- `start_ms`, `end_ms`, `hook_text`, `learning_objective`
- `status`, `review_status`, `published_at`

**`speaking_scenarios`**
- `id`, `slug`, `title`, `cefr_level`, `goal`
- `system_prompt_version`, `status`
- `expected_phrases`, `safety_profile`

**`speaking_sessions`**
- `id`, `user_id`, `scenario_id`
- `started_at`, `ended_at`, `status`
- `quota_units`, `provider`, `model`
- `feedback_json` veya normalize edilmiş alt tablo
- `retention_until`

**`speaking_turns`**
- `id`, `session_id`, `turn_index`
- `speaker_type`, `transcript`, `audio_asset_id` (yalnızca gerekli ve izinliyse)
- `created_at`
- ses saklanmıyorsa yalnızca geçici işleme kullan; varsayılan olarak ham sesi kalıcı saklama.

**`usage_quotas`**
- `user_id`, `quota_type`, `period_start`, `period_end`
- `used_units`, `limit_units`
- eşzamanlı isteklerde atomik güncelleme

**`generation_jobs`**
- `id`, `content_id`, `job_type`, `status`, `step`
- `provider`, `model`, `prompt_version`
- `estimated_cost`, `actual_cost`, `external_job_id`
- `approved_by`, `approved_at`
- `started_at`, `completed_at`, `error_code`

**`audit_events`**
- `id`, `actor_id`, `event_type`, `occurred_at`
- IP/port/saat kaydı proje rehberinde öngörülmüştür; IP kişisel veri kabul edilerek erişim ve saklama kısıtlanmalıdır.
- `metadata` alanında token, parola, ses transkripti veya hassas içerik bulunmamalı.

**`account_deletion_requests`**
- `id`, `user_id`, `requested_at`, `scheduled_delete_at`
- `cancelled_at`, `completed_at`, `status`

### 10.2 Veri modeli kuralları

- UUID veya mevcut projede standart olan ID yaklaşımı seçilir; karma kullanım yapılmaz.
- Zaman damgaları UTC saklanır, kullanıcıya yerel saatle gösterilir.
- Silme, anonimleştirme ve yasal saklama istisnaları tablo bazında belgelenir.
- Transkript, ses ve analitik veriler için ayrı retention kararları alınır.
- Serbest JSON yalnızca değişken sağlayıcı çıktıları gibi uygun yerlerde kullanılır; temel ilişkiler JSON içine saklanmaz.
- İndeksler gerçek sorgulara göre eklenir.
- İlişkisel kısıtlar ve unique constraint'ler idempotency'yi destekler.

---

## 11. API sözleşmesi taslağı

Kesin URL, hata formatı ve authentication biçimi mevcut repo incelendikten sonra standardize edilmelidir. Aşağıdaki örnekler tartışma amaçlıdır.

| Method | Örnek endpoint | Amaç |
|---|---|---|
| `GET` | `/api/v1/me` | Kullanıcı profilini getir |
| `PATCH` | `/api/v1/me/profile` | Hedef/seviye/tercih güncelle |
| `GET` | `/api/v1/content/stories?level=A1` | Seviyeye göre hikâye kataloğu |
| `GET` | `/api/v1/content/stories/{id}` | Hikâye ve sahne metadata'sı |
| `POST` | `/api/v1/lessons/{id}/start` | Ders oturumu başlat |
| `PATCH` | `/api/v1/lessons/{id}/progress` | Video/metin ilerlemesini kaydet |
| `POST` | `/api/v1/quizzes/{id}/attempts` | Quiz yanıtlarını gönder |
| `GET` | `/api/v1/me/vocabulary` | Kaydedilen kelimeleri getir |
| `POST` | `/api/v1/me/vocabulary` | Kelime kaydet |
| `POST` | `/api/v1/speaking/sessions` | Kota kontrolü yapıp konuşma oturumu başlat |
| `POST` | `/api/v1/speaking/sessions/{id}/turns` | Kullanıcı konuşma turunu işle |
| `POST` | `/api/v1/speaking/sessions/{id}/finish` | Oturumu kapat ve geri bildirim oluştur |
| `GET` | `/api/v1/speaking/quota` | Günlük kalan kota |
| `GET` | `/api/v1/feed/clips` | Kısa video akışı |
| `POST` | `/api/v1/clips/{id}/save` | Klip/ifade kaydet |
| `POST` | `/api/v1/account/deletion-request` | Hesap silme talebi |
| `POST` | `/api/v1/account/deletion-request/cancel` | 30 günlük pencerede talebi geri al |

### 11.1 API gereksinimleri

- Tüm özel endpoint'lerde authentication ve authorization.
- İstek gövdelerinde boyut ve format sınırı.
- Rate limit ve kullanıcı başına quota.
- Hatalar sabit, makinece okunabilir kodlarla dönmeli (`QUOTA_EXCEEDED`, `CONTENT_NOT_AVAILABLE`, `VALIDATION_ERROR` vb.).
- İstemciye stack trace, sağlayıcı gizli bilgisi veya prompt içeriği dönülmemeli.
- Ücretli AI sağlayıcı çağrıları idempotency key veya eşdeğer tekrar korumasıyla yapılmalı.
- Video URL'leri süreli imzalı URL veya uygun CDN erişimiyle sunulabilir; URL güvenliği mevcut depolama tasarımına göre belirlenmeli.
- API versiyonlama ve geriye uyumluluk ilkesi dokümante edilmeli.

---

## 12. Güvenlik, gizlilik ve çocuk kullanıcı güvenliği

Bu bölüm teknik gereksinim listesidir; hukuk görüşü değildir. KVKK, çocuklara yönelik hizmetler, App Store/Google Play politikaları ve ilgili ülkelerdeki yükümlülükler yayın öncesi uzman tarafından doğrulanmalıdır.

### 12.1 Veri minimizasyonu

- Sadece işlev için gerekli veriyi topla.
- Mikrofon iznini konuşma özelliği başlatılırken ve bağlamı açıklanarak iste.
- Mikrofon izni olmadan temel hikâye/video özellikleri çalışmalı.
- Ham ses varsayılan olarak kalıcı saklanmamalı. Saklanması gerekiyorsa amaç, açık rıza/hukuki dayanak, süre, silme ve erişim politikası ayrı belirlenmeli.
- Konuşma transkriptleri kişisel veri içerebilir; erişimi kısıtla ve retention süresi belirle.
- IP/port/saat gibi audit kayıtları için erişim rolü, amaç ve saklama süresi tanımla.
  - *Karar (H-095, hukukçu cevabı 2026-10-21):* Amaç güvenlik ve onay ispatı (meşru menfaat, 5/2-f; taslak). Süre: olay tarihinden 2 yıl; hesap silinince boşaltılmaz. Süre dolunca günlük iş siler (`RecordRetentionJob`, `hivelzon.retention.records`). İçerik onay akışı satırlarında (`CONTENT_*`) editör geçmişi kalır, yalnızca IP/port/tarayıcı özeti boşaltılır.
- Telemetride e-posta, token, ses, tam transkript ve serbest kullanıcı metni gibi hassas alanlar gönderme.

### 12.2 Hesap silme

- Kullanıcı silme talebi oluşturabilir.
- Talep sonrası 30 günlük geri alınabilir pencere gösterilir.
- Bu pencere içinde talep iptal edilebilir.
- Süre bitince kullanıcı hesabı ve ilişkili veriler belgelenmiş politikaya göre silinir veya anonimleştirilir.
- Yasal olarak tutulması gereken kayıtlar varsa, neden ve süre açıkça belgelenir.
  - *Karar (H-095):* Kalıcı silmede hesap, e-posta, ad, doğum yılı ve bütün öğrenme verisi silinir. **Rıza kayıtları** (metin sürümü, saat, IP, port) ve **denetim satırları** ispat için kalır; hesabın eski kimliği mezar taşı olarak `account_tombstones`'a yazılır (kişiyle bağ kurulamaz). Rızalar silinmeden 2 yıl sonra, denetim satırları olay tarihinden 2 yıl sonra silinir (V16).
- Silme işlemi idempotent olmalı ve arka plan işi başarısız olursa tekrar denenebilmelidir.
- Kullanıcıya talebin durumu gösterilir.

### 12.3 İçerik ve konuşma güvenliği

- Hedef yaş 13+; yaş uygunluğu mağaza ve hukuk değerlendirmesiyle doğrulanır.
- Şiddet, cinsellik, siyaset, din, gerçek marka, ünlü benzerliği ve telifli karakterler üretim kurallarıyla engellenir.
- AI öğretmeni romantik, manipülatif veya kullanıcıyı kendisine bağımlı kılan dil kullanmamalı.
- Konuşma modeli eğitim bağlamında kalmalı; tehlikeli/uygunsuz taleplerde güvenli yanıt vermeli.
- Kullanıcıya AI ile konuştuğu açıkça bildirilir.
- Kullanıcı tarafından girilen metinler prompt injection olarak ele alınabilir; sistem talimatları güvenilir veriyle ayrılmalı.
- Yayın öncesi editör incelemesi zorunludur.

### 12.4 Kimlik doğrulama ve erişim

- Parolalar varsa modern, güçlü hash algoritması kullanılır; asla düz metin saklanmaz.
- Token ve anahtarlar güvenli depoda tutulur; loglarda maskelenir.
- Admin rolleri least privilege yaklaşımıyla tanımlanır.
- Admin aksiyonları audit edilir.
- Rate limit, brute-force koruması ve hesap kurtarma akışı planlanır.
- Mobil istemciye AI sağlayıcı anahtarı koyulmaz.

---

## 13. Erişilebilirlik, performans ve dayanıklılık

### 13.1 Erişilebilirlik

- Metin boyutu işletim sistemi tercihlerine uyum sağlamalı.
- Video ve ses içeriğinde altyazı bulunmalı.
- Renk tek başına doğru/yanlış veya ilerleme işareti olmamalı.
- Ekran okuyucu etiketleri ve mantıklı odak sırası sağlanmalı.
- Mikrofon kaydı başlat/durdur kontrolleri açık ve erişilebilir olmalı.
- Hata mesajları anlaşılır, eyleme dönük ve Türkçe olmalı.

### 13.2 Performans hedefleri (öneri, testle doğrulanacak)

- Ana ekranın temel içeriği tipik mobil bağlantıda hızlı görünmeli; gerçek hedef cihazlarda ölçüm alınmalı.
- Sayfalama ve thumbnail kullanımıyla kısa video akışında gereksiz büyük dosya indirme engellenmeli.
- Video oynatma sırasında yükleme durumu, yeniden deneme ve bağlantı hatası gösterilmeli.
- İçerik metadata'sı önbelleğe alınabilir; kullanıcıya ait hassas veri ortak önbelleğe girmemeli.
- Konuşma oturumu başlatma, transkripsiyon ve AI yanıt süresi ayrı ayrı ölçülmeli.
- AI sağlayıcı kesintisinde kullanıcıya anlaşılır hata gösterilmeli; sonsuz spinner olmamalı.
- Retry stratejisi exponential backoff ve üst sınır içermeli; ücretli istekler kontrolsüz tekrar edilmemeli.

### 13.3 Gözlemlenebilirlik

Ölçülecek operasyonel metrikler:
- API p50/p95 yanıt süresi ve hata oranı
- Video başlatma başarısı ve oynatma hatası
- AI konuşma turu yanıt süresi/hata oranı
- Kullanıcı başına AI maliyeti ve günlük kota kullanımı
- İçerik üretim işlerinin başarı/başarısızlık durumu
- Yayın öncesi editör bekleme süresi
- Hesap silme işlerinin tamamlanma oranı

Loglarda token, parola, tam ses verisi, gereksiz kişisel veri veya sağlayıcı gizli bilgisi bulunmamalı.

---

## 14. Analitik ve ürün başarı ölçümleri

Analitik, kullanıcıyı gereksiz izlemeye değil ürün kalitesini ölçmeye hizmet etmeli. Kullanıcıya uygun gizlilik bilgisi verilmeli ve mümkün olduğunda anonim/toplulaştırılmış ölçümler kullanılmalı.

### 14.1 MVP ölçümleri

- Onboarding tamamlama oranı
- İlk ders başlatma ve tamamlama oranı
- İlk 7 gün içinde tekrar öğrenme oturumu
- Hikâye/video sonrası quiz tamamlama oranı
- Kelime kaydetme ve tekrar etme oranı
- Kısa klipten tam derse geçiş oranı
- Konuşma pratiği başlatma/tamamlama oranı
- AI konuşma geri bildirimi sonrası aynı konuya tekrar dönüş
- Kullanıcı başına günlük/aylık AI maliyeti
- Kota nedeniyle başarısız olan oturum oranı
- İçerik kalite hatası ve kullanıcı bildirimi oranı

### 14.2 Kuzey yıldızı metriği önerisi

**Haftalık anlamlı öğrenme oturumu tamamlayan aktif kullanıcı sayısı.**

“Anlamlı oturum” tanımı sadece video izleme değil; örneğin bir ders/hikâye + quiz veya konuşma oturumu + geri bildirim gibi öğrenme eylemi içermelidir. Kesin tanım, MVP verisi ve kullanıcı araştırması sonrası onaylanmalıdır.

### 14.3 Kaçınılacak metrik tuzakları

- Sadece günlük açılış veya ekran süresini başarı saymak
- Kullanıcıyı suçlayan streak/seri mesajları
- AI geri bildirimini doğrulamadan skorları başarı metriği olarak kullanmak
- Gereksiz kişisel veriye dayalı kişiselleştirme
- Kısa video akışında sonsuz kaydırmayı öğrenme hedefinin önüne geçirmek

---

## 15. Test stratejisi

### 15.1 Backend

- Unit test: CEFR filtreleri, kota hesaplama, hesap silme, quiz puanlama, maliyet guard.
- Integration test: PostgreSQL migration, repository, transaction ve concurrency.
- API test: auth, yetkilendirme, validation, rate limit, hata şeması.
- Provider adapter test: gerçek ücretli çağrı yerine mock/fake; entegrasyon testi açıkça işaretlenmeli.
- Idempotency test: aynı üretim isteğinin iki kere maliyet oluşturmaması.
- Quota concurrency test: eşzamanlı isteklerde limitin aşılmaması.
- Deletion test: 30 günlük geri alma ve süresi biten silme işi.

### 15.2 Flutter

- Widget test: loading/error/empty/success durumları.
- Navigation test: onboarding → ders → quiz → sonuç.
- Video oynatıcı: ağ kesilmesi, yeniden deneme, altyazı ve ekran yönü.
- Mikrofon izinleri: reddedildi, sonradan verildi, cihazda destek yok.
- Erişilebilirlik testleri ve küçük ekran kontrolü.
- iOS ve Android gerçek cihaz/simülatör smoke testleri.

### 15.3 İçerik kalite testleri

- CEFR seviye denetimi
- Bilinmeyen kelime oranı
- Cümle uzunluğu ve dilbilgisi hedefi
- İngilizce/Türkçe anlam tutarlılığı
- TTS metni ve altyazı zamanlaması
- Sahne-görsel uyumu
- Quiz doğru cevap ve açıklama kontrolü
- Güvenlik/telif kontrolü
- Video formatı, ses seviyesi ve dosya bütünlüğü

---

## 16. Yol haritası ve teslimatlar

### Faz 0 — Depo keşfi ve plan

Teslimatlar:
- Repo ağacı ve mevcut uygulama durumu
- Mevcut `docs/IS-PLANI.md` ve `yapilacaklar/IS-SIRASI.md` değerlendirmesi
- `videoGenerator` koduna dokunmadan incelenecek sınıfların raporu
- Mevcut teknolojilerin doğrulanması
- Açık kararlar, riskler ve bağımlılıklar
- Güncellenmiş `docs/IS-PLANI.md`
- İş kalemleri: `H-<3 hane>-<kisa-baslik>.md`

**Kabul:** Kod değişikliği yok; plan ve riskler kullanıcıya sunulmuş; kullanıcı açık onay vermiş.

### Faz 1 — Teknik temel

- Flutter uygulama iskeleti
- Spring Boot 4 iskeleti
- PostgreSQL ve migration yaklaşımı
- Ortam konfigürasyonu ve secret yönetimi
- Auth/consent/account lifecycle tasarımı
- CI ve temel testler
- Hata/log/health check

**Kabul:** Yerel geliştirme yönergesi, migration ve smoke test doğrulanmış.

### Faz 2 — İçerik kataloğu ve hikâye oynatımı

- Hikâye ve asset modeli
- Admin onay durumu
- Hikâye kataloğu
- Video/metin/altyazı oynatımı
- Kelime açıklaması ve kaydetme
- Quiz ve ilerleme

**Kabul:** En az bir editör onaylı örnek hikâye A1–C1 veri yapısına uygun biçimde uçtan uca çalışır; örnek içeriğin insan kontrolü kaydedilmiştir.

### Faz 3 — Kısa video akışı

- Klip metadata ve yayın durumu
- Sayfalı akış
- Klip kaydetme ve tam hikâyeye geçiş
- Telemetri ve medya performansı

**Kabul:** Klip yalnızca onaylı içerikten gelir; kullanıcı öğrenme eylemine geçebilir; ağ hataları yönetilir.

### Faz 4 — AI konuşma pratiği

- Senaryo kataloğu
- Kota ve sağlayıcı adaptörü
- Ses/transkript işleme
- Oturum yönetimi
- Oturum sonrası geri bildirim
- Gizlilik ve retention
- Maliyet dashboard/raporu

**Kabul:** Kota aşımı engellenir, kullanıcıya kalan kota gösterilir, sağlayıcı hatası yönetilir, hassas veriler loglanmaz ve maliyet kaydı test edilir.

### Faz 5 — Kişiselleştirme ve yayın hazırlığı

- Kural tabanlı öneriler
- Günlük hedef ve kelime tekrarı
- Güvenlik/erişilebilirlik testleri
- Store listing ve gizlilik belgeleri
- Beta kullanıcı testi
- Performans ve maliyet değerlendirmesi

**Kabul:** Kritik hatalar giderilmiş, mağaza gereksinimleri ve hukuki metinler gözden geçirilmiş, yayın kararı kullanıcı tarafından onaylanmıştır.

---

## 17. Codex için çalışma talimatları

Codex bu belgeyi doğrudan kodlama emri olarak değil, planlama ve gereksinim kaynağı olarak kullanmalıdır.

### İlk görev — sadece inceleme ve plan

1. Çalışma dizini ve git durumunu incele. Mevcut değişiklikleri ezme veya sıfırlama.
2. `docs/IS-PLANI.md` dosyasını oku.
3. **Önce** `yapilacaklar/IS-SIRASI.md` dosyasını oku; mevcut sırayı, açık işleri, devam eden işleri ve son doğrulanmış durumu öğren.
4. `yapilacaklar/`, `devam-edenler/`, `bitenler/`, `hatalar/`, `ogrenilenler/` klasörlerini mevcut yönergeye göre incele.
5. Mevcut Flutter, Spring Boot, PostgreSQL, test, CI ve konfigürasyon yapısını doğrula; bu belgede varsayılan olan ama repoda bulunmayan şeyi varmış gibi raporlama.
6. Kimlik doğrulama, onay kayıtları, audit ve 30 günlük geri alınabilir silme için tasarım önerisi hazırla.
7. `videoGenerator` için yalnızca ilgili `README.md`, `CLAUDE.md`, `thoughts/` ve yukarıdaki sınıfları oku. Bu projeyi değiştirme; paketleme/çalışan JVM'i etkileyen işlem yapma.
8. Güvenlik, KVKK, çocuk kullanıcılar, AI maliyeti, içerik moderasyonu ve medya saklama açısından risk listesi hazırla.
9. Bu belge ile mevcut repo arasında çelişki varsa sessizce karar verme; “mevcut durum / rehber kararı / önerilen çözüm” şeklinde raporla.
10. `docs/IS-PLANI.md` için önerilen güncellemeyi ve H-numaralı iş listesini hazırla. Repo kurallarına uygun dosya yerleşimi öner.
11. **Kod, migration, dış servis çağrısı, Higgsfield üretimi veya yayın işlemi yapma.**
12. Planı kullanıcıya sun ve açık onay bekle.

### Kullanıcı onayından sonra

- İşleri tek tek, küçük ve doğrulanabilir parçalara böl.
- Her işin kapsamı, kabul kriteri, test komutu ve geri alma notu olsun.
- İlgisiz refactor yapma.
- Her tamamlanan işi test et; kanıtı olmadan `bitenler/` klasörüne taşıma.
- İş durumu değiştiğinde `IS-SIRASI.md` ve ilgili H dosyasını güncelle.
- Secret, token, kullanıcı ses kaydı veya hassas transkripti loglama.
- Ücretli üretim/AI çağrısından önce maliyet ve kullanıcı onayı kontrolünü atlama.
- Harici yayın gibi geri alınması zor işlemlerde ayrıca onay al.
- Gerçek test sonuçlarını yaz; çalıştırılmayan testi geçmiş gibi gösterme.

---

## 18. Açık kararlar — plan onayında cevaplanacaklar

Bu noktalar proje rehberinde kesinleşmediği için varsayımla kapatılmamalıdır.

1. **Günlük AI konuşma kotası:** Kaç dakika/oturum/tur? Kullanıcı bazında hangi birimle ölçülecek?
2. **AI sağlayıcısı:** Konuşma, ASR, TTS ve metin üretiminde hangi sağlayıcılar kullanılacak? Sağlayıcı seçimi kalite, Türkçe destek, veri işleme koşulları ve gerçek maliyetle doğrulanmalı.
3. **Ham ses saklama:** Hiç saklanmayacak mı, yoksa yalnızca kullanıcı açıkça kaydederse mi saklanacak?
4. **Kayıt zorunluluğu:** Kataloğu misafir olarak gezme mümkün mü? Öğrenme ilerlemesini kaydetmek için hangi aşamada hesap istenecek?
5. **Çevrimdışı kullanım:** MVP'de olacak mı?
6. **İçerik yönetim paneli:** Mevcut bir admin paneli var mı, yoksa MVP için basit bir panel mi gerekli?
7. **Medya depolama/CDN:** Mevcut Velzon altyapısı kullanılabilir mi? Maliyet, erişim ve retention şartları nedir?
8. **Günlük hedef ve bildirimler:** Varsayılan hedef, bildirim sıklığı ve kullanıcı kontrolü ne olacak?
9. **Kısa video akışı:** Otomatik oynatma varsayılanı, içerik sıralaması ve kullanıcı tercihleri nasıl olacak?
10. **Hukuki yaş kapsamı:** 13+ hedefi ve Türkiye/diğer pazarlar için yükümlülükler hukuk danışmanıyla doğrulanacak mı?
11. **AI değerlendirme kalitesi:** Konuşma puanlarının nasıl doğrulanacağı ve hangi metriklerin kullanıcıya gösterileceği.
12. **Ücretsiz kullanım bütçesi:** AI ve medya için aylık harcama tavanı, uyarı eşikleri ve bütçe sorumlusu.
13. **Uygulama adı/marka ve görsel kimlik:** Logo, renk, tipografi ve sabit AI öğretmen karakteri için onaylı tasarım var mı?
14. **Sosyal medya yayın kapsamı:** Bu ürün görevinde yalnızca uygulama içeriği mi hazırlanacak, yoksa sosyal medya yayını ayrı onaylı faz mı olacak?

---

## 19. MVP kabul kriterleri — genel kontrol listesi

MVP, aşağıdaki maddeler doğrulanmadan “tamamlandı” sayılmamalıdır.

### Ürün
- [ ] Kullanıcı A1–C1 seviyeleri arasından içerik seçebilir.
- [ ] Seviye ve öğrenme hedefine göre öneri görür.
- [ ] Hikâye metni, Türkçe destek, kelime listesi ve quiz çalışır.
- [ ] Video ilerlemesi kaydedilir ve devam edilebilir.
- [ ] 30 saniyelik klipten tam hikâyeye geçilebilir.
- [ ] AI konuşma oturumu senaryo ve kota kontrolüyle başlar.
- [ ] Oturum sonrası anlaşılır geri bildirim sunulur.
- [ ] Kota dolduğunda ücretsiz alternatif gösterilir.

### İçerik
- [ ] Her yayınlanmış hikâye editör onayına sahiptir.
- [ ] CEFR kalite kontrolü tamamlanmıştır.
- [ ] Türkçe çeviri insan kontrolünden geçmiştir.
- [ ] Altyazı/ses senkronizasyonu test edilmiştir.
- [ ] Prompt ve üretim maliyeti kaydı vardır.
- [ ] Telif ve güvenlik kontrolü yapılmıştır.

### Güvenlik ve gizlilik
- [ ] Auth ve admin yetkileri test edilmiştir.
- [ ] Mikrofon izni ve kullanım amacı açıkça belirtilir.
- [ ] Ham ses/transkript retention kararı uygulanır.
- [ ] Hesap silme talebi geri alınabilir pencereyi destekler.
- [ ] Secret veya kişisel veri loglara yazılmaz.
- [ ] AI maliyet tavanı ve kota kontrolü test edilmiştir.

### Teknik kalite
- [ ] DB migration'ları temiz ortamda uygulanabilir.
- [ ] Backend unit/integration testleri çalışır.
- [ ] Flutter loading/error/empty state test edilmiştir.
- [ ] iOS ve Android temel akışları smoke testten geçmiştir.
- [ ] Ağ kesintisi ve AI sağlayıcı hatası yönetilir.
- [ ] Kurulum ve yerel geliştirme yönergesi günceldir.

---

## 20. Kaynakça

Araştırma tarihi: **11 Ekim 2026**. Özellikler zamanla değişebilir; uygulama geliştirme veya yayın öncesinde resmî sayfalar yeniden kontrol edilmelidir. Rakiplerin ücretli/ücretsiz özellikleri HiVelzon için otomatik ürün kararı oluşturmaz.

1. Duolingo — Resmî ürün sayfası: https://www.duolingo.com/
2. Duolingo, Duocon 2025 ürün güncellemeleri: https://investors.duolingo.com/news-releases/news-release-details/duolingo-unveils-major-product-updates-turn-learning-real-world
3. Busuu — Mobil uygulama: https://www.busuu.com/en/mobile
4. Busuu — Conversations açıklaması (17 Şubat 2026): https://help.busuu.com/hc/en-us/articles/21862192336402-What-are-Busuu-Conversations-and-how-can-they-help-me-learn-a-language
5. Busuu — Premium özellik karşılaştırması: https://www.busuu.com/en/premium-plans
6. Babbel — Babbel Speak: https://support.babbel.com/hc/en-us/articles/25875402999826-Babbel-Speak
7. Babbel — Speech recognition: https://support.babbel.com/hc/en-gb/articles/19211305815570-Speech-recognition
8. ELSA Speak — Pronunciation feedback: https://elsaspeak.com/en/faqs/how-does-elsa-s-pronunciation-feedback-work
9. ELSA Speak — Speech Analyzer: https://elsaspeak.com/en/speech-analyzer
10. Speak — Resmî ürün sayfası: https://www.speak.com/
11. Cake — App Store sayfası: https://apps.apple.com/tr/app/cake-learn-english-korean/id1350420987
12. Beelinguapp — Resmî ürün sayfası: https://beelinguapp.com/
13. Beelinguapp — English course: https://beelinguapp.com/courses/learn-english

---

## Son not

Bu belge, mevcut HiVelzon rehberini temel alan genişletilmiş bir ürün/teknik şartname taslağıdır. Repo incelenmeden mevcut kod, altyapı, sağlayıcı seçimi veya dağıtım şekli hakkında kesin varsayım yapılmamalıdır. İlk teslimat kod değil, repo keşfi ve kullanıcı onayına sunulacak uygulanabilir plandır.
