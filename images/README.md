# /images

Mirrors the `/images/` folder inside Baker's Slate instance, so the same paths
resolve in staging and in production.

| File                            | Status     | Used by                      | Source                                                        |
| ------------------------------- | ---------- | ---------------------------- | ------------------------------------------------------------- |
| `logo-baker-onecolor-black.svg` | ✓ in place | header + footer (orange)     | Baker brand guidelines PDF — see below                        |
| `logo-baker.svg`                | retired    | nothing (navy-era header)    | `https://www.bakeru.edu/themes/custom/baker_theme/logo.svg`    |

## Why the one-colour black lockup

The approved chrome is Cadmium Orange `#F4771D` in both the header and the
footer. Neither of Baker's full-colour lockups survives on that background:

- `logo-baker.svg` (white wordmark, orange leaves) — white on the orange is
  2.8:1, and the leaves disappear into the bar.
- The navy lockup (navy wordmark, orange leaves) — the text holds at 4.78:1,
  but the leaves are `#F48024` on `#F4771D`, about 1.06:1, so the mark is lost.
  It also brings navy back, which the 2026-10-02 feedback removed.

`logo-baker-onecolor-black.svg` is Baker's own one-colour lockup, extracted as
vector paths from `BakerUniversity-BrandGuidelines-2026-1Pager.pdf` (Primary
Logos & Lockups). Paths and fill (`#231F20`, Pantone Black C) are unaltered;
only the viewBox was trimmed to the artwork. Black on the orange is 5.8:1, and
it matches the "black wherever navy was" direction.

## Getting it in place

1. The SVG is already in this folder as `logo-baker-onecolor-black.svg`.
2. Upload the same file into Slate at Database -> Configurations -> Files,
   under `/images/`, so it resolves at `/images/logo-baker-onecolor-black.svg`.

## Replacing it later

**Always use a new filename.** Slate strips `?v=...` query strings from `src`
attributes at render time, so the cache-busting trick that works for the CSS
`<link>` tags does not work for images. Uploading over an existing file leaves
Slate's CDN serving the old copy for hours or days.

Upload as e.g. `logo-baker-2027.svg`, update the `src` in `shared/build.xslt`
and `index.html`, then save and publish.
