# G-A2-14-have-to-must-should: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi.
- "Hikâyede gör" ve kanca cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A2-K02 p03 · "\"We have to stay on the path,\" said Jonas." (kanca) · "\"We should go back now,\" she said."
  - A2-K03 p03 · "They mustn't eat sweets before lunch." · p12 · "\"You don't have to pay me,\" said Max quietly."
  - A2-K05 p03 · "\"Should I answer?\" asked Mateo."

## Tipik hata kaynağı
*You must to go.*, "gelmek zorunda değilsin" için *You mustn't come.*, *She have to…* (müfredat, G-A2-14)

## Öğretmene notlar
- *have to / must* farkı sade anlatıldı: "anlamları çok yakın; biri günlük konuşmada, öbürü yazılı kurallarda ve güçlü uyarılarda". Konuşanın kendi otoritesi (must) / dış zorunluluk (have to) ayrımı B1'e bırakıldı.
- *had to* (geçmiş) ve *Do I have to…?* (soru) anlatılmadı.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan", "zamanla oturur" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h080b.json`): 7 parça, Duyu kalitesi hepsinde ok, en düşük skor 1.0 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
