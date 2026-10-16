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

## Notlar (2026-10-16, uygulama)
- **Tek karar:** `mobile/lib/features/hi/domain/daily_plan.dart` → `planToday(CoachInput)` (saf). `dailyPlanProvider` Ana Sayfa'yı, `hiSuggestionProvider` (= plan.primary) Hi panelini besler; `suggestToday` aynı fonksiyona bağlandı.
- **Sıra:** (1) bugün oynanmış yarım bölüm → (2) kısa tekrar: tekrar ≥ 5 (uzun aradan, 7+ gün, sonra ≥ 1, "Tekrar hoş geldin!") ve Hi'nin notu → (3) ana adım: A1–A2'de yarım bölüm → yarım kitap → sıradaki bölüm (7+ gün bekleyen yarım bölüm yarım kitabın arkasına); B1+'da yarım kitap → seviyesindeki kitap → (4) küçük görev (A1–A2: sahne avı → eşik altı tekrar → kitap dinleme → dilbilgisi; B1+: dilbilgisi → eşik altı tekrar → sahne avı) → B1+'da isteğe bağlı hikâye → (5) dinlenme. Bugün ana adım yapıldıysa (bölüm bitti / kitap okundu) küçük görev ana adımın önüne geçer.
- **"Başka bir öneri":** öneriyi bugünlük geçer (`app_meta` `hi.dismissedToday`, yalnız cihazda, eşitlenmez; "Hi'nin kayıtlarını sil" de siler). Ertesi gün sıfırlanır; bu yüzden yarım bölüm tekrar borcunu en çok bir gün erteletebilir.
- **Ana Sayfa:** başlık "Bugünün planı" + sakin adım çipleri; bölüm önerisinde görselli kart (gerekçeyle), öteki önerilerde plan kartı; birincil öneri bölüm değilse "Hikâyen" ikincil (B1+'da "İsteğe bağlı"); "Çalışma araçların": Kelime tekrarı ve Defter tek dokunuşla (Defter Ana Sayfa sekmesinde `/defter`; K-30 değişmedi). Plan hesaplanamazsa hikâye kartı birincil kalır.
- **Golden'lar (bilinçli):** `h060_ana_sayfa`, `h060_ana_sayfa_yeni`, `h060_ana_sayfa_sezon_bitti` güncellendi; yeni `h060_ana_sayfa_b2`.
- **Açık:** adım çiplerinin pilot sınaması (H-092); "Başka bir öneri"nin günlük sıfırlanması yeterli mi (pilot gözlemi).
