"""Run with: uv run --no-project --with quickjs python docs/privacy/test-consent.py"""
from pathlib import Path
import json
import quickjs

source = Path('assets/js/privacy.js').read_text()
harness = r'''
var now = 1800000000000; Date.now = function() { return now; };
var store = {}, blocked = false, loads = [], writes = [], events = {}, docEvents = {}, reloads = 0, timer;
var location = {hostname:'www.andywills.info', pathname:'/willslab-dau/exe10/', origin:'https://www.andywills.info', reload:function(){reloads++;}};
var localStorage = {getItem:function(k){if(blocked)throw Error();return store[k] || null;},setItem:function(k,v){if(blocked)throw Error();store[k]=v;}};
var window = {addEventListener:function(k,v){events[k]=v;}};
function setTimeout(f,n){timer=f;return 1;} function clearTimeout(){}
function URL(s) { if(!s) throw Error(); this.origin='https://example.org'; this.pathname='/source'; }
function el(attrs) {return {attrs:attrs || {},hidden:false,textContent:'',setAttribute:function(k,v){this.attrs[k]=v;},getAttribute:function(k){return this.attrs[k];},addEventListener:function(k,v){this[k]=v;},focus:function(){}};}
var accept=el({'data-choice':'accepted'}),reject=el({'data-choice':'rejected'}),close=el(),link=el(),status=el(),settings=el(),panel=el();
panel.querySelector=function(s){return s==='a'?link:s==='.privacy-status'?status:s==='[data-close]'?close:accept;};
panel.querySelectorAll=function(){return [accept,reject];};
var document={currentScript:el({'data-analytics-id':'G-14MBRS9W2N','data-privacy-url':'/privacy/'}),readyState:'complete',referrer:'https://example.org/source?secret=yes',hidden:false,head:{appendChild:function(x){loads.push(x.src);}},body:{appendChild:function(){}},createElement:function(t){return t==='section'?panel:el();},querySelectorAll:function(){return [settings];},addEventListener:function(k,v){docEvents[k]=v;}};
Object.defineProperty(document,'cookie',{get:function(){return '_ga=old; _ga_14MBRS9W2N=old; essential=keep';},set:function(v){writes.push(v);}});
'''

def setup(record=None, blocked=False):
    ctx=quickjs.Context();ctx.eval(harness)
    if record is not None: ctx.eval('store["andywills.analytics-consent.v1"] = '+json.dumps(record)+';')
    if blocked: ctx.eval('blocked=true;')
    ctx.eval(source);return ctx

def check(ctx, expression):
    assert ctx.eval(expression), expression

c=setup();check(c,'loads.length===0 && panel.hidden===false && window["ga-disable-G-14MBRS9W2N"]===true')
check(c,'writes.length>0 && writes.every(function(x){return x.indexOf("essential")===-1;})')
c.eval('reject.click()');check(c,'loads.length===0 && JSON.parse(store["andywills.analytics-consent.v1"]).choice==="rejected"')
c.eval('settings.click(); accept.click(); accept.click()');check(c,'loads.length===1')
check(c,'window.dataLayer.filter(function(x){return x[0]==="config";}).length===1')
check(c,'window.dataLayer[2][2].allow_google_signals===false && window.dataLayer[2][2].cookie_update===false')
check(c,'window.dataLayer[2][2].page_location==="https://www.andywills.info/willslab-dau/exe10/"')
c.eval('settings.click(); reject.click()');check(c,'window["ga-disable-G-14MBRS9W2N"]===true && reloads===1')
for record in ['broken', json.dumps({'choice':'accepted','expires':1799999999999}),json.dumps({'choice':'unknown','expires':1800000001000})]:
    check(setup(record),'loads.length===0 && panel.hidden===false')
valid=json.dumps({'choice':'accepted','expires':1800000001000})
c=setup(valid);check(c,'loads.length===1 && panel.hidden===true')
c.eval('now+=1001;timer()');check(c,'window["ga-disable-G-14MBRS9W2N"]===true && reloads===1')
c=setup(valid);c.eval('store={};events.storage({key:null})');check(c,'reloads===1 && window["ga-disable-G-14MBRS9W2N"]')
c=setup(blocked=True);check(c,'loads.length===0');c.eval('accept.click()');check(c,'loads.length===1');c.eval('reject.click()');check(c,'reloads===1')
print('Consent tests passed: default off, reject, accept once, withdrawal, cookie cleanup, expiry, invalid/blocked storage, cross-tab revocation and privacy config.')
