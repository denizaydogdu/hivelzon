# A1-004: *The Note* (Not) (S1 · B4) · Türkçe çeviri

> **Durum:** TASLAK (Claude, 2026-10-11) — kullanıcı onayı bekliyor (H-046)
> **Kaynak:** `story.en.md` (taslak 0.1). Satır satır veri: `ceviri.tr.json`.
> **Görev kartı:** Yarım notun parçalarından **tam notu** kur: gün, saat, yer.
> **Hedef ifadeler:** *What time is it?* (Saat kaç?) · *It's seven o'clock.* (Saat yedi.) · *on Friday* (cuma günü) · *at seven* (saat yedide) · *What day is it today?* (Bugün günlerden ne?)
> **Not:** Karar seçeneklerinin Türkçesi yalnızca editör içindir; uygulamada seçenekler çevrilmez (H-046 kararı).

---

## Soğuk açılış (~10 sn)

[GÖRSEL] Alex'in telefonunda kapıdaki yarım notun fotoğrafı.
[YAZI] "Fri…  …pm  Pier …  — E." (Cu…  …akşam  İskele …  — E.)

**HI (TR):** Bugün birlikte bakalım. Ama önce bir arkadaşa gösterebilirsin.

## Sahne 1: Tide & Pages (~20 sn)

[GÖRSEL] Pazartesi sabahı. Maya tezgâhta defterine bir şey yazıyor.

**MAYA:** Selam Alex! Bugün günlerden ne?
**ALEX:** Pazartesi.
**MAYA:** Pazartesi! Dokuzda tarih dersim var.
**ALEX:** Maya, bak. Bir not. Eski istasyondan.

[GÖRSEL] Yakın plan: silik harfler.

**MAYA:** Bazı harfler eksik. Hadi bakalım.

## Sahne 2: Gün ve saat (~25 sn)

[GÖRSEL] Yakın plan: "Fri…". Yanında üç kart: takvimde bir gün, kafeste bir kuş, kızarmış balık.

[KARAR K1 · telefon ekranı; görselle seç]
**MAYA:** "Fri…" Bu ne?
- ✓ "Friday." (Cuma.)
- ✗ "Free." (boş, serbest)
  - [TEPKİ] **MAYA:** Free mi? Hayır. Bak, bu bir gün adı. (takvimi gösterir)
  - **HI (TR):** Böyle de söyleyebilirsin: **"Friday."** Notta bir gün olmalı. Günler İngilizcede **büyük harfle** başlar: *Friday*.
- ✗ "Fried." (kızarmış)
  - [TEPKİ] **MAYA:** Kızarmış balık mı? (gülümser) Hayır, bu bir gün adı.
  - **HI (TR):** *Fri…* ile başlayan bir gün: **"Friday."** Günleri hatırla: *Monday, Tuesday… Friday.*

**ALEX:** Cuma! Dinle.

[GÖRSEL] Alex B1 kaydını açar.

**SES:** Cuma. Saat yedi.

[GÖRSEL] Yakın plan: "…pm". Notun köşesinde küçük bir saat çizimi: akrep 7'de, yelkovan 12'de.

[KARAR K2 · saat çizimi]
**MAYA:** Bak, bir saat. Saat kaç?
- ✓ "It's seven o'clock." (Saat yedi.)
- ✗ "It's in seven o'clock." (yanlış kalıp: "yedide" → *in* aktarımı)
  - [TEPKİ] **MAYA:** Yedi mi? Evet! (başını sallar, gülümser)
  - **HI (TR):** Böyle de söyleyebilirsin: **"It's seven o'clock."** Saatin önünde *in* olmaz. Cümlenin içinde **at** kullanılır: *at seven*.

**MAYA:** Saat yedi. Cuma günü saat yedide.

## Sahne 3: Yer (~15 sn)

[GÖRSEL] Yakın plan: "Pier …". Maya telefonu ışığa tutar; soluk bir "3" görünür.

**MAYA:** Bak! Küçük bir üç. 3 numaralı iskele!
**ALEX:** 3 numaralı iskele nerede?

[GÖRSEL] Maya haritasını açar (C3). Limanda numaralı iskeleler.

**MAYA:** Limanın yakınında. İşte burada.
**MAYA:** 2 ve 4 numaralı iskelelerin arasında.

## Görev: Tam notu kur (okuma)

Parçaları doğru yere sürükle:
[YAZI] "Fri…" → "Friday." (Cuma.)
[YAZI] "…pm" → "7 pm." (Akşam 7.)
[YAZI] "Pier …" → "Pier 3." (3 numaralı iskele.)

[YAZI] "Friday. 7 pm. Pier 3. — E." (Cuma. Akşam 7. 3 numaralı iskele. — E.)

## Sahne 4: İki not (~15 sn)

[GÖRSEL] Alex telsizi ve babaannesinin sararmış notunu çıkarır.

[YAZI-TR] "Cuma. Saat yedi. Yedinci kanal. Unutma. — N."

**ALEX (TR):** Cuma… saat yedi. Babaannemin notunda da aynı saat.

[GÖRSEL] Müzik bir an susar. İki not yan yana.

**MAYA:** Alex? İyi misin?
**ALEX:** Evet. İyiyim. Teşekkürler.

## Dil laboratuvarı

**HI (TR):** Saat için **at**, gün için **on**: *at seven*, *on Friday*. Türkçede "yedide" deriz; İngilizcede *in seven* değil, **at seven**.

[KANIT · yeni bağlam: Maya'nın ders programı]
[YAZI] "History: Monday, 9:00. Art: Friday, 2:00." (Tarih: Pazartesi, 9.00. Resim: Cuma, 14.00.)
**MAYA:** Cuma günü resim dersim var. Saat kaçta?
- ✓ "At two o'clock." (Saat ikide.)
- ✗ "In two o'clock." (yanlış kalıp)
  - [TEPKİ] **HI (TR):** Saatten önce **at**: *at two o'clock*.

## Son kare

[GÖRSEL] Akşam, Alex'in odası. İki not masada yan yana.
[YAZI] "Friday." (Cuma.)
[GÖRSEL] Alex telefonuna not yazar.
[YAZI] "Pier 3. Friday. 7." (3 numaralı iskele. Cuma. 7.)

> **Q3 kapandı:** Not çözüldü: "Friday. 7 pm. Pier 3. — E."
> **Açılan soru Q4:** "Cuma saat yedide Pier 3'te kim olacak?"
> **Sonraki bölüm:** *Too Late?* (Çok mu Geç?)
