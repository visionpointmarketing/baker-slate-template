# Baker University — Slate Branding Template

Branding files for Baker University's Slate instance (`apply.bakeru.edu`), plus
a staging page the client reviews before anything is published.

The visual design mirrors [bakeru.edu](https://www.bakeru.edu/) so that Slate
forms, portal pages, the application checklist and decision letters read as
part of the university's site rather than as a separate system.

Built for VisionPoint Marketing. ClickUp: VPM-46834.

---

## Quick start

No build step.

```bash
cd baker-slate-template
python3 -m http.server 8000
# then visit http://localhost:8000
```

Opening `index.html` directly off the filesystem also works; a server is only
needed if you want paths to behave exactly as they do in Slate.

---

## Folder structure

```
baker-slate-template/
├── index.html          ← staging page for client review
├── README.md
├── shared/             ← mirrors Slate's /shared/ — these three files ship
│   ├── build.xslt          page template wrapping every Slate page
│   ├── build.css           all styling, including Slate UI overrides
│   ├── build-fonts.css     FontAwesome @font-face (Google Fonts load via <link>)
│   └── README.md           deploy instructions
├── images/             ← mirrors Slate's /images/
│   ├── logo-baker.svg      the one branding asset
│   └── README.md
└── reference/          ← Baker's CURRENT Slate files, for diffing. Never ships.
    └── README.md
```

The folder names are not decoration. `shared/` and `images/` are the paths
those files live at inside Slate, which is what lets the same CSS work in both
places — see below.

---

## One stylesheet, two environments

`index.html` loads `shared/build.css` — the exact file that gets pasted into
Slate's Branding Editor. Not a staging copy of it, not a modular source that
gets flattened into it. The same bytes.

This is possible because the stylesheet contains no `url()` references: Baker's
footer is flat navy, so the only asset is the logo, and that is an `<img>` in
the markup rather than a CSS background.

The one difference between environments is that logo's path:

| | Path |
| --- | --- |
| `index.html` (staging) | `images/logo-baker.svg` — relative, so the page works from any base URL |
| `shared/build.xslt` (Slate) | `/images/logo-baker.svg` — absolute, because Slate renders pages at many different URLs |

Everything else is shared. There is no "remember to update both" step.

The header and footer markup does exist twice — once in `index.html`, once in
`build.xslt` — because XSLT and HTML can't share a partial without adding a
build step. `index.html` is generated from `build.xslt`'s markup, so if the
chrome changes, change `build.xslt` first and re-derive. Two files is a
tolerable amount of duplication; if this template grows past that, a static
site generator is the next step, not a bigger find-and-replace.

---

## Design decisions worth knowing

### Colors follow the website, not the brand PDF

Baker's brand guidelines list Cadmium Orange `#F4771D` and navy `#001E42` as
the primary palette. The live site renders navy `#212B56`, a darker utility bar
`#171F3D`, and a lighter orange `#F6924A` on its buttons.

The template uses the **website** values, because the portal's job is to feel
continuous with bakeru.edu. Both sets are recorded in the tokens block at the
top of `build.css` so nobody "corrects" this later without knowing it was a
decision.

### Orange is never text

`#F4771D` on white is about 2.8:1 contrast — it fails WCAG AA at every text
size. Orange appears only as a fill with dark navy text on top, which is how
the live site uses it. Links inside Slate content are navy and underlined.

### The header is the logo and nothing else

The site's mega-menu was deliberately not ported. It depends on the site's own
JavaScript, its markup alone is roughly 166KB, and every link in it leads away
from the form the applicant is in the middle of completing. The Slate header is
the navy bar with the Baker logo, linking home.

### The content wrapper resizes itself

Forms, events and decision letters read best at a narrow measure (780px).
Checklist and portal pages render a floated `#side` / `#main` pair that gets
cramped at that width, so `build.css` widens the wrapper to 1120px when it
detects a sidebar, subtabs or a fixed table, using `:has()`. Browsers without
`:has()` keep the narrower measure — tighter than ideal, never broken.

### The reset is deliberately incomplete

A full modern CSS reset breaks Slate's own form rendering, checklist and menus.
`build.css` section 2 is the safe subset: box-sizing, media defaults, motion
preferences and a screen-reader utility. Resist the urge to "finish" it.

---

## Slate gotchas this template accounts for

| Gotcha | How it's handled |
| --- | --- |
| Slate caches CSS at the CDN | `?v=yyyyMMddHHmm` on the `<link>` tags in `build.xslt`; bump on every deploy |
| Slate strips `?v=` from image `src` | Replace images under a **new filename**, never by overwriting — see `images/README.md` |
| `build.xslt` must be valid XML | XSLT 1.0, all tags closed, `&` written as `&amp;`. Validate before pasting |
| Slate's inline `<style>` sets `#content { padding: 15px }` | Kept verbatim; our spacing layers on top rather than fighting it |
| Form inputs overflow on mobile | Widths forced to 100% under 600px |
| `#side` / `#main` are floated at fixed percentages | Stacked below 768px |
| Decision-letter confetti renders under content | `body > canvas { z-index: 500 }` |
| Applicants print checklists and decision letters | Print styles drop the chrome, keep the content |

---

## Status and next steps

- [x] Staging page, `build.css`, `build-fonts.css`, `build.xslt`
- [ ] Add `images/logo-baker.svg` (see `images/README.md`)
- [ ] Drop Baker's current Slate files into `reference/` and reconcile — the
      Slate UI overrides in `build.css` section 6 came from a known-good
      implementation, not from Baker's own instance
- [ ] Publish staging for client review
- [ ] Deploy to Slate (`shared/README.md`)

---

## Credits

- Visual design mirrored from [bakeru.edu](https://www.bakeru.edu/).
- Fonts: [Newsreader](https://fonts.google.com/specimen/Newsreader) and
  [Roboto](https://fonts.google.com/specimen/Roboto) (Google Fonts), both named
  in Baker's brand guidelines.
