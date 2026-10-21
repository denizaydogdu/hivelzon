# H-096: 21 Ekim takip incelemesi düzeltmeleri

- **Durum:** Bitti (2026-10-21); mobil 1454 test, pytest 381
- **Tür:** Hata düzeltmesi (kod)
- **Faz:** F1 MVP
- **Bağımlılık:** H-094, H-090; kaynak: `docs/URUN-TAKIP-INCELEMESI-2026-10-21.md`

## Kapsam (kullanıcı onayı 2026-10-21: "sen karar ver")
1. **[P1] Geri çekilen reelin eski adresi bellekte kalıyor** (`http_content_source.dart`): katalog başarıyla okununca kimlik → paket adresi haritası atomik olarak yenilenir; yayında olmayan kimlik `loadReel` ile açılmaz (`ContentUnavailableException`). Keşfet'e dönüşte / uygulama öne gelince katalog kontrollü yenilenir; açık video geri çekildiyse sakin biçimde durur. Ağ hatasında eski adresle sessiz açma yok.
2. **[P1] Mesaj kontrolü cümleleri birleştiriyor** (`talk_match.dart`): gerekli kalıbın tamamı tek bir cümlede bulunmalı ("Sorry, I am. Late." geçmez); kanıt yalnız eşleşen kalıplar için yazılır.
3. **[P2] İzleme tamamlandı koşulu** (`discover_screen.dart`): %90 konum + yeterli aktif izleme süresi birlikte gerekir.
4. **Etiket:** Keşfet'teki "Kaydet" → "İfadeyi kaydet" (ARAYUZ-METINLERI'ne işlenir).
- **H-044'e not:** paket sürümleri değişmez klasörlerde (`<id>/v2/`) olmalı; yayındaki sürümün dosyaları yeni sürümle ezilmemeli.

## Kabul kriterleri
- Her madde için önce düşen, sonra geçen regresyon testi; `flutter analyze && flutter test` yeşil.

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında; `git revert`.

## Notlar

### 2026-10-21 — dört madde uygulandı (commit yok, gözden geçirme bekliyor)
Her madde için önce düşen regresyon testi yazıldı, sonra düzeltildi.

1. **Reel kataloğu / yayın kapısı** (`http_content_source.dart`, `discover_providers.dart`, `discover_screen.dart`, `reel_selection.dart`)
   - Katalog bütün sayfalarıyla başarıyla okununca kimlik → paket adresi haritası ve yayın kümesi **birlikte, bütünüyle** değişir; yarım okuma haritayı bozmaz.
   - `loadReel` yalnız son başarılı okumadaki kimliği açar; son okuma başarısızsa önce yeniden okur, okuyamazsa `ContentUnavailableException` (eski adresle sessiz açma yok).
   - `ReelCatalogRefresher`: Keşfet'e dönüşte ve uygulama öne gelince katalog yeniden okunur; en kısa aralık 1 dk (`reelCatalogRefreshIntervalProvider`), eşzamanlı çağrılar tek okuma. Değişmediyse akış kesilmez; değiştiyse okunan sonuç sağlayıcıya aktarılır (ikinci istek yok).
   - Açık video artık yayında değilse durur, not: "Bu video artık yayında değil. Listeni yeniledik." Günlük sette mevcut yedek kuralı (aynı seviye + konu) çalışır; kalınan yer yedeğe taşınır (`reconcileDailySetDetailed`). Kalınan yer artık seçkiyle aynı anda okunur (`ReelPool/ReelSet.resumeId`).
   - Testler: `test/shared/content/http_reel_catalog_test.dart` (3 yeni), `test/regressions/reel_catalog_refresh_regression_test.dart` (6 yeni).
2. **Mesaj denetimi** (`talk_match.dart`, `talk_message_view.dart`, `hvpipeline/talk.py`): her gerekli kalıp tek bir cümlede tam geçmeli ("Sorry, I am. Late." geçmez). Kanıt (`coveredTargets`) yalnız geçerli eşleşen kalıplardan ya da gerekli kalıbın geçtiği tek cümlede sırayla geçen hedeften yazılır. Ortak örneklere 5 yeni `checks` + yeni `covered` bölümü (Dart ve Python aynı sonuç).
3. **Tamamlanma**: konum ≥ %90 **ve** bu açılışta aktif oynatma ≥ sürenin %80'i. Bitmiş videoda konum = süre. Belgeler: Keşfet planı §5, `REEL-PAKETI.md`.
4. **Etiket**: "Kaydet" → "İfadeyi kaydet" (klip ve günlük video ortak); ekran okuyucu etiketi aynı kaldı. `ARAYUZ-METINLERI.md` §7.1 güncellendi. Golden: `h040_klip`, `h094_gunluk`, `h094_gunluk_tekrar`, `h094_gunluk_ilgi_enaz` (macOS) bilerek güncellendi; 320×568 · 1,3× taşma denetimi geçiyor.

**Açık:** sekme dönüşü ve öne gelme dışında (ör. sayfa kaydırırken) katalog yenilenmez. Katalogdan kaldırma, daha önce alınmış doğrudan medya adresini iptal etmez: H-044 (değişmez sürüm klasörleri).

**Doğrulama:** `flutter analyze` sorun yok; `flutter test` 1.454 test geçti; içerik hattı pytest 370 geçti, 11 atlandı.
