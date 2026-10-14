# G-B1-10-might-may-could: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi (B1, %100.0).
- "Hikâyede gör" ve kanca cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A2-K04 p08 · "\"Rain is coming on Friday,\" said the weather report."
  - A2-K04 p01 · "From her bedroom window, Nia could see the Earth."
  - A2-K05 p02 · "From the balcony, he could see the beach."
  - A2-K02 p04 · "She could only see Jonas and the flower."

## Tipik hata kaynağı
*It can rain tomorrow.* · *might to go* (müfredat, G-B1-10)

## Öğretmene notlar
- Olasılık anlamı bölüm ve kitaplarda yok. Kanca A2-K04 p08'deki hava raporu cümlesine bağlı (*Rain is coming on Friday*, present continuous); hedef *It might rain on Friday.* bizim. Kitabın sonu (cuma günü yağmur yağmaz) anlatımda söylenmedi, sürpriz bozulmasın diye.
- *may*'in "biraz daha resmî" olduğu sadeleştirmedir; *may*'in izin anlamı anlatılmadı.
- *couldn't* = "imkânsız" sadeleştirme; günlük dilde *can't be* daha yaygın.
- *It can rain* genel olasılıkta doğrudur (*It can rain a lot here in April.*); hata örneği belirli bir gelecek tahmini için verildi.
- *maybe + will* alternatifi anlatılmadı. Olasılık anlamı kitaplarda yok; "Hikâyede gör" yalnız *could*'un geçmiş yetenek anlamını gösterir.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h081a.json`): 7 parça, Duyu kalitesi hepsinde ok, en düşük skor 1.0 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma, 376 karakter) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
