<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://www.w3.org/1999/xhtml">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
	</xsl:template>
	<xsl:template match="ul[preceding-sibling::h3[1]='Question Summary']">
    <ul>
      <xsl:for-each select="parent::div/h3[not(.='Question Summary')]">
        <xsl:call-template name="doHeading"/>
      </xsl:for-each>
    </ul>
	</xsl:template>
	<xsl:template name="doHeading">
    <li>
      <a href="#{preceding-sibling::a[1]/@name}">
        <xsl:value-of select="."/>
      </a>
      <ul>
        <xsl:variable name="precedingHeadings" select="count(preceding-sibling::h3)+1"/>
        <xsl:for-each select="following-sibling::h4[count(preceding-sibling::h3)=$precedingHeadings]">
          <li>
            <a href="#{preceding-sibling::a[1]/@name}">
              <xsl:value-of select="."/>
            </a>
          </li>
        </xsl:for-each>
      </ul>
    </li>
	</xsl:template>
</xsl:stylesheet>
