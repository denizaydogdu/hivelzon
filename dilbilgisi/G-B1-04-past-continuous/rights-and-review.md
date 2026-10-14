# G-B1-04-past-continuous: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi (B1, %100.0).
- "Hikâyede gör" ve kanca cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A2-K02 p06 · "\"I was taking photos,\" said Paloma."
  - A2-K02 p14 · "I was taking a photo of a butterfly.\""
  - A2-K02 p08 · "The shapes were coming towards them."
  - A2-K04 p09 · "It was getting easier."
  - A2-K01 p16 · "Aunt Füsun was laughing, so Elif laughed, too."

## Tipik hata kaynağı
*I was walk.* · *When I was arriving, he called.* (müfredat, G-B1-04)

## Öğretmene notlar
- *when* / *while* kuralı eğilim olarak sade anlatıldı (when kısa olayın, while süren eylemin önünde). *When I was walking home, …* gibi kullanımlar da doğrudur; anlatılmadı.
- Aynı anda süren iki eylem (*while I was cooking*) örnekte var, kural olarak anlatılmadı. Durum fiillerinin (*know, like*) bu yapıyla kullanılmaması anlatılmadı.
- *-ing* yazım kuralları (taking, sitting) G-A2-01'e bırakıldı.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h081a.json`): 6 parça, Duyu kalitesi hepsinde ok, en düşük skor 1.0 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma, 464 karakter) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
