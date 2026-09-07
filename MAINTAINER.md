# Maintainer notes — Sveltia

Up-to-date picture of the **Sveltia CMS** effort (for you). Agents: rewrite this when the story changes; do not add a second maintainer doc. Code invariants: `.cursor/rules/sveltia-cms.mdc`. Pending tasks: `.cursor/plans/`.

## What we’re doing

Replace GitHub’s awkward web UI with **`/admin`** (Sveltia) so Simona can write Italian posts (and later EN/FR) as forms that commit Markdown to this repo. The public site stays Jekyll on GitHub Pages.

## Where we are

**Remote `/admin` in use.** Production `https://simonacella.github.io/admin/` with GitHub classic PAT (`auth_methods: [token]`). Saves commit to `main`. **`skip_ci: false`** — every Save triggers Pages (build + deploy). Local Repository still works for maintainer spikes (`jekyll serve` → Local Repository). Sveltia pinned at **0.205.3** (Renovate watches the unpkg pins in `admin/`; review those PRs, don’t automerge).

**Config** in `admin/` — pinned Sveltia, Italian-first locales, cover + body both `/assets/img/posts`, **`slugify_filename`** on uploads, **Pagine → Chi sono** (`_data/about.yml`), Insert → YouTube for `{% youtube %}`, auto `lang`, sane dates, empty optionals omitted, optional **`republication`** checkbox. Nested `republication` front matter for prior publishers. Cover `img: /assets/img/posts/…`. Preview pane on for posts/about. Scroll-to-top workaround in `admin/index.html`.

**Auth:** PAT now; OAuth later (Hetzner brief in `_review/`).

**Soft launch:** still all-or-nothing (`lang_switcher_public: false`). Selective soft launch is **later**.

**Author docs:** `README.md` still YAML-by-hand; CMS-first checklist later.

## Next

1. Author friction (Italian hints, smoke, `/admin` checklist) — `.cursor/plans/sveltia-author-friction.md`.
2. Later: OAuth, selective soft launch, README CMS-first.

## Try it

```bash
# Maintainer local spike
bundle exec jekyll serve          # http://127.0.0.1:4000/admin/ → Local Repository
JEKYLL_ENV=production bundle exec jekyll build

# Author path
# https://simonacella.github.io/admin/ → Sign in with GitHub PAT
```
