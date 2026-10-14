# G-A2-04-past-simple-regular: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi.
- "Hikâyede gör" ve kanca cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A2-K04 p01 · "She lived in Lunaria, a small town under a glass roof." (kanca)
  - A2-K01 p01 · "The day before the contest, the famous recipe disappeared." · p02 · "On Friday morning, Elif opened the box."
  - A2-K03 p01 · "So when Mrs Bell from next door called him, he listened carefully."
  - A2-K02 p01 · "They stayed in an old wooden house above the trees."

## Tipik hata kaynağı
*Yesterday I walk to school.* (müfredat, G-A2-04) · *studyed* (yazım) · *worked*'ü ayrı hece okumak (müfredat)

## Öğretmene notlar
- Okunuş kuralı sade: "t ya da d sesiyle biten fiilde ek ayrı hece" (/ɪd/). /t/ ile /d/ ayrımı (worked / played) yalnız örnekle duyuruldu, kural olarak anlatılmadı.
- Ünsüz ikileme tek heceli fiillerle sınırlı anlatıldı (stop → stopped); w, x, y ile bitenler (play → played) ve iki heceli vurgulu fiiller (prefer → preferred) anlatılmadı.
- S1'de bu yapı yok; bağlar yalnız A2 kitaplarından.
- Ses: c03'te tek harfler ("e harfi", "i olur") Duyu'da zayıf eşleşti (skor 0.967), c09'da -ed "et" duyuldu (0.917); kalite ok ama yayından önce dinlenmeli.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan", "zamanla oturur" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h080b.json`): 7 parça, Duyu kalitesi hepsinde ok, en düşük skor 0.917 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
