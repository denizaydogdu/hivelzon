# H-077: Ders paketi ve grammar-lint

- **Durum:** Yapılacak
- **Tür:** Uygulama (araç)
- **Faz:** Dilbilgisi D1 (`docs/DILBILGISI.md` §8)
- **Bağımlılık:** H-075, H-076

## Kapsam
- `lesson.json` şeması: kartlar, Türkçe anlatım, örnekler, şema tanımı, alıştırma, "Hikâyede gör" bağları.
- `grammar-lint`: örneklerin seviye kapsaması, cevap anahtarı, bağların çözülmesi, ses ve hizalama uyumu.
- Dışa aktarma ve dev içerik sunucusunda `/grammar/`.
- Bölüm ve kitap paketlerine `grammarTopics` etiketleri.

## Kabul kriterleri
- Örnek bir dersle paket uçtan uca üretilir; pytest yeşil.

## Test
`tools/content-pipeline/.venv/bin/python -m pytest tools/content-pipeline`

## Geri alma
Kendi dalında; `git revert`.

## Notlar
2026-10-14 (dal `h-077-ders-paketi`): Araçlar yazıldı; biçim `docs/DILBILGISI.md` §9'da.
- **Kaynak:** `dilbilgisi/<G-ID>/` klasöründe `lesson.json`, `lesson.md`, `PROMPTS.md`, `rights-and-review.md` ve `audio/{tr,en}/`.
  - `lesson.md` kartları: hook, explain, examples, contrast, practice, seeInStory, rule.
  - Satır işaretleri: `+` örnek, `x` yanlış biçim, `?` alıştırma, `!` açıklama, `- episode|book` bağ, `@diagram` şema.
- **Şemalar:** `schema/lesson.schema.json`, `cards.schema.json`, `lesson-audio.schema.json`. `book.schema.json` ve `scenes.schema.json` (episode) isteğe bağlı `grammarTopics` aldı.
- **Araçlar:**
  - `tts_lesson.py`: Türkçe için tts_tr, İngilizce için ElevenLabs Sarah. Kuru çalışma varsayılan; iki ayrı tavan, idempotent, `PROMPTS.md` kaydı ve `audio/lesson-audio.json`.
  - `grammar_lint.py`, `export_grammar.py`.
  - `hvpipeline/lesson.py`, `storylinks.py`, `grammarlint.py`, `lessonaudio.py`, `grammarexport.py`.
  - `serve.py`: `/grammar/index.json` ve `/grammar/<G-ID>/…`.
- **Örnek ders:** `tools/content-pipeline/tests/fixtures/grammar/G-A1-99-third-person-s` (sahte hizalama). Lint ve paket uçtan uca test ediliyor (`tests/test_grammar.py`, 28 test).
- **Gerçek API çağrısı yapılmadı.** Testlerde sahte istemciler kullanıldı.
- **Kabul:** pytest yeşil. Var olan bölüm ve kitap lint çıktıları değişmedi (alan yoksa çıktı aynı).
- **Kalan (pilot H-079):**
  - Gerçek ders ses üretiminde Duyu kalitesi ve İngilizce kelime uyarıları dinlenerek doğrulanır.
  - Türkçe anlatımda İngilizce kelimeyi bulan kural sezgiseldir (CEFR-J listesi + Türkçe istisna listesi); yanlış alarm görülürse `TR_COMMON` genişletilir.
2026-10-14: Kullanıcı isteğiyle açıldı: "Türk öğrenciler bazen konuları anlamıyor; A1'den C2'ye Türkçe anlatacağımız dilbilgisi konuları olsun." Ek istek: "Her hikâyeden önce dilbilgisi konusunu anlatayım mı diye sorulsun; ayrıca ayrı bir dilbilgisi alanı olsun." Kararlar: anlatıcı Hi (Türkçe Alania, İngilizce örnekler Sarah); biçim canlı ders kartları; yer Hikâye'de üçüncü bölüm ve bağlamdan; teklif bölüm panelinde ikincil düğme (H-050 korunur); önce müfredat, pilot 3 A1 konusu, sonra dalgalar. Ayrıntı: `docs/DILBILGISI.md`.
