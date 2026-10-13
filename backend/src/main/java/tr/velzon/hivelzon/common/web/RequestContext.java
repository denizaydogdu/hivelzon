package tr.velzon.hivelzon.common.web;

/**
 * İsteğin denetim bilgisi: istemci IP'si, kaynak portu, User-Agent özeti ve istek kimliği.
 * User-Agent düz metin tutulmaz (SHA-256 özeti).
 */
public record RequestContext(String ip, Integer port, String userAgentHash, String requestId) {

    public static final RequestContext SYSTEM = new RequestContext(null, null, null, null);
}
