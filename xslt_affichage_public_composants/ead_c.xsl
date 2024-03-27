<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output omit-xml-declaration="yes" indent="yes"/>
	<!-- Variable msurl pour transo RDFa : les liens en /res/ correspondent aux ressources décrites, tandis que les liens en /ms/ sont ceux des notices Calames, i.e. métadonnées de ces ressources -->
	<xsl:variable name="msurl">
		<xsl:text>https://calames.abes.fr/pub/ms/res/</xsl:text>
		<xsl:value-of select="/RESULT/arbre/@id | /RESULT/root/@id"/>
	</xsl:variable>

	<xsl:template match="/RESULT">
		<xsl:apply-templates select="arbre[1] | root"/>
		<!--  gestion spécifique des points d'accès TDD : affichage des points d'accès, non seulement du C courant, mais aussi des TDD hérités -->
		<!--<xsl:apply-templates select="//genreform[@type='type de document']/@normal"  /> --><!--<xsl:if test="//*[not(arbre[1])]//genreform[@type='type de document']"><xsl:call-template name="TDD" ><xsl:with-param name="entrees" /></xsl:call-template></xsl:if>-->
		<!--<xsl:for-each select="//*[not(arbre[1])]//genreform[@type='type de document']"><xsl:call-template name="TDD" ><xsl:with-param name="entrees" /></xsl:call-template></xsl:for-each>-->
		<!--<xsl:if test="not(arbre[1]//accessrestrict)">-->
		<xsl:if test="arbre"><xsl:if test="/*[not(arbre[1]//userestrict)]//userestrict"><xsl:if test="/*[not(arbre[1]//accessrestrict)]//accessrestrict"><xsl:call-template name="AccessUseRestrictH" ></xsl:call-template></xsl:if></xsl:if></xsl:if>
	</xsl:template>
	
	

	<!-- Affichage hérité des Conditions d'accès et d'utilisation : lorsqu'un niveau descriptif ne comporte ni <accessrestrict> ni <userestrict>, rapatrie ces données si elles sont présentes, le cas échéant, au sein de son ancêtre le plus proche  ; voir également dans le template "Result" ci-dessus -->
	<xsl:template name="AccessUseRestrictH">
		<br/>
		<div class="c_accessrestrict">
			<span class="AccessUseRestrictH i18n_condAccesH">Rappels sur les conditions d'accès et d'utilisation des documents</span>
			<xsl:text> : </xsl:text>
			<span class="AccessUseRestrictHbis" property="dc:rights" about="{$msurl}"><xsl:for-each select="//arbre[not(arbre[1])][not(preceding-sibling::arbre//accessrestrict)]//accessrestrict"><xsl:apply-templates select="p"/><xsl:text> </xsl:text></xsl:for-each>
			<br/><xsl:for-each select="//arbre[not(arbre[1])][not(preceding-sibling::arbre//userestrict)]//userestrict"><xsl:apply-templates select="p"/><xsl:text> </xsl:text></xsl:for-each></span>
		</div>
	</xsl:template>
	

	<!--- ****AC:  génération des cotes et titres enfants et parents-->
	<xsl:template match="/unittitle">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="/unitid">
		<xsl:apply-templates/>
	</xsl:template>
	
	<!--<xsl:template match="*[@audience='internal']">
	</xsl:template>-->
	
	<!-- ************************************************************************************** -->
	<!-- Parties hautes du fichier EAD -->
	<!-- ************************************************************************************** -->
	<xsl:template match="repository">
		<p>
			<span class="controlC i18n_orgmResponsable">Organisme responsable</span>
			<br/>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="corpname">
		<xsl:value-of select="."/>
	</xsl:template>
	<!-- modifié -->
	<xsl:template match="address">
	<br />
			<xsl:apply-templates/>
	</xsl:template>
<!-- fin modifications -->
	<xsl:template match="addressline">
		<xsl:value-of select="."/>
		<br/>
	</xsl:template>
	<!-- modif 19 janvier 08 -->
<!-- remodifié -->
	<xsl:template match="physloc">
		<div class="physloc">
			<span class="controlC i18n_lieuConservation">Lieu de conservation</span> : 
		<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- ajout container JMF juin 2012 -->
	<xsl:template match="container">
		<div class="container">
			<span class="controlC i18n_container">Unité(s) de conditionnement</span> : 
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="userestrict">
	<div class="userestrict">
			<span class="controlC i18n_condUtilisation">Conditions d'utilisation</span>
			<xsl:text> : </xsl:text>
			<xsl:apply-templates select="p" />
		<br />
		</div>
	</xsl:template>
	<xsl:template match="prefercite">
		<div class="prefercite">
			<span class="controlC i18n_citerSousForme">Citer sous la forme</span>
			<xsl:text> : </xsl:text>
			<xsl:apply-templates select="p"/>
		<br />
		</div>
	</xsl:template>
<!-- fin modifications -->
	<xsl:template match="lb">
		<br/>
	</xsl:template>
	<!-- ************************************************************************************** -->
	<!-- détail de chaque c -->
	<!-- ************************************************************************************** -->
	<xsl:template match="c">
		<xsl:param name="c"></xsl:param>
		<!-- Ajout Template RDFa pour Adonis le 18/10/10 -->
		<xsl:call-template name="rdfa"/>
		<!-- <xsl:apply-templates select="did/unittitle"/> -->
        	<!-- si archdesc repository en premier -->
		<!--<xsl:apply-templates select="did/repository"/>-->
        		<xsl:apply-templates select="note[@type = 'absent']"/>
		<!--<xsl:apply-templates select=".//genreform[@type='type de document'][@normal]"/>-->
		<!-- mis en commentaire par olga : remplace par cote_unique
		<xsl:apply-templates select="did/unitid[@type='cote_actuelle' or @type='cote']"/>
		 fin commente par olga-->
		<xsl:apply-templates select="did/unitid[@type='cote_unique']"/>
		<xsl:apply-templates select=".//unitdate" mode="bloc"/>
		<xsl:apply-templates select="did/langmaterial"/>
		<xsl:apply-templates select="did/physdesc"/>
        <xsl:apply-templates select="did/materialspec"/>
        <!-- si c repository s'affiche ici -->
		<xsl:apply-templates select="did/repository"/>
		<xsl:apply-templates select="scopecontent"/>
		<xsl:apply-templates select="arrangement"/>
		<xsl:apply-templates select="did/origination"/>
		<xsl:apply-templates select="bioghist"/>
		<xsl:apply-templates select="note[@type = 'provenance']"/>
		<xsl:apply-templates select="custodhist"/>
		<xsl:apply-templates select="acqinfo"/>
        		<xsl:apply-templates select="accruals" />
		<xsl:apply-templates select="did/unitid[@type='ancienne_cote']"/>
        		<xsl:apply-templates select="phystech" />
		<xsl:apply-templates select="did/physloc"/>
		<xsl:apply-templates select="did/container"/>
		<xsl:apply-templates select="accessrestrict"/>
		<xsl:apply-templates select="altformavail"/>
		<xsl:apply-templates select="userestrict"/>
		<xsl:apply-templates select="prefercite"/>
		<xsl:apply-templates select="separatedmaterial"/>
		<xsl:apply-templates select="relatedmaterial"/>
		<xsl:apply-templates select="originalsloc"/>
		<xsl:apply-templates select="otherfindaid"/>
		<xsl:apply-templates select="bibliography"/>
		<xsl:apply-templates select="bibref[@href]"/>
		<xsl:apply-templates select="processinfo"/>
        		<xsl:apply-templates select="appraisal" />
		<xsl:apply-templates select="dao"/>
		<xsl:apply-templates select="daogrp[not(daoloc[@role='vignette'])]" />
		<xsl:if test=".//persname | .//corpname | .//famname | .//geogname | .//subject | .//title | .//genreform">
			<xsl:call-template name="entrees"/>
		</xsl:if>
		<!--<xsl:if test=".//genreform[@type='type de document']">
			<xsl:call-template name="TDD"></xsl:call-template>
		</xsl:if>--> 
	</xsl:template>
	<!--xsl:template match="unitid"/-->
	<!-- AC: J'ai ajouté did/ aux match des cotes pr la transformation des cotes en javascript-->
	<xsl:template match="did/unitid[@type='cote_actuelle' or @type='cote']">
		<div class="cote_actuelle">
			<span class="controlC i18n_cote">Cote</span> : 
			<span property="dc:identifier" about="{$msurl}">
				<xsl:attribute name="typeof">
					<xsl:text>frbrabes:singletonManifestation</xsl:text>
				</xsl:attribute>
				<xsl:apply-templates/>
			</span>
		</div>
	</xsl:template>
	<!-- rajoute par olga -->
	<xsl:template match="did/unitid[@type='cote_unique']">
		<div class="cote_actuelle">
			<span id="coteUnique" class="controlC i18n_cote">Cote</span> : 
			<span class="cote_unique" property="dc:identifier" about="{$msurl}">
				<xsl:attribute name="typeof">
					<xsl:text>frbrabes:singletonManifestation</xsl:text>
				</xsl:attribute>
				<xsl:apply-templates/>
			</span>
		</div>
	</xsl:template>
	<!-- fin rajout par olga-->
	<!--test olga : ajout de classe avec xsl:attribute (ne marche pas)...
    <xsl:template match="did/unitid[@type='cote_unique']">
        <div class="cote_actuelle">
            <span>Cote avec deux classes: 
                <xsl:attribute name="class">
                    <xsl:text>class1 class2</xsl:text>
                </xsl:attribute>
            </span>
            <span class="cote_unique" property="dc:identifier" about="{$msurl}">
                <xsl:attribute name="typeof">
                    <xsl:text>frbrabes:singletonManifestation</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates/>
            </span>
        </div>
    </xsl:template>
    -fin test olga -->
	<xsl:template match="did/unitid[@type='ancienne_cote']">
		<div class="ancienne_cote">
			<span class="controlC i18n_coteAncienne">Ancienne cote</span> : 
			<span>
				<xsl:apply-templates/>
			</span>
		</div>
	</xsl:template>
	<xsl:template match="accessrestrict">
		<div class="c_accessrestrict">
			<span class="controlC i18n_condAcces">Conditions d'accès</span>
				<xsl:text> : </xsl:text>
			<span class="c_accessrestrict" property="dc:rights" about="{$msurl}">
				<xsl:apply-templates select="p"/>
			</span>
		</div>
	</xsl:template>
	  <xsl:template match="note[@type = 'absent']">
	    <p class="important">
	      <xsl:apply-templates/>
	    </p>
	  </xsl:template>
	<!-- Modifié par Yann le 18/10/10 -->
	<xsl:template match="scopecontent">
		<div class="scopecontent">
			<span class="controlC i18n_description">Description</span> : 
			<span property="dc:description" about="{$msurl}">
				<xsl:apply-templates select="p" />
			</span>
		</div>
	</xsl:template>
		
	<xsl:template match="physdesc">
		<div class="physdesc">
			<span class="controlC i18n_descPhysique">Description physique</span> : 
			<!-- JMF : l'affichage de PCDATA dans la balise mixte physdesc ne fonctionne pas avec les fonctions for-each. Utiliser if, ou bien choose/when.  -->
			<xsl:if test="text()">
				<span property="dc:format" about="{$msurl}">
					<xsl:apply-templates select="text() | physfacet | extent | dimensions | .//genreform" />
				</span>
				<!-- <xsl:choose>
				<xsl:when test="text()"><span property="dc:format" about="{$msurl}"><xsl:apply-templates /></span><xsl:text>&nbsp;</xsl:text></xsl:when>
				<xsl:when test="physfacet"><span property="dc:format" about="{$msurl}"><xsl:apply-templates /></span><xsl:text>ici</xsl:text></xsl:when>
				<xsl:when test="dimensions"><span property="dc:format" about="{$msurl}"><xsl:apply-templates /></span><xsl:text> LA </xsl:text></xsl:when>
			</xsl:choose>-->
			</xsl:if>
			<xsl:if test="not(./text())">
			<xsl:for-each select="node()[not(self::comment())]">
				<span property="dc:format" about="{$msurl}">
					<xsl:apply-templates />
					<xsl:text>. </xsl:text>
					<xsl:if test="position() != last()">
						<xsl:text> </xsl:text>
					</xsl:if>
				</span>
			</xsl:for-each>
			</xsl:if>
		</div>
	</xsl:template>
<!--	<xsl:template match="physdesc[text()]/physfacet">
			<xsl:for-each select="." >
				<xsl:apply-templates />
			<xsl:text>. </xsl:text>
			<xsl:if test="position() != last()">
				<xsl:text> </xsl:text>
			</xsl:if>
			</xsl:for-each>
	</xsl:template>-->

	<xsl:template match="altformavail">
		<div class="altformavail">
			<span class="controlC i18n_autreSupport">Autre support</span> : 
			<span>
				<xsl:apply-templates/>
			</span>
		</div>
	</xsl:template>
	

	
	<xsl:template match="unitdate" mode="bloc">
		<div class="unitdate">
			<span class="controlC i18n_date">Date</span> : 
			<span class="unitdate" property="dc:date" content="{@normal}" about="{$msurl}">
				<xsl:apply-templates/>
			</span>
		</div>
	</xsl:template>
	
	
	<xsl:template match="langmaterial[.//text()]">
		<div class="langmaterial">
			<span class="controlC i18n_langue">Langue</span> : 
			<span class="lang" property="dc:language" content="{language/@langcode}"
				about="{$msurl}">
				<xsl:apply-templates/>
			</span>
		</div>
	</xsl:template>
	<xsl:template match="note[@type = 'provenance']">
		<div class="provenance">
			<span class="controlC i18n_provenance">Provenance</span> : 
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="bioghist">
		<div class="bioghist">
			<span class="controlC i18n_biographie">Biographie ou Histoire</span> : 
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="arrangement">
		<div class="arrangement">
			<span class="controlC i18n_classement">Classement</span> : 
			<xsl:apply-templates />
		</div>
	</xsl:template>
	<xsl:template match="processinfo">
		<div class="processinfo">
			<span class="controlC i18n_infoTraitement">Information sur le traitement</span> : 
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="custodhist">
		<div class="custodhist">
			<span class="controlC i18n_provenance">Provenance</span> : 
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="acqinfo">
		<div class="acqinfo">
			<span class="controlC i18n_modalEntrCollection">Modalités d'entrée dans la collection</span> : 
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="origination">
		<div class="origination">
			<span class="controlC i18n_producteurFondsCollect">Producteur du fonds ou collectionneur</span> : 
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="relatedmaterial">
		<div class="relatedmaterial">
			<span class="controlC i18n_docEnRelation">Documents en relation</span> : 
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="originalsloc">
		<div class="originalsloc">
			<span class="controlC i18n_locOriginaux">Localisation des originaux</span> : 
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="otherfindaid">
		<div class="otherfindaid">
			<span class="controlC i18n_autreInstrRech">Autre instrument de recherche</span> : 
			<xsl:apply-templates/>
		</div>
	</xsl:template>


	<xsl:template match="separatedmaterial">
		<div class="separatedmaterial">
			<span class="controlC i18n_docSepares">Documents séparés</span> : 
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	

	
	<xsl:template match="bibliography">
		<div class="bibliography">
			<xsl:if test="position()=1">
				<span class="controlC i18n_bibliographie">
					<xsl:text>Bibliographie</xsl:text>
				</span> : 
				<xsl:if test="head"><br/></xsl:if>
			</xsl:if>
			<xsl:choose>
			<xsl:when test="p">
				<span>            
				<xsl:apply-templates select="p" />
				</span>
			</xsl:when>
			<xsl:when test="head | bibref">
			<xsl:for-each select="head">
				<i><b><xsl:value-of select="."/></b></i>
				<xsl:text> : </xsl:text>
				</xsl:for-each>
					<xsl:for-each select="bibref">
					<xsl:if test="not(@href)"><div><xsl:apply-templates /></div></xsl:if>
					<xsl:if test="@href">
						<div><a href="{@href}" title="{@title}" target="_blank" class="lienExterne">
						<xsl:apply-templates />
						</a></div>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="bibref[@href]">
		<a href="{@href}" title="{@title}" target="_blank" class="lienExterne">
		<xsl:apply-templates />
		</a>
	</xsl:template>
	
	<xsl:template match="archref[@href]">
		<a href="{@href}" title="{@title}" target="_blank" class="lienExterne">
			<xsl:apply-templates />
		</a>
		<!--<xsl:choose>
			<xsl:when test="@href">
				<a href="{@href}" title="{@title}" target="_blank" class="lienExterne">
					<xsl:apply-templates />
				</a>
			</xsl:when>
		<!-\- nuance pour les liens internes à Calames : navigation dans le meme onglet 
			<xsl:when test="@href[starts-with(.,'https://calames.abes.fr')]">
				<a href="{@href}" title="{@title}" target="_blank" class="lienExterne">
					<xsl:apply-templates />
				</a>
			</xsl:when>-\->
		<xsl:otherwise>
			<xsl:apply-templates />
		</xsl:otherwise>
	</xsl:choose>-->
	</xsl:template>
<!-- Ajout de la condition internal pour masquer des daodesc/p/num avec l'identifiant du <c> dans la bibnum + gestion nouvelle valeur de ROLE de <daoloc> "manifest_iiif" + changement affichage par défaut en absence de daoloc oudao TITLE  par BML 27/03/2024 -->
	<xsl:template match="dao">
		<xsl:if test="@href"><div class="rebond">
			<span class="controlC i18n_dao">Version(s) numérique(s)</span> :
			<xsl:if test="daodesc[not(@audience='internal')]/p">
				<!--<span><xsl:value-of select="daodesc/p" /></span> -  --> 
				<xsl:apply-templates /> - 
			</xsl:if>
			<xsl:choose>
				<xsl:when test="@title">
					<span class="numerisation"><a href="{@href}" target="_blank" class="lienExterne"><xsl:value-of select="@title" /></a></span>
				</xsl:when>
				<xsl:otherwise>
					<span class="numerisation"><a href="{@href}" target="_blank" class="lienExterne">Disponible en ligne</a></span>
				</xsl:otherwise>
			</xsl:choose>
		</div></xsl:if>
		<xsl:if test="not(@href)"><div class="rebond">
			<span class="controlC i18n_dao">Version(s) numérique(s)</span> :
			<xsl:for-each select="daodesc[not(@audience='internal')]/p">
				<!--<span><xsl:value-of select="daodesc/p" /></span> -  --> 
				<xsl:apply-templates />
			</xsl:for-each>
		</div></xsl:if>
		
	</xsl:template>
	
	<xsl:template match="daogrp[not(daoloc[@role='vignette'])]">
		<div class="rebond">
		<span class="controlC i18n_dao">Version(s) numérique(s)</span> :
			<xsl:if test="daodesc[not(@audience='internal')]/p">
				<!--<div><span><xsl:value-of select="daodesc/p" /></span> - </div>-->  
				<xsl:apply-templates />
			</xsl:if>
		<xsl:for-each select="daoloc[@role='rebond' or @role='manifest_iiif']">
			
			<div>
				<!--<span><xsl:value-of select="daodesc/p" /></span> -->
				<xsl:if test="daodesc[not(@audience='internal')]/p"><span><xsl:apply-templates /></span>
					<span> : </span> 
				</xsl:if>
			<xsl:choose>
			<xsl:when test="@title">
				<span class="numerisation"><a href="{@href}" target="_blank" class="lienExterne"><xsl:value-of select="@title" /></a></span>
			</xsl:when>
			<xsl:otherwise>
			<!--<xsl:when test="not(@title)">-->
				<span class="numerisation"><a href="{@href}" target="_blank" class="lienExterne">Disponible en ligne</a></span>
			</xsl:otherwise>
			</xsl:choose>
			</div>
		</xsl:for-each>
		</div>
	</xsl:template>
	
	<xsl:template name="entrees">
		<xsl:param name="entrees"></xsl:param>
		<table class="accesstable">
			<!-- producteur -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">producteur</xsl:with-param>
				<xsl:with-param name="lib">Producteur du fonds ou collectionneur</xsl:with-param>
				<xsl:with-param name="property">dcterms:contributor</xsl:with-param>
                <xsl:with-param name="cl">i18n_producteurFondsCollect</xsl:with-param>
			</xsl:call-template>
           			 <!-- 070 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">070</xsl:with-param>
				<xsl:with-param name="lib">Auteur</xsl:with-param>
				<xsl:with-param name="property">dcterms:creator</xsl:with-param>
                <xsl:with-param name="cl">i18n_auteur</xsl:with-param>
			</xsl:call-template>
			<!-- 330 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">330</xsl:with-param>
				<xsl:with-param name="lib">Auteur supposé</xsl:with-param>
				<xsl:with-param name="property">dcterms:creator</xsl:with-param>
               			 <xsl:with-param name="cl">i18n_auteurSupp</xsl:with-param>
			</xsl:call-template>
			<!-- fabricant màj nov 2011-->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">fabricant</xsl:with-param>
				<xsl:with-param name="lib">Fabricant</xsl:with-param>
				<xsl:with-param name="property">dcterms:creator</xsl:with-param>
				<xsl:with-param name="cl">i18n_fabricant</xsl:with-param>
			</xsl:call-template>
			<!-- 730 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">730</xsl:with-param>
				<xsl:with-param name="lib">Traducteur</xsl:with-param>
				<xsl:with-param name="property">dcterms:contributor</xsl:with-param>
                <xsl:with-param name="cl">i18n_traducteur</xsl:with-param>
			</xsl:call-template>
			<!-- 650 Ajout déc. 2014 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">650</xsl:with-param>
				<xsl:with-param name="lib">Editeur commercial</xsl:with-param>
				<xsl:with-param name="property">dcterms:contributor</xsl:with-param>
				<xsl:with-param name="cl">i18n_editeurComm</xsl:with-param>
			</xsl:call-template>
			<!-- 340 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">340</xsl:with-param>
				<xsl:with-param name="lib">Editeur scientifique</xsl:with-param>
				<xsl:with-param name="property">dcterms:contributor</xsl:with-param>
                <xsl:with-param name="cl">i18n_editeurScient</xsl:with-param>
			</xsl:call-template>
			<!-- 440 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">440</xsl:with-param>
				<xsl:with-param name="lib">Illustrateur</xsl:with-param>
				<xsl:with-param name="property">dcterms:contributor</xsl:with-param>
                <xsl:with-param name="cl">i18n_illustrateur</xsl:with-param>
			</xsl:call-template>
			<!-- 212 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">212</xsl:with-param>
				<xsl:with-param name="lib">Commentateur</xsl:with-param>
				<xsl:with-param name="property">dcterms:contributor</xsl:with-param>
                <xsl:with-param name="cl">i18n_commentateur</xsl:with-param>
			</xsl:call-template>
			<!-- 220 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">220</xsl:with-param>
				<xsl:with-param name="lib">Compilateur</xsl:with-param>
				<xsl:with-param name="property">dcterms:contributor</xsl:with-param>
                <xsl:with-param name="cl">i18n_compilateur</xsl:with-param>
			</xsl:call-template>
			<!-- 020 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">020</xsl:with-param>
				<xsl:with-param name="lib">Annotateur</xsl:with-param>
				<xsl:with-param name="property">dcterms:contributor</xsl:with-param>
                <xsl:with-param name="cl">i18n_annotateur</xsl:with-param>
			</xsl:call-template>
			<!-- 100 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">100</xsl:with-param>
				<xsl:with-param name="lib">Auteur adapté</xsl:with-param>
				<xsl:with-param name="property">dcterms:creator</xsl:with-param>
                <xsl:with-param name="cl">i18n_auteurAdap</xsl:with-param>
			</xsl:call-template>
			<!-- 590 -->
            <xsl:call-template name="CTRLaccess">
            <xsl:with-param name="role">590</xsl:with-param>
            <xsl:with-param name="lib">Interprète</xsl:with-param>
            <xsl:with-param name="property">dcterms:contributor</xsl:with-param>
            <xsl:with-param name="cl">i18n_interprete</xsl:with-param>
            </xsl:call-template>
			<!-- participant màj oct 2012 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">participant</xsl:with-param>
				<xsl:with-param name="lib">Participant</xsl:with-param>
				<xsl:with-param name="property">dcterms:contributor</xsl:with-param>
				<xsl:with-param name="cl">i18n_participant</xsl:with-param>
			</xsl:call-template>
			<!-- 660 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">660</xsl:with-param>
				<xsl:with-param name="lib">Destinataire</xsl:with-param>
				<xsl:with-param name="property">dcterms:contributor</xsl:with-param>
                <xsl:with-param name="cl">i18n_destinataire</xsl:with-param>
			</xsl:call-template>
			<!-- 280 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">280</xsl:with-param>
				<xsl:with-param name="lib">Dédicataire</xsl:with-param>
				<xsl:with-param name="property">dcterms:contributor</xsl:with-param>
                <xsl:with-param name="cl">i18n_dedicataire</xsl:with-param>
			</xsl:call-template>
			<!-- 700 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">700</xsl:with-param>
				<xsl:with-param name="lib">Copiste</xsl:with-param>
				<xsl:with-param name="property">dcterms:contributor</xsl:with-param>
                <xsl:with-param name="cl">i18n_copiste</xsl:with-param>
			</xsl:call-template>
<!-- 610 -->
<xsl:call-template name="CTRLaccess">
<xsl:with-param name="role">610</xsl:with-param>
<xsl:with-param name="lib">Imprimeur ou éditeur</xsl:with-param>
<xsl:with-param name="property">dcterms:contributor</xsl:with-param>
<xsl:with-param name="cl">i18n_imprimeurEditeur</xsl:with-param>
</xsl:call-template>
			<!-- Editeur commercial (màj déc. 2014) -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">650</xsl:with-param>
				<xsl:with-param name="lib">Editeur commercial</xsl:with-param>
				<xsl:with-param name="property">dcterms:contributor</xsl:with-param>
				<xsl:with-param name="cl">i18n_editeurComm</xsl:with-param>
			</xsl:call-template>
			<!-- 110 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">110</xsl:with-param>
				<xsl:with-param name="lib">Relieur</xsl:with-param>
				<xsl:with-param name="property">dcterms:contributor</xsl:with-param>
                <xsl:with-param name="cl">i18n_relieur</xsl:with-param>
			</xsl:call-template>
			<!-- 390 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">390</xsl:with-param>
				<xsl:with-param name="lib">Propriétaire préc.</xsl:with-param>
				<xsl:with-param name="property">dcterms:contributor</xsl:with-param>
                <xsl:with-param name="cl">i18n_proprietairePrec</xsl:with-param>
			</xsl:call-template>
			<!-- commanditaire màj fev 2014 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">commanditaire</xsl:with-param>
				<xsl:with-param name="lib">Commanditaire</xsl:with-param>
				<xsl:with-param name="property">dcterms:contributor</xsl:with-param>
				<xsl:with-param name="cl">i18n_commanditaire</xsl:with-param>
			</xsl:call-template>
			<!-- mécène màj fev 2014 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">723</xsl:with-param>
				<xsl:with-param name="lib">Mécène</xsl:with-param>
				<xsl:with-param name="property">dcterms:contributor</xsl:with-param>
				<xsl:with-param name="cl">i18n_mecene</xsl:with-param>
			</xsl:call-template>			
			
          			  <!-- Titre d'oeuvre "titre"-->
			<xsl:for-each select=".//title[not(@role='sujet')]">
				<tr>
					<xsl:call-template name="libelle">
						<xsl:with-param name="libelle">Oeuvre</xsl:with-param>
                        <xsl:with-param name="classeI18N">i18n_oeuvre</xsl:with-param>
					</xsl:call-template>
					<td class="eadtitle">
						<xsl:call-template name="entreeRebond">
							<xsl:with-param name="property">frbr:embodimentOf</xsl:with-param>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:for-each>
			
			<!-- Sujet -->
			<!-- Sélectionner :
				. les Sujets hors Controlaccess ;
				. les Sujets entrées primaires d'un Controlaccess ;
				. Les Sujets Entrées secondaires quand l'entrée primaire n'est pas un Sujet.
				. Les lieux Geogname, sauf si role=lieu de production
				. Les points d'accès Name  
			-->
			<xsl:for-each
				select=".//*[@role='sujet' or local-name()= 'subject' or local-name()='name' or local-name()='geogname'][not(parent::controlaccess)][not(@role='lieu de production')]
				|
				controlaccess/*[1][@role='sujet' or local-name()= 'subject' or local-name()='name' or local-name()   = 'geogname'][not(@role='lieu de production')]
				|
				controlaccess/*[1][following-sibling::*[@role='sujet' or local-name()= 'subject' or local-name()='name' or local-name() = 'geogname'][not(@role='lieu de production')]]
				| 
				controlaccess/*[2][@role='sujet' or local-name()= 'subject' or local-name()='name' or local-name()   = 'geogname'][not(@role='lieu de production')]
				[not(preceding-sibling::*[@role='sujet' or local-name()= 'subject' or local-name()= 'geogname' or local-name()= 'persname'])]">
				<tr>
					<xsl:call-template name="libelle">
						<xsl:with-param name="libelle">Sujet</xsl:with-param>
                        <xsl:with-param name="classeI18N">i18n_sujet</xsl:with-param>
					</xsl:call-template>
						<!-- tous les title en italique, meme si role sujet-->
					<xsl:if test="self::title">
						<td class="eadtitle">
							<xsl:call-template name="entreeRebond">
								<xsl:with-param name="property">dcterms:subject</xsl:with-param>
							</xsl:call-template>
							<xsl:for-each select="following-sibling::*[parent::controlaccess]">
								<span>
									<xsl:text> - </xsl:text>
								</span>
								<xsl:call-template name="entreeRebond">
									<xsl:with-param name="property">dcterms:subject</xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>
						</td>
					</xsl:if>
					<xsl:if  test="not(self::title)">
					<td>
						<xsl:call-template name="entreeRebond">
							<xsl:with-param name="property">dcterms:subject</xsl:with-param>
						</xsl:call-template>
						<xsl:for-each select="following-sibling::*[parent::controlaccess]">
							<span>
								<xsl:text> - </xsl:text>
							</span>
							<xsl:call-template name="entreeRebond">
								<xsl:with-param name="property">dcterms:subject</xsl:with-param>
							</xsl:call-template>
						</xsl:for-each>
					</td>
					</xsl:if>
				</tr>
			</xsl:for-each>

			<!--Ajout JMF juin 2012 "lieu de production"-->
			<xsl:for-each select=".//geogname[@role='lieu de production']">
				<tr>
					<xsl:call-template name="libelle">
						<xsl:with-param name="libelle">Lieu de production</xsl:with-param>
						<xsl:with-param name="classeI18N">i18n_lieuProduction</xsl:with-param>
					</xsl:call-template>
					<td class="controlC">
						<xsl:call-template name="entreeRebond">
							<xsl:with-param name="property">frbr:embodimentOf</xsl:with-param>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:for-each>
			
			 <!--Genreform Technique et Genre, forme et fonction - JMF fev. 2012-->
			<xsl:for-each select=".//genreform[@type='technique']">
				<tr>
					<xsl:call-template name="libelle">
						<xsl:with-param name="property">dcterms:type</xsl:with-param>
						<xsl:with-param name="libelle">Technique(s)</xsl:with-param>
						<xsl:with-param name="classeI18N">i18n_technique</xsl:with-param>
					</xsl:call-template>
					<td class="controlCNoClic">
						<xsl:apply-templates select="@normal" /></td>
				</tr>
			</xsl:for-each>
			<xsl:for-each select=".//genreform[@type='genre, forme et fonction']">
				<tr>
					<xsl:call-template name="libelle">
						<xsl:with-param name="property">dcterms:type</xsl:with-param>
						<xsl:with-param name="libelle">Genre(s), forme(s) et fonction(s)</xsl:with-param>
						<xsl:with-param name="classeI18N">i18n_gff</xsl:with-param>
					</xsl:call-template>
					<td class="controlCNoClic">
						<xsl:apply-templates select="@normal" /></td>
					<!--<td ><xsl:call-template name="entreeRebond">
						<xsl:with-param name="property">frbr:embodimentOf</xsl:with-param>
					</xsl:call-template></td>-->
				</tr>
			</xsl:for-each>
			<!-- Pour affichage des TDD comme points d'accès, dans le seul cas où il y a "Plusieurs types de documents" ; voir également dans le template "Result" ci-dessus -->
			<xsl:if test="count(.//genreform[@type='type de document'])>1"><xsl:for-each select=".//genreform[@type='type de document']">
				<tr>
					<xsl:call-template name="libelle">
						<xsl:with-param name="property">dcterms:type</xsl:with-param>
						<xsl:with-param name="libelle">Types de documents</xsl:with-param>
						<xsl:with-param name="classeI18N">i18n_tdd</xsl:with-param>
					</xsl:call-template>
					<td class="controlCNoClic">
						<xsl:apply-templates select="@normal" /></td>
					<!--<td ><xsl:call-template name="entreeRebond">
						<xsl:with-param name="property">frbr:embodimentOf</xsl:with-param>
						</xsl:call-template></td>-->
				</tr>
			</xsl:for-each></xsl:if>
					
		</table>
	</xsl:template>
	<!-- templates auxiliaires -->
	<xsl:template match="p">
	<xsl:if test="(position()=1 and position()!=last()) or (./parent::bibliography and position()=1)">
		<br />
	</xsl:if>
		<xsl:apply-templates/>
		<xsl:if test="position() != last()">
			<br />
		</xsl:if>
	</xsl:template>
	<xsl:template match="emph[@render='super']">
		<sup>
			<xsl:apply-templates/>
		</sup>
	</xsl:template>
	<xsl:template match="emph[@render='italic']">
		<em>
			<xsl:apply-templates/>
		</em>
	</xsl:template>
	<xsl:template match="emph[@render='sub']">
		<sub>
			<xsl:apply-templates/>
		</sub>
	</xsl:template>
	<xsl:template match="blockquote">
		<blockquote>
			<p>
				<xsl:apply-templates/>
			</p>
		</blockquote>
	</xsl:template>
	<!--<xsl:template match="genreform">
		<xsl:text> </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>-->
	<xsl:template match="extref">
		<a href="{@href}" title="{@title}" target="_blank" class="lienExterne">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<xsl:template match="extptr">
		<img src="https://calames.abes.fr/pub/imagesCGMPng/{substring-before(@href, '.tif')}.png"
			alt="Impossible d 'afficher l'image" class="imagesCgm" style="max-width: 100%"/>
	</xsl:template>
	


	<!-- template pour afficher une entree d'index sous forme de lien (rebond en recherche) -->
	<xsl:template name="entreeRebond">
		<xsl:param name="property"/>
		<a>
			<xsl:attribute name="href">
				<xsl:text>javascript:rechCtrlAccess("</xsl:text>
				<xsl:value-of select="local-name(.)"/>
				<xsl:text>","\%22</xsl:text>
				<xsl:choose>
					<xsl:when test="./@normal">
						<xsl:value-of select="./@normal"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>\%22");</xsl:text>
			</xsl:attribute>
			<xsl:call-template name="affName">
				<xsl:with-param name="property" select="$property"/>
				</xsl:call-template>
			</a>
	</xsl:template>

	<!-- template pour afficher la forme normale d'une entree d'index, sinon la forme entre balises -->
	<xsl:template name="affName">
		<xsl:param name="property"/>
		<span>
			<xsl:attribute name="about">
				<xsl:value-of select="$msurl"/>
			</xsl:attribute>
			<xsl:attribute name="typeof">
				<xsl:text>frbrabes:singletonManifestation</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="rel">
				<xsl:value-of select="$property"/>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="./@normal and @authfilenumber">
					<span resource="http://www.idref.fr/{@authfilenumber}/id" property="rdfs:label">
						<xsl:value-of select="./@normal"/>						
					</span>
				</xsl:when>
				<xsl:when test="./@normal and not(@authfilenumber)">
					<span typeof="rdfs:Resource" property="rdfs:label">
						<xsl:value-of select="./@normal"/>						
					</span>
				</xsl:when>
				<xsl:otherwise>
					<span typeof="rdfs:Resource" property="rdfs:label">
						<xsl:value-of select="."/>
					</span>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>
	<!-- template pour afficher le libelle des entrees : pour chaque role, on affiche le libelle une seule fois -->
	<xsl:template name="libelle">
		<xsl:param name="libelle"/>
        <xsl:param name="classeI18N"/><!--rajoute par olga -->
		<xsl:choose>
			<xsl:when test="position() &lt; 2">
                <td class="controlC">
                    <span class="{$classeI18N}">
                        <xsl:value-of select="$libelle"/>
                    </span> : 
                </td>
			</xsl:when>
			<xsl:otherwise>
				<td/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Template général pour afficher libelles des rôles  + valeurs, sauf pour geogname, sujet et title -->
	<xsl:template name="CTRLaccess">
		<xsl:param name="role"/>
		<xsl:param name="lib"/>
		<xsl:param name="property"/>
        <xsl:param name="cl"/><!--rajoute par olga -->
		<xsl:for-each select=".//*[@role=$role]">
			<tr>
				<xsl:call-template name="libelle">
					<xsl:with-param name="libelle" select="$lib"/>
                    <xsl:with-param name="classeI18N" select="$cl"/>
				</xsl:call-template>
                <td>
                    <xsl:call-template name="entreeRebond">
                        <xsl:with-param name="property" select="$property"/>
                    </xsl:call-template>
                </td>
			</tr>
		</xsl:for-each>
	</xsl:template>
<!-- templates ajoutes Enrico juin 2010 -->
<xsl:template match="materialspec">
<div class="materialspec">
<span class="controlC i18n_particulariteDoc">Particularités de certains types de documents
</span> : 
<xsl:apply-templates />
</div>
</xsl:template>
<xsl:template match="accruals">
<div class="accruals">
<span class="controlC i18n_accroissement">Accroissements
</span> : 
<xsl:apply-templates />
</div>
</xsl:template>
<xsl:template match="phystech">
<div class="phystech">
<span class="controlC i18n_caractMaterielle">Caractéristiques matérielles et contraintes techniques
</span> : 
<xsl:apply-templates />
</div>
</xsl:template>
<xsl:template match="appraisal">
<div class="appraisal">
<span class="controlC i18n_evaluationTri">Evaluation et tris
</span> : 
<xsl:apply-templates />
</div>
</xsl:template>
<!--<xsl:template match="ref">
	<xsl:choose>
		<xsl:when test="@href">
			<a href="{@href}" target="_blank">
				<xsl:if test="@title">
					<xsl:attribute name="title">
						<xsl:value-of select="@title"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates />
			</a>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>-->
<xsl:template match="title">
<em>
<xsl:apply-templates />
</em>
</xsl:template>
<!-- fin templates ajoutées -->
<xsl:template name="rdfa">
		<span about="https://calames.abes.fr/pub/ms/{/RESULT/arbre/@id | /RESULT/root/@id}" rel="foaf:primaryTopic" resource="{$msurl}"></span>
		<span about="{$msurl}" rel="foaf:isPrimaryTopicOf" resource="https://calames.abes.fr/pub/ms/{/RESULT/arbre/@id | /RESULT/root/@id}"></span>
	</xsl:template>
</xsl:stylesheet>
<!-- Notes

 . enlever elements de style sur address
 . Palme : langmaterial pb
 . Palme : Controlaccess/persname ou title : on ne traite que le premier enfant, pour respecter la
  logique choisie dans CGM. Pb.
 . Mieux traiter doubles dates.
 .
-->
<!-- Note de version 2.3
repository doit s'afficher à deux endroits différents si dans archdesc ou c! comment faire?
verifier dcterms:contributor pour interprète et imprimeur/éditeur
vérifier attributs pour les balises de lien
-->