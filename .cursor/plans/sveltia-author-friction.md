# Author friction / handoff

**Parent:** [sveltia-cms.md](./sveltia-cms.md)  
**Status:** Open  
**Goal:** Lowest-friction path for a non-developer author using `/admin`.

## Done

- [x] Form-based posts instead of GitHub “Create file”
- [x] Auto `lang` via hidden `default: "{{locale}}"` + `i18n: true`
- [x] Date fields use `type: date` (ISO `YYYY-MM-DD`; fixed bad `yyyy-MM-dd` → `yyyy-08-Su`)
- [x] i18n file naming aligned with polyglot (`multiple_files`, omit default locale)
- [x] Cover + body media share `/assets/img/posts` (field-level `public_folder: posts` broke thumbnails — treated as entry-relative)
- [x] **About page in CMS** — `_data/about.yml` + file collection Pagine → Chi sono
- [x] **YouTube in CMS** — Insert → YouTube → `{% youtube "…" %}` via `registerEditorComponent` in `admin/index.html`
- [x] `skip_ci: true` so Save does not wait on Pages every typo
- [x] Investigation + author-UX canvases (IDE); OAuth/Hetzner parked with brief

## Next / open

- [ ] **Editor opens mid-form** — not a known open upstream bug; no `index.html` hacks. A/B: Sync Scrolling / Show Second Pane.
- [ ] **Smoke gate (local):** open triad + new IT-only draft via Local Repository; inspect files on disk; `JEKYLL_ENV=production bundle exec jekyll build`; discard junk
- [x] `omit_empty_optional_fields: true` — empty optionals omitted (no `publisher: ''`)
- [x] Optional `republication` object (checkbox; nested `publisher` + `publication_link`)
- [ ] Tighten Italian labels/hints in `admin/config.yml`
- [ ] Short Italian `/admin` checklist — **after** local UX; remote PAT steps only when leaving local-only
- [ ] Selective soft launch — **later** ([sveltia-selective-soft-launch.md](./sveltia-selective-soft-launch.md))
- [ ] Pin `@sveltia/cms` version already done in `admin/index.html` — bump deliberately on upgrade

## Not her problem (keep invisible)

- Git branches/PRs (editorial workflow off)
- YAML indent/quotes for posts (CMS writes front matter)
- Polyglot pairing rules (filename + `lang` automation)
- Brave File System Access flag (local-dev only; she uses remote `/admin`)

## Success test

She publishes a new Italian article (cover, body image, optional YouTube line) without opening the GitHub file editor.
