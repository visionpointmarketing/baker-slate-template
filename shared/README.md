# Slate install files

The three files in this folder replace the Slate-provided versions and brand
every page Slate renders for Baker: forms, events, portal pages, the
application checklist, decision letters.

| File | What it does |
| --- | --- |
| `build.xslt` | Page template. Wraps Slate's `#content` with Baker's header and footer. |
| `build.css` | All styling: tokens, scoped reset, typography, layout, chrome, Slate UI overrides. Also the stylesheet the staging page loads. |
| `build-fonts.css` | FontAwesome `@font-face`. Newsreader and Roboto load from Google Fonts via `<link>` in `build.xslt`. |

---

## Before the first deploy

1. **Reconcile against Baker's current files.** Done 2026-10-13 — their
   files are in `../reference/`. Baker was running Slate's unbranded starter
   template; the `<template path>`, mobile CSS/JS includes, inline `<style>`
   and every Slate UI rule are carried forward here. Their Raleway font is
   intentionally replaced by Newsreader and Roboto.
2. **Upload the logo.** Database → Configurations → Files, at `/images/`, so it
   resolves as `/images/logo-baker-onecolor-black.svg`.
3. **Validate the XSLT.** It has to be well-formed XML or Slate will reject it:
   ```bash
   python3 -c "import xml.etree.ElementTree as ET; ET.parse('shared/build.xslt')"
   ```

---

## Deploying

Paste-and-publish. No command line.

### 1. Bump the cache-busting timestamp

In `build.xslt`, near the top of `<head>`:

```xml
<link href="/shared/build-fonts.css?v=202609241200" rel="stylesheet" />
<link href="/shared/build.css?v=202609241200" rel="stylesheet" />
```

Set `?v=` to the current date and time as `yyyyMMddHHmm`. Without this,
browsers keep the cached stylesheet and the deploy looks like it did nothing.

### 1b. No theme class needed

Baker approved the final design on 2026-10-13 and it is the default in
`build.css`. `<body>` carries no theme class; there is nothing to set.

### 2. Paste into the Branding Editor

Database → Branding → Branding Editor. For each of the three files: select it
in the sidebar, select all in the editor pane, paste the new content, click
**Save**. (A stray "undefined" entry in that sidebar is a Slate UI quirk —
ignore it.)

Don't publish until all three are saved.

### 3. Preview

Click **Preview**, which renders using the saved-but-unpublished files. Check:

- An application or inquiry form
- The application checklist (subtabs and the status table)
- An event registration page
- A portal page, if one exists
- At least one page on a phone-width viewport

Looking for:

- Header: orange-to-red gradient with the black Baker logo on the left
- Footer: solid orange, black text, with social, contact, utility and legal rows
- Buttons: orange pills with black text, turning black with orange text on hover
- Selected checklist subtab: filled orange with black text
- Links inside `#content`: Autumn Maple (dark orange), underlined
- No navy anywhere, and no sideways scrolling on a phone
- The logo loads (if it shows as alt text, the `/images/` upload is missing)

### 4. Publish

Click **Publish Changes**, then allow about 30 seconds for Slate's CDN to
propagate.

---

## Rolling back

Slate keeps file history in the Branding Editor — restore the previous version
of each file and publish. Failing that, this repo's git history is the record:

```bash
git log --oneline shared/
git show <commit>:shared/build.css > rollback.css
```

---

## Updating later

Edit here, commit, then redo the deploy steps. The repo is the source of truth;
the Branding Editor shows no diffs of its own.

Small one-property tweaks can be made directly in the Branding Editor, but
backport them here the same day or the two fall out of sync — which is the
failure mode this repo's structure exists to prevent.
