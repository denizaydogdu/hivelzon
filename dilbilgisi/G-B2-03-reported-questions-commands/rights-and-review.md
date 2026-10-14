# G-B2-03-reported-questions-commands: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi.
- Kanca ve "Hikâyede gör" cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A2-K04 p01 · "\"What is rain really like?\" she often asked." (kanca; köprü: kitapta soru tırnak içinde, aktarılmış biçim bizim cümlemiz)

## Tipik hata kaynağı
*She asked me where was I going.* → *…where I was going.* · *He said me to wait.* → *He told me to wait.* (müfredat, G-B2-03)

## Öğretmene notlar
- Ses: c02 ilk üretimde Alania ikinci cümleyi bozdu (Duyu eşleşmesi %43); cümle "Olmak fiili kişiden sonra gelir, sorudaki yardımcı fiil ise düşer." diye yeniden yazılıp üretildi (skor 1.0). Yayından önce dinlenmeli.
- Kanca bir köprüdür: kitapta yapı yok, aktarılacak soru var. "Hikâyede gör" kartı bu yüzden yok; S1 ve A1–A2 kitaplarında aktarılmış soru ya da rica bulunmadı.
- Evet-hayır sorularında yalnız *if* öğretildi; *whether* anlatılmadı.
- Rica için *asked*, emir için *told* diye sade bir ayrım yapıldı; *ordered, advised, warned, reminded* gibi fiiller anlatılmadı.
- Kancadaki *She often asked what rain was really like* cümlesinde *often* ile alışkanlık anlamı var; zaman kaydırmasının örneği olarak sade tutuldu.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h081b.json`): 6 parça, Duyu kalitesi hepsinde ok, en düşük skor 0.962 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
