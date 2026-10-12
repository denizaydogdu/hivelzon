# PROMPTS: A1-004-the-note (üretim, 2026-10-11)

- **Stil:** `_evren/style/STYLE_PREFIX.md` v1.1 (her prompt'un sonuna eklenir).
- **Model:** gpt_image_2_5, 9:16, 2k, quality low.
- **Telif ve AI kontrolü:** Özgün karakterler. Görselde yazı yok; notlar, mesajlar ve haritadaki yazılar kurguda eklenir.
- **Kullanıcı onayı:** soru-cevap, "Evet, 11,5 kredi" (B2–B4 + Maya referansı).
- **Referanslar:** Alex `663ea0fe…`, Maya `6db4fa91…` (R4), telsiz `74fb45e8…`.

## Görseller

| Ad | Referanslar | Kredi | Job ID | Prompt (STYLE hariç) |
|---|---|---|---|---|
| B4-01-dukkan-sabah | Maya,Alex | 0,5 | 34badcb7-337a-4d61-b25f-b8573870ebf4 | Use the reference images for Maya and Alex. Scene: Monday morning in the cozy book-and-tea shop; Maya at the counter writing in her notebook, Alex arrives holding out her phone with excitement; steam rising from tea cups. Vertical composition. |
| B4-02-telefon-not | Alex | 0,5 | d1cbfa1b-314d-49cd-a14d-6d041c93df53 | Close-up over Alex's shoulder: her hand holds a phone showing a photo of a rain-stained paper note pinned to a wooden door; the note shows only faint blurred smudges, no readable letters. Cozy shop background softly blurred. Vertical composition. |
| B4-03-uc-kart | — | 0,5 | 4f81af42-a1c8-4365-af55-47f36bb9c54c | Top-down view of a wooden table with three small illustrated picture cards side by side: a calendar page with blank squares and no numbers, a small bird inside a cage, and a plate of fried fish. No text on the cards. Vertical composition. |
| B4-04-saat-cizimi | — | 0,5 | e6d08db8-bea4-43f4-906e-899b2cc32a2b | Extreme close-up of the torn corner of a rain-stained paper note: a small hand-drawn clock face without any numbers, the short hand pointing to seven and the long hand pointing to twelve, half washed out by rain. Vertical composition. |
| B4-05-maya-isik | Maya | 0,5 | d6b5e7d9-cce9-4646-a531-f2ac7ad4bea1 | Use the reference image for Maya. Scene: Maya holds a phone up toward the bright shop window, squinting carefully at the screen as if reading faint marks, focused and curious. The screen faces away from the viewer. Vertical composition. |
| B4-06-iskele-harita | — | 0,5 | 140ee4d2-800d-49e0-8cd8-9264bc581f1f | Top-down view of a paper map of a small harbour laid on a wooden table: several numbered piers drawn as simple lines but with no actual numbers or text visible, a pencil and a tea cup at the edge. Vertical composition. |
| B4-07-telsiz-not | Alex,telsiz | 0,5 | be3ed7af-fbf6-4bbd-bf7c-c89acd327227 | Use the reference images for Alex and the old radio. Scene: in the cozy shop, Alex quietly takes the old radio out of her backpack's side pocket; a small yellowed folded paper note slips from the radio into her hand; her face becomes thoughtful and surprised. Vertical composition. |
| B4-08-iki-not | telsiz | 0,5 | 4debe97d-8fb8-4611-985c-68d1858438b6 | Use the reference image for the old radio. Scene: evening, a wooden desk in a small room: two paper notes lie side by side - an old yellowed folded note and a newer rain-stained note - both with only faint illegible marks, no readable letters; the old radio stands behind them, light off; warm lamp light. Vertical composition. |

## Seslendirme

- **Sağlayıcı:** ElevenLabs `eleven_v3` with-timestamps, speed 0.9, `language_code` en/tr.
- **Hesap:** videoGenerator hesabı; ücretsiz plan. **Yalnızca iç kullanım, yayınlanmaz** (H-006).
- **Sesler:** Jessica (Alex), Lily (telsiz), River (Hi), Sarah (Maya).
- **Tüketim:** 33 satır, 1098 karakter.
- **Dosyalar:**
  - `audio/*.mp3` (git dışı) ve `audio/*.align.json`;
  - `audio_manifest.json`: replik → ses kimliği eşlemesi. B1 ile aynı telsiz replikleri B1'in kayıtlarını kullanır.

## B4-01 yeniden üretim (2026-10-11)

- **Sorun:** İlk üretimde (job 34badcb7…, `images/B4-01-dukkan-sabah_v1-hatali.*`) Maya, Alex'in zeytin yeşili ceketiyle çıktı; iki karakter ikiz gibi görünüyordu.
- **Düzeltme:** Prompt'a iki karakterin farklı kıyafetleri açıkça yazıldı. Maya: çizgili kazak + önlük, "NO olive jacket". Alex: zeytin yeşili ceket + sırt çantası.
- **Yeni job:** 684f0cd3-2d34-4306-aa7c-e92e53bb67b9. Tahmin 0,5 / gerçek 0,5.
- **Kullanıcı onayı:** soru-cevap. ✅ Sonuç doğru. **Kredi: 98,25.**
- **Ders:** Birden çok referanslı sahnede karakterlerin ayırt edici kıyafeti prompt'ta açıkça yazılmalı.

## b4_30_maya yeniden seslendirme (H-046, 2026-10-11)

- **Neden:** t-kanit görevindeki Maya repliği "I have Art on Friday. What time is it?" bağlamda belirsizdi ("Şu an saat kaç?" gibi okunuyordu). Kullanıcı kararıyla "I have Art on Friday. What time?" olarak düzeltildi; anlamı "Saat kaçta?". `story.en.md`, `kurgu.json` (prompt.en, item stem), `audio_manifest.json`, `ceviri.tr.json` birlikte güncellendi.
- **Sağlayıcı:** ElevenLabs `eleven_v3` with-timestamps, speed 0.9, `language_code` en; ses Sarah (Maya, `EXAVITQu4vr4xnSDxMaL`), önceki kayıtla aynı ayarlar.
- **Hesap:** videoGenerator hesabı (yerel, iç kullanım; H-006 ek).
- **Çağrı:** 1 TTS çağrısı, **32 karakter**. Metin: `I have Art on Friday. What time?`
- **Çıktı:** `audio/b4_30_maya.mp3` (2,32 sn) + `audio/b4_30_maya.align.json`. Eski dosyalar oturum geçici klasörüne yedeklendi.
- **Kullanıcı onayı:** H-046 soru-cevap.
