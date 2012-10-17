<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:vra="http://www.vraweb.org/vracore4.htm" version="2.0" exclude-result-prefixes="vra">
    <xsl:output method="xhtml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
    <xsl:template match="vra:sourceSet" priority="40">
        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>Name</th>
                    <th class="detail-cell">(type)</th>
                    <th class="detail-cell">refid</th>
                    <th class="detail-cell">(type)</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="vra:source">
                    <tr>
                        <td>
                            <xsl:value-of select="vra:name"/>
                        </td>
                        <td class="detail-cell">
                            <xsl:value-of select="vra:name/@type"/>
                        </td>
                        <td class="detail-cell">
                            <xsl:value-of select="vra:refid"/>
                        </td>
                        <td class="detail-cell">
                            <xsl:value-of select="vra:refid/@type"/>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </xsl:template>
</xsl:stylesheet>
