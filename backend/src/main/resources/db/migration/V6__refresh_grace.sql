-- H-056: yenileme belirtecine kısa hoşgörü (varsayılan 30 sn).
-- Dönen (kullanılmış) belirtecin satırında halefin kimliği ve halef belirtecin sunucu anahtarıyla
-- şifrelenmiş (AES-GCM) değeri tutulur; pencere geçince ya da aile iptal edilince silinir.
ALTER TABLE refresh_tokens ADD COLUMN successor_id uuid;
ALTER TABLE refresh_tokens ADD COLUMN successor_token_enc varchar(256);
CREATE INDEX refresh_tokens_grace_ix ON refresh_tokens (used_at) WHERE successor_token_enc IS NOT NULL;
