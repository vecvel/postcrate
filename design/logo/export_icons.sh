#!/usr/bin/env bash
# Regenerates every platform app icon from the single logo source.
# Requires: node, rsvg-convert (librsvg), magick (ImageMagick).
# Run from the repo root: bash design/logo/export_icons.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OUT="$ROOT/design/logo/out"
IOS="$ROOT/ios/Runner/Assets.xcassets/AppIcon.appiconset"
RES="$ROOT/android/app/src/main/res"

node "$ROOT/design/logo/generate.mjs"

# iOS: single-size 1024 icons, light and dark, no alpha.
rm -f "$IOS"/*.png
rsvg-convert -w 1024 -h 1024 "$OUT/app-icon-light-1024.svg" | magick - -background '#F4F4F4' -alpha remove -alpha off -type TrueColor "PNG24:$IOS/icon-light-1024.png"
rsvg-convert -w 1024 -h 1024 "$OUT/app-icon-dark-1024.svg" | magick - -background '#141414' -alpha remove -alpha off -type TrueColor "PNG24:$IOS/icon-dark-1024.png"
cat > "$IOS/Contents.json" <<'JSON'
{
  "images" : [
    { "filename" : "icon-light-1024.png", "idiom" : "universal", "platform" : "ios", "size" : "1024x1024" },
    {
      "appearances" : [ { "appearance" : "luminosity", "value" : "dark" } ],
      "filename" : "icon-dark-1024.png", "idiom" : "universal", "platform" : "ios", "size" : "1024x1024"
    }
  ],
  "info" : { "author" : "xcode", "version" : 1 }
}
JSON

# Android: adaptive icon (neutral background + foreground + monochrome) and legacy fallbacks.
for pair in mdpi:1 hdpi:1.5 xhdpi:2 xxhdpi:3 xxxhdpi:4; do
  d=${pair%%:*}
  s=${pair##*:}
  fg=$(printf '%.0f' "$(echo "108 * $s" | bc)")
  legacy=$(printf '%.0f' "$(echo "48 * $s" | bc)")
  dir="$RES/mipmap-$d"
  mkdir -p "$dir"
  rsvg-convert -w "$fg" -h "$fg" "$OUT/android-adaptive-foreground.svg" -o "$dir/ic_launcher_foreground.png"
  rsvg-convert -w "$fg" -h "$fg" "$OUT/android-monochrome.svg" -o "$dir/ic_launcher_monochrome.png"
  rsvg-convert -w "$legacy" -h "$legacy" "$OUT/app-icon-light-preview.svg" -o "$dir/ic_launcher.png"
done

mkdir -p "$RES/mipmap-anydpi-v26" "$RES/values"
cat > "$RES/mipmap-anydpi-v26/ic_launcher.xml" <<'XML'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background" />
    <foreground android:drawable="@mipmap/ic_launcher_foreground" />
    <monochrome android:drawable="@mipmap/ic_launcher_monochrome" />
</adaptive-icon>
XML
cat > "$RES/values/ic_launcher_background.xml" <<'XML'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#F4F4F4</color>
</resources>
XML

echo "Icons exported."
