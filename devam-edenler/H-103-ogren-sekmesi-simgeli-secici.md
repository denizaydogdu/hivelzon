# H-103: Hikâye sekmesi → Öğren; simgeli seçici, son bölüm hatırlanır

- **Durum:** Devam ediyor — uygulandı, testler yeşil (1504/1504), simülatörde gösterildi (2026-11-01), kullanıcı geri bildirimi + commit bekliyor (kod yerelde)
- **Tür:** Mobil arayüz + bilgi mimarisi
- **Öncelik:** Orta
- **Bağımlılık:** K-30, H-067 (Kitaplık), H-078 (Dilbilgisi), H-098 (sabit
  seçici, Hi turu), H-087 madde 4 (4 sekme pilotta karşılaştırılır)

## Kapsam

Kullanıcı kararı (2026-11-01, Seçenek 1): Alt menüdeki "Hikâye" sekmesinde
Macera · Kitaplık · Dilbilgisi vardı; kullanıcı sekmeyi yalnız hikâye sanıp
Kitaplık/Dilbilgisi'ni bulamayabilir.

1. Alt menü etiketi **"Hikâye" → "Öğren"**, simge kep (`school_outlined` /
   seçili `school`). Sıra aynı: Ana Sayfa · Keşfet · Öğren · Konuş · Profil.
2. Üstteki sabit seçici: **Hikâye** (eski "Macera"; `movie`) · **Kitaplık**
   (`menu_book`) · **Dilbilgisi** (`text_fields`, "Tt"); seçili bölümün
   simgesi dolgulu. Simge her durumda kalır: yan yana sığmazsa etiketin
   üstüne geçer; etiket tek satır, gerekirse küçülür. Yükseklik ≥ 48.
   Sayfa başlığı **Öğren**.
3. Son seçilen bölüm cihazda: `app_meta` anahtarı `learn.section`
   (`hikaye` | `kitaplik` | `dilbilgisi`). Derin bağlantı
   `/hikaye?bolum=<kod>` (`AppRoutes.learnAt`) hatırlananı ezer, yeni son
   bölüm olur; yol sorgusuz `/hikaye`ya sadeleşir. Ana Sayfa "Haritaya git",
   Keşfet "Hikâyeye git"/sınır kartı ve Hi panelinin hikâye geri dönüşü
   Hikâye bölümünü açar. Kayıt okunmadan yapılan seçim kazanır; okuma/yazma
   hatası akışı durdurmaz (Hikâye ile sürer).
4. Hi turu (bir kez): "Beş sekme" metni Öğren der; yeni adım **Öğren
   sekmesi** · "Hikâye, Kitaplık ve Dilbilgisi burada." (tur 5 adım).
5. Sekmeye atıflar: "Hikâye sekmesinden" → "Öğren sekmesinden" (Hi'nin
   dinlenme cümlesi); ekran okuyucu grubu "Öğren bölümleri". Hikâyenin
   kendisini anlatan "Hikâye" kullanımları değişmedi.

Kod: `TabTexts.learn`, `LearnTexts`, `AppRoutes.learn`/`learnAt`,
`features/story/domain/learn_section.dart`,
`data/learn_section_store.dart`, `application/learn_section_provider.dart`,
`story_screen.dart` (`_LearnHeader`), `router.dart`
(`learnSectionRedirect`), `shell_scaffold.dart`, `app_tour` metinleri.
Belgeler: `CLAUDE.md` (K-30, K-02, H-087 not), `docs/ARAYUZ-METINLERI.md`
(§4, §4.6, §4.8, §8), `docs/OYUN-TASARIMI.md` §11.1 notu.

## Kabul

- Alt menüde "Öğren" (kep); "Hikâye" yalnız seçicide.
- Seçicide üç simgeli bölüm; 320 × 568, metin 1,3× tek satır, taşma yok,
  yükseklik ≥ 44.
- Son bölüm yeniden açılışta hatırlanır; derin bağlantı doğru bölüme gider
  ve hatırlananı ezer (aynı bağlantı tekrar da çalışır).
- Hi turunda Öğren adımı; tur yine bir kez açılır.
- `flutter analyze` temiz, `flutter test` tam takım yeşil.
- Kullanıcının simülatör kontrolü.

## Test komutu

```bash
cd mobile && flutter analyze && flutter test
# hedef: test/features/story/learn_section_test.dart \
#   test/features/grammar/grammar_entry_ui_test.dart test/features/library/library_ui_test.dart \
#   test/app/shell_nav_label_test.dart test/features/onboarding/onboarding_ui_test.dart
```

## Doğrulama (2026-11-01)

- `flutter analyze`: temiz.
- `flutter test`: **1504/1504** (önce 1493; 11 yeni test,
  `learn_section_test.dart`).
- Golden güncellendi ve gözle bakıldı: `h039_tur`, `h060_harita`,
  `h060_bolum_paneli_kilitli/yarim`, `h067_kitaplik`, `h078_bolum_paneli`,
  `h078_dilbilgisi`, `h078_dilbilgisi_ilerleme`.

## Geri alma

Veri şeması değişmez (yalnız `app_meta`'ya bir anahtar). Geri almak için
ilgili commit `git revert`; kalan `learn.section` kaydı zararsızdır
(okunmaz). Yalnız adı geri almak için `TabTexts.learn`/`LearnTexts.title`
metinleri ve `shell_scaffold.dart` simgesi yeterlidir.
