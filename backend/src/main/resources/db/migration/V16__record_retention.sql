-- H-095: rıza ve denetim kayıtlarının 2 yıl saklanması (hukukçu cevabı 2026-10-21, docs/HUKUK-SORULARI.md).
--
-- Önce: kalıcı silmede rızalar silinir, denetim satırlarında kimlik/IP/port boşaltılırdı.
-- Şimdi: kalıcı silmede ikisi de kalır (ispat: metin sürümü, saat, IP, port). Hesabın eski kimliği
-- (UUID) "mezar taşı" olarak kalır; e-posta, ad ve doğum yılı silindiği için kişiyle bağ kurulamaz.
-- Süre dolunca zamanlanmış temizlik (RecordRetentionJob) siler:
--   - rızalar: hesap kalıcı silindikten 2 yıl sonra (etkin hesabın rızası güncel ispattır, silinmez);
--   - denetim satırları: olay tarihinden 2 yıl sonra.

-- Kullanıcı satırı silinince rızalar kalır: yabancı anahtar kaldırılır. Yeni rıza yalnızca etkin hesaba
-- yazılır (ConsentService → requireActive; kayıtta aynı işlemde oluşturulan hesap).
ALTER TABLE consents DROP CONSTRAINT consents_user_id_fkey;

-- Kalıcı silinen hesabın eski kimliği ve silinme anı. Rızaların saklama süresi buradan sayılır;
-- süre dolunca rızalarla birlikte silinir. Kişisel veri içermez.
CREATE TABLE account_tombstones (
    user_id   uuid        PRIMARY KEY,
    purged_at timestamptz NOT NULL
);
CREATE INDEX account_tombstones_purged_ix ON account_tombstones (purged_at);

-- Rıza tablosu yalnızca ekleme olarak kalır (V2 tetikleyicileri). Silme yalnızca saklama süresi dolan
-- satırların temizliğinde, aynı işlemde hivelzon.allow_consent_purge = 'on' iken yapılabilir.
COMMENT ON TABLE consents IS
    'Yalnızca ekleme. Kalıcı silinen hesabın rızaları account_tombstones.purged_at + 2 yıl saklanır (H-095).';
COMMENT ON TABLE audit_log IS
    'Denetim kaydı (IP/port/saat). Olay tarihinden 2 yıl saklanır; hesap silinince boşaltılmaz (H-095).';
