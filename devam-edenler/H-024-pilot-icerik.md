# H-024: Pilot içerik: A1-001 hikâyesi ve 3 kısa klip

- **Durum:** Devam ediyor (2026-10-11'de başladı; kullanıcı mevcut kredilerle başlamayı onayladı)
- **Tür:** İçerik üretimi (kredi harcar, onaylı)
- **Öncelik:** Yüksek
- **Bağımlılık:** H-004, H-005

## Amaç
Gerçek kredi ve emek maliyetini ölçmek; ucuz yol (görsel + Ken Burns + TTS + altyazı) ile `higgsfield-video-explainer`'ı aynı hikâyede karşılaştırmak.

## Kapsam
- `icerik/A1-001-<kisa-baslik>/` CLAUDE.md'deki dosya düzeniyle kurulur.
- Hikâye, çeviri, sözlük ve quiz yazılır; editör kontrolünden geçer.
- Her Higgsfield üretiminden önce `generate cost` sonucu gösterilir ve **onay alınır**; her şey `PROMPTS.md`'ye kaydedilir.
- 3 kısa klip uzun hikâyeden türetilir.

## Kabul kriterleri
- §5.5 ve şartname §7.2 kontrol listeleri tamamlanmış.
- Harcanan kredi ve emek (saat) kaydedilmiş.
- İki üretim yolunun karşılaştırması yazılmış ve kullanıcı birini seçmiş.
- Sosyal medyada yayın yapılmamış (H-017).

## Kaynak
`IS-PLANI.md` §11 Faz 0 · `SARTNAME.md` §7, §8

## Notlar
2026-10-11: `docs/SARTNAME.md` ve `docs/IS-PLANI.md` karşılaştırmasından açıldı.
2026-10-11: Pilot artık **S1·B1 "A Strange Message"** etkileşimli bölümü + 3 klip olacak. İçinde 2 karar anı, 1 tepki dalı, Hi'nin dil laboratuvarı ve ipucu açılışı var. Ken Burns ile video-explainer karşılaştırması korunur. Bağımlılık: H-029, H-030.

## İlerleme (2026-10-11)

**1. Referans sayfaları** (Alex, Hi, telsiz × Nano Banana 2 ve GPT Image 2.5): 7,5 kredi.
- Kullanıcının seçimi: **GPT Image 2.5** (K-24).
- Nano telsiz görseli yazı kuralını çiğnedi.
- Kayıt: `icerik/_evren/style/PROMPTS.md`, `STYLE_PREFIX.md` v1.1.

**2. B1 sahne testi** (T1 oda, T2 POV; 9:16): 1 kredi.
- Karakter tutarlılığı iyi.
- Kayıt: `icerik/A1-001-a-strange-message/PROMPTS.md`.

**3. Kilit klip maliyetleri:** Seedance 2.5 15–35 kredi; Mini ve Grok Lite 5 kredi; yerel geçiş 0.

**Kredi:** 126,25 → 117,75.

**Bekleyenler:**
- B1'in kalan görselleri;
- klip yöntemi;
- ElevenLabs ticari anahtarı (TTS);
- Ken Burns ile video-explainer karşılaştırması.

