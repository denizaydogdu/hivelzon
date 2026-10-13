# H-038: Mobil ↔ backend bağlantısı ve misafir modu

- **Durum:** Yapılacak (sırada; H-025 onaylandı 2026-10-11, sıra `docs/UYGULAMA-PLANI.md`'de)
- **Tür:** Uygulama (kod)
- **Faz:** 1.6 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-035, H-037

## Kapsam
- Kayıt ve giriş ekranları.
- Misafir (prolog + B1) verisinin hesaba taşınması.
- İlerleme ve olay eşitleme; idempotent `client_event_id`.

## Kabul kriterleri
- Misafir → kayıt akışı veri kaybetmeden çalışıyor.
- Aynı olay iki kez gönderilince tek kayıt oluşuyor (test).

## Test
```bash
cd mobile && flutter test
cd backend && mvn verify
```

## Geri alma
Kendi dalında (`h-038-mobil-backend-misafir`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
2026-10-12: Mobil taraftaki yerel veri Drift'te (H-035; H-036 sonrası defter ve FSRS de). Misafirden hesaba taşıma bu tablolardan yapılır. Öğrenme olayları (H-046) `client_event_id` ile idempotent gönderilir. Misafir kapsamı: prolog + B1 (H-009).
2026-10-13: Kapsam değişti (H-009 güncellendi): misafir sınırı yok; hesap isteğe bağlı. Bu işte: isteğe bağlı "Hesap aç / giriş yap" (e-posta kodu), cihazdaki verinin hesaba ilk eşitlenmesi, sonra çift yönlü eşitleme; hesap yoksa hiçbir veri sunucuya gitmez. Sakin uyarı metni ("İlerlemen yalnızca bu telefonda…").
2026-10-13 (H-037'den): Kullanıcı kararı: "Hi'nin kayıtlarını sil" bütün cihazlarda geçerli → sunucu silme işareti (tombstone) eşitlemeyle diğer cihazlara gider. Mobil Drift şema 5: `user_story_flags` ve `season_state`'e `updatedAt`, `review_logs` ve `speech_attempts`'e UUID; kimlikler UUIDv5 kuralıyla (backend README).
