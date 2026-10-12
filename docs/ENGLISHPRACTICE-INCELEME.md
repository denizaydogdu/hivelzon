# EnglishPractice reposu: inceleme ve kullanım kararı

**Tarih:** 2026-10-12 · **Kaynak:** https://github.com/recepyagmur/EnglishPractice (yalnızca okundu; hiçbir şey indirilmedi ya da kopyalanmadı)
**Kullanıcı kararı (soru-cevap, 2026-10-12):** Kod **desen olarak** uyarlanır (MIT, kaynak belirtilerek); içerik **yalnızca referans** alınır, kendi metnimiz yazılır.

## Ne?
Türkçe konuşanlar için yerel, çevrimdışı masaüstü İngilizce pratik uygulaması (Windows/Linux; FastAPI + web arayüzü). Yapay zekâyla yazılı/sesli sohbet ve anında düzeltme, A1–C1 dersler ve sınavlar, Türkçe sesli öğretmen, kelime ve kalıp çalışması, YDS tarzı testler. Modeller: Ollama + Gemma/Qwen, Whisper (STT), Kokoro (İngilizce TTS), EMA Lightning (Türkçe TTS).

## Lisanslar
| Bölüm | Lisans | hiVelzon'da |
|---|---|---|
| Uygulama kodu | MIT | Desen olarak uyarlanabilir; kaynak dosyada belirtilir. İki repo birbirine bağlanmaz. |
| `app/content/` (dersler, kalıplar, kelime listeleri ve Türkçe anlamlar, sınavlar, YDS) | CC BY-SA 4.0 (ShareAlike) | **Kopyalanmaz, uyarlanmaz.** Yalnızca okunur; kendi metnimiz yazılır. (Uyarlanırsa türetilen parça da BY-SA olmak zorunda kalır.) |
| Türkçe ses modeli (EMA Lightning, ONNX) | Apache 2.0 | Hi-C değerlendirmesinde aday; kendi lisansıyla. |
| İndirilen modeller (Gemma/Qwen, Whisper, Kokoro, Vikisözlük) | Kendi lisansları | Seçim H-044 / Hi-B değerlendirmesinde yapılır. |

## hiVelzon'da nerede işe yarar?
| Desen (MIT kod) | Ne yapıyor | Bizdeki işi |
|---|---|---|
| `app/backend/errors.py` | 14 sabit hata kategorisi (zaman, fiil yapısı, özne-yüklem uyumu, a/an/the, edat, zamir, çoğul, kelime sırası, kelime seçimi, eksik/fazla kelime, yazım, noktalama, diğer); sürümlü sınıflandırma; kategori başına pratik konusu | **H-048 (Hi-A)** Türkçeye göre koçluk ve öğrenci modeli; **H-036** öğrenme olaylarında hata türü alanı. Türkçe etiketler ve açıklamalar bizim tarafımızdan yazılır. |
| `corrections.py`, `pronoun_check.py` | LLM düzeltme önerir, deterministik kod denetler (ör. Türkçede tek "o" olduğu için he/she karışması) | **Hi-B** düzeltme hattı: "seviye/düzeltme kararı LLM'e bırakılmaz" ilkemizle aynı. |
| `ollama_client.py`, `llm_models.py` | Yerel model istemcisi, model seçimi | **Hi-B** `AiTutorPort` → Ollama adaptörü (Spring Boot'a Java olarak). |
| `stt.py`, `tts.py`, `tts_tr.py`, `teacher_speech.py` | Whisper, Kokoro, Türkçe TTS | **Hi-C** sesli Hi ve prova. |
| `lessons/README.md` (biçim tanımı) | Ders alanları, 7 alıştırma türü, cevap karşılaştırma kuralları (don't = do not, 2 p.m. = 2pm, 's = is/has …) | Görev/kanıt doğrulamasında cevap normalleştirme kuralları için referans (kurallar kendi kodumuzla yazılır). |

## Doğrulanan bir bulgu
Yazar, "yerel modelin Türkçesi güvenilir değil" diyerek Türkçe anlatımları elle yazıyor; yapay zekâ yalnızca İngilizce soru üretip sohbet ediyor. Bu, `docs/HI-ASISTAN-VE-KOC.md` §4.2'deki kalite riskini destekliyor: Hi-B'de Türkçe açıklamalar onaylı içerikten (RAG/şablon) gelmeli, serbest üretimle değil.

## İşe yaramayanlar
Masaüstü mimari (bizimki mobil + sunucu), YDS içeriği (kapsam dışı), kelime listeleri (CEFR-J 1.5'ten türetilmiş; biz 1.6 kullanıyoruz).
