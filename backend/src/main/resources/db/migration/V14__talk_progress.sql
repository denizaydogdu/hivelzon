-- H-090: Konuş görevleri (yönlendirmeli sahne ve kısa mesaj). Mobil Drift şema 11 aynası.
--   * user_talk_progress: bitirilen görev başına yalnız kimlik ve zamanlar (ilk bitiş, son bitiş). Kullanıcının
--     yazdığı mesaj, söylediğinin yazısı ve ses hiçbir zaman gelmez. Değişebilir, doğal anahtar task_id; düz son
--     yazan kazanır.
--   * speech_attempts: Konuş sahnesinde cevabı söyleme (place = 'talk'; yalnız sonuç, H-055).

CREATE TABLE user_talk_progress (
    user_id           uuid         NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    client_id         uuid         NOT NULL,
    seq               bigint       NOT NULL,
    server_updated_at timestamptz  NOT NULL,
    updated_at        timestamptz  NOT NULL,
    deleted           boolean      NOT NULL DEFAULT false,
    task_id           varchar(64)  NOT NULL,
    completed_at      timestamptz,
    last_done_at      timestamptz,
    PRIMARY KEY (user_id, client_id),
    CONSTRAINT utp_natural_uk UNIQUE (user_id, task_id)
);
CREATE INDEX utp_user_seq_ix ON user_talk_progress (user_id, seq);

ALTER TABLE speech_attempts DROP CONSTRAINT sa_place_ck;
ALTER TABLE speech_attempts ADD CONSTRAINT sa_place_ck
    CHECK (place IN ('review', 'meaning', 'decision', 'episode_end', 'grammar', 'talk'));
