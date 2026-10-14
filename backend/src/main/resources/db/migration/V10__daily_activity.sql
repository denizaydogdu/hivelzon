-- H-074: Günlük hedef için ölçülen öğrenme süresi. Mobil Drift şema 8 aynası.
--   * daily_activity: (yerel gün, kaynak) başına toplam etkin süre (sn). Yalnızca günlük toplam tutulur; hangi
--     ekranda ya da saatte geçtiği yazılmaz. source_id kurulumun rastgele kimliğidir (eşitleme deviceId'si değil);
--     her satırı yalnız kendi cihazı yazar, günün toplamı satırların toplamıdır. Değişebilir, düz LWW.

CREATE TABLE daily_activity (
    user_id           uuid             NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    client_id         uuid             NOT NULL,
    seq               bigint           NOT NULL,
    server_updated_at timestamptz      NOT NULL,
    updated_at        timestamptz      NOT NULL,
    deleted           boolean          NOT NULL DEFAULT false,
    day               varchar(10)      NOT NULL,
    source_id         varchar(36)      NOT NULL,
    active_seconds    integer,
    PRIMARY KEY (user_id, client_id),
    CONSTRAINT da_natural_uk UNIQUE (user_id, day, source_id),
    CONSTRAINT da_seconds_ck CHECK (active_seconds BETWEEN 0 AND 86400)
);
CREATE INDEX da_user_seq_ix ON daily_activity (user_id, seq);
