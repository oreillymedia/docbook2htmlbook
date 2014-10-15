<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" 
              encoding="UTF-8"
              doctype-public="-//OASIS//DTD DocBook XML V4.5//EN"
              doctype-system="http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd"/>
  <xsl:preserve-space elements="programlisting screen literallayout"/>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
<!-- Run this script before db2htmlbook.xsl to remove any block elements nested inside para elements 
     that would cause invalid HTMLBook output. -->

<xsl:variable name="blocks"> itemizedlist screen blockquote example figure 
 informalfigure table informaltable warning caution tip note orderedlist calloutlist 
 programlisting equation informalequation simplelist variablelist </xsl:variable>

<xsl:template match="para">

<xsl:for-each-group select="*|node()" group-starting-with="*[matches($blocks, concat(' ', name(), ' '))]">
  <xsl:choose>
    <xsl:when test="current-group()[1]/self::*[matches($blocks, concat(' ', name(), ' '))]">
          <xsl:for-each-group select="current-group()" group-ending-with="*[matches($blocks, concat(' ', name(), ' '))]">
            <xsl:choose>
              <xsl:when test="current-group()[1]/self::*[matches($blocks, concat(' ', name(), ' '))]">
                <xsl:apply-templates select="current-group()"/>
              </xsl:when>
              <xsl:otherwise>
                <para>
                  <xsl:sequence select="current-group()"/>
                </para>
              </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each-group>
    </xsl:when>
    <xsl:otherwise>
        <para>
            <xsl:sequence select="current-group()"/>
        </para>
      </xsl:otherwise>
  </xsl:choose>
</xsl:for-each-group>

<!-- Need to preeserve any empty paras in source -->
<xsl:if test="self::para[not(node())]">
  <para/>
</xsl:if>

</xsl:template>

</xsl:stylesheet>