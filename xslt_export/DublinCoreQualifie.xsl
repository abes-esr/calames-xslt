<xsl:stylesheet xmlns:dc="http://purl.org/dc" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" exclude-result-prefixes="dc">
  <!-- xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:local="urn:local" extension-element-prefixes="msxsl"> -->
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  <!-- conversion de ead vers Dublin Core : dans la variable filtre il peut y avoir : //c[@id='CGM-124567']. Attention les simple cote sont doublees -->
  <xsl:param name="filtre" />
  <!-- <msxsl:script language="CSharp" implements-prefix="local">public string dateTimeNow(){return DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ssZ");} </msxsl:script>-->
  <xsl:variable name="etab" select="/ead/archdesc/did/repository/corpname" />
  <xsl:variable name="rcr" select="/ead/archdesc/did/repository/corpname/@authfilenumber" />
  <xsl:variable name="intitule" select="/ead/archdesc/did/unittitle" />
  <xsl:template match="/">
    <ListRecords>
      <!--<collection xmlns="http://www.loc.gov/MARC21/slim" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">-->
      <xsl:for-each select="$filtre">
        <!--<xsl:for-each select="//c">-->
        <!--<xsl:for-each select="//c[../daogrp]">-->
        <!--<xsl:for-each select="//c[@id='cgm-1234578'']">-->
        <record>
          <header>
            <identifier>oai:oaicalames.abes.fr:<xsl:value-of select="@id" /></identifier>
            <!-- NB : le fonctionnement de Calames ne permet pas de connaitre la date et heure de l'export-->
            <datestamp>
              <!--<xsl:value-of select="local:dateTimeNow()"/>-->
            </datestamp>
            <setSpec>
              <xsl:value-of select="$rcr" />
            </setSpec>
          </header>
          <metadata>
            <oai_dc>
              <!-- dcterms:title -->
              <xsl:for-each select="did/unittitle">
                <xsl:element name="dcterms:title" namespace="http://purl.org/dc/terms/title">
                  <xsl:value-of select="." />
                </xsl:element>
              </xsl:for-each>
              <!-- dcterms:identifier -->
              <!-- Un élément par cote, division, ou ancienne cote. En cas de division : précédée de la 1ère cote parente. En cas d’absence d’unitid : récupère la première cote parente  -->
              <xsl:if test="did[not(unitid[@type='division'])]">
                <xsl:choose>
                  <xsl:when test="did/unitid[@type='cote_actuelle' or @type='cote']">
                    <xsl:element name="dcterms:identifier" namespace="http://purl.org/dc/terms/identifier">
                      <xsl:value-of select="normalize-space(did/unitid[@type='cote_actuelle' or @type='cote'])" />
                      <xsl:text> [cote]</xsl:text>
                    </xsl:element>
                  </xsl:when>
                  <xsl:when test="did/unitid[@type='ancienne_cote']">
                    <xsl:element name="dcterms:identifier" namespace="http://purl.org/dc/terms/identifier">
                      <xsl:value-of select="normalize-space(did/unitid[@type='ancienne_cote'])" />
                      <xsl:text> [ancienne cote]</xsl:text>
                    </xsl:element>
                  </xsl:when>
                  <xsl:when test="ancestor::*[self::archdesc or self::c][did/unitid[@type='cote_actuelle' or @type='cote']][1]/did/unitid[@type='cote_actuelle' or @type='cote']">
                    <xsl:element name="dcterms:identifier" namespace="http://purl.org/dc/terms/identifier">
                      <xsl:value-of select="normalize-space(ancestor::*[self::archdesc or self::c][did/unitid[@type='cote_actuelle' or @type='cote']][1]/did/unitid[@type='cote_actuelle' or @type='cote'])" />
                      <xsl:text> [cote de l'ensemble]</xsl:text>
                    </xsl:element>
                  </xsl:when>
                </xsl:choose>
              </xsl:if>
              <xsl:if test="did/unitid[@type='division']">
                <xsl:choose>
                  <xsl:when test="ancestor::*[self::archdesc or self::c][did/unitid[@type='cote_actuelle' or @type='cote']][1]/did/unitid[@type='cote_actuelle' or @type='cote']">
                    <xsl:element name="dcterms:identifier" namespace="http://purl.org/dc/terms/identifier">
                      <xsl:value-of select="normalize-space(ancestor::*[self::archdesc or self::c][did/unitid[@type='cote_actuelle' or @type='cote']][1]/did/unitid[@type='cote_actuelle' or @type='cote'])" />
                      <xsl:text> / </xsl:text>
                      <xsl:value-of select="normalize-space(did/unitid[@type='division'])" />
                      <xsl:text> [division de cote]</xsl:text>
                    </xsl:element>
                  </xsl:when>
                </xsl:choose>
              </xsl:if>
              <!-- dcterms:relation RCR -->
              <!-- RCR Calames (transformé en code ISIL international avec le préfixe 'FR-') -->
              <xsl:element name="dcterms:relation" namespace="http://purl.org/dc/terms/relation">
                <xsl:text>FR-</xsl:text>
                <xsl:value-of select="$rcr" />
                <xsl:text> [RCR établissement]</xsl:text>
              </xsl:element>
              <!-- dcterms:relation Fonds -->
              <xsl:element name="dcterms:relation" namespace="http://purl.org/dc/terms/relation">
                <xsl:value-of select="$intitule" />
                <xsl:text> [Fonds ou collection]</xsl:text>
              </xsl:element>
              <!-- dcterms:relation Permalien Calames, selon la pratique BnF -->
              <xsl:if test="@id">
                <xsl:element name="dcterms:relation" namespace="http://purl.org/dc/terms/relation">
                  <xsl:text>http://www.calames.abes.fr/pub/ms/</xsl:text>
                  <xsl:value-of select="@id" />
                  <xsl:comment>Permalien Calames</xsl:comment>
                </xsl:element>
              </xsl:if>
              <xsl:if test="not(@id)">
                <xsl:comment>Le permalien Calames ne peut pas être exporté. Le cas échéant, reportez l'identifiant de haut niveau du type "FileId-XX", où XX = numéro de fichier Calames, dans l'attribut ID de la balise Archdesc</xsl:comment>
              </xsl:if>
              <!-- Permalien Calames en DC Qualifié, possibilité suggérée par les Bonnes pratiques BnF : dcterms:isReferencedBy. Pas retenu au profit d'une interprétation plus littérale (ref. bibliographiques) -->
              <!--<xsl:element name="dcterms:isReferencedBy" namespace="http://purl.org/dc/terms/isReferencedBy"><xsl:attribute name="xsi:type">dcterms:URI</xsl:attribute><xsl:text>http://www.calames.abes.fr/pub/ms/</xsl:text><xsl:value-of select="@id"/></xsl:element>-->
              <!-- dcterms:creator -->
              <xsl:if test="*[not(self::dsc) and not(self::c)]//*[@role='070' or @role='100' or @role='330' or role='fabricant' or role='producteur']">
                <xsl:for-each select="*[not(self::dsc) and not(self::c)]//*[@role='070' or @role='330' or @role='100' or role='fabricant' or role='producteur']">
                  <xsl:element name="dcterms:creator" namespace="http://purl.org/dc/terms/creator">
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                    <xsl:call-template name="Template_roles">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <!-- complément dcterms:creator : recherche des points d'accès des niveaux supérieur dans l'arborescence EAD dans une logique d"héritage de l'indexation -->
              <xsl:if test="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//*[@role='070' or @role='100' or @role='330' or role='fabricant' or role='producteur']">
                <xsl:for-each select="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//*[@role='070' or @role='100' or @role='330' or role='fabricant' or role='producteur']">
                  <xsl:element name="dcterms:creator" namespace="http://purl.org/dc/terms/creator">
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                    <xsl:call-template name="Template_roles">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <!-- dcterms:contributor -->
              <xsl:if test="*[not(self::dsc) and not(self::c)]//*[@role = '020' or @role='110' or @role='700' or @role='280'  or @role='660' or @role='730' or @role='220' or @role='440' or @role='590' or @role='610' or @role='participant' or @role='commanditaire' or @role='723' or @role='340' or @role='650'  or @role='212']">
                <xsl:for-each select="*[not(self::dsc) and not(self::c)]//*[@role = '020' or @role='110' or @role='700' or @role='280'  or @role='660' or @role='730' or @role='220' or @role='440' or @role='590' or @role='610' or @role='participant' or @role='commanditaire' or @role='723' or @role='340' or @role='650'  or @role='212']">
                  <xsl:element name="dcterms:contributor" namespace="http://purl.org/dc/terms/contributor">
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                    <xsl:call-template name="Template_roles">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <!-- Complément dcterms:contributor : recherche des points d'accès des niveaux supérieur dans l'arborescence EAD dans une logique d"héritage de l'indexation -->
              <xsl:if test="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//*[@role = '020' or @role='110' or @role='700' or @role='280'  or @role='660' or @role='730' or @role='220' or @role='440' or @role='590' or @role='610' or @role='participant' or @role='commanditaire' or @role='723' or @role='340' or @role='650'  or @role='212']">
                <xsl:for-each select="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//*[@role = '020' or @role='110' or @role='700' or @role='280'  or @role='660' or @role='730' or @role='220' or @role='440' or @role='590' or @role='610' or @role='participant' or @role='commanditaire' or @role='723' or @role='340' or @role='650'  or @role='212']">
                  <xsl:element name="dcterms:contributor" namespace="http://purl.org/dc/terms/contributor">
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                    <xsl:call-template name="Template_roles">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <!-- dcterms:subject -->
              <!-- [not(preceding-sibling::*)] -->
              <xsl:if test="*[not(self::dsc) and not(self::c)]//*[self::subject[parent::controlaccess][not(preceding-sibling::*)] or self::subject[not(parent::controlaccess)] or self::geogname[not(@role)][parent::controlaccess][not(preceding-sibling::*)] or self::geogname[not(@role)][not(parent::controlaccess)]  or self::*[@role='sujet']]">
                <xsl:for-each select="*[not(self::dsc) and not(self::c)]//*[self::subject[parent::controlaccess][not(preceding-sibling::*)] or self::subject[not(parent::controlaccess)] or self::geogname[not(@role)][parent::controlaccess][not(preceding-sibling::*)] or self::geogname[not(@role)][not(parent::controlaccess)]  or self::*[@role='sujet']]">
                  <xsl:element name="dcterms:subject" namespace="http://purl.org/dc/terms/subject">
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <!-- Complément dcterms:subject : recherche des points d'accès des niveaux supérieurs dans l'arborescence EAD dans une logique d"héritage de l'indexation -->
              <xsl:if test="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//*[self::subject[parent::controlaccess][not(preceding-sibling::*)] or self::subject[not(parent::controlaccess)] or self::geogname[not(@role)][parent::controlaccess][not(preceding-sibling::*)] or self::geogname[not(@role)][not(parent::controlaccess)]  or self::*[@role='sujet']]">
                <xsl:for-each select="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//*[self::subject[parent::controlaccess][not(preceding-sibling::*)] or self::subject[not(parent::controlaccess)] or self::geogname[not(@role)][parent::controlaccess][not(preceding-sibling::*)] or self::geogname[not(@role)][not(parent::controlaccess)]  or self::*[@role='sujet']]">
                  <xsl:element name="dcterms:subject" namespace="http://purl.org/dc/terms/subject">
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <!-- dcterms:format Dimensions -->
              <xsl:if test="did/physdesc/dimensions">
                <xsl:element name="dcterms:format" namespace="http://purl.org/dc/terms/format">Dimensions : <xsl:value-of select="did/physdesc/dimensions" /></xsl:element>
              </xsl:if>
              <!-- dcterms:format Physfacet -->
              <xsl:if test="did/physdesc/physfacet[not(@type='support')][not(@type='materiau')]">
                <xsl:element name="dcterms:format" namespace="http://purl.org/dc/terms/format">Particularités physiques : <xsl:for-each select="did/physdesc/physfacet[not(@type='support')][not(@type='materiau')]"><xsl:value-of select="." /><xsl:if test="position()!=last()"><xsl:text>. - </xsl:text></xsl:if></xsl:for-each></xsl:element>
              </xsl:if>
              <!-- dcterms:date -->
              <!-- récupère l'unitdate du parent le plus proche si l'a pas unitdate en propre -->
              <xsl:choose>
                <xsl:when test="*[not(self::c or self::dsc)]//unitdate">
                  <xsl:for-each select="*[not(self::c or self::dsc)]//unitdate">
                    <xsl:element name="dcterms:date" namespace="http://purl.org/dc/terms/date">
                      <xsl:value-of select="@normal" />
                    </xsl:element>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="ancestor::*[self::archdesc or self::c][*[not(self::c or self::dsc)]//unitdate[@normal]][1]">
                    <xsl:element name="dcterms:date" namespace="http://purl.org/dc/terms/date">
                      <xsl:value-of select="ancestor::*[self::archdesc or self::c]/*[not(self::c or self::dsc)]//unitdate[@normal][1]/@normal" /> [date de l'ensemble]</xsl:element>
                  </xsl:if>
                </xsl:otherwise>
              </xsl:choose>
              <!-- dcterms:language -->
              <!-- récupère l'unitdate du parent le plus proche si l'a pas language en propre -->
              <xsl:if test="did/langmaterial/language">
                <xsl:for-each select="did/langmaterial/language">
                  <xsl:element name="dcterms:language" namespace="http://purl.org/dc/terms/language">
                    <xsl:value-of select="@langcode" />
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <xsl:if test="not(did/langmaterial/language)">
                <xsl:if test="ancestor::*[self::archdesc or self::c][did/langmaterial/language[@langcode]][1]/did/langmaterial/language/@langcode">
                  <xsl:for-each select="ancestor::*[self::archdesc or self::c][did/langmaterial/language[@langcode]]/did/langmaterial/language/@langcode">
                    <xsl:element name="dcterms:language" namespace="http://purl.org/dc/terms/language">
                      <xsl:value-of select="." />
                    </xsl:element>
                  </xsl:for-each>
                </xsl:if>
              </xsl:if>
              <!-- dcterms:description -->
              <xsl:if test="scopecontent">
                <xsl:element name="dcterms:description" namespace="http://purl.org/dc/terms/description">
                  <xsl:for-each select="scopecontent/p">
                    <xsl:value-of select="." />
                    <xsl:if test="position()!=last()">
                      <xsl:text> - </xsl:text>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:element>
              </xsl:if>
              <!-- dcterms:description : liste des sous-composants -->
              <xsl:if test="c">
                <xsl:element name="dcterms:description" namespace="http://purl.org/dc/terms/description">
                  <xsl:text>Contient (liste des sous-composants) : </xsl:text>
                  <xsl:for-each select="c">
                    <xsl:if test="did/unitid">
                      <xsl:text>[</xsl:text>
                      <xsl:value-of select="did/unitid/text()" />
                      <xsl:text>] </xsl:text>
                    </xsl:if>
                    <xsl:if test="did/unittitle">
                      <xsl:value-of select="did/unittitle/text()" />
                    </xsl:if>
                    <xsl:if test="position()!=last()">
                      <xsl:text> - </xsl:text>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:element>
              </xsl:if>
              <!-- dcterms:type -->
              <!--<xsl:if test="child::*[not(self::c)]//genreform[@type='type de document']"><xsl:for-each select="child::*[not(self::c)]//genreform[@type='type de document']"><dcterms:type><xsl:value-of select="@normal"/></dcterms:type></xsl:for-each></xsl:if>-->
              <!--<xsl:if test="not(child::*[not(self::c)]//genreform[@type='type de document'])"><xsl:if test="ancestor::*[self::archdesc or self::c]/*[not(self::c)]//genreform[@type='type de document']"><dcterms:type><xsl:value-of select="ancestor::*[self::archdesc or self::c]/*[not(self::c)]//genreform[@type='type de document']/@normal"/> [TDD hérité]</dcterms:type></xsl:if></xsl:if>-->
              <xsl:choose>
                <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@type='type de document']">
                  <xsl:for-each select="*[not(self::dsc) and not(self::c)]//genreform[@type='type de document']">
                    <xsl:element name="dcterms:type" namespace="http://purl.org/dc/terms/type">
                      <xsl:attribute name="xml:lang">fre</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="dcterms:type" namespace="http://purl.org/dc/terms/type">
                      <xsl:attribute name="xml:lang">eng</xsl:attribute>
                      <xsl:call-template name="Template_DCMItype">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                </xsl:when>
                <!-- Complément dcterms:type : recherche des points d'accès des niveaux supérieurs dans l'arborescence EAD dans une logique d"héritage de l'indexation -->
                <xsl:when test="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//genreform[@type='type de document']">
                  <xsl:if test="not(*[not(self::dsc) and not(self::c)]//genreform[@type='type de document'])">
                    <xsl:for-each select="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//genreform[@type='type de document']">
                      <xsl:element name="dcterms:type" namespace="http://purl.org/dc/terms/type">
                        <xsl:attribute name="xml:lang">fre</xsl:attribute>
                        <xsl:call-template name="Template_normal">
                          <xsl:with-param name="node" select="." />
                        </xsl:call-template>
                      </xsl:element>
                      <xsl:element name="dcterms:type" namespace="http://purl.org/dc/terms/type">
                        <xsl:attribute name="xml:lang">eng</xsl:attribute>
                        <xsl:call-template name="Template_DCMItype">
                          <xsl:with-param name="node" select="." />
                        </xsl:call-template>
                      </xsl:element>
                    </xsl:for-each>
                  </xsl:if>
                </xsl:when>
              </xsl:choose>
              <!-- dcterms:source -->
              <!-- Suivant l'usage BnF, on y consigne une "mention conseillée" à l'instar de Prefercite en EAD : RCR + Cote [+ division le cas échéant)] -->
              <xsl:if test="did/unitid[@type='cote_actuelle' or @type='cote']">
                <xsl:element name="dcterms:source" namespace="http://purl.org/dc/terms/source">
                  <xsl:value-of select="$rcr" />
                  <xsl:text> - </xsl:text>
                  <xsl:value-of select="normalize-space(did/unitid[@type='cote_actuelle' or @type='cote'])" />
                </xsl:element>
              </xsl:if>
              <xsl:if test="not(did/unitid)">
                <xsl:if test="ancestor::*[self::archdesc or self::c][did/unitid[@type='cote_actuelle' or @type='cote']][1]/did/unitid[@type='cote_actuelle' or @type='cote']">
                  <xsl:element name="dcterms:source" namespace="http://purl.org/dc/terms/source">
                    <xsl:value-of select="$rcr" />
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="normalize-space(ancestor::*[self::archdesc or self::c][did/unitid[@type='cote_actuelle' or @type='cote']][1]/did/unitid[@type='cote_actuelle' or @type='cote'])" />
                    <xsl:text> [cote de l'ensemble]</xsl:text>
                  </xsl:element>
                </xsl:if>
              </xsl:if>
              <xsl:if test="did/unitid[@type='division']">
                <xsl:if test="ancestor::*[self::archdesc or self::c][did/unitid[@type='cote_actuelle' or @type='cote']][1]/did/unitid[@type='cote_actuelle' or @type='cote']">
                  <xsl:element name="dcterms:source" namespace="http://purl.org/dc/terms/source">
                    <xsl:value-of select="$rcr" />
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="normalize-space(ancestor::*[self::archdesc or self::c][did/unitid[@type='cote_actuelle' or @type='cote']][1]/did/unitid[@type='cote_actuelle' or @type='cote'])" />
                    <xsl:text> / </xsl:text>
                    <xsl:value-of select="normalize-space(did/unitid[@type='division'])" />
                  </xsl:element>
                </xsl:if>
              </xsl:if>
              <!-- dcterms:rights pour userestrict-->
              <xsl:if test="userestrict">
                <xsl:element name="dcterms:rights" namespace="http://purl.org/dc/terms/rights">
                  <xsl:for-each select="userestrict/p">
                    <xsl:value-of select="." />
                    <xsl:if test="position()!=last()">
                      <xsl:text> - </xsl:text>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:element>
              </xsl:if>
              <xsl:if test="not(userestrict)">
                <xsl:if test="ancestor::*[self::archdesc or self::c][userestrict][1]">
                  <xsl:element name="dcterms:rights" namespace="http://purl.org/dc/terms/rights">
                    <xsl:for-each select="ancestor::*[self::archdesc or self::c][userestrict][1]/*[self::userestrict]/p">
                      <xsl:value-of select="." />
                      <xsl:if test="position()!=last()">
                        <xsl:text> - </xsl:text>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:element>
                </xsl:if>
              </xsl:if>
              <!-- dcterms:accessRights pour accessrestrict-->
              <xsl:if test="accessrestrict">
                <xsl:element name="dcterms:accesRights" namespace="http://purl.org/dc/terms/accessRights">
                  <xsl:for-each select="accessrestrict/p">
                    <xsl:value-of select="." />
                    <xsl:if test="position()!=last()">
                      <xsl:text> - </xsl:text>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:element>
              </xsl:if>
              <!-- Complément dcterms:accessRights : recherche des points d'accès des niveaux supérieurs dans l'arborescence EAD dans une logique d"héritage de l'indexation -->
              <xsl:if test="not(accessrestrict)">
                <xsl:if test="ancestor::*[self::archdesc or self::c][accessrestrict][1]">
                  <xsl:element name="dcterms:accesRights" namespace="http://purl.org/dc/terms/accessRights">
                    <xsl:for-each select="ancestor::*[self::archdesc or self::c][accessrestrict][1]/*[self::accessrestrict]/p">
                      <xsl:value-of select="." />
                      <xsl:if test="position()!=last()">
                        <xsl:text> - </xsl:text>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:element>
                </xsl:if>
              </xsl:if>
              <!-- dcterms:accrualPolicy pour accruals, sans application d'héritage -->
              <xsl:if test="accruals">
                <xsl:element name="dcterms:accrualPolicy" namespace="http://purl.org/dc/terms/accrualPolicy">
                  <xsl:for-each select="accruals/p">
                    <xsl:value-of select="." />
                    <xsl:if test="position()!=last()">
                      <xsl:text> - </xsl:text>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:element>
              </xsl:if>
              <!-- dcterms:extent pour extent (hors dcterms:format) -->
              <xsl:if test="did/physdesc/extent">
                <xsl:element name="dcterms:extent" namespace="http://purl.org/dc/terms/extent">Importance matérielle : <xsl:value-of select="did/physdesc/extent" /></xsl:element>
              </xsl:if>
              <!-- dcterms:hasPart contient le(s) permalien(s) du ou des niveau(x) descriptif(s) enfant(s) -->
              <xsl:if test="child::c">
                <xsl:for-each select="child::c">
                  <xsl:element name="dcterms:hasPart" namespace="http://purl.org/dc/terms/hasPart">
                    <xsl:text>http://www.calames.abes.fr/pub/ms/</xsl:text>
                    <xsl:value-of select="@id" />
                    <xsl:comment>Permalien Calames d'un élément enfant</xsl:comment>
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <!-- dcterms:isPartOf contient le permalien du niveau descriptif parent (c, ou archdesc dont l'ID doit être "artificiellement" renseigné) -->
              <xsl:if test="parent::c">
                <xsl:for-each select="parent::c">
                  <xsl:element name="dcterms:isPartOf" namespace="http://purl.org/dc/terms/isPartOf">
                    <xsl:text>http://www.calames.abes.fr/pub/ms/</xsl:text>
                    <xsl:value-of select="@id" />
                    <xsl:comment>Permalien Calames de l'élément parent</xsl:comment>
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <xsl:if test="parent::dsc">
                <xsl:if test="/ead/archdesc/@id">
                  <xsl:element name="dcterms:isPartOf" namespace="http://purl.org/dc/terms/isPartOf">
                    <xsl:text>http://www.calames.abes.fr/pub/ms/</xsl:text>
                    <xsl:value-of select="/ead/archdesc/@id" />
                    <xsl:comment>Permalien Calames de l'élément parent</xsl:comment>
                  </xsl:element>
                </xsl:if>
                <xsl:if test="/ead/archdesc[not(@id)]">
                  <xsl:comment>L'élément dcterms:isPartOf (permalien Calames de l'élément parent) ne peut pas être exporté : reportez l'identifiant de haut niveau du type "FileId-XX", où XX = numéro de fichier Calames, dans l'attribut ID de Archdesc</xsl:comment>
                </xsl:if>
              </xsl:if>
              <!-- dcterms:isReferencedBy pour les réféfences bibliographiques (structurées) mentionnées en niveau local -->
              <!--    <xsl:if test="../bibliography/head">-->
              <!--    [<xsl:value-of select="preceding-sibling::head"/> : ]-->
              <xsl:if test="bibliography/bibref">
                <xsl:for-each select="bibliography/bibref">
                  <xsl:element name="dcterms:isReferencedBy" namespace="http://purl.org/dc/terms/isReferencedBy">
                    <xsl:value-of select="." />
                    <xsl:if test="@href">
                      <xsl:text>[Lien : </xsl:text>
                      <xsl:value-of select="@href" />
                      <xsl:text>]</xsl:text>
                    </xsl:if>
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <!-- dcterms:medium pour physfacet de type support ou materiau (les autres sous-éléments de physdesc restent en dcterms:format) -->
              <xsl:if test="did/physdesc/physfacet[@type='support']">
                <xsl:element name="dcterms:medium" namespace="http://purl.org/dc/terms/medium">Support : <xsl:for-each select="did/physdesc/physfacet[@type='support']"><xsl:value-of select="." /><xsl:if test="position()!=last()"><xsl:text>. - </xsl:text></xsl:if></xsl:for-each></xsl:element>
              </xsl:if>
              <xsl:if test="did/physdesc/physfacet[@type='materiau']">
                <xsl:element name="dcterms:medium" namespace="http://purl.org/dc/terms/medium">Matériau : <xsl:for-each select="did/physdesc/physfacet[@type='materiau']"><xsl:value-of select="." /><xsl:if test="position()!=last()"><xsl:text>. - </xsl:text></xsl:if></xsl:for-each></xsl:element>
              </xsl:if>
              <!-- dcterms:provenance  pour les éléments custodhist, acqinfo et note type provenance ; ainsi que les CPF rôle 390 locaux ou hérités (informations retirées de dcterms:contributor par conséquent) -->
              <!-- définition de dcterms:provenance d'après DCMI vocabuylary : "a statement of any changes in ownership and custody of the resource since its creation that are significant for its authenticity, integrity, and interpretation" -->
              <xsl:if test="*[not(self::dsc) and not(self::c)]//*[@role='390']">
                <xsl:for-each select="*[not(self::dsc) and not(self::c)]//*[@role='390']">
                  <xsl:element name="dcterms:provenance" namespace="http://purl.org/dc/terms/provenance">
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                    <xsl:call-template name="Template_roles">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <xsl:if test="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//*[@role='390']">
                <xsl:for-each select="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//*[@role='390']">
                  <xsl:element name="dcterms:provenance" namespace="http://purl.org/dc/terms/provenance">
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                    <xsl:call-template name="Template_roles">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                </xsl:for-each>
              </xsl:if>
              <xsl:if test="note[@type='provenance'] | custodhist | acqinfo">
                <xsl:for-each select="acqinfo/p">
                  <xsl:element name="dcterms:provenance" namespace="http://purl.org/dc/terms/provenance">Modalités d'entrée dans la collection : <xsl:value-of select="." /><xsl:if test="position()!=last()"><xsl:text> - </xsl:text></xsl:if></xsl:element>
                </xsl:for-each>
                <xsl:for-each select="custodhist/p">
                  <xsl:element name="dcterms:provenance" namespace="http://purl.org/dc/terms/provenance">Provenance : <xsl:value-of select="." /><xsl:if test="position()!=last()"><xsl:text> - </xsl:text></xsl:if></xsl:element>
                </xsl:for-each>
                <xsl:for-each select="note[@type='provenance']/p">
                  <xsl:element name="dcterms:provenance" namespace="http://purl.org/dc/terms/provenance">Provenance : <xsl:value-of select="." /><xsl:if test="position()!=last()"><xsl:text> - </xsl:text></xsl:if></xsl:element>
                </xsl:for-each>
              </xsl:if>
            </oai_dc>
          </metadata>
        </record>
      </xsl:for-each>
    </ListRecords>
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