-- H-037 Bölüm 1: kimlik çekirdeği.
-- Parolasız e-posta kodu (OTP), kullanıcı, yenileme belirteçleri, rızalar (yalnızca ekleme),
-- denetim kaydı ve hız sınırı sayaçları. Bütün zamanlar UTC (timestamptz).

-- Kullanıcı. Yalnızca gerekli veri: e-posta (küçük harf), isteğe bağlı görünen ad, doğum yılı.
CREATE TABLE users (
    id                    uuid         PRIMARY KEY,
    email                 varchar(254) NOT NULL,
    display_name          varchar(40),
    birth_year            integer      NOT NULL,
    role                  varchar(16)  NOT NULL DEFAULT 'USER',
    status                varchar(24)  NOT NULL DEFAULT 'ACTIVE',
    created_at            timestamptz  NOT NULL,
    updated_at            timestamptz  NOT NULL,
    last_login_at         timestamptz,
    deletion_requested_at timestamptz,
    scheduled_purge_at    timestamptz,
    CONSTRAINT users_email_uk UNIQUE (email),
    CONSTRAINT users_email_lowercase_ck CHECK (email = lower(email)),
    CONSTRAINT users_birth_year_ck CHECK (birth_year BETWEEN 1900 AND 2100),
    CONSTRAINT users_role_ck CHECK (role IN ('USER', 'EDITOR', 'ADMIN')),
    CONSTRAINT users_status_ck CHECK (status IN ('ACTIVE', 'PENDING_DELETION', 'SUSPENDED')),
    CONSTRAINT users_pending_deletion_ck CHECK (
        (status = 'PENDING_DELETION') = (scheduled_purge_at IS NOT NULL AND deletion_requested_at IS NOT NULL))
);

-- Silme işi yalnızca süresi gelen PENDING_DELETION hesaplarını tarar.
CREATE INDEX users_purge_due_ix ON users (scheduled_purge_at) WHERE status = 'PENDING_DELETION';

-- Tek kullanımlık giriş kodu. E-posta ve kod düz metin tutulmaz: ikisi de sunucu anahtarıyla HMAC-SHA256.
-- E-posta başına tek etkin kod vardır; yeni istek eskisinin yerine geçer.
CREATE TABLE otp_challenges (
    email_key  varchar(64) PRIMARY KEY,
    code_hash  varchar(64) NOT NULL,
    attempts   integer     NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL,
    expires_at timestamptz NOT NULL,
    CONSTRAINT otp_attempts_ck CHECK (attempts >= 0)
);
CREATE INDEX otp_challenges_expires_ix ON otp_challenges (expires_at);

-- Yenileme belirteci: opak, yalnızca SHA-256 özeti tutulur. Aynı aile (family_id) bir cihaz oturumudur;
-- kullanılmış bir belirteç yeniden gelirse bütün aile iptal edilir.
CREATE TABLE refresh_tokens (
    id          uuid        PRIMARY KEY,
    user_id     uuid        NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    family_id   uuid        NOT NULL,
    token_hash  varchar(64) NOT NULL,
    device_name varchar(64),
    auth_time   timestamptz NOT NULL,
    created_at  timestamptz NOT NULL,
    expires_at  timestamptz NOT NULL,
    used_at     timestamptz,
    revoked_at  timestamptz,
    CONSTRAINT refresh_tokens_hash_uk UNIQUE (token_hash)
);
CREATE INDEX refresh_tokens_user_ix ON refresh_tokens (user_id);
CREATE INDEX refresh_tokens_family_ix ON refresh_tokens (family_id);
CREATE INDEX refresh_tokens_expires_ix ON refresh_tokens (expires_at);

-- Rızalar: yalnızca ekleme. Güncel durum, türün en son satırıdır.
CREATE TABLE consents (
    id               bigint      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id          uuid        NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    consent_type     varchar(32) NOT NULL,
    document_version varchar(32) NOT NULL,
    granted          boolean     NOT NULL,
    created_at       timestamptz NOT NULL,
    ip               varchar(45),
    port             integer,
    CONSTRAINT consents_type_ck CHECK (consent_type IN ('TERMS', 'PRIVACY_NOTICE', 'MARKETING'))
);
CREATE INDEX consents_user_type_at_ix ON consents (user_id, consent_type, created_at DESC);

-- Rıza satırı güncellenmez. Silme yalnızca hesap kalıcı silinirken (aynı işlemde
-- hivelzon.allow_consent_purge = 'on' iken) yapılabilir.
CREATE FUNCTION consents_append_only() RETURNS trigger
    LANGUAGE plpgsql AS
$$
BEGIN
    IF TG_OP IN ('DELETE', 'TRUNCATE')
       AND coalesce(current_setting('hivelzon.allow_consent_purge', true), '') = 'on' THEN
        RETURN NULL;
    END IF;
    RAISE EXCEPTION 'consents is append-only (%)', TG_OP USING ERRCODE = 'P0001';
END;
$$;

CREATE FUNCTION consents_allow_delete() RETURNS trigger
    LANGUAGE plpgsql AS
$$
BEGIN
    IF coalesce(current_setting('hivelzon.allow_consent_purge', true), '') = 'on' THEN
        RETURN OLD;
    END IF;
    RAISE EXCEPTION 'consents is append-only (DELETE)' USING ERRCODE = 'P0001';
END;
$$;

CREATE TRIGGER consents_no_update
    BEFORE UPDATE ON consents
    FOR EACH ROW EXECUTE FUNCTION consents_append_only();

CREATE TRIGGER consents_no_delete
    BEFORE DELETE ON consents
    FOR EACH ROW EXECUTE FUNCTION consents_allow_delete();

CREATE TRIGGER consents_no_truncate
    BEFORE TRUNCATE ON consents
    FOR EACH STATEMENT EXECUTE FUNCTION consents_append_only();

-- Denetim kaydı (IP/port/saat). E-posta, kod, belirteç yazılmaz. Kullanıcıya yabancı anahtar yoktur:
-- hesap kalıcı silinince satırlar anonimleştirilerek kalır.
CREATE TABLE audit_log (
    id              bigint      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    actor_user_id   uuid,
    action          varchar(48) NOT NULL,
    at              timestamptz NOT NULL,
    ip              varchar(45),
    port            integer,
    user_agent_hash varchar(64),
    request_id      varchar(64),
    detail          varchar(64)
);
CREATE INDEX audit_log_at_ix ON audit_log (at);
CREATE INDEX audit_log_actor_at_ix ON audit_log (actor_user_id, at) WHERE actor_user_id IS NOT NULL;

-- Hız sınırı: sabit pencereli sayaç. Anahtar, e-posta ya da IP'nin HMAC özetidir.
CREATE TABLE rate_limit_buckets (
    bucket_key   varchar(80) NOT NULL,
    window_start timestamptz NOT NULL,
    hits         integer     NOT NULL,
    PRIMARY KEY (bucket_key, window_start)
);
CREATE INDEX rate_limit_buckets_window_ix ON rate_limit_buckets (window_start);
