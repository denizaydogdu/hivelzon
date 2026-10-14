# H-073: Kitap dalgası 3: C1 + C2 (10 kitap)

- **Durum:** Yapılacak
- **Tür:** İçerik üretimi
- **Faz:** Kitaplık K8 (`docs/KITAPLIK.md` §9)
- **Bağımlılık:** H-072

## Kapsam
- Aynı akışla 10 kitap.
- C1/C2 kelime listesi Octanove'dan (ayrı veri seti).

## Kabul kriterleri
- 10 C1–C2 kitabı onaylı ve uygulamada.

## Test
`book-lint` + `flutter test`

## Geri alma
Kitap başına `git revert`.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Bir dinleme hikâyesi olsun; yatakta 'A2 bir hikâye aç' diyebileyim, okumadığım bir kitap sesli okunsun, ekranda renkli kitap gibi görünsün, okunan cümle işaretlensin, dokununca Türkçesi çıksın, durdurabileyim, sesi kapatıp kendim de okuyabileyim; okuduklarım ve yarıda kalanlar takip edilsin; her seviyeden 5, toplam 30 ilgi çekici kitap." Ek istek: bilmediği kelimeleri Defter'e ekleyip sonra çalışabilmeli. Kararlar (önerilenler onaylandı): önce 2 pilot kitap resimli, ElevenLabs önce pilotla, kısa kitap, bağımsız karışık türler. Ayrıntı: `docs/KITAPLIK.md`.
