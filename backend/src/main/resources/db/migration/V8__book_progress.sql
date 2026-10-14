-- H-067: Kitaplık. Mobil Drift şema 6 aynası.
--   * user_book_progress: kitap başına ilerleme (kalınan bölüm, sayfa, cümle ve ses konumu). Değişebilir,
--     doğal anahtar book_id; "bitti her zaman kazanır" (ProgressMerger), öteki alanlarda son yazan kazanır.
--   * notebook_items: kitaptan eklenen ifade (source = 'book') ve kaynağın adı (source_title = kitabın başlığı;
--     Defter satırında "Kitap: <başlık>, s. N", sayfa cue_id'den).

CREATE TABLE user_book_progress (
    user_id           uuid             NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    client_id         uuid             NOT NULL,
    seq               bigint           NOT NULL,
    server_updated_at timestamptz      NOT NULL,
    updated_at        timestamptz      NOT NULL,
    deleted           boolean          NOT NULL DEFAULT false,
    book_id           varchar(16)      NOT NULL,
    status            varchar(16),
    chapter_id        varchar(8),
    page_number       integer,
    sentence_index    integer,
    position_sec      double precision,
    started_at        timestamptz,
    completed_at      timestamptz,
    PRIMARY KEY (user_id, client_id),
    CONSTRAINT ubp_natural_uk UNIQUE (user_id, book_id),
    CONSTRAINT ubp_status_ck CHECK (status IN ('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED'))
);
CREATE INDEX ubp_user_seq_ix ON user_book_progress (user_id, seq);

ALTER TABLE notebook_items ADD COLUMN source_title varchar(200);
ALTER TABLE notebook_items DROP CONSTRAINT ni_source_ck;
ALTER TABLE notebook_items ADD CONSTRAINT ni_source_ck
    CHECK (source IN ('auto_target_phrase', 'user_saved', 'lookup', 'topic_set', 'book'));
