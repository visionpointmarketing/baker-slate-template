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

## Review URLs

Published with GitHub Pages from `main`:

- Form page: <https://visionpointmarketing.github.io/baker-slate-template/>
- Portal page: <https://visionpointmarketing.github.io/baker-slate-template/portal.html>

Pushing to `main` republishes within a minute or so. A small review bar at the
top of each staging page links between the two; it is injected by
`tools/make-staging.py` with its own inline styles and never reaches Slate.

Every asset path in the staging pages is relative, which is what lets them work
under the `/baker-slate-template/` sub-path a project Pages site serves from.
Do not switch them to root-relative paths — that works locally and breaks on
Pages. `.nojekyll` is committed so Pages serves the files as they are.

## Design decisions worth knowing

### The approved palette, and where accessibility shaped it

Baker signed off on 2026-10-02: orange header and footer, orange buttons, black
replacing navy throughout, buttons rounded rather than square, hover going to a
black fill with an orange label.

Three choices inside that were settled by contrast rather than preference, and
each is worth being able to explain:

| Element | Decision | Why |
| --- | --- | --- |
| Text on the orange bands | black | 7.5:1, up from navy's 6.47:1 — dropping navy improved it |
| Primary CTA label | **white** on `#BC421B` | black on `#BC421B` is 3.93:1 and fails AA; white is 5.34:1 |
| Links in content | `#BC421B`, underlined | Cadmium Orange is 2.8:1 on white and can never be text; Autumn Maple is 5.34:1 |

Two more that were not in the feedback but were fixed in the same pass, both
WCAG 1.4.11 (non-text contrast, 3:1):

- **Focus ring is black, not orange.** An orange ring on the white content area
  is 2.8:1 and fails. Black is 21:1 on white and 7.5:1 on the orange bands, so
  one colour covers the whole page.
- **Input borders are `#595959`, not a hairline tint.** The previous
  `rgba(33,43,86,.17)` border was decorative and failed; this is 7:1.

Measured across both staging pages: nothing below 5.34:1, most at 7.5:1 or 21:1.

### One stylesheet, one treatment

The approved treatment is the default in `build.css`, so `build.xslt` needs no
theme class on `<body>` and there is no switch to get wrong.

The navy and mixed treatments that were built for the comparison round are gone
from the working tree. They are in git history at commit `37a2f18` if anyone
ever wants them back:

```bash
git show 37a2f18:index-orange-header.html
```

The header and footer still carry separate text-colour tokens, which is what
made those mixed pairs possible and costs nothing to keep.

**Contrast is why the orange bands use dark navy text, not white:**

| | on Baker Orange `#F4771D` |
| --- | --- |
| white | 2.8:1 — fails AA at any size |
| dark navy `#111527` | 6.47:1 — passes |

So the orange bands carry dark navy text, matching how bakeru.edu treats its own
orange buttons. Links inside Slate content stay navy in every treatment; orange
on white is 2.8:1 and can never be text.

Worth knowing when the options are discussed: **bakeru.edu never runs orange as
a full-width band.** It uses orange for buttons, the flame in the mark, and
accents, against navy structure. The all-orange treatment is the furthest of the
four from how the site handles its own palette. The logo is Baker's one-colour black
lockup from their brand guidelines — see `images/README.md`.

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
- [x] `images/logo-baker-onecolor-black.svg` in place (from Baker's brand guidelines PDF)
- [x] Browser QA pass
- [ ] Drop Baker's current Slate files into `reference/` and reconcile — the
      Slate UI overrides in `build.css` section 6 came from a known-good
      implementation, not from Baker's own instance
- [x] Publish staging for client review
- [x] Orange alternate treatments for client review (all orange, plus the two
      mixed pairs)
- [x] Client feedback of 2026-10-02 applied: orange chrome, orange buttons,
      black replacing navy, rounded controls
- [x] One-colour black lockup extracted from Baker's brand guidelines PDF and
      applied to header and footer
- [ ] Upload the logo into Slate at `/images/logo-baker-onecolor-black.svg`
- [ ] Deploy to Slate (`shared/README.md`)

---

## Credits

- Visual design mirrored from [bakeru.edu](https://www.bakeru.edu/).
- Fonts: [Newsreader](https://fonts.google.com/specimen/Newsreader) and
  [Roboto](https://fonts.google.com/specimen/Roboto) (Google Fonts), both named
  in Baker's brand guidelines.
