<?xml version="1.0" encoding="utf-8"?>
<!-- ====================================================================== -->
<!-- Copyright (C) 2013 Dietmar Kuehl http://www.dietmar-kuehl.de           -->
<!--                                                                        -->
<!-- Permission is hereby granted, free of charge, to any person            -->
<!-- obtaining a copy of this software and associated documentation         -->
<!-- files (the "Software"), to deal in the Software without restriction,   -->
<!-- including without limitation the rights to use, copy, modify,          -->
<!-- merge, publish, distribute, sublicense, and/or sell copies of          -->
<!-- the Software, and to permit persons to whom the Software is            -->
<!-- furnished to do so, subject to the following conditions:               -->
<!--                                                                        -->
<!-- The above copyright notice and this permission notice shall be         -->
<!-- included in all copies or substantial portions of the Software.        -->
<!--                                                                        -->
<!-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,        -->
<!-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES        -->
<!-- OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND               -->
<!-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT            -->
<!-- HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,           -->
<!-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING           -->
<!-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR          -->
<!-- OTHER DEALINGS IN THE SOFTWARE.                                        -->
<!-- ====================================================================== -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text"/>
  <!-- ==================================================================== -->
  <xsl:template name="make-value">
    <xsl:param name="value"/>
    <xsl:text>    </xsl:text>
    <xsl:value-of select="$value/@type"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$value/@name"/>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$value/@value"/>
    <xsl:text>};&#xa;</xsl:text>
  </xsl:template>
  <!-- ==================================================================== -->
  <xsl:template name="make-range">
    <xsl:param name="range"/>
    <xsl:text>    std::vector&lt;</xsl:text>
    <xsl:value-of select="$range/@type"/>
    <xsl:text>&gt; </xsl:text>
    <xsl:value-of select="$range/@name"/>
    <xsl:text>{ </xsl:text>
    <xsl:for-each select="$range/element">
      <xsl:if test="position() != 1">
        <xsl:text>, </xsl:text>
      </xsl:if>
      <xsl:value-of select="./@value"/>
    </xsl:for-each>
    <xsl:text> };&#xa;</xsl:text>
  </xsl:template>
  <!-- ==================================================================== -->
  <xsl:template name="find">
    <xsl:call-template name="make-range">
      <xsl:with-param name="range" select="./range[@name = 'input']"/>
    </xsl:call-template>
    <xsl:call-template name="make-value">
      <xsl:with-param name="value" select="./value[@name = 'value']"/>
    </xsl:call-template>
    <xsl:text>    </xsl:text>
    <xsl:text>std::vector&lt;</xsl:text>
    <xsl:value-of select="./range[@name = 'input']/@type"/>
    <xsl:text>&gt;::const_iterator it{</xsl:text>
    <xsl:text>std::find(input.begin(), input.end(), value)</xsl:text>
    <xsl:text>};&#xa;</xsl:text>
    <xsl:text>    bool result{it == input.begin() + </xsl:text>
    <xsl:value-of select="./result/@position"/>
    <xsl:text>};&#xa;</xsl:text>
    <xsl:text>    std::cout &lt;&lt; "</xsl:text>
    <xsl:value-of select="./@name"/>
    <xsl:text>" &lt;&lt; ": " &lt;&lt; </xsl:text>
    <xsl:text>(result? "OK": "failed") &lt;&lt; '\n';&#xa;</xsl:text>
    <xsl:text>    return result? EXIT_SUCCESS: EXIT_FAILURE;&#xa;</xsl:text>
  </xsl:template>
  <!-- ==================================================================== -->
  <xsl:template match="/testcase">
    <xsl:text>#include &lt;algorithm&gt;&#xa;</xsl:text>
    <xsl:text>#include &lt;iostream&gt;&#xa;</xsl:text>
    <xsl:text>#include &lt;vector&gt;&#xa;</xsl:text>
    <xsl:text>#include &lt;cstdlib&gt;&#xa;</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>int main()&#xa;</xsl:text>
    <xsl:text>{&#xa;</xsl:text>
    <xsl:choose>
      <xsl:when test="@algorithm = 'find'">
        <xsl:call-template name="find"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>    std::cout &lt;&lt; </xsl:text>
        <xsl:text>"ERROR: tests for algorithm '</xsl:text>
        <xsl:value-of select="@algorithm"/>
        <xsl:text>' are not supported\n";&#xa;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}&#xa;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
