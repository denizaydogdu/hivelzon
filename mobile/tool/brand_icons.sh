#!/usr/bin/env bash
# H-101: H-016 marka kararından uygulama ve mağaza simgelerini üretir.
#
# Yerelde ImageMagick ile üretilir; ücretli üretim (Higgsfield vb.) yok.
# Renkler tasarım belirteçlerinden (lib/app/design/tokens.dart):
#   zemin  AppPalette.seaBlue         #1F4E79
#   balon  AppPalette.sand            #F7F1E6
#   ışık   AppPalette.lighthouseYellow #F2B33D
#
# Kullanım (mobile/ içinden): bash tool/brand_icons.sh
# Çıktılar: iOS AppIcon (bütün boyutlar), iOS LaunchImage (1x/2x/3x),
# Android mipmap'leri (eski simge + uyarlanabilir simge ön planı) ve açılış
# işareti. Yeniden çalıştırmak aynı dosyaları üretir (üzerine yazar).
set -euo pipefail

cd "$(dirname "$0")/.."

SEA='#1F4E79'
SAND='#F7F1E6'
YELLOW='#F2B33D'
YELLOW_LIGHT='#FFF4C9'
FONT='assets/fonts/nunito/Nunito-Bold.ttf'
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

command -v magick >/dev/null || { echo "ImageMagick (magick) gerekli: brew install imagemagick" >&2; exit 1; }

# Konuşma balonu içindeki "Hi" wordmark'ı, saydam 1024 tuvalde.
brand_mark() {
  local out=$1
  magick -size 1024x1024 xc:none \
    -fill "$SAND" \
    -draw "path 'M 310,210 H 714 C 802,210 874,282 874,370 V 570 C 874,658 802,730 714,730 H 430 L 304,830 V 730 H 310 C 222,730 160,658 160,570 V 370 C 160,282 222,210 310,210 Z'" \
    -fill "$YELLOW" -draw "circle 772,286 772,248" \
    -fill "$YELLOW_LIGHT" -draw "circle 772,286 772,268" \
    -fill "$SEA" -font "$FONT" -pointsize 348 -gravity center \
    -annotate +0-20 'Hi' -depth 8 -strip "$out"
}

# 1) Ana simge 1024 (iOS: saydamlık yok).
brand_mark "$TMP/mark1024.png"
magick -size 1024x1024 "xc:$SEA" "$TMP/mark1024.png" -composite \
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

# 2) iOS açılış işareti (96 pt): deniz mavisi ekran üstünde balon.
launch=ios/Runner/Assets.xcassets/LaunchImage.imageset
magick "$TMP/mark1024.png" -resize 900x900 -gravity center \
  -background none -extent 1024x1024 "$TMP/launch.png"
magick "$TMP/launch.png" -resize 96x96 -depth 8 -strip "$launch/LaunchImage.png"
magick "$TMP/launch.png" -resize 192x192 -depth 8 -strip "$launch/LaunchImage@2x.png"
magick "$TMP/launch.png" -resize 288x288 -depth 8 -strip "$launch/LaunchImage@3x.png"

# 3) Android: eski simge (48 dp), uyarlanabilir ön plan (108 dp; işaret
#    66 dp güvenli alanın içinde), açılış işareti (96 dp).
magick "$TMP/mark1024.png" -resize 620x620 -gravity center \
  -background none -extent 1024x1024 "$TMP/fg.png"
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

# 4) Mağaza master'ları (hesap/yükleme H-044'te).
cp "$TMP/icon1024.png" ../tasarim/marka/logo-hi-1024.png
magick "$TMP/icon1024.png" -resize 512x512 -alpha off -depth 8 -strip \
  ../tasarim/marka/google-play-icon-512.png

echo "Hi marka simgeleri üretildi (H-101; karar H-016)."
