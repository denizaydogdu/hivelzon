# H-114: Türkçe/İngilizce ses araçlarının sağlamlaştırılması (Codex kancası bulguları)

- **Durum:** Devam ediyor (2026-11-25): uygulandı (3 tur: kancanın 5 bulgusu + çift ücret yarışı + qa-code-reviewer ve Codex bulguları), pytest 533, dört lint 0 hata, gerçek içerikte çevrimdışı kuru çalışmalar temiz; commit edildi (kullanıcı onayı 2026-11-25). **Duyu aylık tavanı kullanıcı kararı bekliyor.**
- **Tür:** Araç düzeltmesi (`tools/content-pipeline`)
- **Öncelik:** Orta (1. madde ücretli harcama tavanıyla ilgili)
- **Bağımlılık:** H-112 (bulgular onun kod denetiminde çıktı)

## Yapılan
1. **Tavan + defter kilidi:** yeni `hvpipeline/ledgerlock.py` (`<defter>.lock` üzerinde `fcntl.flock`, aynı iş
   parçacığında yeniden girilebilir). `tts_tr.ledger_add` ve `tts.ledger_add` kilit altında oku-değiştir-yaz (ortak
   `.tmp` adı yarışı da kapandı). Tavan denetimi → ücretli çağrı → defter yazımı tek kilit içinde, tavan her çağrıdan
   hemen önce yeniden okunur: `tts_tr.execute`, `tts.execute`, `tts_episode_tr.run_en`, `lessonaudio.execute_en`.
   Defter biçimi değişmedi; `.gitignore`'a `*.json.lock`.
   Sonuç: aynı defteri paylaşan koşular ücretli çağrıları sırayla yapar (429 bekleyişi dahil; bekleme mesajı yok).
2. **JSON girdi denetimi:** `instructions` metin, `pronunciations` `{"term","say_as"}` listesi, `text` metin, `id`
   metin/sayı olmalı; aksi `TrTtsError` → `HATA:` ve çıkış 2 (önceden traceback; `"text": null` "None" metni olarak
   ücretli üretime gidebiliyordu).
3. **Duyu zamanları:** `_time_ok` (sonlu sayı, 0 ≤ başlangıç ≤ bitiş, bitiş ≤ süre + 0,5 sn). Geçersiz kelime
   "duyulmadı" sayılır, komşulardan aradeğerlenir, hizalama uyarısı verir (`quality.ok = false`). Mevcut 1.444
   `*.duyu.json` (125.587 kelime) tarandı: 0 geçersiz → mevcut içerik yeni uyarı üretmez.
4. **`tts_episode_tr.py --execute`:** `OSError` da yakalanır → `HATA:` ve çıkış 1.
5. **`_dp_align` maliyeti (değişmedi, ölçüldü):** en uzun gerçek parça (C2-K02 p03, 2.346 karakter) 2,5 sn/+10 MB;
   5.000 karakter sınırında 13,7 sn/+80 MB. Yerel, parça başına bir kez; yavaş ama çökmez. Öneri (ayrı iş): bantlı DP
   ya da `SequenceMatcher` çapaları + `sim()` önbelleği.

## Testler
21+ yeni test (`tests/test_tts_tr.py`, `tests/test_books.py`, `tests/test_tts_episode_tr.py`); her biri düzeltmeden
önce kırmızıydı; kilit boş işlemle değiştirilince 6 test kırmızı; 15 tekrar koşuda kararsızlık yok. pytest **533** (son tur).

## 2. ve 3. tur (2026-11-25)
- **Çift ücret yarışı (Codex):** iki koşu önbelleği kilitten önce boş görüp ikisi de ödüyordu → her ücretli çağrıda kilit
  alındıktan sonra önbellek yeniden denetlenir; önbellek kilit bırakılmadan atomik yazılır. Duyu adımı da kilide alındı;
  `tts_reel.py` ve `tts_episode_en.py` aynı düzene geçti (tavan kilit altında her çağrıdan önce yeniden okunur).
- **Harcama hemen kaydedilir (qa-code-reviewer):** çağrı döner dönmez `ledger_add`, sonra yanıt denetimi/çözme, sonra
  önbellek, en son PROMPTS satırı. Bozuk ama ücretlendirilmiş yanıt da deftere girer; kayıt sonrası hata yeniden ödeme yaptırmaz.
- **Duyu:** ana çağrı ve her boşluk çağrısı ayrı kaydedilir; ana çözümleme `_raw/<anahtar>.duyu.main.json` olarak saklanır,
  boşlukta hata olursa yeniden çalıştırma yalnız boşlukları öder. `duyuCalls` artık her isteği ayrı sayar.
- **PROMPTS.md:** yazanlar dosya kilidi alır; atomik yazım benzersiz geçici adla (`ledgerlock.atomic_bytes`).
- Kilit meşgulse bir kez "defter kilidi bekleniyor: …" yazılır. Ay anahtarı her ücretli çağrıda kilit içinde alınır.
- Kitap tahmini: JSON var MP3 yok parçası artık ücrete sayılır (yürütmeyle aynı kural).
- Bölüm/Hi/Konuş ses adları (`audio` başvurusu, nesne `id`'leri) denetlenir: ayraç, `..`, mutlak yol, `audio/` dışı → `HATA:`.
- Bilinçli değiştirilmeyen: tavan tanımlı değilse `--execute` yalnız önbellekten kurulumda da reddedilir (kural: tavan yoksa üretim kapalı).
- Testler: `tests/test_tts_h114.py` (38; düzeltmeden önce 35'i kırmızı, kalan 3'ü geçerli girdinin kabulü) + diğer dosyalarda eklemeler.

## CI düzeltmesi (2026-11-25 akşam)
CI `45624677439`/`45649519701`'de `test_h114_reel_concurrent_runs_same_cues_pay_once` kırmızıydı. İlk teşhis (yavaş
makine, `7dfdae4` bekleme 60 sn) yanlıştı; asıl neden: `tts_reel.py` cue dosyasını kilit dışında `cp` alt süreciyle
kopyalıyordu, iki çalıştırma aynı hedefe yazınca **GNU cp "File exists"** ile düştü (macOS cp düşmez; ödeme yine tekti).
Düzeltme: kopya, cue JSON ve `timing.json` atomik yazılır (`T._atomic_bytes`); test önce istisnayı raporlar;
`test_h114_reel_cue_copy_does_not_shell_out_to_cp`. pytest 534; Docker Linux'ta 5/5.

## Karar bekleyen (kullanıcı)
- **Duyu (ses saati ücretli) için aylık tavan yok** — kural "her ücretli çağrıdan önce bütçe kontrolü". Seçenekler: ayrı
  `HIVELZON_TR_STT_MONTHLY_SECONDS_CAP` ya da Alania + Duyu'yu tek TL bütçesinde (`estimate_tl`) birleştirmek; tanımlı
  değilse Duyu'yu reddetmek ya da `/v1/usage` kalan saniyesine düşmek.

## Açık kalanlar (sonraki küçük iş adayı)
- `booktr.py`, `lesson.py`, `tts_episode_tr.py`'nin kurduğu parçalar `_check_segments`'ten geçmez (bugün 3.141 içerik
  JSON'unda bozuk kayıt yok).
- `_dp_align` hızlandırma (madde 5).

## Geri alma
İlgili commit `git revert`; `.lock` dosyaları zararsızdır, silinebilir.
