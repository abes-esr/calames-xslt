<xsl:stylesheet xmlns="http://www.loc.gov/MARC21/slim" xmlns:dc="http://purl.org/dc/elements/1.1/"
    
    <!-- attention - cette conversion n'est pas a jour de l'unimarc : encore 210 au lieu de 214 notamment-->
    <!-- xslt récupéré le 10/01/2024 par la fenetre edit de Calames en prod : attention les espaces dans le présent fichier ne sont peut-être pas bon => à tester avant de pouvoir etre publié -->
    
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" exclude-result-prefixes="dc">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:param name="filtre"/>
    <xsl:variable name="rcr" select="/ead/archdesc/did/repository/corpname/@authfilenumber"/>
    <xsl:template match="/">
        <collection xmlns="http://www.loc.gov/MARC21/slim"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
            <xsl:for-each select="$filtre">
                <record>
                    <leader>
                        <xsl:text>     nbm  22     1n 4500					</xsl:text>
                    </leader>
                    <xsl:choose>
                        <xsl:when test="@id">
                            <xsl:element name="controlfield">
                                <xsl:attribute name="tag">001 </xsl:attribute>
                                <xsl:value-of select="normalize-space(@id)"/>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="not(@id)">
                            <xsl:element name="controlfield">
                                <xsl:attribute name="tag">001 </xsl:attribute>
                                <xsl:text>[Absence d'identifiant ou id. de haut niveau]</xsl:text>
                            </xsl:element>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:if test="@id">
                        <xsl:element name="controlfield">
                            <xsl:attribute name="tag">003 </xsl:attribute>
                            <xsl:text>http://www.calames.abes.fr/pub/ms/</xsl:text>
                            <xsl:value-of select="normalize-space(@id)"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:element name="datafield">
                        <xsl:attribute name="ind1">
                            <xsl:text/>
                        </xsl:attribute>
                        <xsl:attribute name="ind2">
                            <xsl:text/>
                        </xsl:attribute>
                        <xsl:attribute name="tag">100 </xsl:attribute>
                        <xsl:element name="subfield">
                            <xsl:attribute name="code">a </xsl:attribute>
                            <xsl:variable name="date_c" select="did/unitdate/@normal"/>
                            <xsl:variable name="date_ancestor1"
                                select="./ancestor::*[self::c or self::archdesc]/child::*[not(self::dsc) and not(self::c)][//unitdate/@normal]//unitdate/@normal"/>
                            <xsl:choose>
                                <xsl:when test="$date_c">
                                    <xsl:call-template name="date100">
                                        <xsl:with-param name="date_chemin" select="$date_c"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="$date_ancestor1">
                                    <xsl:call-template name="date100">
                                        <xsl:with-param name="date_chemin" select="$date_ancestor1"
                                        />
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>        u        									</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:text>k  									</xsl:text>
                            <xsl:text>y0frey									</xsl:text>
                            <xsl:text>50      									</xsl:text>
                            <xsl:choose>
                                <xsl:when
                                    test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Cyrl']">
                                    <xsl:text>ca									</xsl:text>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Jpan']">
                                    <xsl:text>da									</xsl:text>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Hans']">
                                    <xsl:text>ea									</xsl:text>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Arab']">
                                    <xsl:text>fa									</xsl:text>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Grek']">
                                    <xsl:text>ga									</xsl:text>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Hebr']">
                                    <xsl:text>ha									</xsl:text>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Thai']">
                                    <xsl:text>ia									</xsl:text>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Deva']">
                                    <xsl:text>ja									</xsl:text>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Kore']">
                                    <xsl:text>ka									</xsl:text>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Taml']">
                                    <xsl:text>la									</xsl:text>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Geor']">
                                    <xsl:text>ma									</xsl:text>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Armn']">
                                    <xsl:text>mb									</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>ba									</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:element>
                    <xsl:choose>
                        <xsl:when test="did/langmaterial/language/@langcode">
                            <xsl:element name="datafield">
                                <xsl:attribute name="ind1">
                                    <xsl:text>|</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="ind2">
                                    <xsl:text/>
                                </xsl:attribute>
                                <xsl:attribute name="tag">101</xsl:attribute>
                                <xsl:for-each select="did/langmaterial/language/@langcode">
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a</xsl:attribute>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when
                            test="ancestor::*[self::archdesc or self::c]/did/langmaterial/language/@langcode">
                            <xsl:element name="datafield">
                                <xsl:attribute name="ind1">
                                    <xsl:text/>
                                </xsl:attribute>
                                <xsl:attribute name="ind2">
                                    <xsl:text/>
                                </xsl:attribute>
                                <xsl:attribute name="tag">101 </xsl:attribute>
                                <xsl:for-each
                                    select="(ancestor::*[self::c or self::archdesc]/did/langmaterial)[position() = last()]/language">
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:value-of select="normalize-space(@langcode)"/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//genreform[@type = 'type de document'] | ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@type = 'type de document']">
                            <xsl:choose>
                                <xsl:when
                                    test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'image fixe']">
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">181 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>b#																</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">b </xsl:attribute>
                                            <xsl:text>xb2e##																</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">182 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>n																		</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'image fixe']">
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">181 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>b#																				</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">b </xsl:attribute>
                                            <xsl:text>xb2e##																				</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">182 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>n																						</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when
                                    test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'texte imprimé']">
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">181 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>i#																								</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">b </xsl:attribute>
                                            <xsl:text>xxxe##																								</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">182 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>n																										</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'texte imprimé']">
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">181 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>i#																												</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">b </xsl:attribute>
                                            <xsl:text>xxxe##																												</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">182 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>n																														</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when
                                    test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'images animées']">
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">181 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>b#																																</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">b </xsl:attribute>
                                            <xsl:text>xa2e##																																</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">182 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>g																																		</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'images animées']">
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">181 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>b#																																				</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">b </xsl:attribute>
                                            <xsl:text>xa2e##																																				</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">182 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>g																																						</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when
                                    test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'enregistrement sonore']">
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">181 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>g#																																								</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">b </xsl:attribute>
                                            <xsl:text>xxxa##																																								</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">182 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>a																																										</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'enregistrement sonore']">
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">181 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>g#																																												</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">b </xsl:attribute>
                                            <xsl:text>xxxa##																																												</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">182 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>a																																														</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when
                                    test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'objet']">
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">181 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>e#																																																</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">b </xsl:attribute>
                                            <xsl:text>xx3d##																																																</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">182 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>n																																																		</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'objet']">
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">181 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>e#																																																				</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">b </xsl:attribute>
                                            <xsl:text>xx3d##																																																				</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">182 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>n																																																						</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when
                                    test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'ressource électronique']">
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">181 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>i#																																																								</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">b </xsl:attribute>
                                            <xsl:text>xxxe##																																																								</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">182 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>b																																																										</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'ressource électronique']">
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">181 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>i#																																																												</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">b </xsl:attribute>
                                            <xsl:text>xxxe##																																																												</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">182 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>b																																																														</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when
                                    test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'texte manuscrit']">
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">181 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>i#																																																																</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">b </xsl:attribute>
                                            <xsl:text>xxxe##																																																																</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">182 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>n																																																																		</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'texte manuscrit']">
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">181 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>i#																																																																				</xsl:text>
                                        </xsl:element>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">b </xsl:attribute>
                                            <xsl:text>xxxe##																																																																				</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="datafield">
                                        <xsl:attribute name="ind1">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="ind2">
                                            <xsl:text/>
                                        </xsl:attribute>
                                        <xsl:attribute name="tag">182 </xsl:attribute>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>n																																																																						</xsl:text>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="datafield">
                                <xsl:attribute name="ind1">
                                    <xsl:text/>
                                </xsl:attribute>
                                <xsl:attribute name="ind2">
                                    <xsl:text/>
                                </xsl:attribute>
                                <xsl:attribute name="tag">181 </xsl:attribute>
                                <xsl:element name="subfield">
                                    <xsl:attribute name="code">a </xsl:attribute>
                                    <xsl:text>i#																																																																								</xsl:text>
                                </xsl:element>
                                <xsl:element name="subfield">
                                    <xsl:attribute name="code">b </xsl:attribute>
                                    <xsl:text>xxxe##																																																																								</xsl:text>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="datafield">
                                <xsl:attribute name="ind1">
                                    <xsl:text/>
                                </xsl:attribute>
                                <xsl:attribute name="ind2">
                                    <xsl:text/>
                                </xsl:attribute>
                                <xsl:attribute name="tag">182 </xsl:attribute>
                                <xsl:element name="subfield">
                                    <xsl:attribute name="code">a </xsl:attribute>
                                    <xsl:text>n																																																																										</xsl:text>
                                </xsl:element>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="did/unittitle[@type]">
                            <xsl:for-each
                                select="did/unittitle[not(@type)] | did/unittitle[@type = 'traduction']">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text>1																																																																											</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">200 </xsl:attribute>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">6 </xsl:attribute>
                                        <xsl:text>01																																																																												</xsl:text>
                                    </xsl:element>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">7 </xsl:attribute>
                                        <xsl:text>ba																																																																												</xsl:text>
                                    </xsl:element>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </xsl:element>
                                    <xsl:choose>
                                        <xsl:when
                                            test="*[not(self::dsc) and not(self::c)]//genreform[@type = 'type de document'] | ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@type = 'type de document']">
                                            <xsl:choose>
                                                <xsl:when
                                                  test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'image fixe']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Image fixe																																																																													</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'image fixe']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Image fixe																																																																													</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'texte imprimé']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Texte imprimé																																																																													</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'texte imprimé']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Texte imprimé																																																																													</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'images animées']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Images animées																																																																													</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'images animées']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Images animées																																																																													</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'enregistrement sonore']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Enregistrement sonore																																																																													</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'enregistrement sonore']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Enregistrement sonore																																																																													</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'objet']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Objet																																																																													</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'objet']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Objet																																																																													</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'ressource électronique']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Ressource électronique																																																																													</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'ressource électronique']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Ressource électronique																																																																													</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'texte manuscrit']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Texte manuscrit																																																																													</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'texte manuscrit']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Texte manuscrit																																																																													</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">b </xsl:attribute>
                                                <xsl:text>Texte manuscrit																																																																													</xsl:text>
                                            </xsl:element>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when
                                            test="*[not(self::dsc) and not(self::c)]//*[@role = 'producteur' or @role = '070' or @role = '340' or @role = '650' or @role = '330' or @role = '100' or @role = '212' or role = 'fabricant']">
                                            <xsl:for-each
                                                select="*[not(self::dsc) and not(self::c)]//*[@role = 'producteur' or @role = '070' or @role = '340' or @role = '650' or @role = '330' or @role = '100' or @role = '212' or role = 'fabricant']">
                                                <xsl:element name="subfield">
                                                  <xsl:if test="position() = 1">
                                                  <xsl:attribute name="code">f </xsl:attribute>
                                                  <xsl:value-of select="."/>
                                                  </xsl:if>
                                                  <xsl:if test="position() &gt; 1">
                                                  <xsl:attribute name="code">g </xsl:attribute>
                                                  <xsl:value-of select="."/>
                                                  </xsl:if>
                                                </xsl:element>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:call-template name="rechercheancetre">
                                                <xsl:with-param name="ancetre"
                                                  select="ancestor::*[self::archdesc or self::c][*[not(self::dsc) and not(self::c)]//*[@role = '070' or @role = '340' or @role = '650' or @role = '330' or @role = '100' or @role = '212' or role = 'fabricant']][1]"
                                                />
                                            </xsl:call-template>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:for-each
                                select="did/unittitle[@type = 'translittération'] | did/unittitle[@type = 'non-latin originel'] | did/unittitle[@type = 'non-latin alternatif']">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text>1																																																																															</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">200 </xsl:attribute>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">6 </xsl:attribute>
                                        <xsl:text>02																																																																																</xsl:text>
                                    </xsl:element>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">7 </xsl:attribute>
                                        <xsl:choose>
                                            <xsl:when
                                                test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Cyrl']">
                                                <xsl:text>ca																																																																																</xsl:text>
                                            </xsl:when>
                                            <xsl:when
                                                test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Jpan']">
                                                <xsl:text>da																																																																																</xsl:text>
                                            </xsl:when>
                                            <xsl:when
                                                test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Hans']">
                                                <xsl:text>ea																																																																																</xsl:text>
                                            </xsl:when>
                                            <xsl:when
                                                test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Arab']">
                                                <xsl:text>fa																																																																																</xsl:text>
                                            </xsl:when>
                                            <xsl:when
                                                test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Grek']">
                                                <xsl:text>ga																																																																																</xsl:text>
                                            </xsl:when>
                                            <xsl:when
                                                test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Hebr']">
                                                <xsl:text>ha																																																																																</xsl:text>
                                            </xsl:when>
                                            <xsl:when
                                                test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Thai']">
                                                <xsl:text>ia																																																																																</xsl:text>
                                            </xsl:when>
                                            <xsl:when
                                                test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Deva']">
                                                <xsl:text>ja																																																																																</xsl:text>
                                            </xsl:when>
                                            <xsl:when
                                                test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Kore']">
                                                <xsl:text>ka																																																																																</xsl:text>
                                            </xsl:when>
                                            <xsl:when
                                                test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Taml']">
                                                <xsl:text>la																																																																																</xsl:text>
                                            </xsl:when>
                                            <xsl:when
                                                test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Geor']">
                                                <xsl:text>ma																																																																																</xsl:text>
                                            </xsl:when>
                                            <xsl:when
                                                test="ancestor-or-self::*/did/langmaterial/language[@scriptcode = 'Armn']">
                                                <xsl:text>mb																																																																																</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>ba																																																																																</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:element>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </xsl:element>
                                    <xsl:choose>
                                        <xsl:when
                                            test="*[not(self::dsc) and not(self::c)]//genreform[@type = 'type de document'] | ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@type = 'type de document']">
                                            <xsl:choose>
                                                <xsl:when
                                                  test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'image fixe']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Image fixe																																																																																	</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'image fixe']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Image fixe																																																																																	</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'texte imprimé']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Texte imprimé																																																																																	</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'texte imprimé']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Texte imprimé																																																																																	</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'images animées']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Images animées																																																																																	</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'images animées']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Images animées																																																																																	</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'enregistrement sonore']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Enregistrement sonore																																																																																	</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'enregistrement sonore']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Enregistrement sonore																																																																																	</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'objet']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Objet																																																																																	</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'objet']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Objet																																																																																	</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'ressource électronique']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Ressource électronique																																																																																	</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'ressource électronique']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Ressource électronique																																																																																	</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'texte manuscrit']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Texte manuscrit																																																																																	</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                                <xsl:when
                                                  test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'texte manuscrit']">
                                                  <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Texte manuscrit																																																																																	</xsl:text>
                                                  </xsl:element>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">b </xsl:attribute>
                                                <xsl:text>Texte manuscrit																																																																																	</xsl:text>
                                            </xsl:element>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:choose>
                                        <xsl:when
                                            test="*[not(self::dsc) and not(self::c)]//*[@role = 'producteur' or @role = '070' or @role = '340' or @role = '650' or @role = '330' or @role = '100' or @role = '212' or role = 'fabricant']">
                                            <xsl:for-each
                                                select="*[not(self::dsc) and not(self::c)]//*[@role = 'producteur' or @role = '070' or @role = '340' or @role = '650' or @role = '330' or @role = '100' or @role = '212' or role = 'fabricant']">
                                                <xsl:element name="subfield">
                                                  <xsl:if test="position() = 1">
                                                  <xsl:attribute name="code">f </xsl:attribute>
                                                  <xsl:value-of select="."/>
                                                  </xsl:if>
                                                  <xsl:if test="position() &gt; 1">
                                                  <xsl:attribute name="code">g </xsl:attribute>
                                                  <xsl:value-of select="."/>
                                                  </xsl:if>
                                                </xsl:element>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:call-template name="rechercheancetre">
                                                <xsl:with-param name="ancetre"
                                                  select="ancestor::*[self::archdesc or self::c][*[not(self::dsc) and not(self::c)]//*[@role = '070' or @role = '340' or @role = '650' or @role = '330' or @role = '100' or @role = '212' or role = 'fabricant']][1]"
                                                />
                                            </xsl:call-template>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="datafield">
                                <xsl:attribute name="ind1">
                                    <xsl:text>1																																																																																		</xsl:text>
                                </xsl:attribute>
                                <xsl:attribute name="ind2">
                                    <xsl:text/>
                                </xsl:attribute>
                                <xsl:attribute name="tag">200 </xsl:attribute>
                                <xsl:element name="subfield">
                                    <xsl:attribute name="code">a </xsl:attribute>
                                    <xsl:if test="did/unittitle[not(@type)]">
                                        <xsl:value-of select="normalize-space(did/unittitle)"/>
                                    </xsl:if>
                                    <xsl:if test="not(did/unittitle)">
                                        <xsl:text>SANS TITRE																																																																																				</xsl:text>
                                    </xsl:if>
                                </xsl:element>
                                <xsl:choose>
                                    <xsl:when
                                        test="*[not(self::dsc) and not(self::c)]//genreform[@type = 'type de document'] | ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@type = 'type de document']">
                                        <xsl:choose>
                                            <xsl:when
                                                test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'image fixe']">
                                                <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Image fixe																																																																																				</xsl:text>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when
                                                test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'image fixe']">
                                                <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Image fixe																																																																																				</xsl:text>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when
                                                test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'texte imprimé']">
                                                <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Texte imprimé																																																																																				</xsl:text>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when
                                                test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'texte imprimé']">
                                                <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Texte imprimé																																																																																				</xsl:text>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when
                                                test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'images animées']">
                                                <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Images animées																																																																																				</xsl:text>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when
                                                test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'images animées']">
                                                <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Images animées																																																																																				</xsl:text>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when
                                                test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'enregistrement sonore']">
                                                <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Enregistrement sonore																																																																																				</xsl:text>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when
                                                test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'enregistrement sonore']">
                                                <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Enregistrement sonore																																																																																				</xsl:text>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when
                                                test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'objet']">
                                                <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Objet																																																																																				</xsl:text>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when
                                                test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'objet']">
                                                <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Objet																																																																																				</xsl:text>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when
                                                test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'ressource électronique']">
                                                <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Ressource électronique																																																																																				</xsl:text>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when
                                                test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'ressource électronique']">
                                                <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Ressource électronique																																																																																				</xsl:text>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when
                                                test="*[not(self::dsc) and not(self::c)]//genreform[@normal = 'texte manuscrit']">
                                                <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Texte manuscrit																																																																																				</xsl:text>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:when
                                                test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal = 'texte manuscrit']">
                                                <xsl:element name="subfield">
                                                  <xsl:attribute name="code">b </xsl:attribute>
                                                  <xsl:text>Texte manuscrit																																																																																				</xsl:text>
                                                </xsl:element>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">b </xsl:attribute>
                                            <xsl:text>Texte manuscrit																																																																																				</xsl:text>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when
                                        test="*[not(self::dsc) and not(self::c)]//*[@role = 'producteur' or @role = '070' or @role = '340' or @role = '650' or @role = '330' or @role = '100' or @role = '212' or role = 'fabricant']">
                                        <xsl:for-each
                                            select="*[not(self::dsc) and not(self::c)]//*[@role = 'producteur' or @role = '070' or @role = '340' or @role = '650' or @role = '330' or @role = '100' or @role = '212' or role = 'fabricant']">
                                            <xsl:element name="subfield">
                                                <xsl:if test="position() = 1">
                                                  <xsl:attribute name="code">f </xsl:attribute>
                                                  <xsl:value-of select="."/>
                                                </xsl:if>
                                                <xsl:if test="position() &gt; 1">
                                                  <xsl:attribute name="code">g </xsl:attribute>
                                                  <xsl:value-of select="."/>
                                                </xsl:if>
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="rechercheancetre">
                                            <xsl:with-param name="ancetre"
                                                select="ancestor::*[self::archdesc or self::c][*[not(self::dsc) and not(self::c)]//*[@role = '070' or @role = '340' or @role = '650' or @role = '330' or @role = '100' or @role = '212' or role = 'fabricant']][1]"
                                            />
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:element name="datafield">
                        <xsl:attribute name="ind1">
                            <xsl:text/>
                        </xsl:attribute>
                        <xsl:attribute name="ind2">
                            <xsl:text>1																																																																																							</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="tag">210 </xsl:attribute>
                        <xsl:element name="subfield">
                            <xsl:attribute name="code">a </xsl:attribute>
                            <xsl:text>[S.l.]																																																																																							</xsl:text>
                        </xsl:element>
                        <xsl:element name="subfield">
                            <xsl:attribute name="code">c </xsl:attribute>
                            <xsl:text>[S.n.]																																																																																							</xsl:text>
                        </xsl:element>
                        <xsl:element name="subfield">
                            <xsl:attribute name="code">d </xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="did/unitdate">
                                    <xsl:value-of select="normalize-space(did/unitdate)"/>
                                </xsl:when>
                                <xsl:when
                                    test="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)][//unitdate][1]//unitdate">
                                    <xsl:value-of
                                        select="normalize-space(ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)][//unitdate][1]//unitdate)"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>[S.d.]																																																																																									</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:element>
                    <xsl:if test="did/physdesc">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">215 </xsl:attribute>
                            <xsl:if test="did/physdesc/extent">
                                <xsl:element name="subfield">
                                    <xsl:attribute name="code">a </xsl:attribute>
                                    <xsl:value-of select="normalize-space(did/physdesc/extent)"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if
                                test="did/physdesc/physfacet[@type = 'illustration' or @type = 'support']">
                                <xsl:element name="subfield">
                                    <xsl:attribute name="code">c </xsl:attribute>
                                    <xsl:for-each
                                        select="did/physdesc/physfacet[@type = 'illustration' or @type = 'support']">
                                        <xsl:choose>
                                            <xsl:when test="position() != last()">
                                                <xsl:value-of select="normalize-space(.)"/>
                                                <xsl:text>, 																																																																																														</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="did/physdesc/dimensions">
                                <xsl:element name="subfield">
                                    <xsl:attribute name="code">d </xsl:attribute>
                                    <xsl:value-of select="normalize-space(did/physdesc/dimensions)"
                                    />
                                </xsl:element>
                            </xsl:if>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="note[@type = 'absent']">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">300 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">a </xsl:attribute>
                                <xsl:value-of select="normalize-space(note[@type = 'absent'])"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="otherfindaid">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">300 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">a </xsl:attribute>
                                <xsl:text>Autre instrument de recherche : 																																																																																																				</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="count(otherfindaid/p) &gt; 1">
                                        <xsl:for-each select="otherfindaid/p">
                                            <xsl:choose>
                                                <xsl:when test="position() != last()">
                                                  <xsl:value-of
                                                  select="concat(normalize-space(.), ' ; ')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="normalize-space(otherfindaid)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="separatedmaterial">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">300 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">a </xsl:attribute>
                                <xsl:text>Documents separes : 																																																																																																									</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="count(separatedmaterial/p) &gt; 1">
                                        <xsl:for-each select="separatedmaterial/p">
                                            <xsl:choose>
                                                <xsl:when test="position() != last()">
                                                  <xsl:value-of
                                                  select="concat(normalize-space(.), ' ; ')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="normalize-space(separatedmaterial)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="relatedmaterial">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">300 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">a </xsl:attribute>
                                <xsl:text>Documents en relation : 																																																																																																														</xsl:text>
                                <xsl:choose>
                                    <xsl:when test="count(relatedmaterial/p) &gt; 1">
                                        <xsl:for-each select="relatedmaterial/p">
                                            <xsl:choose>
                                                <xsl:when test="position() != last()">
                                                  <xsl:value-of
                                                  select="concat(normalize-space(.), ' ; ')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="normalize-space(relatedmaterial)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="did/materialspec">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">300 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">a </xsl:attribute>
                                <xsl:text>Particularité de certains types de documents : 																																																																																																																			</xsl:text>
                                <xsl:value-of select="normalize-space(did/materialspec)"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <xsl:for-each select="did/physdesc/physfacet[@type = 'ecriture']">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">303 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">a </xsl:attribute>
                                <xsl:value-of select="normalize-space(.)"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                    <xsl:for-each select="did/physdesc/physfacet[@type = 'autre']">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">307 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">a </xsl:attribute>
                                <xsl:value-of select="normalize-space(.)"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                    <xsl:if test="ancestor-or-self::*/accessrestrict">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">310 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">a </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when
                                        test="count(ancestor-or-self::*/accessrestrict[last()]/p) &gt; 1">
                                        <xsl:for-each
                                            select="ancestor-or-self::*/accessrestrict[last()]/p">
                                            <xsl:choose>
                                                <xsl:when test="position() != last()">
                                                  <xsl:value-of
                                                  select="concat(normalize-space(.), ' ; ')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of
                                            select="normalize-space(ancestor-or-self::*/accessrestrict[last()]/p)"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="ancestor-or-self::*/userestrict">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">310 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">a </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when
                                        test="count(ancestor-or-self::*/userestrict[last()]/p) &gt; 1">
                                        <xsl:for-each
                                            select="ancestor-or-self::*/userestrict[last()]/p">
                                            <xsl:choose>
                                                <xsl:when test="position() != last()">
                                                  <xsl:value-of
                                                  select="concat(normalize-space(.), ' ; ')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of
                                            select="normalize-space(ancestor-or-self::*/userestrict[last()]/p)"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <xsl:for-each select="did/physdesc/physfacet[@type = 'reliure']">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">316 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">a </xsl:attribute>
                                <xsl:value-of select="normalize-space(.)"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                    <xsl:for-each select="acqinfo | note[@type = 'provenance'] | custodhist">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">317 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">a </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="count(./p) &gt; 1">
                                        <xsl:for-each select="./p">
                                            <xsl:choose>
                                                <xsl:when test="position() != last()">
                                                  <xsl:value-of
                                                  select="concat(normalize-space(.), ' ; ')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="normalize-space(./p)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                    <xsl:for-each select="bibliography">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text>1																																																																																																																																													</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">321 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">a </xsl:attribute>
                                <xsl:if test="./head">
                                    <xsl:value-of select="concat(normalize-space(head), ' : ')"/>
                                </xsl:if>
                                <xsl:choose>
                                    <xsl:when test="p">
                                        <xsl:value-of select="normalize-space(p)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select=".//bibref">
                                            <xsl:choose>
                                                <xsl:when test="position() != last()">
                                                  <xsl:value-of
                                                  select="concat(normalize-space(.), ' - ')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                    <xsl:if test="originalsloc">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">324 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">a </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="count(originalsloc/p) &gt; 1">
                                        <xsl:for-each select="originalsloc/p">
                                            <xsl:choose>
                                                <xsl:when test="position() != last()">
                                                  <xsl:value-of
                                                  select="concat(normalize-space(.), ' ; ')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="normalize-space(originalsloc/p)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="altformavail">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">325 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">a </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="count(altformavail/p) &gt; 1">
                                        <xsl:for-each select="altformavail/p">
                                            <xsl:choose>
                                                <xsl:when test="position() != last()">
                                                  <xsl:value-of
                                                  select="concat(normalize-space(.), ' ; ')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="normalize-space(.)"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="normalize-space(altformavail/p)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="dao[@href]">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">325 </xsl:attribute>
                            <xsl:for-each select="dao">
                                <xsl:choose>
                                    <xsl:when test="./@title != ''">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:for-each select="./@title">
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </xsl:for-each>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>[Reproduction numérique]																																																																																																																																																															</xsl:text>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:element name="subfield">
                                    <xsl:attribute name="code">u </xsl:attribute>
                                    <xsl:for-each select="./@href">
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="daogrp/daoloc[@role = 'rebond'][@href]">
                        <xsl:for-each select="daogrp/daoloc[@role = 'rebond'][@href]">
                            <xsl:element name="datafield">
                                <xsl:attribute name="ind1">
                                    <xsl:text/>
                                </xsl:attribute>
                                <xsl:attribute name="ind2">
                                    <xsl:text/>
                                </xsl:attribute>
                                <xsl:attribute name="tag">325 </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="./@title != ''">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:for-each select="./@title">
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </xsl:for-each>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">a </xsl:attribute>
                                            <xsl:text>[Reproduction numérique]																																																																																																																																																																			</xsl:text>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:element name="subfield">
                                    <xsl:attribute name="code">u </xsl:attribute>
                                    <xsl:for-each select="./@href">
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="scopecontent">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text>1																																																																																																																																																																			</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">327 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">a </xsl:attribute>
                                <xsl:text>Description du contenu : 																																																																																																																																																																				</xsl:text>
                                <xsl:for-each select="scopecontent/p">
                                    <xsl:choose>
                                        <xsl:when test="position() != last()">
                                            <xsl:value-of select="normalize-space(.)"/>
                                            <xsl:text> ; 																																																																																																																																																																						</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="c">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text>1																																																																																																																																																																						</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">327 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">a </xsl:attribute>
                                <xsl:text>Contient : 																																																																																																																																																																							</xsl:text>
                                <xsl:for-each select="c">
                                    <xsl:choose>
                                        <xsl:when test="position() != last()">
                                            <xsl:if test="./did/unitid[@type != 'ancienne_cote']">
                                                <xsl:value-of
                                                  select="normalize-space(./did/unitid[@type != 'ancienne_cote'])"/>
                                                <xsl:text/>
                                            </xsl:if>
                                            <xsl:if test="./did/unittitle">
                                                <xsl:value-of
                                                  select="normalize-space(./did/unittitle)"/>
                                            </xsl:if>
                                            <xsl:text> ; 																																																																																																																																																																											</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:if test="./did/unitid[@type != 'ancienne_cote']">
                                                <xsl:value-of
                                                  select="normalize-space(./did/unitid[@type != 'ancienne_cote'])"/>
                                                <xsl:text/>
                                            </xsl:if>
                                            <xsl:if test="./did/unittitle">
                                                <xsl:value-of
                                                  select="normalize-space(./did/unittitle)"/>
                                            </xsl:if>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="name(.) != 'archdesc'">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">461 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">t </xsl:attribute>
                                <xsl:value-of select="normalize-space(/ead/archdesc/did/unittitle)"/>
                                <xsl:for-each select="ancestor::c">
                                    <xsl:text> -- 																																																																																																																																																																																	</xsl:text>
                                    <xsl:value-of select="normalize-space(did/unittitle)"/>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="parent::c[@otherlevel = 'groupe-de-notices']">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text>1																																																																																																																																																																																	</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">517 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">a </xsl:attribute>
                                <xsl:value-of
                                    select="normalize-space(parent::c[@otherlevel = 'groupe-de-notices']/did/unittitle)"
                                />
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="did/unittitle[2]">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text>1																																																																																																																																																																																			</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">517 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">a </xsl:attribute>
                                <xsl:value-of select="normalize-space(did/unittitle[2])"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//persname[@role = 'sujet' or @role = 'producteur'][not(parent::controlaccess[./*[2]])]">
                            <xsl:for-each
                                select="*[not(self::dsc) and not(self::c)]//persname[@role = 'sujet' or @role = 'producteur'][not(parent::controlaccess[./*[2]])]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">600 </xsl:attribute>
                                    <xsl:if test="@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																									</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when
                            test="ancestor::*[self::archdesc or self::c][/child::*[not(self::dsc) and not(self::c)]//persname[@role = 'sujet']][1]/child::*[not(self::dsc) and not(self::c)]//persname[@role = 'sujet'][not(parent::controlaccess[./*[2]])]">
                            <xsl:for-each
                                select="ancestor::*[self::archdesc or self::c][/child::*[not(self::dsc) and not(self::c)]//persname[@role = 'sujet']][1]/child::*[not(self::dsc) and not(self::c)]//persname[@role = 'sujet'][not(parent::controlaccess[./*[2]])]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">600 </xsl:attribute>
                                    <xsl:if test="@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																												</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//persname[1][parent::controlaccess[./*[2]]][not(following-sibling::title)]">
                            <xsl:for-each
                                select="*[not(self::dsc) and not(self::c)]//persname[1][parent::controlaccess[./*[2]]][not(following-sibling::title)]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">600 </xsl:attribute>
                                    <xsl:if test="./@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:for-each select="following-sibling::subject">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">x </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="following-sibling::geogname">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">y </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																																	</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when
                            test="ancestor::*[self::archdesc or self::c][/child::*[not(self::dsc) and not(self::c)]//persname[@role = 'sujet']][1]/child::*[not(self::dsc) and not(self::c)]//persname[@role = 'sujet'][parent::controlaccess[./*[2]]][not(following-sibling::title)]">
                            <xsl:for-each
                                select="ancestor::*[self::archdesc or self::c][/child::*[not(self::dsc) and not(self::c)]//persname[@role = 'sujet']][1]/child::*[not(self::dsc) and not(self::c)]//persname[@role = 'sujet'][parent::controlaccess[./*[2]]][not(following-sibling::title)]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">600 </xsl:attribute>
                                    <xsl:if test="./@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:for-each select="following-sibling::subject">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">x </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="following-sibling::geogname">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">y </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																																						</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//corpname[@role = 'sujet' or @role = 'producteur'][not(parent::controlaccess[./*[2]])]">
                            <xsl:for-each
                                select="*[not(self::dsc) and not(self::c)]//corpname[@role = 'sujet' or @role = 'producteur'][not(parent::controlaccess[./*[2]])]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">601 </xsl:attribute>
                                    <xsl:if test="@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																																									</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when
                            test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//corpname[@role = 'sujet'][not(parent::controlaccess[./*[2]])]">
                            <xsl:for-each
                                select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//corpname[@role = 'sujet'][not(parent::controlaccess[./*[2]])]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">601 </xsl:attribute>
                                    <xsl:if test="@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																																												</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//corpname[1][parent::controlaccess[./*[2]]]">
                            <xsl:for-each
                                select="*[not(self::dsc) and not(self::c)]//corpname[1][parent::controlaccess[./*[2]]]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">601 </xsl:attribute>
                                    <xsl:if test="./@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:for-each select="following-sibling::subject">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">x </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="following-sibling::geogname">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">y </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																																																	</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when
                            test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//corpname[1][parent::controlaccess[./*[2]]]">
                            <xsl:for-each
                                select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//corpname[1][parent::controlaccess[./*[2]]]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">601 </xsl:attribute>
                                    <xsl:if test="./@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:for-each select="following-sibling::subject">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">x </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="following-sibling::geogname">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">y </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																																																						</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//famname[@role = 'sujet' or @role = 'producteur'][not(parent::controlaccess[./*[2]])]">
                            <xsl:for-each
                                select="*[not(self::dsc) and not(self::c)]//famname[@role = 'sujet' or @role = 'producteur'][not(parent::controlaccess[./*[2]])]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">602 </xsl:attribute>
                                    <xsl:if test="@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																																																									</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when
                            test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//famname[@role = 'sujet'][not(parent::controlaccess[./*[2]])]">
                            <xsl:for-each
                                select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//famname[@role = 'sujet'][not(parent::controlaccess[./*[2]])]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">602 </xsl:attribute>
                                    <xsl:if test="@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																																																												</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//famname[1][parent::controlaccess[./*[2]]]">
                            <xsl:for-each
                                select="*[not(self::dsc) and not(self::c)]//famname[1][parent::controlaccess[./*[2]]]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">602 </xsl:attribute>
                                    <xsl:if test="./@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:for-each select="following-sibling::subject">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">x </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="following-sibling::geogname">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">y </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																																																																	</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when
                            test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//famname[1][parent::controlaccess[./*[2]]]">
                            <xsl:for-each
                                select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//famname[1][parent::controlaccess[./*[2]]]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">602 </xsl:attribute>
                                    <xsl:if test="./@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:for-each select="following-sibling::subject">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">x </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="following-sibling::geogname">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">y </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																																																																						</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//persname[1][parent::controlaccess[./*[2]]][following-sibling::title]">
                            <xsl:for-each
                                select="*[not(self::dsc) and not(self::c)]//persname[1][parent::controlaccess[./*[2]]][following-sibling::title]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">604 </xsl:attribute>
                                    <xsl:if test="./@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:for-each select="following-sibling::title">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">t </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when
                            test="ancestor::*[self::archdesc or self::c][/child::*[not(self::dsc) and not(self::c)]//persname[@role = 'sujet']][1]/child::*[not(self::dsc) and not(self::c)]//persname[@role = 'sujet'][parent::controlaccess[./*[2]]][following-sibling::title]">
                            <xsl:for-each
                                select="ancestor::*[self::archdesc or self::c][/child::*[not(self::dsc) and not(self::c)]//persname[@role = 'sujet']][1]/child::*[not(self::dsc) and not(self::c)]//persname[@role = 'sujet'][parent::controlaccess[./*[2]]][following-sibling::title]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">604 </xsl:attribute>
                                    <xsl:if test="./@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:for-each select="following-sibling::title">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">t </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//title[not(parent::controlaccess[./*[2]])][not(preceding-sibling::persname)]">
                            <xsl:for-each
                                select="*[not(self::dsc) and not(self::c)]//title[not(parent::controlaccess[./*[2]])][not(preceding-sibling::persname)]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">605 </xsl:attribute>
                                    <xsl:if test="@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																																																																																	</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when
                            test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//title[not(parent::controlaccess[./*[2]])][not(preceding-sibling::persname)]">
                            <xsl:for-each
                                select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//title[not(parent::controlaccess[./*[2]])][not(preceding-sibling::persname)]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">605 </xsl:attribute>
                                    <xsl:if test="@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																																																																																				</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//title[1][parent::controlaccess[./*[2]]][not(preceding-sibling::persname)]">
                            <xsl:for-each
                                select="*[not(self::dsc) and not(self::c)]//title[1][parent::controlaccess[./*[2]]][not(preceding-sibling::persname)]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">605 </xsl:attribute>
                                    <xsl:if test="./@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:for-each select="following-sibling::subject">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">x </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="following-sibling::geogname">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">y </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																																																																																									</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when
                            test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//title[1][parent::controlaccess[./*[2]]][not(preceding-sibling::persname)]">
                            <xsl:for-each
                                select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//title[1][parent::controlaccess[./*[2]]][not(preceding-sibling::persname)]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">605 </xsl:attribute>
                                    <xsl:if test="./@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:for-each select="following-sibling::subject">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">x </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="following-sibling::geogname">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">y </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																																																																																														</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//subject[@source = 'Sudoc'][not(parent::controlaccess[./*[2]])]">
                            <xsl:for-each
                                select="*[not(self::dsc) and not(self::c)]//subject[@source = 'Sudoc'][not(parent::controlaccess[./*[2]])]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">606 </xsl:attribute>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">3 </xsl:attribute>
                                        <xsl:value-of select="normalize-space(@authfilenumber)"/>
                                    </xsl:element>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">2 </xsl:attribute>
                                        <xsl:text>Rameau																																																																																																																																																																																																																																																																	</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when
                            test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//subject[@source = 'Sudoc'][not(parent::controlaccess[./*[2]])]">
                            <xsl:for-each
                                select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//subject[@source = 'Sudoc'][not(parent::controlaccess[./*[2]])]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">606 </xsl:attribute>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">3 </xsl:attribute>
                                        <xsl:value-of select="normalize-space(@authfilenumber)"/>
                                    </xsl:element>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">2 </xsl:attribute>
                                        <xsl:text>Rameau																																																																																																																																																																																																																																																																				</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//subject[1][@source = 'Sudoc'][parent::controlaccess[./*[2]]]">
                            <xsl:for-each
                                select="*[not(self::dsc) and not(self::c)]//subject[1][@source = 'Sudoc'][parent::controlaccess[./*[2]]]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">606 </xsl:attribute>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">3 </xsl:attribute>
                                        <xsl:value-of select="normalize-space(@authfilenumber)"/>
                                    </xsl:element>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:for-each select="following-sibling::subject">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">x </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="following-sibling::geogname">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">y </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">2 </xsl:attribute>
                                        <xsl:text>Rameau																																																																																																																																																																																																																																																																									</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when
                            test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//subject[1][@source = 'Sudoc'][parent::controlaccess[./*[2]]]">
                            <xsl:for-each
                                select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//subject[1][@source = 'Sudoc'][parent::controlaccess[./*[2]]]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">606 </xsl:attribute>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">3 </xsl:attribute>
                                        <xsl:value-of select="normalize-space(@authfilenumber)"/>
                                    </xsl:element>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:for-each select="following-sibling::subject">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">x </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="following-sibling::geogname">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">y </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">2 </xsl:attribute>
                                        <xsl:text>Rameau																																																																																																																																																																																																																																																																														</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//geogname[not(parent::controlaccess[./*[2]])]">
                            <xsl:for-each
                                select="*[not(self::dsc) and not(self::c)]//geogname[not(parent::controlaccess[./*[2]])]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">607 </xsl:attribute>
                                    <xsl:if test="@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																																																																																																																	</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when
                            test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//geogname[not(parent::controlaccess[./*[2]])]">
                            <xsl:for-each
                                select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//geogname[not(parent::controlaccess[./*[2]])]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">607 </xsl:attribute>
                                    <xsl:if test="@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:if test="./@source = 'Sudoc'">
                                <xsl:element name="subfield">
                                    <xsl:attribute name="code">2 </xsl:attribute>
                                    <xsl:text>Rameau																																																																																																																																																																																																																																																																																			</xsl:text>
                                </xsl:element>
                            </xsl:if>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//geogname[1][parent::controlaccess[./*[2]]]">
                            <xsl:for-each
                                select="*[not(self::dsc) and not(self::c)]//geogname[1][parent::controlaccess[./*[2]]]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">607 </xsl:attribute>
                                    <xsl:if test="./@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:for-each select="following-sibling::subject">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">x </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="following-sibling::geogname">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">y </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																																																																																																																									</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when
                            test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//geogname[1][parent::controlaccess[./*[2]]]">
                            <xsl:for-each
                                select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//geogname[1][parent::controlaccess[./*[2]]]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">607 </xsl:attribute>
                                    <xsl:if test="./@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:for-each select="following-sibling::subject">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">x </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="following-sibling::geogname">
                                        <xsl:if test="./@authfilenumber">
                                            <xsl:element name="subfield">
                                                <xsl:attribute name="code">3 </xsl:attribute>
                                                <xsl:value-of
                                                  select="normalize-space(@authfilenumber)"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">y </xsl:attribute>
                                            <xsl:call-template name="Template_normal">
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:if test="./@source = 'Sudoc'">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">2 </xsl:attribute>
                                            <xsl:text>Rameau																																																																																																																																																																																																																																																																																														</xsl:text>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//genreform[@type = 'technique']">
                            <xsl:for-each
                                select="*[not(self::dsc) and not(self::c)]//genreform[@type = 'technique']">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">608 </xsl:attribute>
                                    <xsl:if test="@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">2 </xsl:attribute>
                                        <xsl:text>calames																																																																																																																																																																																																																																																																																																	</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each
                                select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@type = 'technique']">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">608 </xsl:attribute>
                                    <xsl:if test="@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">2 </xsl:attribute>
                                        <xsl:text>calames																																																																																																																																																																																																																																																																																																				</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//genreform[@type = 'genre, forme et fonction']">
                            <xsl:for-each
                                select="*[not(self::dsc) and not(self::c)]//genreform[@type = 'genre, forme et fonction']">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">608 </xsl:attribute>
                                    <xsl:if test="@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">2 </xsl:attribute>
                                        <xsl:text>calames																																																																																																																																																																																																																																																																																																							</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each
                                select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@type = 'genre, forme et fonction']">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">608 </xsl:attribute>
                                    <xsl:if test="@authfilenumber">
                                        <xsl:element name="subfield">
                                            <xsl:attribute name="code">3 </xsl:attribute>
                                            <xsl:value-of select="normalize-space(@authfilenumber)"
                                            />
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">2 </xsl:attribute>
                                        <xsl:text>calames																																																																																																																																																																																																																																																																																																										</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//subject[not(@source = 'Sudoc')][not(parent::controlaccess[./*[2]])]">
                            <xsl:for-each
                                select="*[not(self::dsc) and not(self::c)]//subject[not(@source = 'Sudoc')][not(parent::controlaccess[./*[2]])]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">610 </xsl:attribute>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each
                                select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//subject[not(@source = 'Sudoc')][not(parent::controlaccess[./*[2]])]">
                                <xsl:element name="datafield">
                                    <xsl:attribute name="ind1">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="ind2">
                                        <xsl:text/>
                                    </xsl:attribute>
                                    <xsl:attribute name="tag">610 </xsl:attribute>
                                    <xsl:element name="subfield">
                                        <xsl:attribute name="code">a </xsl:attribute>
                                        <xsl:call-template name="Template_normal">
                                            <xsl:with-param name="node" select="."/>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//*[@role = 'producteur' or @role = '070' or @role = '340' or @role = '650' or @role = '330' or @role = '100' or @role = '212' or role = 'fabricant']">
                            <xsl:for-each
                                select="*[not(self::dsc) and not(self::c)]//*[@role = 'producteur' or @role = '070' or @role = '340' or @role = '650' or @role = '330' or @role = '100' or @role = '212' or role = 'fabricant']">
                                <xsl:choose>
                                    <xsl:when test="name(.) = 'persname'">
                                        <xsl:if test="position() = 1">
                                            <xsl:call-template name="Template_7XX">
                                                <xsl:with-param name="zone_7XX">700
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:if>
                                        <xsl:if test="position() != 1">
                                            <xsl:call-template name="Template_7XX">
                                                <xsl:with-param name="zone_7XX">701
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:when test="name(.) = 'corpname'">
                                        <xsl:if test="position() = 1">
                                            <xsl:call-template name="Template_7XX">
                                                <xsl:with-param name="zone_7XX">710
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:if>
                                        <xsl:if test="position() != 1">
                                            <xsl:call-template name="Template_7XX">
                                                <xsl:with-param name="zone_7XX">711
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:when test="name(.) = 'famname'">
                                        <xsl:if test="position() = 1">
                                            <xsl:call-template name="Template_7XX">
                                                <xsl:with-param name="zone_7XX">720
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:if>
                                        <xsl:if test="position() != 1">
                                            <xsl:call-template name="Template_7XX">
                                                <xsl:with-param name="zone_7XX">721
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:if>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each
                                select="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//*[@role = '070' or @role = '340' or @role = '650' or @role = '330' or @role = '100' or @role = '212' or role = 'fabricant']">
                                <xsl:choose>
                                    <xsl:when test="name(.) = 'persname'">
                                        <xsl:if test="position() = 1">
                                            <xsl:call-template name="Template_7XX">
                                                <xsl:with-param name="zone_7XX">700
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:if>
                                        <xsl:if test="position() != 1">
                                            <xsl:call-template name="Template_7XX">
                                                <xsl:with-param name="zone_7XX">701
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:when test="name(.) = 'corpname'">
                                        <xsl:if test="position() = 1">
                                            <xsl:call-template name="Template_7XX">
                                                <xsl:with-param name="zone_7XX">710
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:if>
                                        <xsl:if test="position() != 1">
                                            <xsl:call-template name="Template_7XX">
                                                <xsl:with-param name="zone_7XX">711
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:when test="name(.) = 'famname'">
                                        <xsl:if test="position() = 1">
                                            <xsl:call-template name="Template_7XX">
                                                <xsl:with-param name="zone_7XX">720
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:if>
                                        <xsl:if test="position() != 1">
                                            <xsl:call-template name="Template_7XX">
                                                <xsl:with-param name="zone_7XX">721
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:if>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="*[not(self::dsc) and not(self::c)]//*[@role = '020' or @role = '110' or @role = '700' or @role = '280' or @role = '660' or @role = '390' or @role = '730' or @role = '220' or @role = '440' or @role = '590' or @role = '610' or @role = 'participant' or @role = 'commanditaire' or @role = '723']">
                            <xsl:for-each
                                select="*[not(self::dsc) and not(self::c)]//*[@role = '020' or @role = '110' or @role = '700' or @role = '280' or @role = '660' or @role = '390' or @role = '730' or @role = '220' or @role = '440' or @role = '590' or @role = '610' or @role = 'participant' or @role = 'commanditaire' or @role = '723']">
                                <xsl:choose>
                                    <xsl:when test="name(.) = 'persname'">
                                        <xsl:call-template name="Template_7XX">
                                            <xsl:with-param name="zone_7XX">702 </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:when test="name(.) = 'corpname'">
                                        <xsl:call-template name="Template_7XX">
                                            <xsl:with-param name="zone_7XX">712 </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:when test="name(.) = 'famname'">
                                        <xsl:call-template name="Template_7XX">
                                            <xsl:with-param name="zone_7XX">722 </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each
                                select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//*[@role = '020' or @role = '110' or @role = '700' or @role = '280' or @role = '660' or @role = '390' or @role = '730' or @role = '220' or @role = '440' or @role = '590' or @role = '610' or @role = 'participant' or @role = 'commanditaire' or @role = '723']">
                                <xsl:choose>
                                    <xsl:when test="name(.) = 'persname'">
                                        <xsl:call-template name="Template_7XX">
                                            <xsl:with-param name="zone_7XX">702 </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:when test="name(.) = 'corpname'">
                                        <xsl:call-template name="Template_7XX">
                                            <xsl:with-param name="zone_7XX">712 </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:when test="name(.) = 'famname'">
                                        <xsl:call-template name="Template_7XX">
                                            <xsl:with-param name="zone_7XX">722 </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:element name="datafield">
                        <xsl:attribute name="ind1">
                            <xsl:text/>
                        </xsl:attribute>
                        <xsl:attribute name="ind2">
                            <xsl:text>3																																																																																																																																																																																																																																																																																																														</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="tag">810 </xsl:attribute>
                        <xsl:element name="subfield">
                            <xsl:attribute name="code">a </xsl:attribute>
                            <xsl:text>FR																																																																																																																																																																																																																																																																																																														</xsl:text>
                        </xsl:element>
                        <xsl:element name="subfield">
                            <xsl:attribute name="code">b </xsl:attribute>
                            <xsl:text>ABES																																																																																																																																																																																																																																																																																																														</xsl:text>
                        </xsl:element>
                        <xsl:element name="subfield">
                            <xsl:attribute name="code">g </xsl:attribute>
                            <xsl:text>AFNOR																																																																																																																																																																																																																																																																																																														</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="datafield">
                        <xsl:attribute name="ind1">
                            <xsl:text/>
                        </xsl:attribute>
                        <xsl:attribute name="ind2">
                            <xsl:text/>
                        </xsl:attribute>
                        <xsl:attribute name="tag">930 </xsl:attribute>
                        <xsl:element name="subfield">
                            <xsl:attribute name="code">b </xsl:attribute>
                            <xsl:value-of select="normalize-space($rcr)"/>
                        </xsl:element>
                        <xsl:element name="subfield">
                            <xsl:attribute name="code">a </xsl:attribute>
                            <xsl:choose>
                                <xsl:when
                                    test="did/unitid[@type = 'cote_actuelle' or @type = 'cote']">
                                    <xsl:value-of
                                        select="normalize-space(did/unitid[@type = 'cote_actuelle' or @type = 'cote'])"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="normalize-space(ancestor::*[self::archdesc or self::c][did/unitid[@type = 'cote_actuelle' or @type = 'cote']][1]/did/unitid[@type = 'cote_actuelle' or @type = 'cote'])"
                                    />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                        <xsl:element name="subfield">
                            <xsl:attribute name="code">j </xsl:attribute>
                            <xsl:text>g																																																																																																																																																																																																																																																																																																																			</xsl:text>
                        </xsl:element>
                        <xsl:if
                            test="did/physloc | ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]/physloc">
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">f </xsl:attribute>
                                <xsl:choose>
                                    <xsl:when test="did/physloc">
                                        <xsl:value-of select="normalize-space(did/physloc)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of
                                            select="normalize-space(ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]/physloc)"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                    <xsl:if test="//archdesc/did/repository/corpname/@authfilenumber = '601415401'">
                        <xsl:element name="datafield">
                            <xsl:attribute name="ind1">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="ind2">
                                <xsl:text/>
                            </xsl:attribute>
                            <xsl:attribute name="tag">995 </xsl:attribute>
                            <xsl:element name="subfield">
                                <xsl:attribute name="code">k </xsl:attribute>
                                <xsl:value-of
                                    select="normalize-space(did/unitid[@type = 'cote_actuelle' or @type = 'cote'])"
                                />
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                </record>
            </xsl:for-each>
        </collection>
    </xsl:template>
    <xsl:template name="date100">
        <xsl:param name="date_chemin"/>
        <xsl:choose>
            <xsl:when test="contains($date_chemin, '/')">
                <xsl:text>        f																																																																																																																																																																																																																																																																																																																							</xsl:text>
                <xsl:value-of select="substring($date_chemin, 1, 4)"/>
                <xsl:value-of select="substring(substring-after($date_chemin, '/'), 1, 4)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>        d																																																																																																																																																																																																																																																																																																																									</xsl:text>
                <xsl:value-of select="concat(substring($date_chemin, 1, 4), '    ')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Template_normal">
        <xsl:param name="node"/>
        <xsl:choose>
            <xsl:when test="$node/@normal">
                <xsl:value-of select="$node/@normal"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space($node)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Template_7XX">
        <xsl:param name="zone_7XX"/>
        <xsl:element name="datafield">
            <xsl:attribute name="ind1">
                <xsl:text/>
            </xsl:attribute>
            <xsl:attribute name="ind2">
                <xsl:text/>
            </xsl:attribute>
            <xsl:attribute name="tag">
                <xsl:value-of select="$zone_7XX"/>
            </xsl:attribute>
            <xsl:if test="@authfilenumber">
                <xsl:element name="subfield">
                    <xsl:attribute name="code">3 </xsl:attribute>
                    <xsl:value-of select="normalize-space(@authfilenumber)"/>
                </xsl:element>
            </xsl:if>
            <xsl:element name="subfield">
                <xsl:attribute name="code">a </xsl:attribute>
                <xsl:call-template name="Template_normal">
                    <xsl:with-param name="node" select="."/>
                </xsl:call-template>
            </xsl:element>
            <xsl:element name="subfield">
                <xsl:attribute name="code">4 </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="@role = 'producteur' or role = 'fabricant'">
                        <xsl:text>070																																																																																																																																																																																																																																																																																																																																</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(@role)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="rechercheancetre">
        <xsl:param name="ancetre"/>
        <xsl:for-each
            select="$ancetre/*[not(self::dsc) and not(self::c)]//*[@role = '070' or @role = '340' or @role = '650' or @role = '330' or @role = '100' or @role = '212' or role = 'fabricant']">
            <xsl:element name="subfield">
                <xsl:if test="position() = 1">
                    <xsl:attribute name="code">f </xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:if>
                <xsl:if test="position() &gt; 1">
                    <xsl:attribute name="code">g </xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:if>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
