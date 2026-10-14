# G-B2-12-contrast-linkers: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi.
- Kanca ve "Hikâyede gör" cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A2-K03 p14 · "He played badly, but he played for hours." (kanca; köprü: kitapta zıtlık A2 bağlacıyla, *although*'lı biçim bizim cümlemiz)

## Tipik hata kaynağı
*Although it was raining, but we went out.* · *Despite it was cold…* → *Despite the cold…* · *despite of* → *despite* (müfredat, G-B2-12)

## Öğretmene notlar
- Kanca bir köprüdür: kitapta *but* var, B2 bağlaçları yok. "Hikâyede gör" kartı yok.
- *despite the fact that* + cümle, *though* (cümle sonunda), *nevertheless*, *on the other hand*, *while* (zıtlık anlamında) anlatılmadı.
- *however*'ın cümle ortasında kullanımı (*The food, however, was great.*) anlatılmadı; yalnız ikinci cümlenin başında verildi.
- *whereas* "oysa" ile karşılandı; *while* ile eş anlamlılığı söylenmedi.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h081b.json`): 6 parça, Duyu kalitesi hepsinde ok, en düşük skor 0.97 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
