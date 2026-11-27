# H-119: ElevenLabs kesik yanıtlarının ücreti deftere yazılmıyordu

- **Durum:** ✅ Bitti (2026-11-27): araç düzeltmesi ve testler çalışma ağacında; content-pipeline pytest tamamı geçti. **Commit yok, kullanıcı onayı bekliyor.**
- **Tür:** Araç düzeltmesi (`tools/content-pipeline`), harcama kaydı
- **Öncelik:** Yüksek (ücretli harcama kaydı ve aylık tavan doğruluğu)
- **Bağımlılık:** H-114 ("çağrı döndü = ödendi" kuralı yalnız dönen çağrıları kapsıyordu)

## Sorun
B2 kitapları seslendirilirken (H-072, 2026-11-27) B2-K01 c2'nin 1. parçası (2.989 karakter; base64 sesli yanıt
~4,7 MB JSON) için ElevenLabs **HTTP 200** döndü ama gövde aktarım ortasında **4 kez** kesildi
(`http.client.IncompleteRead`). Ağ sağlamdı (20 MB deneme indirmesi 4 sn, %0 paket kaybı). ElevenLabs her kesik
çağrıyı ücretlendirdi (her biri ≈ 1.300 kredi, toplam ≈ 5.300 kredi kayıp), araç ise bunları deftere yazmadı: H-114'teki
"çağrı döner dönmez kaydet" kuralı yalnız tamamlanan yanıtları kapsıyordu. Sonuç: defter ve aylık tavan denetimi
gerçek harcamanın altında kaldı.

## Yapılan
1. **`hvpipeline/tts.py`:** yeni `TtsPaidError` (`TtsError` alt sınıfı) ve `paid_call()`. `http_client` 200 gövdesi
   okunurken oluşan hatayı (`IncompleteRead`/`OSError`) ve geçersiz JSON'u (otomatik Codex incelemesinde bulundu)
   `TtsPaidError`'a çevirir; `paid_call` önce defteri yazar, sonra hatayı yeniden yükseltir.
2. **5 ElevenLabs çağrı yerinin hepsi `paid_call` kullanır:** `tts.execute` (kitaplar), `lessonaudio`,
   `tts_episode_tr.run_en`, `tts_reel.py`, `tts_episode_en.py`.
3. **Yanıt gelmeden oluşan hatalar** (ör. bağlantı reddi) ücret sayılmaz, deftere girmez.
4. **`MAX_CHARS["eleven_v3"]` 3000 → 1500:** yanıt gövdesi ~2,4 MB'a indi; değişiklikten sonra B2'de 110 çağrı, 0 kesik.
   Önceden seslendirilmiş bölümler etkilenmez (`textSha256` ile atlanır, yeniden ödeme yok).
5. **Defter elle düzeltildi:** `kitaplar/_maliyet/elevenlabs-karakter.json` 2026-11'e 4 kesik çağrı için
   +4 × 2.989 karakter, +4 çağrı eklendi.

## Testler
`tests/test_tts_h114.py` içinde 6 yeni test: kitap, ders + `run_en` ve bölüm İngilizcesi çağrılarında kesik yanıt
deftere yazılır (kitapta önbelleğe girmez); `http_client` kesik gövdeyi ve geçersiz JSON'u `TtsPaidError`'a çevirir;
yanıt öncesi hata ücretli sayılmaz. content-pipeline pytest tamamı geçti.

## Ders
Aynı parçada yanıt tekrar tekrar kesiliyorsa **dur**, körlemesine yeniden deneme: her deneme ücretlenir. Önce
nedeni (yanıt boyutu, parça sınırı) ele al.

## Geri alma
İlgili değişiklik `git revert`; defterdeki elle düzeltme gerçek harcamayı yansıttığı için geri alınmaz.
