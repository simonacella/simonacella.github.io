# Sveltia CMS (main hub)

**Mode now:** remote `/admin` (GitHub OAuth via `auth.rednaw.nl`). **Shipped invariants:** `.cursor/rules/sveltia-cms.mdc`. **Human map:** [`MAINTAINER.md`](../../MAINTAINER.md).

## Status

| Track | Status | Plan / note |
|---|---|---|
| Remote `/admin` + OAuth | **In use** | `base_url` + `auth_methods: [oauth]`; `skip_ci: false` |
| Local Repository | Optional | maintainer spikes only |
| Auto `lang` / dates / omit empty / `republication` / slugify uploads | Done | see rule |
| OAuth (Hetzner) | **Done** | [sveltia-oauth-hetzner.md](./sveltia-oauth-hetzner.md) → `_review/…` |
| Author friction | **Next** | [sveltia-author-friction.md](./sveltia-author-friction.md) |
| Selective soft launch | **Done** | `translation_public`; see rule |
| README → CMS-first | Later | after author checklist |

## Next action

Author friction (hints, smoke, Italian `/admin` checklist) — [sveltia-author-friction.md](./sveltia-author-friction.md).
