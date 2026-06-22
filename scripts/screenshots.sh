#!/usr/bin/env bash
#
# Regenerate the README / demo screenshots from docs/index.html.
#
# Screenshots are rendered with headless Chromium. The RTL examples use Arabic,
# so an Arabic-capable font MUST be present or the text renders as tofu boxes
# (this bit us once — the screenshot box had no Arabic font). If none is found
# this script installs Noto Sans Arabic into ~/.local/share/fonts (no sudo).
#
# Usage:  bash scripts/screenshots.sh        (or: npm run screenshots)
#
set -euo pipefail
cd "$(dirname "$0")/.."

# --- locate a headless browser ---------------------------------------------
BROWSER=""
for b in chromium chromium-browser google-chrome google-chrome-stable; do
	if command -v "$b" >/dev/null 2>&1; then BROWSER="$b"; break; fi
done
[ -n "$BROWSER" ] || { echo "No Chromium/Chrome found on PATH." >&2; exit 1; }
shot() { "$BROWSER" --headless --no-sandbox --disable-gpu --hide-scrollbars "$@"; }

# --- ensure an Arabic font (for the RTL screenshots) ------------------------
if [ "$(fc-list :lang=ar 2>/dev/null | wc -l)" -eq 0 ]; then
	echo "No Arabic font found — installing Noto Sans Arabic into ~/.local/share/fonts"
	mkdir -p ~/.local/share/fonts
	curl -fsSL \
		"https://raw.githubusercontent.com/google/fonts/main/ofl/notosansarabic/NotoSansArabic%5Bwdth%2Cwght%5D.ttf" \
		-o ~/.local/share/fonts/NotoSansArabic.ttf
	fc-cache -f ~/.local/share/fonts >/dev/null 2>&1
fi

# --- build the CSS the demo loads ------------------------------------------
npm run build:docs >/dev/null

# --- full gallery, light + dark (loads vendored assets, not the CDN) -------
TMP_BASE="docs/.shot-base.html"
sed -e 's#https://cdn.jsdelivr.net/npm/bulma@1.0.4/css/bulma.min.css#../node_modules/bulma/css/bulma.min.css#' \
    -e 's#https://cdn.jsdelivr.net/npm/tom-select@2.6.1/dist/js/tom-select.complete.min.js#../node_modules/tom-select/dist/js/tom-select.complete.min.js#' \
    docs/index.html > "$TMP_BASE"
for theme in light dark; do
	TMP="docs/.shot-$theme.html"
	sed "s/localStorage.getItem(KEY) || 'auto'/'$theme'/" "$TMP_BASE" > "$TMP"
	shot --window-size=1100,2480 --virtual-time-budget=4000 \
		--screenshot="docs/screenshot-$theme.png" "file://$PWD/$TMP"
	rm -f "$TMP"
done
rm -f "$TMP_BASE"

# --- focused RTL (Arabic) pair, light + dark -------------------------------
for theme in light dark; do
	TMP="docs/.shot-rtl.html"
	cat > "$TMP" <<EOF
<!doctype html><html lang="ar" dir="rtl" data-theme="$theme"><head><meta charset="utf-8">
<link rel="stylesheet" href="../node_modules/bulma/css/bulma.min.css">
<link rel="stylesheet" href="./tom-select.bulma.css">
<script src="../node_modules/tom-select/dist/js/tom-select.complete.min.js"></script>
<style>body{padding:1.5rem}.box{height:100%}</style></head><body>
<div class="container"><div class="columns is-multiline">
<div class="column is-half"><div class="box"><p class="has-text-weight-semibold mb-2">قائمة مفردة + بحث</p>
<select id="s" placeholder="اختر إطار العمل…"><option value="">اختر إطار العمل…</option><option>فلاسك</option><option>دجانغو</option></select></div></div>
<div class="column is-half"><div class="box"><p class="has-text-weight-semibold mb-2">اختيار متعدد — وسوم</p>
<select id="m" multiple><option value="py" selected>بايثون</option><option value="js" selected>جافاسكريبت</option><option value="rb">روبي</option></select></div></div>
<div class="column is-half"><div class="box"><p class="has-text-weight-semibold mb-2">مع أيقونة</p>
<div class="control has-icons-left"><select id="i" placeholder="ابحث عن مستخدم…"><option value="">ابحث عن مستخدم…</option><option>أحمد</option></select><span class="icon is-left"><i style="font-style:normal">@</i></span></div></div></div>
<div class="column is-half"><div class="box"><p class="has-text-weight-semibold mb-2">مرفق بزر</p>
<div class="field has-addons"><div class="control is-expanded"><select id="a" placeholder="بحث…"><option value="">بحث…</option><option>مستودع</option></select></div><div class="control"><button class="button is-primary">انطلق</button></div></div></div></div>
</div></div>
<script>new TomSelect('#s',{});new TomSelect('#m',{plugins:['remove_button']});new TomSelect('#i',{});new TomSelect('#a',{});</script>
</body></html>
EOF
	shot --window-size=900,420 --virtual-time-budget=2800 \
		--screenshot="docs/screenshot-rtl-$theme.png" "file://$PWD/$TMP"
	rm -f "$TMP"
done

echo "Done. Updated:"
ls -1 docs/screenshot-*.png
