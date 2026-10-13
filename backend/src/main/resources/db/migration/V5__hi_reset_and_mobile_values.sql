-- H-038 (mobil entegrasyonu): sözleşme düzeltmeleri.
--   * hi_records: mobilin "hunt_done" türü (H-051, sahne avı tamamlandı) eşitlenebilsin.
--   * hi_records: "Hi'nin kayıtlarını sil" bütün cihazlarda geçerli olsun diye silme işareti satırı
--     (kind = 'hi_reset', ref_id = 'all', status = 'cleared', updated_at = silme anı). İşaret itilince sunucu
--     o ana kadarki öğrenme olaylarını, "Söyle" sonuçlarını, yan görev ve not kayıtlarını siler (HiResetHook);
--     işaret çekmeyle öteki cihazlara gider, onlar da kendi yerel kayıtlarını siler.
--   * notebook_items: mobilin "topic_set" kaynağı (H-051, konu setinden eklenen ifade).
ALTER TABLE hi_records DROP CONSTRAINT hr_kind_ck;
ALTER TABLE hi_records ADD CONSTRAINT hr_kind_ck
    CHECK (kind IN ('topic_intro', 'bridge_task', 'note_read', 'hunt_done', 'hi_reset'));
ALTER TABLE hi_records DROP CONSTRAINT hr_status_ck;
ALTER TABLE hi_records ADD CONSTRAINT hr_status_ck
    CHECK (status IN ('seen', 'done', 'dismissed', 'read', 'cleared'));
ALTER TABLE notebook_items DROP CONSTRAINT ni_source_ck;
ALTER TABLE notebook_items ADD CONSTRAINT ni_source_ck
    CHECK (source IN ('auto_target_phrase', 'user_saved', 'lookup', 'topic_set'));
