# Hukukçuya sorular (tek liste)

> **Durum:** Taslak, 2026-10-21 (H-042). Henüz gönderilmedi.
> **Amaç:** hiVelzon'un yayından önce hukuk görüşü gereken bütün sorularını tek seferde iletmek. Her soru kısa bir bağlamla ve ilgili belgeye bağlantıyla yazıldı.
> **Cevaplar geldikçe:** her sorunun altına "Cevap (tarih)" eklenir. Kararı değiştiren cevap ilgili belgeye ve `CLAUDE.md` karar tablosuna da işlenir.

## Ürün hakkında kısa bilgi (hukukçu için)

- **hiVelzon**, Velzon Bilişim Teknolojileri Ltd. Şti.'nin yapay zekâ videolarıyla İngilizce öğreten mobil uygulamasıdır (iOS ve Android).
- **Ücret, reklam ve abonelik yok.** Yayın bölgesi yalnızca Türkiye (H-018).
- **Her yaş kullanabilir.** Uygulamanın tamamı **hesapsız** çalışır; öğrenme verisi telefonda kalır (H-009, H-002).
- **Hesap isteğe bağlıdır ve yalnızca 13 yaş ve üstü açabilir.** Hesapta yalnızca e-posta, doğum yılı, isteğe bağlı ad ve öğrenme ilerlemesi tutulur. Giriş e-postaya gelen tek kullanımlık kodla yapılır; parola yoktur (H-037).
- **Üçüncü taraf analitik, reklam ya da izleme kodu yok.** Ham ses ve konuşma metni saklanmaz.
- **Hukuk metinleri şu an yer tutucu.** Kullanım koşulları ve KVKK aydınlatma metni uygulamada "Taslak" işaretiyle duruyor. Yer tutucu bölümler: `mobile/lib/l10n/tr_strings.dart` → `AccountTexts.termsSections` / `privacySections`.

---

## 1. KVKK aydınlatma metni

**Bağlam:** Hesap açan kullanıcıdan şu bilgiler alınır:
- e-posta;
- doğum yılı (yaş kapısı için);
- isteğe bağlı ad;
- öğrenme ilerlemesi: defter, tekrar kayıtları, bölüm ilerlemesi, Hi'nin kural tabanlı notları;
- rıza kayıtları (metin sürümü ve saat);
- denetim kaydı: IP, port, saat ve tarayıcı bilgisinin özeti (hash).

Hesap açmayanın hiçbir bilgisi telefondan çıkmaz.

Veriler şimdilik yerelde; üretim sunucusu ve barındırma yeri H-044'te seçilecek. Yurt dışı aktarım ihtimali şu anda açık.

Belgeler: `docs/SARTNAME.md` §12, `CLAUDE.md` "Mühendislik ilkeleri" (veri minimizasyonu), `docs/HI-ASISTAN-VE-KOC.md`.

**Sorular:**
1. 6698 sayılı KVKK md. 10 ve Aydınlatma Yükümlülüğü Tebliği'ne uygun bir aydınlatma metnini bizim için yazar mısınız? Ya da taslağımızı gözden geçirir misiniz? Metin, uygulamanın "sen" diliyle ve sade Türkçeyle yazılabilir mi?
2. Bu işlemelerin her biri için doğru hukuki sebep nedir (md. 5/2-c sözleşme, 5/2-ç hukuki yükümlülük, 5/2-f meşru menfaat)? Hesap, eşitleme, rıza kaydı ve denetim kaydı için ayrı ayrı belirler misiniz? Açık rıza gereken bir işleme var mı?
3. İsteğe bağlı "yenilikleri e-postayla almak istiyorum" kutusu ticari elektronik ileti onayı sayılır mı? 6563 sayılı Kanun kapsamında İYS kaydı gerekir mi?
4. Sunucu yurt dışında (ör. AB) seçilirse KVKK md. 9 (2024 değişikliği) uyarınca standart sözleşme ve Kurul'a bildirim gerekir mi? Türkiye'de barındırmayı tercih etmemiz için hukuki bir gerekçe var mı?
5. VERBİS kaydı gerekir mi? Çalışan sayısı ve bilanço eşiği şirket için kesinleşince değerlendirilecek.
6. KVKK aydınlatmasına "Söyle alıştırmaları" için ayrı bir bölüm konacak (bkz. §4). Bu bölümde ne yazmalıyız?

## 2. Kullanım koşulları

**Bağlam:** Uygulama ücretsizdir. İçerik yapay zekâyla üretilir ve editör onayından geçer; uygulama bunu açıkça söyler. Seviye vaadi verilmez (K-08). Hesap 30 gün içinde geri alınabilir biçimde silinir.

Belgeler: `docs/SARTNAME.md` §5.5–5.6, §12.2; `CLAUDE.md` K-08, K-14.

**Sorular:**
1. Kullanım koşullarını bizim için yazar mısınız? Ya da taslağımızı gözden geçirir misiniz? Ücretsiz bir eğitim uygulaması için asgari başlıklar nelerdir (sorumluluğun sınırı, yapay zekâ içeriğinin doğruluğu, hesap kapatma, değişiklik bildirimi, uygulanacak hukuk ve yetkili mahkeme)?
2. 13–17 yaş bir kullanıcının koşulları "kabul etmesi" hukuken geçerli mi? Veli onayı ya da veliye bilgilendirme gerekir mi?
3. "Yapay zekâ ile üretilmiştir" açıklaması yeterli mi? Bu açıklama uygulama içinde bölüm başında kısa süre görünüyor, sosyal medya videolarına ise gömülü (K-14). Tüketici mevzuatı ya da reklam kurulu açısından ek bir yükümlülük var mı?
4. Metin sürümü değişince kullanıcıdan yeniden onay istemek gerekir mi, yoksa bildirim yeterli mi? Backend sürüm uyuşmazlığında `CONSENT_VERSION_OUTDATED` döndürüyor.

## 3. Yaş kuralları: 13 yaş altı hesapsız, 13–17 (H-002)

**Bağlam:** Her yaş uygulamayı kullanabilir.
- **13 yaş altı:** Uygulamanın tamamını hesapsız kullanır. Veri yalnızca cihazdadır; e-posta ve hesap yoktur.
- **Yaşın belirlenmesi:** Yalnızca doğum yılı sorulur. 13 yaş altında doğum yılı ne sunucuya gönderilir ne de saklanır. Cihaz yalnızca "hesabın açılabileceği yılı" hatırlar.
- **13–17 yaş:** Hesap açabilir. İleride gelecek yapay zekâ sohbetinde (v1) rehberli moddadır.
- **Serbest yapay zekâ sohbeti:** Yalnızca 18 yaş ve üstü için.
- **Keşfet:** 13–17 yaş için günlük 20 dakikalık varsayılan sınır vardır (K-15).

Belgeler: `CLAUDE.md` H-002, H-009; `docs/HI-ASISTAN-VE-KOC.md`; `docs/SARTNAME.md` §9, §12.

**Sorular:**
1. 13 yaş altı bir çocuğun uygulamayı hesapsız ve verisi yalnızca kendi telefonunda kalacak biçimde kullanması KVKK açısından "kişisel veri işleme" sayılır mı? Sayılırsa veli açık rızası gerekir mi?
2. Hesap için alt yaş sınırı olarak 13 yaşı uygun buluyor musunuz? Türk hukukunda ayırt etme gücü ve sınırlı ehliyet düşünüldüğünde 13–17 yaş için veli onayı şart mı?
3. Mağazalar ayrıca şart koyuyor: App Store "Kids" kategorisi ve Google Play "Families" politikası. Bunlar ebeveyn kapısı (parental gate) ve yaş beyanı gerektiriyor. Mağaza seçimimiz (H-043/H-044) için hukuki bir öneriniz var mı?
4. Yaş beyanı yalnızca doğum yılıyla alınıyor ve doğrulanmıyor. Bu yeterli bir özen sayılır mı?

## 4. Cihazda konuşma tanıma ve Apple izin metni (H-055)

**Bağlam:** "Söyle" alıştırmalarında kullanıcı İngilizce bir ifadeyi sesli söyler. Telefonun kendi konuşma tanıması bunu yalnızca **cihazda** yazıya çevirir ve beklenen ifadeyle karşılaştırır.
- Ses ve yazı **saklanmaz, hiçbir yere gönderilmez**. Cihaz cihazda tanımayı desteklemiyorsa özellik görünmez.
- Puan verilmez. Özellik bütün yaşlara açıktır.
- Mikrofon izni yalnızca özellik ilk kullanıldığında sorulur.

iOS izin pencerelerindeki metinler (`mobile/ios/Runner/Info.plist`):
- **Mikrofon:** "Söyle alıştırmalarında İngilizceyi sesli söylediğinde mikrofon kullanılır. Sesin bu telefonda yazıya çevrilir; kaydedilmez, hiçbir yere gönderilmez."
- **Konuşma tanıma:** "Söylediğin İngilizce yalnızca bu telefonda yazıya çevrilir ve beklenen ifadeyle karşılaştırılır. Ses ve yazı saklanmaz, hiçbir yere gönderilmez."

Belge: `docs/KONUSMA-ALISTIRMASI.md`.

**Sorular:**
1. Ses hiç kaydedilmiyor ve cihazdan çıkmıyor. Bu durumda 13–17 yaş (ve 13 yaş altı) kullanıcı için bu işleme KVKK kapsamında mı? Ses biyometrik veri sayılabilir mi? Kapsamdaysa hangi hukuki sebebe dayanmalı?
2. İşletim sisteminin konuşma tanıma hizmetini kullanıyoruz (Apple Speech, Android SpeechRecognizer). İşletim sistemi sağlayıcısının kendi işlemesi için aydınlatmada ne yazmalıyız?
3. Yukarıdaki iOS izin metinleri doğru ve yeterli mi? Önerdiğiniz bir değişiklik var mı?

## 5. Denetim kaydı: IP, port ve saat (SARTNAME §12.1)

**Bağlam:** Giriş, kayıt, rıza, hesap silme ve geri alma gibi güvenlik olayları `audit_log` tablosuna yazılır. Kayıtta şunlar bulunur:
- IP;
- kaynak port;
- saat;
- tarayıcı bilgisinin özeti (hash);
- istek kimliği;
- sabit bir eylem kodu.

Kayda e-posta, kod ya da belirteç yazılmaz. Hesap kalıcı silinince kullanıcıyla bağlantılı alanlar boşaltılır (kimlik, IP, port); yalnızca eylem ve saat kalır. Saklama süresi henüz tanımlı değil.

Belgeler: `docs/SARTNAME.md` §12.1, `backend/src/main/java/tr/velzon/hivelzon/audit/AuditService.java`.

**Sorular:**
1. 5651 sayılı Kanun ve ilgili yönetmelik hiVelzon'a uygulanır mı? Uygulanırsa hangi sıfatla (yer sağlayıcı, içerik sağlayıcı)? Bu durumda IP, port ve saat kayıtları ne kadar süre saklanmalı?
2. 5651 uygulanmıyorsa, güvenlik amaçlı denetim kaydı için ölçülü bir saklama süresi ne olabilir (ör. 6 ay, 1 yıl, 2 yıl)? Hukuki sebep meşru menfaat olabilir mi?
3. Hesap silinince IP ve port alanlarını hemen boşaltmak doğru mu? Yoksa yasal saklama süresi dolana kadar tutmamız mı gerekir?

## 6. 30 gün geri alınabilir silme ve saklanması gereken kayıtlar (SARTNAME §12.2)

**Bağlam:** Kullanıcı hesabını uygulamadan siler.
- **Geri alma penceresi:** 30 gün boyunca aynı e-postayla yeni kodla giriş yapıp geri alabilir. Bu sırada bütün oturumlar kapanır.
- **Kalıcı silme:** 30 gün sonunda hesap ve hesaptaki öğrenme verisi kalıcı silinir. İş idempotenttir.
- **Rıza kayıtları:** Yalnızca ekleme yapılabilen (append-only) bir tabloda tutulur; silme yalnızca kalıcı silme işinde açılır.
- **Denetim satırları:** Anonimleştirilerek kalır.
- **Telefondaki veri:** Kullanıcı ayrıca silmedikçe silinmez. Telefonda yalnızca "silme bekliyor" işareti (hesap kimliği ve tarih) kalır; e-posta tutulmaz.

Belgeler: `docs/SARTNAME.md` §12.2, `backend/.../user/AccountPurgeService.java`.

**Sorular:**
1. 30 günlük geri alma penceresi KVKK md. 7 ve Silme, Yok Etme veya Anonim Hale Getirme Yönetmeliği'ne uygun mu? Yönetmelikteki "talep halinde en geç 30 gün" süresiyle çelişir mi? Pencereyi kısaltmamız gerekir mi?
2. Hesap silindikten sonra yasal olarak saklamamız gereken bir kayıt var mı? Örneğin rıza kayıtları (ispat yükü), denetim kaydı (§5) ya da ticari elektronik ileti onayının ispatı. Varsa süresi nedir?
3. Rıza kaydını silmek yerine anonimleştirmek (kullanıcıyla bağını koparmak) yeterli mi?
4. Kişisel veri saklama ve imha politikası hazırlamamız gerekir mi? Gerekirse taslağını sizden alabilir miyiz?

## 7. Pilot onam metni (`docs/H-092-PILOT-KITI.md` §3)

**Bağlam:** İlk sürüm için iki aşamalı küçük bir kullanıcı pilotu yapılacak:
- **Aşama A:** Gözlemli görüşme, 45–60 dakika.
- **Aşama B:** Evde 7–14 gün kullanım.

Toplanan bilgiler:
- yazılı not;
- izin verilirse ekran görüntüsü;
- uygulama içinde olay türü, süre ve yardım kullanımı.

Ham ses, transkript ve serbest metin toplanmaz. Notlar katılımcı koduyla tutulur ve en geç 90 gün içinde silinir. 13–17 yaş için veli onayı ayrıca alınır. Onam metni taslak hâlinde kitte duruyor.

**Sorular:**
1. Onam metni KVKK açısından yeterli mi? Aydınlatma ile açık rızayı aynı metinde birleştirmek doğru mu, yoksa ayrı mı olmalı?
2. **90 günlük saklama süresi** uygun mu?
3. **Veri sorumlusu ve iletişim:** Metinde hangi bilgiler yazmalı (unvan, adres, e-posta, sorumlu kişi)? Bir irtibat kişisi atamamız gerekir mi?
4. 13–17 yaş katılımcı için veli onayı nasıl alınmalı (ıslak imza, e-posta onayı)? 13 yaş altı katılımcı alınabilir mi?
5. Ekran görüntüsünde katılımcının yüzü ya da kişisel bilgisi görünmeyecek. Yine de ayrı bir onay kutusu gerekli mi? Şu an ayrı kutu var.

## 8. Teyit gereken içerik lisansları (`docs/LISANS-RAPORU.md`)

**Bağlam:** Kelime seviyeleri için CEFR-J Wordlist v1.6 kullanılıyor. Lisansı "uygun atıfla ticari kullanım serbest" diyor. Ek olarak:
- **Octanove C1/C2:** CC BY-SA 4.0; ayrı veri seti olarak tutulması planlanıyor.
- **FSRS:** py-fsrs'ten (MIT) Dart'a taşındı.
- **EnglishPractice:** Kodundan (MIT) desenler uyarlandı; içeriği kullanılmadı.

Uygulamanın "Hakkında ve lisanslar" ekranında atıflar ve açık kaynak lisans metinleri var (H-042).

**Sorular:** `docs/LISANS-RAPORU.md` §8'deki 12 soru (S1–S12) olduğu gibi geçerli. Öncelikli olanlar:
1. **S2:** CC BY-SA kelime listesini uygulamaya gömmek. Share-alike yükümlülüğü neyi kapsar? Ayrı veri seti stratejisi yeterli mi? Mağaza dağıtımı "Effective Technological Measures" yasağıyla çelişir mi?
2. **S6:** CEFR-J'nin "uygun atıf" koşulu için uygulamadaki "Hakkında ve lisanslar" ekranındaki atıf ve veri dosyası başlığındaki atıf yeterli mi?
3. **S9:** MEB öğretim programı tema adlarını etiket olarak kullanmak serbest mi?
4. **S10:** Reklamsız ve ücretsiz bir şirket uygulaması "ticari" sayılır mı? Önerimiz, her durumda ticari varsaymak.
5. **S12:** MIT port için kaynak kodda ve Lisanslar ekranında MIT bildirimini korumak yeterli mi?

## 9. Bilgi için: ücretsiz ElevenLabs çıktıları (karar verildi)

**Bağlam:** Bölüm ve kitap seslendirmesinin bir kısmı ElevenLabs'in ücretsiz hesaplarıyla üretildi. Kullanıcı 2026-10-14'te hukukçu görüşüne dayanarak karar verdi: bu sesler yayında kullanılabilir, yeniden üretim gerekmez (`CLAUDE.md` H-006 ek). Bu madde soru değil, yalnızca bilgi içindir.

**Tek kontrol sorusu (isteğe bağlı):** Bu görüş kitap seslendirmeleri (H-065…H-073) ve sosyal medyada yayınlanacak kesitler için de geçerli mi?

---

## Gönderim notu

- Gönderen ve tarih: _(kullanıcı doldurur)_
- Ekler:
  - `docs/SARTNAME.md` §12;
  - `docs/LISANS-RAPORU.md` §8;
  - `docs/H-092-PILOT-KITI.md` §3;
  - uygulamadaki yer tutucu metinlerin ekran görüntüleri (Profil → Hakkında → Kullanım koşulları / KVKK aydınlatma metni).
