# PROMPTS: A1-002-the-new-neighbour (üretim, 2026-10-11)

- **Stil:** `_evren/style/STYLE_PREFIX.md` v1.1 (her prompt'un sonuna eklenir).
- **Model:** gpt_image_2_5, 9:16, 2k, quality low.
- **Telif ve AI kontrolü:** Özgün karakterler. Görselde yazı yok; notlar, mesajlar ve haritadaki yazılar kurguda eklenir.
- **Kullanıcı onayı:** soru-cevap, "Evet, 11,5 kredi" (B2–B4 + Maya referansı).
- **Referanslar:** Alex `663ea0fe…`, Maya `6db4fa91…` (R4), telsiz `74fb45e8…`.

## Görseller

| Ad | Referanslar | Kredi | Job ID | Prompt (STYLE hariç) |
|---|---|---|---|---|
| B2-01-dukkan-dis | — | 0,5 | b8d39d0b-e619-43d8-87bd-d76955dce9f8 | Morning in a quiet harbour street of a coastal town: the front of a small cozy shop with a large window full of stacked books and tea cups, a wooden door with a small bell, potted plants, soft morning light, nobody outside. No sign text. Vertical composition. |
| B2-02-maya-tezgah | Maya | 0,5 | 51fc6157-b427-457f-ac8d-8e6c2b44dd12 | Use the reference image for Maya; keep the same face, curly hair and clothes but she wears a simple apron over her sweater. Scene: inside a cozy book-and-tea shop in the morning, Maya stands behind the wooden counter and looks up with a warm, welcoming smile, as if a customer just came in; shelves of books, tea jars, warm light. Vertical composition. |
| B2-03-maya-pov | Maya,Alex | 0,5 | 56383b2c-703b-4f7b-95ac-0909192dbc48 | Use the reference images for Maya and Alex. First-person view from Alex, standing at the shop counter: Maya smiles and offers a friendly hand to shake; Alex's hand with olive jacket sleeve enters the frame. Cozy book-and-tea shop, morning light, background softly blurred. Vertical composition. |
| B2-04-anne-foto | Maya | 0,5 | 26d1a6c2-2b43-439a-a345-e071d55b75e8 | Use the reference image for Maya. Scene: in the cozy shop, Maya points at a framed photo on the wall: the photo shows Maya and a teenage boy with glasses and headphones around his neck, both smiling. Next to Maya stands her mother, a kind woman in her late forties with curly greying hair and an apron, smiling. No text. Vertical composition. |
| B2-05-maya-sasirma | Maya | 0,5 | bf622335-59ca-4cde-a4f4-f4b8f6c06138 | Use the reference image for Maya. Scene: Maya behind the shop counter tilts her head with a gentle, puzzled smile, trying to understand a customer, one eyebrow raised, friendly and patient, not mocking. Cozy shop, morning light. Vertical composition. |
| B2-06-maya-harita | Maya,Alex | 0,5 | 5639593d-bab4-4f17-88ee-e38d3e49013a | Use the reference images for Maya and Alex. Scene: at the shop counter Maya unfolds a large paper map of the coastal town and draws a circle around the harbour area with a pencil; Alex leans in, curious and hopeful. The map shows streets, piers and the sea, with no labels and no text. Vertical composition. |
| B2-07-oda-harita | Alex,telsiz | 0,5 | 034ff5f4-4fa9-4183-a73b-bcf992b7053f | Use the reference images for Alex and the old radio. Scene: evening in Alex's small rented room; Alex sits at the desk looking thoughtfully at a paper map with a pencil circle around the harbour; the old radio on the desk beside her, light off; window shows the harbour at dusk. Map has no text. Vertical composition. |

## Seslendirme

- **Sağlayıcı:** ElevenLabs `eleven_v3` with-timestamps, speed 0.9, `language_code` en/tr.
- **Hesap:** videoGenerator hesabı; ücretsiz plan. **Yalnızca iç kullanım, yayınlanmaz** (H-006).
- **Sesler:** Alice (Mrs Brooks), Jessica (Alex), Lily (telsiz), River (Hi), Sarah (Maya).
- **Tüketim:** 29 satır, 812 karakter.
- **Dosyalar:**
  - `audio/*.mp3` (git dışı) ve `audio/*.align.json`;
  - `audio_manifest.json`: replik → ses kimliği eşlemesi. B1 ile aynı telsiz replikleri B1'in kayıtlarını kullanır.
