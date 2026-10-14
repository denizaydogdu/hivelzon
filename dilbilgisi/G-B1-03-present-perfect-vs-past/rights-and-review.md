# G-B1-03-present-perfect-vs-past: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi (B1, %99.0).
- "Hikâyede gör" ve kanca cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A2-K05 p13 · "On Friday morning, the doctor took off the cast."

## Tipik hata kaynağı
*I have finished it yesterday.* · *When have you arrived?* (müfredat, G-B1-03)

## Öğretmene notlar
- Kanca A2-K05 p13'e bağlı (zamanı belli past simple: *On Friday morning…*); hedef cümle *The doctor has just taken off my cast!* aynı haberin o anda söylenişi, bizim cümlemiz.
- İngiliz kullanımı esas alındı (müfredat kararı): Amerikan İngilizcesinde *I already ate*, *Did you finish yet?*, *She just left* de kabul görür; derste belirtilmedi. Alıştırma 2'nin seçenekleri bu yüzden yalnız kelime sırasını sınar (*has just / just has*).
- *gone / been* farkı ve *still / ever since* anlatılmadı.
- *cast* (alçı) `glossary`'de (kapsama).
- Ses: c01'de Duyu "alçı"yı "6" (altı) duydu, "Mateo"yu "Mato"; kalite ok (skor 1.0), yayından önce dinlenmeli.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h081a.json`): 5 parça, Duyu kalitesi hepsinde ok, en düşük skor 1.0 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma, 385 karakter) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
