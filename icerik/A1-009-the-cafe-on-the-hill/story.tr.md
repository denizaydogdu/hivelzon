# A1-009: *The Café on the Hill* (Tepedeki Kafe) (S1 · B9) · Türkçe çeviri

> **Durum:** TASLAK (Claude, 2026-10-14; H-085). Editör onayı bekliyor (H-028).
> **Kaynak:** `story.en.md` (taslak 0.1, H-032 onaylı). Satır satır veri: `ceviri.tr.json`.
> **Not:** Karar ve görev seçeneklerinin Türkçesi yalnızca editör içindir; uygulamada çevrilmez (H-046 kararı).
> **Görev kartı:** Kafede kibarca sipariş ver ve kayıt hakkında **2 bilgi** topla.
> **Hedef ifadeler:** *Can I have a tea, please? · a / an · some · How much is it? · Here you are.*
> **Fiyatlar:** birimsiz söylenir ("It's twelve."); etiketlerde yalnızca sayı.
> **Seviye üstü (sözlükte):** *voice*, *member*, *lighthouse*, *signal*, *weak*, *antenna*, *battery*, *cable*, *next to*

---

## Soğuk açılış (~10 sn)

[GÖRSEL] B8'in son karesi: tepede ışığı yanan pencere.
[YAZI] "Hilltop Café" (Tepe Kafesi (Hilltop Café))

[GÖRSEL] Cumartesi öğleden sonra. Alex, Maya ve Sam kafenin kapısını açar. İçerisi sıcak; duvarlarda eski fotoğraflar.

## Sahne 1: Sipariş (~25 sn)

[GÖRSEL] Tezgâhta Rosa: önlük, okuma gözlüğü saçının üstünde. Arkada tahtada menü (kurguda eklenir).

[YAZI] "tea · hot chocolate · orange juice · cake" (çay · sıcak çikolata · portakal suyu · pasta)

**ROSA:** Merhaba! Burada yeni misin?
**ALEX:** Evet. Ben Alex. Tanıştığımıza memnun oldum.
**ROSA:** Memnun oldum, Alex. Ben Rosa.
**ROSA:** Nerelisin?
**ALEX:** Türkiye'denim. İzmir'den.
**ROSA:** İzmir! Büyük bir şehir mi?
**ALEX:** Evet, öyle. Deniz kenarında.

[KARAR K1 · POV: tezgâh · bayrak `drink_choice`]
- ✓ "Can I have a tea, please?" (Bir çay alabilir miyim, lütfen?) (`drink_choice` = tea)
- ✓ "Can I have a hot chocolate, please?" (Bir sıcak çikolata alabilir miyim, lütfen?) (`drink_choice` = hot_chocolate)
- ✗ "I want tea." (Çay istiyorum.)
  - [TEPKİ] **ROSA:** Lütfen? (nazikçe gülümser, bekler)
  - **HI (TR):** *I want…* yanlış değil, ama kafede çok doğrudan duyulur. Böyle de söyleyebilirsin: **"Can I have a tea, please?"**

**MAYA:** Bir portakal suyu alabilir miyim, lütfen?
**SAM:** Bir de pasta, lütfen. Büyük bir pasta!
**ROSA:** Tamam. Sana biraz pasta!
**SAM:** Bir de biraz süt, lütfen?
**ROSA:** Tamam, tamam. Bir dakika.

[GÖRSEL] Rosa tepsiyi uzatır.
**ROSA:** Buyurun.
**ALEX:** Teşekkür ederim. Ne kadar?
**ROSA:** On iki, lütfen.
**ALEX:** Buyurun.

## Sahne 2: Kayıt (~25 sn)

[GÖRSEL] Pencere kenarındaki masa. Aşağıda liman ve uzakta Lumen Point.

**ALEX:** Sam, çalabilir misin?
**SAM:** Evet. Dinle.

**VOICE:** Alo? Alo? Beni duyabiliyor musun? Ben E.

[GÖRSEL] Rosa masaların arasında durur, dinler.

[KARAR K2 · POV: Rosa'ya dönme]
- ✓ "Do you know this voice?" (Bu sesi tanıyor musunuz?)
- ✗ "You know it?" (Hatalı: Biliyorsun onu?)
  - [TEPKİ] **ROSA:** Efendim? (eğilir, anlamaya çalışır)
  - **HI (TR):** Soru için başa **Do** gelir: **"Do you know this voice?"**

**ROSA:** Aa! Bu eski kulüp çağrısı!
**ROSA:** Telsiz kulübü buradaydı.
**ROSA:** Uzun zaman önce. Her cuma.
**MAYA:** Burada mı? Bu kafede mi?
**ROSA:** Evet. Duvara bakın.
**MAYA:** Kulüp şimdi burada mı?
**ROSA:** Hayır. Yalnızca eski fotoğraflar.

[GÖRSEL] Duvarda soluk bir fotoğraf: tepede bir anten, altında el yazısı (kurguda eklenir).
[YAZI] "PLRC" (PLRC (Port Lumen Telsiz Kulübü))

**SAM:** Bak! Eski bir fotoğraf.
**ALEX:** E. kim?
**ROSA:** Bir üye fenere gidiyor.
**ROSA:** Cumartesileri.
**ALEX:** Adı ne?
**ROSA:** Kusura bakma. Bu onun hikâyesi, benim değil.
**ALEX:** Tamam. Teşekkürler, Rosa.
**ALEX:** Bugün cumartesi! Hadi gidelim!
**MAYA:** Lumen Point uzak. Şimdi otobüs yok.
**SAM:** Bir de telsiz zayıf. Bak.

## Görev: Sipariş ver, bilgi al (dinleme + konuşma)

Menüden seç ve Rosa'nın sözlerinden doğru iki bilgiyi işaretle:
- ✓ "Long ago, the club was here." (Uzun zaman önce kulüp buradaydı.)
- ✓ "One person goes there on Saturdays." (Bir kişi cumartesileri oraya gidiyor.)
- ✗ "E. works in the café." (E. kafede çalışıyor.)
- ✗ "The club meets at the old station." (Kulüp eski istasyonda toplanıyor.)

**HI (TR):** *a* sessiz harften önce, *an* sesli harften önce: *a tea*, *a cake*, ama ***an** orange juice*.

[KANIT · yeni kafe, yeni sipariş: rol kartı]
- [YAZI] "Can I have an apple, please?" (Bir elma alabilir miyim, lütfen?)
- [YAZI] "Can I have a coffee, please?" (Bir kahve alabilir miyim, lütfen?)
- [YAZI] "How much is it? It's nine." (Ne kadar? Dokuz.)

## Sahne 3: Liste (~15 sn)

[GÖRSEL] Sam telsizi pencereye tutar. Cızırtı.

**SAM:** Sinyal zayıf.
**SAM:** Daha iyi bir antene ihtiyacımız var.

[GÖRSEL] Sam bir peçeteye çizer. Kelimeler kurguda eklenir.
[YAZI] "Antenna. Battery. Cable." (Anten. Pil. Kablo.)

**ALEX:** Onları nereden alabilirim?
**ROSA:** Bay Grant'in dükkânı. Otobüs durağının yakınında.

> **Q8 kapandı:** Hilltop Café eski radyo kulübünün buluşma yeri; bir üye cumartesileri fenere gidiyor.
> **Açılan soru Q9:** "Çağrıyı daha net duymak (ve cevap verebilmek) için ne lazım?"
> **İpucu panosu:** C14 kafedeki anten fotoğrafı (PLRC) · C15 Rosa'nın sözü: "lighthouse on Saturdays"
