-- H-041: editör onayı. Onay durumu veritabanında yaşar (H-037 kullanıcı kararı); içe aktarma yalnızca paket
-- bilgisini (başlık, manifest, boyutlar, lint sonucu) yazar, durum ve yayın zamanı kolonlarına dokunmaz.
-- Geçiş geçmişi audit_log'dadır (CONTENT_* eylemleri, kişisel veri yok).

ALTER TABLE content_items
    -- İçe aktarılan lint özeti (content-lint --write-reports → <bölüm>/_build/lint.json). NULL = rapor yok
    -- ya da paketten eski; bu durumda onay verilemez.
    ADD COLUMN lint_errors          integer,
    ADD COLUMN lint_warnings        integer,
    ADD COLUMN lint_checked_at      timestamptz,
    -- ceviri.tr.json → status (APPROVED / DRAFT …); dosya yoksa NULL.
    ADD COLUMN translation_status   varchar(16),
    -- Editoryal durum bilgisi (kim, ne zaman). Kullanıcıya yabancı anahtar yok: kalıcı silmede boşaltılır
    -- (EditorialService → UserDataPurger).
    ADD COLUMN status_changed_at    timestamptz,
    ADD COLUMN status_changed_by    uuid,
    ADD COLUMN approved_at          timestamptz,
    ADD COLUMN approved_by          uuid,
    -- Onay kontrol listesi (sabit anahtarlar, yalnız true/false) ve özeti; onaylanan paketin manifest özeti.
    ADD COLUMN approval_checklist   jsonb,
    ADD COLUMN checklist_sha256     varchar(64),
    ADD COLUMN approved_manifest_sha256 varchar(64),
    -- Kaldırma gerekçesi: sabit kod (serbest metin yok).
    ADD COLUMN withdraw_reason      varchar(24),
    -- İyimser kilit: her geçiş 1 artırır; istemci beklediği değeri gönderir.
    ADD COLUMN lock_version         bigint NOT NULL DEFAULT 0;

-- H-037 içe aktarması content.json'a göre APPROVED/SCHEDULED/PUBLISHED yazmış olabilir; onay kaydı
-- olmayan bu satırlar artık geçerli değil: editör ekranından yeniden onaylanmak üzere IN_REVIEW'e döner.
UPDATE content_items SET status = 'IN_REVIEW', publish_at = NULL
 WHERE status IN ('APPROVED', 'SCHEDULED', 'PUBLISHED');
UPDATE content_items SET withdraw_reason = 'OTHER' WHERE status = 'WITHDRAWN';

ALTER TABLE content_items
    ADD CONSTRAINT content_items_lint_ck CHECK (
        (lint_errors IS NULL AND lint_warnings IS NULL)
        OR (lint_errors >= 0 AND lint_warnings >= 0 AND lint_checked_at IS NOT NULL)),
    ADD CONSTRAINT content_items_withdraw_reason_ck CHECK (
        (status = 'WITHDRAWN') = (withdraw_reason IS NOT NULL)
        AND (withdraw_reason IS NULL OR withdraw_reason IN ('COPYRIGHT', 'CONTENT_ERROR', 'SAFETY', 'OTHER'))),
    -- APPROVED / SCHEDULED / PUBLISHED onay kaydı ister (ne zaman, kontrol listesi) ve paket onaylanan
    -- paketle aynı olmalı: onaydan sonra paket değişemez, değişiklik yeni sürümdür.
    ADD CONSTRAINT content_items_approval_ck CHECK (
        status NOT IN ('APPROVED', 'SCHEDULED', 'PUBLISHED')
        OR (approved_at IS NOT NULL AND checklist_sha256 IS NOT NULL
            AND approved_manifest_sha256 = manifest_sha256)),
    ADD CONSTRAINT content_items_checklist_sha_ck CHECK (checklist_sha256 IS NULL OR checklist_sha256 ~ '^[0-9a-f]{64}$');

-- Onay ekranı listesi: sezon + sıra + sürüm (content_items_season_number_ix yeterli). Denetim geçmişi:
-- ayrıntı önekiyle ("A1-001:v1:") aranır.
CREATE INDEX audit_log_content_ix ON audit_log (detail varchar_pattern_ops) WHERE action LIKE 'CONTENT\_%';
