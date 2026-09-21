# Sveltia CMS

Remote `/admin` (GitHub OAuth via `auth.rednaw.nl`). Shipped invariants: `.cursor/rules/sveltia-cms.mdc`. Human map: [`MAINTAINER.md`](../../MAINTAINER.md). OAuth proxy contract: iac `docs/future/oauth-auth-proxy-implementor-brief.md` and `_review/` in this repo — do not re-implement from Jekyll.

## Decided

| | |
|--|--|
| Mode | Remote `/admin`. `base_url` + `auth_methods: [oauth]`. `skip_ci: false`. |
| Local Repository | Optional, maintainer spikes only. |
| Soft launch | `translation_public` on EN/FR — see the rule. |
| Field copy | Author-facing Italian labels/hints in `admin/config.yml` (no paths, Liquid, or «SEO»). |
| README | Italian author ops; CMS-first only when the checklist below ships. |

## Decide

None.

## Do

### 0. README → CMS-first

can start now — short Italian `/admin` checklist in `README.md` (Sign in with GitHub → Nuovo articolo → Salva → aspetta il sito), then treat README as CMS-first author ops.
