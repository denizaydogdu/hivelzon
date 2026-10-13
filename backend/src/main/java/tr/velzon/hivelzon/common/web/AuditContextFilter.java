package tr.velzon.hivelzon.common.web;

import java.io.IOException;
import java.util.UUID;
import java.util.regex.Pattern;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.slf4j.MDC;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import tr.velzon.hivelzon.common.crypto.Hashing;

/**
 * Her isteğe bir istek kimliği verir (istemcinin {@code X-Request-Id} değeri güvenli biçimdeyse o kullanılır),
 * MDC'ye ve cevap başlığına yazar; denetim bilgisini isteğe ekler.
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class AuditContextFilter extends OncePerRequestFilter {

    public static final String HEADER = "X-Request-Id";
    private static final String ATTRIBUTE = RequestContext.class.getName();
    private static final Pattern SAFE_ID = Pattern.compile("[A-Za-z0-9-]{8,64}");

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        String incoming = request.getHeader(HEADER);
        String requestId = incoming != null && SAFE_ID.matcher(incoming).matches()
                ? incoming : UUID.randomUUID().toString();
        String userAgent = request.getHeader("User-Agent");
        RequestContext context = new RequestContext(
                request.getRemoteAddr(),
                request.getRemotePort(),
                userAgent == null || userAgent.isBlank() ? null : Hashing.sha256(userAgent),
                requestId);
        request.setAttribute(ATTRIBUTE, context);
        response.setHeader(HEADER, requestId);
        MDC.put("requestId", requestId);
        try {
            chain.doFilter(request, response);
        } finally {
            MDC.remove("requestId");
        }
    }

    public static RequestContext from(HttpServletRequest request) {
        Object value = request.getAttribute(ATTRIBUTE);
        return value instanceof RequestContext context ? context : RequestContext.SYSTEM;
    }
}
