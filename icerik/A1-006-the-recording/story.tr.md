# A1-006: *The Recording* (Kayıt) (S1 · B6) · Türkçe çeviri

> **Durum:** TASLAK (Claude, 2026-10-14; H-085). Editör onayı bekliyor (H-028).
> **Kaynak:** `story.en.md` (taslak 0.1, H-032 onaylı). Satır satır veri: `ceviri.tr.json`.
> **Görev kartı:** Kayıttaki **üç ipucunu** bul: yer, gün, "the light".
> **Hedef ifadeler:** *There is a…* (Bir … var.) · *There are…* (… var; çoğul) · *on the desk* (masanın üstünde) · *under the bed* (yatağın altında) · *Can you play it?* (Onu çalabilir misin?)
> **Not:** Karar ve görev seçeneklerinin Türkçesi yalnızca editör içindir; uygulamada çevrilmez (H-046 kararı).

---

## Soğuk açılış (~10 sn)

[GÖRSEL] B5'in son karesi: Alex'in elinde ışığı yanmayan kaydedici.
[YAZI] "Maya's cousin Sam! He can fix it!" (Maya'nın kuzeni Sam! O tamir edebilir!)
[GÖRSEL] Cumartesi sabahı. Tide & Pages'in kapısı. Maya el sallar.

## Sahne 1: Sam'in odası (~25 sn)

**MAYA:** Alex, bu benim kuzenim Sam.
**ALEX:** Merhaba Sam. Tanıştığımıza memnun oldum.

[GÖRSEL] Sam cevap vermez; kulaklıklar kulağında.

**ALEX:** Sam? Beni duyabiliyor musun?
**SAM:** Ah! Pardon! Evet, duyabiliyorum. Merhaba!

**MAYA:** Şu odaya bak, Alex!
**MAYA:** Masanın üstünde bir radyo var.
**MAYA:** Her yerde kablo var!
**SAM:** Bir de yatağın altında bir kutu var.

## Sahne 2: Sam hızlı konuşur (~20 sn)

**SAM:** Oo, harika! Eski. Açabilirim. Kolay!
**MAYA:** Sam! Yavaşla!

[KARAR K1 · iki seçenek de doğru · bayrak `ask_style`]
- ✓ "Slowly, please." (Yavaş lütfen.)
- ✓ "Again, please." (Tekrar lütfen.)

**SAM:** Pardon! Eski. Onu açabilirim.
**SAM:** Kolay.

**HI (TR):** İki cevap da doğru! *Slowly, please* hızı, *Again, please* tekrarı ister.

## Sahne 3: Kayıt (~25 sn)

[GÖRSEL] Sam kaydediciye yeni pil takar.

**ALEX:** Onu çalabilir misin?
**SAM:** Sen çalabilirsin. Aç onu.

[KARAR K2 · kaydedicide düğme seç; yazı yok]
- ✓ Kenardaki küçük düğme
- ✗ Pil kapağı
  - [TEPKİ] **SAM:** Yok, yok. O değil.
  - **HI (TR):** *Turn it on* = aç, çalıştır. Kenardaki küçük düğmeye bak.

[GÖRSEL] Küçük kırmızı ışık yanar. Cızırtı.

**SES (KAYIT):** Telsiz sendeyse, sen bir dostsun.
**SES (KAYIT):** Cumartesileri Lumen Point'teyim.
**SES (KAYIT):** Işık. — E.

**SAM:** Bir daha çal.

**SES (KAYIT):** Cumartesileri Lumen Point'teyim.
**SES (KAYIT):** Işık. — E.

## Görev: Üç ipucunu bul (dinleme)

- *I'm at ___ on Saturdays.* (Cumartesileri ___'deyim.) → Lumen Point
- *I'm at Lumen Point on ___.* (___ Lumen Point'teyim.) → Saturdays (cumartesileri)
- *The ___.* → light (ışık)

## Sahne 4: Hangisi doğru? (~20 sn)

[YAZI] Defter: "red coat" (kırmızı palto), "Helen?", "the hill café?" (tepedeki kafe?)

**ALEX:** Buradaydı. 3 numaralı iskelede. Cuma günü.
**ALEX:** Jordan "Helen" diyor. Bir de "tepedeki kafe".
**MAYA:** Ama kadın "E." diyor. Bir de Lumen Point.
**SAM:** Peki kim haklı?

[YAZI] Telsizin etiketi: "PLRC 1979"

**SAM:** PLRC… Radyo Kulübü mü? Eski bir kulüp mü?

[YAZI] Sam'in notu: "old club radio?" (eski kulüp telsizi?)

## Dil laboratuvarı

**HI (TR):** Türkçede tek kelime var: "var". İngilizcede tekil için **There is**, çoğul için **There are**. *There is two radios* değil, **There are two radios.**

[KANIT · Sam'in odasının resmi, eşleştir] *There is a radio on the desk.* (Masanın üstünde bir radyo var.) · *There are two chairs.* (İki sandalye var.) · *There is a box under the bed.* (Yatağın altında bir kutu var.)

## Son kare

[GÖRSEL] Maya haritayı açar; parmağı kıyıdaki burnu, feneri gösterir.

**MAYA:** Lumen Point deniz feneri. Tepe değil.

> **Q5 kapandı:** Kayıt dinlendi: Lumen Point, cumartesileri, ışık, E.
> **Açılan soru Q6:** Kayıt mı doğru, Jordan mı? (Kayıt "Lumen Point" ve "E." diyor; Jordan "Helen, tepedeki kafe" demişti.)
> **İpucu panosu:** C9 kayıt · C10 Sam'in notu: "old club radio?"
