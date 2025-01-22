<xsl:stylesheet xmlns="http://www.loc.gov/MARC21/slim" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" exclude-result-prefixes="dc">
 
  <!-- attention - cette conversion n'est pas a jour de l'unimarc : encore 210 au lieu de 214 notamment-->
  
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  <xsl:param name="filtre" /> 
  <xsl:variable name="rcr" select="/ead/archdesc/did/repository/corpname/@authfilenumber" />
  <xsl:template match="/"><xsl:choose>
    <xsl:when test="$filtre != ''">	
    <collection xmlns="http://www.loc.gov/MARC21/slim" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
      <xsl:for-each select="$filtre">
       <record>
          <leader>
            <xsl:text>     nbm  22     1n 4500</xsl:text>
          </leader>
          <!-- 001 Identifiant notice  -->
          <xsl:choose>
            <xsl:when test="@id">
              <xsl:element name="controlfield">
                <xsl:attribute name="tag">001</xsl:attribute>
                <xsl:value-of select="normalize-space(@id)" />
              </xsl:element>
            </xsl:when>
            <xsl:when test="not(@id)">
              <xsl:element name="controlfield">
                <xsl:attribute name="tag">001</xsl:attribute>
                <xsl:text>[Absence d'identifiant ou id. de haut niveau]</xsl:text>
              </xsl:element>
            </xsl:when>
          </xsl:choose>
          <!-- 003 Permalien ABES  -->
          <xsl:if test="@id">
            <xsl:element name="controlfield">
              <xsl:attribute name="tag">003</xsl:attribute>
              <xsl:text>https://www.calames.abes.fr/pub/ms/</xsl:text>
              <xsl:value-of select="normalize-space(@id)" />
            </xsl:element>
          </xsl:if>
          <!-- 100 données générales de traitement : pas de date d'enregistrement -->
          <xsl:element name="datafield">
            <xsl:attribute name="ind1">
              <xsl:text> </xsl:text>
            </xsl:attribute>
            <xsl:attribute name="ind2">
              <xsl:text> </xsl:text>
            </xsl:attribute>
            <xsl:attribute name="tag">100</xsl:attribute>
            <xsl:element name="subfield">
              <xsl:attribute name="code">a</xsl:attribute>
              <xsl:variable name="date_c" select="child::*[not(self::dsc) and not(self::c)]//unitdate/@normal" />
              <xsl:variable name="date_ancestor1" select="./ancestor::*[self::c or self::archdesc]/child::*[not(self::dsc) and not(self::c)][//unitdate/@normal]//unitdate/@normal" />
              <!-- Dates de publication -->
              <xsl:choose>
                <xsl:when test="$date_c">
                  <xsl:call-template name="date100">
                    <xsl:with-param name="date_chemin" select="$date_c" />
                  </xsl:call-template>
                </xsl:when>
                <xsl:when test="$date_ancestor1">
                  <xsl:call-template name="date100">
                    <xsl:with-param name="date_chemin" select="$date_ancestor1" />
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>        u        </xsl:text>
                </xsl:otherwise>
              </xsl:choose>
              <!-- Types de public sur 3 positions : -->
              <xsl:text>k  </xsl:text>
              <!-- varia : -->
              <xsl:text>y0frey</xsl:text>
              <!-- selon export utf8 ou pas : si utf8 : -->
              <xsl:text>50      </xsl:text>
              <!-- Alphabet du titre  : en fonction de @scriptcode, sinon 'ba' par défaut JMF 12 nov. 2010.  -->
              <xsl:choose>
                <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Cyrl']">
                  <xsl:text>ca</xsl:text>
                </xsl:when>
                <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Jpan']">
                  <xsl:text>da</xsl:text>
                </xsl:when>
                <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Hans']">
                  <xsl:text>ea</xsl:text>
                </xsl:when>
                <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Arab']">
                  <xsl:text>fa</xsl:text>
                </xsl:when>
                <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Grek']">
                  <xsl:text>ga</xsl:text>
                </xsl:when>
                <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Hebr']">
                  <xsl:text>ha</xsl:text>
                </xsl:when>
                <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Thai']">
                  <xsl:text>ia</xsl:text>
                </xsl:when>
                <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Deva']">
                  <xsl:text>ja</xsl:text>
                </xsl:when>
                <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Kore']">
                  <xsl:text>ka</xsl:text>
                </xsl:when>
                <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Taml']">
                  <xsl:text>la</xsl:text>
                </xsl:when>
                <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Geor']">
                  <xsl:text>ma</xsl:text>
                </xsl:when>
                <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Armn']">
                  <xsl:text>mb</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>ba</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
          </xsl:element>
          <!-- 101 Langue du document : en principe, tout c doit avoir une langue, directement ou indirectement, via ancêtre -->
          <xsl:choose>
            <xsl:when test="did/langmaterial/language/@langcode">
              <xsl:element name="datafield">
                <xsl:attribute name="ind1">
                  <xsl:text>|</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="ind2">
                  <xsl:text> </xsl:text>
                </xsl:attribute>
                <xsl:attribute name="tag">101</xsl:attribute>
                <xsl:for-each select="did/langmaterial/language/@langcode">
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:value-of select="normalize-space(.)" />
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:when>
            <xsl:when test="ancestor::*[self::archdesc or self::c]/did/langmaterial/language/@langcode">
              <xsl:element name="datafield">
                <xsl:attribute name="ind1">
                  <xsl:text> </xsl:text>
                </xsl:attribute>
                <xsl:attribute name="ind2">
                  <xsl:text> </xsl:text>
                </xsl:attribute>
                <xsl:attribute name="tag">101</xsl:attribute>
                <xsl:for-each select="(ancestor::*[self::c or self::archdesc]/did/langmaterial)[position()=last()]/language">
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:value-of select="normalize-space(@langcode)" />
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:when>
          </xsl:choose>
          <!-- Zones 181 et 182 : type de contenu et type de médiation. Aucun distingo entre Texte imprimé et Texte manuscrit. Zones $a et $b utilisées pour les exports ISBD (et non $c à l'usage de RDA). Ajouté après mise en production dans Sudoc en novembre 2014. -->
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@type='type de document'] | ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@type='type de document'] ">
              <xsl:choose>
                <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='image fixe']">
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">181</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>b#</xsl:text>
                    </xsl:element>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">b</xsl:attribute>
                      <xsl:text>xb2e##</xsl:text>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">182</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>n</xsl:text>
                    </xsl:element>
                  </xsl:element>
                </xsl:when>
                <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='image fixe']">
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">181</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>b#</xsl:text>
                    </xsl:element>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">b</xsl:attribute>
                      <xsl:text>xb2e##</xsl:text>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">182</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>n</xsl:text>
                    </xsl:element>
                  </xsl:element>
                </xsl:when>
                <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='texte imprimé']">
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">181</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>i#</xsl:text>
                    </xsl:element>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">b</xsl:attribute>
                      <xsl:text>xxxe##</xsl:text>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">182</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>n</xsl:text>
                    </xsl:element>
                  </xsl:element>
                </xsl:when>
                <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='texte imprimé']">
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">181</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>i#</xsl:text>
                    </xsl:element>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">b</xsl:attribute>
                      <xsl:text>xxxe##</xsl:text>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">182</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>n</xsl:text>
                    </xsl:element>
                  </xsl:element>
                </xsl:when>
                <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='images animées']">
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">181</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>b#</xsl:text>
                    </xsl:element>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">b</xsl:attribute>
                      <xsl:text>xa2e##</xsl:text>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">182</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>g</xsl:text>
                    </xsl:element>
                  </xsl:element>
                </xsl:when>
                <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='images animées']">
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">181</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>b#</xsl:text>
                    </xsl:element>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">b</xsl:attribute>
                      <xsl:text>xa2e##</xsl:text>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">182</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>g</xsl:text>
                    </xsl:element>
                  </xsl:element>
                </xsl:when>
                <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='enregistrement sonore']">
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">181</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>g#</xsl:text>
                    </xsl:element>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">b</xsl:attribute>
                      <xsl:text>xxxa##</xsl:text>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">182</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>a</xsl:text>
                    </xsl:element>
                  </xsl:element>
                </xsl:when>
                <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='enregistrement sonore']">
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">181</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>g#</xsl:text>
                    </xsl:element>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">b</xsl:attribute>
                      <xsl:text>xxxa##</xsl:text>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">182</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>a</xsl:text>
                    </xsl:element>
                  </xsl:element>
                </xsl:when>
                <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='objet']">
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">181</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>e#</xsl:text>
                    </xsl:element>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">b</xsl:attribute>
                      <xsl:text>xx3d##</xsl:text>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">182</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>n</xsl:text>
                    </xsl:element>
                  </xsl:element>
                </xsl:when>
                <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='objet']">
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">181</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>e#</xsl:text>
                    </xsl:element>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">b</xsl:attribute>
                      <xsl:text>xx3d##</xsl:text>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">182</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>n</xsl:text>
                    </xsl:element>
                  </xsl:element>
                </xsl:when>
                <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='ressource électronique']">
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">181</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>i#</xsl:text>
                    </xsl:element>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">b</xsl:attribute>
                      <xsl:text>xxxe##</xsl:text>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">182</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>b</xsl:text>
                    </xsl:element>
                  </xsl:element>
                </xsl:when>
                <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='ressource électronique']">
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">181</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>i#</xsl:text>
                    </xsl:element>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">b</xsl:attribute>
                      <xsl:text>xxxe##</xsl:text>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">182</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>b</xsl:text>
                    </xsl:element>
                  </xsl:element>
                </xsl:when>
                <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='texte manuscrit']">
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">181</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>i#</xsl:text>
                    </xsl:element>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">b</xsl:attribute>
                      <xsl:text>xxxe##</xsl:text>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">182</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>n</xsl:text>
                    </xsl:element>
                  </xsl:element>
                </xsl:when>
                <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='texte manuscrit']">
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">181</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>i#</xsl:text>
                    </xsl:element>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">b</xsl:attribute>
                      <xsl:text>xxxe##</xsl:text>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="datafield">
                    <xsl:attribute name="ind1">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                      <xsl:text> </xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tag">182</xsl:attribute>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>n</xsl:text>
                    </xsl:element>
                  </xsl:element>
                </xsl:when>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="datafield">
                <xsl:attribute name="ind1">
                  <xsl:text> </xsl:text>
                </xsl:attribute>
                <xsl:attribute name="ind2">
                  <xsl:text> </xsl:text>
                </xsl:attribute>
                <xsl:attribute name="tag">181</xsl:attribute>
                <xsl:element name="subfield">
                  <xsl:attribute name="code">a</xsl:attribute>
                  <xsl:text>i#</xsl:text>
                </xsl:element>
                <xsl:element name="subfield">
                  <xsl:attribute name="code">b</xsl:attribute>
                  <xsl:text>xxxe##</xsl:text>
                </xsl:element>
              </xsl:element>
              <xsl:element name="datafield">
                <xsl:attribute name="ind1">
                  <xsl:text> </xsl:text>
                </xsl:attribute>
                <xsl:attribute name="ind2">
                  <xsl:text> </xsl:text>
                </xsl:attribute>
                <xsl:attribute name="tag">182</xsl:attribute>
                <xsl:element name="subfield">
                  <xsl:attribute name="code">a</xsl:attribute>
                  <xsl:text>n</xsl:text>
                </xsl:element>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
          <!-- 200 Titre sans sous-titre -->
          <!-- Dédoublement de unittitle -->
          <xsl:choose>
            <!-- titre en caractères latins -->
            <xsl:when test="did/unittitle[@type]">
              <xsl:for-each select="did/unittitle[not(@type)] | did/unittitle[@type='traduction']">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text>1</xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">200</xsl:attribute>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">6</xsl:attribute>
                    <xsl:text>01</xsl:text>
                  </xsl:element>
                  <!-- ...sous-zone 200 $7 code d'écriture -->
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">7</xsl:attribute>
                    <xsl:text>ba</xsl:text>
                  </xsl:element>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:value-of select="normalize-space(.)" />
                  </xsl:element>
                  <!--  ...prise en compte des genreform type de document en 200$b sept. 2012 -->
                  <xsl:choose>
                    <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@type='type de document'] | ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@type='type de document'] ">
                      <xsl:choose>
                        <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='image fixe']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Image fixe</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='image fixe']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Image fixe</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='texte imprimé']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Texte imprimé</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='texte imprimé']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Texte imprimé</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='images animées']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Images animées</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='images animées']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Images animées</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='enregistrement sonore']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Enregistrement sonore</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='enregistrement sonore']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Enregistrement sonore</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='objet']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Objet</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='objet']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Objet</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='ressource électronique']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Ressource électronique</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='ressource électronique']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Ressource électronique</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='texte manuscrit']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Texte manuscrit</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='texte manuscrit']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Texte manuscrit</xsl:text>
                          </xsl:element>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">b</xsl:attribute>
                        <xsl:text>Texte manuscrit</xsl:text>
                      </xsl:element>
                    </xsl:otherwise>
                  </xsl:choose>
                  <!-- ...mentions de responsabilité  -->
                  <xsl:choose>
                    <xsl:when test="*[not(self::dsc) and not(self::c)]//*[@role='producteur' or @role='070' or @role='340' or @role='650' or @role='330' or @role='100' or @role='212' or role='fabricant']">
                      <xsl:for-each select="*[not(self::dsc) and not(self::c)]//*[@role='producteur' or @role='070' or @role='340' or @role='650' or @role='330' or @role='100' or @role='212' or role='fabricant']">
                        <xsl:element name="subfield">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="code">f</xsl:attribute>
                            <xsl:value-of select="." />
                          </xsl:if>
                          <xsl:if test="position() &gt; 1">
                            <xsl:attribute name="code">g</xsl:attribute>
                            <xsl:value-of select="." />
                          </xsl:if>
                        </xsl:element>
                      </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="rechercheancetre">
                        <xsl:with-param name="ancetre" select="ancestor::*[self::archdesc or self::c][*[not(self::dsc) and not(self::c)]//*[@role='070' or @role='340' or @role='650' or @role='330' or @role='100' or @role='212' or role='fabricant']][1]" />
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:element>
              </xsl:for-each>
              <!-- titre en caractères non-latins -->
              <xsl:for-each select="did/unittitle[@type='translittération'] | did/unittitle[@type='non-latin originel'] | did/unittitle[@type='non-latin alternatif']">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text>1</xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">200</xsl:attribute>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">6</xsl:attribute>
                    <xsl:text>02</xsl:text>
                  </xsl:element>
                  <!-- ...sous-zone 200 $7 code d'écriture -->
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">7</xsl:attribute>
                    <xsl:choose>
                      <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Cyrl']">
                        <xsl:text>ca</xsl:text>
                      </xsl:when>
                      <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Jpan']">
                        <xsl:text>da</xsl:text>
                      </xsl:when>
                      <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Hans']">
                        <xsl:text>ea</xsl:text>
                      </xsl:when>
                      <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Arab']">
                        <xsl:text>fa</xsl:text>
                      </xsl:when>
                      <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Grek']">
                        <xsl:text>ga</xsl:text>
                      </xsl:when>
                      <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Hebr']">
                        <xsl:text>ha</xsl:text>
                      </xsl:when>
                      <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Thai']">
                        <xsl:text>ia</xsl:text>
                      </xsl:when>
                      <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Deva']">
                        <xsl:text>ja</xsl:text>
                      </xsl:when>
                      <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Kore']">
                        <xsl:text>ka</xsl:text>
                      </xsl:when>
                      <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Taml']">
                        <xsl:text>la</xsl:text>
                      </xsl:when>
                      <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Geor']">
                        <xsl:text>ma</xsl:text>
                      </xsl:when>
                      <xsl:when test="ancestor-or-self::*/did/langmaterial/language[@scriptcode='Armn']">
                        <xsl:text>mb</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>ba</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:element>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:value-of select="normalize-space(.)" />
                  </xsl:element>
                  <!-- ...prise en compte des genreform type de document en 200$b sept. 2012 -->
                  <xsl:choose>
                    <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@type='type de document'] | ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@type='type de document'] ">
                      <xsl:choose>
                        <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='image fixe']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Image fixe</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='image fixe']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Image fixe</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='texte imprimé']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Texte imprimé</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='texte imprimé']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Texte imprimé</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='images animées']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Images animées</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='images animées']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Images animées</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='enregistrement sonore']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Enregistrement sonore</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='enregistrement sonore']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Enregistrement sonore</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='objet']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Objet</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='objet']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Objet</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='ressource électronique']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Ressource électronique</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='ressource électronique']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Ressource électronique</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='texte manuscrit']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Texte manuscrit</xsl:text>
                          </xsl:element>
                        </xsl:when>
                        <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='texte manuscrit']">
                          <xsl:element name="subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:text>Texte manuscrit</xsl:text>
                          </xsl:element>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">b</xsl:attribute>
                        <xsl:text>Texte manuscrit</xsl:text>
                      </xsl:element>
                    </xsl:otherwise>
                  </xsl:choose>
                  <!-- ....mentions de responsabilité  -->
                  <xsl:choose>
                    <xsl:when test="*[not(self::dsc) and not(self::c)]//*[@role='producteur' or @role='070'  or @role='340' or @role='650' or @role='330' or @role='100' or @role='212' or role='fabricant']">
                      <xsl:for-each select="*[not(self::dsc) and not(self::c)]//*[@role='producteur' or @role='070' or @role='340' or @role='650' or @role='330' or @role='100' or @role='212' or role='fabricant']">
                        <xsl:element name="subfield">
                          <xsl:if test="position() = 1">
                            <xsl:attribute name="code">f</xsl:attribute>
                            <xsl:value-of select="." />
                          </xsl:if>
                          <xsl:if test="position() &gt; 1">
                            <xsl:attribute name="code">g</xsl:attribute>
                            <xsl:value-of select="." />
                          </xsl:if>
                        </xsl:element>
                      </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="rechercheancetre">
                        <xsl:with-param name="ancetre" select="ancestor::*[self::archdesc or self::c][*[not(self::dsc) and not(self::c)]//*[@role='070' or @role='340' or @role='650' or @role='330' or @role='100' or @role='212' or role='fabricant']][1]" />
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <!-- Cas standard : un seul unittitle -->
            <xsl:otherwise>
              <xsl:element name="datafield">
                <xsl:attribute name="ind1">
                  <xsl:text>1</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="ind2">
                  <xsl:text> </xsl:text>
                </xsl:attribute>
                <xsl:attribute name="tag">200</xsl:attribute>
                <xsl:element name="subfield">
                  <xsl:attribute name="code">a</xsl:attribute>
                  <xsl:if test="did/unittitle[not(@type)]">
                    <xsl:value-of select="normalize-space(did/unittitle)" />
                  </xsl:if>
                  <!-- ALERTE - s'il n'y a pas de unittitle, seulement unitid -->
                  <xsl:if test="not(did/unittitle)">
                    <xsl:text>SANS TITRE</xsl:text>
                  </xsl:if>
                </xsl:element>
                <!-- Prise en compte des genreform type de document en 200$b sept. 2012 -->
                <xsl:choose>
                  <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@type='type de document'] | ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@type='type de document'] ">
                    <xsl:choose>
                      <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='image fixe']">
                        <xsl:element name="subfield">
                          <xsl:attribute name="code">b</xsl:attribute>
                          <xsl:text>Image fixe</xsl:text>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='image fixe']">
                        <xsl:element name="subfield">
                          <xsl:attribute name="code">b</xsl:attribute>
                          <xsl:text>Image fixe</xsl:text>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='texte imprimé']">
                        <xsl:element name="subfield">
                          <xsl:attribute name="code">b</xsl:attribute>
                          <xsl:text>Texte imprimé</xsl:text>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='texte imprimé']">
                        <xsl:element name="subfield">
                          <xsl:attribute name="code">b</xsl:attribute>
                          <xsl:text>Texte imprimé</xsl:text>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='images animées']">
                        <xsl:element name="subfield">
                          <xsl:attribute name="code">b</xsl:attribute>
                          <xsl:text>Images animées</xsl:text>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='images animées']">
                        <xsl:element name="subfield">
                          <xsl:attribute name="code">b</xsl:attribute>
                          <xsl:text>Images animées</xsl:text>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='enregistrement sonore']">
                        <xsl:element name="subfield">
                          <xsl:attribute name="code">b</xsl:attribute>
                          <xsl:text>Enregistrement sonore</xsl:text>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='enregistrement sonore']">
                        <xsl:element name="subfield">
                          <xsl:attribute name="code">b</xsl:attribute>
                          <xsl:text>Enregistrement sonore</xsl:text>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='objet']">
                        <xsl:element name="subfield">
                          <xsl:attribute name="code">b</xsl:attribute>
                          <xsl:text>Objet</xsl:text>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='objet']">
                        <xsl:element name="subfield">
                          <xsl:attribute name="code">b</xsl:attribute>
                          <xsl:text>Objet</xsl:text>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='ressource électronique']">
                        <xsl:element name="subfield">
                          <xsl:attribute name="code">b</xsl:attribute>
                          <xsl:text>Ressource électronique</xsl:text>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='ressource électronique']">
                        <xsl:element name="subfield">
                          <xsl:attribute name="code">b</xsl:attribute>
                          <xsl:text>Ressource électronique</xsl:text>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@normal='texte manuscrit']">
                        <xsl:element name="subfield">
                          <xsl:attribute name="code">b</xsl:attribute>
                          <xsl:text>Texte manuscrit</xsl:text>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@normal='texte manuscrit']">
                        <xsl:element name="subfield">
                          <xsl:attribute name="code">b</xsl:attribute>
                          <xsl:text>Texte manuscrit</xsl:text>
                        </xsl:element>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">b</xsl:attribute>
                      <xsl:text>Texte manuscrit</xsl:text>
                    </xsl:element>
                  </xsl:otherwise>
                </xsl:choose>
                <!-- mentions de responsabilité  -->
                <xsl:choose>
                  <xsl:when test="*[not(self::dsc) and not(self::c)]//*[@role='producteur' or @role='070' or @role='340' or @role='650' or @role='330' or @role='100' or @role='212' or role='fabricant']">
                    <xsl:for-each select="*[not(self::dsc) and not(self::c)]//*[@role='producteur' or @role='070' or @role='340' or @role='650' or @role='330' or @role='100' or @role='212' or role='fabricant']">
                      <xsl:element name="subfield">
                        <xsl:if test="position() = 1">
                          <xsl:attribute name="code">f</xsl:attribute>
                          <xsl:value-of select="." />
                        </xsl:if>
                        <xsl:if test="position() &gt; 1">
                          <xsl:attribute name="code">g</xsl:attribute>
                          <xsl:value-of select="." />
                        </xsl:if>
                      </xsl:element>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="rechercheancetre">
                      <xsl:with-param name="ancetre" select="ancestor::*[self::archdesc or self::c][*[not(self::dsc) and not(self::c)]//*[@role='070' or @role='340' or @role='650' or @role='330' or @role='100' or @role='212' or role='fabricant']][1]" />
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
          <!-- 210 Adresse bibliographique -->
          <!-- par défaut sans lieu et sans nom d'éditeur, variable seulement date et sans date -->
          <xsl:element name="datafield">
            <xsl:attribute name="ind1">
              <xsl:text> </xsl:text>
            </xsl:attribute>
            <!-- nouveauté unimarc 2008 : -->
            <xsl:attribute name="ind2">
              <xsl:text>1</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="tag">210</xsl:attribute>
            <xsl:element name="subfield">
              <xsl:attribute name="code">a</xsl:attribute>
              <xsl:text>[S.l.]</xsl:text>
            </xsl:element>
            <xsl:element name="subfield">
              <xsl:attribute name="code">c</xsl:attribute>
              <xsl:text>[S.n.]</xsl:text>
            </xsl:element>
            <!-- ERM : 210$d pcdata de unitdate qui peut être dans soit dans c/*/unidate archdesc/*/unitdate-->
            <!-- Date : va chercher l'ancêtre. Prend la forme entre balises, pas la forme normal : -->
            <xsl:element name="subfield">
              <xsl:attribute name="code">d</xsl:attribute>   
              <xsl:choose>
                <xsl:when test="./child::*[not(self::dsc)][not(self::c)]//unitdate[normalize-space(text()!='')]">
                  <xsl:for-each select="./child::*[not(self::dsc)][not(self::c)]//unitdate[normalize-space(text()!='')][1]">                  
                    <xsl:value-of select="normalize-space(text())"/>
                  </xsl:for-each>
                </xsl:when>
                <xsl:when test="./ancestor::c[1]/*[not(self::c)]//unitdate[normalize-space(text()!='')]">
                  <xsl:for-each
                    select="./ancestor::c[1]/*[not(self::c)]//unitdate[normalize-space(text()!='')][1]">
                    <xsl:value-of select="normalize-space(text())"/>                  
                  </xsl:for-each>
                </xsl:when>
                <xsl:when test="//archdesc/*[not(self::dsc)]//unitdate[normalize-space(text()!='')]">
                  <xsl:for-each
                    select="//archdesc/*[not(self::dsc)]//unitdate[normalize-space(text()!='')][1]">
                    <xsl:value-of select="normalize-space(text())"/>                  
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>[S.d.]</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
          </xsl:element>
          <!-- 215 Collation  -->
          <!-- $a (type de document et importance matérielle) extrait de extent (seulement importance matérielle, mais souvent avec typologie matérielle) -->
          <!-- $c (autres caractéristiques matérielles) extrait de physfacet[@type='illustration' or 'support'] -->
          <!-- $d (format) extrait de dimensions -->
          <xsl:if test="did/physdesc">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">215</xsl:attribute>
              <xsl:if test="did/physdesc/extent">
                <xsl:element name="subfield">
                  <xsl:attribute name="code">a</xsl:attribute>
                  <xsl:value-of select="normalize-space(did/physdesc/extent)" />
                </xsl:element>
              </xsl:if>
              <xsl:if test="did/physdesc/physfacet[@type='illustration' or @type='support']">
                <xsl:element name="subfield">
                  <xsl:attribute name="code">c</xsl:attribute>
                  <xsl:for-each select="did/physdesc/physfacet[@type='illustration' or @type='support']">
                    <xsl:choose>
                      <xsl:when test="position() != last()">
                        <xsl:value-of select="normalize-space(.)" />
                        <xsl:text>, </xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="normalize-space(.)" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </xsl:element>
              </xsl:if>
              <xsl:if test="did/physdesc/dimensions">
                <xsl:element name="subfield">
                  <xsl:attribute name="code">d</xsl:attribute>
                  <xsl:value-of select="normalize-space(did/physdesc/dimensions)" />
                </xsl:element>
              </xsl:if>
            </xsl:element>
          </xsl:if>
          <!-- 300 Note générale -->
          <!-- note=absent -->
          <xsl:if test="note[@type='absent']">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">300</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">a</xsl:attribute>
                <xsl:value-of select="normalize-space(note[@type='absent'])" />
              </xsl:element>
            </xsl:element>
          </xsl:if>
          <!-- Autres instruments de recherche -->
          <xsl:if test="otherfindaid">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">300</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">a</xsl:attribute>
                <xsl:text>Autre instrument de recherche : </xsl:text>
                <xsl:choose>
                  <xsl:when test="count(otherfindaid/p) &gt; 1">
                    <xsl:for-each select="otherfindaid/p">
                      <xsl:choose>
                        <xsl:when test="position() != last()">
                          <xsl:value-of select="concat(normalize-space(.), ' ; ')" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="normalize-space(.)" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(otherfindaid)" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:element>
          </xsl:if>
          <!-- Documents séparés -->
          <xsl:if test="separatedmaterial">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">300</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">a</xsl:attribute>
                <xsl:text>Documents separes : </xsl:text>
                <xsl:choose>
                  <xsl:when test="count(separatedmaterial/p) &gt; 1">
                    <xsl:for-each select="separatedmaterial/p">
                      <xsl:choose>
                        <xsl:when test="position() != last()">
                          <xsl:value-of select="concat(normalize-space(.), ' ; ')" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="normalize-space(.)" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(separatedmaterial)" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:element>
          </xsl:if>
          <!-- Documents en relation -->
          <xsl:if test="relatedmaterial">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">300</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">a</xsl:attribute>
                <xsl:text>Documents en relation : </xsl:text>
                <xsl:choose>
                  <xsl:when test="count(relatedmaterial/p) &gt; 1">
                    <xsl:for-each select="relatedmaterial/p">
                      <xsl:choose>
                        <xsl:when test="position() != last()">
                          <xsl:value-of select="concat(normalize-space(.), ' ; ')" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="normalize-space(.)" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(relatedmaterial)" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:element>
          </xsl:if>
          <!-- Particularité de certains type de documents -->
          <xsl:if test="did/materialspec">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">300</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">a</xsl:attribute>
                <xsl:text>Particularité de certains types de documents : </xsl:text>
                <xsl:value-of select="normalize-space(did/materialspec)" />
              </xsl:element>
            </xsl:element>
          </xsl:if>
          <!-- 303 Note générale sur la description bibliographique physfacet[@type='ecriture']  -->
          <xsl:for-each select="did/physdesc/physfacet[@type='ecriture']">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">303</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">a</xsl:attribute>
                <xsl:value-of select="normalize-space(.)" />
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
          <!-- 307 Note sur la collation -->
          <xsl:for-each select="did/physdesc/physfacet[@type='autre']">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">307</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">a</xsl:attribute>
                <xsl:value-of select="normalize-space(.)" />
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
          <!-- 310 Note sur la reliure et la disponibilité -->
          <xsl:if test="ancestor-or-self::*/accessrestrict">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">310</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">a</xsl:attribute>
                <xsl:choose>
                  <xsl:when test="count(ancestor-or-self::*/accessrestrict[last()]/p) &gt; 1">
                    <xsl:for-each select="ancestor-or-self::*/accessrestrict[last()]/p">
                      <xsl:choose>
                        <xsl:when test="position() != last()">
                          <xsl:value-of select="concat(normalize-space(.), ' ; ')" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="normalize-space(.)" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(ancestor-or-self::*/accessrestrict[last()]/p)" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:element>
          </xsl:if>
          <!-- 310 Note sur la reliure et la disponibilité : USERESTRICT. Ajout JMF 12 nov. 2010-->
          <xsl:if test="ancestor-or-self::*/userestrict">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">310</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">a</xsl:attribute>
                <xsl:choose>
                  <xsl:when test="count(ancestor-or-self::*/userestrict[last()]/p) &gt; 1">
                    <xsl:for-each select="ancestor-or-self::*/userestrict[last()]/p">
                      <xsl:choose>
                        <xsl:when test="position() != last()">
                          <xsl:value-of select="concat(normalize-space(.), ' ; ')" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="normalize-space(.)" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(ancestor-or-self::*/userestrict[last()]/p)" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:element>
          </xsl:if>
          <!-- 316 Note sur l'exemplaire physfacet[@type='reliure'] -->
          <xsl:for-each select="did/physdesc/physfacet[@type='reliure']">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">316</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">a</xsl:attribute>
                <xsl:value-of select="normalize-space(.)" />
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
          <!-- 317 Note sur la provenance -->
          <xsl:for-each select="acqinfo | note[@type = 'provenance'] | custodhist">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">317</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">a</xsl:attribute>
                <xsl:choose>
                  <xsl:when test="count(./p) &gt; 1">
                    <xsl:for-each select="./p">
                      <xsl:choose>
                        <xsl:when test="position() != last()">
                          <xsl:value-of select="concat(normalize-space(.), ' ; ')" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="normalize-space(.)" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(./p)" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
          <!-- 321 Note sur la bibliographie -->
          <!-- Pour chaque bibliography, un 321 contenant un seul $a avec le contenu de head : concaténation des bibref avec séparateur ponctuation espace tiret-->
          <xsl:for-each select="bibliography">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text>1</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">321</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">a</xsl:attribute>
                <xsl:if test="./head">
                  <xsl:value-of select="concat(normalize-space(head), ' : ')" />
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="p">
                    <xsl:value-of select="normalize-space(p)" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each select=".//bibref">
                      <xsl:choose>
                        <xsl:when test="position() != last()">
                          <xsl:value-of select="concat(normalize-space(.), ' - ')" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="normalize-space(.)" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
          <!-- 324 Note sur le document original -->
          <xsl:if test="originalsloc">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">324</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">a</xsl:attribute>
                <xsl:choose>
                  <xsl:when test="count(originalsloc/p) &gt; 1">
                    <xsl:for-each select="originalsloc/p">
                      <xsl:choose>
                        <xsl:when test="position() != last()">
                          <xsl:value-of select="concat(normalize-space(.), ' ; ')" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="normalize-space(.)" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(originalsloc/p)" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:element>
          </xsl:if>
          <!-- 325 Note sur la reproduction -->
          <xsl:if test="altformavail">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">325</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">a</xsl:attribute>
                <xsl:choose>
                  <xsl:when test="count(altformavail/p) &gt; 1">
                    <xsl:for-each select="altformavail/p">
                      <xsl:choose>
                        <xsl:when test="position() != last()">
                          <xsl:value-of select="concat(normalize-space(.), ' ; ')" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="normalize-space(.)" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(altformavail/p)" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:element>
          </xsl:if>
          <!-- 325 Liens dao et daogrp (plutôt qu'en 456, car la notion de reproduction est moins stricte dans l'usage des dao/daogrp) -->
         <xsl:if test="dao[@href]">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">325</xsl:attribute>
              <xsl:for-each select="dao">
                <xsl:choose>
                  <xsl:when test="./@title!=''">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:for-each select="./@title">
                        <xsl:value-of select="normalize-space(.)" />
                      </xsl:for-each>
                    </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>[Reproduction numérique]</xsl:text>
                    </xsl:element>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:element name="subfield">
                  <xsl:attribute name="code">u</xsl:attribute>
                  <xsl:for-each select="./@href">
                    <xsl:value-of select="normalize-space(.)" />
                  </xsl:for-each>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:if>
          <xsl:if test="daogrp/daoloc[@role='rebond'][@href]">
            <xsl:for-each select="daogrp/daoloc[@role='rebond'][@href]">
              <xsl:element name="datafield">
                <xsl:attribute name="ind1">
                  <xsl:text> </xsl:text>
                </xsl:attribute>
                <xsl:attribute name="ind2">
                  <xsl:text> </xsl:text>
                </xsl:attribute>
                <xsl:attribute name="tag">325</xsl:attribute>
                <xsl:choose>
                  <xsl:when test="./@title!=''">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:for-each select="./@title">
                        <xsl:value-of select="normalize-space(.)" />
                      </xsl:for-each>
                    </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">a</xsl:attribute>
                      <xsl:text>[Reproduction numérique]</xsl:text>
                    </xsl:element>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:element name="subfield">
                  <xsl:attribute name="code">u</xsl:attribute>
                  <xsl:for-each select="./@href">
                    <xsl:value-of select="normalize-space(.)" />
                  </xsl:for-each>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:if>
          <!-- 327 Note de contenu : scopecontent -->
          <xsl:if test="scopecontent">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text>1</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">327</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">a</xsl:attribute>
                <xsl:text>Description du contenu : </xsl:text>
                <xsl:for-each select="scopecontent/p">
                  <xsl:choose>
                    <xsl:when test="position() != last()">
                      <xsl:value-of select="normalize-space(.)" />
                      <xsl:text> ; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="normalize-space(.)" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:element>
            </xsl:element>
          </xsl:if>
          <!-- 327 Note de contenu :  liste des divisions d'une cote -->
          <xsl:if test="c">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text>1</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">327</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">a</xsl:attribute>
                <xsl:text>Contient : </xsl:text>
                <xsl:for-each select="c">
                  <xsl:choose>
                    <xsl:when test="position() != last()">
                      <xsl:if test="./did/unitid[@type != 'ancienne_cote']">
                        <xsl:value-of select="normalize-space(./did/unitid[@type != 'ancienne_cote'])" />
                        <xsl:text> </xsl:text>
                      </xsl:if>
                      <xsl:if test="./did/unittitle">
                        <xsl:value-of select="normalize-space(./did/unittitle)" />
                      </xsl:if>
                      <xsl:text> ; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="./did/unitid[@type != 'ancienne_cote']">
                        <xsl:value-of select="normalize-space(./did/unitid[@type != 'ancienne_cote'])" />
                        <xsl:text> </xsl:text>
                      </xsl:if>
                      <xsl:if test="./did/unittitle">
                        <xsl:value-of select="normalize-space(./did/unittitle)" />
                      </xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:element>
            </xsl:element>
          </xsl:if>
          <!-- 461 Niveau de l'ensemble : Indication de la hiérarchie des parents  -->
          <!-- Enchaînement des titres de tous les niveaux depuis l'archdesc jusqu'au composant -->
          <xsl:if test="name(.) != 'archdesc'">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">461</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">t</xsl:attribute>
                <xsl:value-of select="normalize-space(/ead/archdesc/did/unittitle)" />
                <xsl:for-each select="ancestor::c">
                  <xsl:text> -- </xsl:text>
                  <xsl:value-of select="normalize-space(did/unittitle)" />
                </xsl:for-each>
              </xsl:element>
            </xsl:element>
          </xsl:if>
          <!-- 517 Autres variantes du tittre : Mention du titre d'ensemble quand le manuscrit est  dans un groupe de cotes -->
          <!-- Si le niveau père est 'groupe-de-notice', alors on extrait le titre -->
          <!-- Ajout JMF fév. 2013 : 517 en cas de second unittitle en caractères non latins -->
          <xsl:if test="parent::c[@otherlevel='groupe-de-notices']">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text>1</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">517</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">a</xsl:attribute>
                <xsl:value-of select="normalize-space(parent::c[@otherlevel='groupe-de-notices']/did/unittitle)" />
              </xsl:element>
            </xsl:element>
          </xsl:if>
          <xsl:if test="did/unittitle[2]">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text>1</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">517</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">a</xsl:attribute>
                <xsl:value-of select="normalize-space(did/unittitle[2])" />
              </xsl:element>
            </xsl:element>
          </xsl:if>
          <!-- 600  Nom de personne - vedette matière -->
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//persname[@role='sujet' or @role='producteur'][not(parent::controlaccess[./*[2]])]">
              <xsl:for-each select="*[not(self::dsc) and not(self::c)]//persname[@role='sujet' or @role='producteur'][not(parent::controlaccess[./*[2]])]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">600</xsl:attribute>
                  <xsl:if test="@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="ancestor::*[self::archdesc or self::c][/child::*[not(self::dsc) and not(self::c)]//persname[@role='sujet']][1]/child::*[not(self::dsc) and not(self::c)]//persname[@role='sujet'][not(parent::controlaccess[./*[2]])]">
              <xsl:for-each select="ancestor::*[self::archdesc or self::c][/child::*[not(self::dsc) and not(self::c)]//persname[@role='sujet']][1]/child::*[not(self::dsc) and not(self::c)]//persname[@role='sujet'][not(parent::controlaccess[./*[2]])]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">600</xsl:attribute>
                  <xsl:if test="@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
          <!-- traitement des persname avec subdivisions, sauf auteur-titre en 604 -->
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//persname[1][parent::controlaccess[./*[2]]][not(following-sibling::title)]">
              <xsl:for-each select="*[not(self::dsc) and not(self::c)]//persname[1][parent::controlaccess[./*[2]]][not(following-sibling::title)]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">600</xsl:attribute>
                  <xsl:if test="./@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:for-each select="following-sibling::subject">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">x</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:for-each select="following-sibling::geogname">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">y</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="ancestor::*[self::archdesc or self::c][/child::*[not(self::dsc) and not(self::c)]//persname[@role='sujet']][1]/child::*[not(self::dsc) and not(self::c)]//persname[@role='sujet'][parent::controlaccess[./*[2]]][not(following-sibling::title)]">
              <xsl:for-each select="ancestor::*[self::archdesc or self::c][/child::*[not(self::dsc) and not(self::c)]//persname[@role='sujet']][1]/child::*[not(self::dsc) and not(self::c)]//persname[@role='sujet'][parent::controlaccess[./*[2]]][not(following-sibling::title)]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">600</xsl:attribute>
                  <xsl:if test="./@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:for-each select="following-sibling::subject">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">x</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:for-each select="following-sibling::geogname">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">y</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
          <!-- 601  Collectivité  - vedette matière -->
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//corpname[@role='sujet' or @role='producteur'][not(parent::controlaccess[./*[2]])]">
              <xsl:for-each select="*[not(self::dsc) and not(self::c)]//corpname[@role='sujet' or @role='producteur'][not(parent::controlaccess[./*[2]])]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">601</xsl:attribute>
                  <xsl:if test="@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//corpname[@role='sujet'][not(parent::controlaccess[./*[2]])]">
              <xsl:for-each select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//corpname[@role='sujet'][not(parent::controlaccess[./*[2]])]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">601</xsl:attribute>
                  <xsl:if test="@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
          <!-- traitement des corpname avec subdivisions -->
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//corpname[1][parent::controlaccess[./*[2]]]">
              <xsl:for-each select="*[not(self::dsc) and not(self::c)]//corpname[1][parent::controlaccess[./*[2]]]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">601</xsl:attribute>
                  <xsl:if test="./@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:for-each select="following-sibling::subject">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">x</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:for-each select="following-sibling::geogname">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">y</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//corpname[1][parent::controlaccess[./*[2]]]">
              <xsl:for-each select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//corpname[1][parent::controlaccess[./*[2]]]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">601</xsl:attribute>
                  <xsl:if test="./@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:for-each select="following-sibling::subject">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">x</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:for-each select="following-sibling::geogname">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">y</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
          <!-- 602  Nom de famille  - vedette matière -->
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//famname[@role='sujet' or @role='producteur'][not(parent::controlaccess[./*[2]])]">
              <xsl:for-each select="*[not(self::dsc) and not(self::c)]//famname[@role='sujet' or @role='producteur'][not(parent::controlaccess[./*[2]])]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">602</xsl:attribute>
                  <xsl:if test="@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//famname[@role='sujet'][not(parent::controlaccess[./*[2]])]">
              <xsl:for-each select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//famname[@role='sujet'][not(parent::controlaccess[./*[2]])]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">602</xsl:attribute>
                  <xsl:if test="@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
          <!-- traitement des famname avec subdivisions -->
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//famname[1][parent::controlaccess[./*[2]]]">
              <xsl:for-each select="*[not(self::dsc) and not(self::c)]//famname[1][parent::controlaccess[./*[2]]]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">602</xsl:attribute>
                  <xsl:if test="./@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:for-each select="following-sibling::subject">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">x</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:for-each select="following-sibling::geogname">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">y</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//famname[1][parent::controlaccess[./*[2]]]">
              <xsl:for-each select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//famname[1][parent::controlaccess[./*[2]]]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">602</xsl:attribute>
                  <xsl:if test="./@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:for-each select="following-sibling::subject">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">x</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:for-each select="following-sibling::geogname">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">y</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
          <!-- 604 Auteur-Titre -->
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//persname[1][parent::controlaccess[./*[2]]][following-sibling::title]">
              <xsl:for-each select="*[not(self::dsc) and not(self::c)]//persname[1][parent::controlaccess[./*[2]]][following-sibling::title]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">604</xsl:attribute>
                  <xsl:if test="./@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:for-each select="following-sibling::title">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">t</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="ancestor::*[self::archdesc or self::c][/child::*[not(self::dsc) and not(self::c)]//persname[@role='sujet']][1]/child::*[not(self::dsc) and not(self::c)]//persname[@role='sujet'][parent::controlaccess[./*[2]]][following-sibling::title]">
              <xsl:for-each select="ancestor::*[self::archdesc or self::c][/child::*[not(self::dsc) and not(self::c)]//persname[@role='sujet']][1]/child::*[not(self::dsc) and not(self::c)]//persname[@role='sujet'][parent::controlaccess[./*[2]]][following-sibling::title]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">604</xsl:attribute>
                  <xsl:if test="./@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:for-each select="following-sibling::title">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">t</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
          <!-- 605 Titre  - vedette matière  -->
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//title[not(parent::controlaccess[./*[2]])][not(preceding-sibling::persname)]">
              <xsl:for-each select="*[not(self::dsc) and not(self::c)]//title[not(parent::controlaccess[./*[2]])][not(preceding-sibling::persname)]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">605</xsl:attribute>
                  <xsl:if test="@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//title[not(parent::controlaccess[./*[2]])][not(preceding-sibling::persname)]">
              <xsl:for-each select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//title[not(parent::controlaccess[./*[2]])][not(preceding-sibling::persname)]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">605</xsl:attribute>
                  <xsl:if test="@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
          <!-- Traitement des title avec subdivisions -->
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//title[1][parent::controlaccess[./*[2]]][not(preceding-sibling::persname)]">
              <xsl:for-each select="*[not(self::dsc) and not(self::c)]//title[1][parent::controlaccess[./*[2]]][not(preceding-sibling::persname)]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">605</xsl:attribute>
                  <xsl:if test="./@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:for-each select="following-sibling::subject">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">x</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:for-each select="following-sibling::geogname">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">y</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//title[1][parent::controlaccess[./*[2]]][not(preceding-sibling::persname)]">
              <xsl:for-each select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//title[1][parent::controlaccess[./*[2]]][not(preceding-sibling::persname)]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">605</xsl:attribute>
                  <xsl:if test="./@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:for-each select="following-sibling::subject">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">x</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:for-each select="following-sibling::geogname">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">y</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
          <!-- 606  Nom commun  - vedette matière -->
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//subject[@source='Sudoc'][not(parent::controlaccess[./*[2]])]">
              <xsl:for-each select="*[not(self::dsc) and not(self::c)]//subject[@source='Sudoc'][not(parent::controlaccess[./*[2]])]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">606</xsl:attribute>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">3</xsl:attribute>
                    <xsl:value-of select="normalize-space(@authfilenumber)" />
                  </xsl:element>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">2</xsl:attribute>
                    <xsl:text>Rameau</xsl:text>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//subject[@source='Sudoc'][not(parent::controlaccess[./*[2]])]">
              <xsl:for-each select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//subject[@source='Sudoc'][not(parent::controlaccess[./*[2]])]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">606</xsl:attribute>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">3</xsl:attribute>
                    <xsl:value-of select="normalize-space(@authfilenumber)" />
                  </xsl:element>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">2</xsl:attribute>
                    <xsl:text>Rameau</xsl:text>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
          <!-- Traitement des subject avec subdivisions -->
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//subject[1][@source='Sudoc'][parent::controlaccess[./*[2]]]">
              <xsl:for-each select="*[not(self::dsc) and not(self::c)]//subject[1][@source='Sudoc'][parent::controlaccess[./*[2]]]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">606</xsl:attribute>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">3</xsl:attribute>
                    <xsl:value-of select="normalize-space(@authfilenumber)" />
                  </xsl:element>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:for-each select="following-sibling::subject">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">x</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:for-each select="following-sibling::geogname">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">y</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">2</xsl:attribute>
                    <xsl:text>Rameau</xsl:text>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//subject[1][@source='Sudoc'][parent::controlaccess[./*[2]]]">
              <xsl:for-each select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//subject[1][@source='Sudoc'][parent::controlaccess[./*[2]]]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">606</xsl:attribute>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">3</xsl:attribute>
                    <xsl:value-of select="normalize-space(@authfilenumber)" />
                  </xsl:element>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:for-each select="following-sibling::subject">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">x</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:for-each select="following-sibling::geogname">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">y</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">2</xsl:attribute>
                    <xsl:text>Rameau</xsl:text>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
          <!-- 607  Nom géographique  - vedette matière -->
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//geogname[not(parent::controlaccess[./*[2]])]">
              <xsl:for-each select="*[not(self::dsc) and not(self::c)]//geogname[not(parent::controlaccess[./*[2]])]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">607</xsl:attribute>
                  <xsl:if test="@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//geogname[not(parent::controlaccess[./*[2]])]">
              <xsl:for-each select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//geogname[not(parent::controlaccess[./*[2]])]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">607</xsl:attribute>
                  <xsl:if test="@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
              <xsl:if test="./@source='Sudoc'">
                <xsl:element name="subfield">
                  <xsl:attribute name="code">2</xsl:attribute>
                  <xsl:text>Rameau</xsl:text>
                </xsl:element>
              </xsl:if>
            </xsl:when>
          </xsl:choose>
          <!-- Traitement des geogname avec subdivisions -->
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//geogname[1][parent::controlaccess[./*[2]]]">
              <xsl:for-each select="*[not(self::dsc) and not(self::c)]//geogname[1][parent::controlaccess[./*[2]]]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">607</xsl:attribute>
                  <xsl:if test="./@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:for-each select="following-sibling::subject">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">x</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:for-each select="following-sibling::geogname">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">y</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//geogname[1][parent::controlaccess[./*[2]]]">
              <xsl:for-each select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//geogname[1][parent::controlaccess[./*[2]]]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">607</xsl:attribute>
                  <xsl:if test="./@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:for-each select="following-sibling::subject">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">x</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:for-each select="following-sibling::geogname">
                    <xsl:if test="./@authfilenumber">
                      <xsl:element name="subfield">
                        <xsl:attribute name="code">3</xsl:attribute>
                        <xsl:value-of select="normalize-space(@authfilenumber)" />
                      </xsl:element>
                    </xsl:if>
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">y</xsl:attribute>
                      <xsl:call-template name="Template_normal">
                        <xsl:with-param name="node" select="." />
                      </xsl:call-template>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:if test="./@source='Sudoc'">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">2</xsl:attribute>
                      <xsl:text>Rameau</xsl:text>
                    </xsl:element>
                  </xsl:if>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
          <!-- 608 Genreform GFF et technique -->
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@type='technique']">
              <xsl:for-each select="*[not(self::dsc) and not(self::c)]//genreform[@type='technique']">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">608</xsl:attribute>
                  <xsl:if test="@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">2</xsl:attribute>
                    <xsl:text>calames</xsl:text>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@type='technique']">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">608</xsl:attribute>
                  <xsl:if test="@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">2</xsl:attribute>
                    <xsl:text>calames</xsl:text>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//genreform[@type='genre, forme et fonction']">
              <xsl:for-each select="*[not(self::dsc) and not(self::c)]//genreform[@type='genre, forme et fonction']">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">608</xsl:attribute>
                  <xsl:if test="@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">2</xsl:attribute>
                    <xsl:text>calames</xsl:text>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//genreform[@type='genre, forme et fonction']">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">608</xsl:attribute>
                  <xsl:if test="@authfilenumber">
                    <xsl:element name="subfield">
                      <xsl:attribute name="code">3</xsl:attribute>
                      <xsl:value-of select="normalize-space(@authfilenumber)" />
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">2</xsl:attribute>
                    <xsl:text>calames</xsl:text>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
          <!-- 610 Indexation en vocabulaire libre -->
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//subject[not(@source='Sudoc')][not(parent::controlaccess[./*[2]])]">
              <xsl:for-each select="*[not(self::dsc) and not(self::c)]//subject[not(@source='Sudoc')][not(parent::controlaccess[./*[2]])]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">610</xsl:attribute>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//subject[not(@source='Sudoc')][not(parent::controlaccess[./*[2]])]">
                <xsl:element name="datafield">
                  <xsl:attribute name="ind1">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="ind2">
                    <xsl:text> </xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="tag">610</xsl:attribute>
                  <xsl:element name="subfield">
                    <xsl:attribute name="code">a</xsl:attribute>
                    <xsl:call-template name="Template_normal">
                      <xsl:with-param name="node" select="." />
                    </xsl:call-template>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
          <!-- mentions de responsabilité principale -->
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//*[@role='producteur' or @role='070' or @role='340' or @role='650' or @role='330' or @role='100' or @role='212' or role='fabricant']">
              <xsl:for-each select="*[not(self::dsc) and not(self::c)]//*[@role='producteur' or @role='070' or @role='340' or @role='650' or @role='330' or @role='100' or @role='212' or role='fabricant']">
                <xsl:choose>
                  <xsl:when test="name(.) = 'persname'">
                    <xsl:if test="position() = 1">
                      <xsl:call-template name="Template_7XX">
                        <xsl:with-param name="zone_7XX">700</xsl:with-param>
                      </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="position() != 1">
                      <xsl:call-template name="Template_7XX">
                        <xsl:with-param name="zone_7XX">701</xsl:with-param>
                      </xsl:call-template>
                    </xsl:if>
                  </xsl:when>
                  <xsl:when test="name(.) = 'corpname'">
                    <xsl:if test="position() = 1">
                      <xsl:call-template name="Template_7XX">
                        <xsl:with-param name="zone_7XX">710</xsl:with-param>
                      </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="position() != 1">
                      <xsl:call-template name="Template_7XX">
                        <xsl:with-param name="zone_7XX">711</xsl:with-param>
                      </xsl:call-template>
                    </xsl:if>
                  </xsl:when>
                  <xsl:when test="name(.) = 'famname'">
                    <xsl:if test="position() = 1">
                      <xsl:call-template name="Template_7XX">
                        <xsl:with-param name="zone_7XX">720</xsl:with-param>
                      </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="position() != 1">
                      <xsl:call-template name="Template_7XX">
                        <xsl:with-param name="zone_7XX">721</xsl:with-param>
                      </xsl:call-template>
                    </xsl:if>
                  </xsl:when>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]//*[@role='070' or @role='340' or @role='650' or @role='330' or @role='100' or @role='212' or role='fabricant']">
                <xsl:choose>
                  <xsl:when test="name(.) = 'persname'">
                    <xsl:if test="position() = 1">
                      <xsl:call-template name="Template_7XX">
                        <xsl:with-param name="zone_7XX">700</xsl:with-param>
                      </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="position() != 1">
                      <xsl:call-template name="Template_7XX">
                        <xsl:with-param name="zone_7XX">701</xsl:with-param>
                      </xsl:call-template>
                    </xsl:if>
                  </xsl:when>
                  <xsl:when test="name(.) = 'corpname'">
                    <xsl:if test="position() = 1">
                      <xsl:call-template name="Template_7XX">
                        <xsl:with-param name="zone_7XX">710</xsl:with-param>
                      </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="position() != 1">
                      <xsl:call-template name="Template_7XX">
                        <xsl:with-param name="zone_7XX">711</xsl:with-param>
                      </xsl:call-template>
                    </xsl:if>
                  </xsl:when>
                  <xsl:when test="name(.) = 'famname'">
                    <xsl:if test="position() = 1">
                      <xsl:call-template name="Template_7XX">
                        <xsl:with-param name="zone_7XX">720</xsl:with-param>
                      </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="position() != 1">
                      <xsl:call-template name="Template_7XX">
                        <xsl:with-param name="zone_7XX">721</xsl:with-param>
                      </xsl:call-template>
                    </xsl:if>
                  </xsl:when>
                </xsl:choose>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
          <!-- mention de responsabilité secondaire -->
          <xsl:choose>
            <xsl:when test="*[not(self::dsc) and not(self::c)]//*[@role = '020' or @role='110' or @role='700' or @role='280'  or @role='660' or @role='390' or @role='730' or @role='220' or @role='440' or @role='590' or @role='610' or @role='participant' or @role='commanditaire' or @role='723']">
              <xsl:for-each select="*[not(self::dsc) and not(self::c)]//*[@role = '020' or @role='110' or @role='700' or @role='280'  or @role='660' or @role='390' or @role='730' or @role='220' or @role='440' or @role='590' or @role='610' or @role='participant' or @role='commanditaire' or @role='723']">
                <xsl:choose>
                  <xsl:when test="name(.) = 'persname'">
                    <xsl:call-template name="Template_7XX">
                      <xsl:with-param name="zone_7XX">702</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="name(.) = 'corpname'">
                    <xsl:call-template name="Template_7XX">
                      <xsl:with-param name="zone_7XX">712</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="name(.) = 'famname'">
                    <xsl:call-template name="Template_7XX">
                      <xsl:with-param name="zone_7XX">722</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                </xsl:choose>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="ancestor::*[self::archdesc or self::c]/*[not(self::dsc) and not(self::c)]//*[@role = '020' or @role='110' or @role='700' or @role='280'  or @role='660' or @role='390' or @role='730' or @role='220' or @role='440' or @role='590' or @role='610' or @role='participant' or @role='commanditaire' or @role='723']">
                <xsl:choose>
                  <xsl:when test="name(.) = 'persname'">
                    <xsl:call-template name="Template_7XX">
                      <xsl:with-param name="zone_7XX">702</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="name(.) = 'corpname'">
                    <xsl:call-template name="Template_7XX">
                      <xsl:with-param name="zone_7XX">712</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="name(.) = 'famname'">
                    <xsl:call-template name="Template_7XX">
                      <xsl:with-param name="zone_7XX">722</xsl:with-param>
                    </xsl:call-template>
                  </xsl:when>
                </xsl:choose>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
          <!-- 801 Source de catalogage sur le modèle 3?$aFR?$bAbes?$c20080325?$gAFNOR -->
          <xsl:element name="datafield">
            <xsl:attribute name="ind1">
              <xsl:text> </xsl:text>
            </xsl:attribute>
            <xsl:attribute name="ind2">
              <xsl:text>3</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="tag">810</xsl:attribute>
            <xsl:element name="subfield">
              <xsl:attribute name="code">a</xsl:attribute>
              <xsl:text>FR</xsl:text>
            </xsl:element>
            <xsl:element name="subfield">
              <xsl:attribute name="code">b</xsl:attribute>
              <xsl:text>ABES</xsl:text>
            </xsl:element>
            <xsl:element name="subfield">
              <xsl:attribute name="code">g</xsl:attribute>
              <xsl:text>AFNOR</xsl:text>
            </xsl:element>
          </xsl:element>
          <!-- 930. Données d'exemplaires -->
          <xsl:element name="datafield">
            <xsl:attribute name="ind1">
              <xsl:text> </xsl:text>
            </xsl:attribute>
            <xsl:attribute name="ind2">
              <xsl:text> </xsl:text>
            </xsl:attribute>
            <xsl:attribute name="tag">930</xsl:attribute>
            <xsl:element name="subfield">
              <xsl:attribute name="code">b</xsl:attribute>
              <xsl:value-of select="normalize-space($rcr)" />
            </xsl:element>
            <xsl:element name="subfield">
              <xsl:attribute name="code">a</xsl:attribute>
              <xsl:choose>
                <xsl:when test="did/unitid[@type='cote_actuelle' or @type='cote']">
                  <xsl:value-of select="normalize-space(did/unitid[@type='cote_actuelle' or @type='cote'])" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="normalize-space(ancestor::*[self::archdesc or self::c][did/unitid[@type='cote_actuelle' or @type='cote']][1]/did/unitid[@type='cote_actuelle' or @type='cote'])" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
            <xsl:element name="subfield">
              <xsl:attribute name="code">j</xsl:attribute>
              <xsl:text>g</xsl:text>
            </xsl:element>
            <xsl:if test="did/physloc | ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]/physloc">
              <xsl:element name="subfield">
                <xsl:attribute name="code">f</xsl:attribute>
                <xsl:choose>
                  <xsl:when test="did/physloc">
                    <xsl:value-of select="normalize-space(did/physloc)" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(ancestor::*[self::archdesc or self::c]/child::*[not(self::dsc) and not(self::c)]/physloc)" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:if>
          </xsl:element>
          <!-- 995k pour Chantilly -->
          <xsl:if test="//archdesc/did/repository/corpname/@authfilenumber = '601415401'">
            <xsl:element name="datafield">
              <xsl:attribute name="ind1">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ind2">
                <xsl:text> </xsl:text>
              </xsl:attribute>
              <xsl:attribute name="tag">995</xsl:attribute>
              <xsl:element name="subfield">
                <xsl:attribute name="code">k</xsl:attribute>
                <xsl:value-of select="normalize-space(did/unitid[@type='cote_actuelle' or @type='cote'])" />
              </xsl:element>
            </xsl:element>
          </xsl:if>
        </record>
      </xsl:for-each>
    </collection>
    </xsl:when>
    <xsl:otherwise>
      <erreur xsl:exclude-result-prefixes="dc">Etes-vous sûr de la bonne construction de l'xpath saisi dans le champ "Filtre" de la fenêtre d'export ? Avez-vous bien modifié la valeur du champ "Filtre" donnée à titre d'exemple ? Ce type d'export nécessite de préciser un filtre, celui que vous avez utilisé ne correspond à aucun élément dans le document. Voir la documentation pour plus de précision : http://documentation.abes.fr/aidecalames/manuelcorrespondant/index.html#PrincipesExports.</erreur>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:template>
  <!-- Template qui extrait la date de publication pour alimenter la zone 100. -->
  <xsl:template name="date100">
    <xsl:param name="date_chemin" />
    <xsl:choose>
      <xsl:when test="contains($date_chemin, '/')">
        <xsl:text>        f</xsl:text>
        <xsl:value-of select="substring($date_chemin, 1, 4)" />
        <xsl:value-of select="substring(substring-after($date_chemin, '/'),1, 4)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>        d</xsl:text>
        <xsl:value-of select="concat(substring($date_chemin, 1, 4), '    ')" />
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
  <!-- Template pour 7XX -->
  <xsl:template name="Template_7XX">
    <xsl:param name="zone_7XX" />
    <xsl:element name="datafield">
      <xsl:attribute name="ind1">
        <xsl:text> </xsl:text>
      </xsl:attribute>
      <xsl:attribute name="ind2">
        <xsl:text> </xsl:text>
      </xsl:attribute>
      <xsl:attribute name="tag">
        <xsl:value-of select="$zone_7XX" />
      </xsl:attribute>
      <xsl:if test="@authfilenumber">
        <xsl:element name="subfield">
          <xsl:attribute name="code">3</xsl:attribute>
          <xsl:value-of select="normalize-space(@authfilenumber)" />
        </xsl:element>
      </xsl:if>
      <xsl:element name="subfield">
        <xsl:attribute name="code">a</xsl:attribute>
        <xsl:call-template name="Template_normal">
          <xsl:with-param name="node" select="." />
        </xsl:call-template>
      </xsl:element>
      <xsl:element name="subfield">
        <xsl:attribute name="code">4</xsl:attribute>
        <xsl:choose>
          <xsl:when test="@role='producteur' or role='fabricant'">
            <xsl:text>070</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="normalize-space(@role)" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  <!-- template rechercheancetre -->
  <xsl:template name="rechercheancetre">
    <xsl:param name="ancetre" />
    <xsl:for-each select="$ancetre/*[not(self::dsc) and not(self::c)]//*[@role='070' or @role='340' or @role='650' or @role='330' or @role='100' or @role='212' or role='fabricant']">
      <xsl:element name="subfield">
        <xsl:if test="position() = 1">
          <xsl:attribute name="code">f</xsl:attribute>
          <xsl:value-of select="." />
        </xsl:if>
        <xsl:if test="position() &gt; 1">
          <xsl:attribute name="code">g</xsl:attribute>
          <xsl:value-of select="." />
        </xsl:if>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>