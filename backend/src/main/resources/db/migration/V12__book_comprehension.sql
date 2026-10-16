-- H-091: Kitap sonu anlama. Mobil Drift şema 9 aynası.
--   * user_book_comprehension: kitap başına anlama sonucu, kitap ilerlemesinden (user_book_progress) ayrı.
--     Yalnızca sayılar ve öz değerlendirme: cevaplanan soru (0–2), ilk denemede doğru (0–2), yeniden anlatma
--     yapıldı mı ve öz değerlendirme (all / some / not_yet). Kullanıcının yazdığı yeniden anlatma metni hiçbir
--     zaman gelmez. Değişebilir, doğal anahtar book_id; düz son yazan kazanır.

CREATE TABLE user_book_comprehension (
    user_id           uuid             NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    client_id         uuid             NOT NULL,
    seq               bigint           NOT NULL,
    server_updated_at timestamptz      NOT NULL,
    updated_at        timestamptz      NOT NULL,
    deleted           boolean          NOT NULL DEFAULT false,
    book_id           varchar(16)      NOT NULL,
    content_version   integer,
    answered          integer,
    first_try_correct integer,
    retell_done       boolean,
    self_check        varchar(16),
    completed_at      timestamptz,
    PRIMARY KEY (user_id, client_id),
    CONSTRAINT ubc_natural_uk UNIQUE (user_id, book_id),
    CONSTRAINT ubc_answered_ck CHECK (answered BETWEEN 0 AND 2),
    CONSTRAINT ubc_first_try_ck CHECK (first_try_correct BETWEEN 0 AND 2),
    CONSTRAINT ubc_self_check_ck CHECK (self_check IN ('all', 'some', 'not_yet'))
);
CREATE INDEX ubc_user_seq_ix ON user_book_comprehension (user_id, seq);
