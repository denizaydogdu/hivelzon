# G-B1-01-present-perfect-experience: haklar ve inceleme

## Kaynaklar ve lisans
- Metin, örnek cümleler, Türkçe anlatım ve alıştırmalar kendi metnimizdir (Claude taslağı, 2026-10-14).
- Konu sırası ve hedef `dilbilgisi/MUFREDAT.md`'den (CEFR-J Grammar Profile yalnız referans; ham veri kullanılmadı, `docs/LISANS-RAPORU.md`).
- Cambridge EGP/EVP, Oxford, GSE ve benzeri kaynakların metni kullanılmadı.
- Kelime kapsaması: CEFR-J Wordlist v1.6 (atıfla ticari kullanım serbest), `grammar_lint.py` ile denetlendi (B1, %100.0).
- "Hikâyede gör" ve kanca cümleleri hiVelzon'un kendi bölüm ve kitap metinlerinden birebir alındı; `grammar_lint.py` her bağı yeniden çözer:
  - A2-K04 p01 · "Nia was born on the Moon, and she wanted to see rain."

## Tipik hata kaynağı
*Did you ever go to London?* · *I have went.* · *I have seen him yesterday.* (müfredat, G-B1-01)

## Öğretmene notlar
- Present perfect S1 bölümlerinde ve A2 kitaplarında bilerek yok (müfredat). Kanca, gerçek kitap cümlesine (A2-K04 p01, past simple) bağlandı; hedef cümle *I've never seen rain.* bizim yazdığımız, Nia'nın ağzından aynı durum. Anlatım bunu açıkça söyler.
- *been to* / *gone to* farkı anlatılmadı; örneklerde yalnız *been to* (bulunup dönmek) var.
- *Did you ever…?* Amerikan İngilizcesinde deneyim sorusu olarak da duyulur; bu yüzden tipik hata olarak gösterilmedi. Karşılaştırma kartı yalnız zamanı belli cümleyi (*yesterday*) hata olarak gösterir. Alıştırma 1'de *Did* yanlış seçenek (İngiliz kullanımı esas).
- "Üçüncü hâl" (V3) terimi kullanıldı; düzensiz fiil listesi verilmedi. *'ve / 's* (= has) kısaltmaları ayrıca anlatılmadı, yalnız örneklerde.
- A2-K04'ün adı *The Girl Who Never Saw Rain* ve p02 *things Nia never saw* past simple ile (Amerikan kullanımına yakın; İngiliz kullanımında anlatı içinde *had never seen*). Öğrenci sorarsa açıklama gerekebilir.

## Güvenlik
- 13+ ve 13 altı için uygun: şiddet, siyaset, din, gerçek marka ya da ünlü yok.
- Dil utandırmaz: hata "çok olağan" diye sunulur (K-32, `ARAYUZ-METINLERI.md` §1).
- Hi yalnız dile yardım eder; gizemi çözmez (K-23).
- Ses: Türkçe Alania (yapay zekâ sesi), İngilizce Sarah (ElevenLabs, yapay zekâ sesi). Uygulama içinde yapay zekâ notu uygulama kuralıyla gösterilir.

## Onay geçmişi
| Tarih | Adım | Kim | Not |
|---|---|---|---|
| 2026-10-14 | Taslak yazıldı, `grammar_lint.py` 0 hata | Claude | Durum DRAFT, `aiGenerated: true` |
| 2026-10-14 | Türkçe anlatım sesi (Alania + Duyu, kampanya döneminde ücretsiz; defter `patientdesk-h081a.json`): 6 parça, Duyu kalitesi hepsinde ok, en düşük skor 0.963 | Claude | İngilizce örnek sesi bekliyor (yalnız kuru çalışma, 400 karakter) |
| — | Kullanıcı onayı (H-028) | bekliyor | |
| — | Öğretmen ya da editör kontrolü (yayın şartı, DILBILGISI §5) | bekliyor | `teacherReview` henüz `null` |
