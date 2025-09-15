#!/usr/bin/env bash
set -euo pipefail
BIN="${BIN:-.bin/tweego}"
OUT="${OUT:-dist}"
rm -rf "$OUT"; mkdir -p "$OUT"
build(){ deck="$1"; src="stories/${deck}"; outdir="${OUT}/${deck}"; mkdir -p "$outdir";
"$BIN" --log=info --config .tweego.yaml --head "shared/macros/widgets.js" --output "${outdir}/index.html" "${src}/00_meta.twee" "${src}/01_passages" shared/passages;
[ -d "${src}/assets" ] && rsync -a "${src}/assets/" "${outdir}/assets/" || true;
python3 - "$outdir/index.html" <<'PY'
import sys,re
p=sys.argv[1]
h=open(p,encoding='utf-8').read()
sn="\n<script>if('serviceWorker' in navigator){window.addEventListener('load',()=>navigator.serviceWorker.register('../sw.js').catch(()=>{}));}</script>\n"
h=re.sub(r'</body>',sn+'</body>',h,flags=re.I)
open(p,'w',encoding='utf-8').write(h)
print('Injected SW into',p)
PY
}
for d in stories/*/; do build "$(basename "$d")"; done
cp -r pwa manifest.webmanifest sw.js "$OUT/"
python3 - <<'PY'
import os,glob,html
items=[]
for d in sorted(glob.glob('dist/*/')):
  name=os.path.basename(os.path.dirname(d))
  items.append(f"<li><a href='./{html.escape(name)}/index.html'>{html.escape(name)}</a></li>")
page='''<!doctype html><html><head><meta charset='utf-8'><meta name='viewport' content='width=device-width, initial-scale=1'>
<link rel='manifest' href='./manifest.webmanifest'><link rel='apple-touch-icon' href='./pwa/icon-192.png'>
<title>Twine Decks - Japan</title><style>body{font-family:-apple-system,system-ui,Roboto,Arial,sans-serif;max-width:900px;margin:2rem auto;padding:1rem}li{margin:.5rem 0}</style>
</head><body><h1>Twine Decks - Japan</h1><ul>'''+"\n".join(items)+'''</ul><script>if('serviceWorker' in navigator){window.addEventListener('load',()=>navigator.serviceWorker.register('./sw.js').catch(()=>{}));}</script></body></html>'''
open('dist/index.html','w',encoding='utf-8').write(page)
print('Root index written')
PY
