package tr.velzon.hivelzon.learning;

import static tr.velzon.hivelzon.sync.SyncField.bool;
import static tr.velzon.hivelzon.sync.SyncField.decimal;
import static tr.velzon.hivelzon.sync.SyncField.instant;
import static tr.velzon.hivelzon.sync.SyncField.integer;
import static tr.velzon.hivelzon.sync.SyncField.oneOf;
import static tr.velzon.hivelzon.sync.SyncField.string;
import static tr.velzon.hivelzon.sync.SyncField.uuid;

import java.util.List;

import org.springframework.stereotype.Component;

import tr.velzon.hivelzon.sync.SyncField;
import tr.velzon.hivelzon.sync.SyncTable;
import tr.velzon.hivelzon.sync.SyncTable.Kind;
import tr.velzon.hivelzon.sync.SyncTableProvider;

/**
 * Öğrenme tabloları (mobil Drift şema 4 aynası): defter, FSRS kartı ve cevapları, öğrenme olayları, Hi kayıtları
 * ve "Söyle" sonuçları. Defter ve kart doğal anahtarlı ({@code itemKey}); cevap, olay ve "Söyle" sonucu cihazın
 * verdiği UUID ile tekildir.
 */
@Component
public class LearningSyncTables implements SyncTableProvider {

    public static final String NOTEBOOK_ITEMS = "notebook_items";
    public static final String REVIEW_CARDS = "review_cards";
    public static final String REVIEW_LOGS = "review_logs";
    public static final String HI_RECORDS = "hi_records";

    /** Sahne avı tamamlanan konu seti (mobil H-051). */
    public static final String HUNT_DONE = "hunt_done";

    /**
     * "Hi'nin kayıtlarını sil" işareti (H-038): {@code kind = hi_reset}, {@code refId = all}, {@code status =
     * cleared}, {@code updatedAt} = silme anı. Bkz. {@link HiResetHook}.
     */
    public static final String HI_RESET = "hi_reset";

    /** Mobil {@code TaskType.code} değerleri. */
    public static final String[] TASK_TYPES = {"picture_choice", "listen_choice", "arrange", "type", "self_check",
            "scene_hunt", "speak"};

    static final SyncField ITEM_KEY = string("itemKey", "item_key", true, 320);
    static final SyncField UPDATED_AT = instant("updatedAt", "updated_at", true);

    @Override
    public List<SyncTable> syncTables() {
        return List.of(
                new SyncTable(NOTEBOOK_ITEMS, 100, Kind.MUTABLE, List.of(ITEM_KEY), UPDATED_AT, List.of(
                        oneOf("kind", "kind", true, "word", "phrase", "sentence"),
                        string("textEn", "text_en", true, 300),
                        string("textTr", "text_tr", false, 300),
                        string("exampleEn", "example_en", false, 500),
                        string("exampleTr", "example_tr", false, 500),
                        string("contentId", "content_id", false, 32),
                        string("cueId", "cue_id", false, 64),
                        string("imagePath", "image_path", false, 200),
                        string("imageCrop", "image_crop", false, 64),
                        string("audioPath", "audio_path", false, 200),
                        decimal("audioStart", "audio_start", false),
                        decimal("audioEnd", "audio_end", false),
                        decimal("exampleStart", "example_start", false),
                        decimal("exampleEnd", "example_end", false),
                        oneOf("source", "source", true, "auto_target_phrase", "user_saved", "lookup", "topic_set"),
                        instant("createdAt", "created_at", true))),
                new SyncTable(REVIEW_CARDS, 110, Kind.MUTABLE, List.of(ITEM_KEY), UPDATED_AT, List.of(
                        integer("state", "state", true, 1, 3),
                        integer("step", "step", false, 0, 100),
                        decimal("stability", "stability", false),
                        decimal("difficulty", "difficulty", false),
                        instant("due", "due", true),
                        integer("reps", "reps", true, 0, 1_000_000),
                        integer("lapses", "lapses", true, 0, 1_000_000),
                        instant("lastReview", "last_review", false))),
                new SyncTable(REVIEW_LOGS, 120, Kind.APPEND_ONLY, List.of(), null, List.of(
                        uuid("cardClientId", "card_client_id", true),
                        integer("rating", "rating", true, 1, 4),
                        instant("reviewedAt", "reviewed_at", true),
                        oneOf("taskType", "task_type", false, TASK_TYPES),
                        bool("correct", "correct", false),
                        bool("dontKnow", "dont_know", true),
                        integer("durationMs", "duration_ms", false, 0, 86_400_000),
                        bool("wasNew", "was_new", true))),
                new SyncTable("learning_events", 130, Kind.APPEND_ONLY, List.of(), null, List.of(
                        string("contentId", "content_id", true, 32),
                        string("sourceId", "source_id", true, 64),
                        string("target", "target", true, 300),
                        instant("at", "at", true),
                        string("errorType", "error_type", false, 64),
                        integer("errorTaxonomyVersion", "error_taxonomy_version", false, 1, 1000))),
                new SyncTable(HI_RECORDS, 140, Kind.MUTABLE,
                        List.of(oneOf("kind", "kind", true, "topic_intro", "bridge_task", "note_read", HUNT_DONE,
                                HI_RESET),
                                string("refId", "ref_id", true, 64)),
                        UPDATED_AT,
                        List.of(oneOf("status", "status", true, "seen", "done", "dismissed", "read", "cleared"))),
                // H-055: yalnızca sonuç. Ses ve tanıma yazısı alanı yoktur; gönderilirse reddedilir.
                new SyncTable("speech_attempts", 150, Kind.APPEND_ONLY, List.of(), null, List.of(
                        oneOf("place", "place", true, "review", "meaning", "decision", "episode_end"),
                        string("contentId", "content_id", false, 32),
                        string("itemRef", "item_ref", true, 300),
                        oneOf("matchLevel", "match_level", true, "full", "close", "no"),
                        integer("missingCount", "missing_count", true, 0, 100),
                        string("errorNoteId", "error_note_id", false, 64),
                        instant("at", "at", true))));
    }
}
