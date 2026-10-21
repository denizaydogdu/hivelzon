# H-051: Hikâye mekânlarına bağlı konu setleri ve "Sahne avı"

- **Durum:** Bitti
- **Tür:** Uygulama + içerik
- **Faz:** 1.4a (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-036

## Kullanıcı kararı (2026-10-12)
Sosyal medyadaki görsel kelime ızgaraları ("Bedroom Items", "Bathroom Sentences" vb.) örnek gösterildi. Karar: **genel konu setleri değil, hikâyenin mekânlarına bağlı setler + sahne avı.**

## Kapsam
- **Konu setleri:** "Alex'in odası", "Maya'nın dükkânı", "Liman", "Kafe" (B9 ile), … Her set, ilgili bölüm bitince açılır; ızgara görünümünde resim + kelime (+ cümle). Kartlar H-036 destesine eklenir.
- **Sahne avı:** Bölüm sahne görselinde "Find the radio!" → kullanıcı nesneye dokunur (işaretli bölgeler `hotspots` veri olarak). Mevcut görseller kullanılır; ek kredi yok.
- **İçerik verisi:** set başına kelime listesi (CEFR-J seviyesinde), örnek cümle, Türkçe karşılık, görsel kırpma koordinatları, ses kaynağı; content-lint denetimi.
- Görselde yazı yok; şablonlar kopyalanmaz, yalnızca fikir alınır.
- İleride (H-017 sosyal medya fazı) aynı setlerden onaylı paylaşım görselleri üretilebilir.

## Kabul kriterleri
- En az 2 set (Alex'in odası, Maya'nın dükkânı) B1–B2 görsellerinden çalışıyor.
- Sahne avı simülatörde oynanıyor; dokunma bölgeleri doğru.
- Testler yeşil.

## Notlar
2026-10-12: Kullanıcı kararıyla açıldı.

2026-10-13: Uygulandı ve doğrulandı (commit edildi; kullanıcı onayladı).
- **İçerik:** 4 set, `icerik/_evren/setler/` (şema `tools/content-pipeline/schema/topic-set.schema.json`, belge `docs/BOLUM-PAKETI.md` §7): Alex'in odası (B1 `T1-oda`, 10 nesne), Maya'nın dükkânı (B2 `B2-02`, 8), Liman (B3 `B3-05`, 8), Masadaki iki not (B4 `B4-08`, 9). Türkçe anlamlar ve örnek cümleler Claude taslağı: durum `DRAFT`, editör onayı bekliyor. Ses yalnızca kayıttan: 7 kelime (radio, clock, sea, map, fish, note, radio) kelime zamanlarıyla kesildi; diğerlerinde ses düğmesi yok. Ücretli üretim yok.
- **Boru hattı:** `hvpipeline/sets.py` (lint + dışa aktarma), `media.crop_webp/scene_webp/cut_audio`; sezon paketinde `sets/` (512 px öğe WebP, 1080 px sahne WebP, m4a) ve `season.json → topicSets`. content-lint setleri de denetler.
- **Uygulama:** Defter → "Konu setleri" sekmesi; set ızgarası, kart, "Hepsini defterime ekle"; Sahne avı (dokunma, 2 kaçırmada ipucu, "Bilmiyorum", özet, FSRS: Good/Again, `task_type = scene_hunt`); ekran okuyucuda Türkçe bölge etiketleri ve seçenek listesi; bölüm sonunda "Yeni konu seti açıldı: …". H-036 kartları: açık setteki aynı kelimenin kırpılmış görselini alır.
- **Doğrulama:** pytest 106 geçti (yeni `test_sets.py` 29); content-lint 13 bölüm + 4 set, 0 hata; `export_package.py --season 1` (4 set, ~2,1 MB); flutter analyze temiz; flutter test 229 geçti (önce 205; yeni 24). Simülatör (hiVelzon iPhone 17): Konu setleri listesi (2 açık, 2 kilitli), ızgara, kart sesi (radio kelimesi 1,08–1,62 sn ve cümle), sahne avı (2 kaçırma → ipucu, doğru dokunuş, Bilmiyorum, özet, `review_logs` scene_hunt kaydı), bölüm sonu satırı (temiz kurulumda B1 otomatik oynatma). Kullanıcı verisi (Deniz, B1–B2 bitti, B3 yarım) yedekten geri yüklendi; normal debug derleme ve geliştirme sunucusu açık bırakıldı. Ekran görüntüleri: oturum scratchpad `h051-*.png`, `h051-montaj.jpg`; kırpma/bölge önizlemeleri `h051-overlay-*.png`.

2026-10-13 (kullanıcı kararları uygulandı):
- Alex'in odası, Maya'nın dükkânı ve Liman setleri `APPROVED`. "Masadaki iki not" sadeleşti: Alex'in odasıyla tekrarlanan radio, cup, book, desk, window çıkarıldı; note, picture, pencil, lamp kaldı (4 nesne; B4-08'de açıkça görünen başka yeni A1/A2 nesne yok) ve `APPROVED`. 4 öğede "lamp" (A2) kapsamayı %95,8'e indiriyor: sözlükle %100, uyarı.
- Sahne avı: başta yalnızca "Find the …!" (+ kelimenin sesi, varsa); ilk yanlışta Türkçe yardım satırı, ikinci yanlışta bölge parlar. Ekran okuyucu davranışı aynı.
- Sahne görseli ekranı daha çok dolduruyor (iPhone 17'de ~309×546 → ~378×670 pt); iki parmakla ve "Yakınlaştır" düğmesiyle büyütme/kaydırma (`InteractiveViewer`); isabet büyütmede de doğru (test).
- Konu setinden gelen ifade Defter'den çıkarılabilir; set etkilenmez, "Hepsini defterime ekle" yeniden ekler.
- Doğrulama: pytest 106; content-lint 13 bölüm + 4 set, 0 hata; sezon paketi yeniden üretildi; flutter analyze temiz; flutter test 232 geçti. Simülatör: `h051-1x-01-baslangic.png` (yalnız İngilizce), `h051-1x-02-ilk-yanlis-turkce.png`, `h051-1x-03-yakinlastirma.png`, `h051-1x-04-yakinlastirmada-buldun.png`. Kullanıcı verisi değişmedi (10 ifade, 9 tekrar kaydı, B1–B2 bitti, B3 yarım).
2026-10-13 (ana oturum): flutter test 232/232, pytest 106/106, analyze temiz yeniden doğrulandı. Kullanıcı kararları: setler onaylı ("iki not" sadeleştirildi), Türkçe ipucu ilk yanlıştan sonra, sahne büyük + yakınlaştırma, set kartları silinebilir; commit onayı.
