<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  <xsl:param name="filtre" />
  <xsl:template match="/">
     <xsl:choose>
      <xsl:when test="$filtre !=''">	
    <RESULT>
      <!-- Ajout ERM octobre 2024 pour affichage sur la première ligne de l'élément ou attribut interrogé dans l'XPath saisi en filtre d'export. Si attribut, l'élément parent affiché sur cette première et celui de la première occurrence de l'attribut trouvé et non nécessairement de toutes les autres occurrences de l'attribut dans le fichier. -->
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
        <!-- Ajout ERM octobre 2024 pour première colonne avec ID de <c> ou mention "archdesc" si la valeur exportée sur cette ligne se trouve en <archdesc> -->
       <xsl:choose>
         <xsl:when test="./ancestor::c[1]">
           <xsl:value-of select=".//ancestor::c[1]/@id"/>
         </xsl:when>
         <xsl:when test="./ancestor-or-self::archdesc[1]">
           <xsl:text>archdesc</xsl:text>
         </xsl:when>           
       </xsl:choose>
        <!-- ENO août 2024 : ajout de la concaténation avec ID du <c> parent le plus proche, séparateur, valeur sélectionnée dans le filtre et retour chariot -->
        <xsl:value-of select="concat(' ¤ ', ., '&#10;')"/>
        </xsl:for-each>
    </RESULT>
      </xsl:when>
      <xsl:otherwise>
        <erreur xsl:exclude-result-prefixes="xsl">Etes-vous sûr de la bonne construction de l'xpath saisi dans le champ "Filtre" de la fenêtre d'export ? Avez-vous bien modifié la valeur du champ "Filtre" donnée à titre d'exemple ? Ce type d'export nécessite de préciser un filtre, celui que vous avez utilisé ne correspond à aucun élément dans le document. Voir la documentation pour plus de précision : http://documentation.abes.fr/aidecalames/manuelcorrespondant/index.html#PrincipesExports.</erreur>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>