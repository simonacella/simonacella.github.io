# Dependency updates (Renovate)

Renovate runs from [`.github/workflows/renovate.yml`](../.github/workflows/renovate.yml)
via the CLI — **no GitHub App**. Config: [`renovate.json`](../renovate.json).
Nothing automerges; review and merge when the Pages build is green.

## One-time setup

1. Create a **fine-grained PAT**
   ([tokens](https://github.com/settings/personal-access-tokens)):
   - Repository access: **this repo only**
   - Permissions: Contents, Pull requests, Issues, Workflows — all **Read and write**
2. Add repo secret **`RENOVATE_TOKEN`** = that PAT  
   (`GITHUB_TOKEN` is not enough — Renovate PRs would not trigger CI.)
3. Merge the workflow to `main`, then wait for the daily run or use
   **Actions → Renovate → Run workflow**.

Optional: use a bot account so update PRs are not under your personal name.

**Classic PAT fallback** (only if fine-grained fails): `repo` + `workflow` scopes.

## How schedules work

| Layer | Role |
|-------|------|
| Actions cron (`0 4 * * *`) | Starts Renovate daily at 04:00 UTC |
| `lockFileMaintenance.schedule` | `"at any time"` — lockfile-only PRs when the workflow runs |

Manual `workflow_dispatch` runs Renovate immediately.

## Policy

| Kind | Behaviour |
|------|-----------|
| Patch / minor | Grouped where configured |
| Major | Separate PR; manual review |
| Security | `vulnerabilityAlerts` — can open outside the usual cadence |
| Lockfile maintenance | Refreshes `Gemfile.lock` within existing ranges |
| Release age | **1 day** (`minimumReleaseAge`) |
| Ranges | `rangeStrategy: bump` — updates `Gemfile` constraints and the lockfile |

### Groups

| Group | Packages |
|-------|----------|
| jekyll stack | `jekyll`, `jekyll-*` plugins |
| github actions | Workflow action refs |

Everything else in `Gemfile` / `Gemfile.lock` is still updated — Renovate discovers it automatically; ungrouped gems get their own PRs (or land via lockfile maintenance).

## CI gate

Renovate PRs should pass the existing **Deploy Jekyll site to Pages** workflow
(build + image optimize). Merge only when that is green.

## Watch carefully

| Package(s) | Why |
|------------|-----|
| `jekyll` | Major bumps can change Liquid, permalinks, plugin APIs |
| `jekyll-paginate` / `jekyll-feed` / `jekyll-sitemap` | Interact with site layout and SEO |
| `jekyll-polyglot` (when present) | i18n routing and build behaviour |
| Pages / `actions/*` | Deploy pipeline |

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Workflow fails immediately | Check `RENOVATE_TOKEN` exists and is not expired |
| No Actions updates in PRs | Fine-grained token missing **Workflows** write |
| PRs open but CI does not run | Must use a PAT, not `GITHUB_TOKEN` |
| Fine-grained auth errors | Confirm repo access; fall back to classic `repo` + `workflow` if needed |
