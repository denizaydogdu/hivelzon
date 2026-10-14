# G-C2-01-fronting: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: C2 için CEFR-J Wordlist v1.6 + Octanove C1/C2 (CC BY-SA, ayrı veri seti) gerekir; Octanove listesi depoda olmadığı için kapsama denetlenmedi (`grammar_lint.py`: "liste yok"). Liste eklenince yeniden denetlenmeli.
- Kanca ve örnekler bizim cümlelerimizdir; S1 bölümlerinde ve kitaplarda bu yapı henüz yok (müfredat, 2026-10-14).

## Tipik hata kaynağı
*Such the noise was that…* · *Little she knew…* (müfredat, G-C2-01)

## Öğretmene notlar
- Kanca bizim cümlemizdir; hikâye bağı henüz yok (C2-K01 ve C2-K04 yazılınca aday). "Hikâyede gör" kartı yok.
- Üç tür öne alma bir arada anlatıldı: olumsuz anlamlı *Little* + devrik yapı, *Such / So … that* ve yer/nesne öne alma. Bilgi yapısı terimleri (tema/rema, odak) kullanılmadı.
- Yer öne alındığında fiil–özne devriği (*On the hill stood an old lighthouse*) yalnız özne isim öbeğiyse olur; özne zamirse olmaz (*On the hill it stood*). Bu kısıt anlatılmadı.
- Nesne öne alma (*This I can promise you.*, *What he said next I will never forget.*) konuşmada da vurgu için kullanılır; anlatım "çok sık kullanılırsa yapay durur" uyarısıyla sınırlı.
- *Little did she know* edebî/anlatı üslubudur; kayıt notu yalnız "metne akış ve vurgu katar" diye verildi.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h082.json`): 6 parça, Duyu kalitesi hepsinde ok, en düşük skor 1.0 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma, 559 karakter) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
