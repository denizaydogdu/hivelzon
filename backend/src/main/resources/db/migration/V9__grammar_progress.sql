-- H-078: Dilbilgisi dersleri. Mobil Drift şema 7 aynası.
--   * user_grammar_progress: ders başına ilerleme (görüldü = IN_PROGRESS, bitti = COMPLETED; kalınan kart).
--     Değişebilir, doğal anahtar lesson_id; "bitti her zaman kazanır" (ProgressMerger), öteki alanlarda son yazan
--     kazanır.
--   * notebook_items: dilbilgisi kural kartı (kind = 'rule', source = 'grammar'; source_title = dersin başlığı,
--     Defter satırında "Dilbilgisi: <başlık>").
--   * speech_attempts: ders alıştırmasında "Söyle" (place = 'grammar'; yalnız sonuç, H-055).
--   * Ders kimlikleri (G-B2-03-reported-questions-commands) 32 karakteri aşabilir: içerik kimliği kolonları 64'e
--     genişler (notebook_items, learning_events, speech_attempts).

CREATE TABLE user_grammar_progress (
    user_id           uuid             NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    client_id         uuid             NOT NULL,
    seq               bigint           NOT NULL,
    server_updated_at timestamptz      NOT NULL,
    updated_at        timestamptz      NOT NULL,
    deleted           boolean          NOT NULL DEFAULT false,
    lesson_id         varchar(64)      NOT NULL,
    status            varchar(16),
    last_card         varchar(16),
    started_at        timestamptz,
    completed_at      timestamptz,
    PRIMARY KEY (user_id, client_id),
    CONSTRAINT ugp_natural_uk UNIQUE (user_id, lesson_id),
    CONSTRAINT ugp_status_ck CHECK (status IN ('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED'))
);
CREATE INDEX ugp_user_seq_ix ON user_grammar_progress (user_id, seq);

ALTER TABLE notebook_items DROP CONSTRAINT ni_kind_ck;
ALTER TABLE notebook_items ADD CONSTRAINT ni_kind_ck CHECK (kind IN ('word', 'phrase', 'sentence', 'rule'));
ALTER TABLE notebook_items DROP CONSTRAINT ni_source_ck;
ALTER TABLE notebook_items ADD CONSTRAINT ni_source_ck
    CHECK (source IN ('auto_target_phrase', 'user_saved', 'lookup', 'topic_set', 'book', 'grammar'));
ALTER TABLE notebook_items ALTER COLUMN content_id TYPE varchar(64);

ALTER TABLE speech_attempts DROP CONSTRAINT sa_place_ck;
ALTER TABLE speech_attempts ADD CONSTRAINT sa_place_ck
    CHECK (place IN ('review', 'meaning', 'decision', 'episode_end', 'grammar'));
ALTER TABLE speech_attempts ALTER COLUMN content_id TYPE varchar(64);

ALTER TABLE learning_events ALTER COLUMN content_id TYPE varchar(64);
