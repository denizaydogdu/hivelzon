# A1-003: *Find the Station* (S1 · B3) · taslak 0.1

> **Durum:** DRAFT (H-030). İşaretler için bkz. `A1-000-arrival/story.en.md`.
> **Görev kartı:** Haritayı ve yol tarifini kullanarak Old Station'ı bul.
> **Hedef ifadeler:** *Go straight. · Turn left / right. · It's near… · It's between… · It's behind…*
> **Seviye üstü (sözlükte):** *next to* (A2)

---

## Soğuk açılış (~10 sn)

[GÖRSEL] Pazar sabahı. Alex'in telefonuna mesaj gelir.

**Bayrak `greet_tone` = friendly ise:**
[YAZI] "Sorry, Alex! I can't come today. Here is the map. Good luck!"

**Bayrak `greet_tone` = formal ise:**
[YAZI] "Hello Alex, I'm sorry. I can't come today. Here is the map."

**ALEX:** OK. The harbour.

## Sahne 1: Sokakta (~20 sn)

[GÖRSEL] Yokuşlu, renkli evler. Köpeğini gezdiren bir adam.

[KARAR K1 · POV]
- ✓ "Excuse me, where is the harbour?"
- ✗ "Harbour where?"
  - [TEPKİ] **MAN:** Sorry? (omuz silker)
  - **HI (TR):** Dün kullandığın kalıbı hatırla: **"Excuse me, where is…?"**

**MAN:** The harbour? Go straight. Then turn left.
**ALEX:** Again, please.
**MAN:** Go straight. Turn left. It's near.
**ALEX:** Thank you!

[KARAR K2 · POV: kavşak. Oklar seçilir; yazı yok.]
- ✓ düz → sol
- ✗ sağ
  - [TEPKİ] Bir çıkmaz sokak, bir kedi. **HI (TR):** *left* = sol, *right* = sağ. Tekrar dene!

## Sahne 2: Limanda (~20 sn)

[GÖRSEL] Liman: balıkçı dükkânı, otobüs durağı, küçük bir kafe. Alex Maya'nın haritasındaki notu okur.

[YAZI] "The station is near the fish shop. It's between the bus stop and the café."

[KARAR K3: resimde doğru binaya dokun]
- ✓ Otobüs durağı ile kafenin arasındaki eski bina
- ✗ Balıkçı dükkânının arkasındaki bina
  - [TEPKİ] **HI (TR):** *between* = ikisinin arasında. Otobüs durağına ve kafeye bak.

## Sahne 3: Old Station (~20 sn)

[GÖRSEL] Eski, gri bir bina; paslı bir anten; kilitli kapı.

**ALEX:** This is the old station! Hello? Is anybody here?

[GÖRSEL] Sessizlik. Martılar. Kapıda yağmurdan yarısı silinmiş bir kâğıt.

[YAZI] "Fri…  …pm  Pier …  — E."

**ALEX:** E! The message on the radio!

[GÖRSEL] Alex notu telefonuyla fotoğraflar.

## Görev: Rotayı seç (okuma)

Üç tarif cümlesine göre haritada doğru yolu çiz:
[YAZI] "Go straight. Turn left. It's near the fish shop."

[KANIT · yeni harita, yeni yer]
[YAZI] "The café is near the park. It's behind the school."
→ resimde doğru kafeyi seç.

**HI (TR):** Bazı harfler silinmiş. Yarın birlikte bakalım mı?

> **Q1 kapandı:** İstasyon bulundu.
> **Açılan soru Q3:** "Kapıdaki yarım notta ne yazıyor?"
> **İpucu panosu:** C4 yarım not (fotoğraf)
