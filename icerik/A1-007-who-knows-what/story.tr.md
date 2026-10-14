# A1-007: *Who Knows What?* (Kim ne biliyor?) (S1 · B7) · Türkçe çeviri

> **Durum:** TASLAK (Claude, 2026-10-14; H-085). Editör onayı bekliyor (H-028).
> **Kaynak:** `story.en.md` (taslak 0.1, H-032 onaylı). Satır satır veri: `ceviri.tr.json`.
> **Görev kartı:** Üç tanığın cümlelerini karşılaştır ve kadının **doğru tarifini** kur.
> **Hedef ifadeler:** *She has white hair.* (Saçları beyaz.) · *He is tall.* (O [erkek] uzun boylu.) · *She can't walk fast.* (Hızlı yürüyemiyor.) · *a red coat* (kırmızı bir palto) · *I don't know.* (Bilmiyorum.) · kalıp: *What does she look like?* (Nasıl biri? / Görünüşü nasıl?)
> **Not:** Karar ve görev seçeneklerinin Türkçesi yalnızca editör içindir; uygulamada çevrilmez (H-046 kararı).

---

## Soğuk açılış (~10 sn)

[GÖRSEL] B6'nın son karesi: masada harita.
[YAZI] "Lumen Point is the lighthouse. Not the hill." (Lumen Point deniz feneri. Tepe değil.)
[GÖRSEL] Pazar sabahı. Alex, Maya ve Sam limana yürür. Sam yine hızlı konuşur, sonra durur.

**Bayrak `ask_style` = slowly ise:** **SAM:** "Yavaş lütfen." Evet, evet. Biliyorum! (Alex'e göz kırpar)
**Bayrak `ask_style` = again ise:** **SAM:** "Tekrar lütfen." Tamam, tamam. Biliyorum! (Alex'e göz kırpar)

## Sahne 1: Limanda Jordan (~25 sn)

**JORDAN:** Selam Alex! Maya da! Bu kim?
**MAYA:** Bu benim kuzenim Sam.
**SAM:** Selam! Jordan, cumadaki kadın. O kim?
**JORDAN:** Adını bilmiyorum. Helen sanırım.

[KARAR K1]
- ✓ "What does she look like?" (Nasıl biri?)
- ✗ "How is she?" (O nasıl, iyi mi?)
  - [TEPKİ] **JORDAN:** İyidir sanırım! (güler, omuz silker)
  - **HI (TR):** *How is she?* "O nasıl, iyi mi?" demek. Görünüşü sormak için böyle de söyleyebilirsin: **"What does she look like?"**

**JORDAN:** Uzun boylu. Saçları kısa.
**JORDAN:** Mavi bir paltosu var.
**MAYA:** Mavi mi? Cuma günü kırmızı diyorsun!
**JORDAN:** Kırmızı mı? Evet, evet. Kırmızı. Belki.
**ALEX:** Yavaş lütfen. Yaşlı mı?
**JORDAN:** Yaşlı mı? Hayır… evet? Bilmiyorum!

## Sahne 2: Tide & Pages (~25 sn)

**MRS BROOKS:** Kırmızı paltolu bir kadın mı?
**MRS BROOKS:** Evet! Onu hatırlıyorum.
**MRS BROOKS:** Kırmızı paltolu yaşlı bir hanım.
**MRS BROOKS:** Saçları beyaz.
**MRS BROOKS:** Hızlı yürüyemiyor.

[GÖRSEL] Mrs Brooks'un anısı: kırmızı paltolu, beyaz saçlı yaşlı bir kadın, arkadan; yüzü görünmez.

**ALEX:** O kim?
**MRS BROOKS:** Adı mı? Kusura bakma, bilmiyorum.

[KARAR K2 · Alex, Mrs Brooks'un söylediğini Sam'e aktarır]
- ✓ "She has white hair." (Saçları beyaz.)
- ✗ "He has white hair." (Hatalı: "O [erkek] beyaz saçlı.")
  - [TEPKİ] **SAM:** He mi? Bir erkek mi?
  - **HI (TR):** Türkçede "o" hem kadın hem erkek için. İngilizcede kadın için **she**, erkek için **he**. Böyle de söyleyebilirsin: **"She has white hair."**

**SAM:** Beyaz saç mı? Jordan kısa saç diyor.

## Sahne 3: Kayıt ve itiraf (~20 sn)

[GÖRSEL] Jordan bisikletiyle dükkânın önünde durur. Alex telefonunda kaydı (C9) açar.

**SES (KAYIT):** Cumartesileri Lumen Point'teyim… Işık… E.

[KARAR K3 · kayıtla uyumlu olanı seç]
- ✓ "E. Lumen Point. Saturdays."
- ✗ "Helen. The hill café."
  - **HI (TR):** Kaydı bir kez daha dinle. Hangi harfi ve hangi yeri duyuyorsun?

**ALEX:** Jordan, kadın "E." diyor. Helen değil.
**JORDAN:** Tamam, tamam… karanlıktı.
**JORDAN:** Geceleri iyi göremiyorum!
**MAYA:** Bir de iskele gece çok karanlık.
**JORDAN:** Evet. Kusura bakmayın, arkadaşlar!

## Görev: Çelişkileri ayır (okuma)

- **JORDAN:** Uzun boylu. Saçları kısa. Mavi bir paltosu var.
- **MRS BROOKS:** Saçları beyaz. Hızlı yürüyemiyor.
- **SAM:** Dinle. Sesi yaşlı.

*She is ___. She has ___ hair. She has a ___ coat.* → old / white / red (yaşlı / beyaz / kırmızı)

## Dil laboratuvarı (Claude taslağı; editör onayı bekler)

**HI (TR):** Kadın için *she*, erkek için *he*. Bir de *have*: *I have, you have*, ama *he has, she has*. *She has white hair.*

[KANIT · Hi'nin gösterdiği resim: uzun boylu, kısa siyah saçlı bir adam]
- ✓ *He is tall. He has short black hair.* (Uzun boylu. Kısa siyah saçları var.)
- ✗ *She is tall. She has long hair.*

## Sahne 4: Yeni soru (~15 sn)

[GÖRSEL] Akşam. Maya'nın masası: tarif kartı, harita, telsiz.

**ALEX:** Telsizdeki çağrı… nereden geliyor?
**MAYA:** İskeleden mi? Tepeden mi? Bilmiyorum.
**SAM:** Onu bulabiliriz. Cuma. Bir antenle.
**SAM:** Cuma. Saat yedi. Onu buluruz.

> **Q6 kapandı:** Kayıt doğru (Lumen Point, E.). Jordan karanlıkta yanlış görmüş ve duymuş.
> **Açılan soru Q7:** Sinyal gerçekten nereden geliyor?
> **İpucu panosu:** C11 tarif kartı (E.: white hair, red coat)
