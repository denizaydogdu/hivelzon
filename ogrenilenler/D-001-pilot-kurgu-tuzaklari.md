# D-001: Pilot kurgu ve üretim tuzakları (H-024)

**Tarih:** 2026-10-11 · **Kaynak:** S1·B1 pilotu

## Ses ve yazı senkronu
- **ffmpeg'de `atempo` → `adelay` → `apad` → `atrim=duration` zinciri sesi bölüm süresine dolduramadı.** Ses kısa kaldı ve birleştirmede (`acrossfade`) sonraki bütün sesleri öne çekti. Kullanıcı bunu "ses önden ya da arkadan gidiyor" diye fark etti.
  - **Kural:** Hız değişikliği önceden ayrı bir dosyaya uygulanır. Doldurma `apad=whole_dur=L, atrim=end=L` ile yapılır. Bölüm başına ses ve görüntü süresi ölçülür; fark 0,02 sn'yi geçmemelidir.
- **Altyazı cümlenin tamamını bir anda göstermemeli.** TTS zaman damgalarıyla parça parça zamanlanır; yazı söylenince kaldırılır.
- **Doğrulama:** "Göz kararı" yetmez. Çıktıdaki gerçek ses başlangıcı yazı başlangıcıyla otomatik karşılaştırılır (hedef ≤ 0,2 sn).

## Hareket akıcılığı
- **`scale` ile çift piksele yuvarlanan Ken Burns takılır** (44 karenin 12'si hareketsizdi). 3 kat süper örnekleme + `zoompan` ile 0/44.
- Aynı kare art arda uzun süre kullanılmaz. Geçişlerde (`xfade`) hareket kaldığı yerden sürer.

## Higgsfield
- `--json` çıktısında ilk `.png` adresi **referans görsele** ait olabilir. Sonuç **`result_url`** alanından alınır.
- GPT Image 2.5'in varsayılan kalitesi `low`; 0,5 kr/görsel bu kaliteye ait.
- Nano Banana 2 referans sayfasında "yazı yok" kuralını çiğnedi (etiket ve başlık yazdı).
- Hesap başka oturumlarla ortak; her üretimden önce `account status` kontrol edilir.

## Ortam
- **Shell zsh.** Tırnaksız `$args` kelimelere bölünmez. `$VAR:l` bir değişken düzenleyicisidir (`${VAR}:linear` yazılmalı). Çok parçalı komutlar Python `subprocess` ile, liste argümanlarla çalıştırılır.
- Bu makinedeki ffmpeg'de **`drawtext` ve `subtitles` filtreleri yok.** Yazılar ImageMagick ile PNG olarak üretilip `overlay` ile eklenir.

## Seslendirme
- ElevenLabs `eleven_v3` + `with-timestamps`, `voice_settings.speed` ve `language_code` kabul ediyor. Kısa repliklerde konuşma hızı yüksek çıkıyor (220–250 kelime/dk); hedef ifadeler kurguda yavaşlatılır.

## Birden çok karakterli sahne
- İki referanslı sahnede (Maya + Alex) model kıyafetleri karıştırabilir; B4-01'de Maya, Alex'in ceketiyle çıktı. **Kural:** Her karakterin ayırt edici kıyafeti prompt'a açıkça yazılır ve "NO <öteki karakterin kıyafeti>" eklenir.

## 2026-10-12: alimiter kendiliğinden ses yükseltir (H-049)
- `alimiter` varsayılan olarak `level=1` ile çıkışı sınıra göre **yükseltir**. Ölçüp `volume` ile kazanç verip ardından `alimiter` koyunca hedef -16 yerine -14,6 LUFS çıktı.
- Çözüm: `alimiter=limit=0.84:level=0`. Kısa (≤ 3 sn) dosyalarda ebur128 integrated değeri güvenilir değildir; uzun sürümü normalize edip kısayı ondan kesmek daha doğru.
