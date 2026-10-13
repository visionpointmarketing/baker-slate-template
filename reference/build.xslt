<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:fw="http://technolutions.com/framework" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xhtml">
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <template path="/shared/base.xslt" xmlns="http://technolutions.com/framework" />
      <head>
        <!-- ?v= Increment timestamp (note, this is yyyyMMDDHHmm to update build-fonts.css and build.css files -->
        <link href="/shared/build-fonts.css?v=2022021415008895119" rel="stylesheet" />
        <link href="/shared/build.css?v=2022021415008895119" rel="stylesheet" />
        <link href="/shared/build-mobile-global.css" rel="stylesheet" />
        <script src="/shared/build-mobile-global.js" />
        <style>html &gt; body { line-height: normal; } ul.cr, li.cr { margin: 0; padding: 0; } #content { clear: both; padding: 15px; } #global { float: right; } #global ul, #global li { list-style: none; margin: 0; padding: 0; }</style>
        <meta name="viewport" content="user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width" class="cr" />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin" />
        <link href="https://fonts.googleapis.com/css2?family=Raleway&amp;display=swap" rel="stylesheet" />
        <xsl:apply-templates select="xhtml:html/xhtml:head/node()" />
      </head>
      <body>
        <xsl:copy-of select="xhtml:html/xhtml:body/@*" />
        <div id="page">
          <header id="c_header-span" class="c_main_header cr">
            <div id="c_banner" class="c_wrapper cr">
              <!-- Header logo and link -->
              <a target="_blank" href="#" class="c_logo cr">
                <img src="/images/slate_logo.svg" class="c_slate_logo cr" alt="Slate University Logo" />
              </a>
              <!--Navigation menu links-->
              <!--<nav class="c_main_nav cr">
                <ul class="c_main_nav_links cr">
                  <li>
                    <a target="_blank" href="#" class="c_nav_link_color cr">Visit</a>
                  </li>
                  <li>
                    <a target="_blank" href="#" class="c_nav_link_color cr">Request Information</a>
                  </li>
                  <li>
                    <a target="_blank" href="#" class="c_nav_link_color cr">Apply</a>
                  </li>
                </ul>
              </nav>-->
            </div>
          </header>
          <!-- Body content section -->
          <div style="margin-top: 15px;" class="cr">
            <div class="c_section cr">
              <div class="c_container cr">
                <div id="global" />
                <div id="content">
                  <xsl:apply-templates select="xhtml:html/xhtml:body/node()" />
                </div>
              </div>
            </div>
          </div>
          <!-- Footer content section -->
          <!--<div class="c_ft_body cr">
            <footer>
              <section id="c_ft_main" class="c_wrapper cr">
                <div class="c_ft_main_item cr">
                  <a href="#">
                    <img src="/images/slate_logo_ft.svg" class="c_slate_logo_ft cr" alt="Slate Logo" />
                  </a>
                  <address>
                    <strong>Slate University New Haven</strong>
                    <br />
													157 Church Street, 22nd Floor<br />
													New Haven, CT 06510<br /><a href="tel:+#" class="c_ft_main_item_link_color cr">(203) 555-5555</a></address>
                  <ul class="c_ft_social_list cr">
                    <li>
                      <a href="#">
                        <img src="/images/icons/icons8-facebook-50.png" class="c_social_icon cr" alt="Facebook icon" />
                      </a>
                    </li>
                    <li>
                      <a href="#">
                        <img src="/images/icons/icons8-instagram-50.png" class="c_social_icon cr" alt="Instagram icon" />
                      </a>
                    </li>
                    <li>
                      <a href="#">
                        <img src="/images/icons/icons8-twitter-50.png" class="c_social_icon cr" alt="Twitter icon" />
                      </a>
                    </li>
                  </ul>
                </div>
                <div class="c_ft_main_item cr">
                  <h2 class="c_ft_title cr">Quick Links</h2>
                  <ul class="c_ft_links cr">
                    <li>
                      <a href="#" class="c_ft_main_item_link_color cr">Example Link</a>
                    </li>
                    <li>
                      <a href="#" class="c_ft_main_item_link_color cr">Example Link</a>
                    </li>
                    <li>
                      <a href="#" class="c_ft_main_item_link_color cr">Example Link</a>
                    </li>
                    <li>
                      <a href="#" class="c_ft_main_item_link_color cr">Example Link</a>
                    </li>
                  </ul>
                </div>
                <div class="c_ft_main_item cr">
                  <h2 class="c_ft_title cr">Contact</h2>
                  <ul class="c_ft_links cr">
                    <li>
                      <a href="#" class="c_ft_main_item_link_color cr">Example Link</a>
                    </li>
                    <li>
                      <a href="#" class="c_ft_main_item_link_color cr">Example Link</a>
                    </li>
                    <li>
                      <a href="#" class="c_ft_main_item_link_color cr">Example Link</a>
                    </li>
                    <li>
                      <a href="#" class="c_ft_main_item_link_color cr">Example Link</a>
                    </li>
                  </ul>
                </div>
              </section>
              <section class="c_ft_legal cr">
                <ul class="c_ft_legal_list cr">
                  <li>
                    <a href="#" class="c_ft_legal_link_color cr">Terms &amp; Conditions</a>
                  </li>
                  <li>
                    <a href="#" class="c_ft_legal_link_color cr">Privacy Policy</a>
                  </li>
                  <li>Copyright &#xA9; <xsl:value-of select="fw:year()" /> Technolutions, Inc.</li>
                </ul>
              </section>
            </footer>
          </div>-->
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