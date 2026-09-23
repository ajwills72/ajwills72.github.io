# Privacy controls — 23 September 2026

Owner: Sophie (Software developer). Requested by Andy after the GA4 deployment.

## Implemented

- Basic opt-in: no Google Analytics script or consent pings before acceptance.
- Equal accept/reject buttons, 90-day browser preference, permanent footer settings and privacy link on all themed and 43 legacy pages.
- Withdrawal disables GA, clears accessible GA cookies and reloads to unload the Google script. Other open tabs using these controls react to preference changes. Invalid, expired or inaccessible storage defaults to no consent.
- Google signals/advertising features disabled in tag configuration; ad consent denied. 90-day non-rolling GA cookies. Initial page/referrer query strings and fragments omitted.
- Removed FreeVisitorCounters from the shared layout.
- Published privacy notice covers consent, storage, analytics, hosting/resource providers, contact, retention, transfers and rights.

## Account review

Property 495334398, G-14MBRS9W2N, in syntexis account.
- Google signals: already off.
- User-provided data collection: already off.
- Advertising personalisation: changed from 307/307 to 0/307 regions; confirmed in UI.
- Granular location/device collection: turned off; confirmed in UI.
- Retention: event data 2 months, user data 14 months, reset on new activity enabled. Read and disclosed, not changed.

## Verification

Run from repository root:

    UV_CACHE_DIR=/tmp/andy-privacy-uv uv run --no-project --with quickjs python docs/privacy/test-consent.py
    ruby docs/site-audit-2026-09-21/preview-build.rb
    python3 docs/site-audit-2026-09-21/validate-preview.py

Consent-state tests cover default/rejected/accepted, single tag insertion, withdrawal, GA cookie cleanup, expired/invalid preferences, unavailable storage, cross-tab revocation and privacy configuration. These are isolated JS tests with simulated browser APIs, supplemented by actual browser checks.

Build: 157 HTML pages. Each has one local consent script, settings controls and privacy link; none has an unconditional remote Analytics loader or visitor-counter reference. Internal link/duplicate-ID/metadata validation passed. Chrome preview confirmed no remote Analytics script before consent or after rejection and reload; settings available on legacy EXE10. Mobile 390×844 showed equal visible accept/reject buttons and a scrollable banner.

## Limits and owner follow-up

This is a technical privacy improvement, not a certification of full GDPR/PECR compliance. Provider contracts, acceptance of applicable Google processor terms, transfer safeguards for the specific account, any ICO fee/registration obligation, and handling of rights requests require the owner's organisational/legal review. No terms or legal acknowledgements were accepted on Andy's behalf. Retention changes and deletion of data collected before this deployment were not performed.

External font and library CDN requests remain and are disclosed; they are not covered by the Analytics choice. Separately deployed projects (including RMINR) are outside this change and require their own assessment. Existing open pages loaded before this release may still run their previously loaded scripts until closed or refreshed.

Sources consulted: ICO storage/access guidance and right-to-be-informed guidance; Google Analytics configuration/privacy/retention documentation; GitHub Pages hosting/privacy documentation.
