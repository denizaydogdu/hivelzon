# H-090: İlk 7 günlük A1 deneyimi ve yönlendirmeli konuşma görevleri

- **Durum:** Bitti (2026-10-16); 6 Konuş görevinin metni DRAFT, editör onayı bekler (H-028)
- **Tür:** Uygulama + içerik
- **Faz:** F1 MVP — ürün incelemesi sonrası (2026-10-16)
- **Bağımlılık:** H-088, H-089

## Kapsam (ürün incelemesi §4 P1, §6; kullanıcı onayı 2026-10-16)
- İlk 7 gün için dar bir A1 akışı: her gün kısa tekrar → sahne/okuma → bağımsız küçük görev; günlük plan (H-088) bunu sürer.
- **Konuş sekmesi "yakında" yerine 3 yönlendirmeli sahne** (AI sohbeti değil; H-007 korunur): kafede sipariş (Rosa), yol sorma, yeni komşuyla tanışma (Maya). 3–5 tur; her turda aynı anlam için birkaç doğal kabul edilen cevap; söyleyerek (cihazda tanıma, H-055) ya da dokunarak.
- **Kısa mesaj yazma:** 1–2 cümlelik görevler ("Maya'ya geç kalacağını yaz"). Güvenilir değerlendirme yoksa model cevap + öz değerlendirme; kesin puan yok.
- İçerik Claude taslağı → content-lint → editör onayı (H-028); görseller mevcut bölüm görsellerinden; ücretli üretim gerekirse önce maliyet.
- Başarılar H-089 kanıt basamaklarına "yeni örnekte kendi kullandı" olarak yazılır.

## Kabul kriterleri
- Konuş sekmesinde 3 sahne oynanır; ters anlamlı cevap kabul edilmez (H-087).
- Mikrofon izni olmadan dokunarak tamamlanır.
- Metinler ARAYUZ-METINLERI'ne uyar; testler ve golden'lar güncel.

## Test
```bash
cd mobile && flutter analyze && flutter test
```

## Geri alma
Kendi dalında; `git revert`.

## Notlar (2026-10-16, uygulama)
- **İçerik (DRAFT, editör onayı bekliyor, H-028):** `icerik/_evren/konusma/` — 3 sahne: `maya-neighbour` (B2 sonrası, 4 tur, 20 kabul cevabı), `ask-the-way` (B3 sonrası, köpekli adam, 4 tur, 16), `cafe-rosa` (B9 sonrası; Rosa B9'da tanışılır, 4 tur, 19); 3 mesaj: `hi-intro` (B1, kural yok → öz değerlendirme), `meet-note` (B4, telefona not; friday + seven), `late-maya` (B5; sorry + late, "not/never/no" yok). Sahneler "prova" olarak sunulur (kanonu değiştirmez); fiyat birimsiz ("It's twelve, please."). CEFR-J kapsama %96–100, en uzun cümle 8 sözcük.
- **Yer ve biçim:** konu setleri ve Hi verisi gibi sezon paketine aktarılır (`/packages/_season/S1/talk.json`, season.json → `talk`); görseller bölüm paketinin `stills/` görselleri (kopyalanmaz). Şema `tools/content-pipeline/schema/talk-task.schema.json`, lint `hvpipeline/talk.py` (`talk-*` kuralları), belge `docs/BOLUM-PAKETI.md` §9a.
- **Ses:** ücretli üretim yok. Bölüm kaydında konuşan + metin aynen geçen 8 satır (Maya 4, Mrs Brooks 1, Rosa 2, köpekli adam 1) dışa aktarmada kayıttan alınır; kalanlar cihazın İngilizce sesiyle (H-064). ElevenLabs sesleri sonra.
- **Cevap kuralı:** söylenen cevap kabul listesindeki biriyle **tam** eşleşmeli (H-087: anlamı değiştiren ek tam sayılmaz); yakın seçenek duyulursa kibar tepki; 2 denemeden sonra örnek cevap + seçenekler. Dokunarak (seç / kelimelerle kur) ya da "Geç" ile her tur geçilir; mikrofon izni yalnız Söyle'ye ilk dokununca. `SpeechMatcher`: "Turkey" = "Türkiye", "İzmir" (noktalı İ) düzeltildi.
- **Kanıt (H-089):** seçenek görmeden söyleme ya da kuralı geçen yazı → kullanılan hedef ifadelere `own_use`; seçme/dizme → `helped`; öz değerlendirme ve geçilen tur yazmaz. Yalnız defterdeki ifadeler, FSRS değişmez (`NotebookStore.recordPhraseUse`).
- **İlk 7 gün (A1 ya da seviye yok; başlangıç = açılışın bitişi):** Konuş görevi küçük görevlerin başına geçer, gerekçe "İlk haftanın N. günü. Bölüm 2'yi bitirdin; …"; bölüm bugün bittiyse birincil eylem olur ("sahne → küçük görev"). Sonra sahne avından sonra gelir; günde en çok bir Konuş görevi; B1+ önerilmez. Var olan H-088 testleri değişmedi (Konuş görevi yokken plan aynı).
- **Veri:** Drift şema 11 `user_talk_progress` (görev kimliği, ilk ve son bitiş, updated_at; metin/ses yok), eşitleme sırası 97; backend V14 (+ `speech_attempts.place = 'talk'`).
- **Goldenler (yeni):** `h090_*` (10 ekran); `h064` "konus" durumu yeni ekrana bağlandı. Kabuk testi "yakında" yerine Konuş ekranını bekler.
- **Açık:** editör onayı (İngilizce ve Türkçe metinler, kibar tepkiler); ElevenLabs sesleri; ana depoda `export_package.py --season 1` çalıştırılınca `talk.json` ve 8 ses dev sunucuya gelir.

2026-10-16 (birleştirme): Ana klasörde sezon dışa aktarımı ffmpeg geçici dosya adı (`.m4a.tmp`) yüzünden hata verdi; ad `.tmp-<id>.m4a` yapıldı + test. 8 bölüm sesi `talk/` altına yazıldı. Araçlar 325, mobil 1130, backend 146 test geçti.
