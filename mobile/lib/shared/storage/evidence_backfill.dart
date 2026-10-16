import '../sync/sync_schema.dart';
import 'app_database.dart';

/// Şema → 10 (H-089): kanıt basamaklarını eski tekrar cevaplarından doldurur.
/// İdempotent (`INSERT OR IGNORE`); her basamağın ilk anı yazılır.
///
/// Eski cevaplarda kartın o anki durumu yoktur; kurallar bu yüzden
/// yaklaşıktır (`docs/KELIME-TEKRARI.md` §3.3):
/// - yardımla yaptı: doğru pratik cevabı (seç, dinle-seç, diz, dinle ve
///   söyle, sahne avı);
/// - kendi kullandı: doğru yazma (`type`) cevabı;
/// - sonra hatırladı: doğru yazma ya da kendini yoklama cevabı; ifade en az
///   2 gün önce eklenmiş ve aynı kartın en az 1 gün önce başka cevabı var
///   (aralıklı tekrar).
///
/// Hesap açıksa yazılan satırlar eşitleme kuyruğuna da alınır (tetikleyici
/// geçişten sonra kurulur).
Future<void> backfillEvidence(AppDatabase db) async {
  const practice =
      "('picture_choice', 'listen_choice', 'arrange', 'speak', 'scene_hunt')";
  String insert(String stage, String where) =>
      'INSERT OR IGNORE INTO expression_evidence (item_key, stage, at) '
      "SELECT ni.item_key, '$stage', MIN(rl.reviewed_at) FROM review_logs rl "
      'JOIN review_cards rc ON rc.id = rl.card_id '
      'JOIN notebook_items ni ON ni.id = rc.item_id '
      'WHERE rl.correct = 1 AND $where GROUP BY ni.item_key';
  await db.customStatement(insert('helped', 'rl.task_type IN $practice'));
  await db.customStatement(
    insert('own_use', "rl.rating >= 2 AND rl.task_type = 'type'"),
  );
  await db.customStatement(
    insert(
      'recalled_later',
      "rl.rating >= 2 AND rl.task_type IN ('type', 'self_check') "
          'AND julianday(rl.reviewed_at) >= julianday(ni.created_at) + 2 '
          'AND EXISTS (SELECT 1 FROM review_logs p WHERE p.card_id = rl.card_id '
          'AND julianday(p.reviewed_at) <= julianday(rl.reviewed_at) - 1)',
    ),
  );
  await db.customStatement(
    'INSERT OR IGNORE INTO sync_outbox '
    '(tbl, k1, k2, k3, deleted, rev, changed_at, blocked) '
    "SELECT 'expression_evidence', item_key, stage, '', 0, 1, ${SyncSql.now}, 0 "
    'FROM expression_evidence WHERE ${SyncSql.tracked}',
  );
}
