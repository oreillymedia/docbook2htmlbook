<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xsi:schemaLocation="http://www.w3.org/1999/xhtml ../schema/htmlbook.xsd"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="xsi mml">
<xsl:output method="xml" omit-xml-declaration="yes"/>
<!-- 
*******************************
PARAMETERS:
* xref_label outputs text labels of all xrefs
******************************* 
-->
<xsl:param name="xref_label">false</xsl:param>
<xsl:param name="chunk-output">false</xsl:param>
<xsl:param name="include-html-wrapper">true</xsl:param>
<xsl:param name="include-toc">true</xsl:param>

<!--UNDER CONSTRUCTION: parameters for refentry header positional attributes-->
<!-- Supply one of four values: top-left, top-right, bottom-left, bottom-right -->
<xsl:param name="refname"/>
<xsl:param name="refpurpose"/>
<!-- TODO: Have to accommodate different classes -->
<!-- <xsl:param name="refclass"/>
<xsl:param name="refmiscinfo"/> -->

<!-- 
*******************************
DEVELOPMENT:
Output warning and all elements not handled by this stylesheet yet.
******************************* 
-->

<xsl:template match="*">
  <xsl:message terminate="no">WARNING: Unmatched element: <xsl:value-of select="name()"/>: <xsl:value-of select="."/></xsl:message>
  <xsl:apply-templates/>
</xsl:template>

<!-- 
*******************************
BLOCKS
******************************* 
-->
  
<xsl:template match="book">
  <xsl:choose>
    <xsl:when test="$include-html-wrapper = 'true'">
      <html>
	<xsl:copy-of select="document('')/*/@xsi:schemaLocation"/>
	<head>
	  <title><xsl:apply-templates select="title"/></title>
	  <xsl:call-template name="meta"/>
	</head>
	<body>
	  <xsl:call-template name="process-id"/>
	  <xsl:attribute name="data-type">book</xsl:attribute>
	  <h1><xsl:apply-templates select="title"/></h1>
	  <xsl:call-template name="process-child-content"/>
	</body>
      </html>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="process-child-content"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="process-child-content">
  <xsl:call-template name="titlepage"/>
  <xsl:call-template name="copyrightpage"/>
  <!-- Adding parametrized TOC for optional output -->
    <xsl:choose>
      <xsl:when test="$include-toc = 'true'">
        <nav data-type="toc"/>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  <xsl:choose>
    <xsl:when test="$chunk-output != 'false'">
      <xsl:apply-templates select="*[not(self::title)] | processing-instruction()" mode="chunk"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="*[not(self::title)] | processing-instruction()"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--**** FILE CHUNKING NOT IMPLEMENTED YET ****-->
<!-- BEGIN FILE CHUNKING -->
<!--<xsl:template match="chapter|appendix|preface|colophon|dedication|glossary|bibliography" mode="chunk">
  <xsl:variable name="doc-name">
    <xsl:choose>
      <xsl:when test="self::chapter">
        <xsl:text>ch</xsl:text>
        <xsl:number count="chapter" level="any" format="01"/>
      </xsl:when>
      <xsl:when test="self::appendix">
        <xsl:text>app</xsl:text>
        <xsl:number count="appendix" level="any" format="a"/>
      </xsl:when>
      <xsl:when test="self::preface">
        <xsl:text>pr</xsl:text>
        <xsl:number count="preface" level="any" format="01"/>
      </xsl:when>
      <xsl:when test="self::colophon">
        <xsl:text>colo</xsl:text>
        <xsl:if test="count(//colophon) &gt; 1">
          <xsl:number count="colo" level="any" format="01"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="self::dedication">
        <xsl:text>dedication</xsl:text>
        <xsl:if test="count(//dedication) &gt; 1">
          <xsl:number count="dedication" level="any" format="01"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="self::glossary">
        <xsl:text>glossary</xsl:text>
        <xsl:if test="count(//glossary) &gt; 1">
          <xsl:number count="glossary" level="any" format="01"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="self::bibliography">
        <xsl:text>bibliography</xsl:text>
        <xsl:if test="count(//bibliography) &gt; 1">
          <xsl:number count="bibliography" level="any" format="01"/>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
    <xsl:text>.html</xsl:text>
  </xsl:variable>
  <xsl:result-document href="{$doc-name}">
    <xsl:apply-templates select="." mode="#default"/>
  </xsl:result-document>
</xsl:template>-->
  <!-- *** In Process. Not outputting parts correctly yet *** -->
<!--<xsl:template match="part" mode="chunk">
  <xsl:choose>
    <xsl:when test="partintro">
      <xsl:variable name="doc-name">
        <xsl:text>part</xsl:text>
        <xsl:number count="part" level="any" format="i"/>
        <xsl:text>.html</xsl:text>
      </xsl:variable>
      <xsl:result-document href="{$doc-name}">
        <xsl:apply-templates select="partintro" mode="#default"/>
      </xsl:result-document>
      <xsl:apply-templates select="*[not(self::title)][not(self::partintro)]" mode="chunk"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>-->
<!-- END FILE CHUNKING -->
  
<xsl:template match="part">
  <xsl:variable name="part-number"><xsl:number level="any" count="part"/></xsl:variable>
  <div>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role"/>
    <xsl:attribute name="data-type">part</xsl:attribute>
    <!-- <xsl:if test="$part-number = '1'"><xsl:attribute name="class">pagenumrestart</xsl:attribute></xsl:if> -->
    <h1>
      <xsl:apply-templates select="title"/>
    </h1>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </div>
</xsl:template>
  
<xsl:template match="partintro">
  <xsl:apply-templates/>
</xsl:template>
  
<xsl:template match="chapter | preface | appendix | colophon | dedication">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role"/>
    <xsl:if test="@data-nutshell-tab">
      <xsl:attribute name="data-nutshell-tab"><xsl:value-of select="@data-nutshell-tab"/></xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="self::chapter">
          <xsl:variable name="chapter-number"><xsl:number level="any" count="chapter"/></xsl:variable>
          <xsl:attribute name="data-type">chapter</xsl:attribute>
          <!-- <xsl:if test="$chapter-number = '1' and not(parent::part)"><xsl:attribute name="class">pagenumrestart</xsl:attribute></xsl:if> -->
      </xsl:when>
      <xsl:when test="self::preface[contains(@id,'foreword')]">
        <xsl:attribute name="data-type">foreword</xsl:attribute>
      </xsl:when>
      <xsl:when test="self::preface"><xsl:attribute name="data-type">preface</xsl:attribute></xsl:when>
      <xsl:when test="self::appendix[contains(@role,'afterword')]">
        <xsl:attribute name="data-type">afterword</xsl:attribute>
      </xsl:when>
      <xsl:when test="self::appendix"><xsl:attribute name="data-type">appendix</xsl:attribute></xsl:when>
      <xsl:when test="self::colophon"><xsl:attribute name="data-type">colophon</xsl:attribute></xsl:when>
      <xsl:when test="self::dedication"><xsl:attribute name="data-type">dedication</xsl:attribute></xsl:when>
    </xsl:choose>
    <h1>
      <xsl:apply-templates select="title"/>
    </h1>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </section>
</xsl:template>

<xsl:template match="subtitle">
<p>
<xsl:attribute name="data-type">subtitle</xsl:attribute>
<xsl:apply-templates/>
</p>
</xsl:template>

<!-- TO DO: Check prefacinfo byline output after spec solidified -->
<xsl:template match="prefaceinfo | chapterinfo">
  <p>
    <xsl:attribute name="class">byline</xsl:attribute>
    <xsl:choose>
      <xsl:when test="author">
        <xsl:for-each select="author">
          <xsl:if test="position()=last() and count(../author) > 2">
            <xsl:text>and </xsl:text>
          </xsl:if>
          <xsl:if test="firstname"><xsl:value-of select="firstname"/><xsl:text> </xsl:text></xsl:if>
          <xsl:if test="othername"><xsl:value-of select="othername"/><xsl:text> </xsl:text></xsl:if>
          <xsl:if test="surname"><xsl:value-of select="surname"/></xsl:if>
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
        <xsl:message>WARNING: Prefacinfo element without author element. Check rendering.</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
    </p>
    <xsl:if test="author/affiliation">
      <xsl:for-each select="author/affiliation">
        <p>
          <xsl:attribute name="class">byline</xsl:attribute>
          <xsl:apply-templates select="jobtitle"/>
        </p>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="affiliation">
      <xsl:for-each select="affiliation">
        <p>
          <xsl:attribute name="class">byline</xsl:attribute>
          <xsl:apply-templates select="jobtitle"/>
        </p>
      </xsl:for-each>
    </xsl:if>
</xsl:template>
<xsl:template match="jobtitle">
  <xsl:apply-templates/>
</xsl:template>
  
<xsl:template match="footnote">
  <span>
    <xsl:attribute name="data-type">footnote</xsl:attribute>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role"/>
    <xsl:for-each select="para">
      <xsl:if test="not(position() = 1 )"><br/></xsl:if>
      <xsl:apply-templates select="text() | *"/>
    </xsl:for-each>
  </span>
</xsl:template>
  
<xsl:template match="footnoteref">
  <a href="#{@linkend}">
    <xsl:attribute name="data-type">footnoteref</xsl:attribute>
  </a>
</xsl:template>
  
<xsl:template match="para | simpara">
  <xsl:if test="blockquote | figure | informalfigure | itemizedlist | variablelist | orderedlist | table | informaltable | example | equation | informalequation | note | warning | tip | caution | programlisting | screen">
    <xsl:message terminate="no">WARNING: Nested element <xsl:value-of select="name()"/> inside para will cause invalid HTMLBook output. Please run unwrapblocks.xsl first, and then rerun db2htmlbook.xsl.</xsl:message>
  </xsl:if>
  <p>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role"/>
    <xsl:apply-templates/>
  </p>
</xsl:template>
  
  <!-- TO DO: Check formalpara heading level after spec solidified -->
<xsl:template match="formalpara">
  <div>
    <xsl:attribute name="class">formalpara</xsl:attribute>
      <xsl:call-template name="process-id"/>
      <xsl:call-template name="process-role">
        <xsl:with-param name="append-class">formalpara&#x20;</xsl:with-param>
      </xsl:call-template>
    <h5>
      <xsl:apply-templates select="title"/>
    </h5> 
      <xsl:apply-templates select="node()[not(self::title)]"/>
  </div>
</xsl:template>
  
<xsl:template match="sect1">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role"/>
    <xsl:attribute name="data-type">sect1</xsl:attribute>
    <h1><xsl:apply-templates select="title"/></h1>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </section>
</xsl:template>
  
<xsl:template match="sect2">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role"/>
    <xsl:attribute name="data-type">sect2</xsl:attribute>
    <h2><xsl:apply-templates select="title"/></h2>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </section>
</xsl:template>

<xsl:template match="sect3">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role"/>
    <xsl:attribute name="data-type">sect3</xsl:attribute>
    <h3><xsl:apply-templates select="title"/></h3>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </section>
</xsl:template>

<xsl:template match="sect4">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role"/>
    <xsl:attribute name="data-type">sect4</xsl:attribute>
    <h4><xsl:apply-templates select="title"/></h4>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </section>
</xsl:template>

<xsl:template match="sect5">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role"/>
    <xsl:attribute name="data-type">sect5</xsl:attribute>
    <h5><xsl:apply-templates select="title"/></h5>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </section>
</xsl:template>
  
<xsl:template match="sidebar">
  <aside>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role"/>
    <xsl:attribute name="data-type">sidebar</xsl:attribute>
    <h5><xsl:apply-templates select="title"/></h5>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </aside>
</xsl:template>

<xsl:template match="note | tip | warning | caution | important">
  <div>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role"/>
        <xsl:attribute name="data-type">
          <xsl:choose>
            <xsl:when test="self::note">note</xsl:when>
            <xsl:when test="self::tip">tip</xsl:when>
            <xsl:when test="self::warning">warning</xsl:when>
            <xsl:when test="self::caution">caution</xsl:when>
            <xsl:when test="self::important">important</xsl:when>
          </xsl:choose>
        </xsl:attribute>
    <xsl:if test="title"><h1><xsl:apply-templates select="title"/></h1></xsl:if>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </div>
</xsl:template>

<xsl:template match="blockquote | epigraph">
  <blockquote>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role"/>
    <xsl:if test="self::epigraph">
      <xsl:attribute name="data-type">epigraph</xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="node()[not(self::attribution)]"/>
    <xsl:if test="attribution">
      <xsl:apply-templates select="attribution"/>
    </xsl:if>
  </blockquote>
</xsl:template>

<xsl:template match="attribution">
  <p>
  <xsl:attribute name="data-type">attribution</xsl:attribute>
  <xsl:choose>
      <xsl:when test="author">
        <xsl:for-each select="author">
          <xsl:if test="position()=last() and count(../author) > 2">
            <xsl:text>and </xsl:text>
          </xsl:if>
          <xsl:if test="firstname"><xsl:value-of select="firstname"/><xsl:text> </xsl:text></xsl:if>
          <xsl:if test="othername"><xsl:value-of select="othername"/><xsl:text> </xsl:text></xsl:if>
          <xsl:if test="surname"><xsl:value-of select="surname"/></xsl:if>
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
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </p>
</xsl:template>

<xsl:template match="title">
  <xsl:apply-templates/>
</xsl:template>

<!-- Equations -->
  <!-- Inline Equations -->
  <xsl:template match="inlineequation">
    <xsl:choose>
      <!-- Latex -->
      <!-- To Do: Test inline latex equations -->
      <xsl:when test="mathphrase[@role='tex']">
        <span>
          <xsl:attribute name="data-type">latex</xsl:attribute>
          <xsl:copy-of select="mathphrase/text() | mathphrase/*"/>
        </span>
      </xsl:when>
      <!-- MathML -->
      <xsl:when test="mml:*">
        <math xmlns="http://www.w3.org/1998/Math/MathML">
          <xsl:copy-of select="mml:math/node()"/>
        </math>
      </xsl:when>
      <!-- Regular mathphrase equation -->
      <!-- To Do: Test regular inline equations -->
      <xsl:when test="mathphrase[not(@role='tex')]">
        <math>
          <xsl:copy-of select="node()"/>
        </math>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- Block Equations -->
  <xsl:template match="equation | informalequation">
    <div>
      <xsl:call-template name="process-id"/>
      <xsl:call-template name="process-role"/>
      <xsl:attribute name="data-type">equation</xsl:attribute>
      <xsl:if test="title"><h5><xsl:apply-templates select="title"/></h5></xsl:if>
      <xsl:choose>
        <!-- Latex -->
        <xsl:when test="mathphrase[@role='tex']">
          <p>
            <xsl:attribute name="data-type">tex</xsl:attribute>
            <xsl:copy-of select="mathphrase/text() | mathphrase/*"/>
          </p>
        </xsl:when>
        <!-- MathML -->
        <xsl:when test="mml:*">
            <math xmlns="http://www.w3.org/1998/Math/MathML">
              <xsl:copy-of select="mml:math/node()"/>
            </math>
        </xsl:when>
        <!-- Regular mathphrase equation -->
        <xsl:when test="mathphrase[not(@role='tex')]">
            <p>
              <xsl:apply-templates select="mathphrase"/>
            </p>
        </xsl:when>
      </xsl:choose>
    </div>
</xsl:template>

<xsl:template match="mathphrase">
  <xsl:apply-templates/>
</xsl:template>

<!-- Glossary -->
<xsl:template match="glossary">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role"/>
    <xsl:attribute name="data-type">glossary</xsl:attribute>
    <h1><xsl:apply-templates select="title"/></h1>
    <!-- targets all children that are not 1) a title and 2) a glossentry. All other glossary related nodes should be embedded in glossentry, so no need to specify all the glossary tags to ignore here. This previously only targetted child::para. -->
    <xsl:apply-templates select="child::node()[not(self::glossentry) and not(self::title)]"/>
    <!-- Per AW, all glossary items should be wrapped in one single <dl> -->
    <!-- See https://github.com/oreillymedia/docbook2htmlbook/issues/20 -->
    <dl>
      <xsl:attribute name="data-type">glossary</xsl:attribute>
      <xsl:call-template name="process-role"/>
      <!--This only selects nodes related to glossaries. This previously grabbed anything that wasn't a para or title. --> 
      <xsl:apply-templates select="node()[self::glossdiv or self::glossentry or self::glossterm]"/>
    </dl>
  </section>
</xsl:template>
<xsl:template match="glossdiv">
    <xsl:apply-templates select="node()/*"/>
</xsl:template>
    <!-- Removing h2 per AW -->
<xsl:template match="glossentry">
    <xsl:call-template name="process-role"/>
    <xsl:apply-templates/>
</xsl:template>
<xsl:template match="glossterm">
  <dt>
    <xsl:attribute name="data-type">glossterm</xsl:attribute>
    <xsl:if test="parent::glossentry/@id">
      <xsl:attribute name="id"><xsl:value-of select="parent::glossentry/@id"/></xsl:attribute>
    </xsl:if>
    <xsl:call-template name="process-role"/>
    <dfn><xsl:apply-templates/></dfn>
  </dt>
</xsl:template>
<xsl:template match="glossdef">
  <dd>
    <xsl:attribute name="data-type">glossdef</xsl:attribute>
    <xsl:call-template name="process-role"/>
    <xsl:apply-templates/>
  </dd>
</xsl:template>

<!-- Template for calculating continuation on <orderedlist> (see #58) -->
<!-- Adapted from DocBook stylesheets common.xsl -->
<xsl:template name="output-orderedlist-starting-number">
  <xsl:param name="list"/>
  <xsl:choose>
    <xsl:when test="not($list/@continuation = 'continues')">
      <xsl:choose>
        <xsl:when test="$list/@startingnumber">
          <xsl:value-of select="$list/@startingnumber"/>
        </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="prevlist" select="$list/preceding::orderedlist[1]"/>
      <xsl:choose>
        <xsl:when test="count($prevlist) = 0">2</xsl:when>
        <xsl:otherwise>
          <xsl:variable name="prevlength" select="count($prevlist/listitem)"/>
          <xsl:variable name="prevstart">
            <xsl:call-template name="output-orderedlist-starting-number">
              <xsl:with-param name="list" select="$prevlist"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="$prevstart + $prevlength"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
  
<!-- Lists -->
<xsl:template match="itemizedlist">
  <ul>
    <xsl:call-template name="process-role"/>
    <xsl:for-each select="listitem">
      <li>
        <xsl:call-template name="process-role"/>
        <xsl:apply-templates/>
      </li>
    </xsl:for-each>
  </ul>
</xsl:template>
<xsl:template match="orderedlist">
  <ol>
    <xsl:if test="@numeration='loweralpha'">
      <xsl:attribute name="type">a</xsl:attribute>
    </xsl:if>
    <xsl:if test="@numeration='lowerroman'">
      <xsl:attribute name="type">i</xsl:attribute>
    </xsl:if>
    <xsl:if test="@numeration='upperalpha'">
      <xsl:attribute name="type">A</xsl:attribute>
    </xsl:if>
    <xsl:if test="@numeration='upperroman'">
      <xsl:attribute name="type">I</xsl:attribute>
    </xsl:if>
    <xsl:if test="@continuation">
      <xsl:if test="@continuation='continues'">
        <xsl:attribute name="start">
          <xsl:call-template name="output-orderedlist-starting-number">
            <xsl:with-param name="list" select="."/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:if>
      <!-- If @continuation='restarts', do nothing -->
    </xsl:if>
    <xsl:call-template name="process-role"/>
    <xsl:for-each select="listitem">
      <li><xsl:apply-templates/></li>
    </xsl:for-each>
  </ol>
</xsl:template>
<xsl:template match="variablelist">
  <dl>
    <xsl:call-template name="process-role"/>
    <xsl:for-each select="varlistentry">
        <xsl:choose>
          <xsl:when test="@role!=''">
            <xsl:for-each select="term[1]">
              <dt>
                <xsl:attribute name="class"><xsl:value-of select="parent::varlistentry/@role"/></xsl:attribute>
                <xsl:apply-templates/>
              </dt>
            </xsl:for-each>
            <xsl:for-each select="term[position()>1]">
              <dt><xsl:apply-templates/></dt>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="term">
              <dt><xsl:apply-templates/></dt>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      <xsl:for-each select="listitem">
        <dd>
          <xsl:call-template name="process-role"/>
          <xsl:apply-templates/>
        </dd>
      </xsl:for-each>
    </xsl:for-each>
  </dl>
</xsl:template>
<xsl:template match="simplelist">
  <ul class="simplelist">
    <xsl:call-template name="process-role"/>
    <xsl:for-each select="member">
      <li><xsl:apply-templates/></li>
    </xsl:for-each>
  </ul>
</xsl:template>

<!-- Procedures and steps/substeps-->
<xsl:template match="procedure">
<div>
<xsl:call-template name="process-role"/>
  <p>
    <xsl:attribute name="class">procedure-title</xsl:attribute>
    <xsl:apply-templates select="title"/>
  </p>
  <ol>
    <xsl:call-template name="process-id"/>
      <xsl:choose>
      <xsl:when test="@role">
         <xsl:attribute name="class"><xsl:value-of select="concat('procedure ', @role)"/></xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
         <xsl:attribute name="class">procedure</xsl:attribute>
      </xsl:otherwise>
      </xsl:choose>
    <xsl:for-each select="step">
      <li>
        <xsl:call-template name="process-id"/>
      <xsl:choose>
      <xsl:when test="@role">
         <xsl:attribute name="class"><xsl:value-of select="concat('step ', @role)"/></xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
         <xsl:attribute name="class">step</xsl:attribute>
      </xsl:otherwise>
      </xsl:choose>
        <xsl:apply-templates/>
      </li>
    </xsl:for-each>
  </ol>
</div>
</xsl:template>

<xsl:template match="substeps">
  <ol>
    <xsl:call-template name="process-id"/>
      <xsl:choose>
      <xsl:when test="@role">
         <xsl:attribute name="class"><xsl:value-of select="concat('substeps ', @role)"/></xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
         <xsl:attribute name="class">substeps</xsl:attribute>
      </xsl:otherwise>
      </xsl:choose>
    <xsl:for-each select="step">
      <li>
        <xsl:call-template name="process-id"/>
      <xsl:choose>
      <xsl:when test="@role">
         <xsl:attribute name="class"><xsl:value-of select="concat('step ', @role)"/></xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
         <xsl:attribute name="class">step</xsl:attribute>
      </xsl:otherwise>
      </xsl:choose>
        <xsl:apply-templates/>
      </li>
    </xsl:for-each>
  </ol>
</xsl:template>

<!-- Code Blocks -->
<xsl:template match="programlisting | screen">
  <pre>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role"/>
    <xsl:attribute name="data-type">programlisting</xsl:attribute>
    <xsl:if test="@language"><xsl:attribute name="data-code-language"><xsl:value-of select="@language"/></xsl:attribute></xsl:if>
    <xsl:apply-templates/>
  </pre>
</xsl:template>
<xsl:template match="literallayout">
  <pre>
  <xsl:call-template name="process-id"/>
  <xsl:call-template name="process-role"/>
  <xsl:attribute name="class">literallayout</xsl:attribute>
  <xsl:apply-templates/>
</pre>
</xsl:template>
<xsl:template match="example">
  <div>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role"/>
    <xsl:attribute name="data-type">example</xsl:attribute>
    <h5><xsl:apply-templates select="title"/></h5>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </div>
</xsl:template>

<!-- Figures -->
<xsl:template match="figure">
  <figure>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role"/>
    <xsl:if test="@float">
      <xsl:attribute name="style">float: <xsl:value-of select="@float"/></xsl:attribute>
    </xsl:if>
    <img>
      <xsl:call-template name="fig-attrs"/>
    </img>
    <xsl:if test="title"><figcaption><xsl:apply-templates select="title"/></figcaption></xsl:if>
  </figure>
</xsl:template>

<xsl:template match="informalfigure">
  <figure>
  <xsl:call-template name="process-role"/>
  <xsl:if test="@float">
      <xsl:attribute name="style">float: <xsl:value-of select="@float"/></xsl:attribute>
  </xsl:if>
  <!-- informalfigures should always receive class="informal" when in htmlbook -->
  <xsl:choose>
    <!-- if informalfigure already has a role attribute -->
    <xsl:when test="@role">
      <!-- add "informal" to class attribute value -->
      <xsl:attribute name="class"><xsl:value-of select="@role"/> informal</xsl:attribute>
    </xsl:when>
    <!-- otherwise, add class attribute with value "informal" -->
    <xsl:otherwise>
      <xsl:attribute name="class">informal</xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
    <img>
      <xsl:call-template name="fig-attrs"/>
    </img>
    <figcaption/>
  </figure>
</xsl:template>

<xsl:template name="fig-attrs">
  <xsl:attribute name="src">
    <xsl:choose>
      <xsl:when test="mediaobject/imageobject[@role='web']">
        <xsl:value-of select="mediaobject/imageobject[@role='web']/imagedata/@fileref"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="mediaobject/imageobject/imagedata/@fileref"/></xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:if test="mediaobject/imageobject/imagedata[@width]">
    <xsl:attribute name="width"><xsl:value-of select="mediaobject/imageobject/imagedata/@width"/></xsl:attribute>
  </xsl:if>
  <xsl:if test="mediaobject/imageobject/imagedata[@height]">
    <xsl:attribute name="height"><xsl:value-of select="mediaobject/imageobject/imagedata/@height"/></xsl:attribute>
  </xsl:if>
  <xsl:if test="mediaobject/textobject">
    <!-- Use value-of for alt text, so no child elements are output in alt attribute -->
    <xsl:attribute name="alt"><xsl:value-of select="mediaobject/textobject/phrase"/></xsl:attribute>
  </xsl:if>
</xsl:template>

  <xsl:template match="inlinemediaobject">
    <img>
      <xsl:attribute name="src">
      <xsl:choose>
        <xsl:when test="imageobject[@role='web']">
          <xsl:value-of select="imageobject[@role='web']/imagedata/@fileref"/>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="imageobject/imagedata/@fileref"/></xsl:otherwise>
      </xsl:choose>
      </xsl:attribute>
      <xsl:if test="textobject">
        <xsl:attribute name="alt"><xsl:value-of select="textobject/phrase"/></xsl:attribute>
      </xsl:if>
    </img>
  </xsl:template>
  
<!-- Handle CALS or HTML Tables -->
<xsl:template match="table | informaltable | entrytbl">
  <xsl:variable name="table-markup">
  <table>
    <xsl:call-template name="process-id"/>
    <xsl:choose>
    <xsl:when test="@tabstyle='landscape' or @orient='land'">
      <xsl:choose>
      <xsl:when test="@role">
         <xsl:attribute name="class"><xsl:value-of select="concat('landscape ', @role)"/></xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
         <xsl:attribute name="class">landscape</xsl:attribute>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="@role">
      <xsl:attribute name="class"><xsl:value-of select="@role"/></xsl:attribute>
    </xsl:when>
    <xsl:otherwise/>
    </xsl:choose>
    <xsl:if test="title">
      <caption>
      <xsl:if test="title/@role">
        <xsl:attribute name="class"><xsl:value-of select="title/@role"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="title"/></caption>
    </xsl:if>
    <xsl:if test="caption">
      <xsl:if test="caption/@role">
        <xsl:attribute name="class"><xsl:value-of select="caption/@role"/></xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="caption"/>
    </xsl:if>
    <xsl:apply-templates select="node()[not(self::title|self::caption)]"/> 
  </table>
  </xsl:variable>
  <xsl:choose>
  <xsl:when test="@tabstyle='landscape' or @orient='land'">
  <div class="landscape">
    <xsl:copy-of select="$table-markup"/>
  </div>
  </xsl:when>
  <xsl:when test="self::entrytbl">
  <td>
    <xsl:copy-of select="$table-markup"/>
  </td>
  </xsl:when>
  <xsl:otherwise>
    <xsl:copy-of select="$table-markup"/>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="tgroup">
  <xsl:apply-templates/>
</xsl:template>
<xsl:template match="caption">
<caption>
  <xsl:apply-templates select="node()"/>
</caption>
</xsl:template>
<xsl:template match="thead">
<thead>
  <xsl:call-template name="process-role"/>
  <xsl:apply-templates/>
</thead>
</xsl:template>
  <xsl:template match="tbody">
<tbody>
  <xsl:call-template name="process-role"/>
  <xsl:apply-templates/>
</tbody>
</xsl:template>
  <xsl:template match="row">
<tr>
  <xsl:call-template name="process-role"/>
  <xsl:apply-templates/>
</tr>
</xsl:template>
<xsl:template match="tr">
<tr>
  <xsl:call-template name="process-role"/>
  <xsl:apply-templates select="node()"/>
</tr>
</xsl:template>
<xsl:template match="th">
<th>
  <xsl:call-template name="process-role"/>
  <xsl:if test="@width!=''">
    <xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
  </xsl:if>
  <!-- No p elements inside table heads -->
  <xsl:choose>
    <xsl:when test="para">
      <xsl:apply-templates select="para/node()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="node()"/>
    </xsl:otherwise>
  </xsl:choose>
</th>
</xsl:template>
<xsl:template match="td">
<td>
  <xsl:call-template name="process-role"/>
  <xsl:apply-templates select="node()"/>
</td>
</xsl:template>
<xsl:template match="entry">
<xsl:choose>
  <xsl:when test="ancestor::thead">
    <!-- No p elements inside table heads -->
    <th>
      <xsl:call-template name="process-id"/>
      <xsl:call-template name="process-role"/>
      <xsl:if test="@width!=''">
        <xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="para">
          <xsl:apply-templates select="para/node()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </th>
  </xsl:when>
  <xsl:otherwise>
    <td>
      <xsl:call-template name="process-id"/>
      <xsl:call-template name="process-role"/>
      <xsl:apply-templates/>
    </td>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>
<!-- Column widths should be handled in the CSS -->
<xsl:template match="colspec"/>
<xsl:template match="col"/>

<!-- Suppress the index -->
<xsl:template match="index">
  <section>
    <xsl:attribute name="data-type">index</xsl:attribute>
    <xsl:apply-templates/>
  </section>
</xsl:template>
  
<!-- Indexterms -->
<xsl:template match="indexterm">
  <a>
    <xsl:attribute name="data-type">indexterm</xsl:attribute>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role"/>
    <xsl:if test="primary">
      <xsl:attribute name="data-primary"><xsl:value-of select="primary"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="secondary">
      <xsl:attribute name="data-secondary"><xsl:value-of select="secondary"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="tertiary">
      <xsl:attribute name="data-tertiary"><xsl:value-of select="tertiary"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="primary/@sortas">
      <xsl:attribute name="data-primary-sortas"><xsl:value-of select="primary/@sortas"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="seondary/@sortas">
      <xsl:attribute name="data-secondary-sortas"><xsl:value-of select="secondary/@sortas"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="tertiary/@sortas">
      <xsl:attribute name="data-tertiary-sortas"><xsl:value-of select="tertiary/@sortas"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="see">
      <xsl:attribute name="data-see"><xsl:value-of select="see"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="seealso">
      <xsl:attribute name="data-seealso"><xsl:value-of select="seealso"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="@class='endofrange'">
      <xsl:attribute name="data-startref"><xsl:value-of select="@startref"/></xsl:attribute>
    </xsl:if>
  <xsl:text>&#xa0;</xsl:text>
  </a>
</xsl:template>
  
<!-- Remarks -->
<xsl:template match="remark">
  <xsl:comment><xsl:apply-templates/></xsl:comment>
</xsl:template>
  
<!-- Code Callouts -->
<xsl:template match="co">
  <a>
    <xsl:attribute name="class">co</xsl:attribute>
    <xsl:if test="@id">
      <xsl:attribute name="id">co_<xsl:value-of select="@id"/></xsl:attribute>
      <xsl:attribute name="href">#callout_<xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>
   <img>
    <xsl:attribute name="src">callouts/<xsl:apply-templates select="." mode="callout.number"/>.png</xsl:attribute>
    <xsl:attribute name="alt"><xsl:apply-templates select="." mode="callout.number"/></xsl:attribute>
   </img>
  </a>
</xsl:template>

<xsl:template match="co" mode="callout.number">
    <xsl:number level="any" from="programlisting | screen" format="1"/>
</xsl:template>

<xsl:template match="calloutlist">
    <dl>
      <xsl:attribute name="class">calloutlist</xsl:attribute>
      <xsl:call-template name="process-role">
        <xsl:with-param name="append-class"><xsl:value-of select="local-name(.)"/><xsl:text>&#x20;</xsl:text></xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates/>
    </dl>
</xsl:template>

<!-- Need to call utility templates to properly increment callout numbers when there are multiple strings in @arearefs -->
<xsl:template match="callout">
  <xsl:variable name="total-num-of-arearef-strings">
    <xsl:variable name="num-of-spaces">
      <xsl:for-each select="preceding-sibling::*">
        <xsl:value-of select="string-length(@arearefs) - string-length(translate(@arearefs,' ',''))"/>
        <xsl:if test="position() != last()"><xsl:text>+</xsl:text></xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:call-template name="sum-numbers">
      <xsl:with-param name="text" select="$num-of-spaces"/>
    </xsl:call-template>
  </xsl:variable>
  <dt>
  <xsl:call-template name="tokenize-arearefs">
    <xsl:with-param name="current" select="concat(@arearefs, ' ')"/>
    <xsl:with-param name="callout-incremented"><xsl:value-of select="1 + count(preceding-sibling::callout) + $total-num-of-arearef-strings"/></xsl:with-param>
  </xsl:call-template>
  </dt>
  <dd>
    <xsl:apply-templates/>
  </dd>
</xsl:template>

<xsl:template name="sum-numbers">
  <xsl:param name="text" select="."/>
  <xsl:param name="sum" select="0"/>
  <xsl:param name="delim" select="'+'"/>
  <xsl:choose>
    <xsl:when test="not(string-length($text) >0)">
      <xsl:value-of select="$sum"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="newlist" select="concat($text,$delim)"/>
      <xsl:variable name="head" select="substring-before($newlist, $delim)"/>
      <xsl:call-template name="sum-numbers">
        <xsl:with-param name="text" select="substring-after($text, $delim)"/>
        <xsl:with-param name="sum" select="$sum+$head"/>
        <xsl:with-param name="delim" select="$delim"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

<xsl:template name="tokenize-arearefs">
<xsl:param name="current"/>
<xsl:param name="callout-incremented"/>
  <xsl:if test="string-length($current)">
    <xsl:variable name="currentref" select="substring-before($current, ' ')"/>
    <a>
      <xsl:attribute name="class">co</xsl:attribute>
        <xsl:attribute name="id">callout_<xsl:value-of select="$currentref"/></xsl:attribute>
        <xsl:attribute name="href">#co_<xsl:value-of select="$currentref"/></xsl:attribute>
       <img>
          <xsl:attribute name="src">callouts/<xsl:value-of select="$callout-incremented"/>.png</xsl:attribute>
          <xsl:attribute name="alt"><xsl:value-of select="$callout-incremented"/></xsl:attribute>
       </img>
    </a>
    <xsl:call-template name="tokenize-arearefs">
      <xsl:with-param name="current" select="substring-after($current, ' ')"/>
      <xsl:with-param name="callout-incremented" select="$callout-incremented +1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- 
*******************************
INLINES
******************************* 
-->

<xsl:template match="literal | code">
  <code>
    <!--propegate role attributes on code/literal tags to class attributes if they exist ; RT # 187250-->
    <xsl:if test="@role">
    <xsl:attribute name="class"><xsl:value-of select="@role"/></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </code>
</xsl:template>

<xsl:template match="package"><code><xsl:apply-templates/></code></xsl:template>
<xsl:template match="methodname"><code><xsl:apply-templates/></code></xsl:template>
<xsl:template match="emphasis"><em><xsl:apply-templates/></em></xsl:template>
<xsl:template match="emphasis[@role='strong']"><strong><xsl:apply-templates/></strong></xsl:template>
<xsl:template match="emphasis[@role='bold']"><strong><xsl:apply-templates/></strong></xsl:template>
<xsl:template match="quote"><q><xsl:apply-templates/></q></xsl:template>
<xsl:template match="superscript"><sup><xsl:apply-templates/></sup></xsl:template>
<xsl:template match="subscript"><sub><xsl:apply-templates/></sub></xsl:template>
<xsl:template match="replaceable"><em><code><xsl:apply-templates/></code></em></xsl:template>
<xsl:template match="userinput"><strong><code><xsl:apply-templates/></code></strong></xsl:template>
<xsl:template match="firstterm"><span class="firstterm"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="filename"><em class="filename"><xsl:apply-templates/></em></xsl:template>
<xsl:template match="citetitle"><em><xsl:apply-templates/></em></xsl:template>
<xsl:template match="citation"><em><xsl:apply-templates/></em></xsl:template>
<xsl:template match="acronym"><span class="acronym"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="command"><span class="command"><em><xsl:apply-templates/></em></span></xsl:template>
<xsl:template match="application"><span class="application"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="computeroutput"><code class="computeroutput"><xsl:apply-templates/></code></xsl:template>
<xsl:template match="parameter"><code class="parameter"><xsl:apply-templates/></code></xsl:template>
<xsl:template match="function"><code class="function"><xsl:apply-templates/></code></xsl:template>
<xsl:template match="classname"><code class="classname"><xsl:apply-templates/></code></xsl:template>
<xsl:template match="varname"><code class="varname"><xsl:apply-templates/></code></xsl:template>
<xsl:template match="option"><code class="option"><xsl:apply-templates/></code></xsl:template>
<xsl:template match="prompt"><code class="prompt"><xsl:apply-templates/></code></xsl:template>
<xsl:template match="systemitem"><code class="systemitem"><xsl:apply-templates/></code></xsl:template>
<xsl:template match="uri"><code class="uri"><xsl:apply-templates/></code></xsl:template>
<xsl:template match="interfacename"><span class="interfacename"><em><xsl:apply-templates/></em></span></xsl:template>
<xsl:template match="optional"><span class="optional"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="processing-instruction()"><xsl:copy/></xsl:template>
<xsl:template match="processing-instruction('lb')"><br /></xsl:template>

<!-- Handling for custom <phrase> roles -->
<xsl:template match="phrase[@role]">
  <xsl:choose>
    <xsl:when test="@role='strong'">
      <strong><xsl:apply-templates/></strong>
    </xsl:when>
    <xsl:when test="@role='bold'">
      <strong><xsl:apply-templates/></strong>
    </xsl:when>
    <xsl:when test="@role='bolditalic'">
      <em><strong><xsl:apply-templates/></strong></em>
    </xsl:when>
    <xsl:when test="@role='keep-together'">
      <span class="keep-together"><xsl:apply-templates/></span>
    </xsl:when>
    <xsl:when test="@role='unicode'">
      <span class="unicode"><xsl:apply-templates/></span>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="classname"><xsl:value-of select="@role"/></xsl:variable>
      <span>
        <xsl:attribute name="class"><xsl:value-of select="$classname"/></xsl:attribute>
        <xsl:apply-templates/>
      </span>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="phrase[not(@role)]">
  <span>
    <xsl:call-template name="process-id"/>
    <xsl:apply-templates/>
  </span>
</xsl:template>
  
<!-- TO DO: Output should insert the proper arrow character between elements. Need example books to test. -->
<!-- <xsl:template match="menuchoice"><xsl:apply-templates/></xsl:template> -->
<xsl:template match="guimenu"><span class="guimenu"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="guisubmenu"><span class="guisubmenu"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="guibutton"><span class="guibutton"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="guilabel"><span class="guilabel"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="guiicon"><span class="guiicon"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="guimenuitem"><span class="guimenuitem"><xsl:apply-templates/></span></xsl:template>
  
<!-- TO DO: Output should insert the proper plus character between elements. Need example books to test.-->
<xsl:template match="keycombo">
  <xsl:variable name="action" select="@action"/>
  <xsl:variable name="joinchar">
    <xsl:choose>
      <xsl:when test="$action='seq'"><xsl:text> </xsl:text></xsl:when>
      <xsl:when test="$action='simul'">+</xsl:when>
      <xsl:when test="$action='press'">-</xsl:when>
      <xsl:when test="$action='click'">-</xsl:when>
      <xsl:when test="$action='double-click'">-</xsl:when>
      <xsl:when test="$action='other'"/>
      <xsl:otherwise>+</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:for-each select="keycap">
    <xsl:if test="position()&gt;1"><xsl:value-of select="$joinchar"/></xsl:if>
    <span class="keycap"><xsl:apply-templates select="."/></span>
  </xsl:for-each>
</xsl:template>

<xsl:template match="keycap[parent::keycombo]">
      <xsl:apply-templates/>
</xsl:template>

<xsl:template match="keycap[not(parent::keycombo)]">
      <span class="keycap"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="symbol">
  <span>
    <xsl:attribute name="class">symbol</xsl:attribute>
    <xsl:attribute name="data-remap"><xsl:value-of select="@remap"/></xsl:attribute>
    <xsl:apply-templates/>
  </span>
</xsl:template>
  
<xsl:template match="emphasis[@role='strikethrough'] | phrase[@role='strikethrough']">
  <span class="strikethrough"><xsl:apply-templates/></span>
</xsl:template>
  
<!-- TO DO: Check lineannotation after spec solidified -->
<xsl:template match="lineannotation">
  <code>
    <xsl:attribute name="class">lineannotation</xsl:attribute>
    <xsl:apply-templates/>
  </code>
</xsl:template>

<!-- Added 'select' to apply-templates below to fix https://github.com/oreillymedia/docbook2htmlbook/issues/26 -->
<xsl:template match="ulink">
  <a href="{@url}">
    <xsl:call-template name="process-role"/>
    <xsl:choose>
      <xsl:when test="node()">
          <xsl:choose>
            <xsl:when test="@role='orm:hideurl:ital'"><em class="hyperlink"><xsl:apply-templates/></em></xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
      </xsl:when>
      <xsl:otherwise><em class="hyperlink"><xsl:value-of select="@url"/></em></xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

<xsl:template match="email">
  <a>
    <xsl:attribute name="class">email</xsl:attribute>
    <xsl:call-template name="process-role"/>
    <xsl:attribute name="href">mailto:<xsl:value-of select="text()"/></xsl:attribute>
      <em><xsl:apply-templates/></em>
  </a>
</xsl:template>
  
<xsl:template match="xref | link">
  <xsl:variable name="label">
    <xsl:choose>
      <!-- TO DO: Test part rendering -->
      <xsl:when test="id(@linkend)[self::part]"><xsl:text>Part </xsl:text></xsl:when>
      <xsl:when test="id(@linkend)[self::chapter]"><xsl:text>Chapter </xsl:text></xsl:when>
      <xsl:when test="id(@linkend)[self::preface]"><xsl:text>Preface</xsl:text></xsl:when>
      <xsl:when test="id(@linkend)[self::appendix]"><xsl:text>Appendix </xsl:text></xsl:when>
      <xsl:when test="id(@linkend)[self::figure]"><xsl:text>Figure </xsl:text></xsl:when>
      <xsl:when test="id(@linkend)[self::table]"><xsl:text>Table </xsl:text></xsl:when>
      <xsl:when test="id(@linkend)[self::example]"><xsl:text>Example </xsl:text></xsl:when>
      <!-- Note: Outputs only the sidebar title; Can't output page number as well (as in csspdf) -->
      <xsl:when test="id(@linkend)[self::sidebar]"><xsl:text> "</xsl:text><xsl:value-of select="id(@linkend)/title"/><xsl:text>"</xsl:text></xsl:when>
      <xsl:when test="id(@linkend)[self::sidebar | self::sect1 | self::sect2 | self::sect3 | self::sect4 | self::sect5 | self::sect6 | self::section]">
        <xsl:text> "</xsl:text><xsl:value-of select="id(@linkend)/title"/><xsl:text>"</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>???</xsl:text></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="count">
    <xsl:for-each select="id(@linkend)">
      <xsl:if test="self::part"><xsl:number count="part" level="any" format="1"/></xsl:if>
      <xsl:if test="self::chapter"><xsl:number count="chapter" level="any" format="1"/></xsl:if>
      <xsl:if test="self::appendix"><xsl:number count="appendix" level="any" format="A"/></xsl:if>
      <xsl:if test="self::figure">
        <xsl:choose>
          <xsl:when test="ancestor::chapter">
            <xsl:number count="chapter" level="any" format="1"/>
            <xsl:text>-</xsl:text>
            <xsl:number count="figure" level="any" from="chapter" format="1"/>
          </xsl:when>
          <xsl:when test="ancestor::preface">
            <xsl:text>P-</xsl:text>
            <xsl:number count="figure" level="any" from="preface" format="1"/>
          </xsl:when>
          <xsl:when test="ancestor::appendix">
            <xsl:number count="appendix" level="any" format="A"/>
            <xsl:text>-</xsl:text>
            <xsl:number count="figure" level="any" from="appendix" format="1"/>
          </xsl:when>
          <xsl:otherwise><xsl:text>???</xsl:text></xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="self::table">
        <xsl:choose>
          <xsl:when test="ancestor::chapter">
            <xsl:number count="chapter" level="any" format="1"/>
            <xsl:text>-</xsl:text>
            <xsl:number count="table" level="any" from="chapter" format="1"/>
          </xsl:when>
          <xsl:when test="ancestor::preface">
            <xsl:text>P-</xsl:text>
            <xsl:number count="table" level="any" from="preface" format="1"/>
          </xsl:when>
          <xsl:when test="ancestor::appendix">
            <xsl:number count="appendix" level="any" format="A"/>
            <xsl:text>-</xsl:text>
            <xsl:number count="table" level="any" from="appendix" format="1"/>
          </xsl:when>
          <xsl:otherwise><xsl:text>???</xsl:text></xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:if test="self::example">
        <xsl:choose>
          <xsl:when test="ancestor::chapter">
            <xsl:number count="chapter" level="any" format="1"/>
            <xsl:text>-</xsl:text>
            <xsl:number count="example" level="any" from="chapter" format="1"/>
          </xsl:when>
          <xsl:when test="ancestor::preface">
            <xsl:text>P-</xsl:text>
            <xsl:number count="example" level="any" from="preface" format="1"/>
          </xsl:when>
          <xsl:when test="ancestor::appendix">
            <xsl:number count="appendix" level="any" format="A"/>
            <xsl:text>-</xsl:text>
            <xsl:number count="example" level="any" from="appendix" format="1"/>
          </xsl:when>
          <xsl:otherwise><xsl:text>???</xsl:text></xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <a href="#{@linkend}">
    <xsl:choose>
      <xsl:when test="self::xref">
        <xsl:attribute name="data-type">xref</xsl:attribute>
      </xsl:when>
      <xsl:when test="self::link">
        <xsl:attribute name="data-type">link</xsl:attribute>
      </xsl:when>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="$xref_label = 'true'">
        <xsl:value-of select="$label"/><xsl:value-of select="$count"/>
      </xsl:when>
      <xsl:when test="self::link">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
    <xsl:if test="@xrefstyle">
      <xsl:attribute name="data-xrefstyle"><xsl:apply-templates select="@xrefstyle"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="self::xref">
      <xsl:text>#</xsl:text><xsl:value-of select="@linkend"/>
    </xsl:if>
  </a>
</xsl:template>
  

<!-- 
*******************************
NAMED TEMPLATES
******************************* 
-->
  
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
  </xsl:if>
</xsl:template>

<xsl:template name="titlepage">
  <section>
    <xsl:attribute name="data-type">titlepage</xsl:attribute>
    <h1><xsl:apply-templates select="title"/></h1>
    <xsl:choose>
      <xsl:when test="bookinfo/edition = 1"/>
      <xsl:when test="bookinfo/edition = 2">
        <p>
        <xsl:attribute name="class">edition</xsl:attribute>
        <xsl:text>Second Edition</xsl:text>
        </p>
      </xsl:when>
      <xsl:when test="bookinfo/edition = 3">
        <p>
        <xsl:attribute name="class">edition</xsl:attribute>
        <xsl:text>Third Edition</xsl:text>
        </p>
      </xsl:when>
      <xsl:when test="bookinfo/edition = 4">
        <p>
        <xsl:attribute name="class">edition</xsl:attribute>
        <xsl:text>Fourth Edition</xsl:text>
        </p>
      </xsl:when>
      <xsl:when test="bookinfo/edition = 5">
        <p>
        <xsl:attribute name="class">edition</xsl:attribute>
        <xsl:text>Fifth Edition</xsl:text>
        </p>
      </xsl:when>
      <xsl:when test="bookinfo/edition = 6">
        <p>
        <xsl:attribute name="class">edition</xsl:attribute>
        <xsl:text>Sixth Edition</xsl:text>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <!-- TODO: Add support for more editions -->
        <p>
        <xsl:attribute name="class">edition</xsl:attribute>
        <xsl:value-of select="bookinfo/edition"/><xsl:text>th Edition</xsl:text>
        </p>
      </xsl:otherwise>
    </xsl:choose>
    <p>
      <xsl:attribute name="class">author</xsl:attribute>
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
  
<!-- 
*******************************
TO DO
******************************* 
-->
  
<!-- Drop everything from the bookinfo except the author bios -->
<xsl:template match="bookinfo">
  <section data-type="colophon" class="abouttheauthor">
    <xsl:choose>
      <xsl:when test="count(descendant::authorblurb) > 1">
        <h1>About the Authors</h1>
      </xsl:when>
      <xsl:otherwise>
        <h1>About the Author</h1>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="descendant::authorblurb/*"/>
  </section>
</xsl:template>


<!-- REFERENCE SECTION HANDLING IS STILL UNDER CONSTRUCTION -->
<xsl:template match="refentry">
  <div>
    <xsl:attribute name="class"><xsl:value-of select="local-name(.)"/></xsl:attribute>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role">
       <xsl:with-param name="append-class"><xsl:value-of select="local-name(.)"/><xsl:text>&#x20;</xsl:text></xsl:with-param>
    </xsl:call-template>
    <header>
      <xsl:apply-templates select="refmeta"/>
      <xsl:apply-templates select="refnamediv"/>
    </header>
    <xsl:apply-templates select="*[not(self::refmeta or self::refnamediv)]"/>
  </div>
</xsl:template>

<xsl:template match="refnamediv">
  <!-- must contain refname, and may contain refpurpose and refclass-->
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refname|refpurpose">
  <xsl:if test="text()!=''">
  <p>
    <xsl:attribute name="class">
      <xsl:value-of select="local-name(.)"/>
      <!-- can be given a header positional param -->
      <xsl:variable name="position">
        <xsl:if test="$refname!='' and local-name(.)='refname'"><xsl:value-of select="$refname"/></xsl:if>
        <xsl:if test="$refpurpose!='' and local-name(.)='refpurpose'"><xsl:value-of select="$refpurpose"/></xsl:if>
      </xsl:variable>
      <xsl:if test="$position!=''">
        <xsl:text>&#x20;</xsl:text><xsl:value-of select="$position"/>
      </xsl:if>
    </xsl:attribute>
    <xsl:apply-templates/>
  </p>
</xsl:if>
</xsl:template>

<xsl:template match="refclass">
  <xsl:if test="text()!=''">
  <p>
    <xsl:attribute name="class">
      <xsl:choose>
        <xsl:when test="@class">
          <xsl:value-of select="replace(@class, 'orm:', '')"/>
        </xsl:when>
        <xsl:when test="@role">
          <xsl:value-of select="replace(@role, 'orm:', '')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="local-name(.)"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- TODO: Can be given a header positional param (have to accommodate different classes) -->
<!--       <xsl:variable name="position">
        <xsl:if test="$refclass!='' and local-name(.)='refclass'"><xsl:value-of select="$refclass"/></xsl:if>
      </xsl:variable>
      <xsl:if test="$position!=''">
        <xsl:text>&#x20;</xsl:text><xsl:value-of select="$position"/>
      </xsl:if> -->
    </xsl:attribute>
    <xsl:apply-templates/>
  </p>
</xsl:if>
</xsl:template>

<xsl:template match="refmeta">
    <!-- only preserve refmeta/refentrytitle if it's different from refnamediv/refname-->
    <xsl:if test="refentrytitle/text()!=following-sibling::refnamediv/refname/text()">
      <p class="refentrytitle"><xsl:value-of select="refentrytitle"/></p>
    </xsl:if>
    <!-- preserve other child elements -->
    <xsl:if test="refmiscinfo">
      <xsl:for-each select="refmiscinfo">
       <p>
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="@class">
              <xsl:value-of select="replace(@class, 'orm:', '')"/>
            </xsl:when>
            <xsl:when test="@role">
              <xsl:value-of select="replace(@role, 'orm:', '')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="local-name(.)"/>
            </xsl:otherwise>
          </xsl:choose>
          <!-- TODO: Can be given a header positional param (have to accommodate different classes) -->
<!--           <xsl:variable name="position">
            <xsl:if test="$refmiscinfo!=''"><xsl:value-of select="$refmiscinfo"/></xsl:if>
          </xsl:variable>
          <xsl:if test="$position!=''">
            <xsl:text>&#x20;</xsl:text><xsl:value-of select="$position"/>
          </xsl:if> -->
        </xsl:attribute>
        <xsl:value-of select="."/>
      </p>
      </xsl:for-each>
    </xsl:if>
</xsl:template>

<xsl:template match="refsynopsisdiv|refsect1|refsect2|refsect3|refsection">
  <div>
    <xsl:attribute name="class"><xsl:value-of select="local-name(.)"/></xsl:attribute>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role">
       <xsl:with-param name="append-class"><xsl:value-of select="local-name(.)"/><xsl:text>&#x20;</xsl:text></xsl:with-param>
    </xsl:call-template>
    <xsl:if test="title">
      <h6>
        <xsl:if test="title/@role!=''">
        <xsl:attribute name="class"><xsl:value-of select="title/@role"/></xsl:attribute>
        </xsl:if>
        <xsl:apply-templates select="title"/>
      </h6>
    </xsl:if>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </div>
</xsl:template>
    
<xsl:template match="synopsis">
  <pre>
    <xsl:attribute name="class"><xsl:value-of select="local-name(.)"/></xsl:attribute>
    <xsl:call-template name="process-id"/>
    <xsl:call-template name="process-role">
       <xsl:with-param name="append-class"><xsl:value-of select="local-name(.)"/><xsl:text>&#x20;</xsl:text></xsl:with-param>
    </xsl:call-template>
    <xsl:apply-templates/>
  </pre>
</xsl:template>

<!-- 
*******************************
UTILITY TEMPLATES
******************************* 
-->

<xsl:template name="process-id">
  <xsl:if test="@id">
    <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
  </xsl:if>
</xsl:template>

<xsl:template name="process-role">
<xsl:param name="append-class"/>
<xsl:if test="@role!=''">
  <xsl:attribute name="class"><xsl:value-of select="$append-class"/><xsl:value-of select="@role"/>
  </xsl:attribute>
</xsl:if>
</xsl:template>

<!--For use with asciidoctor-htmlbook-->
<xsl:template match="root">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
