# H-034: Bölüm paketi formatı, dışa aktarma ve content-lint

- **Durum:** Bitti
- **Tür:** Uygulama (kod)
- **Faz:** 1.1 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-033

## Kapsam
- `scenes.json` şeması (JSON Schema): düğüm türleri segment, karar, tepki, kart, görev; kenarlar; bayraklar (bölüm başına ≤ 3).
- Geçici kurgu araçlarının kalıcı sürümü `tools/content-pipeline/`: B1–B4'ü segment MP4 + altyazı JSON (zaman damgalı) + `scenes.json` paketine dönüştürür.
- `content-lint` ilk sürümü: A1 kapsama (CEFR-J), cümle uzunluğu, bağ alanları, grafik denetimi (ulaşılamayan düğüm, çıkışsız karar).
- Sırlar repoya girmez; medya git dışında kalır.

## Kabul kriterleri
- B1–B4 paketleri üretiliyor.
- `content-lint` dört bölümü geçiriyor; bozuk örnek pakette hata veriyor (test).
- Şema belgelendi.

## Test
```bash
python3 -m pytest tools/content-pipeline
python3 tools/content-pipeline/content_lint.py icerik/A1-001-*
```

## Geri alma
Kendi dalında (`h-034-bolum-paketi-formati`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.

### 2026-10-11: Doğrulama özeti (uygulama)

**Yapılanlar:** `tools/content-pipeline/` (stdlib Python; `hvpipeline` paketi, `export_package.py`, `content_lint.py`), şema `schema/scenes.schema.json` + `schema/subs.schema.json` (`schemaVersion: 1`), belge `docs/BOLUM-PAKETI.md`, bölüm kaynakları `icerik/A1-00[1-4]-*/kurgu.json`, CEFR-J v1.6 verisi + atıf (`data/`), CI işi `content-pipeline` (checkout/setup-java v5'e yükseltildi). Ücretli çağrı yapılmadı; story.en.md ve content.json değişmedi.

**Testler:** `.venv/bin/python -m pytest tools/content-pipeline` → `43 passed` (jsonschema 4.25.1 ile çapraz denetim dahil; bozuk örnek paket hata veriyor).

**content-lint** (`icerik/A1-0*`, 13 bölüm): `0 hata, 7 uyarı`, çıkış 0. A1 kapsama (sözlükle):
000 %98,3 (100) · 001 %98,3 (100) · 002 %98,0 (100) · 003 %96,2 (100) · 004 %97,7 (100) · 005 %98,4 (99,5) · 006 %98,2 (100) · 007 %98,0 (99,6) · 008 %97,4 (100) · 009 %96,0 (99,6) · 010 %98,6 (100) · 011 %98,4 (100) · 012 %99,0 (100). 8 sözcüğü aşan cümle yok.
Uyarılar: 003, 004, 008, 009 %95–98 bandında (sözlükle ≥ %98; görsel desteği editör doğrulamalı); sözlükte olmayan liste dışı: 005 *yeah* (A2), 007 *voice* (A2), 009 *far* (A2).

**Dışa aktarma** (`export_package.py icerik/A1-00[1-4]-*`, önbellekle ~51 sn, ilk çalıştırma ~3 dk):

| Bölüm | Video dosyası (segment + tepki) | Karar | Yalnızca metin | Senkron en büyük fark (%35 eşik / %10 eşik) | Ses (LUFS) | Paket |
|---|---|---|---|---|---|---|
| A1-001 | 10 (8 + 2) | 2 | 0 | 0,09 / 0,003 sn | -16,1 | 29,3 MB |
| A1-002 | 10 (9 + 1) | 2 | 1 | 0,04 / 0,01 sn | -16,0 | 46,7 MB |
| A1-003 | 7 (5 + 2) | 3 | 4 | 0,13 / 0,007 sn | -16,0 | 30,8 MB |
| A1-004 | 12 (9 + 3) | 2 | 1 | **0,21** / 0,01 sn | -16,1 | 48,3 MB |

- ffprobe: bütün segmentler `h264 High 1080x1920 yuv420p`, `aac 44100 Hz 2ch`, faststart; ses-görüntü süre farkı ≤ 0,001 sn.
- **A1-004 `k2-ok`:** pilot ölçüm yöntemi (%35 eşik) 0,21 sn veriyor. Neden: "It's" yumuşak başlıyor (tepe değerin %29'u), ölçüm "seven"i yakalıyor. %10 eşikle fark 0,01 sn. Araç bu bölümü "SORUN" olarak işaretliyor; kural gevşetilmedi.
- Yalnızca metin: 002 `c-alex` (Alex'in TR iç sesi); 003 `r-k2-b` Hi balonu sessiz, `r-k3-b` videosuz (yalnızca Hi balonu), `t-gorev` ve `t-kanit` harita görseli yok (seçenekler metin); 004 `c-alex` (Alex'in TR repliği).
- Editör onayı bekleyenler: kararların 1. ve 2. düzey Hi ipuçları; B3 görev ve kanıt seçenek metinleri (kurgu.json'da yazıldı).
2026-10-11 (ana oturum doğrulaması): pytest 43/43; content-lint 13 bölümde çıkış 0. Senkron kararı %10 eşiğe alındı (A1-004 k2-ok'ta %35 eşik yumuşak "It's"i kaçırıp "seven"i ölçüyordu; 20 ms zarfla elle bakıldı: ses 0,48–0,50 sn, ipucu 0,50 sn). Sınır 0,2 sn değişmedi. Yeniden dışa aktarım: B1 0,003 · B2 0,01 · B3 0,007 · B4 0,01 sn; dördü TAMAM.
