<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:d="http://docbook.org/ns/docbook"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:exsl="http://exslt.org/common"
  exclude-result-prefixes="d xi xlink exsl html">

  <xsl:preserve-space elements="*"/>
  
  <xsl:output method="xml" indent="yes" 
    doctype-public="-//OASIS//DTD DocBook XML V4.5//EN"
    doctype-system="http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd"/>
  <xsl:variable name="inlines">abbrev accel acronym alt anchor
    annotation application author biblioref citation citebiblioid
    citerefentry citetitle classname code command computeroutput
    constant coref database date editor email emphasis envar errorcode
    errorname errortext errortype exceptionname filename firstterm
    footnote footnoteref foreignphrase function glossterm guibutton
    guiicon guilabel guimenu guimenuitem guisubmenu hardware indexterm
    initializer inlineequation inlinemediaobject interfacename jobtitle
    keycap keycode keycombo keysym link literal markup menuchoice
    methodname modifier mousebutton nonterminal olink ooclass
    ooexception oointerface option optional org orgname package
    parameter person personname phrase productname productnumber prompt
    property quote remark replaceable returnvalue shortcut subscript
    superscript symbol systemitem tag termdef token trademark type uri
    userinput varname wordasword xref</xsl:variable>

  <!-- copy.xsl -->
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template> 
  
  <!-- Overwrite standard template and create elements without 
       a namespace node
  -->
  <xsl:template match="d:*">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
    
  <xsl:template match="@xml:id|@xml:lang">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>
  
  <!-- Suppress the following attributes: -->
  <xsl:template match="@annotations|@version"/>
  <xsl:template match="@xlink:*"/>
  
  <xsl:template match="@xlink:href">
    <xsl:choose>
      <xsl:when test="contains($inlines, local-name(..))">
        <ulink url="{.}" remap="{local-name(..)}">
          <xsl:value-of select=".."/>
        </ulink>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>@xlink:href could not be processed!
  parent element: <xsl:value-of select="local-name(..)"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="d:*[@xlink:href]">
    <xsl:choose>
      <xsl:when test="contains($inlines, local-name())">
        <ulink url="{@xlink:href}" remap="{local-name(.)}">
          <xsl:element name="{local-name()}">
            <xsl:apply-templates 
              select="@*[local-name() != 'href' and
                         namespace-uri() != 'http://www.w3.org/1999/xlink']
                      |node()"/>
          </xsl:element>
        </ulink>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{local-name()}">
          <xsl:apply-templates 
            select="@*[local-name() != 'href' and
                       namespace-uri() != 'http://www.w3.org/1999/xlink']
                    |node()"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="d:link/@xlink:href">
    <xsl:attribute name="url">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="d:link[@xlink:href]">
    <ulink>
      <xsl:apply-templates select="@*|node()"/>
    </ulink>
  </xsl:template>
  
  <xsl:template match="d:link[@linkend]">
    <link>
      <xsl:apply-templates select="@*|node()"/>
    </link>
  </xsl:template>
  
  <!-- Renamed DocBook elements -->
  <xsl:template match="d:personblurb">
    <authorblurb>
      <xsl:apply-templates select="@*|node()"/>
    </authorblurb>
  </xsl:template>
  <xsl:template match="d:tag">
    <sgmltag>
      <xsl:apply-templates select="@*|node()"/>
    </sgmltag>
  </xsl:template>

  <!-- ORM: Additional cleanup below -->
  <!-- Hacking mapping for acknowledgements and annotation -->
  <xsl:template match="d:acknowledgements">
    <preface>
       <xsl:apply-templates select="@*|node()"/>
    </preface>
  </xsl:template>

  <xsl:template match="d:annotation">
    <para>
       <xsl:apply-templates select="@*|node()"/>
    </para>
  </xsl:template>

  <!-- Convert info element to bookinfo -->
  <xsl:template match="d:info">
    <bookinfo>
       <xsl:apply-templates select="@*|node()"/>
    </bookinfo>
  </xsl:template>

  <!-- Drop unnecessary personname element -->
  <xsl:template match="d:personname"/>

  <!-- Drop unnecessary titleabbrev element-->
  <xsl:template match="d:titleabbrev"/>

  <!-- Handling to create IDs/linkends for glossary terms -->
  <xsl:template name="createid">
  <!-- Replace spaces with underscores -->
  <xsl:param name="string" select="."/>
  <xsl:param name="target" select="' '"/>
  <xsl:param name="replacement" select="'_'"/>
  <xsl:choose>
    <xsl:when test="contains($string, $target)">
      <xsl:variable name="rest">
        <xsl:call-template name="createid">
          <xsl:with-param name="string" select="substring-after(normalize-space($string), $target)"/>
          <xsl:with-param name="target" select="$target"/>
          <xsl:with-param name="replacement" select="$replacement"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="concat(substring-before(normalize-space($string), $target), $replacement, $rest)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="normalize-space($string)"/>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:template>

  <!-- Variables for cleaning up and processing IDs/linkends -->
  <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
  <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  <xsl:variable name="parens" select="'()'"/>
  <xsl:variable name="deparens" select="''"/>
  <xsl:variable name="glossstring" select="'gloss_'" />

  <xsl:template name="processid">
     <xsl:param name="string" select="."/>
     <xsl:variable name="idcreation">
        <xsl:call-template name="createid">
          <xsl:with-param name="string" select="$string"/>
        </xsl:call-template>
     </xsl:variable>
     <xsl:variable name="lowercasing" select="translate($idcreation, $uppercase, $lowercase)"/>
     <xsl:variable name="deparenthesizing" select="translate($lowercasing, $parens, $deparens)"/>
     <xsl:value-of select="concat($glossstring, $deparenthesizing)"/>
  </xsl:template>

  <!-- Store a global list of glossentry IDs -->
  <xsl:variable name="globalidlist">
    <xsl:for-each select="//d:glossentry/d:glossterm/text()">
    <xsl:call-template name="processid">
        <xsl:with-param name="string" select="."/>
    </xsl:call-template>
  </xsl:for-each>
  </xsl:variable>

  <!-- Store a global list of glossterm IDs not in glossary -->
  <xsl:variable name="globaltermlist">
    <xsl:for-each select="//d:glossterm[not(ancestor::d:glossary)]">
    <xsl:choose>
      <xsl:when test="self::d:glossterm[not(@baseform)]">
        <xsl:call-template name="processid">
            <xsl:with-param name="string" select="text()"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="processid">
            <xsl:with-param name="string" select="@baseform"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  </xsl:variable>

  <!-- Convert glossterms not in glossary to links, and add linkend -->
  <!-- but ONLY if the linkend would match a glossentry ID -->
  <!-- otherwise drop the tag and add a remark around it -->
  <xsl:template match="d:glossterm[not(ancestor::d:glossary)]">
  <xsl:variable name="glosslinkend">
    <xsl:choose>
        <xsl:when test="self::d:glossterm[not(@baseform)]">
            <xsl:call-template name="processid"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="processid">
              <xsl:with-param name="string" select="@baseform"/>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
        <xsl:choose>
        <xsl:when test="contains($globalidlist, $glosslinkend)">
          <link>
            <xsl:attribute name="linkend"><xsl:value-of select="$glosslinkend"/></xsl:attribute>
            <xsl:apply-templates/>
          </link>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
          <remark>Warning: "<xsl:value-of select="."/>" was marked up as a glossterm in the text but did not match any glossary entries, so the markup was removed during conversion from DocBook 5 to 4.5 in order to prevent validity errors.</remark>
          <xsl:message>Warning: "<xsl:value-of select="."/>" was marked up as a glossterm in the text but did not match any glossary entries, so the markup was removed during conversion from DocBook 5 to 4.5 in order to prevent validity errors.</xsl:message>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <!-- Add IDs only to glossentries that match linkends not in glossary-->
  <xsl:template match="d:glossentry">
  <xsl:variable name="glossid">
      <xsl:call-template name="processid">
        <xsl:with-param name="string" select="child::d:glossterm/text()"/>
      </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="contains($globaltermlist, $glossid)">
      <xsl:choose>
    <xsl:when test="string-length(child::d:glossterm/text()) != 0">
  <glossentry>
    <xsl:attribute name="id"><xsl:value-of select="$glossid"/></xsl:attribute>
    <xsl:apply-templates/>
  </glossentry>
</xsl:when>
  <xsl:otherwise>
<glossentry><xsl:apply-templates/></glossentry>
  </xsl:otherwise>
  </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
      <glossentry><xsl:apply-templates/></glossentry>
  </xsl:otherwise>
  </xsl:choose>
  </xsl:template>

  <!-- Convert section elements to sectNs -->
  <xsl:template match="d:section|d:simplesect">
    <xsl:variable name="level">
      <xsl:call-template name="section.level"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$level = 1">
        <sect1>
          <xsl:apply-templates select="@*|node()"/>
        </sect1>  
      </xsl:when>
      <xsl:when test="$level = 2">
        <sect2>
          <xsl:apply-templates select="@*|node()"/>
        </sect2>  
      </xsl:when>
      <xsl:when test="$level = 3">
        <sect3>
          <xsl:apply-templates select="@*|node()"/>
        </sect3>  
      </xsl:when>
      <xsl:when test="$level = 4">
        <sect4>
          <xsl:apply-templates select="@*|node()"/>
        </sect4>  
      </xsl:when>
      <xsl:when test="$level = 5">
        <sect5>
          <xsl:apply-templates select="@*|node()"/>
        </sect5>  
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- borrowed and modified from docbook-xsl -->
  <xsl:template name="section.level">
    <xsl:param name="node" select="."/>
    <xsl:choose>
      <xsl:when test="$node/../../../../../../d:section|$node/../../../../../../d:simplesect">6</xsl:when>
      <xsl:when test="$node/../../../../../d:section|$node/../../../../../d:simplesect">5</xsl:when>
      <xsl:when test="$node/../../../../d:section|$node/../../../../d:simplesect">4</xsl:when>
      <xsl:when test="$node/../../../d:section|$node/../../../d:simplesect">3</xsl:when>
      <xsl:when test="$node/../../d:section|$node/../../d:simplesect">2</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- New DocBook v5.1 and HTML elements, no mapping available -->
  <xsl:template match="d:arc
                       |d:cover
                       |d:definitions
                       |d:extendedlink
                       |d:givenname
                       |d:locator
                       |d:org|d:tocdiv
                       |html:*">
    <xsl:message>Don't know how to transfer "<xsl:value-of
      select="local-name()"/>" element into DocBook 4</xsl:message>
  </xsl:template>
  
</xsl:stylesheet>
