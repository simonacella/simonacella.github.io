# Maintainer notes — Sveltia

Sveltia effort status for you. Agents: rewrite when the story changes; no second maintainer doc. Invariants: `.cursor/rules/sveltia-cms.mdc`.

## What

`/admin` (Sveltia) so Simona can write posts as forms that commit Markdown. Public site stays Jekyll on GitHub Pages.

## Where we are

**Remote `/admin` live** — Simona has published. OAuth via `https://auth.rednaw.nl` (secret on VPS). Saves → `main` → Pages build. Sveltia **0.206.0** (Renovate PRs on `admin/` pins — review, don’t automerge).

Local spikes: `jekyll serve` → Local Repository in **Brave** (Cursor Simple Browser can’t pick a folder). Author docs: `README.md`; file hand-edit: `GUIDA-FILE.md`.

## Next

None.

## Try it

```bash
bundle exec jekyll serve   # Brave → http://127.0.0.1:4000/admin/ → Local Repository
# Authors: https://simonacella.github.io/admin/ → Sign in with GitHub
```
