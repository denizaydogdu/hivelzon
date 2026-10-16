-- H-089: Öğrenme kanıtı basamakları. Mobil Drift şema 10 aynası.
--   * expression_evidence: ifade (defterdeki item_key) ve basamak başına ilk ulaşılan an. Basamaklar:
--     helped (yardımla yaptı), own_use (kendi kullandı), recalled_later (birkaç gün sonra hatırladı). "Gördü"
--     saklanmaz (defterdeki ifadenin eklenme anı). İçerik metni (anahtar dışında), ses ve tanıma yazısı yok.
--     Yalnız eklenir; doğal anahtar (item_key, stage). Kurallar: docs/KELIME-TEKRARI.md §3.
--   * review_logs.task_type: yeni değer speak_recall (sesi duymadan söyleme, hatırlama). Kolonda CHECK yok;
--     izinli değerler LearningSyncTables.TASK_TYPES'tadır.

CREATE TABLE expression_evidence (
    user_id           uuid         NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    client_id         uuid         NOT NULL,
    seq               bigint       NOT NULL,
    server_updated_at timestamptz  NOT NULL,
    item_key          varchar(320) NOT NULL,
    stage             varchar(16)  NOT NULL,
    at                timestamptz  NOT NULL,
    PRIMARY KEY (user_id, client_id),
    CONSTRAINT ee_natural_uk UNIQUE (user_id, item_key, stage),
    CONSTRAINT ee_stage_ck CHECK (stage IN ('helped', 'own_use', 'recalled_later'))
);
CREATE INDEX ee_user_seq_ix ON expression_evidence (user_id, seq);
