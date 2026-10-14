# H-083: Türkçe seslerin Alania'ya geçişi

- **Durum:** Devam ediyor (44 klip Alania; main'de; kullanıcının (a)/(b) seçimi ve ses eşlemesi onayı bekleniyor)
- **Tür:** İçerik üretimi + uygulama (araç ve mobil)
- **Faz:** Dilbilgisi D0 devamı (`docs/DILBILGISI.md` §2, Türkçe ses)
- **Bağımlılık:** H-075

## Kapsam
Kullanıcı kararı (2026-10-14): "Uygulamadaki Türkçe konuşan her yer Alania ile."

1. **Mevcut Türkçe sesler:** Bölüm 1–4'teki 14 Hi repliği (~978 karakter; şu an ElevenLabs River) Alania `alania2-f1` ile yeniden üretilir.
   - Bu repliklerde balon, Hi kartı ve yanlış cevap ipucu var.
   - Bunlar ayrı ses klipleridir, video yeniden kurgulanmaz.
   - İngilizce ifade içeren satırlar için iki yol denenir ve kullanıcıya dinletilir:
     - (a) tümü Alania, söyleniş sözlüğüyle;
     - (b) Türkçe kısım Alania, İngilizce ifade İngilizce sesle, arka arkaya.
2. **Yeni Türkçe sesler** (kullanıcı seçti):
   - Hi'nin sesi üretilmemiş replikleri (ör. A1-003 `r-k2-b`) ve Hi panelinin Türkçe metinleri (hata kataloğu, konu tanıtımları, köprü görevleri; ~2.800 karakter). Uygulamada Hi panelinde dinle düğmesi eklenir.
   - Alex'in Türkçe cümleleri (A1-002, A1-004), genç kadın sesiyle.
   - Babaannenin notu (A1-004 `c-nermin`), olgun, sıcak, yavaş sesle.
   - İpucu panosu ve "AÇIK SORU" kartları, anlatıcı sesiyle. Gerekirse kart sesi desteği eklenir.
3. **Karakter–ses eşlemesi** sabit tutulur ve `icerik/_evren/` altında yazılır.
4. **Dışa aktarma düzeltmesi:** Türkçe klipler kendi -16 LUFS normalizasyonunu korur; bölüm kazancı üstüne ikinci kez uygulanmaz.

## Kabul kriterleri
- Bütün Türkçe sesler Alania'dan gelir.
- content-lint 0 hata; pytest ve flutter test yeşil.
- Kullanıcı karışık dil satırları için seçimini yapar.

## Test
`tools/content-pipeline/.venv/bin/python -m pytest tools/content-pipeline` · `content_lint.py icerik/A1-0*` · `cd mobile && flutter test`

## Geri alma
Kendi dalında; eski ElevenLabs sesleri `_raw`/yedekte kalır; `git revert`.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı ("ses kalitesi çok güzel; Türkçe konuşan her yeri Alania'ya çevirelim"). PatientDesk kampanyası 14 Kasım 2026'ya kadar ücretsiz ve sınırsız.

2026-10-14 (dal `h-083-turkce-sesler`, uygulandı; kullanıcı dinleyip seçecek):
- **Ses eşlemesi** `icerik/_evren/sesler.json` (DILBILGISI §2.1): Hi `alania2-f1`, Alex `alania2-nisa`, babaanne Nermin `alania2-selin` (+ yavaş, sıcak üslup), anlatıcı `alania2-m1` (+ sakin üslup); İngilizce ifadeler Sarah. Ses denemeleri: `.yerel/h083/ses-secimi/<ses>/` (8 aday).
- **Araç** `tools/content-pipeline/tts_episode_tr.py` (BOLUM-PAKETI §5.1, §6): kurgu.json + Hi verisinden Türkçe yerleri toplar; `speechTr` ile İngilizce ifadeler `{…}` işaretlenir; kuru çalışma varsayılan, iki tavan, idempotent, PROMPTS kaydı, eski ElevenLabs sesleri `audio/_raw/elevenlabs/`. content-lint `tr-voice` kuralı.
- **Üretildi:** 44 ses (bölüm 26, Hi verisi 18): 14 eski Hi repliği Alania'ya geçti; yeni: A1-003 `r-k2-b`, Alex (A1-002, A1-004), babaanne notu, 8 ipucu/açık soru kartı, 9 hata notu, 5 konu tanıtımı, 4 köprü görevi. Alania 3.411 karakter (+ ses denemesi 1.384), ElevenLabs Sarah 709 karakter (hesap 2: 7.268 / 10.000). Duyu hizalaması: bütün sesler uyarısız (Türkçe kelimelerin tamamı eşleşti).
- **Karışık satırlar:** varsayılan b (Alania + Sarah); A1-004 `c-oq` ("Pier 3'te") a kipi. Karşılaştırma: `.yerel/h083/b2_17_hi-{a-alania-soylenis,b-alania-sarah}.mp3`, `.yerel/h083/b4_21_hi-…`. a kipinde b4_21'de Duyu ilk cümleden sonrasını tanıyamadı (söyleniş sözlüğüyle okunan İngilizce Türkçe sese karışıyor).
- **Dışa aktarma:** Türkçe klipler kendi -16 LUFS düzeyinde (bölüm kazancı yok; `manifest.loudness.turkishClips`). Hi verisi sesleri sezon paketinde `hi/<ad>.m4a`.
- **Uygulama:** ipucu, açık soru, Alex ve not kartları zaten `audio`yu kendiliğinden çalıyor ve "Dinle" gösteriyordu (testler eklendi). Hi panelinde hata notu, konu tanıtımı ve köprü görevi kartlarına "Dinle" düğmesi (kapanınca durur). Uygulamada sessiz kipi yok.
- **Kapsam dışı kaldı (sonra sorulacak):** karar ipuçları (`hints[].tr`), karar ve görev yönergeleri (`prompt.tr`) Türkçe ama seslendirilmedi.
- **Bekleyen:** kullanıcının a/b seçimi ve ses eşlemesi onayı.
