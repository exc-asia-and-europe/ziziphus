<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:vra="http://www.vraweb.org/vracore4.htm" xmlns:html="http://www.w3.org/1999/xhtml" version="2.0">
    <xsl:output method="xhtml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
    <xsl:preserve-space elements="vra:text"/>
    <xsl:template match="vra:inscriptionSet">
        <xsl:param name="vraTableId"/>
        <div class="simple" id="{$vraTableId}">
            <table class="vraSetView table table-striped">
                <tbody>
                    <xsl:for-each select="vra:inscription">
                        <tr>
                            <td>
                                <xsl:for-each select="vra:text">
                                    <xsl:choose>
                                        <xsl:when test="string-length(string-join(@type,'')) != 0">
                                            <div class=" textType keepWhitespace" data-bf-type="select1" data-bf-bind="vra:text/@type" tabindex="0" title="Type" id="b-d2e714">
                                                <xsl:value-of select="@type"/>
                                            </div>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <div class="nodata keepWhitespace" data-bf-type="select1" data-bf-bind="vra:text/@type" tabindex="0">(Type)</div>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                
                                    <xsl:choose>
                                        <xsl:when test="string-length(string-join(.,'')) != 0">
                                            <div class="textarea keepWhitespace" data-bf-type="textarea" data-bf-bind="vra:text" tabindex="0" title="Text" id="b-d2e707">
                                                <xsl:if xmlns="" test="string-length(.) &gt; 100">
                                                    <xsl:attribute name="data-expand">100%</xsl:attribute>
                                                    <xsl:attribute name="data-collapse">150px</xsl:attribute>
                                                </xsl:if>
                                                <xsl:value-of select="."/>
                                            </div>
                                            <xsl:if xmlns="" test="string-length(.) &gt; 100">
                                                <p class="expand">
                                                    <i class="fa fa-arrow-down"/>Click to Read More<i class="fa fa-arrow-down"/>
                                                </p>
                                                <p class="contract hide">
                                                    <i class="fa fa-arrow-up"/>Click to Hide<i class="fa fa-arrow-up"/>
                                                </p>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <div class="textarea nodata keepWhitespace" data-bf-type="textarea" data-bf-bind="vra:text" tabindex="0">
                                                <xsl:if xmlns="" test="string-length(.) &gt; 100">
                                                    <xsl:attribute name="data-expand">100%</xsl:attribute>
                                                    <xsl:attribute name="data-collapse">150px</xsl:attribute>
                                                </xsl:if>(Text)
                                            </div>
                                            <xsl:if xmlns="" test="string-length(.) &gt; 100">
                                                <p class="expand">
                                                    <i class="fa fa-arrow-down"/>Click to Read More<i class="fa fa-arrow-down"/>
                                                </p>
                                                <p class="contract hide">
                                                    <i class="fa fa-arrow-up"/>Click to Hide<i class="fa fa-arrow-up"/>
                                                </p>
                                            </xsl:if>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </td>
                            <td>
                                <xsl:choose>
                                    <xsl:when test="string-length(string-join(vra:author,'')) != 0">
                                        <div class="Author-autocomplete keepWhitespace" data-bf-type="input" data-bf-bind="vra:author" tabindex="0" title="Author" id="b-d2e665">
                                            <xsl:value-of select="vra:author"/>
                                        </div>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <div class="nodata keepWhitespace" data-bf-type="input" data-bf-bind="vra:author" tabindex="0">(Author)</div>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                            <td>
                                <xsl:choose>
                                    <xsl:when test="string-length(string-join(vra:position,'')) != 0">
                                        <div class="keepWhitespace" data-bf-type="input" data-bf-bind="vra:position" tabindex="0" title="Position" id="b-d2e686">
                                            <xsl:value-of select="vra:position"/>
                                        </div>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <div class="nodata keepWhitespace" data-bf-type="input" data-bf-bind="vra:position" tabindex="0">(Position)</div>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                        </tr>
                    </xsl:for-each>
                </tbody>
            </table>
        </div>
    </xsl:template>
</xsl:stylesheet>