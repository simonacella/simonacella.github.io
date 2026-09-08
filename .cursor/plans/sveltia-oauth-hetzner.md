# OAuth auth proxy (Hetzner) — done

**Parent:** [sveltia-cms.md](./sveltia-cms.md)  
**Status:** Done — production `/admin` signs in with GitHub via OAuth

## Shipped

- Auth proxy origin: `https://auth.tientjeketama.nl` (Hetzner VPS; secret not in this repo)
- CMS: `backend.base_url` + `auth_methods: [oauth]` in `admin/config.yml`
- GitHub OAuth App callback: `https://auth.tientjeketama.nl/callback`
- Verified: Sign in with GitHub completes on production `/admin`

## Why this exists

One-click “Sign in with GitHub” needs an OAuth **client secret**. A static `/admin` SPA cannot hold that secret. The VPS exchanges `code` → access token, then `postMessage`s the token to the CMS popup (Decap/Sveltia contract).

## Server contract (reference)

[`_review/oauth-auth-proxy-implementor-brief.md`](../../_review/oauth-auth-proxy-implementor-brief.md) — keep for the auth-service project; do not re-implement from this Jekyll repo.
