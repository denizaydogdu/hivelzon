# hiVelzon sistem denetimi — 2026-10-28

## Kapsam

Simülatör açılmadan mobil kod, backend, içerik boru hattı, takip belgeleri,
CI ve yerel servis durumu kontrol edildi.

## Teknik sonuç

| Alan | Sonuç |
|---|---|
| Flutter analiz | Temiz |
| Flutter test | **1483/1483** |
| Backend test | **164/164**; hata/atlama yok |
| İçerik boru hattı pytest | Geçti |
| Bölüm/Konuş lint | 13 bölüm, 4 konu seti, 6 Konuş görevi; **0 hata** |
| Kitap lint | 30 kitap; **0 hata** |
| Dilbilgisi lint | 71 ders; **0 hata** |
| Reel lint | 18 reel; **0 hata, 0 uyarı** |
| Sır taraması | Gerçek anahtar/özel anahtar dosyası bulunmadı; eşleşmeler örnek/test veya yerel geliştirme parolası |
| Yerel servisler | HiVelzon backend ve içerik portları kapalı; HiVelzon Docker konteyneri çalışmıyor |

Backend'in ilk denemesi `./gradlew` olmadığı için çalışmadı; proje Maven
kullanıyor. Maven'in ilk koşusu da Colima soketi verilmediği için Testcontainers
ortamını bulamadı. Rehberdeki doğru komutla sonuç yeşil:

```sh
cd backend
DOCKER_HOST=unix://$HOME/.colima/default/docker.sock \
TESTCONTAINERS_RYUK_DISABLED=true mvn -q test
```

## Bulunan ve giderilen yerel açık

GitHub Actions'ın son koşusu (`40587989108`, commit `536dbe2`) başarısızdı.
Mobil ve backend işleri geçmiş; içerik işinde 363 test geçmiş, 3 TTS testi
runner'da `ffmpeg` bulunmadığı için `FileNotFoundError` vermişti. Workflow'a
pytest öncesi `ffmpeg` kurulumu eklendi.

CI ayrıca pytest ve bölüm lint'ini çalıştırıyor, fakat kitap ve dilbilgisi
kaynaklarını lint etmiyordu. `.github/workflows/ci.yml` içine şu kapılar da
eklendi:

- 30 kitabın `book_lint.py` denetimi;
- 71 dersin `grammar_lint.py` denetimi.

Reel lint medya dosyaları git dışında olduğu için temiz CI kopyasında
çalıştırılmadı; reel kuralları pytest içinde, tam medya denetimi ise yerelde
çalışmaya devam eder.

## Gerçek açık işler — uygulanacak sıra

1. **H-043/H-068 gerçek iPhone:** kalite, arka plan sesi, kilit ekranı ve
   kumandalar.
2. **H-085/H-086 kullanıcı denemesi:** teknik doğrulamalar yeşil; öznel kabul
   bekliyor. Simülatör her çalıştırmadan önce açık izin ister.
3. **Öğretmen/editör incelemesi:** H-028 süreç kararı tamam; bölüm, kitap,
   dilbilgisi ve Konuş içeriklerinin operasyonel incelemesi açık.
4. **Eksik İngilizce sesler:** H-071…H-073 için 25 kitap + A1-K01 düzeltmesi,
   H-080…H-082 için dilbilgisi örnekleri. Çalışan ElevenLabs erişimi veya
   ayrıca onaylanmış ücretli plan gerekir.
5. **H-044 dış hesaplar ve mağaza — en son:** Almanya sunucusu/DNS, Bunny,
   Apple/Google, mağaza yüklemesi, veri sorumlusu bilgileri ve muhasebe.
6. **H-092 kullanıcı pilotu:** aşama A ve B, H-044 tamamlandıktan sonra;
   H-094 insan değerlendirmesi de bu pilotla tamamlanır.

## Sonuç

Şu anda kullanıcı onayı olmadan başlanabilecek yeni ürün kodu işi yoktur.
Kod tabanı ve kaynak içerikler yeşildir. Kalan işler insan/gerçek cihaz,
çalışan TTS erişimi veya ertelenmiş dış hesaplara bağlıdır. Yeni ürün kapsamı
pilot sonucu görülmeden açılmamalıdır.

CI düzeltmesinin GitHub runner doğrulaması için bu değişikliklerin commit ve
push edilmesi gerekir.
