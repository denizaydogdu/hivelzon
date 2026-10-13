package tr.velzon.hivelzon.learning;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import tr.velzon.hivelzon.common.security.CurrentUser;

@RestController
@RequestMapping("/api/v1/review")
class ReviewController {

    private final ReviewService reviews;

    ReviewController(ReviewService reviews) {
        this.reviews = reviews;
    }

    @PostMapping("/rate")
    ReviewService.RateResponse rate(@AuthenticationPrincipal Jwt jwt, @RequestBody ReviewService.RateRequest body) {
        return reviews.rate(CurrentUser.from(jwt).id(), body);
    }
}
