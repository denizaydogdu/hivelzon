# G-B2-11-future-continuous-perfect: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi.
- Kanca ve "Hikâyede gör" cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - yok (müfredat: "henüz yok"); kanca bizim cümlemiz.

## Tipik hata kaynağı
*until June* (bitiş anlamında) → *by June* · *will have finish* → *will have finished*

## Öğretmene notlar
- Ses: c04 ilk üretimde "iş o" zayıf eşleşti (skor 0.933); cümle "Eylem o ana kadar bitecekse…" diye yeniden yazılıp üretildi (skor 1.0).
- - Kanca bizim cümlemizdir: müfredatta bu konu için hikâye bağı "henüz yok" (S1 ve A1–A2 kitapları 2026-10-14'te yeniden tarandı). Bu yüzden "Hikâyede gör" kartı yok; B1–B2 kitapları ya da S2 yazılınca eklenmeli.
- Müfredattaki "*By June I will finish.* → *By June I will have finished.*" tipik hatası bilerek kullanılmadı: *I'll finish it by June* da doğru bir cümledir (bitiş sınırı). Karşılaştırma kartında yerine *until* yanlışı ve *will have finish* biçim hatası kondu.
- *will be doing*'in kibar soru kullanımı (*Will you be using the car?*) yalnız örnekte var, ayrıca anlatılmadı.
- Future perfect continuous (*will have been working*) anlatılmadı.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h081b.json`): 6 parça, Duyu kalitesi hepsinde ok, en düşük skor 1.0 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
