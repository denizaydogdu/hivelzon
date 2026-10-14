# G-A2-11-will: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi.
- "Hikâyede gör" ve kanca cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A1-010 · "I'll take it." (kanca; kurgu yok, story.en.md satırı "OK. I'll take it.")
  - "Hikâyede gör" kartı yok: S1'de *will* yalnız bu cümlede geçiyor; A2 kitapları gelecek için *going to* kullanıyor (lint uyarısı bilerek bırakıldı).

## Tipik hata kaynağı
*I will to go.* ve alışverişte *I take it.* (müfredat, G-A2-11)

## Öğretmene notlar
- *going to* ile *will* ayrımı A2 düzeyinde sade anlatıldı (plan / kanıt → going to; anlık karar, söz, teklif, görüşe dayalı tahmin → will). Gerçek kullanımda sınır bulanıktır; alıştırmaya iki biçimin de doğru olabileceği sorular bilerek konmadı.
- Türkçe karşılıklar ("Pencereyi kapatayım", "Ben bakarım") anlık kararın Türkçedeki doğal söylenişine göre seçildi.
- A2 kitaplarında *will* örneği yok; ileride bir kitap ya da bölüm eklenirse "Hikâyede gör" kartı eklenmeli.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan", "zamanla oturur" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h080b.json`): 6 parça, Duyu kalitesi hepsinde ok, en düşük skor 1.0 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
