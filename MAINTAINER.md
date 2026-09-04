# Maintainer notes — Sveltia

Up-to-date picture of the **Sveltia CMS** effort (for you). Agents: rewrite this when the story changes; do not add a second maintainer doc. Code invariants: `.cursor/rules/sveltia-cms.mdc`. Pending tasks: `.cursor/plans/`.

## What we’re doing

Replace GitHub’s awkward web UI with **`/admin`** (Sveltia) so Simona can write Italian posts (and later EN/FR) as forms that commit Markdown to this repo. The public site stays Jekyll on GitHub Pages.

## Where we are

**Local only for now.** Run `jekyll serve`, open `http://127.0.0.1:4000/admin/`, choose **Work with Local Repository**. Saves write the working tree; you commit in git yourself. Brave may need the File System Access flag. No PAT / remote `/admin` handoff yet. Sveltia pinned at **0.205.3**.

**Prototype config** in `admin/` — pinned Sveltia, GitHub backend still declared for later remote use, Italian-first locales, cover + body both `/assets/img/posts` (so CMS shows cover thumbnails), auto `lang`, sane dates, `skip_ci`, empty optionals omitted, optional **`republication`** checkbox. Posts with a prior publisher use nested `republication` front matter. Cover front matter is `img: /assets/img/posts/…`.

**Auth (later):** PAT on published `/admin`, then parked OAuth (Hetzner brief in `_review/`). Not blocking current UX work.

**Soft launch:** still all-or-nothing (`lang_switcher_public: false`). Selective soft launch is **later**.

**Author docs:** `README.md` stays YAML-by-hand until we’re past local UX + a real handoff path.

## Next (local UX first)

1. Editor open scroll — workaround in `admin/index.html` (reset `.content` on entry open; drop when upstream fixes). Field order keeps body before meta.
2. More local friction fixes (hints, smoke on disk + `jekyll build`) — `.cursor/plans/sveltia-author-friction.md`.
3. Later: remote PAT / OAuth, selective soft launch, README CMS-first.

## Try it

```bash
bundle exec jekyll serve          # http://127.0.0.1:4000/admin/ → Local Repository
JEKYLL_ENV=production bundle exec jekyll build
```
