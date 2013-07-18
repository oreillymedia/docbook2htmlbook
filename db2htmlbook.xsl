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
    <xsl:attribute name="data-type">book</xsl:attribute>
    <h1><xsl:apply-templates select="title"/></h1>
    <xsl:call-template name="titlepage"/>
    <xsl:call-template name="copyrightpage"/>
    <!-- Question: TOC needed in this type of conversion? -->
    <xsl:apply-templates/>
  </body>
</html>
</xsl:template>
  
<xsl:template match="part">
  <div>
    <xsl:attribute name="data-type">part</xsl:attribute>
    <h1>
      <xsl:call-template name="process-id"/>
      <xsl:apply-templates select="title"/>
    </h1>
    <xsl:apply-templates/>
  </div>
</xsl:template>
  
<!-- TODO: Partintro; What element should this convert to? -->
  
<xsl:template match="chapter | preface | appendix | colophon">
  <section>
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
    </xsl:choose>
    <h1>
      <xsl:call-template name="process-id"/>
      <xsl:apply-templates select="title"/>
    </h1>
    <xsl:apply-templates/>
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
    <xsl:attribute name="data-type">sect1</xsl:attribute>
    <h1>
      <xsl:call-template name="process-id"/>
      <xsl:apply-templates select="title"/>
    </h1>
    <xsl:apply-templates/>
  </section>
</xsl:template>
  
<xsl:template match="sect2">
  <section>
    <xsl:attribute name="data-type">sect2</xsl:attribute>
    <h2>
      <xsl:call-template name="process-id"/>
      <xsl:apply-templates select="title"/>
    </h2>
    <xsl:apply-templates/>
  </section>
</xsl:template>

<xsl:template match="sect3">
  <section>
    <xsl:attribute name="data-type">sect3</xsl:attribute>
    <h3>
      <xsl:call-template name="process-id"/>
      <xsl:apply-templates select="title"/>
    </h3>
    <xsl:apply-templates/>
  </section>
</xsl:template>

<xsl:template match="sect4">
  <section>
    <xsl:attribute name="data-type">sect4</xsl:attribute>
    <h4>
      <xsl:call-template name="process-id"/>
      <xsl:apply-templates select="title"/>
    </h4>
    <xsl:apply-templates/>
  </section>
</xsl:template>

<xsl:template match="sect5 | sidebar">
  <section>
    <xsl:attribute name="data-type">
      <xsl:choose>
        <xsl:when test="self::sect5">sect5</xsl:when>
        <xsl:when test="self::sidebar">sidebar</xsl:when>
      </xsl:choose>
    </xsl:attribute>
    <h5>
      <xsl:call-template name="process-id"/>
      <xsl:apply-templates select="title"/>
    </h5>
    <xsl:apply-templates/>
  </section>
</xsl:template>
  
<xsl:template match="note | tip | warning | caution">
  <div>
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
    <xsl:apply-templates/>
  </div>
</xsl:template>

<!-- Used apply-templates for all title output, to retain any child elements. Have to then specifically 
   output both text and child elements of title here -->
<xsl:template match="title"><xsl:value-of select="title/text()"/><xsl:apply-templates/></xsl:template>
  
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
    <xsl:attribute name="data-type">programlisting</xsl:attribute>
    <xsl:apply-templates/>
  </pre>
</xsl:template>
<xsl:template match="example">
  <div>
    <xsl:attribute name="data-type">example</xsl:attribute>
    <h5><xsl:apply-templates select="title"/></h5>
    <xsl:apply-templates select="programlisting"/>
  </div>
</xsl:template>
  
<!-- Figures -->
<xsl:template match="figure">
  <figure>
    <figcaption><xsl:apply-templates select="title"/></figcaption>
    <img>
      <xsl:attribute name="src"><xsl:value-of select="mediaobject/imagedata/@fileref"/></xsl:attribute>
      <!-- TODO: Test fig alt text -->
      <xsl:if test="mediaobject/textobject">
        <!-- Use value-of for alt text, so no child elements are output in alt attribute -->
        <xsl:attribute name="alt"><xsl:value-of select="mediaobject/textobject/phrase"/></xsl:attribute>
      </xsl:if>
    </img>
  </figure>
</xsl:template>
  
  
  <!-- ******************************* INLINES ******************************* -->

<!-- Question: Inlines within inlines okay? For example, constant width bold is <strong><code>?  -->
<!-- TODO: email, ulink, footnote -->
<!-- PIs, phrase keep-togethers -->
<xsl:template match="literal"><code><xsl:apply-templates/></code></xsl:template>
<xsl:template match="emphasis"><em><xsl:apply-templates/></em></xsl:template>
<xsl:template match="emphasis[@role='strong']"><strong><xsl:apply-templates/></strong></xsl:template>
<xsl:template match="emphasis[@role='strikethrough']">
  <span>
    <xsl:attribute name="data-type">strikethrough</xsl:attribute>
    <xsl:apply-templates/>
  </span>
</xsl:template>
<xsl:template match="ulink">
  <a>
    <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
    <xsl:apply-templates/>
  </a>
</xsl:template>
  

  
  
  <!-- ******************************* NAMED TEMPLATES ******************************* -->
  
<xsl:template name="meta">
  <xsl:if test="bookinfo/isbn">
    <meta><xsl:attribute name="name">isbn13</xsl:attribute><xsl:value-of select="bookinfo/isbn"/></meta>
    <meta><xsl:attribute name="name">edition</xsl:attribute><xsl:value-of select="bookinfo/edition"/></meta>
    <!-- Question: What other meta elements do we want to pull in from the Docbook? -->
  </xsl:if>
</xsl:template>

<xsl:template name="titlepage">
  <section>
    <xsl:attribute name="data-type">titlepage</xsl:attribute>
    <h1><xsl:value-of select="title"/></h1>
    <h2>
      <xsl:attribute name="data-type">author</xsl:attribute>
      <xsl:text>by </xsl:text>
      <!-- TODO: Add logic to insert correct commas between multiple author names -->
      <xsl:for-each select="bookinfo/author">
        <xsl:value-of select="firstname"/>
        <xsl:text> </xsl:text>
        <xsl:if test="othername"><xsl:value-of select="othername"/><xsl:text> </xsl:text></xsl:if>
        <xsl:value-of select="surname"/>
      </xsl:for-each>
    </h2>
  </section>
</xsl:template>
  
<xsl:template name="copyrightpage">
  <section>
    <xsl:attribute name="data-type">copyright-page</xsl:attribute>
    <h1><xsl:value-of select="title"/></h1>
    <!-- TODO: Add logic to insert correct commas between multiple author names -->
    <xsl:for-each select="bookinfo/author">
      <p>
        <xsl:attribute name="class">author</xsl:attribute>
        <xsl:text>by </xsl:text>
        <xsl:value-of select="firstname"/>
        <xsl:text> </xsl:text>
        <xsl:if test="othername"><xsl:value-of select="othername"/><xsl:text> </xsl:text></xsl:if>
        <xsl:value-of select="surname"/>
      </p>
    </xsl:for-each>
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
  
<!-- To do -->
<xsl:template match="prefacinfo"/>
<xsl:template match="dedication"/>
<xsl:template match="index"/>
<xsl:template match="indexterm"/>
<xsl:template match="bibliography"/>
<xsl:template match="glossary"/>
<xsl:template match="footnote"/>
<xsl:template match="xref"/>
<!-- Question: Can we retain keep-togethers somehow? -->
<xsl:template match="phrase[@role='keep-together']"><xsl:apply-templates/></xsl:template>

</xsl:stylesheet>