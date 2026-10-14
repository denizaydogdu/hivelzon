# G-B2-02-reported-statements: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi.
- Kanca ve "Hikâyede gör" cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A2-K04 p01 · "Mum said it was cold." (kanca)
  - A2-K04 p01 · "Dad said it was warm."
  - A2-K03 p07 · "They said it was the best pancake in the world."

## Tipik hata kaynağı
*She said me…* → *She told me…* · *She told that…* → *She said that…* (müfredat, G-B2-02)

## Öğretmene notlar
- Zaman kaydırma "çoğu zaman" diye anlatıldı: söz hâlâ doğruysa kaydırma zorunlu değildir (*She said she lives in Ankara*). Bu istisna kartlarda açıkça işlenmedi; alıştırmalar yalnız kaydırmalı biçimi soruyor.
- Geçmiş → past perfect kaydırması da konuşmada sıkça yapılmaz (*He said he saw it*). Anlatımda "daha önceki geçmişe geçer" dendi; öğretmen "yazıda ve dikkatli konuşmada" diye yumuşatmak isteyebilir.
- *can → could*, *must → had to*, *this → that* gibi diğer kaydırmalar anlatılmadı; yalnız *will → would*, *here → there*, *tomorrow → the next day* örneklendi.
- Kancadaki "Mum said it was cold." kitapta anlatı geçmişinin içinde; annenin özgün sözünün "It's cold." olduğu varsayıldı.
- *said* ile *told* ayrımı "kime söylendiğini belirtiyorsan told" diye sadeleştirildi; *said to me* biçimi anlatılmadı.

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
