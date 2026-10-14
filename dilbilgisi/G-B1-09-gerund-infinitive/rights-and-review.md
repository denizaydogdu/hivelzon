# G-B1-09-gerund-infinitive: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi (B1, %100.0).
- "Hikâyede gör" ve kanca cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A2-K02 p08 · "Paloma tried to remember Mrs Berg's rules."
  - A2-K02 p09 · "Paloma started to laugh."
  - A2-K04 p01 · "Nia wanted to know for herself."
  - A2-K04 p03 · "Some days she wanted to stop."
  - A2-K03 p13 · "Then Captain began to sing."

## Tipik hata kaynağı
*I want that you help me.* · *I'm looking forward to see you.* · *I enjoy to swim.* (müfredat, G-B1-09)

## Öğretmene notlar
- Yalnız sık fiiller verildi. *like / love / hate* (iki kalıp), *try + -ing* (deneme anlamı) ve *forget* anlatılmadı; kancadaki *tried to remember* "çabalamak" anlamındadır.
- *start / begin* iki kalıbı da alır; "Hikâyede gör"deki *started to laugh*, *began to sing* yalnız mastar örneğidir ("Kitaplarda bu fiillerden sonra hep mastar geliyor" cümlesi kitaplar için doğru, kural için değil).
- *to + fiil* Türkçe anlatımda "mastar" diye anıldı. *look forward to*'daki *to*'nun edat olduğu yalnız hata notunda.
- Ses: Duyu "mastar"ı "master" duydu (6 parça); kalite ok, Alania okuyuşu dinlenmeli.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h081a.json`): 7 parça, Duyu kalitesi hepsinde ok, en düşük skor 1.0 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma, 498 karakter) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
