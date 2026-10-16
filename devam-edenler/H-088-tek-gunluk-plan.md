# H-088: Tek günlük plan: Ana Sayfa ve Hi aynı öneriyi verir

- **Durum:** Devam ediyor (2026-10-16)
- **Tür:** Uygulama (kod)
- **Faz:** F1 MVP — ürün incelemesi sonrası (2026-10-16)
- **Bağımlılık:** H-047, H-060, H-074

## Kapsam (ürün incelemesi §4 P1, kullanıcı onayı 2026-10-16)
- Ana Sayfa'nın birincil kartı ve Hi'nin günlük önerisi **tek bir karar** fonksiyonundan gelir (kural tabanlı, gerekçesi görünür; LLM yok).
- Günlük plan sırası: kısa tekrar (borç varsa) → sahne ya da okuma → küçük görev. Kullanıcı tek bir eylem görür (ürün ilkesi); plan adımları sakin bir ilerlemeyle gösterilir.
- Karar şunları dikkate alır: yarım kalan bölümün yaşı (uzun süre yarım kalan bölüm diğer ihtiyaçları ezmez), tekrar borcu, hata notu, son önerinin reddedilmesi, uzun süre ilerlememe.
- **Seviyeye göre birincil öneri:** seviye testinden B1+ çıkan kullanıcıya birincil öneri seviyesindeki kitap + kısa görev; hikâye isteğe bağlı kalır. A1–A2 kullanıcıda hikâye birincil. Yeni bölüm üretilmez (K-25 korunur).
- Defter ve Kelime tekrarı Ana Sayfa'dan tek dokunuşla bulunur (Profil'e gömülü kalmaz). Sekme düzeni (K-30) değişmez; o karar pilotta (H-092) sınanır.
- Metinler `docs/ARAYUZ-METINLERI.md`'ye uyar; K-32 yasakları geçerli.

## Kabul kriterleri
- Aynı girdide Ana Sayfa kartı ile Hi önerisi aynı eylemi gösterir (test).
- B2 yerleştirme sonucunda birincil öneri A1 bölümü değildir (test).
- Uzun süre yarım kalan bölüm, tekrar borcunu sonsuza dek bastırmaz (test).
- Golden'lar bilinçli güncellenir; erişilebilirlik testleri geçer.

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında; `git revert`.
