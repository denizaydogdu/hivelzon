# H-036: Defter, ipucu panosu, FSRS tekrarı

- **Durum:** Yapılacak (sırada; H-025 onaylandı 2026-10-11, sıra `docs/UYGULAMA-PLANI.md`'de)
- **Tür:** Uygulama (kod)
- **Faz:** 1.4 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-035

## Kapsam
- Defter: bölümlerde toplanan ifadeler.
- İpucu panosu ve açık sorular (en fazla 3).
- FSRS tekrarı (hedef hatırlama 0,90), Bildim / Bilmedim.
- Ana Sayfa'da "Hızlı pratik" (5/10/15 dk hedef).

## Kabul kriterleri
- FSRS birim testleri yeşil.
- İstemci–sunucu eşdeğerlik testi için örnek veri hazır.

## Test
```bash
cd mobile && flutter test
```

## Geri alma
Kendi dalında (`h-036-defter-ipucu-fsrs`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
2026-10-12 (H-035 ve H-046'dan sonra güncel notlar):
- **Depolama Drift'te olmalı** (H-035: `mobile/lib/shared/storage/app_database.dart`). Defter, ipucu panosu ve FSRS kartları için yeni tablolar eklenir; şema sürümü artırılır, taşıma testi yazılır. Kod üretimi: `dart run build_runner build --force-jit`.
- **Defterin girişi hazır:** H-046 anlam panelindeki "Deftere ekle" (`lib/shared/meaning/notebook_repository.dart`) şimdilik `shared_preferences`'ta tutuluyor; bu iş onu Drift'e taşır (bir kerelik, H-035'teki taşıma deseniyle).
- **Öğrenme olayları:** H-046'nın `LearningEventLog` kayıtları (bakılan kelime/satır) şimdilik `shared_preferences`'ta; Drift'e alınır ve ileride H-038 eşitlemesine (`client_event_id`) hazır tutulur. Bakmak puan düşürmez (K-32).
- İpucu panosu bölüm `content.json` alanlarından (`cluesUnlocked`, `openQuestion`, `answers`) beslenir; kapı ilerlemesi H-035'teki `gate_progress`'ten okunur.
2026-10-12: Öğrenme olaylarına sürümlü hata türü alanı eklenmesi düşünülsün (EnglishPractice `errors.py` deseni, MIT). Bkz. `docs/ENGLISHPRACTICE-INCELEME.md`.

## Kullanıcı kararları (2026-10-12, soru-cevap; sosyal medyadaki görsel kelime şablonları üzerine)
- **Kelime/kalıp kartı = görsel + kelime + örnek cümle + ses + Türkçesi.** Tek kelime değil, cümle içinde.
- **Tekrar, hatırlama sorularıyla yapılır** (yalnızca Bildim/Bilmedim değil); seviyeye göre: resimden seç → dinle-seç → yaz/söyle. Sonuç FSRS notuna çevrilir.
- **"Bilmiyorum" düğmesi** utandırmaz; bilinemeyen kart aynı oturumun sonunda ve ertesi gün yeniden sorulur (FSRS yeniden öğrenme adımları).
- Günlük yeni kart sınırı günlük hedefe (5/10/15 dk) bağlı.
- Görsel kaynağı: önce mevcut sahne görsellerinden kırpma; gerekirse tek ızgara görselden kesme (maliyet önce onaylanır). Görselde yazı yok; kelimeyi uygulama çizer.
- Ses: mümkünse bölümdeki karakter sesinden kesilir (kelime zaman damgaları); yoksa TTS (yerel, iç kullanım).
