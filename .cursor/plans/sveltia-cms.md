# Sveltia CMS

Remote `/admin` (GitHub OAuth via `auth.rednaw.nl`). Shipped invariants: `.cursor/rules/sveltia-cms.mdc`. Human map: [`MAINTAINER.md`](../../MAINTAINER.md). OAuth proxy contract: iac `docs/future/oauth-auth-proxy-implementor-brief.md` and `_review/` in this repo — do not re-implement from Jekyll.

## Decided

| | |
|--|--|
| Mode | Remote `/admin`. `base_url` + `auth_methods: [oauth]`. `skip_ci: false`. |
| Local Repository | Optional, maintainer spikes only. |
| Soft launch | `translation_public` on EN/FR — see the rule. |
| Field copy | Author-facing Italian labels/hints in `admin/config.yml` (no paths, Liquid, or «SEO»). |
| README aim | Demystify Sveltia vs GitHub file UI. One concrete Italian publish win. |
| Spine / login / form / close | Concrete win · bottone + Authorize · three form crops · live site shot. |
| Example piece | [L’Africa al Lido…](https://www.nigrizia.it/notizia/cinema-africano-venezia-83-film-mostra); fragments OK; republication Nigrizia. |
| Author docs | `README.md` = CMS visual story; `GUIDA-FILE.md` = YAML hand-edit; both excluded from Pages. |
| Screenshots | `assets/img/admin-guide/01-accedi.png` … `08-online.png` (wired in `README.md`). |

## Decide

None.

## Do

### 0. Optional reshoots

can start now — GitHub **Authorize** (permission) if preferred over sign-in; dedicated Publish click; YouTube/Immagine insert. Replace files in `assets/img/admin-guide/` keeping the same names (or adjust README).
