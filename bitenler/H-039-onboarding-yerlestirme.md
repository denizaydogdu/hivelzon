# H-039: Onboarding ve yerleştirme

- **Durum:** Bitti (2026-10-14; flutter test geçti, CI yeşil; kararlar ve soru havuzu kullanıcı onaylı)
- **Tür:** Uygulama (kod)
- **Faz:** 1.7 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-038

## Kapsam
- Dil, yaş beyanı (13+), rızalar.
- Prolog.
- Atlanabilir kademeli yerleştirme testi (K-06).
- Bildirim izni sonradan istenir.

## Kabul kriterleri
- 13 yaş altı kayıt engelleniyor.
- Test atlanabiliyor.

## Test
```bash
cd mobile && flutter test
```

## Geri alma
Kendi dalında (`h-039-onboarding-yerlestirme`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
2026-10-13: H-002 güncellendi: açılışta doğum yılı sorulur. 13 altı → hesap açma gösterilmez, uygulamanın tamamı hesapsız (cihazda) açılır; 13+ → misafir (prolog + B1) ya da hesap. AI sohbeti 18+. Ebeveyn kapısı (mağaza kuralı) H-043/H-044'te değerlendirilir.
2026-10-13: H-009 güncellendi: onboarding hesap istemez; yalnız doğum yılı (18+ AI kuralı ve 13+ hesap için) ve isteğe bağlı ad. Hesap teklifi sonradan, sakin bir kartla.

2026-10-14: **Uygulandı** (dal `h-039-onboarding-yerlestirme`; ana oturumun doğrulaması ve birleştirmesi bekleniyor).
- **Akış** (`mobile/lib/features/onboarding/`, tasarım sistemi v2, taslak S09): karşılama → doğum yılı + isteğe bağlı ad → "Bilmen gerekenler" (bilgilendirme, taslak hukuk metinlerine bağlantı) → günlük hedef + altyazıda Türkçe satır (K-03, varsayılan açık) → seviye (kendi tahmini + atlanabilir test) → [soru → sonuç] → hazır → Ana Sayfa. Sekme çubuğu ve Hi balonu yok; geri düğmesi önceki adıma döner.
- **Yaş:** doğum yılı zorunlu, yalnızca yıl, yalnızca cihazda (`app_meta` `profile.birthYear`; eşitlenmez, sunucuya gitmez). 13 altı → mevcut yaş kapısı (`account.ageBlockedUntil`) kapanır: Profil'deki Hesap satırı kapalı, Ana Sayfa hesap kartı görünmez, açılışta hesaptan hiç söz edilmez. 13+ → hazır adımında yalnızca sakin bir not ("İstersen sonra Profil'den hesap açıp…"); hesap teklifi mevcut H-038 kartında kalır. 18+ kuralı (v1 AI sohbeti) için `AgeBand` hazır.
- **Bilgilendirme:** onay kutusu yok (hesapsız kullanımda veri telefondan çıkmaz); okunan aydınlatma sürümü cihazda kaydedilir (`onboarding.noticeVersion`). Hukuk metinleri H-059 ekranıyla açılır, "Taslak metin" kartı görünür.
- **Yerleştirme testi (K-06):** kural tabanlı motor (`domain/placement.dart`): isteğe bağlı ısınma (2 soru), basamak başına 4 soru, 3–4 doğru → üst, 2 → kal, 0–1 → bir alt; en fazla 20 soru; "Bilmiyorum"; doğru/yanlış gösterilmez; her an "Testi bırak". Sonuç yalnızca "Önerilen başlangıç seviyesi" ve cihazda (`placement.suggestedLevel`); içerik yalnızca S1/A1 olduğu için bilgi amaçlı. Ağ ve AI yok.
- **Soru havuzu TASLAK:** `mobile/assets/placement/placement_bank.json` (`status: DRAFT`; A1–C1 × 4 madde + 2 ısınma; kendi cümlelerimiz; Cambridge/Oxford/GSE/CEFR Companion/VST/VLT metni yok). Dinleme maddesi yok.
- **Altyazı tercihi:** `settings.subtitleMode` (`app_meta`); oynatıcı açılınca uygulanır, oynatıcı menüsü de kaydeder (önceden her bölüm yalnız İngilizceyle açılıyordu).
- **Bir kez gösterilir:** `onboarding.completedAt` (ilk an kalır). Önceden kullanımı olan cihaz (bölüm ilerlemesi, defter, öğrenme olayı, izlenmiş jenerik, hesap, Profil'de ad ya da günlük hedef) açılışı görmez ve bir kez işaretlenir. go_router `redirect` + `refreshListenable`; istenen yol `?sonra=` ile korunur. Durum okunamazsa ya da 10 sn'de okunamazsa açılış atlanır (uygulama durmaz). Yeniden sınama: `OnboardingGateNotifier.restart()`; debug derlemede `/acilis?yeniden=1` (`--dart-define=HV_START_ROUTE=/acilis?yeniden=1`). Otomatik oynatma derlemesinde kapı yok.
- **Prolog:** A1-000 oynanabilir paket değil; bitiş Ana Sayfa'ya gider (oradaki tek eylem ilk bölümü açar). Hikâye içeriği oluşturulmadı.
- **Bildirim izni** açılışta istenmez; kancası hazır adımında not olarak duruyor (hatırlatma H-013, ilk bölümden sonra).
- **Drift şeması değişmedi** (v5); yalnızca `app_meta` anahtarları.
- **Testler:** `cd mobile && dart format . && flutter analyze && flutter test` → analyze temiz, 494 test geçti. Yeni: `test/features/onboarding/onboarding_domain_test.dart` (havuz, motor, yaş, kayıt, yönlendirme), `onboarding_ui_test.dart` (13 altı yolu, 13+, doğum yılı denetimi + geri, test bırakma ve sonuna kadar, kendi tahmini + Bilmiyorum, eski kullanıcı, reset, 320×568'de 1,3× yazı, dokunma alanı/etiket/kontrast, hareket açık), oynatıcıda kayıtlı altyazı tercihi; golden'lar `test/goldens/h039_onboarding_golden_test.dart` (8 adım, yalnız macOS). Uygulamanın tamamını açan eski testler `test/support/onboarding.dart` ile açılışı bitmiş sayar; entegrasyon testleri (H-038, H-059) de öyle.
- Metinler: `ARAYUZ-METINLERI.md` §13.

**Kullanıcıya açık sorular:**
1. **Soru havuzu onayı (H-028):** 22 taslak madde; seviye başına 30–40'a genişletme ve dinleme maddeleri (bölüm seslerinden kesme) ayrı iş mi?
2. **Doğum yılı saklama:** Brif "yalnızca yıl, yerelde sakla" diyor; mevcut hesap akışı (H-038) ise doğum yılını saklamayıp yalnızca "hesabın açılabileceği yılı" tutuyor. Açılış yılı saklıyor (18+ kuralı için). Daha da az veri istenirse yıl yerine yalnızca eşik yılları (13 ve 18) saklanabilir.
3. **Doğum yılı zorunlu mu?** Taslakta "Daha sonra" düğmesi vardı; şimdilik zorunlu (tek zorunlu soru). Atlanabilir olsun mu?
4. **13 altı ve yıl değişikliği:** 13 altı yıl girildikten sonra geri dönülüp yıl değiştirilse de yaş kapısı açılmaz (hesap ekranıyla aynı davranış). Uygun mu?
5. **Bilgilendirme metni:** "Reklam yok; seni başka uygulamalarda izlemiyoruz" ve "Sesin kaydedilmez" ürün kararlarından alındı; hukuk teyidi (H-042) ve ebeveyn kapısı (H-043/H-044) bekliyor. "Bir büyüğünle birlikte oku" notu yeterli mi?
6. **Hesap ekranında doğum yılının yeniden sorulması:** Açılışta girilen yıl hesap açarken önceden doldurulsun mu (şimdi yeniden soruluyor)?
7. **"Dil" adımı:** Arayüz yalnız Türkçe olduğu için ayrı dil adımı konmadı.
2026-10-14 (kullanıcı kararları):
- Doğum yılı **saklanmaz**; yalnızca henüz geçmemiş eşik tutulur (13 altı: `account.ageBlockedUntil`; 13–17: `profile.adultFromYear`; 18+: kayıt yok). İlk sürümün `profile.birthYear` kaydı görülünce silinir.
- Doğum yılı adımı zorunlu kalır ("Daha sonra" yok).
- Hesap açarken doğum yılı yeniden sorulur (önceden doldurulmaz).
- Soru havuzu: kullanıcı okuyup onaylayacak; onaydan sonra `status: DRAFT` kaldırılır.
2026-10-14: Kullanıcı 22 maddelik soru havuzunu onayladı ("onayladım"); `placement_bank.json` `status: APPROVED`. İş kapandı. Açık kalanlar başka işlerde: bilgilendirme metninin hukuk kontrolü (H-042), ebeveyn kapısı (H-043/H-044), havuzun büyütülmesi ve dinleme maddeleri (ileride ayrı iş), bildirim izni (H-013 ile ilk bölümden sonra).
