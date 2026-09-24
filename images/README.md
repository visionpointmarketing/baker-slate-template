# /images

Mirrors the `/images/` folder inside Baker's Slate instance, so the same paths
resolve in staging and in production.

| File              | Status  | Used by                            | Source                                                                 |
| ----------------- | ------- | ---------------------------------- | ---------------------------------------------------------------------- |
| `logo-baker.svg`  | needed  | header + footer (`<img>` in both)  | `https://www.bakeru.edu/themes/custom/baker_theme/logo.svg`             |

One asset, used in two places. The SVG is a white wordmark with the orange
flame mark, drawn for a navy background — which is what both the header and the
footer use, so no second light-background version is required.

## Getting it in place

1. Save the SVG from the URL above into this folder as `logo-baker.svg`.
2. Upload the same file into Slate at Database -> Configurations -> Files,
   under `/images/`, so it resolves at `/images/logo-baker.svg`.

## Replacing it later

**Always use a new filename.** Slate strips `?v=...` query strings from `src`
attributes at render time, so the cache-busting trick that works for the CSS
`<link>` tags does not work for images. Uploading over an existing file leaves
Slate's CDN serving the old copy for hours or days.

Upload as e.g. `logo-baker-2027.svg`, update the `src` in `shared/build.xslt`
and `index.html`, then save and publish.
