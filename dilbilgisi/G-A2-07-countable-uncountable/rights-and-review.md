# G-A2-07-countable-uncountable: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi.
- "Hikâyede gör" ve kanca cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A1-009 · "And some milk, please?" (kanca; kurgu yok, story.en.md satırı)
  - A1-000 · "I have some questions." (kurgu yok; story.en.md satırı "I have some questions. Is that OK?")
  - A1-009 · "Some cake for you!" (kurgu yok; story.en.md satırı "OK. Some cake for you!")
  - A1-K01 p02 · "There is not much sun here." · A2-K05 p10 · "\"There aren't any trees on the beach.\""

## Tipik hata kaynağı
*informations* ve *I don't have some money.* (müfredat, G-A2-07)

## Öğretmene notlar
- "Soru ve olumsuzda çoğu zaman *any*" dendi; rica ve tekliflerde *some* (Can I have some water?) yalnız örnekle gösterildi, kural olarak anlatılmadı.
- *much / many* için "en çok soru ve olumsuzda; olumluda *a lot of* daha doğal" dendi (resmî yazıda olumlu *much / many* de doğru).

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
