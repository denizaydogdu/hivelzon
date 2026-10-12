# H-052: Defter ince ayarı ("Listen." ve sözlük filtresi)

- **Durum:** Bitti
- **Tür:** İçerik + boru hattı + uygulama
- **Bağımlılık:** H-036

## Kapsam (kullanıcı kararı 2026-10-12)
- B1 hedef ifadesi "Listen." hiçbir altyazıda yok: `ceviri.tr.json`'a anlam ("Dinle.") eklenir; kart görsel + anlamla desteye girer. Ses: yerel TTS (iç kullanım) ya da sonraki seslendirmede.
- Bölüm sözlüğü (content.json `glossary` / seviye üstü kelimeler) pakete eklenir; altyazıda bakılan kelimelerden yalnızca sözlükteki seviye kelimeleri karta dönüşür. Paketler kredisiz yeniden üretilir.
- content-lint: her hedef ifadenin anlamı var mı denetlenir.

## Kabul kriterleri
- B1 destesinde 5 hedef ifade; sözlük dışı bakılan kelime karta dönüşmüyor (test).
- pytest + flutter test yeşil.

## Notlar

### 2026-10-12 — uygulama ve doğrulama
- **Şema:** `ceviri.tr.json` için yeni üst düzey alan `phrases: [{en, tr, words, source, note}]` eklendi. Bu alan, altyazıda geçmeyen hedef ifadelerin ve sözlük kelimelerinin anlamını tutar. Eklenen girdiler:
  - B1: *Listen.* → "Dinle.";
  - B2: *Excuse me, where is…?* → "Affedersiniz, … nerede?" (görev kartıyla aynı; bu ifadenin de anlamı yoktu);
  - B3: *next to* → "…-in yanında" (sözlük kelimesi).
  - Bu üç girdi Claude taslağıdır; editör onayı bekliyor.
- **Paket:** `episode.glossary: [{w, tr}]` eklendi. Kaynağı `content.json` → `glossary`; Türkçesi sırasıyla `phrases` → kalıp → satır kelime anlamından gelir. Hedef ifadenin anlamı için arama sırası: satır → kalıp → `phrases`.
- **content-lint:**
  - `target-meaning` (hata): hedef ifadenin anlamı yok.
  - `glossary-meaning` (uyarı): sözlük kelimesinin anlamı yok.
  - Belgeler güncellendi: `docs/BOLUM-PAKETI.md` (§2, §3.1 ve kurallar tablosu).
- **Uygulama:**
  - Altyazıda bakılan kelime yalnızca bölüm sözlüğündeyse karta dönüşür; eski durak kelime listesi kaldırıldı.
  - Altyazıda ve karar anında geçmeyen hedef ifade de karta dönüşür: görsel + anlam var, ses yok.
  - Deste biçimi `d2`: H-052'den önce aktarılmış bölümler bir kez yeniden aktarılır. Bu aktarım idempotenttir. Simülatörde günlük: "A1-001 deftere: 5 kart (1 yeni)", "A1-002 deftere: 5 kart (1 yeni)".
- **Doğrulama:**
  - pytest **70 geçti**.
  - content-lint `icerik/A1-0*`: **13 bölüm, 0 hata, 16 uyarı** (B1–B4: 0 hata).
  - Dışa aktarma: B1–B4 + Sezon 1 paketi, kredisiz, ~50 sn.
  - Senkron, en büyük fark: B1 0,003 sn · B2 0,01 sn · B3 0,007 sn · B4 0,01 sn (eşik 0,2 sn).
  - Ses: B1 -16,16 · B2 -16,05 · B3 -16,01 · B4 -16,12 LUFS.
  - Test fikstürleri paketlerden kopyalandı.
  - flutter analyze temiz; flutter test **193 geçti**.
- **Kabul kriterleri:**
  - B1 destesinde 5 hedef ifade var (`deck_builder_test`, `notebook_ui_test`).
  - Sözlük dışında bakılan kelime ("hear", "you") karta dönüşmüyor (`deck_builder_test`).
  - Simülatörde Defter'de "Listen. / Dinle." kartı görsel ve anlamla görünüyor, ses düğmesi yok: `h053-b1-listen-card.png`.
2026-10-12 (ana oturum): flutter test 193/193, pytest 70/70, analyze temiz yeniden doğrulandı. Kullanıcı yeni anlamları (Listen. / Excuse me, where is…? / next to) onayladı; commit onayı.
