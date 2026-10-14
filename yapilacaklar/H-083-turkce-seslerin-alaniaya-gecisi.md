# H-083: Türkçe seslerin Alania'ya geçişi

- **Durum:** Yapılacak
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
