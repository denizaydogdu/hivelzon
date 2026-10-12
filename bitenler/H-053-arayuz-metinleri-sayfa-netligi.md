# H-053: Arayüz metinleri ve sayfa netliği

- **Durum:** Bitti
- **Tür:** Uygulama (UX metinleri + düzen)
- **Bağımlılık:** H-036
- **Faz:** 1.4' (H-052 ile birlikte)

## Kullanıcı isteği (2026-10-12)
"Uygulamadaki genel yazıları dikkatli incele. Ana Sayfa'da 'Merhaba' var; 'Merhaba Deniz', 'Merhaba Ayşe' gibi isim olabilir. Ana Sayfa'da resmin altında 'Hikâyeye devam', altında tekrar kutucuğunda '4' yazıyor; ne olduğu net değil. Sekme içinde başlıklar olabilir. Sayfaları netleştir, kullanıcılar sayfada ne olduğunu daha net anlasın."

## Kararlar (soru-cevap)
- **İsim:** Profil'de isteğe bağlı "Sana nasıl seslenelim?" alanı (yalnızca ilk ad ya da takma ad, cihazda saklanır). Boşsa "Merhaba!". Onboarding'de (H-039) de sorulur; hesap açılınca (H-038) hesaba taşınır. KVKK: en az veri.
- H-052 ile birlikte yapılır.

## Kapsam
- Bütün ekranların metin ve düzen denetimi: Ana Sayfa, Keşfet, Hikâye haritası + bölüm paneli, oynatıcı (başlık, önceki bölümde, karar, Hi ipucu, kartlar, görevler, bölüm sonu, 🎯, anlam paneli), Defter + İpucu panosu + tekrar oturumu, Profil, boş/yükleniyor/hata durumları, sezon jeneriği.
- Her ekran: açık başlık; gerekiyorsa tek cümlelik açıklama; bölümler başlıklı; sayılar cümle içinde ("4 ifadenin tekrar zamanı geldi · ~2 dk").
- Ana Sayfa: "Merhaba {ad}" + "Hikâyen" bölümü + "Kelime tekrarı" bölümü (tekrar yoksa sakin bir durum metni).
- Metin kılavuzu: `docs/ARAYUZ-METINLERI.md` (ilkeler + ekran ekran eski → yeni).

## Kabul kriterleri
- Metin kılavuzu yazıldı; uygulama ona uyuyor.
- Simülatör ekran görüntüleri: her ana ekran.
- Testler yeşil.

## Notlar

### 2026-10-12 — uygulama ve doğrulama
- **Metin kılavuzu:** `docs/ARAYUZ-METINLERI.md`. İlkeler, terimler ve ekran ekran eski → yeni karşılaştırması burada.
  - Terim kararları:
    - Sayımda hep **ifade** denir.
    - **kart** yalnızca nesne anlamında kullanılır ("kartı aç").
    - Özelliğin adı **Kelime tekrarı**dır.
    - Bölüm için **Tekrar oyna**, hata sonrası için **Tekrar dene** denir.
- **Kod:**
  - Metinler `mobile/lib/l10n/tr_strings.dart` dosyasında toplandı.
  - Türkçe yardımcılar `mobile/lib/shared/text/turkish.dart` dosyasında: `upperTr`, `lowerTr`, `possessiveNumber`.
  - Ortak başlık bileşenleri: `PageHeader` ve `SectionHeading`.
  - Uygulama dili `tr` olarak sabitlendi (`flutter_localizations`). Önceden İngilizce okunan Material etiketleri artık Türkçe: "Scrim", "Dismiss", "Tab 1 of 5", "characters remaining".
  - `w600` kaldırıldı; yazı ağırlığı 400 / 500 / 700.
- **Ana Sayfa:**
  - Selam: "Merhaba {ad}!" ya da "Merhaba!"; altında "Bugün için önerimiz:".
  - **Hikâyen** bölümü: bölüm kartı ve "Bu sezonda 12 bölümden 2'si bitti." cümlesi. Görsel 2:1 oranına kısaldı.
  - **Kelime tekrarı** bölümü: "7 ifadenin tekrar zamanı geldi · yaklaşık 3 dk" ve "Tekrara başla". Tekrar yoksa sakin bir durum cümlesi çıkar.
- **Profil:**
  - "Sana nasıl seslenelim?" alanı eklendi. Ad isteğe bağlıdır: en fazla 20 karakter; harf, boşluk, kesme işareti ve tire kullanılabilir.
  - Ad `app_meta` tablosunda `profile.displayName` anahtarıyla saklanır. Şema değişmedi, migration gerekmedi.
  - Sayfa bölümleri: Defter ve Günlük hedef.
- **Öteki ekranlar:**
  - Hikâye: başlık ve tek cümle açıklama. "Sezon 1 · …" satırı eklendi. Hata ekranında artık komut satırı yok.
  - Bölüm paneli: "Oyna" yerine "Başla".
  - Defter: üst çubukta başlık; her sekmede tek cümle açıklama; "Topladığın ifadeler (n)".
  - Tekrar oturumu: "Kelime tekrarı · 1 / 7".
  - Keşfet ve Konuş: başlık, "… yakında" ve ne geleceğini anlatan cümle.
  - Oynatıcı: "Soru 2 / 2", "Devam et", "Haritaya dön", yeni bölüm sonu notu.
- **Testler:**
  - flutter analyze temiz; flutter test **193 geçti**.
  - Yeni testler:
    - `test/shared/text/turkish_test.dart`;
    - `test/features/profile/profile_test.dart`;
    - `notebook_ui_test`: adlı ve adsız selam, tekrar zamanı gelmiş ve gelmemiş durum;
    - `home_screen_test` ve `story_screen_test`: ilerleme cümlesi, harita başlığı.
  - pytest 70 geçti.
- **Simülatör** (hiVelzon iPhone 17, ad "Deniz"): ekran görüntüleri scratchpad'de, `h053-*.png`:
  - `home-name`, `home-noname`;
  - `map`, `sheet`, `sheet-locked`;
  - `defter`, `ipucu-panosu`, `review-task`, `b1-listen-card`;
  - `profile`, `kesfet`, `konus`.
- **Açık:**
  - Haritanın görünür alanı başlık nedeniyle kısaldı; Bölüm 1 ve 2 düğümleri alt kenara yakın, kısmen kesiliyor.
  - Simülatör klavyesi `axe type` ile "i" harfini "ı" yazdı (Türkçe klavye düzeni). Ad bu yüzden veritabanında elle "Deniz" olarak düzeltildi. Uygulamada bir hata yok.
2026-10-12 (ana oturum): flutter test 193/193, pytest 70/70, analyze temiz yeniden doğrulandı. Kullanıcı yeni anlamları (Listen. / Excuse me, where is…? / next to) onayladı; commit onayı.
