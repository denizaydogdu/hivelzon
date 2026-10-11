# H-034: Bölüm paketi formatı, dışa aktarma ve content-lint

- **Durum:** Yapılacak (H-025 onayından sonra)
- **Tür:** Uygulama (kod)
- **Faz:** 1.1 (`docs/UYGULAMA-PLANI.md`)
- **Bağımlılık:** H-033

## Kapsam
- `scenes.json` şeması (JSON Schema): düğüm türleri segment, karar, tepki, kart, görev; kenarlar; bayraklar (bölüm başına ≤ 3).
- Geçici kurgu araçlarının kalıcı sürümü `tools/content-pipeline/`: B1–B4'ü segment MP4 + altyazı JSON (zaman damgalı) + `scenes.json` paketine dönüştürür.
- `content-lint` ilk sürümü: A1 kapsama (CEFR-J), cümle uzunluğu, bağ alanları, grafik denetimi (ulaşılamayan düğüm, çıkışsız karar).
- Sırlar repoya girmez; medya git dışında kalır.

## Kabul kriterleri
- B1–B4 paketleri üretiliyor.
- `content-lint` dört bölümü geçiriyor; bozuk örnek pakette hata veriyor (test).
- Şema belgelendi.

## Test
```bash
python3 -m pytest tools/content-pipeline
python3 tools/content-pipeline/content_lint.py icerik/A1-001-*
```

## Geri alma
Kendi dalında (`h-034-bolum-paketi-formati`) yapılır; `main`'e alınmadan önce testler geçer. Sorun çıkarsa birleştirme commit'i geri alınır (`git revert`).

## Notlar
2026-10-11: H-025 uygulama planıyla açıldı.
