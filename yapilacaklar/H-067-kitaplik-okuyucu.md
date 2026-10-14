# H-067: Kitaplık ve okuyucu (mobil)

- **Durum:** Yapılacak
- **Tür:** Uygulama (kod)
- **Faz:** Kitaplık K2 (`docs/KITAPLIK.md` §9)
- **Bağımlılık:** H-066

## Kapsam
- **Kitaplık ekranı:** raflar (Okumaya devam et, Senin seviyen, diğer seviyeler, Okuduklarım), kitap kartı ve ilerleme halkası, "Bana bir kitap oku" (seviye seç → okunmamış kitap).
- **Okuyucu:**
  - renkli, resimli sayfa;
  - sesli ve sessiz mod;
  - okunan cümle vurgusu, kelime vurgusu ayarı;
  - otomatik sayfa çevirme;
  - oynat/duraklat, 10 sn geri, hız 0,75 / 1 / 1,25;
  - uyku zamanlayıcısı;
  - okuma yazı boyutu.
- **Dokun → anlam paneli** (`shared/meaning/`), "Sen de söyle".
- **Defter'e ekle:** dokunarak ya da uzun basarak. Kayıtta kaynak "Kitap: başlık, s. N", örnek cümle ve kitap sesinden kesilmiş telaffuz. Defter'de kitaba göre süzme; Kelime tekrarına (FSRS) girer; kitap sonunda "Bu kitapta kaydettiklerin".
- **İlerleme:** `user_book_progress` (Drift v6 + eşitleme, "bitti kazanır").
- **Hi önerisi:** `continueBook` / `startBook`.
- "Hareketi azalt" desteği. K-32 yasakları geçerli.

## Kabul kriterleri
- Kitaptan eklenen kelime Defter'de kaynağıyla görünür ve tekrara girer; aynı kelime iki kez eklenmez.
- Vurgu kayması ≤ 0,2 sn.
- Yarıda kalan kitap kaldığı cümleden açılır.
- Golden testler, erişilebilirlik testi, 1,3× metin; testler yeşil.

## Test
`cd mobile && flutter analyze && flutter test`

## Geri alma
Kendi dalında (`h-067-kitaplik-okuyucu`); `git revert`.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Bir dinleme hikâyesi olsun; yatakta 'A2 bir hikâye aç' diyebileyim, okumadığım bir kitap sesli okunsun, ekranda renkli kitap gibi görünsün, okunan cümle işaretlensin, dokununca Türkçesi çıksın, durdurabileyim, sesi kapatıp kendim de okuyabileyim; okuduklarım ve yarıda kalanlar takip edilsin; her seviyeden 5, toplam 30 ilgi çekici kitap." Ek istek: bilmediği kelimeleri Defter'e ekleyip sonra çalışabilmeli. Kararlar (önerilenler onaylandı): önce 2 pilot kitap resimli, ElevenLabs önce pilotla, kısa kitap, bağımsız karışık türler. Ayrıntı: `docs/KITAPLIK.md`.
