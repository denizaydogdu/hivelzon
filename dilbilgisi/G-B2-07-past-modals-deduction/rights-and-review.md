# G-B2-07-past-modals-deduction: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi.
- Kanca ve "Hikâyede gör" cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A1-006 · "She was here." (kanca; köprü: bölümde düz geçmiş zaman var, çıkarım biçimi bizim cümlemiz)

## Tipik hata kaynağı
*She must forgot.* → *She must have forgotten.* · *He mustn't have seen me.* (çıkarım) → *He can't have seen me.* (müfredat, G-B2-07)

## Öğretmene notlar
- Kanca bir köprüdür: S1·B6'da Alex B5'teki notlarından "She was here." sonucunu çıkarır; *She must have been here.* bizim cümlemizdir. Bağ `story.en.md` satırına çözülüyor (lint uyarısı).
- Dikkat: A2-K03'teki *They must have a bath at six.* zorunluluktur (must + have + isim), çıkarım değildir. Bu yüzden bağ yapılmadı; öğretmen bunu "benzer görünen ama farklı" örneği olarak kullanmak isteyebilir.
- Olasılık kelimeleri (*might / may / could have*) tek grup olarak verildi; *couldn't have* (= *can't have*) anlatılmadı.
- *should have* "eleştiri ya da pişmanlık" olarak tek kartta verildi; *needn't have* C1-05'tedir.
- Türkçe karşılık "Burada olmuş olmalı." kancada biraz resmî kalabilir; "Buradaymış demek ki" de doğal bir karşılıktır.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h081b.json`): 6 parça, Duyu kalitesi hepsinde ok, en düşük skor 1.0 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
