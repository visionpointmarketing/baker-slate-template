<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:fw="http://technolutions.com/framework" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xhtml">
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <template path="/shared/base.xslt" xmlns="http://technolutions.com/framework" />
      <head>
        <!-- Cache busting: bump the timestamp (yyyyMMddHHmm) whenever build.css
             or build-fonts.css changes, or Slate will keep serving the old copy.
             Note this trick works for <link href> but NOT for image src — Slate
             strips query strings from those. See images/README.md. -->
        <link href="/shared/build-fonts.css?v=202609241200" rel="stylesheet" />
        <link href="/shared/build.css?v=202609241200" rel="stylesheet" />
        <link href="/shared/build-mobile-global.css" rel="stylesheet" />
        <script src="/shared/build-mobile-global.js" />
        <style>html &gt; body { line-height: normal; } ul.cr, li.cr { margin: 0; padding: 0; } #content { clear: both; padding: 15px; } #global { float: right; } #global ul, #global li { list-style: none; margin: 0; padding: 0; }</style>
        <meta name="viewport" content="user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width" class="cr" />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin" />
        <link href="https://fonts.googleapis.com/css2?family=Newsreader:ital,opsz,wght@0,6..72,300;0,6..72,400;0,6..72,500;0,6..72,600;1,6..72,300;1,6..72,400&amp;family=Roboto:wght@300;400;500;700&amp;display=swap" rel="stylesheet" />
        <xsl:apply-templates select="xhtml:html/xhtml:head/node()" />
      </head>
      <body>
        <xsl:copy-of select="xhtml:html/xhtml:body/@*" />
        <div id="page">

          <a class="skip-link" href="#main-content">Skip to main content</a>

          <!-- ============================================================
               SITE HEADER
               Navy bar, logo only. The live site's mega-menu is intentionally
               not carried over: it needs the site's JavaScript and every link
               in it leads away from the form the applicant is completing.
               ============================================================ -->
          <header class="site-header" role="banner">
            <div class="site-header__inner">
              <a class="site-header__brand" href="https://www.bakeru.edu/" aria-label="Baker University home">
                <img class="site-header__logo" src="/images/logo-baker.svg" alt="Baker University" width="132" height="52" />
              </a>
            </div>
          </header>

          <!-- ============================================================
               SLATE CONTENT
               Slate injects forms, events, portal pages, the application
               checklist and decision letters into #content. The wrapper gives
               them all consistent width and rhythm; build.css widens it when a
               sidebar, subtabs or a fixed table is present.
               ============================================================ -->
          <main id="main-content" class="slate-form-area" role="main">
            <div class="slate-form-area__inner">
              <div id="global" />
              <div id="content">
                <xsl:apply-templates select="xhtml:html/xhtml:body/node()" />
              </div>
            </div>
          </main>

          <!-- ============================================================
               SITE FOOTER
               Mirrors bakeru.edu: brand + social, contact, utility links, the
               non-discrimination statement, and the legal row.
               Keep in sync with index.html.
               ============================================================ -->
          <footer class="site-footer" id="fsFooter" role="contentinfo">
            <div class="site-footer__inner">

              <div class="site-footer__top">

                <div class="site-footer__brand-col">
                  <a class="site-footer__brand" href="https://www.bakeru.edu/" aria-label="Baker University home">
                    <img class="site-footer__logo" src="/images/logo-baker.svg" alt="Baker University" width="132" height="52" />
                  </a>
                  <p class="site-footer__social-label">Connect with us:</p>
                  <nav class="site-footer__social" aria-label="Social media">
                    <ul>
                      <li>
                        <a href="https://www.facebook.com/BakerUniversity/" target="_blank" rel="noopener" aria-label="Baker University on Facebook (opens in a new window)">
                          <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false" width="20" height="20" xmlns="http://www.w3.org/2000/svg"><path fill="currentColor" d="M13.5 21v-8h2.7l.4-3.1h-3.1V7.9c0-.9.3-1.5 1.6-1.5h1.7V3.6c-.3 0-1.3-.1-2.5-.1-2.5 0-4.2 1.5-4.2 4.3v2.4H7.4V13h2.7v8h3.4z" /></svg>
                        </a>
                      </li>
                      <li>
                        <a href="https://www.instagram.com/bakeruniversity/" target="_blank" rel="noopener" aria-label="Baker University on Instagram (opens in a new window)">
                          <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false" width="20" height="20" xmlns="http://www.w3.org/2000/svg"><path fill="currentColor" d="M12 4.5c2.4 0 2.7 0 3.7.1 1 0 1.5.2 1.9.4.5.2.8.4 1.2.8.4.4.6.7.8 1.2.2.4.3.9.4 1.9 0 1 .1 1.3.1 3.7s0 2.7-.1 3.7c0 1-.2 1.5-.4 1.9-.2.5-.4.8-.8 1.2-.4.4-.7.6-1.2.8-.4.2-.9.3-1.9.4-1 0-1.3.1-3.7.1s-2.7 0-3.7-.1c-1 0-1.5-.2-1.9-.4-.5-.2-.8-.4-1.2-.8-.4-.4-.6-.7-.8-1.2-.2-.4-.3-.9-.4-1.9 0-1-.1-1.3-.1-3.7s0-2.7.1-3.7c0-1 .2-1.5.4-1.9.2-.5.4-.8.8-1.2.4-.4.7-.6 1.2-.8.4-.2.9-.3 1.9-.4 1 0 1.3-.1 3.7-.1M12 3c-2.4 0-2.8 0-3.7.1-1 0-1.6.2-2.2.4-.6.2-1.2.6-1.7 1.1S3.7 5.7 3.5 6.3c-.2.6-.4 1.2-.4 2.2C3 9.4 3 9.7 3 12s0 2.6.1 3.6c0 1 .2 1.6.4 2.2.2.6.6 1.2 1.1 1.7s1 .9 1.7 1.1c.6.2 1.2.4 2.2.4 1 .1 1.3.1 3.6.1s2.7 0 3.7-.1c1 0 1.6-.2 2.2-.4.6-.2 1.2-.6 1.7-1.1s.9-1 1.1-1.7c.2-.6.4-1.2.4-2.2 0-1 .1-1.3.1-3.6s0-2.6-.1-3.7c0-1-.2-1.6-.4-2.2-.2-.6-.6-1.2-1.1-1.7s-1-.9-1.7-1.1c-.6-.2-1.2-.4-2.2-.4C14.6 3 14.3 3 12 3zm0 4.4c-2.5 0-4.6 2-4.6 4.6s2 4.6 4.6 4.6 4.6-2 4.6-4.6-2.1-4.6-4.6-4.6zm0 7.6c-1.7 0-3-1.3-3-3s1.3-3 3-3 3 1.3 3 3-1.3 3-3 3zm4.8-8.9c-.6 0-1.1.5-1.1 1.1s.5 1.1 1.1 1.1 1.1-.5 1.1-1.1c-.1-.6-.5-1.1-1.1-1.1z" /></svg>
                        </a>
                      </li>
                      <li>
                        <a href="https://www.linkedin.com/school/baker-university/" target="_blank" rel="noopener" aria-label="Baker University on LinkedIn (opens in a new window)">
                          <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false" width="20" height="20" xmlns="http://www.w3.org/2000/svg"><path fill="currentColor" d="M6.94 5.5a1.94 1.94 0 1 1-3.88 0 1.94 1.94 0 0 1 3.88 0zM7 8.48H3V21h4V8.48zm6.32 0H9.34V21h3.94v-6.57c0-3.66 4.77-4 4.77 0V21H22v-7.93c0-6.17-7.06-5.94-8.72-2.91l.04-1.68z" /></svg>
                        </a>
                      </li>
                      <li>
                        <a href="https://www.youtube.com/channel/UChKbAy2Vp01oiNcTcpHyY4g" target="_blank" rel="noopener" aria-label="Baker University on YouTube (opens in a new window)">
                          <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false" width="20" height="20" xmlns="http://www.w3.org/2000/svg"><path fill="currentColor" d="M23 12s0-3.2-.4-4.7a3 3 0 0 0-2.1-2.1C18.9 4.7 12 4.7 12 4.7s-6.9 0-8.5.5a3 3 0 0 0-2.1 2.1C1 8.8 1 12 1 12s0 3.2.4 4.7a3 3 0 0 0 2.1 2.1c1.6.5 8.5.5 8.5.5s6.9 0 8.5-.5a3 3 0 0 0 2.1-2.1c.4-1.5.4-4.7.4-4.7zM9.8 15.2V8.8l5.7 3.2-5.7 3.2z" /></svg>
                        </a>
                      </li>
                      <li>
                        <a href="https://www.tiktok.com/@bakeruniversity" target="_blank" rel="noopener" aria-label="Baker University on TikTok (opens in a new window)">
                          <svg viewBox="0 0 24 24" aria-hidden="true" focusable="false" width="20" height="20" xmlns="http://www.w3.org/2000/svg"><path fill="currentColor" d="M16.6 5.8a4.8 4.8 0 0 1-1.1-3.1h-3v12.2a2.6 2.6 0 1 1-1.8-2.5v-3a5.6 5.6 0 1 0 4.8 5.5V9.6a7.8 7.8 0 0 0 4.5 1.4V8a4.8 4.8 0 0 1-3.4-2.2z" /></svg>
                        </a>
                      </li>
                    </ul>
                  </nav>
                </div>

                <section class="site-footer__contact" aria-label="Contact information">
                  <ul>
                    <li>
                      <span class="site-footer__contact-label">Phone</span>
                      <a href="tel:+17855946451">(785) 594-6451</a>
                    </li>
                    <li>
                      <a href="https://maps.app.goo.gl/aQkYZK3bDLcsYEPbA" target="_blank" rel="noopener">Get Directions<span class="visually-hidden"> (opens in a new window)</span></a>
                    </li>
                  </ul>
                </section>

                <nav class="site-footer__utility" aria-label="Footer navigation">
                  <ul>
                    <li><a href="https://www.bakeru.edu/campus-safety">Campus Safety &amp; Alerts</a></li>
                    <li><a href="https://www.bakeru.edu/about-baker/careers-baker">Careers</a></li>
                    <li><a href="https://wildcatwearhouse.myshopify.com/" target="_blank" rel="noopener">Wildcat Wearhouse<span class="visually-hidden"> (opens in a new window)</span></a></li>
                    <li><a href="https://www.bakeru.edu/alumni">Alumni</a></li>
                  </ul>
                </nav>

              </div>

              <p class="site-footer__statement">Baker University prohibits discrimination on the basis of race, color, national origin, sex, religion, age, disability, marital status, veteran status, pregnancy status, sexual orientation, or other status protected by law in the university's programs and activities. Retaliation is also prohibited by university policy.</p>

              <div class="site-footer__bottom">
                <p class="site-footer__copyright">&#169; Copyright 2026 Baker University</p>
                <nav class="site-footer__legal" aria-label="Legal">
                  <ul>
                    <li><a href="https://www.bakeru.edu/policies-procedures/title-ix">Title IX</a></li>
                    <li><a href="https://www.bakeru.edu/policies-procedures/privacy-policy">Privacy Policy</a></li>
                    <li><a href="https://www.bakeru.edu/consumer-information">Consumer Information</a></li>
                    <li><a href="https://www.bakeru.edu/policies-procedures/compliance-reporting">Compliance Reporting</a></li>
                    <li><a href="https://www.bakeru.edu/about-baker/accreditations-standards">Accreditation</a></li>
                  </ul>
                </nav>
              </div>

            </div>
          </footer>
        </div>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
