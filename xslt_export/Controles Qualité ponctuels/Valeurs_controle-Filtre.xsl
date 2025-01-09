<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  <!-- Cet xslt requière un XPATH défini dans Calames dans le champ "filtre" -->
  <xsl:param name="filtre" />
  <xsl:template match="/">
     <xsl:choose>
      <xsl:when test="$filtre !=''">	
    <RESULT>
      <!-- Pour affichage sur la première ligne de l'élément ou attribut interrogé dans l'XPath saisi en filtre d'export - ajout ERM octobre 2024 -->
      <xsl:value-of select="'&#10;'"/>
      <xsl:text>Résultat(s) avec le filtre :  </xsl:text>
      <xsl:choose>
        <xsl:when test="$filtre/self::*">
          <xsl:value-of select="local-name($filtre)"/>
        </xsl:when>
        <xsl:when test="$filtre/self::text()">
          <xsl:value-of select="concat(local-name($filtre/parent::*), '/text()')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(local-name($filtre/parent::*), '/@', local-name($filtre))"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="'&#10;'"/>
      <xsl:value-of select="'&#10;'"/>
      <xsl:for-each select="$filtre">
        <!-- Pour première colonne avec ID de <c> ou mention "archdesc" si la valeur exportée sur cette ligne se trouve en <archdesc> - ajout ERM octobre 2024 -->
       <xsl:choose>
         <xsl:when test="./ancestor::c[1]">
           <xsl:value-of select=".//ancestor::c[1]/@id"/>
         </xsl:when>
         <xsl:when test="./ancestor-or-self::archdesc[1]">
           <xsl:text>archdesc</xsl:text>
         </xsl:when>           
       </xsl:choose>
        <!-- Concaténation pour générer la la seconde colonne du séparateur + valeur sélectionnée dans le filtre + retour chariot - ajout ENO août 2024 -->
        <xsl:value-of select="concat(' ¤ ', ., '&#10;')"/>
        </xsl:for-each>
    </RESULT>
      </xsl:when>
       <!-- message type si aucune réponse au xpath -->
      <xsl:otherwise>
        <erreur xsl:exclude-result-prefixes="xsl">Etes-vous sûr de la bonne construction de l'xpath saisi dans le champ "Filtre" de la fenêtre d'export ? Avez-vous bien modifié la valeur du champ "Filtre" donnée à titre d'exemple ? Ce type d'export nécessite de préciser un filtre, celui que vous avez utilisé ne correspond à aucun élément dans le document. Voir la documentation pour plus de précision : http://documentation.abes.fr/aidecalames/manuelcorrespondant/index.html#PrincipesExports.</erreur>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>