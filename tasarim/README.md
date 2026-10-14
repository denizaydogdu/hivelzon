# hiVelzon arayüz tasarım yönü (H-045)

Taslaklar: `onizleme/T1…T6.jpg` (tam boy PNG'ler git dışında). Üretim kaydı: `PROMPTS.md`.
Ton: hikâyeyle uyumlu (kullanıcı kararı, 2026-10-11). Arayüz sade; hikâye çizimleri kartlarda ve videoda.

## Tasarım sistemi v2 (H-057, 2026-10-14)

Kod: `mobile/lib/app/design/` (belirteçler), `mobile/lib/app/theme.dart` (tema), `mobile/lib/shared/ui/` (ortak bileşenler). Vitrin: debug derlemede `/tasarim` (`--dart-define=HV_START_ROUTE=/tasarim` ile doğrudan açılır). Uygulama **açık temaya sabit**; karanlık tema derlenir ama kullanılmaz (sonra ayrı iş).

**Kural:** `lib/app/design/**` ve `lib/app/theme.dart` dışında `Color(0x…)` ve `fontSize:` yazılmaz. `test/app/design/style_literals_guard_test.dart` dosya başına taban çizgisini tutar (2026-10-14: `Color(0x` 31 → 10, `fontSize:` 40 → 37); sayılar yalnızca azalır. `shared/ui` ve vitrinde sıfırdır.

### Yazı tipleri (gömülü, SIL OFL 1.1)
| Aile | Rol | Ağırlık | Kaynak |
|---|---|---|---|
| **Nunito** | display / headline / title (başlıklar) | 700 (400 / 500 de gömülü) | github.com/googlefonts/nunito `fonts/variable/Nunito[wght].ttf` (commit `93a90a3`); fontTools 4.55.3 `instancer` ile 400 / 500 / 700 statik örnek |
| **Inter** | body / label (metin) | 400 / 500 / 700 | github.com/rsms/inter **v4.1** sürümü, `extras/ttf/Inter-{Regular,Medium,Bold}.ttf` |

Lisanslar `mobile/assets/fonts/*/OFL.txt`; Lisanslar sayfasına `registerFontLicenses()` ekler. Türkçe karakterler (ç ğ ı İ ö ş ü â Â î û) altı dosyanın da `cmap` tablosunda var (`test/app/design/fonts_test.dart`).

### Renk (`AppPalette`, `AppScrim`)
| Belirteç | Değer | Kullanım |
|---|---|---|
| `seaBlue` (50 / 100 / 200 / 300 / 700 / 900) | `#1F4E79` (`#EAF1F8` … `#0E2840`) | Birincil, başlık vurgusu, ikincil düğme; açık tonlar seçenek ve bilgi zemini |
| `lighthouseYellow` (50 / 100 / 200 / 700) | `#F2B33D` | Ana eylem düğmesi, dolan halka |
| `sand` (50 / 200 / 300 / 500) | `#F7F1E6` | Sayfa zemini, alt panel |
| `eveningOrange` / `orange700` | `#E98A3C` / `#A9530F` | Küçük vurgu / turuncu **metin** (AA) |
| `ink` (700 / 500 / 300 / 200 / 100) | `#2B2B2B` | Metin; `ink500` ikincil metin (kumda 5,5:1), `ink200` kenar |
| `white` | `#FFFFFF` | Kart, ayar grubu, sekme çubuğu |
| `success` / `successSurface` | `#276B43` / `#E6F3EA` | Olumlu durum |
| `warning` / `warningSurface` | `#8A5A00` / `#FFF4D6` | Dikkat (suçlamasız) |
| `info` / `infoSurface` | `seaBlue` / `seaBlue50` | Bilgi, ipucu |
| `danger` / `dangerSurface` | `#B3261E` / `#FBE9E7` | Geri alınması zor eylem (hesap silme) |
| `AppScrim.*` | `playerBackground #101418`, `captionBox #CC1B1B1B`, `captionText #E6FFFFFF`, `strong #99000000`, `gradientEnd #B3000000`, `textShadow`, `panelShadow`, `cardShadow`, `badgeShadow` | Oynatıcı ve görsel üstü perdeler |

### Ölçüler
| Belirteç | Değerler |
|---|---|
| Boşluk `AppSpace` | 4 / 8 / 12 / 16 / 24 / 32 / 48 / 64; sayfa kenarı 16 |
| Köşe `AppRadius` | `sm` 8 · `md` 12 (kart, giriş) · `lg` 20 (alt panel, pencere) · `full` (hap düğme) |
| Gölge `AppShadows` | `level1` kart · `level2` öne çıkan kart · `level3` panel; sıcak tonlu, düşük opaklık |
| İkon `AppIconSize` | 16 / 24 / 32 / 48 |
| Dokunma `AppTouch` | en az 48; ana eylem 56 |
| Yazı ölçeği `AppTypography` | Material 3 boyutları (57 … 12; `labelSmall` 11 → 12); başlık Nunito 700, metin Inter 400, etiket Inter 500; düğme Inter 700 16 |

### Hareket (`AppMotion`)
| Belirteç | Değer | Nerede |
|---|---|---|
| `fast` | 150 ms | Dokunma tepkisi (ölçek 0,97) |
| `base` | 250 ms | Sayfa geçişi, belirme |
| `slow` | 400 ms | Dolan halka, sakin kutlama |
| `stagger` | 50 ms (en fazla 8 öğe) | Listede sırayla belirme |
| Eğriler | `enter` easeOutCubic · `exit` easeInCubic · `standard` easeInOutCubic | |

Kurallar: Sekmeler arası geçiş anlık. İtilen sayfalarda (Defter, Hesap, Hi gizlilik, konu seti) Android'de solarak geçiş; **iOS'ta yerel kaydırma** kalır (kenardan kaydırarak geri dönme yalnız onda çalışır). Oynatıcı, jenerik ve tekrar oturumu tam ekran geçişini korur. "Hareketi azalt" açıksa (`MediaQuery.disableAnimations`) bütün bileşenler durağandır. K-32: geri sayım, titreşen uyarı, baskı yok.

### Düğmeler (`AppButtonStyles`)
| Varyant | Biçim | Kullanım |
|---|---|---|
| Birincil (`FilledButton`, tema) | Fener sarısı, mürekkep yazı, hap | Ekrandaki tek ana eylem |
| İkincil (`OutlinedButton`, tema) | Deniz mavisi kenar ve yazı | Yan eylem |
| Sessiz (`TextButton`, tema) | Yalnız yazı | "Şimdi değil", "Geç" |
| Tehlike `danger()` / `dangerFilled()` | Kırmızı kenar / kırmızı dolgu | Silme; dolu olan yalnız son onayda |
| "Bilmiyorum" `dontKnow()` | Deniz mavisi kenar, 700, `help_outline` ikonu | Tekrar ve sahne avı (ortak) |

### Ortak bileşenler (`mobile/lib/shared/ui/`)
| Bileşen | Ne için |
|---|---|
| `AppSheet`, `showAppSheet` | Alt panel iskeleti: tutamaç, başlık, "Kapat" |
| `InfoCard` (`neutral / info / success / warning / danger`) | Bilgi kartı (ekranlardaki 8 kopyanın yerine) |
| `SettingsGroup`, `SettingsRow` (`.toggle`) | Gruplu ayarlar: ikon, başlık, alt satır ipucu, değer / ok / anahtar; `destructive`. Her satır ayrı ekran okuyucu düğümü (H-059) |
| `StatTile`, `StatRow` | Büyük sayı + etiket; tek parça okunur. `StatTile.count`: sıfırdan sayarak belirir, "Hareketi azalt"ta durağan (H-059) |
| `CapsLabel` (`orange / blue`) | Büyük harfli küçük etiket, `upperTr` |
| `ShapedHeader` (`wave / diagonal`) | Şekilli başlık, isteğe bağlı illüstrasyon (H-058). `title` verilmezse yalnız görsel (Profil, Hesap; H-059) |
| `ProgressRing` | Dolan halka, değer ekran okuyucuda |
| `EmptyState` | İllüstrasyon / ikon + başlık + açıklama + eylem |
| `TappableCard`, `PressScale` | Dokunma tepkili kart / sarmalayıcı |
| `StaggeredList`, `FadeSlideIn` | Sırayla belirme (`flutter_animate`, zamanlayıcısız) |

Mevcutlar yeniden kullanılır: `PageHeader` / `SectionHeading`, `Skeleton` ailesi, oynatıcı kiti (`player_ui.dart`), `CardFace` / `AudioButton` / `EpisodeTag`, `HiAvatar`.

### Testler
- Golden: `mobile/test/goldens/` (gömülü yazı tipleriyle; `test/support/app_fonts.dart`). Bilinçli görsel değişiklikten sonra: `cd mobile && flutter test --update-goldens test/goldens`. Golden'lar macOS'ta üretildi.
- Erişilebilirlik: vitrinde `androidTapTargetGuideline`, `iOSTapTargetGuideline`, `labeledTapTargetGuideline`, `textContrastGuideline`; metin 1,3× büyütmede taşma yok.

## Tasarım belirteçleri v1 (H-045; v2'nin temeli)
| Belirteç | Değer | Kullanım |
|---|---|---|
| Birincil | `#1F4E79` deniz mavisi | Başlıklar, seçili sekme, birincil düğme (koyu) |
| Vurgu | `#F2B33D` fener sarısı | Ana eylem düğmesi ("Hikâyeye devam", "Bildim"), sıradaki bölüm |
| Arka plan | `#F7F1E6` kum | Sayfa zemini |
| Metin | `#2B2B2B` | Gövde metni (saf siyah yok) |
| Akşam turuncusu | `#E98A3C` | Yalnızca küçük vurgular |
| Köşe | 12 px | Kart ve düğmeler |
| Boşluk | 8 px ızgara | 8 / 16 / 24 / 32 |
| Yazı | Inter benzeri, en fazla 3 ağırlık | 400 / 500 / 700 |

## Ekranlardan alınacaklar
- **T1 Ana Sayfa:** tek büyük "Hikâyeye devam" kartı + günlük hedef halkası + "Hızlı pratik" + "Yeni klipler". Ürün ilkesi: tek öğrenme eylemi öne çıkar.
- **T2 Harita:** resimli kasaba haritası, limandan fenere uzanan yol, biten bölümde onay, sıradaki parlayan, kilitlide kilit + spoiler'sız ipucu. Düğümler Flutter'da çizilir (görseldeki numaralar bozuk).
- **T3 Oynatıcı + karar:** video üstte kararır, alttan "Ne dersin?" kartı, büyük seçenek düğmeleri; üst çubukta kapat, ilerleme noktaları, 0,75x, altyazı düğmesi.
- **T4 Hi ipucu:** Hi'nin ışıklı balonu, Türkçe ipucu + ses, "Bir ipucu daha" ve "Tekrar dene". Cezalandırıcı dil yok.
- **T5 Defter:** "İfadeler / İpucu panosu" sekmesi, FSRS kartı (Bildim / Bilmedim), bölüm etiketli ifade listesi.
- **T6 Keşfet:** tam boy klip, hedef kelime vurgulu altyazı + küçük Türkçe karşılık, sağda Kaydet / Anlam / Tam hikâye. Beğeni ve yorum yok.

## Taslaklardan farklı yapılacaklar
- Oynatıcıda (T3, T4) alt sekme çubuğu **gizlenir**; tam ekran.
- T2'deki üst sekme şeridi kullanılmaz (sekmeler yalnızca altta).
- Görsellerdeki İngilizce örnekler yer tutucudur: gerçek metin bölüm paketinden gelir. (T5'teki "Otobüs durağı nerede?" çevirisi de yanlış; *bus station* ≠ durak.)
- Görsellerdeki tabela yazıları ("Good Coffee Better Days", "CAFÉ") uygulamaya taşınmaz.
