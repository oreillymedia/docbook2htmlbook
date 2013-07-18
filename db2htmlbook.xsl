<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.w3.org/1999/xhtml ../schema/htmlbook.xsd"
  xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="xml" indent="yes"/>

<!-- BLOCKS -->
<xsl:template match="book">
<html>
  <xsl:copy-of select="document('')/*/@xsi:schemaLocation"/>
  <head>
    <title><xsl:value-of select="title"/></title>
  </head>
  <body>
    <xsl:attribute name="data-type">book</xsl:attribute>
    <h1><xsl:value-of select="title"/></h1>
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
      <xsl:value-of select="title"/>
    </h1>
    <xsl:apply-templates/>
  </div>
</xsl:template>
  
  <!-- TODO: Partintro; What element should this convert to? -->
  
<xsl:template match="chapter | preface | appendix">
  <section>
    <xsl:choose>
      <xsl:when test="self::chapter"><xsl:attribute name="data-type">chapter</xsl:attribute></xsl:when>
      <xsl:when test="self::preface[contains(@id,'foreword')]">
        <xsl:attribute name="data-type">foreword</xsl:attribute>
      </xsl:when>
      <xsl:when test="self::preface"><xsl:attribute name="data-type">preface</xsl:attribute></xsl:when>
      <xsl:when test="self::appendix"><xsl:attribute name="data-type">appendix</xsl:attribute></xsl:when>
    </xsl:choose>
    <h1>
      <xsl:call-template name="process-id"/>
      <xsl:value-of select="title"/>
    </h1>
    <xsl:apply-templates/>
  </section>
</xsl:template>
  
<xsl:template match="para | simpara">
  <p>
    <xsl:call-template name="process-id"/>
    <xsl:value-of select="text()"/>
    <xsl:apply-templates/>
  </p>
</xsl:template>
  
<xsl:template match="appendix">
  <section>
    <xsl:choose>
      <!-- Check afterword markup -->
      <xsl:when test="@role='afterword'"><xsl:attribute name="data-type">afterword</xsl:attribute></xsl:when>
      <xsl:otherwise><xsl:attribute name="data-type">afterword</xsl:attribute></xsl:otherwise>
    </xsl:choose>
    <h1>
      <xsl:call-template name="process-id"/>
      <xsl:value-of select="title"/>
    </h1>
    <xsl:apply-templates/>
  </section>
</xsl:template>
  
<xsl:template match="sect1">
  <section>
    <xsl:attribute name="data-type">sect1</xsl:attribute>
    <h1>
      <xsl:call-template name="process-id"/>
      <xsl:value-of select="title"/>
    </h1>
    <xsl:apply-templates/>
  </section>
</xsl:template>
  
<xsl:template match="sect2">
  <section>
    <xsl:attribute name="data-type">sect2</xsl:attribute>
    <h2>
      <xsl:call-template name="process-id"/>
      <xsl:value-of select="title"/>
    </h2>
    <xsl:apply-templates/>
  </section>
</xsl:template>

<xsl:template match="sect3">
  <section>
    <xsl:attribute name="data-type">sect3</xsl:attribute>
    <h3>
      <xsl:call-template name="process-id"/>
      <xsl:value-of select="title"/>
    </h3>
    <xsl:apply-templates/>
  </section>
</xsl:template>

<xsl:template match="sect4">
  <section>
    <xsl:attribute name="data-type">sect4</xsl:attribute>
    <h4>
      <xsl:call-template name="process-id"/>
      <xsl:value-of select="title"/>
    </h4>
    <xsl:apply-templates/>
  </section>
</xsl:template>

<xsl:template match="sect5">
  <section>
    <xsl:attribute name="data-type">sect5</xsl:attribute>
    <h5>
      <xsl:call-template name="process-id"/>
      <xsl:value-of select="title"/>
    </h5>
    <xsl:apply-templates/>
  </section>
</xsl:template>
  
  
<!-- NAMED TEMPLATES -->
  
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

  
<!-- MISC -->
<xsl:template name="process-id">
  <xsl:if test="@id">
    <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
  </xsl:if>
</xsl:template>
 
<!-- To do --> 
<xsl:template match="text()"/>
<xsl:template match="bookinfo"/>
<xsl:template match="dedication"/>
<xsl:template match="index"/>
<xsl:template match="colophon"/>
<xsl:template match="bibliography"/>
<xsl:template match="glossary"/>

</xsl:stylesheet>