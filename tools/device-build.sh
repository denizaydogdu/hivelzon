#!/usr/bin/env bash
# H-043: gerçek telefon için derleme yardımcısı (iç beta, yerel ağ).
#
# Mac'in yerel ağ adresini bulur; uygulamaya içerik sunucusu, reel kataloğu
# ve backend adreslerini bu adresle verir (`--dart-define`). Sürüm 0.1.0,
# yapı numarası her derlemede artar (varsayılan: git commit sayısı).
#
# ÇALIŞAN SERVİSLERE DOKUNMAZ: backend (:8080) ve içerik sunucusu (:8787)
# durdurulmaz, yeniden başlatılmaz. Yerel ağdan erişim için ne yapılacağı
# yalnızca ekrana yazılır.
#
# Kullanım (depo kökünden):
#   tools/device-build.sh run  [debug|profile] [-- flutter run argümanları, ör. -d <cihaz>]
#   tools/device-build.sh apk  [debug|profile]
#   tools/device-build.sh ios  [debug|profile]
#   tools/device-build.sh print                 # yalnızca adresleri ve adımları yaz
#
# Ortam değişkenleri (isteğe bağlı):
#   HV_LAN_IP        adresi elle ver (otomatik bulunamazsa)
#   HV_CONTENT_PORT  yerel ağdaki içerik sunucusu portu (varsayılan 8788;
#                    127.0.0.1:8787'deki çalışan sunucu ayrı kalır)
#   HV_API_PORT      backend portu (varsayılan 8080)
#   HV_BUILD_NUMBER  yapı numarası (varsayılan: git rev-list --count HEAD)
#   HV_DRY_RUN=1     komutu çalıştırmadan yaz
#
# Release derlemesi bilerek yok: release yalnızca HTTPS ve gerçek adreslerle
# yapılır (H-044). Ayrıntı: docs/BETA-KONTROL-LISTESI.md
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MOBILE="$ROOT/mobile"

action="${1:-print}"
mode="${2:-debug}"
if [[ $# -ge 2 ]]; then shift 2; elif [[ $# -ge 1 ]]; then shift 1; fi
[[ "${1:-}" == "--" ]] && shift

case "$mode" in
  debug|profile) ;;
  release)
    echo "Release derlemesi bu betikle yapılmaz (yalnız HTTPS, gerçek adresler; H-044)." >&2
    exit 2 ;;
  *) echo "Mod debug ya da profile olmalı: $mode" >&2; exit 2 ;;
esac

lan_ip() {
  if [[ -n "${HV_LAN_IP:-}" ]]; then echo "$HV_LAN_IP"; return; fi
  local iface ip
  iface="$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')"
  for i in $iface en0 en1; do
    ip="$(ipconfig getifaddr "$i" 2>/dev/null || true)"
    if [[ -n "$ip" ]]; then echo "$ip"; return; fi
  done
}

IP="$(lan_ip)"
if [[ -z "$IP" ]]; then
  echo "Yerel ağ adresi bulunamadı. Wi-Fi'ye bağlan ya da HV_LAN_IP=192.168.x.y ver." >&2
  exit 1
fi

CONTENT_PORT="${HV_CONTENT_PORT:-8788}"
API_PORT="${HV_API_PORT:-8080}"
CONTENT_URL="http://$IP:$CONTENT_PORT"
API_URL="http://$IP:$API_PORT"
REEL_URL="$API_URL/api/v1/catalog/reels"

VERSION_NAME="$(sed -n 's/^version:[[:space:]]*\([0-9][0-9.]*\)+.*/\1/p' "$MOBILE/pubspec.yaml")"
BUILD_NUMBER="${HV_BUILD_NUMBER:-$(git -C "$ROOT" rev-list --count HEAD 2>/dev/null || echo 1)}"

probe() {
  local url=$1
  local code
  code="$(curl -s -o /dev/null -m 2 -w '%{http_code}' "$url" 2>/dev/null || true)"
  if [[ "$code" =~ ^(2|3) ]]; then echo "ulaşılıyor ($code)"; else echo "ULAŞILAMIYOR (${code:-yok})"; fi
}

cat <<EOF
hiVelzon cihaz derlemesi (H-043)
  Mac'in yerel ağ adresi : $IP
  İçerik sunucusu        : $CONTENT_URL   $(probe "$CONTENT_URL/packages/index.json")
  Backend                : $API_URL   $(probe "$API_URL/actuator/health")
  Reel kataloğu          : $REEL_URL
  Sürüm                  : $VERSION_NAME+$BUILD_NUMBER ($mode)

Yerel ağdan erişim (çalışan servislere dokunulmaz; gerekirse AYRI terminalde):
  1) İçerik sunucusu (127.0.0.1:8787 olduğu gibi kalır; ikinci örnek):
       python3 tools/dev-content-server/serve.py --host $IP --port $CONTENT_PORT
  2) Backend: Spring Boot varsayılan olarak bütün arayüzleri dinler (*:$API_PORT).
     Ulaşılamıyorsa macOS Güvenlik Duvarı'nda Java'ya gelen bağlantı izni ver.
     Reel videoları backend'in verdiği medya kökünden gelir; telefonda açılması
     için backend'in bir SONRAKİ başlatılışında şu değişkenle başlat:
       HIVELZON_MEDIA_LOCAL_BASE_URL=$CONTENT_URL/packages/
     (Çalışan backend bu betikle durdurulmaz/yeniden başlatılmaz.)
  3) Telefon ve Mac aynı Wi-Fi'de olmalı. İş bitince 1)'deki sunucuyu kapat.
  iOS: ilk açılışta "Yerel ağ" izni sorulur (yalnız debug/profile).
  Android: debug/profile derlemesinde düz HTTP açık (network_security_config).
EOF

defines=(
  "--dart-define=CONTENT_BASE_URL=$CONTENT_URL"
  "--dart-define=REEL_CATALOG_URL=$REEL_URL"
  "--dart-define=API_BASE_URL=$API_URL"
  "--dart-define=HV_APP_VERSION=$VERSION_NAME+$BUILD_NUMBER"
)
version_args=(--build-name "$VERSION_NAME" --build-number "$BUILD_NUMBER")

case "$action" in
  print) exit 0 ;;
  run) cmd=(flutter run "--$mode" "${defines[@]}" "$@") ;;
  apk) cmd=(flutter build apk "--$mode" "${version_args[@]}" "${defines[@]}" "$@") ;;
  ios) cmd=(flutter build ios "--$mode" "${version_args[@]}" "${defines[@]}" "$@") ;;
  *) echo "Eylem run | apk | ios | print olmalı: $action" >&2; exit 2 ;;
esac

echo
echo "Komut (mobile/ içinde):"
printf '  %q' "${cmd[@]}"
echo
if [[ "${HV_DRY_RUN:-}" == "1" ]]; then exit 0; fi
cd "$MOBILE"
exec "${cmd[@]}"
