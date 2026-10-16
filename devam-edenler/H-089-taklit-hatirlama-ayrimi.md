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
