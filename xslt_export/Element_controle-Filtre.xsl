<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" omit-xml-declaration="yes" indent="no" encoding="UTF-8"/>
  <xsl:param name="filtre"/> 
  <!--<xsl:param name="filtre" select="//*/@href"/>-->
 <!-- <xsl:param name="filtre" select="//p"/>-->
  <!--<xsl:param name="filtre" select="//persname/text()"/>-->
  <!--<xsl:param name="filtre" select="//persname/@*"/>-->
  <!--<xsl:param name="filtre" select="//persname/@role"/>-->
  <xsl:template match="/">
    <xsl:choose>
      <!-- Modification par ENO en novembre 2024 : ajout d'un premier when pour retour d'une phrase dans le fichier txt en résultat lorsque le filtre interroge un élément EAD interdit par les Bonnes pratiques EAD -->
      <xsl:when test="$filtre/self::abstract | $filtre/self::chronitem | $filtre/self::chronlist | $filtre/self::colspec | $filtre/self::entry | $filtre/self::imprint | $filtre/self::row | $filtre/self::table | $filtre/self::tbody | $filtre/self::tgroup | $filtre/self::thead"> 
        <erreur xsl:exclude-result-prefixes="xsl">Vous avez essayé de sélectionner un élément EAD interdit par les Bonnes pratiques dans le filtre d'export. Voir le site des Bonnes pratiques EAD en bibliothèque pour plus de précision : https://www.ead-bibliotheque.fr/synthese-elements-attributs/</erreur>
      </xsl:when>
      <xsl:when test="$filtre != ''">
        <!-- Modification par ENO en novembre 2024 des intitulés de colonne : Path devient Chemin en EAD, Contexte devient ID du composant et Valeur devient Contenu textuel -->
          <xsl:text>Chemin en EAD ¤ ID du composant ¤ Attribut(s) ¤ Contenu textuel </xsl:text>
        <xsl:value-of select="'&#10;'"/>
        <xsl:for-each select="$filtre">
          <xsl:call-template name="filtre">
            <xsl:with-param name="type">
              <xsl:choose>
                <xsl:when test="$filtre/self::*">element</xsl:when>
                <xsl:when test="$filtre/self::text()">texte</xsl:when>
                <xsl:otherwise>attribut</xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
          <xsl:text> ¤ </xsl:text>
          <xsl:call-template name="contexte">
            <xsl:with-param name="type">
              <xsl:choose>
                <xsl:when test="$filtre/self::*">element</xsl:when>
                <xsl:when test="$filtre/self::text()">texte</xsl:when>
                <xsl:otherwise>attribut</xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <erreur xsl:exclude-result-prefixes="xsl">Etes-vous sûr de la bonne construction de l'xpath
          saisi dans le champ "Filtre" de la fenêtre d'export ? Avez-vous bien modifié la valeur du
          champ "Filtre" donnée à titre d'exemple ? Ce type d'export nécessite de préciser un
          filtre, celui que vous avez utilisé ne correspond à aucun élément dans le document. Voir
          la documentation pour plus de précision :
          http://documentation.abes.fr/aidecalames/manuelcorrespondant/index.html#PrincipesExports.</erreur>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="filtre">
    <xsl:param name="type"/>
    <xsl:choose>
      <xsl:when test="$type = 'element'">
        <xsl:for-each select="ancestor-or-self::*">
          <xsl:value-of select="concat('/', local-name())"/>
          <xsl:if
            test="(preceding-sibling::* | following-sibling::*)[local-name() = local-name(current())]">
            <xsl:value-of
              select="concat('[', count(preceding-sibling::*[local-name() = local-name(current())]) + 1, ']')"
            />
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="$type = 'texte' or $type='attribut'">
        <xsl:for-each select="ancestor::*">
          <xsl:value-of select="concat('/', local-name())"/>
          <xsl:if
            test="(preceding-sibling::* | following-sibling::*)[local-name() = local-name(current())]">
            <xsl:value-of
              select="concat('[', count(preceding-sibling::*[local-name() = local-name(current())]) + 1, ']')"
            />
          </xsl:if>
        </xsl:for-each>
        <xsl:if test="$type = 'texte'"><xsl:text>/text()</xsl:text></xsl:if>
      <xsl:if test="$type = 'attribut'">       
            <xsl:value-of select="concat('/@', local-name())"/>            
           </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="contexte">
    <xsl:param name="type"/>
    <xsl:choose>
      <xsl:when test="./ancestor::c[1]">
        <!-- Modification par ENO en novembre 2024 pour récupération uniquement de la valeur d'ID de <c> -->
        <xsl:value-of select=".//ancestor::c[1]/@id"/>
        </xsl:when>
      <xsl:when test="./ancestor-or-self::archdesc[1]">
        <xsl:text>archdesc</xsl:text>
      </xsl:when>
    </xsl:choose>
    <xsl:text> ¤ </xsl:text>
    <xsl:for-each select="@* | self::node()[$type='attribut']">
      <xsl:sort select="name(.)" data-type="text"/>      
      <xsl:text>[</xsl:text> <xsl:apply-templates select="."/>  <xsl:text>]</xsl:text>      
    </xsl:for-each>
    
    <xsl:text> ¤ </xsl:text>
    <xsl:choose>
      <xsl:when
        test="normalize-space(.//text() != '' or text() != '') and ($type = 'element' or $type = 'texte')">
        <xsl:variable name="chaine">
          <!--ERM decembre 2024 - prendre tout text() descendant de l'élément sélectionné par le filtre (y compris lui-même) sauf text() issu d'un élément proscrit (= ayant pour ancêtre)-->
          <xsl:for-each select="descendant-or-self::text()">            
            <xsl:choose>
              <xsl:when test="ancestor::abstract | ancestor::chronitem | ancestor::chronlist | ancestor::colspec | ancestor::entry | ancestor::imprint | ancestor::row | ancestor::table | ancestor::tbody | ancestor::tgroup | ancestor::thead"></xsl:when>
              <xsl:otherwise><xsl:copy-of select="."/> </xsl:otherwise>
           </xsl:choose>           
          </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="normalize-space($chaine)"/>
      </xsl:when>
      <xsl:when test="$type = 'attribut'"/>
    </xsl:choose>
    <xsl:value-of select="'&#10;'"/>
  </xsl:template>
  <xsl:template match="@*">
    <xsl:value-of select="concat('@', local-name(), '=&quot;', ., '&quot;')"/>
  </xsl:template>
</xsl:stylesheet>
