# H-089: Taklit ile hatırlamanın ayrılması ve öğrenme kanıtı basamakları

- **Durum:** Devam ediyor (2026-10-16)
- **Tür:** Uygulama (kod)
- **Faz:** F1 MVP — ürün incelemesi sonrası (2026-10-16)
- **Bağımlılık:** H-036, H-055, H-087

## Kapsam (ürün incelemesi §4 P1, kullanıcı onayı 2026-10-16)
- Kelime tekrarında "dinle ve söyle" gibi **taklit** görevleri ve seçenekten tanıma, FSRS hatırlama değerlendirmesiyle aynı ağırlıkta karta yazılmaz. Hatırlama yalnız yardımsız geri çağırmadan (Türkçe anlamdan İngilizce üretme, ipucusuz yazma/söyleme) gelir; taklit ve tanıma "pratik" olarak kaydedilir.
- Her ifade için kanıt basamağı tutulur (yalnız cihazda, hesap varsa eşitlenir): **Gördü → Yardımla yaptı → Yeni örnekte kendi kullandı → Birkaç gün sonra hatırladı.**
- Profil ve haftalık özet, sayı yığını ve sahte yüzdeler yerine kanıta dayalı küçük kazanımlar gösterir ("Yol sorabiliyorsun; saat ifadelerini yeniden çalışalım"). Dilbilgisi/kitap ilerleme yüzdeleri "içerik ilerlemesi" olarak kalır, "öğrendi" diye yorumlanmaz.
- Hızdan otomatik Hard/Easy kuralı gözden geçirilir (erişilebilirlik); gerekirse yumuşatılır.
- Veri minimizasyonu: içerik metni, ses ve transkript saklanmaz; yalnız olay türü ve sonuç.

## Kabul kriterleri
- Taklit görevinin başarısı FSRS'te "Good/Easy" hatırlama sayılmaz (test).
- Kanıt basamağı geçişleri test edilir; Profil'de en az bir kanıta dayalı kazanım cümlesi görünür.
- Şema değişikliği varsa Drift geçişi + backend eşitleme geriye uyumlu.

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında; `git revert`.

## Notlar (2026-10-16, uygulama)
- Kurallar ve gerekçe: `docs/KELIME-TEKRARI.md`. Pratik (seç, dinle-seç, diz, dinle ve söyle, sahne avı) FSRS'e yazılmaz; başarılıysa aynı oturumun sonunda yardımsız hatırlama sorusu gelir. Uzun vade kartı önce yardımsız hatırlanır. Yeni görev: `speak_recall` (Türkçesinden, sesi duymadan söyle).
- "Söyle" hatırlamasında anlamı değiştiren ek (H-087 `changedWords`) → Again; yalnız eksik kelime → Hard. "Yavaş = Hard" kuralı kaldırıldı (erişilebilirlik); "hızlı = Easy" yalnız olgun kartta, yazma/söylemede.
- Kanıt basamağı: `expression_evidence` (Drift şema 10, backend V13, eşitleme sırası 160); eski cevaplardan doldurulur. Profil'de "Neler yapabiliyorsun" + "İçerik ilerlemesi" başlığı.
- Sonra: Hi/Ana Sayfa haftalık özetine kanıt cümlesi; hikâye içi söyleme yerlerinin "yardımla yaptın"a bağlanması; kitap anlaması (H-091) kitap düzeyinde olduğundan ifade basamağına bağlanmadı.
