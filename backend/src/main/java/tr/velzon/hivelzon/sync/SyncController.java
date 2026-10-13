package tr.velzon.hivelzon.sync;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import tools.jackson.databind.JsonNode;
import tr.velzon.hivelzon.common.security.CurrentUser;

@RestController
@RequestMapping("/api/v1/sync")
class SyncController {

    private final SyncService sync;

    SyncController(SyncService sync) {
        this.sync = sync;
    }

    @PostMapping("/push")
    SyncDtos.PushResponse push(@AuthenticationPrincipal Jwt jwt, @RequestBody JsonNode body) {
        return sync.push(CurrentUser.from(jwt).id(), body);
    }

    @GetMapping("/pull")
    SyncDtos.PullResponse pull(@AuthenticationPrincipal Jwt jwt, @RequestParam(required = false) Long since,
            @RequestParam(required = false) Integer limit) {
        return sync.pull(CurrentUser.from(jwt).id(), since, limit);
    }

    @DeleteMapping("/speech-attempts")
    ResponseEntity<Void> clearSpeech(@AuthenticationPrincipal Jwt jwt) {
        sync.clearSpeechAttempts(CurrentUser.from(jwt).id());
        return ResponseEntity.noContent().build();
    }
}
