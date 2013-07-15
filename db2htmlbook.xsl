<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" indent="yes"/>

<!-- BLOCKS -->
<xsl:template match="book">
<html>
  <head>
    <title><xsl:value-of select="title"/></title>
    <xsl:for-each select="bookinfo/author">
      <meta>
        <!-- Need handling for editors, contributors, etc. -->
        <xsl:attribute name="name">author</xsl:attribute>
        <xsl:attribute name="content">
          <xsl:value-of select="firstname"/><xsl:text> </xsl:text>
          <xsl:choose>
            <xsl:when test="othername"><xsl:value-of select="othername"/><xsl:text> </xsl:text></xsl:when>
          </xsl:choose>
          <xsl:value-of select="surname"/>
        </xsl:attribute>
      </meta>
    </xsl:for-each>
  </head>
  <body>
    <xsl:attribute name="class">book</xsl:attribute>
    <h1><xsl:value-of select="title"/></h1>
    <!-- Title page -->
    <!-- TOC -->
    <xsl:apply-templates/>
  </body>
</html>
</xsl:template>
  
<xsl:template match="chapter | preface | appendix">
  <section>
    <xsl:choose>
      <xsl:when test="self::chapter"><xsl:attribute name="class">chapter</xsl:attribute></xsl:when>
      <xsl:when test="self::preface"><xsl:attribute name="class">preface</xsl:attribute></xsl:when>
      <xsl:when test="self::appendix"><xsl:attribute name="class">appendix</xsl:attribute></xsl:when>
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
  
<xsl:template name="process-id">
  <xsl:if test="@id">
    <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
  </xsl:if>
</xsl:template>
 
<!-- To do --> 
<xsl:template match="text()"/>
<xsl:template match="bookinfo"/>
<xsl:template match="index"/>
<xsl:template match="colophon"/>

</xsl:stylesheet>