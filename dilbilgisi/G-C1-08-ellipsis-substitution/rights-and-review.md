# G-C1-08-ellipsis-substitution: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: C1 için CEFR-J Wordlist v1.6 + Octanove C1/C2 (CC BY-SA, ayrı veri seti) gerekir; Octanove listesi depoda olmadığı için kapsama denetlenmedi (`grammar_lint.py`: "liste yok"). Liste eklenince yeniden denetlenmeli.
- Kanca bağı hiVelzon'un kendi kitap metninden birebir alındı; `grammar_lint.py` bağı yeniden çözer:
  - A1-K04 p05 · ""Me too," says Pip." (kanca; köprü)

## Tipik hata kaynağı
Olumsuzda *Me too.* / *So do I.* · *I think yes.* · *I hope it.* (müfredat, G-C1-08)

## Öğretmene notlar
- Kanca bir köprüdür: A1-K04 p05'te Pip, Zara'nın olumsuz cümlesine (*I can't sleep.*) gündelik *Me too* ile katılıyor. Anlatım bunu "gündelik ve kısa, konuşmada çok duyulur" diye sunar; özenli kalıp olarak *Neither can I* gösterilir. Kitap satırı A1 sadeliği için bırakılabilir; editör isterse *Me neither* yapılabilir (o zaman kanca bağı güncellenmeli).
- Karşılaştırma kartındaki x satırı *So do I* (olumsuza olumlu kalıp) üzerinden kuruldu, *Me too* üzerinden değil; çünkü *Me too* gündelik konuşmada olumsuzdan sonra da duyulur. *Me neither* kartlarda geçmiyor.
- *So / Neither / Nor* ile kısa cevaplar ve *I think so / I hope not / I'm afraid not* anlatıldı. *I don't think so* ile *I think not* (resmî) ayrımı ve *do so* yerine koyma anlatılmadı.
- Müfredat notu: temel biçim A2–B1'dir; C1'de akıcı kullanım ve yardımcı fiilden sonra eksiltme (*I wanted to help, but I couldn't.*) eklendi. Bu eksiltme ayrıca adlandırılmadı, yalnız örnekte.
- *one / ones* yalnız tekil sayılabilen isimle verildi; sayılamayan isimle kullanılmadığı söylenmedi.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h082.json`): 6 parça, Duyu kalitesi hepsinde ok, en düşük skor 1.0 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma, 497 karakter) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
