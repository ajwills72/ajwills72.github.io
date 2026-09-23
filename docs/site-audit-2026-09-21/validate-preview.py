from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import urlsplit,urljoin,unquote
import json,collections
ROOT=Path('/tmp/andy-site-preview');baseline=json.load(open('docs/site-audit-2026-09-21/results.json'))
class P(HTMLParser):
 def __init__(self):super().__init__();self.links=[];self.ids=[];self.lang=False;self.viewport=False
 def handle_starttag(self,t,a):
  a=dict(a)
  if a.get('id'):self.ids.append(a['id'])
  if t=='html':self.lang=bool(a.get('lang'))
  if t=='meta' and a.get('name')=='viewport':self.viewport=True
  for attr in (['href'] if t in ['a','link'] else ['src'] if t in ['img','script','source','iframe'] else []):
   if a.get(attr):self.links.append(a[attr])
def locate(path):
 p=ROOT/unquote(path).lstrip('/')
 for x in [p,p/'index.html',Path(str(p)+'.html'),Path(str(p).rstrip('/')+'.html')]:
  if x.is_file():return x
bad=[];dupes=[];metadata=[]
for f in ROOT.rglob('*.html'):
 rel=f.relative_to(ROOT).as_posix();src='/'+rel
 # Model GitHub Pages pretty URLs for Markdown-generated flat HTML pages.
 if not src.endswith('/index.html') and (Path(rel).with_suffix('.md')).exists():src=src[:-5]+'/'
 p=P();p.feed(f.read_text(errors='replace'))
 for id,n in collections.Counter(p.ids).items():
  if n>1:dupes.append([src,id,n])
 if not p.lang or not p.viewport:metadata.append([src,p.lang,p.viewport])
 for href in p.links:
  u=urlsplit(urljoin('http://127.0.0.1:8765'+src,href))
  if u.hostname not in ['127.0.0.1','www.andywills.info','andywills.info','ajwills72.github.io']:continue
  if locate(u.path):continue
  remote='https://www.andywills.info'+u.path
  old=baseline.get(remote,{})
  if old.get('status')=='200':continue # Separate deployed project, outside this checkout.
  bad.append([src,href,u.path])
result={'html_pages':len(list(ROOT.rglob('*.html'))),'broken':bad,'duplicate_ids':dupes,'missing_metadata':metadata}
Path('/tmp/andy-site-audit/validation.json').write_text(json.dumps(result,indent=2))
print(json.dumps(result,indent=2))
