# A1-003: *Find the Station* (İstasyonu Bul) (S1 · B3) · Türkçe çeviri

> **Durum:** TASLAK (Claude, 2026-10-11) — kullanıcı onayı bekliyor (H-046)
> **Kaynak:** `story.en.md` (taslak 0.1). Satır satır veri: `ceviri.tr.json`.
> **Görev kartı:** Haritayı ve yol tarifini kullanarak Old Station'ı bul.
> **Hedef ifadeler:** *Go straight.* (Düz git.) · *Turn left / right.* (Sola / sağa dön.) · *It's near…* (…-in yakınında.) · *It's between…* (…-in arasında.) · *It's behind…* (…-in arkasında.)
> **Not:** Karar seçeneklerinin Türkçesi yalnızca editör içindir; uygulamada seçenekler çevrilmez (H-046 kararı).

---

## Soğuk açılış (~10 sn)

[GÖRSEL] Pazar sabahı. Alex'in telefonuna Maya'dan mesaj gelir.

**Bayrak `greet_tone` = friendly ise:**
[YAZI] "Sorry, Alex! I can't come today. Here is the map. Good luck!"
(Kusura bakma Alex! Bugün gelemiyorum. Harita burada. Bol şans!)

**Bayrak `greet_tone` = formal ise:**
[YAZI] "Hello Alex, I'm sorry. I can't come today. Here is the map."
(Merhaba Alex, üzgünüm. Bugün gelemiyorum. İşte harita.)

**ALEX:** Tamam. Liman.

## Sahne 1: Sokakta (~20 sn)

[GÖRSEL] Yokuşlu, renkli evler. Köpeğini gezdiren bir adam.

[KARAR K1]
- ✓ "Excuse me, where is the harbour?" (Affedersiniz, liman nerede?)
- ✗ "Harbour where?" (Liman nerede? — Türkçe söz dizimi)
  - [TEPKİ] **ADAM:** Efendim? (omuz silker)
  - **HI (TR):** Dün kullandığın kalıbı hatırla: **"Excuse me, where is…?"**

**ADAM:** Liman mı? Düz git. Sonra sola dön.
**ALEX:** Bir daha, lütfen.
**ADAM:** Düz git. Sola dön. Yakında.
**ALEX:** Teşekkürler!

[KARAR K2 · kavşak; oklar seçilir, yazı yok]
- ✓ düz → sol
- ✗ sağ
  - [TEPKİ] Çıkmaz sokak, bir kedi. **HI (TR):** *left* = sol, *right* = sağ. Tekrar dene!

## Sahne 2: Limanda (~20 sn)

[GÖRSEL] Liman: balıkçı dükkânı, otobüs durağı, küçük bir kafe. Alex Maya'nın haritasındaki notu okur.

[YAZI] "The station is near the fish shop. It's between the bus stop and the café."
(İstasyon balıkçı dükkânının yakınında. Otobüs durağıyla kafenin arasında.)

[KARAR K3: resimde doğru binaya dokun]
- ✓ Otobüs durağı ile kafenin arasındaki eski bina
- ✗ Balıkçı dükkânının arkasındaki bina
  - [TEPKİ] **HI (TR):** *between* = ikisinin arasında. Otobüs durağına ve kafeye bak.

## Sahne 3: Old Station (~20 sn)

[GÖRSEL] Eski, gri bir bina; paslı bir anten; kilitli kapı.

**ALEX:** Burası eski istasyon! Merhaba? Kimse var mı?

[GÖRSEL] Sessizlik. Martılar. Kapıda yağmurdan yarısı silinmiş bir kâğıt.

[YAZI] "Fri…  …pm  Pier …  — E." (Cu…  …akşam  İskele …  — E.)

**ALEX:** E! Telsizdeki mesaj!

[GÖRSEL] Alex notu telefonuyla fotoğraflar.

## Görev: Rotayı seç (okuma)

[YAZI] "Go straight. Turn left. It's near the fish shop."
(Düz git. Sola dön. Balıkçı dükkânının yakınında.)

[KANIT · yeni harita, yeni yer]
[YAZI] "The café is near the park. It's behind the school."
(Kafe parkın yakınında. Okulun arkasında.)
→ resimde doğru kafeyi seç.

**HI (TR):** Bazı harfler silinmiş. Yarın birlikte bakalım mı?

> **Q1 kapandı:** İstasyon bulundu.
> **Açılan soru Q3:** "Kapıdaki yarım notta ne yazıyor?"
> **Sonraki bölüm:** *The Note* (Not)
