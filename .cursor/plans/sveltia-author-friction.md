# Author friction / handoff

Lowest-friction path for a non-developer author using `/admin`. Parent: [sveltia-cms.md](./sveltia-cms.md). Shipped CMS behaviour is `.cursor/rules/sveltia-cms.mdc` — do not relitigate it here.

## Decided

| | |
|--|--|
| Invisible to her | Git branches/PRs (editorial off); YAML indent for posts; polyglot pairing; Brave File System Access (local-dev only). |
| Success | She publishes a new Italian article (cover, body image, optional YouTube) without opening the GitHub file editor. |

## Decide

None.

## Do

### 0. Editor opens mid-form

can start now — not a known open upstream bug; no `index.html` hacks. A/B: Sync Scrolling / Show Second Pane.

### 1. Smoke gate (local)

can start now — open triad + new IT-only draft via Local Repository; inspect files on disk; `JEKYLL_ENV=production bundle exec jekyll build`; discard junk.

### 2. Italian labels and checklist

can start now — tighten Italian labels/hints in `admin/config.yml`. Short Italian `/admin` checklist (Sign in with GitHub + Save → deploy).
