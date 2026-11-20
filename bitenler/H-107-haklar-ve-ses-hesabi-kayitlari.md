# H-107: Haklar ve ses hesabı kayıtlarının doğrulanması

- **Durum:** ✅ Bitti (2026-11-20). Kayıt `ce0bfb7`, şartname tarihi düzeltmesi ve takip `6e885b9`; ikisi GitHub'a gönderildi.
- **Tür:** Belge ve kayıt (içerik hakları)
- **Faz:** F1 içerik
- **Bağımlılık:** H-085 (B5–B12 üretimi), H-069/H-071 (kitap sesleri), H-006 ek (ücretsiz seslerin yayında kullanımı)

## Sorun

`docs/EDITOR-INCELEME-PAKETI.md` §7'de iki açık nokta vardı:

1. B5–B12 İngilizce replik seslerinin hangi ElevenLabs hesabı/planıyla üretildiği bölüm kayıtlarında yazmıyordu ("doğrulanmadı").
2. Higgsfield çıktılarının ticari kullanım koşulu depoda doğrulanmış kaynakla yazılı değildi.

Ayrıca sesli dört kitabın `PROMPTS.md` ses bölümü başlığı hâlâ "Henüz üretilmedi" diyordu ve A1-K02…K05 ile A2-K03 haklar tablolarında hesap "Creator (ticari)" ya da "hesap/plan kitap kaydında yok" olarak geçiyordu.

## Yapılanlar

### Higgsfield ticari kullanım

- Terms of Use §4.4 (2026-10-23 sürümü) doğrulandı: Higgsfield girdilerin ve çıktıların sahipliğini talep etmiyor, çıktıların ticari kullanımını kısıtlamıyor; dışa aktarılan çıktı hakları abonelik bitince de sürüyor.
- Kaynak: `higgsfield.ai/Terms-of-Use-Agreement` §4.4 ve yardım merkezi "Who owns my generations and can I use them commercially"; doğrulama tarihi 2026-11-20.
- A1-001…A1-012 `rights-and-review.md` dosyalarındaki "depoda doğrulanmış kayıt yok" satırı bu koşulla değiştirildi. A1-000 üretilmediği için (PROMPTS/ses yok) satır içermiyordu.

### B5–B12 İngilizce ses hesapları

| Bölüm | Hesap | Kaynak |
|---|---|---|
| B5 (A1-005) | hesap3 (diyalog) + hesap1/videoGenerator (Hi ifadeleri) | `devam-edenler/H-085-bolum-5-12-uretimi.md`, 2026-10-14 |
| B6–B12 (A1-006…A1-012) | hesap4 | aynı dosya; defter `kitaplar/_maliyet/elevenlabs-hesap4-karakter.json` (9.993/10.000) |

- Hepsi ücretsiz plan. Ücretsiz hesap seslerinin yayında kullanılabilmesi H-006 ek (hukukçu görüşü, `docs/HUKUK-SORULARI.md` §9) kararına dayanır; yeniden üretim gerekmez.
- A1-002/003/004 zaten videoGenerator hesabını (ücretsiz plan) doğru yazıyordu; değiştirilmedi.

### Kitap kayıtları

- A1-K02, A1-K03, A1-K04, A1-K05 `PROMPTS.md` başlığı "Henüz üretilmedi" → "Üretildi" (tarihleriyle).
- A1-K02, A1-K03, A1-K04, A1-K05 ve A2-K03 haklar tabloları gerçek hesaplarla düzeltildi (ücretsiz anahtar; hesap2/hesap3; defter dosyaları).
- Sesli olmayan 24 kitabın "Henüz üretilmedi" başlığı **doğrudur**, değiştirilmedi.

### Belgeler

- `docs/EDITOR-INCELEME-PAKETI.md` §7: iki açık nokta kapandı; editörün kendi kontrolünü bekleyen maddeler (marka/kişi benzerliği, yaş uygunluğu) duruyor.

## Doğrulama

- `grep -rl "depoda doğrulanmış kayıt yok" icerik/` → 0 dosya.
- `grep -rl "ElevenLabs hesabı ve planı bu kayıtlarda yazmıyor" icerik/` → 0 dosya.
- Sesli dört kitapta `grep -l "Henüz üretilmedi"` → 0 dosya.
- 22 dosya değişti (12 bölüm + 5 kitap haklar + 4 kitap PROMPTS + editör paketi), commit `ce0bfb7`.
- 2026-11-20 yerel doğrulama: `pytest -q tools/content-pipeline` geçti (417 test); bölüm lint 13 bölüm/0 hata/30 uyarı, kitap lint 30/0/205, dilbilgisi lint 71/0/606, reel lint 18/0/6. Önceki bölüm uyarısı 28 idi; bu koşuda 30, sıfır hata.

## Sınırlar ve notlar

- Bu iş yeni bir hukuk görüşü üretmedi; ücretsiz hesap sesleri için mevcut H-006 ek kararı kaydedildi.
- Higgsfield §4.4 çıktıların model eğitiminde kullanılmasına izin veriyor (Enterprise hariç). İçerikte gerçek kişi, kişisel veri ve marka yok; ek önlem gerekmedi.
- Filigran ve üçüncü taraf hakları çıktı bazında yayın öncesi kontrol edilir; §4.4 tek başına editör onayı değildir.
- İlk `ce0bfb7` kaydındaki şartname sürüm tarihi (2026-08-27) yanlıştı; resmî sayfanın üstündeki 2026-10-23 tarihi esas alındı (2026-11-20 düzeltmesi).
