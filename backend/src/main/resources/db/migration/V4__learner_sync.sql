-- H-037 Bölüm 2: öğrenen verisi eşitleme (cihaz değişince kaybolmaması gereken her şey).
-- Tablolar mobil Drift şema 4'ün (mobile/lib/shared/storage/app_database.dart) aynasıdır; tablo adları
-- aynıdır, app_meta (yalnızca cihaz) yoktur. Ortak kurallar:
--   * Her satır kullanıcıya aittir (user_id) ve istemci kimliğiyle (client_id, UUID) tekildir:
--     PRIMARY KEY (user_id, client_id). Doğal anahtarlı tablolarda client_id belirlenimcidir
--     (UUIDv5, bkz. backend/README.md), bu yüzden iki cihazdaki aynı satır aynı kimliği taşır.
--   * seq: sunucu sırası (sync_seq). Her ekleme/değişiklikte yeni değer alır; çekme imleci budur.
--   * Değişebilir tablolarda updated_at (istemci, UTC) son yazan kazanır kuralının zamanıdır;
--     deleted = silme işareti (mezar taşı, veri kolonları boşaltılır).
--   * Yalnız eklenen tablolar (review_logs, learning_events, speech_attempts, gate_progress, clues) güncellenmez.
--   * Ses ve tanıma yazısı (transkript) hiçbir tabloda yoktur (H-055); speech_attempts yalnızca sonuçtur.
--   * Kullanıcıya yabancı anahtar ON DELETE RESTRICT: kalıcı silmede satırları LearnerDataPurger açıkça siler.

CREATE SEQUENCE sync_seq AS bigint;

-- ------------------------------------------------------------------ ilerleme (progress)

CREATE TABLE user_story_progress (
    user_id                 uuid        NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    client_id               uuid        NOT NULL,
    seq                     bigint      NOT NULL,
    server_updated_at       timestamptz NOT NULL,
    updated_at              timestamptz NOT NULL,
    deleted                 boolean     NOT NULL DEFAULT false,
    content_id              varchar(32) NOT NULL,
    status                  varchar(16),
    last_checkpoint_node_id varchar(64),
    checkpoint_snapshot     jsonb,
    started_at              timestamptz,
    completed_at            timestamptz,
    PRIMARY KEY (user_id, client_id),
    CONSTRAINT usp_natural_uk UNIQUE (user_id, content_id),
    CONSTRAINT usp_status_ck CHECK (status IN ('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED')),
    CONSTRAINT usp_snapshot_size_ck CHECK (checkpoint_snapshot IS NULL OR octet_length(checkpoint_snapshot::text) <= 32768)
);
CREATE INDEX usp_user_seq_ix ON user_story_progress (user_id, seq);

CREATE TABLE user_story_flags (
    user_id           uuid        NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    client_id         uuid        NOT NULL,
    seq               bigint      NOT NULL,
    server_updated_at timestamptz NOT NULL,
    updated_at        timestamptz NOT NULL,
    deleted           boolean     NOT NULL DEFAULT false,
    content_id        varchar(32) NOT NULL,
    flag              varchar(64) NOT NULL,
    value             varchar(64),
    PRIMARY KEY (user_id, client_id),
    CONSTRAINT usf_natural_uk UNIQUE (user_id, content_id, flag)
);
CREATE INDEX usf_user_seq_ix ON user_story_flags (user_id, seq);

CREATE TABLE gate_progress (
    user_id           uuid        NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    client_id         uuid        NOT NULL,
    seq               bigint      NOT NULL,
    server_updated_at timestamptz NOT NULL,
    content_id        varchar(32) NOT NULL,
    item_kind         varchar(16) NOT NULL,
    node_id           varchar(64) NOT NULL,
    recorded_at       timestamptz NOT NULL,
    PRIMARY KEY (user_id, client_id),
    CONSTRAINT gp_natural_uk UNIQUE (user_id, content_id, item_kind, node_id),
    CONSTRAINT gp_kind_ck CHECK (item_kind IN ('comprehension', 'targetPhrase', 'activeTask'))
);
CREATE INDEX gp_user_seq_ix ON gate_progress (user_id, seq);

CREATE TABLE season_state (
    user_id           uuid        NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    client_id         uuid        NOT NULL,
    seq               bigint      NOT NULL,
    server_updated_at timestamptz NOT NULL,
    updated_at        timestamptz NOT NULL,
    deleted           boolean     NOT NULL DEFAULT false,
    season_id         integer     NOT NULL,
    intro_seen        boolean,
    intro_seen_at     timestamptz,
    PRIMARY KEY (user_id, client_id),
    CONSTRAINT ss_natural_uk UNIQUE (user_id, season_id),
    CONSTRAINT ss_season_ck CHECK (season_id >= 1)
);
CREATE INDEX ss_user_seq_ix ON season_state (user_id, seq);

CREATE TABLE clues (
    user_id           uuid         NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    client_id         uuid         NOT NULL,
    seq               bigint       NOT NULL,
    server_updated_at timestamptz  NOT NULL,
    content_id        varchar(32)  NOT NULL,
    clue_id           varchar(32)  NOT NULL,
    text_tr           varchar(500) NOT NULL,
    text_en           varchar(500),
    unlocked_at       timestamptz  NOT NULL,
    PRIMARY KEY (user_id, client_id),
    CONSTRAINT clues_natural_uk UNIQUE (user_id, content_id, clue_id)
);
CREATE INDEX clues_user_seq_ix ON clues (user_id, seq);

CREATE TABLE story_links (
    user_id           uuid         NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    client_id         uuid         NOT NULL,
    seq               bigint       NOT NULL,
    server_updated_at timestamptz  NOT NULL,
    recorded_at       timestamptz  NOT NULL,
    deleted           boolean      NOT NULL DEFAULT false,
    content_id        varchar(32)  NOT NULL,
    number            integer,
    open_question_id  varchar(32),
    open_question_tr  varchar(500),
    answers           jsonb,
    partial_notes     jsonb,
    PRIMARY KEY (user_id, client_id),
    CONSTRAINT sl_natural_uk UNIQUE (user_id, content_id),
    CONSTRAINT sl_answers_ck CHECK (answers IS NULL OR jsonb_typeof(answers) = 'array'),
    CONSTRAINT sl_notes_ck CHECK (partial_notes IS NULL OR jsonb_typeof(partial_notes) = 'object')
);
CREATE INDEX sl_user_seq_ix ON story_links (user_id, seq);

-- ------------------------------------------------------------------ öğrenme (learning)

CREATE TABLE notebook_items (
    user_id           uuid             NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    client_id         uuid             NOT NULL,
    seq               bigint           NOT NULL,
    server_updated_at timestamptz      NOT NULL,
    updated_at        timestamptz      NOT NULL,
    deleted           boolean          NOT NULL DEFAULT false,
    item_key          varchar(320)     NOT NULL,
    kind              varchar(16),
    text_en           varchar(300),
    text_tr           varchar(300),
    example_en        varchar(500),
    example_tr        varchar(500),
    content_id        varchar(32),
    cue_id            varchar(64),
    image_path        varchar(200),
    image_crop        varchar(64),
    audio_path        varchar(200),
    audio_start       double precision,
    audio_end         double precision,
    example_start     double precision,
    example_end       double precision,
    source            varchar(24),
    created_at        timestamptz,
    PRIMARY KEY (user_id, client_id),
    CONSTRAINT ni_natural_uk UNIQUE (user_id, item_key),
    CONSTRAINT ni_kind_ck CHECK (kind IN ('word', 'phrase', 'sentence')),
    CONSTRAINT ni_source_ck CHECK (source IN ('auto_target_phrase', 'user_saved', 'lookup'))
);
CREATE INDEX ni_user_seq_ix ON notebook_items (user_id, seq);

-- FSRS kartı (K-04). Durum, review_logs'tan sunucuda yeniden hesaplanır (bkz. ReviewService).
CREATE TABLE review_cards (
    user_id           uuid             NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    client_id         uuid             NOT NULL,
    seq               bigint           NOT NULL,
    server_updated_at timestamptz      NOT NULL,
    updated_at        timestamptz      NOT NULL,
    deleted           boolean          NOT NULL DEFAULT false,
    item_key          varchar(320)     NOT NULL,
    state             smallint,
    step              integer,
    stability         double precision,
    difficulty        double precision,
    due               timestamptz,
    reps              integer,
    lapses            integer,
    last_review       timestamptz,
    PRIMARY KEY (user_id, client_id),
    CONSTRAINT rc_natural_uk UNIQUE (user_id, item_key),
    CONSTRAINT rc_state_ck CHECK (state BETWEEN 1 AND 3),
    CONSTRAINT rc_counts_ck CHECK (reps >= 0 AND lapses >= 0)
);
CREATE INDEX rc_user_seq_ix ON review_cards (user_id, seq);

CREATE TABLE review_logs (
    user_id           uuid        NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    client_id         uuid        NOT NULL,
    seq               bigint      NOT NULL,
    server_updated_at timestamptz NOT NULL,
    card_client_id    uuid        NOT NULL,
    rating            smallint    NOT NULL,
    reviewed_at       timestamptz NOT NULL,
    task_type         varchar(24),
    correct           boolean,
    dont_know         boolean     NOT NULL DEFAULT false,
    duration_ms       integer,
    was_new           boolean     NOT NULL DEFAULT false,
    PRIMARY KEY (user_id, client_id),
    CONSTRAINT rl_rating_ck CHECK (rating BETWEEN 1 AND 4),
    CONSTRAINT rl_duration_ck CHECK (duration_ms IS NULL OR duration_ms >= 0)
);
CREATE INDEX rl_user_seq_ix ON review_logs (user_id, seq);
-- Kart yeniden hesaplaması: kartın bütün cevapları zaman sırasıyla.
CREATE INDEX rl_user_card_ix ON review_logs (user_id, card_client_id, reviewed_at, client_id);

CREATE TABLE learning_events (
    user_id                uuid         NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    client_id              uuid         NOT NULL,
    seq                    bigint       NOT NULL,
    server_updated_at      timestamptz  NOT NULL,
    content_id             varchar(32)  NOT NULL,
    source_id              varchar(64)  NOT NULL,
    target                 varchar(300) NOT NULL,
    at                     timestamptz  NOT NULL,
    error_type             varchar(64),
    error_taxonomy_version integer,
    PRIMARY KEY (user_id, client_id)
);
CREATE INDEX le_user_seq_ix ON learning_events (user_id, seq);

CREATE TABLE hi_records (
    user_id           uuid        NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    client_id         uuid        NOT NULL,
    seq               bigint      NOT NULL,
    server_updated_at timestamptz NOT NULL,
    updated_at        timestamptz NOT NULL,
    deleted           boolean     NOT NULL DEFAULT false,
    kind              varchar(16) NOT NULL,
    ref_id            varchar(64) NOT NULL,
    status            varchar(16),
    PRIMARY KEY (user_id, client_id),
    CONSTRAINT hr_natural_uk UNIQUE (user_id, kind, ref_id),
    CONSTRAINT hr_kind_ck CHECK (kind IN ('topic_intro', 'bridge_task', 'note_read')),
    CONSTRAINT hr_status_ck CHECK (status IN ('seen', 'done', 'dismissed', 'read'))
);
CREATE INDEX hr_user_seq_ix ON hi_records (user_id, seq);

-- "Söyle" (H-055): yalnızca sonuç. Ses, tanıma yazısı ve güven puanı kolonu yoktur.
CREATE TABLE speech_attempts (
    user_id           uuid         NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    client_id         uuid         NOT NULL,
    seq               bigint       NOT NULL,
    server_updated_at timestamptz  NOT NULL,
    place             varchar(16)  NOT NULL,
    content_id        varchar(32),
    item_ref          varchar(300) NOT NULL,
    match_level       varchar(8)   NOT NULL,
    missing_count     integer      NOT NULL DEFAULT 0,
    error_note_id     varchar(64),
    at                timestamptz  NOT NULL,
    PRIMARY KEY (user_id, client_id),
    CONSTRAINT sa_place_ck CHECK (place IN ('review', 'meaning', 'decision', 'episode_end')),
    CONSTRAINT sa_match_ck CHECK (match_level IN ('full', 'close', 'no')),
    CONSTRAINT sa_missing_ck CHECK (missing_count BETWEEN 0 AND 100)
);
CREATE INDEX sa_user_seq_ix ON speech_attempts (user_id, seq);
