-- H-094 P4: bağımsız konu reelleri (Keşfet "Bugün") aynı içerik tablosunda ve aynı K-05 durum
-- makinesiyle onaylanır; tür sütunu ayırır.
--   * content_type: EPISODE | BOOK | REEL.
--   * Kimlik: reel <SEVİYE>-R-<KAT>-<2 hane> (A1-R-CIN-01); kategori CIN (Sinema), SPO (Spor), BOK (Kitap).
--   * Reelde sezon yok (NULL); number = kimlikteki NN (1…); genre yok; descriptor zorunlu
--     (kategori + başlık + hedef gibi katalog meta verisi; medya pakette).
--   * Kanon bağı yoktur (bağımsız içerik): onay kontrol listesinde canonChecked istenmez (EditorialService).

ALTER TABLE content_items
    DROP CONSTRAINT content_items_type_ck,
    DROP CONSTRAINT content_items_content_id_ck,
    DROP CONSTRAINT content_items_level_ck,
    DROP CONSTRAINT content_items_season_ck;

ALTER TABLE content_items
    ADD CONSTRAINT content_items_type_ck CHECK (content_type IN ('EPISODE', 'BOOK', 'REEL')),
    ADD CONSTRAINT content_items_content_id_ck CHECK (
        (content_type = 'EPISODE' AND content_id ~ '^(A1|A2|B1|B2|C1)-[0-9]{3}$')
        OR (content_type = 'BOOK' AND content_id ~ '^(A1|A2|B1|B2|C1|C2)-K[0-9]{2}$')
        OR (content_type = 'REEL' AND content_id ~ '^(A1|A2|B1|B2|C1|C2)-R-(CIN|SPO|BOK)-[0-9]{2}$')),
    ADD CONSTRAINT content_items_level_ck CHECK (
        level IN ('A1', 'A2', 'B1', 'B2', 'C1', 'C2')
        AND (content_type IN ('BOOK', 'REEL') OR level <> 'C2')
        AND (content_type = 'EPISODE' OR left(content_id, 2) = level)),
    ADD CONSTRAINT content_items_season_ck CHECK (
        (content_type = 'EPISODE' AND season IS NOT NULL AND season >= 1 AND number >= 0
            AND genre IS NULL AND descriptor IS NULL)
        OR (content_type = 'BOOK' AND season IS NULL AND number >= 1
            AND genre IS NOT NULL AND descriptor IS NOT NULL)
        OR (content_type = 'REEL' AND season IS NULL AND number >= 1
            AND genre IS NULL AND descriptor IS NOT NULL));

-- Açık reel kataloğu: seviye + sıra (kategori descriptor'dan süzülür).
CREATE INDEX content_items_reel_ix ON content_items (level, number, content_version DESC)
    WHERE content_type = 'REEL';
