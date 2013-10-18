<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" 
              encoding="UTF-8"
              doctype-public="-//OASIS//DTD DocBook XML V4.5//EN"
              doctype-system="http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd"/>
  <xsl:preserve-space elements="programlisting screen literallayout"/>
  <xsl:template  match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

<!-- Unwrap block elements from paras -->
  <xsl:template match="para[blockquote]">
    <xsl:for-each-group select="*|node()" group-starting-with="blockquote">
      <xsl:choose>
        <xsl:when test="current-group()[1]/self::blockquote">
          <xsl:for-each-group select="current-group()" group-ending-with="*[not(blockquote)]">
            <xsl:choose>
              <xsl:when test="current-group()[1]/self::blockquote">
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
  </xsl:template>

  <xsl:template match="para[example]">
    <xsl:for-each-group select="*|node()" group-starting-with="example">
      <xsl:choose>
        <xsl:when test="current-group()[1]/self::example">
          <xsl:for-each-group select="current-group()" group-ending-with="*[not(example)]">
            <xsl:choose>
              <xsl:when test="current-group()[1]/self::example">
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
  </xsl:template>

  <xsl:template match="para[figure]">
    <xsl:for-each-group select="*|node()" group-starting-with="figure">
      <xsl:choose>
        <xsl:when test="current-group()[1]/self::figure">
          <xsl:for-each-group select="current-group()" group-ending-with="*[not(figure)]">
            <xsl:choose>
              <xsl:when test="current-group()[1]/self::figure">
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
  </xsl:template>

    <xsl:template match="para[informalfigure]">
    <xsl:for-each-group select="*|node()" group-starting-with="informalfigure">
      <xsl:choose>
        <xsl:when test="current-group()[1]/self::informalfigure">
          <xsl:for-each-group select="current-group()" group-ending-with="*[not(informalfigure)]">
            <xsl:choose>
              <xsl:when test="current-group()[1]/self::informalfigure">
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
  </xsl:template>

  <xsl:template match="para[informaltable]">
    <xsl:for-each-group select="*|node()" group-starting-with="informaltable">
      <xsl:choose>
        <xsl:when test="current-group()[1]/self::informaltable">
          <xsl:for-each-group select="current-group()" group-ending-with="*[not(informaltable)]">
            <xsl:choose>
              <xsl:when test="current-group()[1]/self::informaltable">
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
  </xsl:template>

  <xsl:template match="para[itemizedlist]">
    <xsl:for-each-group select="*|node()" group-starting-with="itemizedlist">
      <xsl:choose>
        <xsl:when test="current-group()[1]/self::itemizedlist">
          <xsl:for-each-group select="current-group()" group-ending-with="*[not(itemizedlist)]">
            <xsl:choose>
              <xsl:when test="current-group()[1]/self::itemizedlist">
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
  </xsl:template>

  <xsl:template match="para[warning]">
    <xsl:for-each-group select="*|node()" group-starting-with="warning">
      <xsl:choose>
        <xsl:when test="current-group()[1]/self::warning">
          <xsl:for-each-group select="current-group()" group-ending-with="*[not(warning)]">
            <xsl:choose>
              <xsl:when test="current-group()[1]/self::warning">
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
  </xsl:template>
  <xsl:template match="para[tip]">
    <xsl:for-each-group select="*|node()" group-starting-with="tip">
      <xsl:choose>
        <xsl:when test="current-group()[1]/self::tip">
          <xsl:for-each-group select="current-group()" group-ending-with="*[not(tip)]">
            <xsl:choose>
              <xsl:when test="current-group()[1]/self::tip">
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
  </xsl:template>
  <xsl:template match="para[note]">
    <xsl:for-each-group select="*|node()" group-starting-with="note">
      <xsl:choose>
        <xsl:when test="current-group()[1]/self::note">
          <xsl:for-each-group select="current-group()" group-ending-with="*[not(note)]">
            <xsl:choose>
              <xsl:when test="current-group()[1]/self::note">
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
  </xsl:template>

  <xsl:template match="para[orderedlist]">
    <xsl:for-each-group select="*|node()" group-starting-with="orderedlist">
      <xsl:choose>
        <xsl:when test="current-group()[1]/self::orderedlist">
          <xsl:for-each-group select="current-group()" group-ending-with="*[not(orderedlist)]">
            <xsl:choose>
              <xsl:when test="current-group()[1]/self::orderedlist">
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
  </xsl:template>

  <xsl:template match="para[programlisting]">
    <xsl:for-each-group select="*|node()" group-starting-with="programlisting">
      <xsl:choose>
        <xsl:when test="current-group()[1]/self::programlisting">
          <xsl:for-each-group select="current-group()" group-ending-with="*[not(programlisting)]">
            <xsl:choose>
              <xsl:when test="current-group()[1]/self::programlisting">
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
  </xsl:template>

  <xsl:template match="para[screen]">
    <xsl:for-each-group select="*|node()" group-starting-with="screen">
      <xsl:choose>
        <xsl:when test="current-group()[1]/self::screen">
          <xsl:for-each-group select="current-group()" group-ending-with="*[not(screen)]">
            <xsl:choose>
              <xsl:when test="current-group()[1]/self::screen">
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
  </xsl:template>

<xsl:template match="para[simplelist]">
    <xsl:for-each-group select="*|node()" group-starting-with="simplelist">
      <xsl:choose>
        <xsl:when test="current-group()[1]/self::simplelist">
          <xsl:for-each-group select="current-group()" group-ending-with="*[not(simplelist)]">
            <xsl:choose>
              <xsl:when test="current-group()[1]/self::simplelist">
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
  </xsl:template>

  <xsl:template match="para[table]">
    <xsl:for-each-group select="*|node()" group-starting-with="table">
      <xsl:choose>
        <xsl:when test="current-group()[1]/self::table">
          <xsl:for-each-group select="current-group()" group-ending-with="*[not(table)]">
            <xsl:choose>
              <xsl:when test="current-group()[1]/self::table">
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
  </xsl:template>

  <xsl:template match="para[variablelist]">
    <xsl:for-each-group select="*|node()" group-starting-with="variablelist">
      <xsl:choose>
        <xsl:when test="current-group()[1]/self::variablelist">
          <xsl:for-each-group select="current-group()" group-ending-with="*[not(variablelist)]">
            <xsl:choose>
              <xsl:when test="current-group()[1]/self::variablelist">
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
  </xsl:template>

</xsl:stylesheet>
