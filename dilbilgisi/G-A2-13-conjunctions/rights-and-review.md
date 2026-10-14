# G-A2-13-conjunctions: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi.
- "Hikâyede gör" ve kanca cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A2-K02 p01 · "When the fog came down, the path disappeared." (kanca)
  - A2-K02 p02 · "\"Listen carefully, because there are four rules.\""
  - A2-K03 p01 · "So when Mrs Bell from next door called him, he listened carefully."
  - A2-K04 p01 · "Nia was born on the Moon, and she wanted to see rain." · A1-K05 p01 · "But every morning at seven, someone waves."

## Tipik hata kaynağı
Yazıda tek başına *Because I was tired.* ve *When I will arrive, I'll call you.* (müfredat, G-A2-13)

## Öğretmene notlar
- "Bu kelimeler ikinci cümlenin başına gelir" kuralı *and / but / so* için anlatıldı; *because* cümle başına da gelebilir (Because it was cold, we…). Kitap cümlelerinde *But* ve *So* cümle başında duruyor (anlatım dilinde olağan).
- Konuşmada tek başına *Because…* cevabı (Why? – Because I was tired.) doğaldır; hata yalnız yazı için söylendi.
- *after / before* yan cümlesi örnekte geçmiş zamanla verildi (after we had dinner).

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
