<xsl:stylesheet version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:html="http://www.w3.org/1999/xhtml"
        xmlns:xf="http://www.w3.org/2002/xforms"
        xmlns:bf="http://betterform.sourceforge.net/xforms"
        xmlns:transform="http://betterform.de/transform"
        xmlns:bfn="http://www.betterform.de/XSL/Functions"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        exclude-result-prefixes="xf bf transform">

    <xsl:output method="xhtml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
    <xsl:namespace-alias stylesheet-prefix="transform" result-prefix="xsl"/>

    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <transform:stylesheet version="2.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:vra="http://www.vraweb.org/vracore4.htm">
            <transform:output method="xhtml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>

            <transform:template match="/vra:work |/vra:image">
                <transform:variable name="side" select="if(local-name(.)='work') then 'leftPanel' else 'rightPanel'"/>
                <transform:variable name="script" select="if(local-name(.)='work') then 'showWorkXML();' else 'showImageXML();'"/>
                <div class="columntitle">
                    <transform:value-of select="$title"/>
                    <transform:text>&#160;</transform:text>
                    <button type="button" class="showXML" id="{{$recordType}}-showXML" title="show raw XML" onclick="{{$script}}">XML</button>
                    <button type="button" class="historyButton" id="{{$recordType}}-versions-button" subject="{{$recordId}}" title="Versions history for {{$recordType}} {{$recordId}}">H</button>
                </div>

                <div id="{{$side}}" class="sidePanel ui-layout-content">
                    <!--<xsl:for-each select="//set[@visible='true']">-->
                    <xsl:for-each select="//set | //separator">

                        <xsl:choose>
                            <xsl:when test="local-name() = 'set'">
                                <xsl:variable name="setName" select="bfn:upperCase(substring-after(@name,':'))"/>
                                <xsl:message>setname: <xsl:value-of select="$setName"/></xsl:message>

                                <transform:call-template name="titlePane">
                                    <transform:with-param name="vraSetName" select="'{$setName}'"/>
                                    <transform:with-param name="vraSetNode" select="{@name}"/>
                                    <transform:with-param name="visible" select="'{@visible}'"/>
                                </transform:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <a href="#" id="{{$side}}Separator" onclick="toggleSetVisibility('{{$side}}');"><div class="separator">more VRA Sets...</div></a>
                            </xsl:otherwise>
                        </xsl:choose>

                    </xsl:for-each>
                </div>
            </transform:template>

        </transform:stylesheet>

    </xsl:template>

    <xsl:function name="bfn:upperCase" as="xsd:string?">
        <xsl:param name="arg" as="xsd:string?"/>
        <xsl:sequence select="concat(upper-case(substring($arg,1,1)),substring($arg,2))"/>
    </xsl:function>

</xsl:stylesheet>