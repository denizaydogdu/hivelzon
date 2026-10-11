# H-028: İçerik onayı, roller ve kapasite

- **Durum:** Bitti — karar verildi (2026-10-11)
- **Tür:** Karar
- **Öncelik:** Yüksek (pilot içerikten önce)
- **Bağımlılık:** H-004

## Soru
- İngilizce metni, Türkçe çeviriyi ve CEFR uygunluğunu kim onaylayacak? Pedagojik bir onaylayan olacak mı?
- İlk 3 ayın içerik kapasitesi ne? Kaç editör çalışacak, haftada kaç saat?
- Kullanıcıların içerik hata bildirimlerini kim, hangi sürede inceleyecek?
- Kritik kalite kontrolü, içeriği üretenden başka biri tarafından yapılmalı. Bu projede bu nasıl sağlanacak?

## Plan önerisi
- Üretimi Claude yapar, onayı kullanıcı verir.
- Çeviri ve pedagojik kontrol için dönemsel olarak bir İngilizce öğretmeni ya da editör desteği alınır. Örnek: her ünitenin sonunda toplu inceleme.
- Hata bildirimleri haftada bir incelenir.
- Telif ya da güvenlik bildirimlerinde içerik aynı gün `WITHDRAWN` durumuna alınır.

## Kaynak
`docs/ICERIK-MIMARISI.md` §9.2, §14 (K-18) · `docs/ICERIK-STRATEJISI.md` §4.1, §24

## Notlar
2026-10-11: Web araştırması (5 kol) ve kullanıcının içerik stratejisi belgesinden açıldı. Ayrıntı: `docs/ICERIK-MIMARISI.md`.

## Karar (2026-10-11)
Kullanıcı soru-cevapla karar verdi: **Claude üretir, kullanıcı onaylar.** Her ünite (bölüm grubu) sonunda bir İngilizce öğretmeni ya da editör toplu kontrol yapar.

**Kalan:** Öğretmen ya da editörün kim olacağı ve ücreti. Kontrolün sıklığı: Sezon 1 için en az B4, B8 ve B12'den sonra.
