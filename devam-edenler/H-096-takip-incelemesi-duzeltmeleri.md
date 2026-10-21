# H-096: 21 Ekim takip incelemesi düzeltmeleri

- **Durum:** Devam ediyor (2026-10-21)
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
