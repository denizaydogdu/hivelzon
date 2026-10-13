package tr.velzon.hivelzon.common.web;

import java.net.URI;

import jakarta.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.HttpMediaTypeNotSupportedException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.HandlerMethodValidationException;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.web.servlet.resource.NoResourceFoundException;

/**
 * Bütün hatalar RFC 9457 ProblemDetail olarak döner: {@code code} (makine), {@code detail} (Türkçe, güvenli),
 * {@code requestId}. İstemciye stack trace ya da iç mesaj dönmez. Loga yalnızca hata türü ve istek kimliği
 * yazılır; istisna mesajları kişisel veri (ör. e-posta) içerebileceği için loglanmaz.
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    public static ResponseEntity<ProblemDetail> problem(ErrorCode code, HttpServletRequest request) {
        ProblemDetail body = ProblemDetail.forStatusAndDetail(code.status(), code.detail());
        body.setType(URI.create("urn:hivelzon:problem:" + code.name()));
        body.setTitle(code.name());
        if (request != null) {
            body.setInstance(URI.create(request.getRequestURI()));
        }
        body.setProperty("code", code.name());
        String requestId = MDC.get("requestId");
        if (requestId != null) {
            body.setProperty("requestId", requestId);
        }
        return ResponseEntity.status(code.status()).body(body);
    }

    @ExceptionHandler(ApiException.class)
    ResponseEntity<ProblemDetail> api(ApiException ex, HttpServletRequest request) {
        ResponseEntity<ProblemDetail> response = problem(ex.code(), request);
        if (ex.retryAfter() != null) {
            return ResponseEntity.status(response.getStatusCode())
                    .header(HttpHeaders.RETRY_AFTER, Long.toString(Math.max(1, ex.retryAfter().toSeconds())))
                    .body(response.getBody());
        }
        return response;
    }

    @ExceptionHandler({MethodArgumentNotValidException.class, HandlerMethodValidationException.class,
            HttpMessageNotReadableException.class, MissingServletRequestParameterException.class,
            MethodArgumentTypeMismatchException.class, HttpMediaTypeNotSupportedException.class})
    ResponseEntity<ProblemDetail> validation(Exception ex, HttpServletRequest request) {
        return problem(ErrorCode.VALIDATION_FAILED, request);
    }

    @ExceptionHandler({NoHandlerFoundException.class, NoResourceFoundException.class})
    ResponseEntity<ProblemDetail> notFound(Exception ex, HttpServletRequest request) {
        return problem(ErrorCode.NOT_FOUND, request);
    }

    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    ResponseEntity<ProblemDetail> method(Exception ex, HttpServletRequest request) {
        return problem(ErrorCode.METHOD_NOT_ALLOWED, request);
    }

    @ExceptionHandler(AuthenticationException.class)
    ResponseEntity<ProblemDetail> unauthenticated(Exception ex, HttpServletRequest request) {
        return problem(ErrorCode.UNAUTHORIZED, request);
    }

    @ExceptionHandler(AccessDeniedException.class)
    ResponseEntity<ProblemDetail> forbidden(Exception ex, HttpServletRequest request) {
        return problem(ErrorCode.FORBIDDEN, request);
    }

    @ExceptionHandler(Exception.class)
    ResponseEntity<ProblemDetail> unexpected(Exception ex, HttpServletRequest request) {
        StackTraceElement origin = ex.getStackTrace().length > 0 ? ex.getStackTrace()[0] : null;
        log.error("Beklenmeyen hata: type={} at={}", ex.getClass().getName(), origin);
        return problem(ErrorCode.INTERNAL_ERROR, request);
    }
}
