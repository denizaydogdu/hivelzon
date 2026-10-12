# H-036: Defter, ipucu panosu, FSRS tekrarı

- **Durum:** Bitti
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

### 2026-10-12: Uygulama ve doğrulama özeti
- **FSRS:** py-fsrs 6.3.2'nin (MIT) saf Dart portu: `mobile/lib/shared/fsrs/fsrs.dart`, FSRS-6, 21 parametre, hedef hatırlama 0,90, bulanıklaştırma (fuzz) kapalı. pub.dev `fsrs` 2.0.1 kullanılmadı, çünkü referanstan geride: Easy başlangıç zorluğunu kırpıyor, Hard'da kısa vadeli alt sınırı uygulamıyor, varsayılanları eski. Python'la birebir sonuç için tam gün aşağı yuvarlanıyor, aralık yuvarlaması yarımda çifte yapılıyor.
- **Eşdeğerlik verisi:** `mobile/test/fixtures/fsrs_vectors.json`, py-fsrs ile üretildi: 17 vaka, 159 inceleme. Üreteç `tools/fsrs-vectors/generate_vectors.py`. Dart portu 159 incelemenin hepsinde aynı S, D, durum, adım ve vadeyi veriyor (göreli fark ≤ 1e-9). Java portu da aynı dosyayla test edilecek.
- **Yeniden öğrenme:** Öğrenme ve yeniden öğrenme adımı 10 dk, tek adım. "Bilmiyorum" ya da yanlış cevap Again sayılır. Kart oturumun sonuna en çok 2 kez yeniden eklenir; orada doğru bilinirse ertesi gün gelir (vektör: 09:03 → ertesi gün 09:03).
- **Günlük yeni kart:** Günlük hedefe bağlı (5/10/15 dk → 5/10/15 kart). Profil'de seçilir, varsayılan 10.
- **Şema 1 → 2 (Drift):** `notebook_items`, `review_cards`, `review_logs`, `learning_events` (`client_event_id`, `error_type` ve `error_taxonomy_version` isteğe bağlı), `clues`, `story_links`. Açık sorular `story_links`'ten türetilir. `shared_preferences` defteri ve olayları bir kez taşınır (işaret: `migration.sharedPrefs.notebook.v1`); eski anahtarlar silinmez.
- **Testler:** `flutter analyze` temiz. `flutter test` 180/180 (önce 129; +51). pytest çalıştırılmadı, çünkü boru hattına dokunulmadı.
- **Simülatör (hiVelzon iPhone 17, geliştirme sunucusu açık):**
  - Cihazdaki gerçek v1 veritabanı (B1 bitmiş, H-035'ten) açılışta v2'ye taşındı. B1 geriye dönük aktarıldı: 4 kart (Can you hear me? · Yes, I can. · Again, please. · Where is…?), 2 ipucu (C1, C2), açık soru "Old Station nerede?". "Listen." B1'de geçmediği ve Türkçesi olmadığı için atlandı.
  - Kartlar sahne görseli, karakter sesi ve örnek cümleyle geliyor (ör. "Yes, I can." → k1-ok 0,46–1,18 sn, "Yes, I can hear you.").
  - Oturum 1 (resimden seç): 4 kart, 5 cevap. "Bilmiyorum" denen kart 5/5'te yeniden geldi ve ertesi güne planlandı. Özet: 1 kart yarın, 3 kart daha sonra.
  - Uygulama yeniden açıldı; veriler yerinde.
  - Oturum 2: "dinle-seç" görevi. Kartların vadesi elle geçmişe çekildi (2 gün sonrası taklit edildi). Ses segmentten çaldı: "k2-ok 0,46–1,812 sn → konum 1732 ms", "s02 11,027–12,587 sn → konum 12501 ms". Yanlış cevap verilen kart unutma sayıldı (lapse 1) ve yeniden öğrenmeye düştü. Doğru bilinenler 11 gün sonraya planlandı.
  - Oturum 3 (gerçek bekleme): yeniden öğrenmedeki kart 10 dk sonra kendiliğinden vadesine geldi ("Tekrar (1)"). Resimden seç görevinde doğru bilindi.
  - "Bilmiyorum" artık gerçek bir düğme (kullanıcı geri bildirimi): kenarlıklı OutlinedButton, deniz mavisi, w700/16 px, yükseklik ≥ 48 px, ? simgesi. Seçeneklerden ikincil kalıyor.
  - Defter her açılışta sayıları yeniliyor; önceden vadesi gelen kart ekranda "bitti" görünüyordu, düzeltildi.
  - Ekran görüntüleri: oturumun scratchpad klasöründe `h036-*.png`.
- **Açık:** "Listen." gibi bölümde geçmeyen hedef ifadeler kart olmuyor. Bakılan kelimeler için seviye üstü sözlük (`content.json` → `glossary`) pakete eklenmeli; şimdilik dilbilgisi sözcükleri listesiyle süzülüyor.
2026-10-12 (ana oturum): flutter test 180/180, analyze temiz yeniden doğrulandı. Kullanıcı kararları (soru-cevap):
- "Listen." için anlam eklenir (Dinle.), ses sonra (yerel TTS ya da sonraki seslendirme) → H-052.
- Karta dönüşen bakılan kelimeler yalnızca bölüm sözlüğündeki seviye kelimeleri; sözlük listesi pakete eklenir (kredisiz yeniden paketleme) → H-052.
- Tekrar ayarları başlangıç değeri olarak onaylandı: oturumda ≤ 20 kart, yanlış kart oturumda ≤ 2 kez geri gelir, seçmeli 15 sn üstü Hard, 4 sn altı (olgun kartta) Easy; süre gösterilmez.
- Commit onayı. Kart görselleri için ifadeye özel kırpma H-051'de.
