# H-035: Hikâye haritası, bölüm kapısı, yerel ilerleme

- **Durum:** Yapılacak (H-025 onayından sonra)
- **Tür:** Uygulama (kod)
- **Faz:** 1.3 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-031

## Kapsam
- Sezon haritası; kilitli bölümde kilit nedeni ve spoiler içermeyen ipucu.
- Bölüm kapısı (K-29): kavrama + hedef ifade + 1 etkin görev.
- Yerel ilerleme (Drift/SQLite): `user_story_progress`, kontrol noktası, bayraklar.
- Ana Sayfa'da "Hikâyeye devam".

## Kabul kriterleri
- Kapı kuralı birim testli.
- Uygulama kapatılıp açılınca kalınan yerden devam ediyor.

## Test
```bash
cd mobile && flutter test
```

## Geri alma
Kendi dalında (`h-035-hikaye-haritasi-ilerleme`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
