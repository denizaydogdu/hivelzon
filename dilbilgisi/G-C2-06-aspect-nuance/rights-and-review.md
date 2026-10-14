# G-C2-06-aspect-nuance: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: C2 için CEFR-J Wordlist v1.6 + Octanove C1/C2 (CC BY-SA, ayrı veri seti) gerekir; Octanove listesi depoda olmadığı için kapsama denetlenmedi (`grammar_lint.py`: "liste yok"). Liste eklenince yeniden denetlenmeli.
- Kanca ve örnekler bizim cümlelerimizdir; S1 bölümlerinde ve kitaplarda bu yapı henüz yok (müfredat, 2026-10-14).

## Tipik hata kaynağı
Geçici davranış için *He is rude today.* · resmî ricada *I wonder if you can help.* (müfredat, G-C2-06) · şu an olan iş için *We have dinner now.*

## Öğretmene notlar
- Kanca bizim cümlemizdir; hikâye bağı henüz yok. C2-K05'te babanın kusurlu İngilizcesi bilinçli korunuyor (`KATALOG.md` madde 6); kitap yazılınca karşılaştırma kaynağı olabilir.
- *He is rude today.* karşılaştırma kartında x olarak duruyor (müfredattaki tipik hata). Kesin dilbilgisi hatası değildir; "bugünkü geçici davranış için doğal olan *is being*" diye yumuşak not verildi. Öğretmen gerekirse bu satırı kaldırabilir.
- *I wonder if you can help* yanlış değildir, yalnız daha az kibardır; bu yüzden x satırı olarak konmadı, alıştırma 2'de de seçenek değil.
- Anlamı değişen durum fiilleri üç örnekle sınırlı (*have* = yemek, *think* = tartmak, *see* = buluşmak). *I'm loving it* gibi konuşma dili kullanımları ve *always + -ing* (yakınma) anlatılmadı.
- *I was hoping…* ve *I was thinking…* geçmiş sürekli biçimle yumuşatma olarak örneklerde var; *I'm hoping / I'd hoped* katmanları anlatılmadı.
- Alıştırma 3'te *think* (geniş zaman) bağlamda yanlış sayıldı ("henüz karar vermedim" süreç bildiriyor); tartışmalı bulunursa soru değiştirilebilir.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h082.json`): 6 parça, Duyu kalitesi hepsinde ok, en düşük skor 1.0 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma, 456 karakter) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
