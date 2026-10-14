# H-075: Türkçe ses: Alania + Duyu hizalama

- **Durum:** Bitti (2026-10-14; pytest 184/184; gerçek uçtan uca deneme yapıldı)
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

2026-10-14 (uygulama, `h-075-turkce-ses` dalı):
- Kod: `tools/content-pipeline/hvpipeline/tts_tr.py` ve CLI `tools/content-pipeline/tts_tr.py`. Kullanım: `docs/DILBILGISI.md` §6.1.
- Testler: `tests/test_tts_tr.py`, 15 test, sahte istemciyle (ağ yok). Kapsam: kuru çalışma, tavan reddi, idempotentlik ve önbellek, Retry-After, yanlış duyma ve noktalama dahil eşleme, `align.py` uyumu, -16 LUFS. Bütün paket: 175 geçti, 9 atlandı (git dışı medya).
- Duman testi (gerçek API, ücretsiz ay, kullanıcı onaylı): Hi'nin "-s takısı" anlatımından 2 cümle. Çıktı repo dışında: `/Users/felece/.claude/jobs/f31ecd68/tmp/h075/`.
  - 154 karakter; 4,32 sn ve 7,20 sn; -16,49 ve -16,6 LUFS; Alania sürümü `alania-v2.1`.
  - Türkçe cümle: 10/10 kelime eşleşti.
  - İngilizce örnekli cümle: `he/she/She plays` Türkçe okundu ve "h/ş/fi" duyuldu. Araç uyardı (%81, `quality.ok=false`).
  - İkinci çalışmada hiçbir çağrı yapılmadı.
  - Defter: `kitaplar/_maliyet/patientdesk-karakter.json`.
- Açık: İngilizce örnekler için Sarah parçası mı, söyleniş sözlüğü mü (pilot). "-s" söylenişi de sözlük adayı. Sesler henüz kulakla dinlenmedi. Kabul kriterlerinin doğrulanması ve dosyanın taşınması kullanıcıya bırakıldı.
2026-10-14: `main`'e birleştirildi ve kapandı. Bulgu: Alania İngilizce kelimeleri Türkçe okur; Türkçe anlatım içindeki İngilizce örnekler ayrı parça olarak Sarah'ya (ElevenLabs) okutulacak. Söyleniş sözlüğü (ör. `-s` → "se") pilotta (H-079) denenecek.
