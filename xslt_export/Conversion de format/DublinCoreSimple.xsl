<xsl:stylesheet xmlns:dc="http://purl.org/dc" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" exclude-result-prefixes="dc">
  <!-- xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:local="urn:local" extension-element-prefixes="msxsl"> -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  <!-- conversion de ead vers Dublin Core : dans la variable filtre il peut y avoir : //c[@id='CGM-124567']. Attention les simple cote sont doublees -->
  <xsl:param name="filtre" />
  <!-- <msxsl:script language="CSharp" implements-prefix="local">public string dateTimeNow(){       return DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ssZ"); } </msxsl:script>-->
  <xsl:variable name="etab" select="/ead/archdesc/did/repository/corpname" />
  <xsl:variable name="rcr" select="/ead/archdesc/did/repository/corpname/@authfilenumber" />
  <xsl:variable name="intitule" select="/ead/archdesc/did/unittitle" />
  <xsl:template match="/">    
    <xsl:choose>
      <xsl:when test="$filtre != ''">	
    <ListRecords>
      <!--<collection xmlns="http://www.loc.gov/MARC21/slim" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">-->
      <xsl:for-each select="$filtre">
        <!--<xsl:for-each select="//c">-->
        <!--<xsl:for-each select="//c[../daogrp]">-->
        <!--<xsl:for-each select="//c[@id='cgm-1234578'']">-->
        <record>
          <header>
            <identifier>oai:oaicalames.abes.fr:<xsl:value-of select="@id" /></identifier>
            <datestamp>
              <!--<xsl:value-of select="local:dateTimeNow()"/>-->
            </datestamp>
            <setSpec>
              <xsl:value-of select="$rcr" />
            </setSpec>
          </header>
          <metadata>
            <oai_dc>
              <!-- dc:title -->
              <xsl:for-each select="did/unittitle">
                <xsl:element name="dc:title" namespace="http://purl.org/dc/elements/1.1/title">
                  <xsl:value-of select="." />
                </xsl:element>
              </xsl:for-each>
              <!-- dc:identifier -->
              <!-- Un élément par cote, division, ou ancienne cote. En cas de division : précédée de la 1ère cote parente. En cas d’absence d’unitid : récupère la première cote parente  -->
              <xsl:if test="did[not(unitid[@type='division'])]">
                <xsl:choose>
                  <xsl:when test="did/unitid[@type='cote_actuelle' or @type='cote']">
                    <xsl:element name="dc:identifier" namespace="http://purl.org/dc/elements/1.1/identifier">
                      <xsl:value-of select="normalize-space(did/unitid[@type='cote_actuelle' or @type='cote'])" />
                      <xsl:text> [cote]</xsl:text>
                    </xsl:element>
                  </xsl:when>
                  <xsl:when test="did/unitid[@type='ancienne_cote']">
                    <xsl:element name="dc:identifier" namespace="http://purl.org/dc/elements/1.1/identifier">
                      <xsl:value-of select="normalize-space(did/unitid[@type='ancienne_cote'])" />
                      <xsl:text> [ancienne cote]</xsl:text>
                    </xsl:element>
                  </xsl:when>
                  <xsl:when test="ancestor::*[self::archdesc or self::c][did/unitid[@type='cote_actuelle' or @type='cote']][1]/did/unitid[@type='cote_actuelle' or @type='cote']">
                    <xsl:element name="dc:identifier" namespace="http://purl.org/dc/elements/1.1/identifier">
                      <xsl:value-of select="normalize-space(ancestor::*[self::archdesc or self::c][did/unitid[@type='cote_actuelle' or @type='cote']][1]/did/unitid[@type='cote_actuelle' or @type='cote'])" />
                      <xsl:text> [cote de l'ensemble]</xsl:text>
                    </xsl:element>
                  </xsl:when>
                </xsl:choose>
              </xsl:if>
              <xsl:if test="did/unitid[@type='division']">
                <xsl:choose>
                  <xsl:when test="ancestor::*[self::archdesc or self::c][did/unitid[@type='cote_actuelle' or @type='cote']][1]/did/unitid[@type='cote_actuelle' or @type='cote']">
                    <xsl:element name="dc:identifier" namespace="http://purl.org/dc/elements/1.1/identifier">
                      <xsl:value-of select="normalize-space(ancestor::*[self::archdesc or self::c][did/unitid[@type='cote_actuelle' or @type='cote']][1]/did/unitid[@type='cote_actuelle' or @type='cote'])" />
                      <xsl:text> / </xsl:text>
                      <xsl:value-of select="normalize-space(did/unitid[@type='division'])" />
                      <xsl:text> [division de cote]</xsl:text>
                    </xsl:element>
                  </xsl:when>
                </xsl:choose>
              </xsl:if>
              <!-- dc:relation RCR -->
              <!-- RCR Calames (transformé en code ISIL international avec le préfixe 'FR-') -->
              <xsl:element name="dc:relation" namespace="http://purl.org/dc/elements/1.1/relation">
                <xsl:text>FR-</xsl:text>
                <xsl:value-of select="$rcr" />
                <xsl:text> [RCR établissement]</xsl:text>
              </xsl:element>
              <!-- dc:relation Fonds -->
              <xsl:element name="dc:relation" namespace="http://purl.org/dc/elements/1.1/relation">
                <xsl:value-of select="$intitule" />
                <xsl:text> [Fonds ou collection]</xsl:text>
              </xsl:element>
              <!-- dc:relation Permalien Calames, selon la pratique BnF  -->
              <xsl:if test="@id">
                <xsl:element name="dc:relation" namespace="http://purl.org/dc/elements/1.1/relation">
                  <xsl:text>http://www.calames.abes.fr/pub/ms/</xsl:text>
                  <xsl:value-of select="@id" />
                  <xsl:comment>Permalien Calames</xsl:comment>
                </xsl:element>
              </xsl:if>
              <xsl:if test="not(@id)">
                <xsl:comment>Le permalien Calames ne peut pas être exporté. Le cas échéant, reportez l'identifiant de haut niveau du type "FileId-XX", où XX = numéro de fichier Calames, dans l'attribut ID de la balise Archdesc</xsl:comment>
              </xsl:if>
              <!-- Permalien Calames en DC Qualifié : dcterms:isReferencedBy-->
              <!--<xsl:element name="dcterms:isReferencedBy" namespace="http://purl.org/dc/terms/isReferencedBy"><xsl:attribute name="xsi:type">dcterms:URI</xsl:attribute><xsl:text>http://www.calames.abes.fr/pub/ms/</xsl:text><xsl:value-of select="@id"/></xsl:element>-->
              <!-- dc:creator -->
              <xsl:if test="*[not(self::dsc) and not(self::c)]//*[@role='070' or @role='100' or @role='330' or role='fabricant' or role='producteur']">
                <xsl:for-each select="*[not(self::dsc) and not(self::c)]//*[@role='070' or @role='330' or @role='100' or role='fabricant' or role='producteur']">
                  <xsl:element name="dc:creator" namespace="http://purl.org/dc/elements/1.1/creator">
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                    <xsl:call-template name="Template_roles">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <xsl:if test="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//*[@role='070' or @role='100' or @role='330' or role='fabricant' or role='producteur']">
                <xsl:for-each select="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//*[@role='070' or @role='100' or @role='330' or role='fabricant' or role='producteur']">
                  <xsl:element name="dc:creator" namespace="http://purl.org/dc/elements/1.1/creator">
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                    <xsl:call-template name="Template_roles">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <!-- dc:contributor -->
              <xsl:if test="*[not(self::dsc) and not(self::c)]//*[@role = '020' or @role='110' or @role='700' or @role='280'  or @role='660' or @role='390' or @role='730' or @role='220' or @role='440' or @role='590' or @role='610' or @role='participant' or @role='commanditaire' or @role='723' or @role='340' or @role='650'  or @role='212']">
                <xsl:for-each select="*[not(self::dsc) and not(self::c)]//*[@role = '020' or @role='110' or @role='700' or @role='280'  or @role='660' or @role='390' or @role='730' or @role='220' or @role='440' or @role='590' or @role='610' or @role='participant' or @role='commanditaire' or @role='723' or @role='340' or @role='650'  or @role='212']">
                  <xsl:element name="dc:contributor" namespace="http://purl.org/dc/elements/1.1/contributor">
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                    <xsl:call-template name="Template_roles">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <xsl:if test="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//*[@role = '020' or @role='110' or @role='700' or @role='280'  or @role='660' or @role='390' or @role='730' or @role='220' or @role='440' or @role='590' or @role='610' or @role='participant' or @role='commanditaire' or @role='723' or @role='340' or @role='650'  or @role='212']">
                <xsl:for-each select="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//*[@role = '020' or @role='110' or @role='700' or @role='280'  or @role='660' or @role='390' or @role='730' or @role='220' or @role='440' or @role='590' or @role='610' or @role='participant' or @role='commanditaire' or @role='723' or @role='340' or @role='650'  or @role='212']">
                  <xsl:element name="dc:contributor" namespace="http://purl.org/dc/elements/1.1/contributor">
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                    <xsl:call-template name="Template_roles">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <!-- dc:subject -->
              <!-- [not(preceding-sibling::*)] -->
              <xsl:if test="*[not(self::dsc) and not(self::c)]//*[self::subject[parent::controlaccess][not(preceding-sibling::*)] or self::subject[not(parent::controlaccess)] or self::geogname[not(@role)][parent::controlaccess][not(preceding-sibling::*)] or self::geogname[not(@role)][not(parent::controlaccess)]  or self::*[@role='sujet']]">
                <xsl:for-each select="*[not(self::dsc) and not(self::c)]//*[self::subject[parent::controlaccess][not(preceding-sibling::*)] or self::subject[not(parent::controlaccess)] or self::geogname[not(@role)][parent::controlaccess][not(preceding-sibling::*)] or self::geogname[not(@role)][not(parent::controlaccess)]  or self::*[@role='sujet']]">
                  <xsl:element name="dc:subject" namespace="http://purl.org/dc/elements/1.1/subject">
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <xsl:if test="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//*[self::subject[parent::controlaccess][not(preceding-sibling::*)] or self::subject[not(parent::controlaccess)] or self::geogname[not(@role)][parent::controlaccess][not(preceding-sibling::*)] or self::geogname[not(@role)][not(parent::controlaccess)]  or self::*[@role='sujet']]">
                <xsl:for-each select="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//*[self::subject[parent::controlaccess][not(preceding-sibling::*)] or self::subject[not(parent::controlaccess)] or self::geogname[not(@role)][parent::controlaccess][not(preceding-sibling::*)] or self::geogname[not(@role)][not(parent::controlaccess)]  or self::*[@role='sujet']]">
                  <xsl:element name="dc:subject" namespace="http://purl.org/dc/elements/1.1/subject">
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <!-- dc:format -->
              <!--<xsl:if test="did/physdesc/*"><xsl:for-each select="did/physdesc/*"><dc:format><xsl:value-of select="."/></dc:format></xsl:for-each></xsl:if>-->
              <!-- dc:format Extent -->
              <xsl:if test="did/physdesc/extent">
                <xsl:element name="dc:format" namespace="http://purl.org/dc/elements/1.1/format">Importance matérielle : <xsl:value-of select="did/physdesc/extent" /></xsl:element>
              </xsl:if>
              <!-- dc:format Dimensions -->
              <xsl:if test="did/physdesc/dimensions">
                <xsl:element name="dc:format" namespace="http://purl.org/dc/elements/1.1/format">Dimensions : <xsl:value-of select="did/physdesc/dimensions" /></xsl:element>
              </xsl:if>
              <!-- dc:format Physfacet -->
              <xsl:if test="did/physdesc/physfacet">
                <xsl:element name="dc:format" namespace="http://purl.org/dc/elements/1.1/format">Particularités physiques : <xsl:for-each select="did/physdesc/physfacet"><xsl:value-of select="." /><xsl:if test="position()!=last()"><xsl:text>. - </xsl:text></xsl:if></xsl:for-each></xsl:element>
              </xsl:if>
              <!-- dcterms:extent -->
              <!--<dcterms:extent><xsl:value-of select="did/physdesc/extent"/></dcterms:extent>-->
              <!-- dc:date -->
              <xsl:if test="did/unitdate">
                <xsl:for-each select="did/unitdate">
                  <xsl:element name="dc:date" namespace="http://purl.org/dc/elements/1.1/date">
                    <xsl:value-of select="@normal" />
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <xsl:if test="not(did/unitdate)">
                <xsl:if test="ancestor::*[self::archdesc or self::c][did/unitdate[@normal]][1]/did/unitdate/@normal">
                  <xsl:element name="dc:date" namespace="http://purl.org/dc/elements/1.1/date">
                    <xsl:value-of select="ancestor::*[self::archdesc or self::c][did/unitdate[@normal]][1]/did/unitdate/@normal" /> [date de l'ensemble]</xsl:element>
                </xsl:if>
              </xsl:if>
              <!-- dc:language -->
              <xsl:if test="did/langmaterial/language">
                <xsl:for-each select="did/langmaterial/language">
                  <xsl:element name="dc:language" namespace="http://purl.org/dc/elements/1.1/language">
                    <xsl:value-of select="@langcode" />
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <xsl:if test="not(did/langmaterial/language)">
                <xsl:if test="ancestor::*[self::archdesc or self::c][did/langmaterial/language[@langcode]][1]/did/langmaterial/language/@langcode">
                  <xsl:for-each select="ancestor::*[self::archdesc or self::c][did/langmaterial/language[@langcode]]/did/langmaterial/language/@langcode">
                    <xsl:element name="dc:language" namespace="http://purl.org/dc/elements/1.1/language">
                      <xsl:value-of select="." />
                    </xsl:element>
                  </xsl:for-each>
                </xsl:if>
              </xsl:if>
              <!-- dc:description -->
              <xsl:if test="scopecontent">
                <xsl:element name="dc:description" namespace="http://purl.org/dc/elements/1.1/description">
                  <xsl:for-each select="scopecontent/p">
                    <xsl:value-of select="." />
                    <xsl:if test="position()!=last()">
                      <xsl:text> - </xsl:text>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:element>
              </xsl:if>
              <!-- dc:type -->
              <!--<xsl:if test="child::*[not(self::c)]//genreform[@type='type de document']"><xsl:for-each select="child::*[not(self::c)]//genreform[@type='type de document']"><dc:type><xsl:value-of select="@normal"/></dc:type></xsl:for-each></xsl:if>-->
              <!--<xsl:if test="not(child::*[not(self::c)]//genreform[@type='type de document'])"><xsl:if test="ancestor::*[self::archdesc or self::c]/*[not(self::c)]//genreform[@type='type de document']"><dc:type><xsl:value-of select="ancestor::*[self::archdesc or self::c]/*[not(self::c)]//genreform[@type='type de document']/@normal"/> [TDD hérité]</dc:type></xsl:if></xsl:if>-->
              <xsl:choose>
                <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@type='type de document']">
                  <xsl:for-each select="*[not(self::dsc) and not(self::c)]//genreform[@type='type de document']">
                    <xsl:element name="dc:type" namespace="http://purl.org/dc/elements/1.1/type">
                      <xsl:attribute name="xml:lang">fre</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="dc:type" namespace="http://purl.org/dc/elements/1.1/type">
                      <xsl:attribute name="xml:lang">eng</xsl:attribute>
                      <xsl:call-template name="Template_DCMItype">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                </xsl:when>
                <xsl:when test="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//genreform[@type='type de document']">
                  <xsl:if test="not(*[not(self::dsc) and not(self::c)]//genreform[@type='type de document'])">
                    <xsl:for-each select="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//genreform[@type='type de document']">
                      <xsl:element name="dc:type" namespace="http://purl.org/dc/elements/1.1/type">
                        <xsl:attribute name="xml:lang">fre</xsl:attribute>
                        <xsl:call-template name="Template_normal">
                          <xsl:with-param name="node" select="." />
                        </xsl:call-template>
                      </xsl:element>
                      <xsl:element name="dc:type" namespace="http://purl.org/dc/elements/1.1/type">
                        <xsl:attribute name="xml:lang">eng</xsl:attribute>
                        <xsl:call-template name="Template_DCMItype">
                          <xsl:with-param name="node" select="." />
                        </xsl:call-template>
                      </xsl:element>
                    </xsl:for-each>
                  </xsl:if>
                </xsl:when>
              </xsl:choose>
              <!-- dc:source -->
              <!-- Suivant l'usage BnF, on y consigne une "mention conseillée" à l'instar de Prefercite en EAD : RCR + Cote -->
              <xsl:if test="did/unitid[@type='cote_actuelle' or @type='cote']">
                <xsl:element name="dc:source" namespace="http://purl.org/dc/elements/1.1/source">
                  <xsl:value-of select="$rcr" />
                  <xsl:text> - </xsl:text>
                  <xsl:value-of select="normalize-space(did/unitid[@type='cote_actuelle' or @type='cote'])" />
                </xsl:element>
              </xsl:if>
              <xsl:if test="not(did/unitid)">
                <xsl:if test="ancestor::*[self::archdesc or self::c][did/unitid[@type='cote_actuelle' or @type='cote']][1]/did/unitid[@type='cote_actuelle' or @type='cote']">
                  <xsl:element name="dc:source" namespace="http://purl.org/dc/elements/1.1/source">
                    <xsl:value-of select="$rcr" />
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="normalize-space(ancestor::*[self::archdesc or self::c][did/unitid[@type='cote_actuelle' or @type='cote']][1]/did/unitid[@type='cote_actuelle' or @type='cote'])" />
                    <xsl:text> [cote de l'ensemble]</xsl:text>
                  </xsl:element>
                </xsl:if>
              </xsl:if>
              <xsl:if test="did/unitid[@type='division']">
                <xsl:if test="ancestor::*[self::archdesc or self::c][did/unitid[@type='cote_actuelle' or @type='cote']][1]/did/unitid[@type='cote_actuelle' or @type='cote']">
                  <xsl:element name="dc:source" namespace="http://purl.org/dc/elements/1.1/source">
                    <xsl:value-of select="$rcr" />
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="normalize-space(ancestor::*[self::archdesc or self::c][did/unitid[@type='cote_actuelle' or @type='cote']][1]/did/unitid[@type='cote_actuelle' or @type='cote'])" />
                    <xsl:text> / </xsl:text>
                    <xsl:value-of select="normalize-space(did/unitid[@type='division'])" />
                  </xsl:element>
                </xsl:if>
              </xsl:if>
              <!-- dc:rights -->
              <xsl:if test="accessrestrict">
                <xsl:element name="dc:rights" namespace="http://purl.org/dc/elements/1.1/rights">
                  <xsl:for-each select="accessrestrict/p">
                    <xsl:value-of select="." />
                    <xsl:if test="position()!=last()">
                      <xsl:text> - </xsl:text>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:element>
              </xsl:if>
              <xsl:if test="userestrict">
                <xsl:element name="dc:rights" namespace="http://purl.org/dc/elements/1.1/rights">
                  <xsl:for-each select="userestrict/p">
                    <xsl:value-of select="." />
                    <xsl:if test="position()!=last()">
                      <xsl:text> - </xsl:text>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:element>
              </xsl:if>
              <xsl:if test="not(accessrestrict | userestrict)">
                <xsl:if test="ancestor::*[self::archdesc or self::c][userestrict | accessrestrict][1]">
                  <xsl:element name="dc:rights" namespace="http://purl.org/dc/elements/1.1/rights">
                    <xsl:for-each select="ancestor::*[self::archdesc or self::c][userestrict | accessrestrict][1]/*[self::userestrict | self::accessrestrict]/p">
                      <xsl:value-of select="." />
                      <xsl:if test="position()!=last()">
                        <xsl:text> - </xsl:text>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:element>
                </xsl:if>
              </xsl:if>
            </oai_dc>
          </metadata>
        </record>
      </xsl:for-each>
    </ListRecords></xsl:when>
      <xsl:otherwise>
        <erreur xsl:exclude-result-prefixes="dcterms xsi">Etes-vous sûr de la bonne construction de l'xpath saisi dans le champ "Filtre" de la fenêtre d'export ? Avez-vous bien modifié la valeur du champ "Filtre" donnée à titre d'exemple ? Ce type d'export nécessite de préciser un filtre, celui que vous avez utilisé ne correspond à aucun élément dans le document. Voir la documentation pour plus de précision : http://documentation.abes.fr/aidecalames/manuelcorrespondant/index.html#PrincipesExports.</erreur>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Template qui prend la valeur @normal d'un élément quand elle existe ; sinon, se contente de la valeur de l'élément. -->
  <xsl:template name="Template_normal">
    <xsl:param name="node" />
    <xsl:choose>
      <xsl:when test="$node/@normal">
        <xsl:value-of select="$node/@normal" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space($node)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Template de décodage des codes fonctions des points d'accès CPF -->
  <xsl:template name="Template_roles">
    <xsl:param name="node" />
    <xsl:if test="$node/@role='020'">
      <xsl:text> [Annotateur]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='070'">
      <xsl:text> [Auteur]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='100'">
      <xsl:text> [Auteur adapté]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='330'">
      <xsl:text> [Auteur supposé]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='commanditaire'">
      <xsl:text> [Commanditaire]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='212'">
      <xsl:text> [Commentateur]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='220'">
      <xsl:text> [Compilateur]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='700'">
      <xsl:text> [Copiste]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='280'">
      <xsl:text> [Dédicataire]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='660'">
      <xsl:text> [Destinataire de lettres]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='650'">
      <xsl:text> [Editeur commercial]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='340'">
      <xsl:text> [Editeur scienfitique]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='fabricant'">
      <xsl:text> [Fabricant]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='440'">
      <xsl:text> [Illustrateur]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='610'">
      <xsl:text> [Imprimeur ou éditeur]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='590'">
      <xsl:text> [Interprète]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='723'">
      <xsl:text> [Mécène]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='participant'">
      <xsl:text> [Participant]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='producteur'">
      <xsl:text> [Producteur du fonds ou Collectioneur]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='390'">
      <xsl:text> [Propriétaire précédent]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='110'">
      <xsl:text> [Relieur]</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@role='sujet'">
      <xsl:text> [Sujet]</xsl:text>
    </xsl:if>
  </xsl:template>
  <!-- Template de correspondance genreform TDD - DCMI types -->
  <xsl:template name="Template_DCMItype">
    <xsl:param name="node" />
    <xsl:if test="$node/@normal='texte imprimé'">
      <!--<xsl:attribute name="xmlns:dcterms">http://purl.org/dc/dcmitype/Text</xsl:attribute>-->
      <xsl:text>text</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@normal='texte manuscrit'">
      <xsl:text>text</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@normal='image fixe'">
      <xsl:text>still image</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@normal='images animées'">
      <xsl:text>moving image</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@normal='objet'">
      <xsl:text>physical object</xsl:text>
    </xsl:if>
    <xsl:if test="$node/@normal='enregistrement sonore'">
      <xsl:text>interactive resource</xsl:text>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>