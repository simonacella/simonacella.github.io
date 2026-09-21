# Sveltia CMS

Remote `/admin` (GitHub OAuth via `auth.rednaw.nl`). Shipped invariants: `.cursor/rules/sveltia-cms.mdc`. Human map: [`MAINTAINER.md`](../../MAINTAINER.md). OAuth proxy contract: iac `docs/future/oauth-auth-proxy-implementor-brief.md` and `_review/` in this repo — do not re-implement from Jekyll.

## Decided

| | |
|--|--|
| Mode | Remote `/admin`. `base_url` + `auth_methods: [oauth]`. `skip_ci: false`. |
| Local Repository | Optional, maintainer spikes only. |
| Soft launch | `translation_public` on EN/FR — see the rule. |
| README | Italian author ops, not CMS-first until author friction lands. |

## Decide

None.

## Do

### 0. Author friction

can start now — [sveltia-author-friction.md](./sveltia-author-friction.md).

### 1. README → CMS-first

after author friction — only if that plan’s Italian `/admin` checklist is in use.
