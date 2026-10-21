#!/bin/zsh
# H-095: kalıcı silmeden sonra rıza ve denetim satırları kalır (yalıtılmış backend 8090, hivelzon_e2e).
# Kullanım: integration_test/h095_purge_check.sh <e-posta>
# Backend kalıcı silme işi sık çalışmalı (h042_h095_backend.sh: her 10 sn). Hesabın silme tarihi
# yalnızca hivelzon_e2e'de geçmişe çekilir; kod değişikliği yok.
set -eu
email=$1
api=http://127.0.0.1:8090/api/v1
sql() { docker exec -i hivelzon-postgres psql -U hivelzon -d hivelzon_e2e -v ON_ERROR_STOP=1 -At -c "$1"; }

uid=$(sql "SELECT id FROM users WHERE email = '$email'")
[[ -n $uid ]] || { print "hesap yok"; exit 1; }
print "hesap: $uid"
sent=$(date -u +%Y-%m-%dT%H:%M:%S)
curl -s -o /dev/null -w "POST /auth/email/start → %{http_code}\n" -H 'Content-Type: application/json' \
  -d "{\"email\":\"$email\"}" $api/auth/email/start
code=""
for i in {1..20}; do
  code=$(curl -s "http://127.0.0.1:8027/api/v1/search?query=to:$email" | python3 -I -c '
import json,re,sys
sent=sys.argv[1]
for m in json.load(sys.stdin)["messages"]:
    if m["Created"][:19] >= sent:
        r=re.search(r"\b(\d{6})\b", m["Snippet"])
        if r: print(r.group(1)); break
' "$sent")
  [[ -n $code ]] && break
  sleep 1
done
[[ -n $code ]] || { print "kod gelmedi"; exit 1; }
tok=$(curl -s -H 'Content-Type: application/json' -d "{\"email\":\"$email\",\"code\":\"$code\"}" \
  $api/auth/email/verify | python3 -I -c 'import json,sys; print(json.load(sys.stdin)["accessToken"])')
curl -s -o /dev/null -w "DELETE /me → %{http_code}\n" -X DELETE -H "Authorization: Bearer $tok" $api/me

count() {
  print "  users=$(sql "SELECT count(*) FROM users WHERE id = '$uid'")" \
    "consents=$(sql "SELECT count(*) FROM consents WHERE user_id = '$uid'")" \
    "audit=$(sql "SELECT count(*) FROM audit_log WHERE actor_user_id = '$uid'")" \
    "audit_with_ip=$(sql "SELECT count(*) FROM audit_log WHERE actor_user_id = '$uid' AND ip IS NOT NULL")" \
    "notebook=$(sql "SELECT count(*) FROM notebook_items WHERE user_id = '$uid'")" \
    "learning_events=$(sql "SELECT count(*) FROM learning_events WHERE user_id = '$uid'")" \
    "tombstone=$(sql "SELECT count(*) FROM account_tombstones WHERE user_id = '$uid'")"
}
print "silme isteğinden sonra:"; count
sql "UPDATE users SET scheduled_purge_at = now() - interval '1 minute' WHERE id = '$uid' AND status = 'PENDING_DELETION'" >/dev/null
for i in {1..30}; do
  [[ $(sql "SELECT count(*) FROM users WHERE id = '$uid'") == 0 ]] && break
  sleep 2
done
print "kalıcı silmeden sonra:"; count
print "rıza satırları:"; sql "SELECT consent_type, document_version, granted, (ip IS NOT NULL) FROM consents WHERE user_id = '$uid' ORDER BY id"
print "denetim:"; sql "SELECT action, (ip IS NOT NULL), (port IS NOT NULL) FROM audit_log WHERE actor_user_id = '$uid' ORDER BY id"
print "ACCOUNT_PURGED satırı: $(sql "SELECT count(*) FROM audit_log WHERE action = 'ACCOUNT_PURGED'")"
