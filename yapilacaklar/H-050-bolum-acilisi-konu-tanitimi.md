# H-050: Bölüm açılışı (4 katman) ve Hi'nin konu tanıtımı

- **Durum:** Yapılacak
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
- **Hi'nin konu tanıtımı:** başlıktan önce değil; yeni dilbilgisi konusu sahnede ilk geçtiği anda, kısa ve atlanabilir.

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
