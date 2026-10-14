-- H-070: Kitaplık arka ucu. Kitaplar bölümlerle aynı içerik tablosunda (content_items) ve aynı K-05 durum
-- makinesiyle (EditorialService) onaylanır; tür sütunu ayırır.
--   * content_type: EPISODE (varsayılan, mevcut satırlar) | BOOK.
--   * Kimlik: bölüm <SEVİYE>-<3 hane> (A1-001), kitap <SEVİYE>-K<2 hane> (A1-K01); kitapta önek = seviye.
--   * Seviye: C2 eklenir; yalnızca kitaplarda (sezonlar C1'de biter).
--   * Kitapta sezon yok (NULL); number = K numarası (1…). genre ve descriptor (book.json'un katalog alt kümesi,
--     bölüm/sayfa listesi hariç) zorunlu. Medya veritabanında değil; descriptor küçük meta veridir.

ALTER TABLE content_items
    ADD COLUMN content_type varchar(8) NOT NULL DEFAULT 'EPISODE',
    ADD COLUMN genre        varchar(16),
    ADD COLUMN descriptor   jsonb,
    ALTER COLUMN season DROP NOT NULL;

ALTER TABLE content_items
    DROP CONSTRAINT content_items_content_id_ck,
    DROP CONSTRAINT content_items_level_ck,
    DROP CONSTRAINT content_items_season_ck;

ALTER TABLE content_items
    ADD CONSTRAINT content_items_type_ck CHECK (content_type IN ('EPISODE', 'BOOK')),
    ADD CONSTRAINT content_items_content_id_ck CHECK (
        (content_type = 'EPISODE' AND content_id ~ '^(A1|A2|B1|B2|C1)-[0-9]{3}$')
        OR (content_type = 'BOOK' AND content_id ~ '^(A1|A2|B1|B2|C1|C2)-K[0-9]{2}$')),
    ADD CONSTRAINT content_items_level_ck CHECK (
        level IN ('A1', 'A2', 'B1', 'B2', 'C1', 'C2')
        AND (content_type = 'BOOK' OR level <> 'C2')
        AND (content_type <> 'BOOK' OR left(content_id, 2) = level)),
    ADD CONSTRAINT content_items_season_ck CHECK (
        (content_type = 'EPISODE' AND season IS NOT NULL AND season >= 1 AND number >= 0
            AND genre IS NULL AND descriptor IS NULL)
        OR (content_type = 'BOOK' AND season IS NULL AND number >= 1
            AND genre IS NOT NULL AND descriptor IS NOT NULL)),
    ADD CONSTRAINT content_items_genre_ck CHECK (
        genre IS NULL OR genre IN ('mystery', 'adventure', 'humor', 'scifi-fantasy', 'everyday'));

-- Açık kitap kataloğu: tür + seviye + sıra.
CREATE INDEX content_items_book_ix ON content_items (level, number, content_version DESC)
    WHERE content_type = 'BOOK';
