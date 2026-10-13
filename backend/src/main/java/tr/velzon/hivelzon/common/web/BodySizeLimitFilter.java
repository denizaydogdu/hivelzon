package tr.velzon.hivelzon.common.web;

import java.io.IOException;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ReadListener;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletInputStream;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletRequestWrapper;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.servlet.HandlerExceptionResolver;

import tr.velzon.hivelzon.common.config.HivelzonProperties;

/**
 * İstek gövdesi sınırı ({@code /api/**}). Bildirilen boyut (Content-Length) sınırı aşıyorsa gövde okunmadan
 * {@code 413 PAYLOAD_TOO_LARGE}; boyut bildirilmemişse (parçalı aktarım) okuma sırasında sınır aşılınca aynı hata.
 * Eşitleme ({@code /api/v1/sync/push}) daha büyük bir sınır kullanır.
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE + 10)
public class BodySizeLimitFilter extends OncePerRequestFilter {

    /** Okuma sırasında sınır aşıldı. */
    public static class BodyTooLargeException extends IOException {
        public BodyTooLargeException() {
            super("request body too large", null);
        }
    }

    private final HivelzonProperties properties;
    private final HandlerExceptionResolver resolver;

    public BodySizeLimitFilter(HivelzonProperties properties,
            @org.springframework.beans.factory.annotation.Qualifier("handlerExceptionResolver")
            HandlerExceptionResolver resolver) {
        this.properties = properties;
        this.resolver = resolver;
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI().substring(request.getContextPath().length());
        return !path.startsWith("/api/");
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        String path = request.getRequestURI().substring(request.getContextPath().length());
        long limit = path.equals("/api/v1/sync/push")
                ? properties.getSync().getMaxPushBytes()
                : properties.getSync().getMaxDefaultBodyBytes();
        long declared = request.getContentLengthLong();
        if (declared > limit) {
            resolver.resolveException(request, response, null, new ApiException(ErrorCode.PAYLOAD_TOO_LARGE));
            return;
        }
        chain.doFilter(new LimitedRequest(request, limit), response);
    }

    private static final class LimitedRequest extends HttpServletRequestWrapper {
        private final long limit;
        private ServletInputStream stream;

        LimitedRequest(HttpServletRequest request, long limit) {
            super(request);
            this.limit = limit;
        }

        @Override
        public ServletInputStream getInputStream() throws IOException {
            if (stream == null) {
                ServletInputStream delegate = super.getInputStream();
                stream = new ServletInputStream() {
                    private long read;

                    private void count(long n) throws IOException {
                        if (n > 0) {
                            read += n;
                            if (read > limit) {
                                throw new BodyTooLargeException();
                            }
                        }
                    }

                    @Override
                    public int read() throws IOException {
                        int b = delegate.read();
                        if (b >= 0) {
                            count(1);
                        }
                        return b;
                    }

                    @Override
                    public int read(byte[] b, int off, int len) throws IOException {
                        int n = delegate.read(b, off, len);
                        count(n);
                        return n;
                    }

                    @Override
                    public boolean isFinished() {
                        return delegate.isFinished();
                    }

                    @Override
                    public boolean isReady() {
                        return delegate.isReady();
                    }

                    @Override
                    public void setReadListener(ReadListener listener) {
                        delegate.setReadListener(listener);
                    }
                };
            }
            return stream;
        }

        @Override
        public java.io.BufferedReader getReader() throws IOException {
            return new java.io.BufferedReader(new java.io.InputStreamReader(getInputStream(),
                    getCharacterEncoding() == null ? "UTF-8" : getCharacterEncoding()));
        }
    }
}
