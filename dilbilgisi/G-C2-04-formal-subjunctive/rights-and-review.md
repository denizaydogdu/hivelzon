# G-C2-04-formal-subjunctive: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: C2 için CEFR-J Wordlist v1.6 + Octanove C1/C2 (CC BY-SA, ayrı veri seti) gerekir; Octanove listesi depoda olmadığı için kapsama denetlenmedi (`grammar_lint.py`: "liste yok"). Liste eklenince yeniden denetlenmeli.
- Kanca ve örnekler bizim cümlelerimizdir; S1 bölümlerinde ve kitaplarda bu yapı henüz yok (müfredat, 2026-10-14).

## Tipik hata kaynağı
*Should you will need…* · *Had I know…* (müfredat, G-C2-04)

## Öğretmene notlar
- Kanca bizim cümlemizdir; hikâye bağı henüz yok (S1 ve A1–A2 kitapları 2026-10-14'te tarandı), "Hikâyede gör" kartı yok; B2+ kitapları ya da S2+ yazılınca eklenmeli.
- "Olası bir durum için öğüt modalı" = *Should you…* (1. tip, resmî). Buradaki *should* öğüt anlamı taşımaz; terim yalnız kelimeyi işaret etmek için kullanıldı. Öğretmen isterse açıklama ekleyebilir.
- *Were I…* / *Were it not for…* (2. tip) ve *Had I…* / *Had it not been for…* (3. tip) anlatıldı. *Were I to…* (gelecek varsayımı) anlatılmadı.
- Olumsuzda kısaltma yok: *Had it not been*, *Hadn't it been* değil. Anlatım bunu kısaca söyler.
- Resmî dilek kipi (*It is essential that he be…*, *recommended that she rest*) Amerikan İngilizcesinde ve resmî yazıda yaygındır; İngiliz İngilizcesinde *should be* ya da düz *is* de kullanılır. Bu yüzden *that he is there* hata olarak gösterilmedi; anlatım "günlük dilde yerine öğüt modalı da kullanılır" der.
- Alıştırma 4'te *Had it not been for you, I would be lost* karışık koşuldur (geçmiş koşul, şimdiki sonuç; G-C1-03).
- Kalıplaşmış dilek kipi (*Long live…*, *be that as it may*) bilerek anlatılmadı (kapsam ve din/siyaset çağrışımı).

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h082.json`): 6 parça, Duyu kalitesi hepsinde ok, en düşük skor 0.952 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma, 640 karakter) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
