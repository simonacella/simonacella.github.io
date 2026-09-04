# Brief: OAuth callback proxy for a static Git-backed CMS

**Audience:** AI (or human) implementor of a small auth service on an existing VPS (e.g. Hetzner).  
**Scope:** Everything required from the **server project’s** point of view.  
**Style:** Requirements and contracts only — no language, framework, or process-manager choices.

---

## 1. Purpose

Provide a **minimal HTTPS service** that lets a **browser-based, static CMS** complete GitHub’s (or compatible forge’s) **OAuth authorization-code** login.

The CMS cannot hold an OAuth **client secret**. This service holds the secret and performs the **code → access token** exchange, then returns the token to the CMS via the browser popup protocol described below.

This is **login glue only**. It is not the CMS, not the website, and not the git host.

---

## 2. Non-goals (explicitly out of scope)

Do **not** implement or host:

- The public website or CMS admin UI (those stay on static hosting).
- Content storage, media, or git commit/push on behalf of the user after login.
- User accounts, passwords, or a separate identity system.
- PKCE-only public-client flow (no secret) — that is a forge/CMS capability, not this service’s job.
- Multi-tenant SaaS for arbitrary third-party sites (unless the operator later expands scope).
- High availability / multi-region design beyond “reliable enough for occasional human logins.”

After a successful login, the CMS talks **directly** to the git host API. This service is idle until the next sign-in.

---

## 3. Actors and trust boundaries

| Actor | Role |
|---|---|
| **Content author** | Uses the CMS in a browser; clicks “Sign in with GitHub” (or equivalent). |
| **CMS (static SPA)** | Opens an OAuth popup pointed at this service; receives the access token; stores it client-side; calls the git host API. |
| **This service (VPS)** | Holds client id/secret; starts OAuth; exchanges `code` for token; hands token to the popup’s opener. |
| **Git host (e.g. GitHub)** | Issues codes and tokens; enforces repo permissions. |
| **Operator** | Deploys this service, registers the OAuth app, configures secrets and DNS/TLS. |

**Trust rule:** The client secret never appears in the CMS, the static site, or client-side source. User access tokens are not required to be persisted on this server after the response is sent to the browser.

---

## 4. Integration contract (what the CMS expects)

The CMS is configured with a **backend base URL** equal to this service’s public origin (scheme + host, no path), for example `https://auth.example.com`.

Typical CMS settings (handled by the CMS project, not this one):

- Git backend name (e.g. `github`)
- Repository identity
- `base_url` → this service’s origin

This service must be compatible with the **Decap/Netlify CMS–style OAuth proxy** protocol used by Sveltia CMS and similar tools:

### 4.1 Routes

| Method | Path | Role |
|---|---|---|
| `GET` | `/auth` (alias `/oauth/authorize` acceptable) | Start login: validate request, set CSRF state, redirect to the forge authorize URL. |
| `GET` | `/callback` (alias `/oauth/redirect` acceptable) | Forge redirect target: validate state, exchange `code` for token, return HTML that talks to `window.opener`. |

Unknown paths: `404`.

### 4.2 `/auth` query parameters (incoming from CMS popup)

- `provider` — e.g. `github` (required; reject unsupported providers clearly).
- `site_id` — optional hostname of the site using the CMS; may be used for an allowlist.
- `scope` — optional; if present, only accept known-safe scopes for that provider; otherwise use a documented default suitable for private/public repo content editing (for GitHub, a typical default is repo + user identity scopes).

### 4.3 `/callback` query parameters (incoming from forge)

- `code` — authorization code
- `state` — must match the CSRF value established in `/auth`

### 4.4 Popup → CMS handoff (required behavior)

The callback response is an **HTML document** that runs in the OAuth **popup** and uses `postMessage`:

1. Notify readiness to the opener (provider-specific ready signal, e.g. for GitHub: message data `authorizing:github`).
2. When the opener replies with the matching authorizing message, send the result to `event.origin` (do not use `*` for the token-bearing message).
3. Success payload shape (string message):  
   `authorization:<provider>:success:` + JSON object including at least `{ provider, token }`.
4. Failure payload shape:  
   `authorization:<provider>:error:` + JSON object including `{ provider, error }` (and optionally a stable `errorCode` for UI).

Clear the CSRF cookie after the callback attempt.

**CSRF:** Bind a random state to an HttpOnly, Secure, short-lived cookie at `/auth`; verify it on `/callback` before exchanging the code.

---

## 5. Forge-side setup (operator responsibilities; document for handoff)

The operator (or a sibling checklist) must:

1. Create an **OAuth App** on the git host.
2. Set the **authorization callback URL** to this service’s public callback URL  
   (`https://<this-service-host>/callback`).
3. Obtain **client id** and **client secret**.
4. Place id + secret only in this service’s runtime configuration (environment / secret store on the VPS).
5. Ensure CMS users who should publish have **write access** to the target repository on the forge. OAuth does not bypass forge ACLs.

This server project does not create the OAuth App; it **consumes** the credentials.

---

## 6. Configuration this service must support

Provide configuration (env or equivalent) for at least:

| Name (illustrative) | Required | Meaning |
|---|---|---|
| Client id | yes | OAuth app id |
| Client secret | yes | OAuth app secret |
| Public origin | yes | Canonical `https://host` used for redirects where the forge requires `redirect_uri` |
| Allowed site hostnames | recommended | If set, only CMS popups / `site_id` values matching the list may use the service (support exact hosts; optional wildcards are fine if documented) |
| Forge hostname | optional | Default public forge (e.g. `github.com`); override for enterprise |

Do not commit secrets to any git repository. Document how the operator injects them on the VPS.

---

## 7. Hosting expectations (VPS, implementation-agnostic)

The deployable unit must:

1. Listen on an internal port or socket as the operator prefers.
2. Be reachable at a **stable public hostname** over **HTTPS** (TLS termination may be this process or a reverse proxy in front — either is fine).
3. Survive reboot (restart policy under the operator’s process supervisor).
4. Expose only the auth routes publicly; no admin UI required.
5. Log enough to diagnose failed logins (without logging the client secret or access tokens).

Uptime need: **human login frequency**, not request-heavy APIs. Brief downtime blocks **new** sign-ins only.

DNS for the hostname points at this VPS (or the proxy in front of it).

---

## 8. Security requirements

- Client secret only on the server; never returned to the browser except as part of forging the token exchange server-to-server.
- CSRF state as above.
- Prefer allowing only configured site hostnames when the operator supplies an allowlist.
- Use HTTPS only in production.
- Do not log tokens or secrets.
- Do not act as an open relay: reject unknown providers and disallowed domains.
- Principle of least privilege on scopes: prefer the CMS-requested scope when it is within an allowlist; otherwise fall back to a documented default and do not honor arbitrary scope strings.

---

## 9. Provider support

**Minimum for v1:** GitHub (github.com).

Optional later: GitLab or others, behind the same `/auth` + `/callback` shape, only if `provider` is explicitly supported and credentials exist.

Unsupported `provider` → user-visible error via the same postMessage error path (or an error HTML page that still notifies the opener).

---

## 10. Deliverables from this project

1. Runnable auth service meeting the contract above.
2. Operator README: DNS/TLS, env vars, OAuth App callback URL, how to point a CMS `base_url` at this origin, smoke-test steps.
3. Declared default scopes and allowlist behavior.
4. No dependency on any particular static site repo layout or CMS content model.

---

## 11. Acceptance criteria

The implementation is done when all of the following hold:

1. Given a valid OAuth app and CMS configured with `base_url` = this origin, clicking **Sign in with GitHub** in the CMS completes without a personal access token.
2. A wrong or reused `state` does not yield a token.
3. With an allowlist configured, a CMS on a non-allowed host cannot obtain a token.
4. Secrets are not present in the CMS static assets or in this project’s tracked source.
5. Stopping this service does not take down the static site; it only prevents new OAuth logins.
6. After login, CMS content operations succeed or fail solely based on forge permissions and CMS config — this service is not in that path.

---

## 12. Smoke test (manual)

1. Set secrets and HTTPS hostname.
2. Register OAuth app callback to `/callback`.
3. Point a test CMS `backend.base_url` at this origin.
4. Open CMS → Sign in with GitHub → authorize → land authenticated in the CMS.
5. Confirm a forge API call from the CMS works (e.g. list repo contents).
6. Revoke or stop the service and confirm a **fresh** login fails while the static site still loads.

---

## 13. Handoff inputs the implementor should ask the operator for

If missing, request:

- Public hostname for the auth service  
- GitHub (or forge) OAuth client id and secret  
- Whether enterprise/self-hosted forge hostnames apply  
- Allowed CMS site hostnames (e.g. `example.github.io`, `www.example.com`)  
- Whether only GitHub is required for v1  

Do **not** require access to the static site’s source or build pipeline beyond knowing the CMS `base_url` value and callback URL to document.
