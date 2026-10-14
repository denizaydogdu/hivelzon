# G-B2-09-non-defining-relatives: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi.
- Kanca ve "Hikâyede gör" cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A2-K04 p01 · "She lived in Lunaria, a small town under a glass roof." (kanca; müfredatın önerdiği aday: virgüllü açıklama öbeği, cümlecikli biçim bizim cümlemiz)

## Tipik hata kaynağı
*My brother, that lives in İzmir, …* → *My brother, who lives in İzmir, …* · virgülsüz *He didn't call which was strange.* (müfredat, G-B2-09)

## Öğretmene notlar
- Kanca bir köprüdür: kitaptaki cümlede açıklama öbeği (apozisyon) var, sıfat cümleciği yok. "Hikâyede gör" kartı yok.
- Dikkat: A1-K01'deki *"Mrs Ada, who lives behind the blue door?" asks Lina.* bir hitap ve sorudur, sıfat cümleciği değildir; bağ olarak kullanılmadı.
- Edat + *which/whom* (*the city in which…*, *to whom*), *whom* ve nicelik ifadeleri (*some of whom*) anlatılmadı.
- Virgülsüz/virgüllü karşılaştırmasında *brother* için Türkçe "ağabey" seçildi; Türkçe karşılıklar aynı kaldığı için anlam farkı parantez notuyla verildi.

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
