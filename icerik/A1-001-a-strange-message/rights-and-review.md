# A1-001 *A Strange Message*: haklar ve inceleme

> Bu dosya 2026-10-30'da depodaki kayıtlardan derlendi (K-01). Yalnız kanıtı olan bilgi yazıldı; kanıtı olmayan yerde "kayıt yok" ya da "doğrulanmadı" denir. **Bu bölüm editör onayından geçmedi.**

## Mevcut durum (`content.json`)
- `status: DRAFT` · `humanReviewed: false` · `rightsStatus: PENDING` · `aiGenerated: true` · `canonVersion: 0.1` · `version: 1`.
- Türkçe çeviri (`ceviri.tr.json`): `APPROVED`, onaylayan: kullanıcı (soru-cevap, 2026-10-12).

## Kaynaklar ve lisans
- **Metin:** hiVelzon'un özgün hikâyesi (*The Missing Signal*, Sezon 1), Claude taslağı. Kanon `icerik/_evren/` (STORY_BIBLE v0.2, kullanıcı onayı H-030). Uyarlama ya da üçüncü taraf metin kaydı yok. Metnin yazım tarihi ayrıca kayıtlı değil; `content.json → coverageCheck` ölçümü 2026-10-11.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile (`content_lint.py`; atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`, `docs/LISANS-RAPORU.md`). Denetim araçları Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA ya da BNC kullanmıyor; LLM istemlerinde kullanılmadıklarına dair bölüm bazında ayrı kayıt yok.
- **Dilbilgisi bağları:** `G-A1-07-can`, `G-A1-01-to-be`, `G-A1-02-to-be-questions-negatives` (`dilbilgisi/`; CEFR-J Grammar Profile yalnız referans).
- **Görseller:** Higgsfield, `gpt_image_2_5` (GPT Image 2.5), 9:16, 2k, quality low; stil öneki `_evren/style/STYLE_PREFIX.md` v1.1, karakter referansları `_evren/style/`. `images/` altında 8 dosya (git dışı). Prompt, job id, tahmini/gerçek kredi ve kullanıcı onayı `PROMPTS.md`'de. Pilot: T1–T2 sahne testi (1 kr) + I1–I5 (2,5 kr); hesap 118,75 → 115,25 kr.
- **Kilit klip:** ★ telsiz ışığı: Seedance 2.0 Mini, 720p, 5 sn, 5 kr (job `30078f0c-7700-4017-897e-1db9553fcea0`, `clips/K-isik-seedance-mini.mp4`); yerel ffmpeg sürümü `clips/K-isik-yerel.mp4` (0 kr). Bölümün toplam Higgsfield harcaması 8,5 kr (118,75 → 110,25).
- **Higgsfield çıktılarının ticari kullanım koşulu:** depoda doğrulanmış kayıt yok (`docs/LISANS-RAPORU.md` kapsamında değil). Hesap: lite plan (H-004).
- **Ses (İngilizce):** İngilizce (ve ilk Türkçe) replikler 2026-10-11'de ElevenLabs `eleven_v3` (with-timestamps, hız 0.9) ile üretildi; hazır sesler. Hesap: videoGenerator'ın ElevenLabs hesabı, **ücretsiz plan** (`PROMPTS.md` "Seslendirme"). O günkü kayıt "yalnızca iç kullanım, yayınlanmaz" diyor; 2026-10-14 kullanıcı kararıyla (hukukçu görüşü, `CLAUDE.md` H-006 ek, `docs/HUKUK-SORULARI.md` §9) ücretsiz hesap sesleri yayında kullanılabilir, yeniden üretim gerekmez.
- **Ses (Türkçe):** Hi ve Türkçe satırlar PatientDesk Alania (`alania-v2`) + Duyu hizalaması, 2026-10-14 (kampanya döneminde ücretsiz; H-083, H-075…H-082). İstek kimlikleri `PROMPTS.md` "Türkçe seslendirme kayıtları"nda. İngilizce ifade parçaları Sarah (`eleven_v3`) ile, kayıtlar aynı dosyada.

## Yapay zekâ açıklaması
- Metin, Türkçe çeviri taslağı, görseller ve sesler yapay zekâ ile üretildi; `content.json → aiGenerated: true`.
- Uygulama içinde "Yapay zekâ ile üretilmiştir" ibaresi videoya **gömülmez**; bölüm başında ~4 sn kısa not gösterilir (Higgsfield kuralı 6, kullanıcı kararı 2026-10-12). Uygulama dışına çıkan her kesitte etiket gömülür (K-14; `export_package.py --ai-label`).
- `final/` altındaki önizlemeler iç pilottur ve "İÇ PİLOT — yayınlanmaz" ibaresi taşır (`PROMPTS.md`); yayın dosyası değildir.

## Güvenlik (13+, şartname §5.5–§5.6)
- `PROMPTS.md` kaydı: "Özgün karakterler. Görselde yazı yok"; ekran yazıları kurguda eklenir (Higgsfield kuralı 7). Kayıtlardaki ses kimlikleri ElevenLabs ve Alania hazır sesleridir; ses klonlama kaydı yok.
- Gerçek marka, ünlü ya da telifli karakter bulunmadığı, şiddet/cinsellik/siyaset/din içermediği: **editör tarafından doğrulanmadı.** Otomatik denetim bu maddeleri kontrol etmiyor.
- Utandırmayan dil, K-32 yasakları ve kanon uyumu (K-34): **editör kontrolü bekliyor.**

## Dil denetimi
- `content_lint.py --no-clips` (2026-10-30): sonuç **TAMAM**, 0 hata; kapsama %98.3 (sözlükle %100.0), 59 token, en uzun cümle 6 sözcük. Çeviri [APPROVED]: 17/17 altyazı satırı, 53/53 kelime anlamlı (özel adlar hariç; toplam 55), 16 kalıp.
- `content.json → coverageCheck` (2026-10-11, cefr_check(scratch) v2: TEPKİ satırları dahil): A1 %98.3, sözlükle %100.0; hedef ≥ %98, alt sınır %95 (K-07).

## Yayın kontrol listesi (şartname §7.2)
Hiçbir madde editör tarafından işaretlenmedi. Otomatik kanıtı olanlar parantezde.
- [ ] CEFR seviyesi ve hedef dilbilgisi uygun (content-lint kapsaması: yukarıda)
- [ ] Kelime ve cümle uzunluğu kılavuza uygun (content-lint)
- [ ] A1–A2 bilinmeyen kelime oranı kontrol edildi (content-lint)
- [ ] Türkçe çeviri insan tarafından gözden geçirildi (kullanıcı onayı var; editör kontrolü yok)
- [ ] Sözlük anlamları bağlama uygun
- [ ] Quiz cevapları doğrulandı
- [ ] TTS telaffuzu ve hız seviyeyle uyumlu
- [ ] Altyazı senkronizasyonu kontrol edildi
- [ ] Görsel-sahne uyumu doğrulandı (Claude değerlendirmesi `PROMPTS.md`'de; editör değil)
- [ ] Ses seviyesi, boşluklar ve geçişler kontrol edildi
- [ ] Telif, marka, kişi benzerliği ve yaş uygunluğu kontrol edildi
- [ ] AI ile üretildi bilgisi gerektiği yerde mevcut
- [ ] Prompt ve maliyet kaydı mevcut (`PROMPTS.md` var)
- [ ] Mobilde portre/yatay oranlar ve güvenli alanlar kontrol edildi
- [ ] Editör onayı kaydedildi

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| 2026-10-11 | Pilot görselleri, kilit klip ve ses (H-024); her ücretli adım soru-cevapla onaylandı | Claude / kullanıcı | Kayıt `PROMPTS.md` |
| 2026-10-12 | Türkçe çeviri onayı (H-028) | Kullanıcı | `APPROVED` (kullanıcı (soru-cevap, 2026-10-12)) |
| — | Haklar kontrolü (`rightsStatus`) | Editör / kullanıcı | Bekliyor (`PENDING`) |
| — | Editör toplu kontrolü (H-028, `humanReviewed`) | Editör | Bekliyor (`false`) |
| — | Yayın onayı (K-05, `APPROVED` backend'de) | Editör hesabı | Bekliyor (`DRAFT`) |
