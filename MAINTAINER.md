# Maintainer notes — Sveltia

Up-to-date picture of the **Sveltia CMS** effort (for you). Agents: rewrite this when the story changes; do not add a second maintainer doc. Code invariants: `.cursor/rules/sveltia-cms.mdc`. Pending tasks: `.cursor/plans/`.

## What we’re doing

Replace GitHub’s awkward web UI with **`/admin`** (Sveltia) so Simona can write Italian posts (and later EN/FR) as forms that commit Markdown to this repo. The public site stays Jekyll on GitHub Pages.

## Where we are

**Remote `/admin` in use.** Production `https://simonacella.github.io/admin/` with **Sign in with GitHub** (OAuth). Auth proxy: `https://auth.rednaw.nl` (`backend.base_url`; `auth_methods: [oauth]`). Saves commit to `main`. **`skip_ci: false`** — every Save triggers Pages (build + deploy). Local Repository still works for maintainer spikes (`jekyll serve` → Local Repository) in **Brave** (or another desktop Chromium). Cursor/VS Code Simple Browser fails after the folder picker (`A repository root directory could not be selected`) — File System Access is incomplete there. Sveltia pinned at **0.206.0** (Renovate watches the unpkg pins in `admin/`; review those PRs, don’t automerge).

**Config** in `admin/` — pinned Sveltia, Italian-first locales, cover + body both `/assets/img/posts`, **`slugify_filename`** on uploads, **Pagine → Chi sono** (`_data/about.yml`), Insert → YouTube for `{% youtube %}`, auto `lang`, sane dates, empty optionals omitted, optional **`republication`** checkbox, optional **`translation_public`** (EN/FR publish). Nested `republication` front matter for prior publishers. Cover `img: /assets/img/posts/…`. Preview pane on for posts/about. Scroll-to-top workaround in `admin/index.html`.

**Auth:** OAuth via Hetzner proxy (secret stays on the VPS, not in this repo). PAT path disabled. Implementor brief kept in `_review/` for the server project.

**Soft launch:** language buttons on chrome. Posts show the switcher only when a translation is public (`translation_public`). EN/FR listings show every article; unpublished langs open Italian.

**Author docs:** `README.md` = CMS visual story with shots in `assets/img/admin-guide/`. YAML hand-edit: `GUIDA-FILE.md`. Field hints: `admin/config.yml`.

## Next

1. Optional: reshoot Authorize / Publish click / YouTube insert (see `.cursor/plans/sveltia-cms.md`).

## Try it

```bash
# Maintainer local spike
bundle exec jekyll serve          # Brave: http://127.0.0.1:4000/admin/ → Local Repository
JEKYLL_ENV=production bundle exec jekyll build

# Author path
# https://simonacella.github.io/admin/ → Sign in with GitHub
```
