# H-070: Kitaplık arka ucu

- **Durum:** Bitti (2026-10-14; `mvn verify` 137 test, `pytest` 270 geçti; kitaplar içe aktarma + K-05 onayı + katalog ucu)
- **Tür:** Uygulama (backend)
- **Faz:** Kitaplık K5 (`docs/KITAPLIK.md` §9)
- **Bağımlılık:** H-066

## Kapsam
- İçerik türü `BOOK`.
- Seviyeye C2 eklenir (veritabanı kısıtları).
- Kimlik biçimi `<SEVİYE>-K<2 hane>`.
- İçe aktarma dalı (`book.json`).
- `/admin` onayı (K-05 durum makinesi aynen).
- Katalog uç noktası (ETag).

## Kabul kriterleri
- `mvn -B verify` yeşil.
- Örnek kitap içe aktarılır ve onaylanır.

## Test
`cd backend && mvn -B verify`

## Geri alma
Flyway geçişi ileri yönlü; kendi dalında, `git revert` + düzeltme geçişi.

## Notlar
2026-10-14: Kullanıcı isteğiyle açıldı: "Bir dinleme hikâyesi olsun; yatakta 'A2 bir hikâye aç' diyebileyim, okumadığım bir kitap sesli okunsun, ekranda renkli kitap gibi görünsün, okunan cümle işaretlensin, dokununca Türkçesi çıksın, durdurabileyim, sesi kapatıp kendim de okuyabileyim; okuduklarım ve yarıda kalanlar takip edilsin; her seviyeden 5, toplam 30 ilgi çekici kitap." Ek istek: bilmediği kelimeleri Defter'e ekleyip sonra çalışabilmeli. Kararlar (önerilenler onaylandı): önce 2 pilot kitap resimli, ElevenLabs önce pilotla, kısa kitap, bağımsız karışık türler. Ayrıntı: `docs/KITAPLIK.md`.

2026-10-14 (uygulama): Yapıldı ve doğrulandı (testler aşağıda).
- **V10__book_catalog.sql:** `content_items.content_type` (EPISODE varsayılan | BOOK), `genre`, `descriptor` (jsonb), `season` kitapta NULL. Kısıtlar: kimlik türe göre (`A1-001` / `A1-K01`), seviyeye C2 (yalnız kitap; kitapta önek = seviye), kitapta sezon yok + `number` = K numarası + tür ve tanım zorunlu, tür listesi.
- **İçe aktarma:** `CatalogImportService` kitap dalı (`kitaplar/<id>-<slug>/_build/package/manifest.json` `contentType: BOOK` + `book.json`; kök `hivelzon.catalog.books-import-root`, varsayılan `../kitaplar`). Bölümle ortak upsert: yeni sürüm lint temizse IN_REVIEW, değilse DRAFT; onaylı sürüm donmuş; `book.json → status` yok sayılır.
- **Onay:** `EditorialService` aynı K-05 akışı; kitapta `canonChecked` istenmez (kitaplar kanona bağlı değil, KITAPLIK §2). Editör listesi `?type=BOOK|EPISODE`; `/admin` ekranında "Kitaplık" süzgeci, kanon maddesi kitapta gizli.
- **Katalog:** `GET /api/v1/catalog/books?level=` (ETag/304, sayfalı); `/catalog/items` yalnız bölüm. Paket yeri `_books/<id>`; içerik sunucusu `/packages/_books/<id>/…` takma adı.
- **İçerik hattı:** `book_lint.py --write-reports` → `<kitap>/_build/lint.json` (backend lint özeti).
- Test: `mvn -B verify` 137 test yeşil (yeni `BookCatalogTest` 5); `pytest tools/content-pipeline` 270 geçti, 11 atlandı. Mevcut 30 kitap paketinin (ana çalışma kopyası) kimlik/tür/sürüm alanları içe aktarma kurallarına uyuyor.
