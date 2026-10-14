# G-B2-01-passive: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi.
- Kanca ve "Hikâyede gör" cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A2-K04 p01 · "Nia was born on the Moon, and she wanted to see rain." (kanca)
  - A2-K02 p07 · "The fish were called One, Two and Three." (Hikâyede gör)

## Tipik hata kaynağı
*I born in 2005.* / *I am born…* · *The house built in 1990.* · *It was happened.* (müfredat, G-B2-01)

## Öğretmene notlar
- *be born* edilgen yapı gibi anlatıldı ("doğmak İngilizcede edilgendir"); tarihsel olarak *bear* fiilinin edilgenidir, bugün kalıp gibi öğretilir.
- Anlatılmayanlar: *get* edilgeni (*got stolen*), süren edilgen (*is being built*), modal edilgen (*must be done*), iki nesneli fiiller (*I was given a book*). Örneklerde yalnız geniş, geçmiş, gelecek ve present perfect var.
- "Yapan çoğu zaman söylenmez" bir eğilimdir, kural değil; *by* yalnız yeni ya da önemli bilgi olduğunda gelir.
- Müfredattaki sıfat gibi V3 örnekleri (A1-K01 p01 "It is locked.", A1-002 "It is closed.") durum bildirdiği için bilerek bağ yapılmadı; istenirse ayrı bir notla eklenebilir.
- *cancelled* İngiliz yazımıyla bırakıldı (kitaplarla aynı); Amerikan yazımı *canceled*.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h081b.json`): 7 parça, Duyu kalitesi hepsinde ok, en düşük skor 1.0 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
