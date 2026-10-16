# Konuşma alıştırması ("Söyle"): tasarım ve fazlar

**Tarih:** 2026-10-13 · **Durum:** Kararlar verildi (kullanıcı, soru-cevap) · **İş:** H-055 (S1)

## Neden?
Türk öğrencinin en sık sorunu "anlıyorum ama konuşamıyorum". Dinlediğini söylemek (çıktı alıştırması) A1'de öğrenmeyi güçlendirir. Kullanıcı önerisi: "Tekrar yerlerinde kullanıcı mikrofonla konuşabilmeli, sistem doğru söyleyip söylemediğini kontrol etmeli."

## Temel ayrım
| Soru | Yapılabilir mi? | Nasıl |
|---|---|---|
| **Beklenen ifadeyi söyledi mi?** | Evet, güvenilir | Telefonun **cihazda** konuşma tanıması → yazı → beklenen ifadeyle karşılaştırma (normalleştirme: büyük/küçük harf, noktalama, *I'm = I am*, *don't = do not* …; kelime düzeyinde fark). Seçenekler arasında hangisinin söylendiğini bulmak (karar anı) daha da sağlam. |
| **Telaffuzu ne kadar doğru?** | Şimdilik hayır | Tanıma motoru yanlış telaffuzu da doğru kelimeye "düzeltir"; ses düzeyinde puan ayrı ve zor bir iş. H-015 ilkesi: güvenilir değilse puan gösterilmez. |

## Kurallar (bağlayıcı)
- **İsteğe bağlı.** Mikrofon izni ilk kullanımda istenir; izin yoksa ya da cihaz desteklemiyorsa her şey dokunarak çalışır.
- **Ses cihazdan çıkmaz ve kaydedilmez.** Yalnızca cihazda tanıma (iOS `requiresOnDeviceRecognition`, Android cihazda tanıma). Cihaz desteklemiyorsa özellik **görünmez** (bulut tanıma kullanılmaz; sunucu seçeneği S2'de, Türkiye'deki kendi sunucumuzda).
- **Puan yok, utandırma yok.** "Söyledin!" ya da "Bir daha dene"; eksik kelime gösterilir ("*hear* kelimesini duyamadım"); anlamı değiştiren fazla kelime (olumsuzluk, kip, sayı, başa eklenen do/does/did) "Söyledin!" sayılmaz, "Neredeyse!" olur (H-087; hitap, "yes", "please" gibi zararsız ekler sorun değil); hata türü eşleşirse Hi'nin Türkçe notu (H-048 hata kataloğu). 2 denemeden sonra metin gösterilir, devam edilir; "Geç" hep var.
- **Konuşma hikâyeyi kilitlemez** (K-28); kapının "hedef ifade" adımı dokunarak da geçilir.
- **Yaş:** cihazda kaldığı için bütün yaşlar (13+). Açık bilgilendirme metni. Serbest yapay zekâ sohbeti 18+ kuralı ayrıdır ve korunur. Hukuk teyidi listesine eklenir.
- Öğrenme olayına yalnızca sonuç yazılır (doğru/yanlış, eksik kelime, hata türü); ses ve tam transkript saklanmaz.

## Konuş sekmesi: yönlendirmeli sahneler (H-090)
MVP'de Konuş sekmesi "yakında" yerine 3 prova sahnesi (Maya'yla tanışma, yol sorma, Rosa'nın kafesinde sipariş) ve kısa mesaj görevleri sunar. Yapay zekâ yoktur: karakter satırları ve kabul edilen cevaplar önceden yazılmış, editör onayı bekleyen içeriktir (`icerik/_evren/konusma/`). Kurallar bu belgedekilerle aynıdır: cihazda tanıma, izin ilk kullanımda, ses ve yazı saklanmaz (sonuç `place = talk`), puan yok, 2 deneme + "Geç", dokunarak (seç ya da kelimelerle kur) baştan sona oynanır. Fark: her turda **birkaç doğal cevap** kabul edilir; söyleneni kabul için birinin **tam** duyulması gerekir; yakın seçenek duyulursa kibar tepkisi gösterilir.

## Fazlar
| Faz | Ne | Ne zaman |
|---|---|---|
| **S1: "Söyle" alıştırmaları** | Kelime tekrarında **"Dinle ve söyle"** görevi (H-089: taklittir, FSRS'e işlenmez; hatırlama için sesi duymadan **"Söyle"**, `docs/KELIME-TEKRARI.md`) · anlam panelinde **"Sen de söyle"** · karar anında isteğe bağlı **"Söyleyerek seç"** · bölüm sonunda **hedef ifadeleri söyleme** (kapı adımı söyleyerek de geçilir) | MVP; H-055, H-048'den hemen sonra |
| **S2: Hi ile prova ve karakterlerle konuşma** | Serbest konuşma, "önce Hi'ye fısılda"; cihazda tanıma olmayan telefonlar için kendi sunucumuzda (Türkiye) Whisper | v1, Hi-C ile (`docs/HI-ASISTAN-VE-KOC.md`) |
| **S3: Telaffuz geri bildirimi** | Türklerin zorlandığı seslere odaklı (th, w/v, uzun/kısa ünlü); yalnızca doğrulanırsa, sayısal puan yalnızca güvenilirse | Sonra; H-015 |
