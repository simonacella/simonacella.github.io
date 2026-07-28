# Site review — 27 July 2026

Reviewed at commit `984228b` ("simplified search") on `main`, clean working tree.

This directory starts with `_`, so Jekyll never copies it into `_site` and this file
cannot leak onto the published site. No configuration change is needed to keep it private.

## How this was checked

- Clean production build (`JEKYLL_ENV=production bundle exec jekyll build`) into a scratch
  directory: 104 output files, no warnings or errors.
- Internal link check over every generated `.html`: all root-absolute `href`/`src` targets
  resolve. Zero broken internal links.
- Dry run of `scripts/optimize-site-images.py`'s rewrite logic against the build: 32 images
  would be converted, 32 distinct references would be rewritten, no dangling references and
  no orphaned conversions.
- All 54 external links in `_posts/` and `_config.yml` requested with redirects followed.
- Structural scan of the built HTML for duplicate ids, heading order, alt text, intrinsic
  dimensions and lazy-loading attributes.
- Live production spot checks against https://simonacella.github.io.
- Browser testing of every interactive behaviour against the built site (tag filtering,
  search, menu focus trap, back-to-top, YouTube facade, copy-link, language switcher,
  390×844 mobile viewport).

## Overall assessment

The site is in good shape. The build is clean, there are no broken internal links, the
image pipeline is self-consistent, and every interactive behaviour works in a real browser.
Accessibility fundamentals are genuinely implemented rather than gestured at: skip link,
focus trap, `inert` on the closed navigation, `prefers-reduced-motion` handling, self-hosted
subset fonts, and a click-to-load YouTube facade that sets no cookies until the reader asks
for the video. The commentary in `_includes/locale.html` and `_data/*.yml` documents the
non-obvious jekyll-polyglot traps (the `page_id` / `content_id` collision, why `hreflang` is
withheld during the soft launch) well enough that they are unlikely to be re-broken.

Everything below is polish. Item 1 under "Fix first" is the remaining issue with
user-visible consequences today; items 2 and 3 in that section are done.

## Fix first

### 1. Production `og:image` is a WebP URL, which may break social previews

The deploy script rewrites every `assets/img/…jpg|png` reference in HTML, and that includes
the Open Graph and JSON-LD image URLs. Confirmed live:

    $ curl -s https://simonacella.github.io/Dao.html | grep og:image
    <meta property="og:image" content="https://simonacella.github.io/assets/img/posts/Dao.webp">

X and Facebook handle WebP; LinkedIn's crawler documents only JPG, PNG and GIF. The article
sidebar has a prominent LinkedIn share button, so that is the preview most at risk of losing
its image.

- Source of the URL: `_includes/SEO.html` lines 7, 9 (`seo_image`), consumed at lines 37, 62
  and 79.
- Cause: `scripts/optimize-site-images.py` line 25 (`REWRITE_SUFFIXES` includes `.html`) and
  the pattern at line 28, which matches inside `content="…"` attributes.
- Options: exclude `og:image` / `"image"` lines from `rewrite_references`, or have the script
  keep a JPEG alongside the WebP and leave the social URL pointing at it.

While in `SEO.html`: `og:image:width` and `og:image:height` are missing, which makes some
crawlers skip the image or render it small.

### 2. "Articoli recenti" recommends the article you are currently reading — fixed

`_includes/recent-post.html` now builds the strip from
`site.posts | where_exp: "p", "p.url != page.url"` with `limit: 4`, so the current article
is excluded. On `/Dao.html` the four cards are other posts; on the 404 page the four newest
(including Dao) still appear.

### 3. Body images in articles load eagerly — fixed

`_plugins/image_intrinsic_size.rb` now adds `loading="lazy" decoding="async"` on article
pages (`layout: post`) for local images that are not the cover (`.cover-image`) and do not
already set `loading`. Cover, homepage LCP cards, About portrait, and 404 hero stay eager.

## Markup, headings and SEO

### 4. Missing and duplicated headings

Heading structure per built page:

| Page | Headings emitted | Problem |
|---|---|---|
| `archive.html` | none | No `<h1>`, no headings at all |
| `tags.html` | one `<h2>` | `<h2>` with no `<h1>` above it |
| `tag.html` | eighteen `<h1>` | One per tag block; seventeen are inside `display:none` |
| `index.html`, `404.html` | `<h1 class="sr-only">` | Fine |
| post pages | `h1`, then `h2`s | Fine |

`_layouts/home-page.html` line 8 adds the screen-reader `<h1>`; `_layouts/menu-page.html`
does not, which is why `archive.html` and `tags.html` are bare. `_pages/tags.html` line 11
uses `<h2>` where an `<h1>` belongs.

Relatedly, post titles are not headings anywhere in a listing: `index.html` lines 13–15 wrap
them in `<p class="post-card-title-and-meta">` / `<a class="post-card-link">`, and the archive
uses `<a class="post-list-title">`. Those pages therefore have no document outline for screen
readers or search engines.

### 5. Tag anchors use two incompatible id schemes — fixed

`tag.html` and `tags.html` both use `{{ this_word | slugify }}` for element ids, and
`tag_cloud.html` passes the same slug in `?tag=`. Valid HTML ids, one spelling everywhere
(e.g. `alain-gomis`).

### 6. `/tag.html` with no query string is a blank page

All eighteen blocks stay hidden and the reader sees only the tag cloud, with no explanatory
text. Confirmed in a browser. Worth a short "choose a tag" message, or a redirect to
`/tags.html`.

### 7. Localized sitemaps and feeds duplicate the Italian ones

`_config.yml` lines 48–53 list `sitemap.xml` under `exclude_from_localization`, but that
exclusion does not apply to plugin-generated files. Live in production right now:

    /sitemap.xml       200
    /en/sitemap.xml    200   <- lists the Italian URLs, byte-identical content
    /fr/sitemap.xml    200   <- same
    /en/feed.xml       200   <- carries the root feed's <id>, entries tagged xml:lang="it"

`robots.txt` only advertises the root sitemap, so the impact is limited to crawlers that
discover the others directly. Fixing it needs jekyll-sitemap / jekyll-feed configuration or
a post-build cleanup step in the workflow rather than the polyglot exclusion list.

### 8. `/page2/` is in the sitemap but marked `noindex`

`_includes/head.html` line 9 sets `noindex, follow` when `paginator.page > 1`, yet
`/page2/` appears in `sitemap.xml`. Pick one: either drop it from the sitemap or let it be
indexed.

## Content

### 9. Dead external link

`_posts/2025-08-20-Soundtrack-to-a-coup-d-etat.md` line 122:

    [_My Country Africa_](https://www.andréeblouin.com) di  Andrée Blouin

The domain does not resolve in either its Unicode or Punycode (`xn--andreblouin-o1a.com`)
form. All 53 other external links across the posts and config return 200.

### 10. Copy-editing

- `_posts/2026-07-23-The-Bride.md` line 14: `![The-Bride.jpg](…)` uses a filename as alt text.
- `_posts/2026-07-23-The-Bride.md` line 37: `genocidio del 1994.Come` — missing space.
- `_posts/2026-07-23-The-Bride.md` line 43: "Eve decide di lasciare" — the character is Eva
  everywhere else.
- `_posts/2024-08-18-Hyènes-un-western-tropicale.md` line 14: `al cinema.Se` — missing space.
- Four lines end in two or more spaces, which Markdown turns into a forced `<br>` mid-sentence
  (exactly what the README warns against): `2025-07-31-La-storia-di-Souleymane.md` lines 19
  and 34, `2025-08-01-Intervista-a-Boris-Lojkine.md` line 14,
  `2025-08-20-Soundtrack-to-a-coup-d-etat.md` line 49.

## Search

### 11. No accent folding — fixed

`assets/js/search.js` now folds accents on both the query and each indexed field
(`normalize('NFD')` + strip combining marks) before `indexOf`, so `hyenes` matches
the title "Hyènes, un western tropicale".

### 12. Paragraph boundaries are glued together in the index — fixed

`strip_html` removes tags with nothing between them, so `</p><p>` fused words across
paragraph breaks. `search.json` now uses a `searchable_text` filter
(`_plugins/search_text.rb`) that replaces every HTML tag with a space before collapsing
whitespace — covers all elements, not a hand-picked tag list.

### 13. A failed index fetch is permanent — fixed

`assets/js/search.js` resets `requested` in the `catch` path, so a later keystroke or
focus can retry after a transient network failure instead of staying broken until reload.

## JavaScript

### 14. The "don't close on link click" guard never fires — fixed

Menu backdrop clicks use `e.target.closest('a')`, so clicks on the label/`svg` inside a
nav link no longer count as "outside" and dismiss the menu before navigation.

### 15. Focus is lost when the YouTube facade is replaced — fixed

After swapping the play button for the iframe, `assets/js/main.js` calls `iframe.focus()`
so keyboard users stay on the video instead of dropping to `<body>`.

## Plugins and documentation

### 16. `{% youtube %}` fails silently and is undocumented — fixed

`_plugins/youtube.rb` logs a build warning when the URL cannot be parsed. The README
formatting table documents `{% youtube "https://youtu.be/…" %}` for the author.

### 17. Caption convention — documented and in use

Figure captions via `img` + `<small>` are documented in the README formatting section
and used on the Soundtrack article (Hotel Theresa photo). Full-bleed via `#full` was
tried mid-article, looked wrong with the white content card, and was removed.

## Dead and duplicated CSS — fixed

Removed unused selectors (`svg.menu-icon-house`, `.post-card-tags`, `.header-page .page-date`,
the `.page-footer` / `.page-tag` / `.page-share` block, unreachable `.post h1…h6` / `.post img`)
and the duplicate declarations on `.page-footer` (`padding-bottom`) and `.contact-icons li`
(`margin-left`). About 60 lines dropped from `assets/css/main.css`; no template references
those rules.

## Housekeeping

- The `I18N` branch is fully merged into `main` and still exists locally and on the remote.
- `assets/css/main.css` is mode 755; it is not executable content.
- `Gemfile.lock` lists only `x86_64-darwin` and `x86_64-linux`. Fine for the current machine
  and for CI, but a move to an Apple Silicon Mac will need `bundle lock --add-platform
  arm64-darwin`.
- `jekyll-paginate` 1.1.0 last released in 2014 (~12 years). `jekyll-paginate-v2`
  last released in February 2020 — also long dormant, so it is not a “maintained
  upgrade path.” The site only needs previous/next links; staying on
  `jekyll-paginate` is fine. Reach for something else only if pagination features
  actually change, and treat any candidate as unmaintained until proven otherwise.

## Verified working

Recorded so future changes can be checked against a known-good baseline. All confirmed in a
real browser against the production build.

- Tag filtering for single- and multi-word tags via slugified `?tag=` / element ids
  (e.g. `alain-gomis`).
- Search: overlay opens with focus on the input, `/search.json` loads lazily on first use,
  results render and navigate, Escape closes and returns focus to the magnifier, and an
  unmatched query shows the localized "Nessun risultato" status.
- Hamburger menu: opens, moves focus inside, traps Tab within the navigation, closes on
  Escape and restores focus to the trigger.
- Back-to-top button appears past one viewport and scrolls to the top.
- YouTube facade inserts no iframe until clicked, then loads from `youtube-nocookie.com`.
- Copy-link falls back to `prompt()` when the Clipboard API is unavailable, without throwing.
- Language switcher is hidden on Italian pages and present under `/en/` and `/fr/`;
  navigation links stay within the active language prefix.
- No horizontal overflow at 390×844 on either the homepage or an article page.
- No console errors and no failed network requests on any page tested.
