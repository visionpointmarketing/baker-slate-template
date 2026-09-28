#!/usr/bin/env python3
"""Generate the staging pages from shared/build.xslt.

build.xslt is the single source of truth for the header and footer markup.
This script lifts that chrome out of it, swaps the Slate-absolute image paths
for relative ones, and wraps each demo fragment in tools/demo/ as a standalone
page. Run it after any change to the chrome:

    python3 tools/make-staging.py

Staging pages are generated files — edit build.xslt or the demo fragments,
never the generated HTML.
"""
import pathlib, re, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
XSLT = (ROOT / "shared" / "build.xslt").read_text()

# out -> (fragment, title, description, theme)
# theme "navy" is the default treatment; "orange" is the alternate view that
# leads with Baker Orange. A theme sets the <body> class and the logo file —
# everything else is token overrides in build.css section 7.
PAGES = {
    "index.html": ("demo-form.html", "Request Information",
                   "Staging preview of Baker University's Slate branding — form page.",
                   "navy"),
    "portal.html": ("demo-portal.html", "Application Status",
                    "Staging preview of Baker University's Slate branding — portal page.",
                    "navy"),
    "index-orange.html": ("demo-form.html", "Request Information (orange)",
                          "Alternate view leading with Baker Orange — form page.",
                          "orange"),
    "portal-orange.html": ("demo-portal.html", "Application Status (orange)",
                           "Alternate view leading with Baker Orange — portal page.",
                           "orange"),
}

THEMES = {
    "navy":   {"body_class": "", "logo": "images/logo-baker.svg"},
    # Both themes use the official logo unaltered. On the orange bar the mark's
    # orange flame loses definition — the fix is Baker's own reversed or
    # one-colour lockup, not artwork we recolour ourselves. See images/README.md.
    "orange": {"body_class": " class=\"theme-orange\"", "logo": "images/logo-baker.svg"},
}

# The review bar exists only on the staging pages, so reviewers can move between
# the two layouts. It is injected here with its own inline styles rather than
# living in build.css or build.xslt, so it cannot leak into what ships to Slate.
REVIEW_BAR_CSS = """
    <style>
        .preview-bar {
            font: 500 14px/1.4 system-ui, -apple-system, "Segoe UI", sans-serif;
            background: #EBEEF9;
            color: #171F3D;
            padding: 10px 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 8px 20px;
            align-items: center;
            border-bottom: 1px solid rgba(23, 31, 61, 0.15);
        }
        .preview-bar strong { font-weight: 700; }
        .preview-bar nav { display: flex; flex-wrap: wrap; gap: 8px 16px; align-items: center; }
        .preview-bar__group { font-weight: 700; }
        .preview-bar a { color: #212B56; padding: 4px 0; }
        .preview-bar a[aria-current] { text-decoration: none; font-weight: 700; }
        @media print { .preview-bar { display: none; } }
    </style>"""


def review_bar(current):
    groups = []
    for heading, pages in (
        ("Navy", (("index.html", "Form"), ("portal.html", "Portal"))),
        ("Orange", (("index-orange.html", "Form"), ("portal-orange.html", "Portal"))),
    ):
        links = []
        for href, label in pages:
            mark = ' aria-current="page"' if href == current else ""
            links.append(f'<a href="{href}"{mark}>{label}</a>')
        joined = "\n                ".join(links)
        groups.append(f"""        <nav aria-label="{heading} theme pages">
            <span class="preview-bar__group">{heading}:</span>
                {joined}
        </nav>""")
    navs = "\n".join(groups)
    return f"""    <div class="preview-bar">
        <strong>Staging preview</strong>
        <span>Slate branding for Baker University &mdash; not a live Slate page.</span>
{navs}
    </div>
"""

FONTS = ('https://fonts.googleapis.com/css2?family=Newsreader:ital,opsz,wght@'
         '0,6..72,300;0,6..72,400;0,6..72,500;0,6..72,600;1,6..72,300;1,6..72,400'
         '&family=Roboto:wght@300;400;500;700&display=swap')


def lift(tag):
    start = XSLT.index(f'<{tag} class="site-{tag}')
    end = XSLT.index(f'</{tag}>', start) + len(f'</{tag}>')
    chunk = XSLT[start:end].replace('src="/images/', 'src="images/')
    # de-indent from XSLT nesting to page nesting
    return "\n".join(l[6:] if l.startswith(" " * 6) else l for l in chunk.split("\n"))


def build(out, fragment, title, description, theme):
    t = THEMES[theme]
    demo = (ROOT / "tools" / "demo" / fragment).read_text().rstrip()
    demo = "\n".join(" " * 12 + l if l.strip() else l for l in demo.split("\n"))
    page = f"""<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>{title} | Baker University</title>
    <meta name="description" content="{description}">
    <meta name="robots" content="noindex,nofollow">

    <!-- Same families and weights requested in shared/build.xslt. -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="{FONTS}">

    <!-- The SAME stylesheet that ships to Slate, not a staging copy of it. -->
    <link rel="stylesheet" href="shared/build.css">
{REVIEW_BAR_CSS}
</head>
<body{t["body_class"]}>

    <!-- GENERATED by tools/make-staging.py — edit shared/build.xslt or
         tools/demo/{fragment}, then re-run the script. -->

    <a class="skip-link" href="#main-content">Skip to main content</a>

{review_bar(out)}
{lift('header').replace('images/logo-baker.svg', t['logo'])}

    <main id="main-content" class="slate-form-area" role="main">
        <div class="slate-form-area__inner">
            <div id="global"></div>
            <div id="content">

{demo}

            </div>
        </div>
    </main>

{lift('footer').replace('images/logo-baker.svg', t['logo'])}

</body>
</html>
"""
    (ROOT / out).write_text(page)
    return out, len(page.split("\n"))


if __name__ == "__main__":
    for out, (fragment, title, desc, theme) in PAGES.items():
        name, lines = build(out, fragment, title, desc, theme)
        print(f"wrote {name} ({lines} lines)")
