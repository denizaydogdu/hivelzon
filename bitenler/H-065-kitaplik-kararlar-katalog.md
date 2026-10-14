# H-065: Kitaplık kararları ve 30 kitaplık katalog

- **Durum:** Bitti (2026-10-14; katalog ve yerleşim kullanıcı onaylı)
- **Tür:** Karar ve içerik planı
- **Faz:** Kitaplık K0 (`docs/KITAPLIK.md` §9)
- **Bağımlılık:** —

## Kapsam
- `docs/KITAPLIK.md`'nin kesinleşmesi.
- 30 kitabın kataloğu: her seviyede 5 kitap, 5 ayrı tür. Her kitap için başlık, tür, tek cümlelik kanca, ana karakter ve istek/engel, bölüm sayısı, Türkçe tanıtım.
- Yerleşim kararı: Hikâye sekmesinde "Macera · Kitaplık" (kullanıcı onaylı).
- Okuyucu tel çerçevesi: kodla çizilir, kredisiz.

## Kabul kriterleri
- Kullanıcı kataloğu ve yerleşimi onaylar.
- Katalog `kitaplar/KATALOG.md`'de.

## Test
Belge işi; test yok. Tutarlılık denetimi: durum ve klasör uyumu, tablo sütunları.

## Geri alma
Belge ve katalog `git revert` ile geri alınır.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Bir dinleme hikâyesi olsun; yatakta 'A2 bir hikâye aç' diyebileyim, okumadığım bir kitap sesli okunsun, ekranda renkli kitap gibi görünsün, okunan cümle işaretlensin, dokununca Türkçesi çıksın, durdurabileyim, sesi kapatıp kendim de okuyabileyim; okuduklarım ve yarıda kalanlar takip edilsin; her seviyeden 5, toplam 30 ilgi çekici kitap." Ek istek: bilmediği kelimeleri Defter'e ekleyip sonra çalışabilmeli. Kararlar (önerilenler onaylandı): önce 2 pilot kitap resimli, ElevenLabs önce pilotla, kısa kitap, bağımsız karışık türler. Ayrıntı: `docs/KITAPLIK.md`.
2026-10-14: Kullanıcı 30 kitaplık kataloğu (`kitaplar/KATALOG.md`) onayladı. Pilot kitaplar: **A1-K01 The Blue Door** ve **A2-K03 The Parrot Who Told Everything**. Yerleşim: Hikâye sekmesinde "Macera · Kitaplık". Okuyucu tel çerçevesi H-067'nin ilk adımı olarak yapılacak. İş kapandı.
