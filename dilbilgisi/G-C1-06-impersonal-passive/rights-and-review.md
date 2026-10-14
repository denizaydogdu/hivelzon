# G-C1-06-impersonal-passive: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: C1 için CEFR-J Wordlist v1.6 + Octanove C1/C2 (CC BY-SA, ayrı veri seti) gerekir; Octanove listesi depoda olmadığı için kapsama denetlenmedi (`grammar_lint.py`: "liste yok"). Liste eklenince yeniden denetlenmeli.
- Kanca ve örnekler bizim cümlelerimizdir; S1 bölümlerinde ve kitaplarda bu yapı henüz yok (müfredat, 2026-10-14).

## Tipik hata kaynağı
*He is said that he is rich.* (müfredat, G-C1-06) · *She is believed to leave yesterday.*

## Öğretmene notlar
- Kanca bizim cümlemizdir; hikâye bağı henüz yok (S1 ve A1–A2 kitapları 2026-10-14'te tarandı), "Hikâyede gör" kartı yok; B2+ kitapları ya da S2+ yazılınca eklenmeli.
- "Boş özne" = sözde özne *it*. *There is said to be…* kalıbı anlatılmadı.
- Mastarın sürekli biçimi (*is said to be living*) ve edilgen mastar (*is thought to have been stolen*) anlatılmadı; yalnız *to + fiil* ve *to have + V3*.
- Her fiil iki kalıbı da aynı doğallıkta almaz; anlatım bunu ayrıca söylemiyor.
- Hook'ta Türkçe "söyleniyor" ile köprü kuruldu; karşılaştırmada "-mış" (zenginmiş) da anıldı. Bu bir köprüdür, birebir eşdeğerlik değil.
- Kancadaki "perili kale" 13 yaş altı için de hafif bir masal unsuru olarak düşünüldü; istenirse başka bir söylentiyle değiştirilebilir.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h082.json`): 6 parça, Duyu kalitesi hepsinde ok, en düşük skor 1.0 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma, 480 karakter) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
