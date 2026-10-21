# H-040: Keşfet akışı (kısa klipler)

- **Durum:** Bitti (2026-10-14; flutter 887; kullanıcı onayladı)
- **Tür:** Uygulama (kod)
- **Faz:** 1.8 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-038

## Kapsam
- B1–B4'ten kısa klipler.
- Kaydet / Anlam / Tam hikâye.
- Her 4–5 klipte quiz kartı, ~10 klipte mola kartı; 13–17 yaş için 20 dk sınırı (K-15).

## Kabul kriterleri
- Akış bellek sınırı içinde (ölçüm raporu).
- Mola ve süre sınırı testli.

## Test
```bash
cd mobile && flutter test
```

## Geri alma
Kendi dalında (`h-040-kesfet-akisi`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
2026-10-12: "Anlam" düğmesi H-046'daki anlam panelini (`lib/shared/meaning/`) yeniden kullanır. Klipler yalnızca editörün onayladığı içerikten türetilir; uygulama içinde AI etiketi gömülmez, kısa not gösterilir (CLAUDE.md Higgsfield kuralı 6).

2026-10-14: **Uygulandı ve `main`'e alındı** (dal `h-040-kesfet`); kullanıcı onayladı.

**Boru hattı (ücretli üretim yok):**
- Kaynak `icerik/_evren/klipler/S1.json`: B1–B4'ten **17 klip** (5,3–15,6 sn, toplam 174 sn), her biri tek hedef (ifade/kelime + Türkçesi), 16'sında dilbilgisi dersi bağı, 15'inde quiz. Klip bir ya da birkaç ardışık segmentten kesilir (ör. karar öncesi sahne + doğru cevabın segmenti).
- `hvpipeline/clips.py` (denetim + dışa aktarma), `media.cut_clip` / `media.parts_loudness` / `media.frame_webp`. 720p segmentlerden kesilir; ses her klipte -16 LUFS'a getirilir (ölçülen: -16,02…-16,04 LUFS). Paket: sezon paketinde `clips.json` + `clips/<id>.mp4` (720×1280) + `clips/<id>.webp`; 41,6 MB. `season.json → clips` özeti. Geliştirme sunucusu değişmeden sunar.
- content-lint: segment sınırı, altyazı satırı bölünmez, ≤ 30 sn, hedef altyazıda geçer, ders var, quiz biçimi ve tonu; **onaysız kaynak bölüm / onaysız klip dosyası uyarıdır, `--require-approved` ile hata** (yayın denetimi). Belge: `docs/BOLUM-PAKETI.md` §9. Testler: `tools/content-pipeline/tests/test_clips.py` (32).

**Uygulama (`mobile/lib/features/discover/`):**
- Dikey akış, yalnızca **açılmış bölümlerin** klipleri (spoiler yok, "Tam hikâye" her zaman açılır). Ses açık başlar, sağ üstte kapatılır. Video kendiliğinden sonrakine geçmez ("Tekrar izle" + kaydırma ipucu).
- Altyazı (hedef sözcükler sarı) → dokununca video durur, anlam paneli (H-046) açılır; ses klibin kendi kaydından; kapanınca kaldığı yerden sürer. "Bu yapı ne?" ve dilbilgisi etiketi dersi açar.
- **Kaydet** → Defter (kaynak satırı "Keşfet: <bölüm adı>"; satır kimliği bölümdeki gibi, kart görsel/ses alır). **Tam hikâye** → `openEpisode`.
- 4–5 klipte bir quiz kartı (puansız; yanlışta "Bir daha bakalım.", "Bilmiyorum"), ~10 klipte mola kartı ("Bugünün adımına geç"), sonda bitiş kartı (sonsuz kaydırma yok).
- Günlük süre: 13–17 **ve 13 altı** 20 dk; yerel gün (`app_meta` `discover.watch.<gün>`), yalnızca dolunca sakin kart, izlerken geri sayım yok. 18+ ve yaş bilgisi yoksa sınır yok.
- Yapay zekâ notu akış açılınca ~4 sn (yalnızca klip üstünde). "Hareketi azalt" desteklenir. Yükleniyor (iskelet), boş, hata durumları.
- Video denetleyicileri: ekrandaki + sıradaki 1 klip; ötekiler kare bitince atılır. **Sert sınır 3** (atılmayı bekleyen dahil, yer açılmadan yenisi kurulmaz).

**Bellek ölçümü (2026-10-14, iOS 26.5 simülatörü iPhone 17 Pro, debug, gerçek 720p klipler, yerel içerik sunucusu; `integration_test/h040_memory_test.dart`):** akış 2 tur baştan sona (23 sayfa × 2, sayfa başına 3 sn oynatma). Süreç RSS'i başlangıçta 396,5 MB, en yüksek 456,6 MB (+60 MB, ilk klip açılırken), tur sonlarında 389,8 / 408,8 MB, akış kapanınca 410,6 MB: **turdan tura büyüme yok** (sızıntı yok). Aynı anda en çok **2** denetleyici (sınır 3), 34 denetleyici kurulup atıldı. Widget testinde (sahte platform, 22 klip) aynı anda en çok 3 (atılmayı bekleyen dahil) doğrulanır. Not: debug derlemede RSS'in mutlak değeri yayın derlemesinden yüksektir; karşılaştırma için turlar arası fark esas alınmalı.

**Testler:** `test/features/discover/discover_feed_test.dart` (25), `test/goldens/h040_discover_golden_test.dart` (5 golden + erişilebilirlik + 320×568 1,3×: 15), `integration_test/h040_memory_test.dart` (simülatör ölçümü).

**Açık sorular:**
- 13 altına da 20 dk varsayılan sınır uygulandı (K-15 yalnız 13–17 diyor); kullanıcı onayladı (2026-10-14 kaydı).
- Sınırın ayarlardan değiştirilmesi (ICERIK-MIMARISI §6.5) bu işte yok.
- Defter kaynağı için ayrı bir `discover` kaynak türü backend'de (V9 `CHECK`) yok; şimdilik `user_saved` + `sourceTitle` "Keşfet: …". Ayrı tür istenirse backend göçü gerekir.
- Bölümler ve klip dosyası `DRAFT`: yayından önce editör onayı (H-028) ve `content_lint.py --require-approved`.
- "Bu içeriği önerme" düğmesi (ICERIK-MIMARISI §6.5) ve Ana Sayfa'dan sessiz başlayan geçiş bu işte yok.
2026-10-14: Kullanıcı onayladı. 13 yaş altına da günlük 20 dk sınırı uygulanır (kullanıcı onayı). Açık: sınırın ayarlardan değiştirilmesi, "Bu içeriği önerme", klip metinlerinin editör kontrolü.
