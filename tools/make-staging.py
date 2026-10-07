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

# Baker approved the orange treatment on 2026-10-02, so it is the default in
# build.css. The earlier navy and mixed treatments are in git history at
# 37a2f18 if they are ever needed again.
#
# The *-gradient pages preview the orange gradient Baker shared on 2026-10-05
# (BU26-BG-TIBC-O-9X6-Gradient). It is a concept they are still developing with
# their agency, not an approved direction, so it is opt-in: the same markup
# with a `chrome-gradient` class on <body>, which build.css picks up.
PAGES = {
    "index.html": ("demo-form.html", "Request Information",
                   "Staging preview of Baker University's Slate branding — form page.", ""),
    "portal.html": ("demo-portal.html", "Application Status",
                    "Staging preview of Baker University's Slate branding — portal page.", ""),
    "index-gradient.html": ("demo-form.html", "Request Information",
                            "Staging preview of Baker University's Slate branding — form page, gradient header option.",
                            "chrome-gradient"),
    "portal-gradient.html": ("demo-portal.html", "Application Status",
                             "Staging preview of Baker University's Slate branding — portal page, gradient header option.",
                             "chrome-gradient"),
}

# The review bar exists only on the staging pages, so reviewers can move between
# the two layouts. It is injected here with its own inline styles rather than
# living in build.css or build.xslt, so it cannot leak into what ships to Slate.
#
# It carries no navy either. The bar never reaches Slate, but it sits at the top
# of every page the client reviews, and "remove navy" is easier to honour than
# to explain away.
REVIEW_BAR_CSS = """
    <style>
        .preview-bar {
            font: 500 14px/1.4 system-ui, -apple-system, "Segoe UI", sans-serif;
            background: #F2F2F2;
            color: #000000;
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
        .preview-bar a { color: #BC421B; padding: 4px 0; }
        .preview-bar a[aria-current] { text-decoration: none; font-weight: 700; }
        @media print { .preview-bar { display: none; } }
    </style>"""


def review_bar(current):
    groups = (
        ("Approved solid orange", (("index.html", "Form page"), ("portal.html", "Portal page"))),
        ("Gradient header option", (("index-gradient.html", "Form page"), ("portal-gradient.html", "Portal page"))),
    )
    navs = []
    for group, pages in groups:
        links = []
        for href, label in pages:
            mark = ' aria-current="page"' if href == current else ""
            links.append(f'<a href="{href}"{mark}>{label}</a>')
        joined = "\n                ".join(links)
        navs.append(f"""        <nav aria-label="{group} preview pages">
                <span class="preview-bar__group">{group}:</span>
                {joined}
        </nav>""")
    navs = "\n".join(navs)
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


def build(out, fragment, title, description, body_class=""):
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
<body{f' class="{body_class}"' if body_class else ""}>

    <!-- GENERATED by tools/make-staging.py — edit shared/build.xslt or
         tools/demo/{fragment}, then re-run the script. -->

    <a class="skip-link" href="#main-content">Skip to main content</a>

{review_bar(out)}
{lift('header')}

    <main id="main-content" class="slate-form-area" role="main">
        <div class="slate-form-area__inner">
            <div id="global"></div>
            <div id="content">

{demo}

            </div>
        </div>
    </main>

{lift('footer')}

</body>
</html>
"""
    (ROOT / out).write_text(page)
    return out, len(page.split("\n"))


if __name__ == "__main__":
    for out, (fragment, title, desc, body_class) in PAGES.items():
        name, lines = build(out, fragment, title, desc, body_class)
        print(f"wrote {name} ({lines} lines)")
