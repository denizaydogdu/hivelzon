package tr.velzon.hivelzon.auth;

import java.time.Clock;
import java.time.Duration;

import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.oauth2.core.DelegatingOAuth2TokenValidator;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.JwtIssuerValidator;
import org.springframework.security.oauth2.jwt.JwtTimestampValidator;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.oauth2.jwt.NimbusJwtEncoder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;
import org.springframework.security.oauth2.server.resource.web.BearerTokenResolver;
import org.springframework.security.oauth2.server.resource.web.DefaultBearerTokenResolver;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.web.servlet.HandlerExceptionResolver;

import tr.velzon.hivelzon.common.config.HivelzonProperties;
import tr.velzon.hivelzon.common.config.SecretsValidator;
import tr.velzon.hivelzon.common.web.ApiException;
import tr.velzon.hivelzon.common.web.ErrorCode;

/**
 * Durumsuz (stateless) JWT kaynak sunucusu. {@code /api/v1/auth/**} ve {@code /actuator/health} açık;
 * diğer {@code /api/**} uçları belirteç ister; geri kalan her şey kapalı. Mobil istemci olduğu için CORS ve
 * CSRF kapalı (çerez yok).
 */
@Configuration(proxyBeanMethods = false)
public class SecurityConfig {

    /**
     * Bütün cevaplarda: yalnızca aynı kökten betik, stil ve bağlantı; satır içi betik yok; çerçeveleme yok. JSON
     * uçları için zararsız, editör ekranı için XSS savunmasının ikinci katmanı (ekran veriyi textContent ile yazar).
     */
    static final String CONTENT_SECURITY_POLICY = "default-src 'none'; script-src 'self'; style-src 'self'; "
            + "img-src 'self'; connect-src 'self'; form-action 'self'; frame-ancestors 'none'; base-uri 'none'";

    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http, JwtAuthenticationConverter converter,
            @Qualifier("handlerExceptionResolver") HandlerExceptionResolver resolver) throws Exception {
        AuthenticationEntryPoint entryPoint = (request, response, ex) ->
                resolver.resolveException(request, response, null, new ApiException(ErrorCode.UNAUTHORIZED));
        AccessDeniedHandler deniedHandler = (request, response, ex) ->
                resolver.resolveException(request, response, null, new ApiException(ErrorCode.FORBIDDEN));
        http
                .csrf(c -> c.disable())
                .cors(c -> c.disable())
                .httpBasic(b -> b.disable())
                .formLogin(f -> f.disable())
                .logout(l -> l.disable())
                .requestCache(r -> r.disable())
                .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                // Editör ekranı (H-041) aynı kökten statik dosya; satır içi betik/stil yok, çerçevelenemez.
                .headers(h -> h
                        .contentSecurityPolicy(c -> c.policyDirectives(CONTENT_SECURITY_POLICY))
                        .referrerPolicy(r -> r.policy(
                                org.springframework.security.web.header.writers.ReferrerPolicyHeaderWriter
                                        .ReferrerPolicy.NO_REFERRER)))
                .authorizeHttpRequests(a -> a
                        .requestMatchers(HttpMethod.GET, "/actuator/health", "/actuator/health/**").permitAll()
                        // Editör ekranının kabuğu (veri içermez); veriler /api/v1/admin/** üzerinden rol ister.
                        .requestMatchers(HttpMethod.GET, "/admin", "/admin/", "/admin/index.html", "/admin/admin.js",
                                "/admin/admin.css").permitAll()
                        .requestMatchers(HttpMethod.POST, "/api/v1/auth/**").permitAll()
                        // Katalog açık: misafir ve hesapsız (13 yaş altı) kullanıcılar da içerik görür (H-009, H-002).
                        .requestMatchers(HttpMethod.GET, "/api/v1/catalog/**").permitAll()
                        .requestMatchers("/api/v1/admin/**").hasAnyRole("EDITOR", "ADMIN")
                        .requestMatchers("/error").permitAll()
                        .requestMatchers("/api/**").authenticated()
                        .anyRequest().denyAll())
                .oauth2ResourceServer(o -> o
                        .bearerTokenResolver(bearerTokenResolver())
                        .jwt(j -> j.jwtAuthenticationConverter(converter))
                        .authenticationEntryPoint(entryPoint)
                        .accessDeniedHandler(deniedHandler))
                .exceptionHandling(e -> e.authenticationEntryPoint(entryPoint).accessDeniedHandler(deniedHandler));
        return http.build();
    }

    /**
     * Açık uçlarda ({@code /api/v1/auth/**}, katalog, sağlık) Authorization başlığı yok sayılır: süresi dolmuş erişim
     * belirteciyle {@code /auth/refresh} çağıran istemci 401 almamalı.
     */
    static BearerTokenResolver bearerTokenResolver() {
        DefaultBearerTokenResolver delegate = new DefaultBearerTokenResolver();
        return request -> {
            String path = request.getRequestURI().substring(request.getContextPath().length());
            if (path.startsWith("/api/v1/auth/") || path.startsWith("/actuator/health")
                    || path.startsWith("/api/v1/catalog/")) {
                return null;
            }
            return delegate.resolve(request);
        };
    }

    @Bean
    JwtAuthenticationConverter jwtAuthenticationConverter() {
        JwtGrantedAuthoritiesConverter authorities = new JwtGrantedAuthoritiesConverter();
        authorities.setAuthoritiesClaimName("roles");
        authorities.setAuthorityPrefix("ROLE_");
        JwtAuthenticationConverter converter = new JwtAuthenticationConverter();
        converter.setJwtGrantedAuthoritiesConverter(authorities);
        return converter;
    }

    @Bean
    JwtEncoder jwtEncoder(SecretsValidator secrets) {
        return NimbusJwtEncoder.withSecretKey(secretKey(secrets)).algorithm(MacAlgorithm.HS256).build();
    }

    @Bean
    JwtDecoder jwtDecoder(SecretsValidator secrets, HivelzonProperties properties, Clock clock) {
        NimbusJwtDecoder decoder = NimbusJwtDecoder.withSecretKey(secretKey(secrets))
                .macAlgorithm(MacAlgorithm.HS256)
                .build();
        JwtTimestampValidator timestamps = new JwtTimestampValidator(Duration.ofSeconds(30));
        timestamps.setClock(clock);
        decoder.setJwtValidator(new DelegatingOAuth2TokenValidator<>(timestamps,
                new JwtIssuerValidator(properties.getSecurity().getIssuer())));
        return decoder;
    }

    private static SecretKey secretKey(SecretsValidator secrets) {
        return new SecretKeySpec(secrets.jwtKey(), "HmacSHA256");
    }
}
