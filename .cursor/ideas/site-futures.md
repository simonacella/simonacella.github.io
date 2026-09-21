# Site futures

**Speculation.** Options only — not committed. Promote via a plan, not by editing this into one. Portfolio-wide exit/sovereignty: `rednaw` → `.cursor/ideas/portfolio-levers.md`. Prices checked Sep 2026.

## Precompute (CI)

- Cross-lingual semantic search — multilingual embeddings in CI, int8 vectors in browser (~80KB); vendor weights (not Hugging Face at build).
- Client-side RAG — quantized model + corpus in browser; weights as Release asset or VPS, not git.
- Print — Pandoc + LaTeX PDFs / yearly anthology.
- Audio — Piper TTS (IT) + podcast RSS in CI.
- Chromatic index — ImageMagick palettes per still.
- Fact lint — film titles/years vs vendored DB in `_plugins/content_lint.rb`.
- Social cards per post/language (existing ImageMagick).
- Suggested tags / related posts — bot PR on front matter + `_data/tag-labels.yml`.
- Offline PWA of the archive.

## Scheduled data

Pattern: sibling `anticobagliosiciliano` Lodgify workflow (cron → secret → commit only on change → keep schedule alive). Sovereign alt: Prefect on VPS.

- Watchability index — nightly “where to watch in Italy” (most useful-vs-archival).
- Festival radar — African / third-cinema calendars → PR.
- Translation drafting — machine EN/FR branch; `translation_public` stays the gate. Mistral (FR) for sovereign API.
- Link rot — check, archive, rewrite by PR.

## Git as content

- Revision slider from commit history (build-time).
- Provenance footer (`git log`: revised N times, last CMS edit).

## Citable archive

- CC JSON-LD corpus + Zenodo DOI per release (CERN/EU, free). Ask Zenodo first — fair-use excludes “reviews” as main purpose; structured research corpus OK, verbatim blog republish maybe not.
- BibTeX / COinS per essay.
- Per-film canonical pages with stable IDs.

## Drafts, private media, gated audience

Author friction → `.cursor/plans/sveltia-author-friction.md`. Today: CMS → `main` (see `sveltia-cms.mdc`).

- Private drafts — second private repo; bot promotes into public. Free on GitHub; sovereign = Forgejo on VPS. Sveltia supports Forgejo 12.0+ (`base_url`/`api_root`); no Editorial Workflow, REST slower — fine since we already commit to `main`.
- Private media masters — VPS or Hetzner Storage Box (€3.20/mo); build publishes only low-res crops (rights boundary).
- Gated audience — not on `simonacella.github.io`; Authelia + Traefik on VPS under a controlled domain (~25–50 MB RAM).

## Walls

- No secrets in repo; scheduled-job keys in CI secrets.
- Public repo = public from first commit; only a private-content split changes that.
- Pages soft limits: 1 GB repo / site, 100 GB/mo bandwidth, 10-min deploy; custom Actions workflow → no 10-builds/hr cap. Free Actions minutes only while public.
- GitHub exit is portfolio direction; this site is last (needs domain + owner). Exit loses free Actions → `_plugins` / image pipeline need a new runner.
- VPS cost is maintenance time; today this site uses it only for CMS OAuth.
