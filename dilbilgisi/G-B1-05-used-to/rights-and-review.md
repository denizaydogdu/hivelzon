# G-B1-05-used-to: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi (B1, %100.0).
- Kancada ve "Hikâyede gör"de bölüm ya da kitap bağı yok (bkz. Öğretmene notlar).

## Tipik hata kaynağı
*I was used to play.* · *Did you used to…?* (müfredat, G-B1-05)

## Öğretmene notlar
- İngilizce bölüm ve kitap metinlerinde *used to* yok. Kanca, prolog A1-000 Sahne 2'deki babaanne Nermin'in Türkçe repliğine ("Orada iyi çekerdi…") anlatımda değinir; Türkçe replik bağ olarak çözülemediği için kancada bağ yok (`grammar_lint` uyarısı, bilerek). *The signal used to be good there.* bizim çevirimiz. `linksTo.episodes` A1-000'ı bu Türkçe bağ için taşır.
- *would* ile geçmiş alışkanlık anlatılmadı.
- *be used to + -ing* (alışkın olmak) yalnız karşılaştırma kartında tek örnekle tanıtıldı; *get used to* yok.
- Şimdiki alışkanlık için *use to* kullanılmadığı (*I use to…* hatası) anlatılmadı.
- *used to / use to* söylenişinin aynı olduğu (/juːstə/) Türkçe anlatımda "söylenişte fark duyulmaz" diye verildi.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h081a.json`): 5 parça, Duyu kalitesi hepsinde ok, en düşük skor 1.0 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma, 418 karakter) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
