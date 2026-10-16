# H-090: İlk 7 günlük A1 deneyimi ve yönlendirmeli konuşma görevleri

- **Durum:** Yapılacak
- **Tür:** Uygulama + içerik
- **Faz:** F1 MVP — ürün incelemesi sonrası (2026-10-16)
- **Bağımlılık:** H-088, H-089

## Kapsam (ürün incelemesi §4 P1, §6; kullanıcı onayı 2026-10-16)
- İlk 7 gün için dar bir A1 akışı: her gün kısa tekrar → sahne/okuma → bağımsız küçük görev; günlük plan (H-088) bunu sürer.
- **Konuş sekmesi "yakında" yerine 3 yönlendirmeli sahne** (AI sohbeti değil; H-007 korunur): kafede sipariş (Rosa), yol sorma, yeni komşuyla tanışma (Maya). 3–5 tur; her turda aynı anlam için birkaç doğal kabul edilen cevap; söyleyerek (cihazda tanıma, H-055) ya da dokunarak.
- **Kısa mesaj yazma:** 1–2 cümlelik görevler ("Maya'ya geç kalacağını yaz"). Güvenilir değerlendirme yoksa model cevap + öz değerlendirme; kesin puan yok.
- İçerik Claude taslağı → content-lint → editör onayı (H-028); görseller mevcut bölüm görsellerinden; ücretli üretim gerekirse önce maliyet.
- Başarılar H-089 kanıt basamaklarına "yeni örnekte kendi kullandı" olarak yazılır.

## Kabul kriterleri
- Konuş sekmesinde 3 sahne oynanır; ters anlamlı cevap kabul edilmez (H-087).
- Mikrofon izni olmadan dokunarak tamamlanır.
- Metinler ARAYUZ-METINLERI'ne uyar; testler ve golden'lar güncel.

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında; `git revert`.
