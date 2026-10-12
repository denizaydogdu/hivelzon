# A1-002: *The New Neighbour* (Yeni Komşu) (S1 · B2) · Türkçe çeviri

> **Durum:** TASLAK (Claude, 2026-10-11) — kullanıcı onayı bekliyor (H-046)
> **Kaynak:** `story.en.md` (taslak 0.1). Satır satır veri: `ceviri.tr.json`.
> **Görev kartı:** Komşunla tanış ve Old Station hakkında **3 bilgi** öğren.
> **Hedef ifadeler:** *Nice to meet you.* (Tanıştığımıza memnun oldum.) · *This is my…* (Bu benim…) · *Excuse me, where is…?* (Affedersiniz, … nerede?) · *Is it far?* (Uzak mı?) · *Thank you.* (Teşekkür ederim.)
> **Not:** Karar seçeneklerinin Türkçesi yalnızca editör içindir; uygulamada seçenekler çevrilmez (H-046 kararı).

---

## Soğuk açılış (~10 sn)

[GÖRSEL] Telsizin yeşil ışığı (B1).
**SES:** Benimle eski istasyonda buluş.

[GÖRSEL] Sabah. Yan kapıdaki dükkânın camında kitaplar ve çay fincanları.

## Sahne 1: Tide & Pages (~25 sn)

[GÖRSEL] Kapı zili. Kitaplar, çay kokusu. Tezgâhta Maya.

**MAYA:** Günaydın! Yardımcı olabilir miyim?

[KARAR K1 · bayrak `greet_tone`]
- ✓ "Nice to meet you. I'm Alex." (Tanıştığımıza memnun oldum. Ben Alex.) (resmî)
- ✓ "Hi! I'm Alex." (Selam! Ben Alex.) (samimi)

**MAYA:** Selam Alex! Ben Maya. Buralarda yeni misin?
**ALEX:** Evet. Yeni komşunum.
**MAYA:** Aa, hoş geldin! Nerelisin?
**ALEX:** Türkiye'denim. İzmir'den.
**MAYA:** İzmir mi? Deniz kenarında mı?
**ALEX:** Evet! Port Lumen gibi.

## Sahne 2: Aile (~20 sn)

[GÖRSEL] Maya'nın annesi gelir. Duvarda bir fotoğraf: Maya ve gözlüklü bir genç.

**MAYA:** Bu annem.
**MRS BROOKS:** Merhaba Alex. Tanıştığımıza memnun oldum.
**MAYA:** Bu da kuzenim Sam. Telsizlere bayılır!

[KARAR K2]
- ✓ "Excuse me, where is the old station?" (Pardon, eski istasyon nerede?)
- ✗ "Where station?" (İstasyon nerede? — fiil eksik)
  - [TEPKİ] **MAYA:** Efendim? Şey… istasyon mu? (gülümser, anlamaya çalışır)
  - **HI (TR):** Böyle de söyleyebilirsin: **"Excuse me, where is the old station?"** *Excuse me* kibar bir başlangıçtır.

**MAYA:** Eski istasyon mu? Limanın yakınında. Ama kapalı. Çok eski.
**ALEX:** Kapalı mı? Bir daha, lütfen.
**MAYA:** Kapalı. Kimse yok.

## Görev: 3 bilgi (dinleme ve okuma)

Maya'nın cümlelerinden doğru üçünü seç:
- ✓ "It's near the harbour." (Limanın yakınında.)
- ✓ "It's closed." (Kapalı.)
- ✓ "It's very old." (Çok eski.)
- ✗ "It's in İzmir." (İzmir'de.)
- ✗ "It's a big shop." (Büyük bir dükkân.)

## Sahne 3: Harita (~15 sn)

**ALEX:** Uzak mı?
**MAYA:** Hayır, değil. Bak, işte bir harita.

[GÖRSEL] Maya katlanmış bir haritayı açar ve limanı daire içine alır.

**MAYA:** Sana gösterebilirim. Yarın olur mu?
**ALEX:** Evet, lütfen! Teşekkür ederim.

[KANIT · boşluk doldurma, yeni bağlam: kafedeki bir müşteri]
[YAZI] "Hello! My name is ___. I'm from ___." (Merhaba! Benim adım ___. ___'denim.)

[GÖRSEL] Akşam. Alex odasında haritaya bakıyor.
**ALEX (TR):** Kapalıysa… neden orada buluşmak istiyor?

> **Açılan soru Q2:** "İstasyon kapalıysa, çağrı neden oraya çağırıyor?"
> **Q1 kısmen cevaplandı:** limanda.
> **Sonraki bölüm:** *Find the Station* (İstasyonu Bul)
