# G-A2-15-verb-patterns: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi.
- "Hikâyede gör" ve kanca cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A2-K04 p01 · "Nia was born on the Moon, and she wanted to see rain." (kanca)
  - A2-K01 p02 · "This year, Elif wanted to enter with the lemon cake." · A2-K02 p08 · "Paloma tried to remember Mrs Berg's rules."
  - A1-K04 p06 · "\"Do you want to sleep, too?\"" · A2-K04 p15 · "Nobody needed to tell Nia."

## Tipik hata kaynağı
*I want go.* ve *I would like go.* (müfredat, G-A2-15)

## Öğretmene notlar
- *like / love* sonrası *to* da doğrudur (I like to read; özellikle Amerikan İngilizcesi). Derste "çoğu zaman -ing" dendi; alıştırmada *to play* seçeneği bilerek konmadı ve açıklamada "-ing ya da to" yazıldı.
- *try to* (çabalamak) ile *try -ing* (denemek) farkı B1-09'a bırakıldı.
- Kitaplarda *like + -ing* örneği yok; "Hikâyede gör" yalnız *to* kalıbını gösteriyor.

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
