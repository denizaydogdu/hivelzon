# H-068: Arka planda dinleme ve kilit ekranı

- **Durum:** Yapılacak
- **Tür:** Uygulama (kod)
- **Faz:** Kitaplık K3 (`docs/KITAPLIK.md` §9)
- **Bağımlılık:** H-067

## Kapsam
- `just_audio` + `audio_service` (lisans kontrolü önce).
- iOS `UIBackgroundModes: audio`.
- Android medya bildirimi.
- Kilit ekranı denetimleri: oynat/duraklat, 10 sn geri, kitap adı ve kapak.
- Uyku zamanlayıcısı arka planda da çalışır.
- Mikrofon gibi yeni izin istenmez.

## Kabul kriterleri
- Ekran kilitliyken ses sürer; kilit ekranından duraklatılır.
- Testler yeşil.

## Test
`cd mobile && flutter analyze && flutter test` + simülatör/cihaz denemesi

## Geri alma
Kendi dalında; `git revert`.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Bir dinleme hikâyesi olsun; yatakta 'A2 bir hikâye aç' diyebileyim, okumadığım bir kitap sesli okunsun, ekranda renkli kitap gibi görünsün, okunan cümle işaretlensin, dokununca Türkçesi çıksın, durdurabileyim, sesi kapatıp kendim de okuyabileyim; okuduklarım ve yarıda kalanlar takip edilsin; her seviyeden 5, toplam 30 ilgi çekici kitap." Ek istek: bilmediği kelimeleri Defter'e ekleyip sonra çalışabilmeli. Kararlar (önerilenler onaylandı): önce 2 pilot kitap resimli, ElevenLabs önce pilotla, kısa kitap, bağımsız karışık türler. Ayrıntı: `docs/KITAPLIK.md`.
