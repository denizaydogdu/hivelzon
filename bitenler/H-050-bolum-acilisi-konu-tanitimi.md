# H-050: Bölüm açılışı (4 katman) ve Hi'nin konu tanıtımı

- **Durum:** Bitti
- **Tür:** Uygulama + boru hattı
- **Bağımlılık:** H-049 (jenerik), H-046
- **Faz:** 1.2c

## Güncelleme: kullanıcı kararı 2026-10-12 (ikinci)
"Bence olmaması lazım, direkt bölüm başlığı ile başlaması lazım her zaman."
- **Her bölüm doğrudan bölüm başlığıyla açılır.** Başlıktan önce soğuk açılış videosu, "Friday." gibi yazı ya da kart yok.
- **Başlık ekranı:** jeneriğin kısa sürümü (2–3 sn animasyon) üstünde "Sezon 1 · Bölüm N · Başlık". Dokunma gerekmez.
- **Başlıktan sonra:** (B2 ve sonrası) atlanabilir "Önceki bölümde" özeti, sonra doğrudan hikâye.
- **Ayrı görev kartı ve hedef ifade listesi açılışta yok.** Hedef ifadeler üst çubukta 🎯 simgesiyle isteğe bağlı açılır ve bölüm sonunda gösterilir. Görev cümlesi 🎯 panelinde durur.
- **Hikâye kartları sahneye taşınır:** B3'teki Maya'nın mesajı ilk sahnenin içinde; B4'teki Hi kartı başlıktan sonra, sahne içinde.
- **Tam jenerik (10 sn) bölümlerin başında değil;** sezonun ilk açılışında (Hikâye sekmesinde Sezon 1 ilk kez açılınca, H-035) bir kez oynar, sonra sezon başlığından yeniden izlenebilir.
- **Hi'nin konu tanıtımı:** başlıktan önce değil; yeni dilbilgisi konusu sahnede ilk geçtiği anda, kısa ve atlanabilir. **Bu işten çıkarıldı → H-048.**

## İlk kapsam (aşağıdaki maddeler yukarıdaki güncellemeyle değişti)
1. **Önceki bölümde** (10–15 sn): Önceki bölümün son replikleri ve `previously` alanından otomatik özet segmenti; boru hattında yerel kurgu, kredisiz. Dün izlenmişse "Atla".
2. **Kanca** (3–5 sn): Bölümün kanca segmenti (`kurgu.json`'da işaretlenir).
3. **Sezon jeneriği:** İlk izlemede tam, sonra 2 sn kısa sürüm + "Atla". İzlenme yerelde tutulur.
4. **Hi'nin görev tanıtımı** (5–8 sn, uygulama içi animasyon, kredisiz): Hi zıplayarak gelir; görev + 3–5 hedef ifade kartlarla belirir; Hi'nin kısa repliği (TTS).
- **Konu tanıtımı:** Yeni bir dilbilgisi konusu ilk kez geldiğinde (ör. saatler, fiyatlar) Hi'nin kısa animasyonlu konu kartı. `content.json`'daki dilbilgisi hedefinden beslenir; konu başına bir kez gösterilir, defterden yeniden açılabilir.
- **Kural:** İlk etkileşime kadar toplam ≤ 30 sn. Bütün katmanlar atlanabilir. Geri sayım yok (K-32).

## Kabul kriterleri
- `scenes.json` şemasında açılış katmanları; content-lint süre sınırını denetliyor.
- Simülatörde B2: özet → kanca → jenerik → Hi tanıtımı → ilk sahne; ikinci açılışta kısa jenerik.
- Widget ve motor testleri yeşil.

## Notlar
2026-10-12: H-049 ile birlikte açıldı.

2026-10-12 (uygulama ve doğrulama):
- **Açılış (B1–B4):** her bölüm `title` düğümüyle açılır (sezonun yazısız 2,53 sn animasyonu + uygulamanın çizdiği "SEZON 1 · BÖLÜM N" ve bölüm adı; dokunma yok, video bitince geçer). Eski soğuk açılış `s01`: B1'de kaldırıldı (sessiz not görseli, aynı görsel s03'te var; B1'de özet yok). B2'de 1. çekim (B1'in telsiz anı, "Meet me at the old station.") `recap` 2,5 sn oldu, dükkânın dış çekimi `s02`'nin açılış çekimi oldu. B3'te B2'nin sonu (Maya haritada, "I can show you. Tomorrow?") `recap` 2,8 sn. B4'te B3'ün son karesi (kapıdaki yarım not) sessiz `recap` 3,2 sn. `c-title` ve `c-mission` kartları kalktı. B3 `c-msg` ve B4 `h-01` başlık+özetten sonra, Sahne 1'in ilk düğümü (kontrol noktası). Kaynak görseller silinmedi; yalnızca `kurgu.json` değişti, `story.en.md`'ye dokunulmadı.
- **Paket:** `schemaVersion 2` (`title`, `recap`; kart türlerinden `title`/`mission` çıktı; `episode.targetPhraseGloss`). Sezon paketi `icerik/_evren/_build/season/S1/` → `/packages/_season/S1/` (season.json, jenerik-tam 10,27 sn, jenerik-kisa 2,03 sn, jenerik-baslik 2,53 sn + ilk kare jpg; 15,2 MB). Yazısız başlık arka planı `kurgu.py --baslik-arka` ile yerelde üretildi (-16,0 LUFS; kredi yok).
- **content-lint:** yeni kurallar `title-start`, `title-first` (hata), `recap-length` >15 sn, `recap-position`, `season-missing` (uyarı). B1–B4: 0 hata (uyarılar: çeviri DRAFT, B3/B4 kapsama %96,2/%97,6 sözlükle %100).
- **Dışa aktarma:** senkron en büyük fark B1 0,003 / B2 0,010 / B3 0,007 / B4 0,010 sn (özetler dahil; B2 özet 0,000, B3 özet 0,000; B4 özeti sessiz); ses -16,16 / -16,05 / -16,01 / -16,12 LUFS; boyut 27,1 / 46,3 / 30,7 / 47,9 MB.
- **Uygulama:** başlık ekranı (afiş → video, yazı 0,45 sn'de belirir, son 0,4 sn'de kaybolur, ekran okuyucuya "Sezon 1, Bölüm N: …", dokunmayla durmaz, duraklat simgesi yok), "Önceki bölümde" + "Atla" (48 px), üst çubukta 🎯 (görev + hedef ifadeler; anlamı olan ifadeye dokununca anlam paneli; panel açıkken video durur), Hikâye sekmesinde sezon başlığı + "Jeneriği izle"; tam jenerik ilk açılışta bir kez (cihazda bayrak), "Geç" ile atlanır. Kaldığı yerden devamda önce başlık, sonra kontrol noktası. AI notu başlık ekranında sol üstte 4 sn, başlık yazısıyla çakışmıyor.
- **Testler:** pytest 62 geçti; flutter analyze temiz; flutter test 86 geçti.
- **Simülatör (hiVelzon iPhone 17, AUTOPLAY_TEST=h050):** sezon jeneriği ilk açılışta oynadı ve kapandı; B1 ve B2 sona kadar oynadı (kapı açık, hata 0). Geçişler: başlık→s02 38,9 ms, başlık→özet 39,3 ms (ikisi de önden başlatıldı, siyah kare yok); özet "Atla"→s02 170,9 ms (ui). Bölüm açılışında başlık videosunun ilk karesi 252,7–323,1 ms (önceki ölçüm 602,8 ms); bu sürede başlık afişi (ilk kare jpg, bölüm yüklenirken önbelleğe alınır) ve yazı görünür; başlık videosu bölüm JSON'u okunduktan hemen sonra ısıtılır. Ekran görüntüleri: oturum scratchpad'inde `h050-*.png`.
- **Kalan:** Hi'nin konu tanıtımı H-048'de. Gerçek sezon haritası H-035'te (jenerik düğmesi şimdilik Hikâye listesinin başında). B4 özeti sessiz (yalnızca görsel + not yazısı).
2026-10-12 (ana oturum): flutter test 86/86, pytest 62/62, analyze temiz yeniden doğrulandı. Kullanıcı "commit and push" dedi.
