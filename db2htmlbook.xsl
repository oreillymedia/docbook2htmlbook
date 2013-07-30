<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.w3.org/1999/xhtml ../schema/htmlbook.xsd"
  xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="xml" indent="yes"/>


<!-- DEVELOPMENT: Output warning and all elements not handled by this stylesheet yet. -->
<xsl:template match="*">
  <xsl:message terminate="no">
    WARNING: Unmatched element: <xsl:value-of select="name()"/>
  </xsl:message>
  
  <xsl:apply-templates/>
</xsl:template>
  
  
  <!-- ******************************* BLOCKS ******************************* -->

<xsl:template match="book">
<html>
  <xsl:copy-of select="document('')/*/@xsi:schemaLocation"/>
  <head>
    <title><xsl:value-of select="title"/></title>
    <xsl:call-template name="meta"/>
  </head>
  <body>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">book</xsl:attribute>
    <h1><xsl:apply-templates select="title"/></h1>
    <xsl:call-template name="titlepage"/>
    <xsl:call-template name="copyrightpage"/>
    <!-- Question: TOC needed, or is it generated later? -->
    <xsl:apply-templates select="*[not(self::title)]"/>
  </body>
</html>
</xsl:template>
  
<xsl:template match="part">
  <div>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">part</xsl:attribute>
    <h1>
      <xsl:call-template name="process-id"/>
      <xsl:apply-templates select="title"/>
    </h1>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </div>
</xsl:template>
  
<!-- TODO: Partintro; What element should this convert to? -->
  
<xsl:template match="chapter | preface | appendix | colophon | dedication">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:choose>
      <xsl:when test="self::chapter"><xsl:attribute name="data-type">chapter</xsl:attribute></xsl:when>
      <xsl:when test="self::preface[contains(@id,'foreword')]">
        <xsl:attribute name="data-type">foreword</xsl:attribute>
      </xsl:when>
      <xsl:when test="self::preface"><xsl:attribute name="data-type">preface</xsl:attribute></xsl:when>
      <xsl:when test="self::appendix[contains(@role,'afterword')]">
        <xsl:attribute name="data-type">afterword</xsl:attribute>
      </xsl:when>
      <xsl:when test="self::appendix"><xsl:attribute name="data-type">appendix</xsl:attribute></xsl:when>
      <!-- TODO: colophon not working -->
      <xsl:when test="self::colophon"><xsl:attribute name="data-type">colophon</xsl:attribute></xsl:when>
      <xsl:when test="self::dedication"><xsl:attribute name="data-type">dedication</xsl:attribute></xsl:when>
    </xsl:choose>
    <h1>
      <xsl:apply-templates select="title"/>
    </h1>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </section>
</xsl:template>
 
<xsl:template match="para | simpara">
  <p>
    <xsl:call-template name="process-id"/>
    <xsl:apply-templates/>
  </p>
</xsl:template>
  
<xsl:template match="sect1">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">sect1</xsl:attribute>
    <h1>
      <xsl:apply-templates select="title"/>
    </h1>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </section>
</xsl:template>
  
<xsl:template match="sect2">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">sect2</xsl:attribute>
    <h2>
      <xsl:apply-templates select="title"/>
    </h2>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </section>
</xsl:template>

<xsl:template match="sect3">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">sect3</xsl:attribute>
    <h3>
      <xsl:apply-templates select="title"/>
    </h3>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </section>
</xsl:template>

<xsl:template match="sect4">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">sect4</xsl:attribute>
    <h4>
      <xsl:apply-templates select="title"/>
    </h4>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </section>
</xsl:template>

<xsl:template match="sect5">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">sect5</xsl:attribute>
    <h5>
      <xsl:apply-templates select="title"/>
    </h5>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </section>
</xsl:template>
  
<xsl:template match="sidebar">
  <aside>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">sidebar</xsl:attribute>
    <h5><xsl:apply-templates select="title"/></h5>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </aside>
</xsl:template>

<xsl:template match="note | tip | warning | caution">
  <div>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">
      <xsl:choose>
        <xsl:when test="self::note">note</xsl:when>
        <xsl:when test="self::tip">tip</xsl:when>
        <xsl:when test="self::warning">warning</xsl:when>
        <xsl:when test="self::caution">caution</xsl:when>
      </xsl:choose>
    </xsl:attribute>
    <xsl:if test="@role='safarienabled'">
      <xsl:attribute name="class">safarienabled</xsl:attribute>
    </xsl:if>
    <xsl:if test="title"><h1><xsl:apply-templates select="title"/></h1></xsl:if>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </div>
</xsl:template>

<xsl:template match="blockquote">
  <!-- TODO: Test this. -->
  <blockquote>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="cite"><xsl:apply-templates select="attribution"/></xsl:attribute>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </blockquote>
</xsl:template>

<!-- Used apply-templates for all title output, to retain any child elements. Have to then specifically 
   output both text and child elements of title here -->
<xsl:template match="title">
  <xsl:value-of select="title/text()"/>
  <xsl:apply-templates/>
</xsl:template>
  
<!-- Lists -->
<xsl:template match="itemizedlist">
  <ul>
    <xsl:for-each select="listitem">
      <li><xsl:apply-templates/></li>
    </xsl:for-each>
  </ul>
</xsl:template>
<xsl:template match="orderedlist">
  <ol>
    <xsl:for-each select="listitem">
      <li><xsl:apply-templates/></li>
    </xsl:for-each>
  </ol>
</xsl:template>
<xsl:template match="variablelist">
  <dl>
    <xsl:for-each select="varlistentry">
      <xsl:for-each select="term">
        <dt><xsl:apply-templates/></dt>
      </xsl:for-each>
      <xsl:for-each select="listitem">
        <dd><xsl:apply-templates/></dd>
      </xsl:for-each>
    </xsl:for-each>
  </dl>
</xsl:template>

<!-- Code Blocks -->
<xsl:template match="programlisting | screen">
  <pre>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">programlisting</xsl:attribute>
    <xsl:apply-templates/>
  </pre>
</xsl:template>
<xsl:template match="example">
  <div>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">example</xsl:attribute>
    <h5><xsl:apply-templates select="title"/></h5>
    <xsl:apply-templates select="programlisting"/>
  </div>
</xsl:template>
  
<!-- Figures -->
<xsl:template match="figure">
  <figure>
    <xsl:call-template name="process-id"/>
    <!-- Output float attribute? -->
    <figcaption><xsl:apply-templates select="title"/></figcaption>
    <img>
      <xsl:attribute name="src">
        <xsl:choose>
          <xsl:when test="mediaobject/imageobject[@role='web']">
            <xsl:value-of select="mediaobject/imageobject[@role='web']/imagedata/@fileref"/>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="mediaobject/imageobject/imagedata/@fileref"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <!-- TODO: Test fig alt text -->
      <xsl:if test="mediaobject/textobject">
        <!-- Use value-of for alt text, so no child elements are output in alt attribute -->
        <xsl:attribute name="alt"><xsl:value-of select="mediaobject/textobject/phrase"/></xsl:attribute>
      </xsl:if>
    </img>
  </figure>
</xsl:template>
  
<!-- Tables -->
<xsl:template match="table | informaltable">
  <table>
    <xsl:call-template name="process-id"/>
    <xsl:if test="title">
      <caption><xsl:apply-templates select="title"/></caption>
    </xsl:if>
    <!-- TODO: Add handling for colgroup -->
    <!-- TODO: Add handling for entry attributes like align, etc. -->
    <thead>
      <xsl:apply-templates select="tgroup/thead"/>
    </thead>
    <tbody>
      <xsl:apply-templates select="tgroup/tbody"/>
    </tbody>
  </table>
</xsl:template>
<xsl:template match="row">
  <tr><xsl:apply-templates/></tr>
</xsl:template>
<xsl:template match="entry">
  <xsl:choose>
    <xsl:when test="ancestor::thead">
      <th><xsl:value-of select="para/text()"/><xsl:apply-templates/></th>
    </xsl:when>
    <xsl:otherwise>
      <td><xsl:value-of select="text()"/><xsl:apply-templates/></td>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
  <!-- thead cannot contain p elements -->
  <!-- Find a better way to handle this. -->
  <xsl:template match="thead/row/entry/para"/>
  
<!-- Remarks -->
<xsl:template match="remark">
  <xsl:comment><xsl:apply-templates/></xsl:comment>
</xsl:template>
  
  
  <!-- ******************************* INLINES ******************************* -->

<!-- ToDo: Test inlines within inlines okay (e.g., constant width bold <strong><code>).  -->
<xsl:template match="literal"><code><xsl:apply-templates/></code></xsl:template>
<xsl:template match="emphasis"><em><xsl:apply-templates/></em></xsl:template>
<xsl:template match="emphasis[@role='strong']"><strong><xsl:apply-templates/></strong></xsl:template>
<xsl:template match="superscript"><sup><xsl:apply-templates/></sup></xsl:template>
<xsl:template match="subscript"><sub><xsl:apply-templates/></sub></xsl:template>
  
<xsl:template match="emphasis[@role='strikethrough']">
  <span>
    <xsl:attribute name="data-type">strikethrough</xsl:attribute>
    <xsl:apply-templates/>
  </span>
</xsl:template>
  
<xsl:template match="ulink">
  <!-- Is this right, or should it be <link>? -->
  <!-- URLs will render correctly as is below. But if there are any internal links, they'll need a hash before them. Check this. -->
  <a href="{@url}">
    <xsl:apply-templates/>
  </a>
</xsl:template>
  
<!--<xsl:template match="xref">
  <!-\- TO DO: Correct labels for each type of xref -\->
  <!-\- This method would use a ton of 'ifs' for figures, tables, etc; counts would have to take into acount each type
          of section it could appear in.
          try this to select label: local-name(id(@linkend)) -\->
  <xsl:variable name="label">
    <xsl:choose>
      <xsl:when test="id(@linkend)[self::part]"><xsl:text>Part </xsl:text></xsl:when>
      <xsl:when test="id(@linkend)[self::chapter]"><xsl:text>Chapter </xsl:text></xsl:when>
      <xsl:when test="id(@linkend)[self::preface]"><xsl:text>Preface </xsl:text></xsl:when>
      <xsl:when test="id(@linkend)[self::appendix]"><xsl:text>Appendix </xsl:text></xsl:when>
      <xsl:when test="id(@linkend)[self::figure]"><xsl:text>Figure </xsl:text></xsl:when>
      <xsl:when test="id(@linkend)[self::table]"><xsl:text>Table </xsl:text></xsl:when>
      <xsl:when test="id(@linkend)[self::sidebar]"><xsl:text>Sidebar </xsl:text></xsl:when>
      <xsl:when test="id(@linkend)[self::example]"><xsl:text>Example </xsl:text></xsl:when>
      <xsl:when test="id(@linkend)[self::sect1 | self::sect2 | self::sect3 | self::sect4 | self::sect5 | self::sect6 | self::section]"><xsl:text> "</xsl:text><xsl:value-of select="id(@linkend)/title"/><xsl:text>"</xsl:text></xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:variable>
  <!-\- TO DO: Set up counts for fig, table, chap, etc. numbers -\->
  <!-\- Not all need counts. Like sections, which need section title -\->
  <xsl:variable name="count">
    <!-\- Gah! Can't use id() function in xsl:number count below. -\->
    <xsl:if test="id(@linkend)[self::chapter]"><xsl:number count="id(@linkend)/chapter" level="any" format="1"/></xsl:if>
    
    <xsl:if test="id(@linkend)[self::part]"><xsl:number count="part" level="any" format="1"/></xsl:if>
    <xsl:if test="id(@linkend)[self::preface]"/> <!-\- No count for preface (as seen in csspdf and dbtopdf) -\->
    <xsl:if test="id(@linkend)[self::chapter]"><xsl:number count="appendix" level="any" format="a"/></xsl:if>
    <xsl:if test="id(@linkend)[self::figure]"><xsl:number count="chapter" level="any" format="01"/><xsl:text>-</xsl:text><xsl:number count="figure" level="multiple" format="01"/></xsl:if>
  </xsl:variable>
  
  <a href="#{@linkend}">
    <xsl:value-of select="$label"/><xsl:value-of select="$count"/>
  </a>
</xsl:template>

<xsl:template match="xref[id(@linkend)[self::chapter]]">
  
</xsl:template>-->
  
  <!-- ******************************* NAMED TEMPLATES ******************************* -->
  
<xsl:template name="meta">
  <xsl:if test="bookinfo/isbn">
    <meta>
      <xsl:attribute name="name">isbn13</xsl:attribute>
      <xsl:attribute name="content"><xsl:value-of select="bookinfo/isbn"/></xsl:attribute>
    </meta>
    <meta>
      <xsl:attribute name="name">edition</xsl:attribute>
      <xsl:attribute name="content"><xsl:value-of select="bookinfo/edition"/></xsl:attribute>
    </meta>
    <!-- Question: What other meta elements do we want to pull in from the Docbook? -->
  </xsl:if>
</xsl:template>

<xsl:template name="titlepage">
  <section>
    <xsl:attribute name="data-type">titlepage</xsl:attribute>
    <h1><xsl:apply-templates select="title"/></h1>
    <h2>
      <xsl:attribute name="data-type">author</xsl:attribute>
      <xsl:text>by </xsl:text>
      <xsl:choose>
        <xsl:when test="bookinfo/authorgroup">
          <xsl:for-each select="bookinfo/authorgroup/author">
            <xsl:if test="position()=last() and count(../author) > 2">
              <xsl:text>and </xsl:text>
            </xsl:if>
            <xsl:value-of select="firstname"/>
            <xsl:text> </xsl:text>
            <xsl:if test="othername"><xsl:value-of select="othername"/><xsl:text> </xsl:text></xsl:if>
            <xsl:value-of select="surname"/>
            <xsl:choose>
              <!-- Only 2 authors -->
              <xsl:when test="position() = 1 and count(../author) = 2">
                <xsl:text> and </xsl:text>
              </xsl:when>
              <!-- More than 2 authors -->
              <xsl:when test="not(position()=last()) and count(../author) > 2">
                <xsl:text>, </xsl:text>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="bookinfo/author">
            <xsl:if test="position()=last() and count(../author) > 2">
              <xsl:text>and </xsl:text>
            </xsl:if>
            <xsl:value-of select="firstname"/>
            <xsl:text> </xsl:text>
            <xsl:if test="othername"><xsl:value-of select="othername"/><xsl:text> </xsl:text></xsl:if>
            <xsl:value-of select="surname"/>
            <xsl:choose>
              <!-- Only 2 authors -->
              <xsl:when test="position() = 1 and count(../author) = 2">
                <xsl:text> and </xsl:text>
              </xsl:when>
              <!-- More than 2 authors -->
              <xsl:when test="not(position()=last()) and count(../author) > 2">
                <xsl:text>, </xsl:text>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
      
    </h2>
  </section>
</xsl:template>
  
<xsl:template name="copyrightpage">
  <section>
    <xsl:attribute name="data-type">copyright-page</xsl:attribute>
    <h1><xsl:value-of select="title"/></h1>
      <p>
        <xsl:attribute name="class">author</xsl:attribute>
        <xsl:text>by </xsl:text>
        <xsl:choose>
          <xsl:when test="bookinfo/authorgroup">
            <xsl:for-each select="bookinfo/authorgroup/author">
              <xsl:if test="position()=last() and count(../author) > 2">
                <xsl:text>and </xsl:text>
              </xsl:if>
              <xsl:value-of select="firstname"/>
              <xsl:text> </xsl:text>
              <xsl:if test="othername"><xsl:value-of select="othername"/><xsl:text> </xsl:text></xsl:if>
              <xsl:value-of select="surname"/>
              <xsl:choose>
                <!-- Only 2 authors -->
                <xsl:when test="position() = 1 and count(../author) = 2">
                  <xsl:text> and </xsl:text>
                </xsl:when>
                <!-- More than 2 authors -->
                <xsl:when test="not(position()=last()) and count(../author) > 2">
                  <xsl:text>, </xsl:text>
                </xsl:when>
              </xsl:choose>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="bookinfo/author">
              <xsl:if test="position()=last() and count(../author) > 2">
                <xsl:text>and </xsl:text>
              </xsl:if>
              <xsl:value-of select="firstname"/>
              <xsl:text> </xsl:text>
              <xsl:if test="othername"><xsl:value-of select="othername"/><xsl:text> </xsl:text></xsl:if>
              <xsl:value-of select="surname"/>
              <xsl:choose>
                <!-- Only 2 authors -->
                <xsl:when test="position() = 1 and count(../author) = 2">
                  <xsl:text> and </xsl:text>
                </xsl:when>
                <!-- More than 2 authors -->
                <xsl:when test="not(position()=last()) and count(../author) > 2">
                  <xsl:text>, </xsl:text>
                </xsl:when>
              </xsl:choose>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </p>
  </section>
</xsl:template>

  
  <!-- ******************************* MISC ******************************* -->
  
<xsl:template name="process-id">
  <xsl:if test="@id">
    <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
  </xsl:if>
</xsl:template>
 
<!-- Don't output --> 
<xsl:template match="bookinfo"/>
  
  <!-- ******************************* TO DO ******************************* -->

<xsl:template match="index"/>
<xsl:template match="indexterm"/>
<xsl:template match="bibliography"/>
<xsl:template match="glossary"/>
  
  <!-- don't know spec -->
<xsl:template match="prefaceinfo"/>
<xsl:template match="simplelist"/>
<xsl:template match="footnote"/>
<xsl:template match="link"/>
<xsl:template match="co"/>
<xsl:template match="calloutlist"/>
<xsl:template match="epigraph"/>
<xsl:template match="phrase[@role='keep-together']"><xsl:apply-templates/></xsl:template>
  <!-- Spec for other PIs -->

<!-- inlines -->
<xsl:template match="email"><xsl:apply-templates/></xsl:template>
<xsl:template match="application"><xsl:apply-templates/></xsl:template>
<xsl:template match="filename"><xsl:apply-templates/></xsl:template>
<xsl:template match="citetitle"><xsl:apply-templates/></xsl:template>
  
</xsl:stylesheet>