# G-B1-02-present-perfect-since-for: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi (B1, %100.0).
- "Hikâyede gör" ve kanca cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A2-K05 p15 · "For thirty years, she watched the sea from this tower."

## Tipik hata kaynağı
*I am here since 2019.* · *I know him for five years.* · *since three years* (müfredat, G-B1-02)

## Öğretmene notlar
- Kanca A2-K05 p15'e bağlı: anlatıcı *For thirty years, she watched…* (bitmiş zaman çerçevesi, past simple) diyor; hedef cümle *I've watched the sea for thirty years.* İnes'in ağzından bizim yeniden söyleyişimiz (bugün son günü, iş hâlâ sürüyor).
- Yalnız durum fiilleri ve basit biçim. Süren eylem biçimi (*I've been learning English for three years*) B2'ye (G-B2-08) bırakıldı; Türkçe örnek "üç yıldır İngilizce öğreniyorum" bu yüzden anlatımdan çıkarıldı, yerine "üç yıldır onu tanıyorum" kondu.
- "Yanına ne zamandan beri ya da ne kadardır sürdüğü eklenir" sadeleştirmedir; yapı zaman ifadesi olmadan da kullanılır (G-B1-01).
- *for* ≈ "-dır" eşlemesi yaklaşık: *for* bitmiş geçmişte de kullanılır (kanca cümlesi tam bunu gösterir). *How long…?* sorusu yalnız örnekte.
- Anlatımda yıllar rakamla (2019, 2020) yazıldı; Duyu eşleşmesi sorunsuz.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h081a.json`): 5 parça, Duyu kalitesi hepsinde ok, en düşük skor 1.0 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma, 422 karakter) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
