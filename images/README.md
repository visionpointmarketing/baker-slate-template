# /images

Mirrors the `/images/` folder inside Baker's Slate instance, so the same paths
resolve in staging and in production.

| File                   | Status     | Used by                          | Source                                                        |
| ---------------------- | ---------- | -------------------------------- | ------------------------------------------------------------- |
| `logo-baker.svg`       | ✓ in place | navy theme, header + footer      | `https://www.bakeru.edu/themes/custom/baker_theme/logo.svg`    |
| `logo-baker-navy.svg`  | ✓ stand-in | orange theme, header + footer    | derived from the above by fill swap — see below                |

## The navy lockup is a stand-in

`logo-baker.svg` is a white wordmark with an orange flame, drawn for a navy
background. On the orange theme neither colour holds up: white on Baker Orange
is 2.8:1, and the orange flame disappears into the bar.

`logo-baker-navy.svg` is the same artwork with `white` and `#F58025` swapped to
the logo's own navy `#002D62`. No paths were altered. Baker's brand guidelines
list navy, reversed and one-colour lockups as approved secondary options, so a
proper version of this exists in their brand files — **request it and replace
this before anything ships**, rather than shipping artwork we recoloured.

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
