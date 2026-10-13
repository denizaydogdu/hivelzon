package tr.velzon.hivelzon.progress;

import static tr.velzon.hivelzon.sync.SyncField.bool;
import static tr.velzon.hivelzon.sync.SyncField.instant;
import static tr.velzon.hivelzon.sync.SyncField.integer;
import static tr.velzon.hivelzon.sync.SyncField.jsonArray;
import static tr.velzon.hivelzon.sync.SyncField.jsonObject;
import static tr.velzon.hivelzon.sync.SyncField.oneOf;
import static tr.velzon.hivelzon.sync.SyncField.string;

import java.util.List;

import org.springframework.stereotype.Component;

import tr.velzon.hivelzon.sync.SyncField;
import tr.velzon.hivelzon.sync.SyncTable;
import tr.velzon.hivelzon.sync.SyncTable.Kind;
import tr.velzon.hivelzon.sync.SyncTableProvider;

/**
 * Hikâye ilerlemesi tabloları (mobil Drift şema 4 aynası): bölüm ilerlemesi, kalıcı bayraklar, bölüm kapısı,
 * sezon durumu, ipuçları ve bölüm bağları. Hepsi doğal anahtarlıdır.
 */
@Component
public class ProgressSyncTables implements SyncTableProvider {

    static final SyncField CONTENT_ID = string("contentId", "content_id", true, 32);
    static final SyncField UPDATED_AT = instant("updatedAt", "updated_at", true);

    @Override
    public List<SyncTable> syncTables() {
        return List.of(
                new SyncTable("user_story_progress", 10, Kind.MUTABLE, List.of(CONTENT_ID), UPDATED_AT, List.of(
                        oneOf("status", "status", true, "NOT_STARTED", "IN_PROGRESS", "COMPLETED"),
                        string("lastCheckpointNodeId", "last_checkpoint_node_id", false, 64),
                        jsonObject("checkpointSnapshot", "checkpoint_snapshot", false, 32_768),
                        instant("startedAt", "started_at", false),
                        instant("completedAt", "completed_at", false))),
                new SyncTable("user_story_flags", 20, Kind.MUTABLE,
                        List.of(CONTENT_ID, string("flag", "flag", true, 64)), UPDATED_AT,
                        List.of(string("value", "value", true, 64))),
                new SyncTable("gate_progress", 30, Kind.APPEND_ONLY,
                        List.of(CONTENT_ID, oneOf("itemKind", "item_kind", true, "comprehension", "targetPhrase",
                                "activeTask"), string("nodeId", "node_id", true, 64)),
                        null, List.of(instant("recordedAt", "recorded_at", true))),
                new SyncTable("season_state", 40, Kind.MUTABLE,
                        List.of(integer("seasonId", "season_id", true, 1, 999)), UPDATED_AT,
                        List.of(bool("introSeen", "intro_seen", true), instant("introSeenAt", "intro_seen_at", false))),
                new SyncTable("clues", 50, Kind.APPEND_ONLY,
                        List.of(CONTENT_ID, string("clueId", "clue_id", true, 32)), null, List.of(
                        string("textTr", "text_tr", true, 500),
                        string("textEn", "text_en", false, 500),
                        instant("unlockedAt", "unlocked_at", true))),
                new SyncTable("story_links", 60, Kind.MUTABLE, List.of(CONTENT_ID),
                        instant("recordedAt", "recorded_at", true), List.of(
                        integer("number", "number", true, 0, 999),
                        string("openQuestionId", "open_question_id", true, 32),
                        string("openQuestionTr", "open_question_tr", false, 500),
                        jsonArray("answers", "answers", true, 4_096),
                        jsonObject("partialNotes", "partial_notes", false, 4_096))));
    }
}
