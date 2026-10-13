-- H-037 Bölüm 2: içerik kataloğu (K-05 durumları, K-12 içerik kod olarak → içe aktarma, K-13 VideoHostingPort).
-- Medya veritabanında tutulmaz; yalnızca paketin yeri (package_base_path) ve bütünlük özeti (manifest sha256).

CREATE TABLE content_items (
    id                bigint       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    content_id        varchar(32)  NOT NULL,
    content_version   integer      NOT NULL,
    slug              varchar(80),
    season            integer      NOT NULL,
    number            integer      NOT NULL,
    level             varchar(2)   NOT NULL,
    title             varchar(200) NOT NULL,
    status            varchar(16)  NOT NULL DEFAULT 'DRAFT',
    publish_at        timestamptz,
    package_base_path varchar(200) NOT NULL,
    manifest_sha256   varchar(64)  NOT NULL,
    total_bytes       bigint,
    rendition_bytes   jsonb,
    estimated_minutes integer,
    imported_at       timestamptz  NOT NULL,
    updated_at        timestamptz  NOT NULL,
    CONSTRAINT content_items_id_version_uk UNIQUE (content_id, content_version),
    CONSTRAINT content_items_content_id_ck CHECK (content_id ~ '^(A1|A2|B1|B2|C1)-[0-9]{3}$'),
    CONSTRAINT content_items_version_ck CHECK (content_version >= 1),
    CONSTRAINT content_items_season_ck CHECK (season >= 1 AND number >= 0),
    CONSTRAINT content_items_level_ck CHECK (level IN ('A1', 'A2', 'B1', 'B2', 'C1')),
    CONSTRAINT content_items_status_ck CHECK (status IN
        ('DRAFT', 'IN_REVIEW', 'APPROVED', 'SCHEDULED', 'PUBLISHED', 'ARCHIVED', 'WITHDRAWN')),
    CONSTRAINT content_items_sha_ck CHECK (manifest_sha256 ~ '^[0-9a-f]{64}$'),
    -- Zamanlanmış içerik yayın tarihi ister.
    CONSTRAINT content_items_scheduled_ck CHECK (status <> 'SCHEDULED' OR publish_at IS NOT NULL)
);
-- Açık liste: sezon + sıra; görünürlük süzgeci: durum + yayın tarihi.
CREATE INDEX content_items_season_number_ix ON content_items (season, number, content_version DESC);
CREATE INDEX content_items_visible_ix ON content_items (status, publish_at)
    WHERE status IN ('PUBLISHED', 'APPROVED', 'SCHEDULED');

-- Sezon paketi (season.json): başlık, jenerik, harita ve bölüm yerleri. descriptor = season.json'un
-- uygulamaya dönen alt kümesi (dosya listesi hariç).
CREATE TABLE catalog_seasons (
    season            integer      PRIMARY KEY,
    title             varchar(200) NOT NULL,
    level             varchar(2)   NOT NULL,
    package_base_path varchar(200) NOT NULL,
    descriptor        jsonb        NOT NULL,
    descriptor_sha256 varchar(64)  NOT NULL,
    imported_at       timestamptz  NOT NULL,
    updated_at        timestamptz  NOT NULL,
    CONSTRAINT catalog_seasons_season_ck CHECK (season >= 1),
    CONSTRAINT catalog_seasons_level_ck CHECK (level IN ('A1', 'A2', 'B1', 'B2', 'C1'))
);
