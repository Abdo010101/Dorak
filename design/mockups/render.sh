#!/usr/bin/env sh
# Rebuild mockups.html and export design/Dorak_UI_Mockups_v1.pdf with headless Chrome.
# Usage: sh render.sh [preview-dir]   (preview-dir: also write one PNG per page there)
set -e
cd "$(dirname "$0")"
CHROME="${CHROME:-/c/Program Files/Google/Chrome/Application/chrome.exe}"
HERE="$(pwd -W 2>/dev/null || pwd)"
URL="file:///$HERE/mockups.html"
python -I build.py
"$CHROME" --headless=new --disable-gpu --no-pdf-header-footer --virtual-time-budget=15000 \
  --print-to-pdf="$HERE/../Dorak_UI_Mockups_v1.pdf" "$URL" 2>/dev/null
if [ -n "$1" ]; then
  PAGES=$(grep -o '<section class="page' mockups.html | wc -l)
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --virtual-time-budget=15000 \
    --window-size=1123,$((PAGES * 794)) --screenshot="$1/full.png" "$URL" 2>/dev/null
  python -I -c "
import sys
from PIL import Image
d, n = sys.argv[1], int(sys.argv[2])
im = Image.open(d + '/full.png')
for i in range(n):
    im.crop((0, i * 794, 1123, (i + 1) * 794)).save(f'{d}/p{i + 1:02d}.png')
" "$1" "$PAGES"
fi
echo "done"
