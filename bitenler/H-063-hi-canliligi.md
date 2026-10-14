# H-063: Hi'nin canlılığı (ifadeler ve animasyonlar)

- **Durum:** Bitti (2026-10-14; flutter 716/716; kullanıcı onayladı)
- **Tür:** Uygulama (tasarım)
- **Faz:** Tasarım yenilemesi T6 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-057

## Kapsam
- Kodla çizilen Hi'ye ifade durumları: mutlu, düşünen, el sallayan, uykulu, şaşkın; geçiş animasyonları.
- Hi balonunda hafif "nefes alma"; panelde ifade durumla eşleşir.
- Hi paneli bileşenlere bölünür (700 satır).

## Kabul kriterleri
- İfade vitrini; "hareketi azalt" testi; K-32 ve ürün ilkelerine uygunluk (bağımlılık yaratan efekt yok).
- Simülatör önce/sonra ekran görüntüleri `.yerel/h-063/` altına; kullanıcının verileri yedeklenip geri yüklenir.

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında (`h-063-hi-canliligi`); sorun olursa birleştirme commit'i `git revert` ile geri alınır.

## Kullanıcı kararları (2026-10-14, soru-cevap)
- Bütçe ~8 kr (Higgsfield, GPT Image 2.5 orta 1k: ~10 ekran taslağı + ~6 illüstrasyon); Hi ifadeleri kodla çizilir. Her üretimden önce maliyet gösterilir.
- Yazı tipi: başlıklar yuvarlak/sıcak (Nunito ya da Fredoka, OFL), metin Inter (OFL); uygulamaya gömülü.
- Yalnız açık tema (karanlık mod sonra ayrı iş; sistem hazır kurulur).
- Sıra: tasarım sistemi + Profil önce; H-039 ve H-040 yeni tasarımla.
- Hareket dili: yumuşak geçişler, dokunma tepkisi, sırayla belirme, dolan halka/çubuk, Hi ifadeleri, harita ışığı, sakin kutlama, hafif haptic; "Hareketi azalt" açıksa statik. K-32 yasakları korunur.
- Araçlar: Higgsfield; `frontend-design` skill'i ve AwesomeDesign standartları; 21st.dev Magic yalnız fikir panosu (web üretir, Flutter'a doğrudan girmez); `flutter_animate` (MIT).
- Plan: `/Users/felece/.claude/plans/ek-i-olarak-sayfalar-n-delightful-elephant.md` → özeti `docs/UYGULAMA-PLANI.md` "Tasarım yenilemesi".

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Sayfaların tasarımlarıyla ilgilenen bir iş aç; Profilim sayfasını hiç beğenmedim, her şey iç içe, düz yazı gibi. Daha animasyonlu, şekilli, kullanıcıyı çekecek tasarımlar."
2026-10-14 (H-062'den): Bölüm sonu sakin kutlamasında bayrak ikonu yerine mutlu Hi ifadesi kullanılabilir.

2026-10-14 (uygulama, dal `h-063-hi-canliligi`; birleştirilmedi):
- **İfadeler (kodla, görsel/kredi yok):** `HiExpression` = sakin, mutlu, düşünen, el sallayan, uykulu, şaşkın, dinleyen ("Söyle" için hazır; henüz bir ekrana bağlanmadı). Değerler `widgets/hi_face.dart` (`HiFace` + `lerp`), çizim `widgets/hi_painter.dart` + `hi_painter_marks.dart`. İfade değişince göz, göz kapağı, ağız, ışık ve küçük işaretler 400 ms'de yumuşakça geçer (`TweenAnimationBuilder`, zamanlayıcı yok; H-062 yaklaşımı). Sakin yüz H-005 çiziminin piksel piksel aynısı.
- **Renk:** `_rim` sabiti kalktı → `AppHiColors` (`rim`, `core`, `face`, `highlight`, `cheek`) `tokens.dart`'ta. `Color(0x` taban çizgisi 1 → 0; oynatıcı katı denetimi artık Hi çizimini de kapsıyor.
- **Nefes:** Hi balonu 3 sakin nefes alır (her biri 4,8 sn, en çok %2,5 büyüme, nefes başına bir göz kırpma), sonra durağan. Sonsuz döngü bilinçli olarak yok: dikkat çekmez, pil harcamaz, testler (`pumpAndSettle`) ve golden'lar belirli bir dinlenme anında biter. Rozet davranışı aynı (sayı yok, panel açılınca kalkar). "Hareketi azalt" → nabız, nefes, el sallama yok; ifade anlık.
- **Bağlam eşlemesi** (`hi_expressions.dart`): panel açılınca Hi bir kez el sallar, sonra öneriye göre bakar: hikâye/kitap/sahne avı → mutlu; tekrar/defter → sakin; Hi'nin notu → düşünen; dinlenme önerisi geç akşam (21.00–04.59) → uykulu, gündüz → mutlu. Hi'nin notu kartı → düşünen. Oynatıcıda ipucu paneli → düşünen. Bölüm sonu kutlamasında bayrak yerine mutlu Hi; Kelime tekrarı özetinde de mutlu Hi (`CalmCelebration(child:)`). Kitap sonu ve sahne avı özeti kendi ikonlarıyla kaldı (okuyucu temasının renkleri; Hi'siz bağlam).
- **Panel bölündü** (davranış aynı; anahtar, metin ve başlıklar aynı): `hi_panel.dart` 703 → 248 satır; `panel/hi_panel_parts.dart` (tanıtım, başlık, yükleniyor), `hi_suggestion_card.dart`, `hi_bridge_card.dart`, `hi_lookup_results.dart`, `hi_week_card.dart`. Hiçbir yeni dosya 300 satırı geçmiyor.
- **Vitrin:** `/tasarim` → "Hi ifadeleri" (7 ifade + seçilerek geçiş denenen büyük Hi), `showcase_hi_section.dart`.
- **Testler:** `test/features/hi/hi_expressions_test.dart` (ifade başına çizim + etiket, geçiş ara değeri, hareketi azalt, nefes sınırı ve durması, göz kırpma, selamlama, balon dokunma alanı ≥ 48 ve etiket); `hi_ui_test` panel bölme eşdeğerliği ve ifade eşlemesi; H-061/H-062 testlerine mutlu Hi denetimi. Golden: `test/goldens/images/h063_hi_<ifade>.png` (7), `showcase_hi.png`; yeniden üretilen: `h062_bolum_sonu`, `h062_ipucu`, `h061_tekrar_ozet`, `h059_hi_gizlilik` (yalnız ışığın dinlenme değeri; eskiden nabız bitişi kareye göre değişiyordu). Hepsi gözle kontrol edildi.
- **Açık:** simülatör önce/sonra ekran görüntüleri (`.yerel/h-063/`) bu adımda alınmadı; birleştirmeden önce alınacak.
2026-10-14: Kullanıcı 7 ifadeyi onayladı. Simülatör önce/sonra H-064'te. "Dinleyen" ifadesinin Söyle'ye bağlanması ileride.
