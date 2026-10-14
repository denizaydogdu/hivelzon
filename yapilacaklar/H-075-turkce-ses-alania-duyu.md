# H-075: Türkçe ses: Alania + Duyu hizalama

- **Durum:** Yapılacak
- **Tür:** Uygulama (araç)
- **Faz:** Dilbilgisi D0 (`docs/DILBILGISI.md` §8)
- **Bağımlılık:** —

## Kapsam
- Boru hattına Türkçe TTS adaptörü: PatientDesk Alania, `alania-v2`, `alania2-f1`.
- Varsayılan kuru çalışma; gerçek çağrı için `--execute`.
- Aylık karakter tavanı tanımlı değilse araç çalışmaz.
- Var olan ses yeniden üretilmez (idempotent).
- Her çağrı `PROMPTS.md`'ye yazılır.
- Anahtar yalnız ortamdan ya da `~/.config/hivelzon/patientdesk.env`'den okunur.
- Duyu (`duyu-1`, `verbose_json`, kelime zaman damgası) ile kelime zamanları alınır ve `align.py`'nin okuduğu hizalama biçimine çevrilir.
- Ses -16 LUFS'a getirilir.
- Sunucu ayarı `hivelzon.tts.patientdesk` (yapıldı, 2026-10-14).

## Kabul kriterleri
- Örnek bir Türkçe cümle uçtan uca seslendirilir ve zamanlanır.
- pytest yeşil; gerçek API sahte istemciyle test edilir.

## Test
`tools/content-pipeline/.venv/bin/python -m pytest tools/content-pipeline`

## Geri alma
Kendi dalında; `git revert`.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Türk öğrenciler bazen konuları anlamıyor; A1'den C2'ye Türkçe anlatacağımız dilbilgisi konuları olsun." Ek istek: "Her hikâyeden önce dilbilgisi konusunu anlatayım mı diye sorulsun; ayrıca ayrı bir dilbilgisi alanı olsun." Kararlar: anlatıcı Hi (Türkçe Alania, İngilizce örnekler Sarah); biçim canlı ders kartları; yer Hikâye'de üçüncü bölüm ve bağlamdan; teklif bölüm panelinde ikincil düğme (H-050 korunur); önce müfredat, pilot 3 A1 konusu, sonra dalgalar. Ayrıntı: `docs/DILBILGISI.md`.
