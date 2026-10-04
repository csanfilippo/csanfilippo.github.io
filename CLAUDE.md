# CLAUDE.md

Personal website of Calogero Sanfilippo. Static site built with Hugo and the `hugo-coder` theme, deployed to GitHub Pages and served at **https://calogerosanfilippo.it** (`static/CNAME`).

## Commands

```bash
git submodule update --init --recursive   # theme is a submodule; required before first build
hugo server                               # local preview with drafts off; add -D for drafts
hugo build --gc --minify                  # production build into public/ (gitignored)
hugo new content posts/YYYY-MM-DD-<slug>.md
```

Hugo must be the **extended** edition: the theme compiles SCSS with `toCSS` (libsass). The non-extended binary fails with `you need the extended version to build SCSS/SASS`.

There are no tests. A clean `hugo build` with no errors or warnings is the verification step.

## Layout

| Path | Purpose |
|------|---------|
| `hugo.toml` | Site config, menu, social links, sitemap cascade for thin tags |
| `content/posts/` | Release notes and announcements |
| `content/apps/`, `content/libs/`, `content/tools/` | One page per product; `_index.md` is the section landing page |
| `content/privacy/<app>.md`, `content/terms/<app>-terms.md` | App Store legal pages, linked from each app page |
| `content/app-ads.txt` | Served at `/app-ads.txt` for ad networks |
| `layouts/` | Site-level overrides of the theme (shortcodes, JSON-LD partial, `robots.txt`) |
| `static/doc/aral/<version>/` | Dokka-generated API docs, committed as build output |
| `layouts/home.llms.txt` | Template for `/llms.txt`, the site index for LLM agents, generated from product page front matter |
| `themes/hugo-coder/` | Git submodule — never edit; override in `layouts/` instead |

## Authorship

Calogero writes every post and page. The content is his.
- Do not write, draft, or rewrite prose unless explicitly asked.
- Mechanical fixes are fine when requested: typos, broken links, Markdown, front matter.
- Suggest any change to wording, tone, or claims in a reply. Do not apply it to the file.

## Content conventions

- Front matter is TOML (`+++`). `title` and `date` are single-quoted strings; `date` carries a timezone offset (`'2026-07-26T10:00:00+02:00'`).
- Posts: filename `YYYY-MM-DD-<slug>.md`, with `draft`, `title`, `description`, `slug` (filename without the date), `authors = ["Calogero Sanfilippo"]`, and `tags`.
- Tags are lowercase and hyphenated (`kotlin-multiplatform`). Release posts include `release` plus the product name tag.
- Product pages use `summary` (not `description`) and follow the same outline: logo, intro, *Why …?*, *The approach*, *Philosophy*, *Learn more*.
- Product front matter feeds `/llms.txt`: `repository` (libs and tools), `mavenCoordinates` and `apiDocs` (aral), `discontinued = true` (apps removed from the App Store).
- Library names are lowercase in prose: aral, altai, swift-sgp4.
- `content/libs/swift-spg4.md` is misspelled but its URL is published and linked externally. Do not rename it without adding an alias.
- `markup.goldmark.renderer.unsafe = true`: raw HTML in Markdown is allowed.

## Shortcodes

- `{{< appStoreBadge "<app-name>/id<number>" >}}` — App Store badge linking to the Italian storefront.
- `{{< figure-dynamic light-src=… dark-src=… alt=… width=… >}}` — image that swaps with `prefers-color-scheme`. Used for library logos.

Images live in `static/images/` and are referenced with absolute paths (`/images/…`).

## Things that must stay in sync

When adding or removing an app, library, or tool, update all of:
1. The product page under its section.
2. The section `_index.md` `description`, which names every product.
3. `content/about/index.md` if the product is mentioned there.

`/llms.txt` follows automatically from the product pages.

When publishing a new aral docs version: add `static/doc/aral/<version>/` and update `apiDocs` in the `content/libs/aral.md` front matter; the page body and `/llms.txt` both read it. Dokka's nested `older/` folders are disallowed in `layouts/robots.txt` to avoid ~1400 duplicate pages being crawled.

When adding a new content section, extend `layouts/_partials/head/extensions.html` so its pages get the right schema.org JSON-LD type.

## SEO decisions

- Tag pages used by two posts or fewer are excluded from `sitemap.xml` via the `[[cascade]]` path list in `hugo.toml`. When a tag crosses that threshold, add or remove it from the list.
- `/privacy/` and `/terms/` are excluded from `sitemap.xml` by a second `[[cascade]]` in `hugo.toml`. They exist for App Store review, not search.
- `enableGitInfo = true` derives `lastmod` from git history, so CI checks out with `fetch-depth: 0`. Shallow clones produce wrong sitemap dates.
- Old index URLs (`/app-index/`, `/libs-index/`, `/projects/…`) are preserved as `aliases`. Keep them when moving pages.

## Deployment

- `.github/workflows/hugo.yaml` builds and deploys on every push to `main`. It overrides `baseURL` with the Pages URL, so `baseURL` in `hugo.toml` only matters locally.
- The Umami analytics site ID is injected through the `HUGO_PARAMS_UMAMI_SITEID` env var from the `UMAMI_SITE_ID` secret. Leave `params.umami.siteID` empty in `hugo.toml`.
- `.github/workflows/indexnow.yaml` submits every sitemap URL to IndexNow after a successful deploy. Its key must match the file `static/8ee81a805215d0ad184c68b6ce5c0691.txt`.
- Do not delete the search engine verification files in `static/` (`BingSiteAuth.xml`, `google*.html`, the IndexNow key) or `static/CNAME`.
