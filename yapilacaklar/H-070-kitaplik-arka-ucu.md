# H-070: Kitaplık arka ucu

- **Durum:** Yapılacak
- **Tür:** Uygulama (backend)
- **Faz:** Kitaplık K5 (`docs/KITAPLIK.md` §9)
- **Bağımlılık:** H-066

## Kapsam
- İçerik türü `BOOK`.
- Seviyeye C2 eklenir (veritabanı kısıtları).
- Kimlik biçimi `<SEVİYE>-K<2 hane>`.
- İçe aktarma dalı (`book.json`).
- `/admin` onayı (K-05 durum makinesi aynen).
- Katalog uç noktası (ETag).

## Kabul kriterleri
- `mvn -B verify` yeşil.
- Örnek kitap içe aktarılır ve onaylanır.

## Test
`cd backend && mvn -B verify`

## Geri alma
Flyway geçişi ileri yönlü; kendi dalında, `git revert` + düzeltme geçişi.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Bir dinleme hikâyesi olsun; yatakta 'A2 bir hikâye aç' diyebileyim, okumadığım bir kitap sesli okunsun, ekranda renkli kitap gibi görünsün, okunan cümle işaretlensin, dokununca Türkçesi çıksın, durdurabileyim, sesi kapatıp kendim de okuyabileyim; okuduklarım ve yarıda kalanlar takip edilsin; her seviyeden 5, toplam 30 ilgi çekici kitap." Ek istek: bilmediği kelimeleri Defter'e ekleyip sonra çalışabilmeli. Kararlar (önerilenler onaylandı): önce 2 pilot kitap resimli, ElevenLabs önce pilotla, kısa kitap, bağımsız karışık türler. Ayrıntı: `docs/KITAPLIK.md`.
