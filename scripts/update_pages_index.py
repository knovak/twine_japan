#!/usr/bin/env python3
import html
import sys
from pathlib import Path

ROOT = Path(sys.argv[1]) if len(sys.argv) > 1 else Path('dist')
items = []
for entry in sorted(ROOT.iterdir()):
    if not entry.is_dir():
        continue
    index_file = entry / 'index.html'
    if not index_file.exists():
        continue
    name = entry.name
    items.append(f"<li><a href='./{html.escape(name)}/index.html'>{html.escape(name)}</a></li>")
page = """<!doctype html><html><head><meta charset='utf-8'><meta name='viewport' content='width=device-width, initial-scale=1'>
<link rel='manifest' href='./manifest.webmanifest'><link rel='apple-touch-icon' href='./pwa/icon-192.png'>
<title>Twine Decks - Japan</title><style>body{font-family:-apple-system,system-ui,Roboto,Arial,sans-serif;max-width:900px;margin:2rem auto;padding:1rem}li{margin:.5rem 0}</style>
</head><body><h1>Twine Decks - Japan</h1><ul>""" + "\n".join(items) + """</ul><script>if('serviceWorker' in navigator){window.addEventListener('load',()=>navigator.serviceWorker.register('./sw.js').catch(()=>{}));}</script></body></html>"""
ROOT.joinpath('index.html').write_text(page, encoding='utf-8')
print(f'Root index written to {ROOT / "index.html"}')
