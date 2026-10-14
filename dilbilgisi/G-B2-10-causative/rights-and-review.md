# G-B2-10-causative: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi.
- Kanca ve "Hikâyede gör" cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - yok (müfredat: "henüz yok"); kanca bizim cümlemiz.

## Tipik hata kaynağı
Kuaförden sonra *I cut my hair.* → *I had my hair cut.* · *I made my car repair.* → *I had my car repaired.* (müfredat, G-B2-10)

## Öğretmene notlar
- - Kanca bizim cümlemizdir: müfredatta bu konu için hikâye bağı "henüz yok" (S1 ve A1–A2 kitapları 2026-10-14'te yeniden tarandı). Bu yüzden "Hikâyede gör" kartı yok; B1–B2 kitapları ya da S2 yazılınca eklenmeli.
- Gündelik konuşmada *I cut my hair* kuaförde kestirmek anlamında da duyulur; ders standart biçimi öğretiyor.
- Kötü bir olayın başa gelmesi anlamı (*She had her bag stolen*) ve *have/get someone to do*, *make someone do* yapıları anlatılmadı.
- *get* "almak anlamındaki fiil" diye tanıtıldı; *get*'in birçok anlamı olduğu söylenmedi.

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
