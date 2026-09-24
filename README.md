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
├── index.html          ← staging: a form page          (GENERATED)
├── portal.html         ← staging: a checklist/portal page (GENERATED)
├── README.md
├── shared/             ← mirrors Slate's /shared/ — these three files ship
│   ├── build.xslt          page template wrapping every Slate page
│   ├── build.css           all styling, including Slate UI overrides
│   ├── build-fonts.css     FontAwesome @font-face (Google Fonts load via <link>)
│   └── README.md           deploy instructions
├── images/             ← mirrors Slate's /images/
│   ├── logo-baker.svg      the one branding asset
│   └── README.md
├── tools/
│   ├── make-staging.py     regenerates the staging pages from build.xslt
│   └── demo/               the demo content each staging page wraps
└── reference/          ← Baker's CURRENT Slate files, for diffing. Never ships.
    └── README.md
```

Two staging pages, because Slate lays out two kinds of page differently: a form
at a reading measure, and a checklist/portal with a sidebar at a wider one. One
page showing both at once would misrepresent each.

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

The header and footer markup is not duplicated either. `build.xslt` is the only
place it's written; the staging pages are generated from it:

```bash
python3 tools/make-staging.py
```

That script lifts the chrome out of `build.xslt`, swaps the Slate-absolute image
path for a relative one, and wraps each fragment in `tools/demo/`. **Never edit
`index.html` or `portal.html` directly** — change `build.xslt` or a demo
fragment and re-run. Adding a staging page means adding a fragment and one line
to `PAGES` in the script.

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

### The content column shares the chrome's left gutter

On bakeru.edu the logo and the body copy start on the same left edge. The Slate
content column does the same: the wrapper is the same container as the header
and footer, and the reading measure is applied to `#content` inside it rather
than by centering a narrower box, which would leave content floating off the
grid the chrome establishes.

Slate's own inline `<style>` sets `#content { padding: 15px }`, which would push
content 15px off that gutter and make staging differ from production.
`build.css` overrides it with a more specific selector so every gutter comes
from the wrapper.

### The content measure resizes itself

Forms, events and decision letters read best at a narrow measure (780px).
Checklist and portal pages render a floated `#side` / `#main` pair that gets
cramped at that width, so `build.css` widens `#content` to 1120px when it
detects a sidebar, subtabs or a fixed table, using `:has()`. Browsers without
`:has()` keep the narrower measure — tighter than ideal, never broken.

### Slate's `:link` rules out-specify component rules

`#content a:link` is more specific than `div#menu ul li a`, so any component
that needs its own link treatment (subtabs, the portal sidebar) restates its
selector with `:link` and `:visited`. If a link somewhere comes out underlined
and navy when it shouldn't, this is why.

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

## Browser QA

Reviewed by Breon Williams on 2026-09-24, in Chrome against a local server and
in headless Chromium at phone and tablet widths. Checked and fixed:

- Logo, content and footer all share one left gutter at every width
- Fieldset default inline margin knocking the form off that gutter
- Header brand link falling back to default link blue if the logo fails to load
- Body type set to the site's 18px/30px rhythm; lede at 20px
- Slate form questions: labels above controls, inputs at a consistent width
- Portal sidebar styled as a nav rather than a bulleted list
- `#side` / `#main` stack below 900px, where the 22% sidebar wraps labels
- Keyboard focus ring visible on both white and navy, with a `:focus` fallback
- Footer list links and radio/checkbox targets meet the 24px minimum
- No horizontal overflow at 375, 390, 820, 1024, 1440
- Contrast: every text pair 12.6:1 or better

## Status and next steps

- [x] Staging pages, `build.css`, `build-fonts.css`, `build.xslt`
- [x] `images/logo-baker.svg` in place
- [x] Browser QA pass
- [ ] Drop Baker's current Slate files into `reference/` and reconcile — the
      Slate UI overrides in `build.css` section 6 came from a known-good
      implementation, not from Baker's own instance
- [ ] Publish staging for client review
- [ ] Upload the logo into Slate at `/images/logo-baker.svg`
- [ ] Deploy to Slate (`shared/README.md`)

---

## Credits

- Visual design mirrored from [bakeru.edu](https://www.bakeru.edu/).
- Fonts: [Newsreader](https://fonts.google.com/specimen/Newsreader) and
  [Roboto](https://fonts.google.com/specimen/Roboto) (Google Fonts), both named
  in Baker's brand guidelines.
