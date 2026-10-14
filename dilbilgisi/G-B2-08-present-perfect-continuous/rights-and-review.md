# G-B2-08-present-perfect-continuous: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi.
- Kanca ve "Hikâyede gör" cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - yok (müfredat: "henüz yok"); kanca bizim cümlemiz.

## Tipik hata kaynağı
*I am waiting for two hours.* → *I've been waiting for two hours.* · *I've been knowing her for years.* → *I've known her for years.* (müfredat, G-B2-08)

## Öğretmene notlar
- - Kanca bizim cümlemizdir: müfredatta bu konu için hikâye bağı "henüz yok" (S1 ve A1–A2 kitapları 2026-10-14'te yeniden tarandı). Bu yüzden "Hikâyede gör" kartı yok; B1–B2 kitapları ya da S2 yazılınca eklenmeli.
- Durum fiilleri "genellikle bu yapıyı almaz" diye anlatıldı; *I've been loving this book* gibi konuşma kullanımları ve *live / work* gibi iki yapıyla da kullanılabilen fiiller anlatılmadı.
- Present perfect simple ile farkı (bitmiş sonuç / süreç: *I've painted the room* / *I've been painting the room*) ayrı kart olarak işlenmedi; yalnız "izi görünen eylem" kartıyla değinildi.
- Türkçe karşılıklarda süren eylem şimdiki zamanla (bekliyorum), izi görünen eylem -miş ya da geçmişle (yağıyormuş, yüzdün mü) verildi.

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
