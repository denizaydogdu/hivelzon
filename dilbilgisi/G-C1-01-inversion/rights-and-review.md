# G-C1-01-inversion: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: C1 için CEFR-J Wordlist v1.6 + Octanove C1/C2 (CC BY-SA, ayrı veri seti) gerekir; Octanove listesi depoda olmadığı için kapsama denetlenmedi (`grammar_lint.py`: "liste yok"). Liste eklenince yeniden denetlenmeli.
- Kanca ve örnekler bizim cümlelerimizdir; S1 bölümlerinde ve kitaplarda bu yapı henüz yok (müfredat, 2026-10-14).

## Tipik hata kaynağı
*Never I have seen…* · *Not only he is…* (müfredat, G-C1-01) · *Only then I understood.*

## Öğretmene notlar
- Kanca bizim cümlemizdir; hikâye bağı henüz yok (S1 ve A1–A2 kitapları 2026-10-14'te tarandı), "Hikâyede gör" kartı yok; B2+ kitapları ya da S2+ yazılınca eklenmeli.
- Anlatılan devrik yapı yalnız olumsuz ve kısıtlayıcı zarf öbeklerinden sonrakidir (*Never, Rarely, Seldom, Hardly … when, Not only, Only then, Not until, Under no circumstances*). *if*'siz şart devriği (*Had I known*) G-C2-04'e, *Little did she know* ve *So/Such … that* G-C2-01'e bırakıldı.
- *Hardly had we arrived when…* ve *Not until I got home did I notice…* (devrik yapı ana cümlede) örnekte var ama ayrıca anlatılmadı; *No sooner … than* hiç yok.
- "Olmak fiili varsa yardımcı eklenmez, kendisi öne geçer" kuralı modal ve *have* yardımcısı için de geçerli (*Under no circumstances should you…*); yalnız örnekle gösterildi.
- Kayıt notu: anlatım "daha çok yazıda, konuşmalarda ve resmî dilde" diyor; *Not only… but also* ve *Never have I…* günlük konuşmada da vurgu için duyulur.
- Türkçedeki "devrik cümle" (yüklemin öne geçmesi) ile ayrım açıkça söylendi; öğrencinin terimden kafası karışabilir.
- *realise* İngiliz yazımıyla (kitaplarla aynı).

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h082.json`): 6 parça, Duyu kalitesi hepsinde ok, en düşük skor 1.0 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma, 542 karakter) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
