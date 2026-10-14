# G-A2-12-adverbs: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi.
- "Hikâyede gör" ve kanca cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A2-K02 p01 · "He always listened to teachers." (kanca)
  - A1-006 · "Slowly, please." (kurgu yok; story.en.md ✓ seçenek satırı)
  - A1-K05 p01 · "She always looks down a little." · A2-K05 p02 · "Usually, Mateo spent every summer in the water."
  - A2-K03 p01 · "Max did the maths very quickly."

## Tipik hata kaynağı
*I go always.*, *Speak slow.*, *I don't never…* (müfredat, G-A2-12)

## Öğretmene notlar
- *usually / sometimes / often* cümle başına da gelebilir (kitapta "Usually, Mateo…"); *always / never* gelmez. Derste yalnız "genelde ve bazen anlamındakiler başa da gelebilir" dendi.
- *Speak slow* gündelik (özellikle Amerikan) konuşmada duyulur; derste standart biçim (*slowly*) öğretildi.
- Düzensiz zarflardan yalnız *good → well* gösterildi; *fast, hard, late* anlatılmadı.
- Ses: c04 ve c09'da "sıfata -ly" Duyu'da "sıfat ali" duyuldu (skor 0.958 / 0.944); kalite ok ama yayından önce dinlenmeli.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan", "zamanla oturur" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h080b.json`): 7 parça, Duyu kalitesi hepsinde ok, en düşük skor 0.944 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
