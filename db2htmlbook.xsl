<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xsi:schemaLocation="http://www.w3.org/1999/xhtml ../schema/htmlbook.xsd"
  xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="xml" indent="yes"/>
  
<!-- 
*******************************
PARAMETERS:
* xref_label outputs text labels of all xrefs
******************************* 
-->
<xsl:param name="xref_label">false</xsl:param>
<xsl:param name="chunk-output">false</xsl:param>

<!-- 
*******************************
DEVELOPMENT:
Output warning and all elements not handled by this stylesheet yet.
******************************* 
-->

<xsl:template match="*">
  <xsl:message terminate="no">WARNING: Unmatched element: <xsl:value-of select="name()"/></xsl:message>
  <xsl:apply-templates/>
</xsl:template>
  
  
<!-- 
*******************************
BLOCKS
******************************* 
-->
  
<xsl:template match="book">
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
    <xsl:call-template name="titlepage"/>
    <xsl:call-template name="copyrightpage"/>
    <!-- TO DO: Add parametrized TOC for optional output -->
    <xsl:choose>
      <xsl:when test="$chunk-output != 'false'">
        <xsl:apply-templates select="*[not(self::title)] | processing-instruction()" mode="chunk"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="*[not(self::title)] | processing-instruction()"/>
      </xsl:otherwise>
    </xsl:choose>
  </body>
</html>
</xsl:template>
  
<!-- BEGIN FILE CHUNKING -->
<xsl:template match="chapter|appendix|preface|colophon|dedication|glossary|bibliography" mode="chunk">
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
</xsl:template>
  <!-- *** In Process. Not outputting parts correctly yet *** -->
<xsl:template match="part" mode="chunk">
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
</xsl:template>
<!-- END FILE CHUNKING -->
  
<xsl:template match="part">
  <div>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">part</xsl:attribute>
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
      <xsl:when test="self::colophon"><xsl:attribute name="data-type">colophon</xsl:attribute></xsl:when>
      <xsl:when test="self::dedication"><xsl:attribute name="data-type">dedication</xsl:attribute></xsl:when>
    </xsl:choose>
    <h1>
      <xsl:apply-templates select="title"/>
    </h1>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </section>
</xsl:template>

<!-- TO DO: Check prefacinfo byline output after spec solidified -->
<xsl:template match="prefaceinfo | chapterinfo">
  <div>
    <xsl:attribute name="data-class">byline</xsl:attribute>
    <p>
      <xsl:attribute name="data-class">author</xsl:attribute>
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
          <xsl:attribute name="data-class">affiliation</xsl:attribute>
          <xsl:apply-templates select="jobtitle"/>
        </p>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="affiliation">
      <xsl:for-each select="affiliation">
        <p>
          <xsl:attribute name="data-class">affiliation</xsl:attribute>
          <xsl:apply-templates select="jobtitle"/>
        </p>
      </xsl:for-each>
    </xsl:if>
  </div>
</xsl:template>
<xsl:template match="jobtitle">
  <xsl:apply-templates/>
</xsl:template>
  
<xsl:template match="footnote">
  <span>
    <xsl:attribute name="data-type">footnote</xsl:attribute>
    <xsl:call-template name="process-id"/>
    <xsl:for-each select="para">
      <xsl:if test="not(position() = 1 )"><br/></xsl:if>
      <xsl:apply-templates select="text() | *"/>
    </xsl:for-each>
  </span>
</xsl:template> 
  
<!-- TO DO: Check footnoteref after spec solidified -->
<xsl:template match="footnoteref">
  <a href="{@linkend}">
    <xsl:attribute name="data-type">footnoteref</xsl:attribute>
  </a>
</xsl:template>
  
<xsl:template match="para | simpara">
  <!-- Begin error handling for block elements nested in para/simpara that will cause invalid HTMLBook output -->
  <xsl:if test="count(screen) > 0">
    <xsl:message terminate="no">WARNING: Nested block element in para or simpara: screen</xsl:message>
  </xsl:if>
  <xsl:if test="count(figure) > 0">
    <xsl:message terminate="no">WARNING: Nested block element in para or simpara: figure</xsl:message>
  </xsl:if>
  <xsl:if test="count(informalfigure) > 0">
    <xsl:message terminate="no">WARNING: Nested block element in para or simpara: informalfigure</xsl:message>
  </xsl:if>
  <xsl:if test="count(programlisting) > 0">
    <xsl:message terminate="no">WARNING: Nested block element in para or simpara: programlisting</xsl:message>
  </xsl:if>
  <xsl:if test="count(orderedlist) > 0">
    <xsl:message terminate="no">WARNING: Nested block element in para or simpara: orderedlist</xsl:message>
  </xsl:if>
  <xsl:if test="count(itemizedlist) > 0">
    <xsl:message terminate="no">WARNING: Nested block element in para or simpara: itemizedlist</xsl:message>
  </xsl:if>
  <xsl:if test="count(variablelist) > 0">
    <xsl:message terminate="no">WARNING: Nested block element in para or simpara: variablelist</xsl:message>
  </xsl:if>
  <xsl:if test="count(table) > 0">
    <xsl:message terminate="no">WARNING: Nested block element in para or simpara: table</xsl:message>
  </xsl:if>
  <xsl:if test="count(informaltable) > 0">
    <xsl:message terminate="no">WARNING: Nested block element in para or simpara: informaltable</xsl:message>
  </xsl:if>
  <xsl:if test="count(example) > 0">
    <xsl:message terminate="no">WARNING: Nested block element in para or simpara: example</xsl:message>
  </xsl:if>
  <xsl:if test="count(equation) > 0">
    <xsl:message terminate="no">WARNING: Nested block element in para or simpara: equation</xsl:message>
  </xsl:if>
  <xsl:if test="count(informalequation) > 0">
    <xsl:message terminate="no">WARNING: Nested block element in para or simpara: informalequation</xsl:message>
  </xsl:if>
  <xsl:if test="count(note) > 0">
    <xsl:message terminate="no">WARNING: Nested block element in para or simpara: note</xsl:message>
  </xsl:if>
  <xsl:if test="count(warning) > 0">
    <xsl:message terminate="no">WARNING: Nested block element in para or simpara: warning</xsl:message>
  </xsl:if>
  <xsl:if test="count(tip) > 0">
    <xsl:message terminate="no">WARNING: Nested block element in para or simpara: tip</xsl:message>
  </xsl:if>
  <xsl:if test="count(caution) > 0">
    <xsl:message terminate="no">WARNING: Nested block element in para or simpara: caution</xsl:message>
  </xsl:if>
  <!-- End error handling for nested block elements -->
  <p>
    <xsl:call-template name="process-id"/>
    <xsl:apply-templates/>
  </p>
</xsl:template>
  
  <!-- TO DO: Check formalpara heading level after spec solidified -->
<xsl:template match="formalpara">
  <div>
    <xsl:attribute name="data-type">formalpara</xsl:attribute>
    <h5>
      <xsl:apply-templates select="title"/>
    </h5> 
      <xsl:call-template name="process-id"/>
      <xsl:apply-templates select="node()[not(self::title)]"/>
  </div>
</xsl:template>
  
<!-- For lone block elements nested inside a para with no other elements or text, ditch the para and output only the nested element. -->
<xsl:template match="
  para[figure[position()=1] and not(text()[normalize-space()])] |
  para[informalfigure[position()=1] and not(text()[normalize-space()])] |
  para[itemizedlist[position()=1] and not(text()[normalize-space()])] |
  para[variablelist[position()=1] and not(text()[normalize-space()])] |
  para[orderedlist[position()=1] and not(text()[normalize-space()])] |
  para[table[position()=1] and not(text()[normalize-space()])] |
  para[informaltable[position()=1] and not(text()[normalize-space()])] |
  para[example[position()=1] and not(text()[normalize-space()])] |
  para[equation[position()=1] and not(text()[normalize-space()])] |
  para[informalequation[position()=1] and not(text()[normalize-space()])] |
  para[note[position()=1] and not(text()[normalize-space()])] |
  para[warning[position()=1] and not(text()[normalize-space()])] |
  para[tip[position()=1] and not(text()[normalize-space()])] |
  para[caution[position()=1] and not(text()[normalize-space()])] |
  para[programlisting[position()=1] and not(text()[normalize-space()])] |
  simpara[figure[position()=1] and not(text()[normalize-space()])] |
  simpara[informalfigure[position()=1] and not(text()[normalize-space()])] |
  simpara[itemizedlist[position()=1] and not(text()[normalize-space()])] |
  simpara[variablelist[position()=1] and not(text()[normalize-space()])] |
  simpara[orderedlist[position()=1] and not(text()[normalize-space()])] |
  simpara[table[position()=1] and not(text()[normalize-space()])] |
  simpara[informaltable[position()=1] and not(text()[normalize-space()])] |
  simpara[example[position()=1] and not(text()[normalize-space()])] |
  simpara[equation[position()=1] and not(text()[normalize-space()])] |
  simpara[informalequation[position()=1] and not(text()[normalize-space()])] |
  simpara[note[position()=1] and not(text()[normalize-space()])] |
  simpara[warning[position()=1] and not(text()[normalize-space()])] |
  simpara[tip[position()=1] and not(text()[normalize-space()])] |
  simpara[caution[position()=1] and not(text()[normalize-space()])] |
  simpara[programlisting[position()=1] and not(text()[normalize-space()])]">
  <xsl:apply-templates select="node()[not(para)] | node()[not(simpara)]"/>
</xsl:template>
  
<xsl:template match="sect1">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">sect1</xsl:attribute>
    <h1><xsl:apply-templates select="title"/></h1>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </section>
</xsl:template>
  
<xsl:template match="sect2">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">sect2</xsl:attribute>
    <h2><xsl:apply-templates select="title"/></h2>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </section>
</xsl:template>

<xsl:template match="sect3">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">sect3</xsl:attribute>
    <h3><xsl:apply-templates select="title"/></h3>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </section>
</xsl:template>

<xsl:template match="sect4">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">sect4</xsl:attribute>
    <h4><xsl:apply-templates select="title"/></h4>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </section>
</xsl:template>

<xsl:template match="sect5">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">sect5</xsl:attribute>
    <h5><xsl:apply-templates select="title"/></h5>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </section>
</xsl:template>
  
<xsl:template match="sidebar">
  <aside>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">sidebar</xsl:attribute>
    <h5><xsl:apply-templates select="title"/></h5>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </aside>
</xsl:template>

<xsl:template match="note | tip | warning | caution | important">
  <div>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">
      <xsl:choose>
        <xsl:when test="self::note">note</xsl:when>
        <xsl:when test="self::tip">tip</xsl:when>
        <xsl:when test="self::warning">warning</xsl:when>
        <xsl:when test="self::caution">caution</xsl:when>
        <xsl:when test="self::important">important</xsl:when>
      </xsl:choose>
    </xsl:attribute>
    <xsl:if test="@role='safarienabled'">
      <xsl:attribute name="class">safarienabled</xsl:attribute>
    </xsl:if>
    <xsl:if test="title"><h1><xsl:apply-templates select="title"/></h1></xsl:if>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </div>
</xsl:template>

<xsl:template match="blockquote | epigraph | quote">
  <blockquote>
    <xsl:call-template name="process-id"/>
    <xsl:if test="self::epigraph">
      <xsl:attribute name="data-type">epigraph</xsl:attribute>
    </xsl:if>
    <xsl:if test="attribution">
      <xsl:apply-templates select="attribution"/>
    </xsl:if>
    <xsl:apply-templates select="node()[not(self::attribution)]"/>
  </blockquote>
</xsl:template>
<xsl:template match="attribution">
  <p>
    <xsl:attribute name="data-type">attribution</xsl:attribute>
    <xsl:apply-templates/>
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
      <xsl:choose>
        <!-- Latex -->
        <xsl:when test="mathphrase[@role='tex']">
          <xsl:call-template name="process-id"/>
          <xsl:if test="title"><h5><xsl:apply-templates select="title"/></h5></xsl:if>
          <p>
            <xsl:attribute name="data-type">latex</xsl:attribute>
            <xsl:copy-of select="mathphrase/text() | mathphrase/*"/>
          </p>
        </xsl:when>
        <!-- MathML -->
        <xsl:when test="mml:*">
          <div>
            <xsl:call-template name="process-id"/>
            <xsl:attribute name="data-type">equation</xsl:attribute>
            <xsl:if test="title"><h5><xsl:apply-templates select="title"/></h5></xsl:if>
            <math xmlns="http://www.w3.org/1998/Math/MathML">
              <xsl:copy-of select="mml:math/node()"/>
            </math>
          </div>
        </xsl:when>
        <!-- Regular mathphrase equation -->
        <xsl:when test="mathphrase[not(@role='tex')]">
          <div>
            <xsl:call-template name="process-id"/>
            <xsl:attribute name="data-type">equation</xsl:attribute>
            <xsl:if test="title"><h5><xsl:apply-templates select="title"/></h5></xsl:if>
            <p>
              <xsl:apply-templates select="mathphrase"/>
            </p>
          </div>
        </xsl:when>
      </xsl:choose>
</xsl:template>
<xsl:template match="mathphrase">
  <xsl:apply-templates/>
</xsl:template>

<!-- Glossary -->
<xsl:template match="glossary">
  <section>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">glossary</xsl:attribute>
    <h1><xsl:apply-templates select="title"/></h1>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </section>
</xsl:template>
<xsl:template match="glossdiv">
  <div>
    <xsl:attribute name="data-type">glossdiv</xsl:attribute>
    <!-- TO DO: Check glossdiv heading level after spec solidified -->
    <h2><xsl:apply-templates select="title"/></h2>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </div>
</xsl:template>
<xsl:template match="glossentry">
  <dl>
    <xsl:attribute name="data-type">glossary</xsl:attribute>
    <xsl:apply-templates/>
  </dl>
</xsl:template>
<xsl:template match="glossterm">
  <dt>
    <xsl:attribute name="data-type">glossterm</xsl:attribute>
    <dfn><xsl:apply-templates/></dfn>
  </dt>
</xsl:template>
<xsl:template match="glossdef">
  <dd>
    <xsl:attribute name="data-type">glossdef</xsl:attribute>
    <xsl:apply-templates/>
  </dd>
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
<xsl:template match="simplelist">
  <ul data-type="simplelist">
    <xsl:for-each select="member">
      <li><xsl:apply-templates/></li>
    </xsl:for-each>
  </ul>
</xsl:template>

<!-- Code Blocks -->
<xsl:template match="programlisting | screen">
  <pre>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">programlisting</xsl:attribute>
    <xsl:if test="@language"><xsl:attribute name="data-code-language"><xsl:value-of select="@language"/></xsl:attribute></xsl:if>
    <xsl:apply-templates/>
  </pre>
</xsl:template>
<xsl:template match="literallayout">
  <pre>
  <xsl:call-template name="process-id"/>
  <xsl:attribute name="data-type">literallayout</xsl:attribute>
  <xsl:apply-templates/>
</pre>
</xsl:template>
<xsl:template match="example">
  <div>
    <xsl:call-template name="process-id"/>
    <xsl:attribute name="data-type">example</xsl:attribute>
    <h5><xsl:apply-templates select="title"/></h5>
    <xsl:apply-templates select="node()[not(self::title)]"/>
  </div>
</xsl:template>
  
<!-- Figures -->
<xsl:template match="figure | informalfigure">
  <figure>
    <xsl:call-template name="process-id"/>
    <xsl:if test="@float">
      <xsl:attribute name="float"><xsl:value-of select="@float"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="title"><figcaption><xsl:apply-templates select="title"/></figcaption></xsl:if>
    <!-- TO DO: Once handling is added to schema to allow figure without a figcaption, remove xsl:if below this comment. (It outputs an empty figcaption element for figures that don't have a title, to trick the schema. -->
    <xsl:if test="not(title)"><figcaption/></xsl:if>
    <img>
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
    </img>
  </figure>
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
    </img>
  </xsl:template>
  
<!-- Tables -->
<xsl:template match="table | informaltable">
  <table>
    <xsl:call-template name="process-id"/>
    <xsl:if test="@tabstyle='landscape' or @orient='land'">
      <xsl:attribute name="class">landscape</xsl:attribute>
    </xsl:if>
    <xsl:if test="title">
      <caption><xsl:apply-templates select="title"/></caption>
    </xsl:if>
    <xsl:apply-templates select="node()[not(self::title)]"/> 
  </table>
</xsl:template>
<xsl:template match="tgroup">
  <xsl:apply-templates/>
</xsl:template>
<xsl:template match="thead">
<thead>
  <xsl:apply-templates/>
</thead>
</xsl:template>
  <xsl:template match="tbody">
<tbody>
  <xsl:apply-templates/>
</tbody>
</xsl:template>
  <xsl:template match="row">
<tr><xsl:apply-templates/></tr>
</xsl:template>
  <xsl:template match="entry">
<xsl:choose>
  <xsl:when test="ancestor::thead">
    <!-- No p elements inside table heads -->
    <th><xsl:apply-templates select="para/node()"/></th>
  </xsl:when>
  <xsl:otherwise>
    <td><xsl:apply-templates/></td>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>
<!-- Column widths should be handled in the CSS -->
<xsl:template match="colspec"/>
  
<!-- Suppress the index -->
<xsl:template match="index"/>
  
<!-- Indexterms -->
<xsl:template match="indexterm">
  <a>
    <xsl:attribute name="data-type">indexterm</xsl:attribute>
    <xsl:call-template name="process-id"/>
    <xsl:if test="primary">
      <xsl:attribute name="data-primary"><xsl:value-of select="primary"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="secondary">
      <xsl:attribute name="data-secondary"><xsl:value-of select="secondary"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="tertiary">
      <xsl:attribute name="data-tertiary"><xsl:value-of select="secondary"/></xsl:attribute>
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
    <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
    <xsl:attribute name="href"><xsl:value-of select="@linkends"/></xsl:attribute>
    <!-- Insert callout number (image or glyph)? -->
  </a>
</xsl:template>
<xsl:template match="calloutlist">
  <div>
    <xsl:attribute name="class">calloutlist</xsl:attribute>
    <dl>
      <xsl:for-each select="callout">
        <dt>
          <a>
            <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="@arearefs"/></xsl:attribute>
          </a>
          <!-- Insert callout number (image or glyph)? -->
        </dt>
        <dd>
          <xsl:apply-templates/>
        </dd>
      </xsl:for-each>
    </dl>
  </div>
</xsl:template>
  
  
<!-- 
*******************************
INLINES
******************************* 
-->

<xsl:template match="literal | code"><code><xsl:apply-templates/></code></xsl:template>
<xsl:template match="emphasis"><em><xsl:apply-templates/></em></xsl:template>
<xsl:template match="emphasis[@role='strong']"><strong><xsl:apply-templates/></strong></xsl:template>
<xsl:template match="phrase[@role='strong']"><strong><xsl:apply-templates/></strong></xsl:template>
<xsl:template match="phrase[@role='bolditalic']"><em><strong><xsl:apply-templates/></strong></em></xsl:template>
<xsl:template match="superscript"><sup><xsl:apply-templates/></sup></xsl:template>
<xsl:template match="subscript"><sub><xsl:apply-templates/></sub></xsl:template>
<xsl:template match="replaceable"><em><code><xsl:apply-templates/></code></em></xsl:template>
<xsl:template match="userinput"><strong><code><xsl:apply-templates/></code></strong></xsl:template>
<xsl:template match="firstterm"><span data-type="firstterm"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="email"><em data-type="email"><xsl:apply-templates/></em></xsl:template>
<xsl:template match="filename"><code data-type="filename"><xsl:apply-templates/></code></xsl:template>
<xsl:template match="citetitle"><em><xsl:apply-templates/></em></xsl:template>
<xsl:template match="acronym"><span data-type="acronym"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="command"><span data-type="command"><em><xsl:apply-templates/></em></span></xsl:template>
<xsl:template match="application"><span data-type="application"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="computeroutput"><span data-type="computeroutput"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="parameter"><span data-type="parameter"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="function"><code data-type="function"><xsl:apply-templates/></code></xsl:template>
<xsl:template match="varname"><code data-type="varname"><xsl:apply-templates/></code></xsl:template>
<xsl:template match="option"><code data-type="option"><xsl:apply-templates/></code></xsl:template>
<xsl:template match="prompt"><code data-type="prompt"><xsl:apply-templates/></code></xsl:template>
<xsl:template match="uri"><code data-type="uri"><xsl:apply-templates/></code></xsl:template>
<xsl:template match="interfacename"><span data-type="interfacename"><em><xsl:apply-templates/></em></span></xsl:template>
<xsl:template match="optional"><span data-type="optional"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="phrase[@role='keep-together']"><span class="keep-together"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="phrase[@role='unicode']"><span class="unicode"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="processing-instruction()"><xsl:copy/></xsl:template>
<xsl:template match="processing-instruction('lb')"><br /></xsl:template>
  
<!-- TO DO: Output should insert the proper arrow character between elements. 
<xsl:template match="menuchoice"><xsl:apply-templates/></xsl:template>
<xsl:template match="guimenu"><span data-type="guimenu"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="guisubmenu"><span data-type="guisubmenu"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="guibutton"><span data-type="guibutton"><xsl:apply-templates/></span></xsl:template>
<xsl:template match="guilabel"><span data-type="guilabel"><xsl:apply-templates/></span></xsl:template> -->
  
<!-- TO DO: Output should insert the proper plus character between elements.
<xsl:template match="keycombo"><xsl:apply-templates/></xsl:template>
<xsl:template match="keycap"><span data-type="keycap"><xsl:apply-templates/></span></xsl:template> -->

<xsl:template match="symbol">
  <span>
    <xsl:attribute name="data-type">symbol</xsl:attribute>
    <xsl:attribute name="data-remap"><xsl:value-of select="@remap"/></xsl:attribute>
    <xsl:apply-templates/>
  </span>
</xsl:template>
  
<xsl:template match="emphasis[@role='strikethrough'] | phrase[@role='strikethrough']">
  <span data-type="strikethrough"><xsl:apply-templates/></span>
</xsl:template>
  
<!-- TO DO: Check lineannotation after spec solidified -->
<xsl:template match="lineannotation">
  <code>
    <xsl:attribute name="data-type">lineannotation</xsl:attribute>
    <xsl:apply-templates/>
  </code>
</xsl:template>
  
<xsl:template match="ulink">
  <a href="{@url}">
    <xsl:apply-templates/>
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

<xsl:template name="process-id">
  <xsl:if test="@id">
    <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
  </xsl:if>
</xsl:template>
  
<!-- 
*******************************
TO DO
******************************* 
-->
  
<xsl:template match="bookinfo"/>  
<xsl:template match="refentry"/>
  
</xsl:stylesheet>