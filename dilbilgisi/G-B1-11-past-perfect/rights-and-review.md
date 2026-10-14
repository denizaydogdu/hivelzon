# G-B1-11-past-perfect: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi (B1, %100.0).
- "Hikâyede gör" ve kanca cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A2-K04 p05 · "Then the door opened, and she saw the sky."

## Tipik hata kaynağı
*When I arrived, the train left.* (anlam farkı) · *I had went.* (müfredat, G-B1-11)

## Öğretmene notlar
- Past perfect bölüm ve kitaplarda yok. Kanca A2-K04 p05'e bağlı (*Then the door opened, and she saw the sky.*); hedef *She had never seen a blue sky before.* bizim (Ay'da gökyüzü hep siyah, A2-K04 p01). Kitabın sürprizi (p16: ilk yağmur Leo'nun hortumları) bilerek kullanılmadı.
- Past perfect continuous anlatılmadı.
- *after / before* ile past perfect isteğe bağlıdır (*After I had finished…* da doğru); anlatımda "sıra belliyse geçmiş zaman kullanılır" diye sadeleştirildi.
- *When I arrived, the train left.* dilbilgisi olarak yanlış değil; anlam farkı olarak sunuldu (not: "Anlam değişir").

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h081a.json`): 5 parça, Duyu kalitesi hepsinde ok, en düşük skor 1.0 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma, 503 karakter) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
