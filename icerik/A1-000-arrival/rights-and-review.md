# A1-000 *Arrival*: haklar ve inceleme

> Bu dosya 2026-10-30'da depodaki kayıtlardan derlendi (K-01). Yalnız kanıtı olan bilgi yazıldı; kanıtı olmayan yerde "kayıt yok" ya da "doğrulanmadı" denir. **Bu bölüm editör onayından geçmedi.**

## Mevcut durum (`content.json`)
- `status: DRAFT` · `humanReviewed: false` · `rightsStatus: PENDING` · `aiGenerated: true` · `canonVersion: 0.1` · `version: 1`.
- Türkçe çeviri dosyası (`ceviri.tr.json`) yok.
- Prolog isteğe bağlıdır (`optional: true`) ve **üretilmedi**: klasörde yalnız `content.json` ve `story.en.md` var; görsel, ses, `PROMPTS.md` ve `story.tr.md` yok (`docs/EDITOR-INCELEME-PAKETI.md` §7: inceleme dışı).

## Kaynaklar ve lisans
- **Metin:** hiVelzon'un özgün hikâyesi (*The Missing Signal*, Sezon 1), Claude taslağı. Kanon `icerik/_evren/` (STORY_BIBLE v0.2, kullanıcı onayı H-030). Uyarlama ya da üçüncü taraf metin kaydı yok. Metnin yazım tarihi ayrıca kayıtlı değil; `content.json → coverageCheck` ölçümü 2026-10-11.
- **Kelime listesi:** Seviye denetimi CEFR-J Wordlist v1.6 ile (`content_lint.py`; atıf: Tono Laboratory, TUFS; `tools/content-pipeline/data/README.md`, `docs/LISANS-RAPORU.md`). Denetim araçları Cambridge EVP/EGP, Oxford 3000/5000, GSE, COCA ya da BNC kullanmıyor; LLM istemlerinde kullanılmadıklarına dair bölüm bazında ayrı kayıt yok.
- **Dilbilgisi bağları:** `G-A1-01-to-be`, `G-A1-03-a-an` (`dilbilgisi/`; CEFR-J Grammar Profile yalnız referans).
- **Görseller, klip, ses:** üretilmedi; `PROMPTS.md` yok.

## Yapay zekâ açıklaması
- Metin yapay zekâ (Claude) ile üretildi; `content.json → aiGenerated: true`.
- Uygulama içinde "Yapay zekâ ile üretilmiştir" ibaresi videoya **gömülmez**; bölüm başında ~4 sn kısa not gösterilir (Higgsfield kuralı 6, kullanıcı kararı 2026-10-12). Uygulama dışına çıkan her kesitte etiket gömülür (K-14; `export_package.py --ai-label`).

## Güvenlik (13+, şartname §5.5–§5.6)
- Gerçek marka, ünlü ya da telifli karakter bulunmadığı, şiddet/cinsellik/siyaset/din içermediği: **editör tarafından doğrulanmadı.** Otomatik denetim bu maddeleri kontrol etmiyor.
- Utandırmayan dil, K-32 yasakları ve kanon uyumu (K-34): **editör kontrolü bekliyor.**

## Dil denetimi
- `content_lint.py --no-clips` (2026-10-30): sonuç **UYARI**, 0 hata; kapsama %98.3 (sözlükle %100.0), 60 token, en uzun cümle 5 sözcük. Uyarı türleri: translation.
- `content.json → coverageCheck` (2026-10-11, cefr_check(scratch) v2: TEPKİ satırları dahil): A1 %98.2, sözlükle %100.0; hedef ≥ %98, alt sınır %95 (K-07).

## Yayın kontrol listesi (şartname §7.2)
Hiçbir madde editör tarafından işaretlenmedi. Otomatik kanıtı olanlar parantezde.
- [ ] CEFR seviyesi ve hedef dilbilgisi uygun (content-lint kapsaması: yukarıda)
- [ ] Kelime ve cümle uzunluğu kılavuza uygun (content-lint)
- [ ] A1–A2 bilinmeyen kelime oranı kontrol edildi (content-lint)
- [ ] Türkçe çeviri insan tarafından gözden geçirildi
- [ ] Sözlük anlamları bağlama uygun
- [ ] Quiz cevapları doğrulandı
- [ ] TTS telaffuzu ve hız seviyeyle uyumlu
- [ ] Altyazı senkronizasyonu kontrol edildi
- [ ] Görsel-sahne uyumu doğrulandı
- [ ] Ses seviyesi, boşluklar ve geçişler kontrol edildi
- [ ] Telif, marka, kişi benzerliği ve yaş uygunluğu kontrol edildi
- [ ] AI ile üretildi bilgisi gerektiği yerde mevcut
- [ ] Prompt ve maliyet kaydı mevcut (`PROMPTS.md` yok)
- [ ] Mobilde portre/yatay oranlar ve güvenli alanlar kontrol edildi
- [ ] Editör onayı kaydedildi

## Onay geçmişi
| Tarih | Adım | Kim | Sonuç |
|---|---|---|---|
| — | Haklar kontrolü (`rightsStatus`) | Editör / kullanıcı | Bekliyor (`PENDING`) |
| — | Editör toplu kontrolü (H-028, `humanReviewed`) | Editör | Bekliyor (`false`) |
| — | Yayın onayı (K-05, `APPROVED` backend'de) | Editör hesabı | Bekliyor (`DRAFT`) |
