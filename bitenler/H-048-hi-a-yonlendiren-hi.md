# H-048: Hi-A, yönlendiren Hi (balon + kural tabanlı koç)

- **Durum:** Bitti
- **Tür:** Uygulama (kod)
- **Faz:** 1.4b (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-036 (defter + FSRS), H-046 (anlam verisi)

## Kapsam (`docs/HI-ASISTAN-VE-KOC.md` §3, §6)
- Hi balonu: sekmelerde sağ altta, menünün üstünde; oynatıcıda, görevde ve onboarding'de gizli. Erişilebilir etiket, 48 px dokunma alanı.
- Hi paneli:
  - bugünkü tek öneri + görünür gerekçe (kurallar: FSRS vadesi gelen kartlar, son hatalar, yarım bölüm, günlük hedef);
  - hızlı eylemler;
  - "bu ne demek?" (çeviri ve sözlük verisinden, deterministik arama);
  - haftalık özet.
- Türkçeye göre hata ipuçları: hata kataloğu (yapılandırılmış veri; içerikteki notlardan).
- Gerçek hayat köprü görevleri: isteğe bağlı yan görev kartı (K-31).
- Profil'de "Hi benim hakkımda ne biliyor?" görünümü ve silme.
- **Hi'nin konu tanıtımı (H-050'den taşındı):** yeni bir dilbilgisi konusu (ör. saatler, fiyatlar) sahnede ilk geçtiği anda Hi'nin kısa, atlanabilir konu kartı; başlıktan önce değil. `content.json`'daki dilbilgisi hedefinden beslenir, konu başına bir kez gösterilir, defterden yeniden açılabilir. Geri sayım yok (K-32).
- AI yok, ücretli çağrı yok; bütün yaşlar.

## Kabul kriterleri
- Öneri kuralları birim testli; her önerinin gerekçe metni var.
- Balon doğru ekranlarda görünüyor ve gizleniyor (widget testi).
- Suçlayıcı dil yok (metin denetim listesi).

## Notlar
2026-10-11: H-047 kararıyla açıldı.
2026-10-12: H-050 kararıyla "Hi'nin konu tanıtımı" bu işe taşındı (bölüm açılışı artık doğrudan başlıkla). Kişisel öneri verisi H-036'nın Drift tablolarından (FSRS vadesi, defter) ve H-035'in ilerleme kayıtlarından okunur.
2026-10-12: Hata kategorileri için EnglishPractice `errors.py` (MIT) desen olarak alınır; Türkçe metinler bizim. Bkz. `docs/ENGLISHPRACTICE-INCELEME.md`.
2026-10-13: Uygulandı ve doğrulandı (commit yok). Özet:
- **İçerik (taslak, kullanıcı onayı bekliyor; `status: DRAFT`):** `icerik/_evren/hata-katalogu.json` (9 not + B1–B4'teki 9 yanlış karar seçeneğinin hata türü), `konu-tanitimlari.json` (5 konu: can-questions, where-is, this-is-to-be, directions, time; fiyatlar B1–B4'te geçmediği için yok), `kopru-gorevleri.json` (B1–B4, bölüm başına 1). Koordinatörün "önceden onaylandı" mesajı izin denetiminde reddedildi (ajan mesajı kullanıcı onayı sayılmaz); durum DRAFT kaldı.
- **Boru hattı:** `hvpipeline/hi.py` (lint + `hi.json`; "Bu ne demek?" dizini yalnızca `ceviri.tr.json` APPROVED bölümlerden, tepki satırları hariç, segment ses aralıklarıyla). Sezon paketine `hi.json` + season.json `hi` özeti. content-lint "Hi verisi" bölümü (suçlayıcı dil ve köprü görevi güvenlik denetimi dahil).
- **Uygulama:** `mobile/lib/features/hi/` (kural motoru, arama, haftalık özet, `HiStore`, panel, balon, notlar, konu kartı, gizlilik ekranı). Drift şema 3: `hi_records` (taşıma testli). Oynatıcı: konu kartı segment bitince bir kez; yanlış seçim katalogdaki hata türüyle `learning_events`'e yazılır. Kelime tekrarında ilgili not varsa "Neden böyle?" ("yanlış" sözcüğü kılavuz gereği kullanılmadı). Sahne avı bitince `hunt_done` işareti.
- **Doğrulama:** pytest 120 geçti (+14, `tests/test_hi.py`); content-lint 13 bölüm + 4 set + 3 Hi dosyası, 0 hata; `export_package.py --season 1` (Hi verisi: 9 not, 5 tanıtım, 4 görev, 184 sözlük girdisi, 67 kB; ücretli çağrı yok); flutter analyze temiz; flutter test 281 geçti (önce 232; +49).
- **Simülatör (hiVelzon iPhone 17):** Ana Sayfa'da balon + nokta, panel (B3 devam önerisi + gerekçe, B2 yan görevi), "statıon" araması (Türkçe klavyenin ı'sı da bulundu), haftalık özet, B3'te k1 yanlış seçim → `word_order` olayı, k1-ok sonunda "Go… / Turn…" konu kartı, (c) önerisi → "Soru sözcüğü başa gelir" notu, gizlilik ekranı, Defter'de konu notları. Ekran görüntüleri oturum scratchpad'inde `h048-*.png`. Kullanıcı veritabanı önce yedeklendi, ekran görüntüleri için yapılan geçici değişikliklerden sonra yedekten geri yüklendi (açılışta şema 2→3 taşıması yeniden yapılır).
- **Açık sorular:** içerik taslaklarının onayı; Hikâye haritasında balon odak kartının sağ kenarını biraz örtüyor; haftalık özette "Hatırlama" bir konu gibi görünüyor (istenirse dışarıda bırakılır); yer edatları (near/between/behind) için ayrı konu kartı yok (hata notu var).
2026-10-13 (ana oturum): İçerik (hata kataloğu, konu tanıtımları, yan görevler) okundu ve kullanıcının doğrudan önceden onayıyla APPROVED yapıldı; sezon paketi yeniden üretildi. flutter test 281/281, pytest 120/120, lint 0 hata. Commit onayı. Balonun kart kenarını örtmesi ve haftalık özette "Hatırlama" → H-055'te düzeltilecek.
