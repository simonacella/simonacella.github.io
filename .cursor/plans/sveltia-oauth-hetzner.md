# OAuth auth proxy (Hetzner) — parked

**Parent:** [sveltia-cms.md](./sveltia-cms.md)  
**Status:** Parked — **do not implement until explicitly un-parked**

## Why this exists

One-click “Sign in with GitHub” needs an OAuth **client secret**. A static `/admin` SPA cannot hold that secret. Something server-side must exchange `code` → access token, then `postMessage` the token to the CMS popup (Decap/Sveltia contract).

GitHub SPA PKCE is not something we rely on yet for this stack; until then the choices are **PAT** (no server) or a **secret-holding endpoint**.

## Decision

- **Now:** PAT only (`admin/config.yml` → `auth_methods: [token]`). No Cloudflare.
- **Later (optional):** tiny HTTPS service on an existing **Hetzner** VPS (or equivalent), not a second static site.

Cloudflare Worker is the same *job* with a different host — rejected for vendor-surface reasons; Hetzner is the preferred host *if* OAuth is un-parked.

## Implementor brief (source of truth for the server project)

Hand this to the Hetzner/auth-service agent — generic, not site-specific:

[`_review/oauth-auth-proxy-implementor-brief.md`](../../_review/oauth-auth-proxy-implementor-brief.md)

Do **not** duplicate that brief here. When un-parking: wire `backend.base_url` to the service origin and set the GitHub OAuth App callback to `/callback`.

## Out of scope while parked

- Deploying Workers or VPS auth code from this repo
- Changing `auth_methods` away from `[token]`
- Netlify/Vercel OAuth proxies
