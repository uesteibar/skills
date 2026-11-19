#!/usr/bin/env bash
# Render a visual explainer page to PNG screenshots, light and dark, per scenario.
# Usage: render.sh <page.html> [scenarioId ...]
# Output: <name>-<scenario|default>-<light|dark>.png next to the HTML file.
# Height: read from <html data-height="..."> (the template sets it), else $HEIGHT, else 2000.
# Width: $WIDTH (default 1360).
set -euo pipefail

html="${1:?usage: render.sh <page.html> [scenarioId ...]}"
shift || true
html="$(cd "$(dirname "$html")" && pwd)/$(basename "$html")"
dir="$(dirname "$html")"
base="$(basename "$html" .html)"
width="${WIDTH:-1360}"

chrome="${CHROME_BIN:-}"
if [ -z "$chrome" ]; then
  for c in "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
           "/Applications/Chromium.app/Contents/MacOS/Chromium" \
           "$(command -v google-chrome || true)" "$(command -v chromium || true)"; do
    [ -n "$c" ] && [ -x "$c" ] && chrome="$c" && break
  done
fi
[ -n "$chrome" ] || { echo "No Chrome/Chromium found. Set CHROME_BIN." >&2; exit 1; }

measure() {
  "$chrome" --headless=new --disable-gpu --hide-scrollbars --window-size="$width,800" \
    --dump-dom "$1" 2>/dev/null | grep -o 'data-height="[0-9]*"' | head -1 | grep -o '[0-9]*' || true
}

scenarios=("$@")
[ ${#scenarios[@]} -eq 0 ] && scenarios=("default")

for s in "${scenarios[@]}"; do
  url="file://$html"
  [ "$s" != "default" ] && url="$url#$s"
  height="${HEIGHT:-}"
  if [ -z "$height" ]; then
    height="$(measure "$url")"
    height="${height:-2000}"
  fi
  for mode in light dark; do
    out="$dir/$base-$s-$mode.png"
    extra=()
    [ "$mode" = dark ] && extra=(--force-dark-mode --blink-settings=preferredColorScheme=0)
    "$chrome" --headless=new --disable-gpu --hide-scrollbars --window-size="$width,$height" \
      ${extra[@]+"${extra[@]}"} --screenshot="$out" "$url" >/dev/null 2>&1
    echo "$out"
  done
done
