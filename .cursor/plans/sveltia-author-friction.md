# Author friction / handoff

**Parent:** [sveltia-cms.md](./sveltia-cms.md)  
**Status:** Open  
**Goal:** Lowest-friction path for a non-developer author using `/admin`.

## Done

- [x] Form-based posts instead of GitHub “Create file”
- [x] Auto `lang` via hidden `default: "{{locale}}"` + `i18n: true`
- [x] Date fields use `type: date` (ISO `YYYY-MM-DD`; fixed bad `yyyy-MM-dd` → `yyyy-08-Su`)
- [x] i18n file naming aligned with polyglot (`multiple_files`, omit default locale)
- [x] Cover vs body media folders configured (`posts/…` vs `/assets/img/posts/…`)
- [x] `skip_ci: true` so Save does not wait on Pages every typo
- [x] Investigation + author-UX canvases (IDE); OAuth/Hetzner parked with brief

## Next / open

- [ ] **Selective soft launch** — see [sveltia-selective-soft-launch.md](./sveltia-selective-soft-launch.md)
- [ ] **Smoke gate:** existing triad (e.g. Dahomey) + new IT-only draft; inspect committed YAML; `JEKYLL_ENV=production` build / `content_lint` green; discard test junk
- [x] `omit_empty_optional_fields: true` — empty optionals omitted (no `publisher: ''`)
- [x] Optional `republication` object (checkbox; nested `publisher` + `publication_link`)
- [ ] Tighten Italian labels/hints in `admin/config.yml`
- [ ] Short Italian `/admin` checklist (README stays YAML fallback until CMS is primary)
- [ ] PAT handoff steps for Simona (create token → paste); OAuth only after [sveltia-oauth-hetzner.md](./sveltia-oauth-hetzner.md) un-parked
- [ ] Pin `@sveltia/cms` version already done in `admin/index.html` — bump deliberately on upgrade

## Not her problem (keep invisible)

- Git branches/PRs (editorial workflow off)
- YAML indent/quotes for posts (CMS writes front matter)
- Polyglot pairing rules (filename + `lang` automation)
- Brave File System Access flag (local-dev only; she uses remote `/admin`)

## Success test

She publishes a new Italian article (cover, body image, optional YouTube line) without opening the GitHub file editor.
