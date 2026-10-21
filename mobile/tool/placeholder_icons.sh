#!/usr/bin/env bash
# H-043: GEÇİCİ uygulama simgesi ve açılış işareti (asıl logo H-016'da).
#
# Yerelde ImageMagick ile üretilir; ücretli üretim (Higgsfield vb.) yok.
# Renkler tasarım belirteçlerinden (lib/app/design/tokens.dart):
#   zemin  AppPalette.sand    #F7F1E6
#   işaret AppPalette.seaBlue #1F4E79 (yuvarlak), yazı beyaz, Nunito Bold
#
# Kullanım (mobile/ içinden): bash tool/placeholder_icons.sh
# Çıktılar: iOS AppIcon (bütün boyutlar), iOS LaunchImage (1x/2x/3x),
# Android mipmap'leri (eski simge + uyarlanabilir simge ön planı) ve açılış
# işareti. Yeniden çalıştırmak aynı dosyaları üretir (üzerine yazar).
set -euo pipefail

cd "$(dirname "$0")/.."

SAND='#F7F1E6'
SEA='#1F4E79'
FONT='assets/fonts/nunito/Nunito-Bold.ttf'
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

command -v magick >/dev/null || { echo "ImageMagick (magick) gerekli: brew install imagemagick" >&2; exit 1; }

# Yuvarlak "hi" işareti, saydam zeminde (kenar = çap oranı).
# $1 çıktı, $2 tuval px, $3 çap / tuval oranı (0–1)
mark() {
  local out=$1 size=$2 ratio=$3
  local r cx pt
  r=$(python3 -c "print(round($size * $ratio / 2))")
  cx=$((size / 2))
  pt=$(python3 -c "print(round($size * $ratio * 0.52))")
  magick -size "${size}x${size}" xc:none \
    -fill "$SEA" -draw "circle $cx,$cx $cx,$((cx - r))" \
    -font "$FONT" -pointsize "$pt" -fill white -gravity center \
    -annotate "+0-$(python3 -c "print(round($pt * 0.06))")" 'hi' \
    "$out"
}

# 1) Ana simge 1024 (iOS: saydamlık yok).
mark "$TMP/mark1024.png" 1024 0.70
magick -size 1024x1024 "xc:$SAND" "$TMP/mark1024.png" -composite \
  -alpha off -depth 8 -strip "$TMP/icon1024.png"

ios=ios/Runner/Assets.xcassets/AppIcon.appiconset
for spec in 20x20@1x:20 20x20@2x:40 20x20@3x:60 29x29@1x:29 29x29@2x:58 \
  29x29@3x:87 40x40@1x:40 40x40@2x:80 40x40@3x:120 60x60@2x:120 \
  60x60@3x:180 76x76@1x:76 76x76@2x:152 83.5x83.5@2x:167 1024x1024@1x:1024; do
  name=${spec%%:*}
  px=${spec##*:}
  magick "$TMP/icon1024.png" -resize "${px}x${px}" -alpha off -depth 8 -strip \
    "$ios/Icon-App-$name.png"
done

# 2) iOS açılış işareti (96 pt).
launch=ios/Runner/Assets.xcassets/LaunchImage.imageset
mark "$TMP/launch.png" 1024 0.96
magick "$TMP/launch.png" -resize 96x96 -depth 8 -strip "$launch/LaunchImage.png"
magick "$TMP/launch.png" -resize 192x192 -depth 8 -strip "$launch/LaunchImage@2x.png"
magick "$TMP/launch.png" -resize 288x288 -depth 8 -strip "$launch/LaunchImage@3x.png"

# 3) Android: eski simge (48 dp), uyarlanabilir ön plan (108 dp; işaret
#    66 dp güvenli alanın içinde), açılış işareti (96 dp).
mark "$TMP/fg.png" 1024 0.56
res=android/app/src/main/res
for spec in mdpi:1 hdpi:1.5 xhdpi:2 xxhdpi:3 xxxhdpi:4; do
  d=${spec%%:*}
  k=${spec##*:}
  icon=$(python3 -c "print(round(48 * $k))")
  fg=$(python3 -c "print(round(108 * $k))")
  lm=$(python3 -c "print(round(96 * $k))")
  mkdir -p "$res/mipmap-$d"
  magick "$TMP/icon1024.png" -resize "${icon}x${icon}" -depth 8 -strip \
    "$res/mipmap-$d/ic_launcher.png"
  magick "$TMP/fg.png" -resize "${fg}x${fg}" -depth 8 -strip \
    "$res/mipmap-$d/ic_launcher_foreground.png"
  magick "$TMP/launch.png" -resize "${lm}x${lm}" -depth 8 -strip \
    "$res/mipmap-$d/launch_mark.png"
done

echo "Geçici simgeler üretildi (H-043; asıl logo H-016)."
