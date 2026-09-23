/* Analytics is never requested until the visitor explicitly opts in. */
(function () {
  'use strict';
  var script = document.currentScript;
  var id = script.getAttribute('data-analytics-id');
  var privacyUrl = script.getAttribute('data-privacy-url');
  var key = 'andywills.analytics-consent.v1';
  var lifetime = 90 * 24 * 60 * 60 * 1000;
  var loaded = false;
  var panel, status, settings;
  var expiryTimer;
  window['ga-disable-' + id] = true;

  function readChoice() {
    try {
      var value = JSON.parse(localStorage.getItem(key));
      if (value && (value.choice === 'accepted' || value.choice === 'rejected') &&
          typeof value.expires === 'number' && value.expires > Date.now() &&
          value.expires <= Date.now() + lifetime) return value;
    } catch (error) { /* Unavailable or invalid storage means no consent. */ }
    return null;
  }

  function clearCookies() {
    var names = document.cookie.split(';').map(function (part) { return part.trim().split('=')[0]; });
    var hostParts = location.hostname.split('.');
    var domains = [''];
    for (var i = 0; i < hostParts.length - 1; i++) domains.push(hostParts.slice(i).join('.'));
    var parts = location.pathname.split('/');
    var paths = ['/'];
    for (var j = 1; j < parts.length; j++) paths.push(parts.slice(0, j + 1).join('/'));
    names.filter(function (name) { return /^(_ga($|_)|_gid$|_gat($|_))/.test(name); }).forEach(function (name) {
      domains.forEach(function (domain) {
        paths.forEach(function (path) {
          document.cookie = name + '=; Max-Age=0; path=' + path +
            (domain ? '; domain=' + domain : '') + '; SameSite=Lax';
        });
      });
    });
  }

  function stopAnalytics() {
    window['ga-disable-' + id] = true;
    clearCookies();
    if (loaded) location.reload(); // Unload Google's script as well as blocking further hits.
  }

  function startAnalytics() {
    if (loaded || !/^G-[A-Z0-9]+$/.test(id)) return;
    loaded = true;
    window['ga-disable-' + id] = false;
    window.dataLayer = window.dataLayer || [];
    window.gtag = function () { window.dataLayer.push(arguments); };
    window.gtag('consent', 'default', {
      analytics_storage: 'granted', ad_storage: 'denied',
      ad_user_data: 'denied', ad_personalization: 'denied'
    });
    window.gtag('js', new Date());
    var referrer = '';
    try { var ref = new URL(document.referrer); referrer = ref.origin + ref.pathname; } catch (error) {}
    window.gtag('config', id, {
      allow_google_signals: false,
      allow_ad_personalization_signals: false,
      cookie_expires: lifetime / 1000,
      cookie_update: false,
      page_location: location.origin + location.pathname,
      page_referrer: referrer
    });
    var tag = document.createElement('script');
    tag.async = true;
    tag.src = 'https://www.googletagmanager.com/gtag/js?id=' + encodeURIComponent(id);
    document.head.appendChild(tag);
  }

  function scheduleExpiry(record) {
    clearTimeout(expiryTimer);
    if (!record || record.choice !== 'accepted') return;
    // setTimeout has a maximum delay of about 24 days; recheck for longer consents.
    expiryTimer = setTimeout(sync, Math.min(record.expires - Date.now() + 1, 2147483647));
  }

  function sync() {
    var record = readChoice();
    scheduleExpiry(record);
    if (record && record.choice === 'accepted') startAnalytics();
    else stopAnalytics();
    if (panel) {
      panel.hidden = !!record;
      status.textContent = record && record.choice === 'accepted' ?
        'Analytics is on. You can withdraw consent by choosing Reject analytics.' :
        'Analytics is off. You can use the whole website without accepting.';
    }
  }

  function choose(choice) {
    var record = {choice: choice, expires: Date.now() + lifetime};
    var saved = false;
    try { localStorage.setItem(key, JSON.stringify(record)); saved = !!readChoice(); } catch (error) {}
    if (choice === 'accepted') {
      // When storage is blocked, consent applies only to this page visit.
      startAnalytics();
      scheduleExpiry(record);
    } else stopAnalytics();
    panel.hidden = true;
    settings.forEach(function (button) { button.textContent = 'Cookie settings'; });
    if (settings[0]) settings[0].focus({preventScroll: true});
    if (!saved && choice === 'accepted') status.textContent = 'Your choice could not be saved; it applies only to this page visit.';
  }

  function init() {
    panel = document.createElement('section');
    panel.className = 'privacy-banner';
    panel.setAttribute('role', 'region');
    panel.setAttribute('aria-label', 'Analytics choice');
    panel.innerHTML = '<h2>Optional analytics</h2>' +
      '<p>With your permission, Google Analytics uses cookies to help Andy Wills understand how this website is used. ' +
      'It is off until you accept. Rejecting does not affect access to the site. ' +
      'Your choice is stored on this browser for 90 days; change it using Cookie settings.</p>' +
      '<p class="privacy-status" role="status"></p><div class="privacy-actions">' +
      '<button type="button" data-choice="accepted">Accept analytics</button>' +
      '<button type="button" data-choice="rejected">Reject analytics</button>' +
      '<a>Privacy and cookies</a><button type="button" data-close hidden>Close</button></div>';
    panel.querySelector('a').href = privacyUrl;
    status = panel.querySelector('.privacy-status');
    document.body.appendChild(panel);
    settings = Array.prototype.slice.call(document.querySelectorAll('[data-cookie-settings]'));
    settings.forEach(function (button) {
      button.hidden = false;
      button.addEventListener('click', function () {
        status.textContent = loaded && !window['ga-disable-' + id] ?
          'Analytics is on. Choose Reject analytics to withdraw consent.' : 'Analytics is off.';
        panel.hidden = false;
        panel.querySelector('[data-close]').hidden = false;
        panel.querySelector('button').focus();
      });
    });
    panel.querySelectorAll('[data-choice]').forEach(function (button) {
      button.addEventListener('click', function () { choose(button.getAttribute('data-choice')); });
    });
    panel.querySelector('[data-close]').addEventListener('click', function () {
      panel.hidden = true;
      if (settings[0]) settings[0].focus({preventScroll: true});
    });
    sync();
    window.addEventListener('storage', function (event) { if (event.key === key || event.key === null) sync(); });
    window.addEventListener('pageshow', sync);
    document.addEventListener('visibilitychange', function () { if (!document.hidden) sync(); });
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
  else init();
}());
