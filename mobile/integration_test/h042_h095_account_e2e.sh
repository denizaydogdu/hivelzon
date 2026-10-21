#!/bin/zsh
# H-042 + H-095 uçtan uca betiği (geçici simülatör + yalıtılmış backend 8090).
#
# Kullanım: integration_test/h042_h095_account_e2e.sh <geçici-simülatör-UDID> <çıktı-klasörü>
# Önkoşul: h042_h095_backend.sh çalışıyor (port 8090, veritabanı hivelzon_e2e), Mailpit 8027.
# Yalnızca verilen UDID'ye ve hivelzon_e2e veritabanına dokunur.
set -eu
udid=$1
out=$2
here=${0:A:h}
cd "$here/.."
mkdir -p "$out"
export SHOT_DIR=$out
bundle=tr.velzon.hivelzon
stamp=$(date +%s)
emailA="h042-a-$stamp@example.com"
emailB="h095-b-$stamp@example.com"
print "$emailA $emailB" > "$out/emails.txt"

sql() { docker exec -i hivelzon-postgres psql -U hivelzon -d hivelzon_e2e -v ON_ERROR_STOP=1 -At -c "$1"; }
fresh() { xcrun simctl uninstall "$udid" "$bundle" 2>/dev/null || true; }
drive() {
  local p=$1 mail=$2; shift 2
  print "=== aşama $p ($mail) ==="
  flutter drive --driver=test_driver/integration_test.dart \
    --target=integration_test/h042_h095_account_e2e_test.dart \
    -d "$udid" --keep-app-running \
    --dart-define=API_BASE_URL=http://127.0.0.1:8090 \
    --dart-define=E2E_PHASE=$p --dart-define=E2E_EMAIL=$mail "$@" \
    2>&1 | tee "$out/phase$p.log" | grep -E "H042-E2E|All tests passed|Some tests failed|EXCEPTION|Expected|Actual|Bulunamadı|Error" || true
  grep -q "All tests passed" "$out/phase$p.log" || { print "aşama $p BAŞARISIZ"; exit 1; }
}
consents() {
  sql "SELECT c.consent_type, c.document_version, c.granted, (c.ip IS NOT NULL) AS has_ip
       FROM consents c JOIN users u ON u.id = c.user_id WHERE u.email = '$1' ORDER BY c.id"
}

fresh; drive 1 "$emailA"
print -r -- "-- DB A rızalar:"; consents "$emailA"
print -r -- "-- DB A defter satırı: $(sql "SELECT count(*) FROM notebook_items n JOIN users u ON u.id = n.user_id WHERE u.email = '$emailA'")"

fresh; drive 2 "$emailB" --dart-define=TERMS_VERSION=taslak-1 --dart-define=PRIVACY_NOTICE_VERSION=taslak-1
print -r -- "-- DB B rızalar (eski uygulama):"; consents "$emailB"
drive 3 "$emailB"
print -r -- "-- DB B rızalar (güncel uygulamadan sonra; yeni satır beklenmez):"; consents "$emailB"
print -r -- "-- DB B defter satırı: $(sql "SELECT count(*) FROM notebook_items n JOIN users u ON u.id = n.user_id WHERE u.email = '$emailB'")"

fresh; drive 4 "$emailA"
print -r -- "-- DB A durum: $(sql "SELECT status, scheduled_purge_at FROM users WHERE email = '$emailA'")"
print -r -- "-- DB A denetim: $(sql "SELECT string_agg(a.action, ',' ORDER BY a.id) FROM audit_log a JOIN users u ON u.id = a.actor_user_id WHERE u.email = '$emailA'")"

fresh; drive 5 "$emailA"
print "UI aşamaları tamam"
