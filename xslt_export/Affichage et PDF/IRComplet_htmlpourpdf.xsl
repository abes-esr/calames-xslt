<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	
	<!-- modele d'export publié sur le github public de l'Abes -->
	
	<xsl:output xmlns="http://www.w3.org/1999/xhtml"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" indent="yes"
		method="html" encoding="UTF-8"/>
	<xsl:variable name="msurl">
		<!-- xsl:text>https://www.calames.abes.fr/pub/ms/res/
			</xsl:text -->
		<xsl:value-of select="/RESULT/arbre/@id | /RESULT/root/@id"/>
	</xsl:variable>
	<xsl:template match="/">
		<!-- uniquement structure de la page html et appel des instructions -->
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
				<!--mise à jour lien css dec 2024 par suite changement environnement serveurs-->
				<!-- ccs est egalement publié sur le github public de l'Abes-->
				<link rel="stylesheet" type="text/css"
					href="https://calames.abes.fr/pub/css/style-visio.css"/>
				<style type="text/css">
					img.carre {
					    float: right;
					}
					div img.carre {
					    height: 10px;
					}
					h4 {
					    display: inline;
					    font-weight: normal;
					}
					.controle_i h3 {
					    display: inline;
					}
					#detail {
					    float: left;
					    width: 700px;
					}
					#detail_IR {
					    float: left;
					    width: 700px;
					}
					#detail_IR ul {
					    list-style: none;
					    padding-top: 5px;
					}
					#detail_IR li {
					    position: relative;
					    list-style: none;
					    padding-top: 5px;
					}</style>
				<link href="images_aix/favicon.gif" type="image/gif" rel="shortcut icon"/>
				<title>
					<xsl:call-template name="titleproper"/>
				</title>
			</head>
			<body>
				<div id="conteneur" class="conteneur">
					<!--ERM decembre 2024 déplacé pour apparaitre sous l'image
					<div id="entete" style="font-size:150%">Calames: Catalogue en ligne des archives
						et des manuscrits de l'enseignement supérieur. </div>-->
					<div id="entete" style="font-size:150%"/>
					<div id="selection">
						<span class="titleproper">Calames: Catalogue en ligne des archives et des manuscrits de l'enseignement supérieur.</span>	
						<ul id="detail_IR">
							<li>
								<div>
									<span class="titleproper">
										<xsl:call-template name="titleproper"/>
									</span>
								</div>
								<div>
									<span class="titleproper-author">
										<xsl:call-template name="titleproper-author"/>
									</span>
								</div>
								<br/>
								<div>
									<xsl:call-template name="informations"/>
								</div>
							</li>
						</ul>
						<ul id="detail">
							<li>
								<div class="intitule">
									<span class="title" style="font-size:150%">
										<xsl:value-of select="//archdesc/did/unittitle"/>
									</span>
								</div>
								<div class="contain">
									<xsl:call-template name="contain_archdesc"/>
								</div>
								<xsl:apply-templates select="ead/archdesc/dsc/c"/>
							</li>
						</ul>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="titleproper">
		<xsl:if test="normalize-space(//titleproper) != ''">
			<xsl:value-of select="normalize-space(//titleproper)"/>
			<xsl:if test="//subtitle">
				<xsl:value-of select="concat(' : ', //subtitle)"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="titleproper-author">
		<xsl:if test="normalize-space(//titleproper) != ''">
			<xsl:if test="//author">
				<xsl:value-of select="concat('Auteur : ', //author)"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="informations">
		<!-- institution responsable   RCR -->
		<xsl:if test="//archdesc/did/repository/corpname"><span class="controlCRepository"
				style="font-size:150%">Organisme responsable </span> : <a style="font-size:150%"
					><xsl:value-of select="normalize-space(//repository/corpname/@normal)"/></a><a
				style="font-size:120%"><xsl:for-each select="//repository/address/addressline"
							><div><xsl:value-of select="."/></div></xsl:for-each></a></xsl:if>
		<hr style="width:250px;"/>
		<xsl:if test="normalize-space(//frontmatter) != ''">
			<p>
				<b><span class="controlCInfos" style="font-size:120%">>Introduction du volume
						imprimé </span> : </b>
				<br/>
				<div>
					<b>
						<xsl:value-of select="normalize-space(//div/head)"/>
					</b>
				</div>
				<xsl:for-each select="//div/p">
					<div>
						<xsl:apply-templates/>
					</div>
				</xsl:for-each>
			</p>
			<hr style="width:250px;"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="contain_archdesc">
		<!-- template d'affichage et d'analyse des elements de archdesc sans dsc -->
		<!-- xsl:apply-templates select="ead/archdesc/*[not(self::dsc)]"/ -->
		<!--<xsl:apply-templates select="ead/archdesc/did/repository"/>-->
		<xsl:apply-templates select="ead/archdesc/note[@type = 'absence']"/>
		<xsl:apply-templates
			select="ead/archdesc/did/unitid[@type = 'cote_actuelle' or @type = 'cote']"/>
		<xsl:apply-templates select="did/unitid[@type = 'division']"/>
		<xsl:apply-templates select="ead/archdesc/child::*[not(self::dsc)]//unitdate" mode="bloc">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/did/langmaterial">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/did/physdesc">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/did/materialspec">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<!-- xsl:apply-templates select="ead/archdesc/did/repository"/ -->
		<xsl:apply-templates select="ead/archdesc/scopecontent">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/arrangement">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/did/origination">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/bioghist">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/note[@type = 'provenance']">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/custodhist">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/acqinfo">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/accruals">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/did/unitid[@type = 'ancienne_cote']"/>
		<xsl:apply-templates select="ead/archdesc/phystech">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/did/physloc">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/accessrestrict">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/altformavail">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/userestrict">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/prefercite">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/separatedmaterial"/>
		<xsl:apply-templates select="ead/archdesc/relatedmaterial">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/originalsloc">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/otherfindaid">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/bibliography">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/processinfo">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/appraisal">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="ead/archdesc/bibref"/>
		<xsl:apply-templates select="ead/archdesc/dao[@href]">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<xsl:apply-templates
			select="ead/archdesc/daogrp[daoloc[@role = 'rebond' or @role = 'manifest_iiif']]">
			<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
			<xsl:with-param name="style" select="'gras'"/>
		</xsl:apply-templates>
		<!-- ERM septembre 2024 : ajout du for-each pour pointer sur le archdesc-->
		<xsl:if
			test="ead/archdesc/*[not(self::dsc)]//*[self::persname[@role] | self::famname[@role] | self::corpname[@role] | self::geogname | self::subject | self::title | self::genreform]">
			<xsl:for-each select="/ead/archdesc">
				<xsl:call-template name="entrees"> </xsl:call-template>
			</xsl:for-each>
		</xsl:if>
		<!--ERM septembre 2024 réécriture avec un choose pour éviter les if-->
		<xsl:choose>
			<xsl:when test="count(ead/archdesc/dsc/c) = 1">
				<br/>
				<span class="txtNbEnfC">Contient 1 composant : </span>
			</xsl:when>
			<xsl:when test="count(ead/archdesc/dsc/c) != 1">
				<br/>
				<span class="txtNbEnfC">Contient&#x20;<xsl:value-of select="count(ead/archdesc/dsc/c)"/>&#x20;composants : </span>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<!-- ************************************************************************************** -->
	<!-- detail de chaque c -->
	<!-- ************************************************************************************** -->
	<xsl:template match="c">
		<!-- <xsl:apply-templates select="did/unittitle"/> -->
		<ul class="enfant">
			<li class="pasSouligne">
				<div class="encart">
					<span class="title" style="font-size:120%">
						<b>
							<xsl:value-of select="did/unittitle"/>
						</b>
					</span>
					<xsl:apply-templates
						select="did/unitid[@type = 'cote_actuelle' or @type = 'cote']"/>
					<xsl:apply-templates select="did/unitid[@type = 'division']"/>
					<xsl:apply-templates select="@id"/>
				</div>
				<div class="contain">
					<xsl:apply-templates select="note[@type = 'absence']"/>
					<!--ERM decembre 2024 déplacé dans le div encart <xsl:apply-templates select="@id"/>-->
					<xsl:apply-templates select="./child::*[not(self::c)]//unitdate" mode="bloc"/>
					<xsl:apply-templates select="did/langmaterial"/>
					<xsl:apply-templates select="did/physdesc"/>
					<xsl:apply-templates select="did/materialspec"/>
					<xsl:apply-templates select="did/repository"/>
					<xsl:apply-templates select="scopecontent"/>
					<xsl:apply-templates select="arrangement"/>
					<xsl:apply-templates select="did/origination"/>
					<xsl:apply-templates select="bioghist"/>
					<xsl:apply-templates select="note[@type = 'provenance']"/>
					<xsl:apply-templates select="custodhist"/>
					<xsl:apply-templates select="acqinfo"/>
					<xsl:apply-templates select="accruals"/>
					<xsl:apply-templates select="did/unitid[@type = 'ancienne_cote']"/>
					<xsl:apply-templates select="phystech"/>
					<xsl:apply-templates select="did/physloc"/>
					<xsl:apply-templates select="accessrestrict"/>
					<xsl:apply-templates select="altformavail"/>
					<xsl:apply-templates select="userestrict"/>
					<xsl:apply-templates select="prefercite"/>
					<xsl:apply-templates select="separatedmaterial"/>
					<xsl:apply-templates select="relatedmaterial"/>
					<xsl:apply-templates select="originalsloc"/>
					<xsl:apply-templates select="otherfindaid"/>
					<xsl:apply-templates select="bibliography"/>
					<xsl:apply-templates select="processinfo"/>
					<xsl:apply-templates select="appraisal"/>
					<xsl:apply-templates select="bibref"/>
					<xsl:apply-templates select="dao"/>
					<xsl:apply-templates
						select="daogrp[daoloc[@role = 'rebond' or @role = 'manifest_iiif']]"/>
					<xsl:if
						test="./child::*[not(self::c)]//persname[@role] | ./child::*[not(self::c)]//corpname[@role] | ./child::*[not(self::c)]//famname[@role] | ./child::*[not(self::c)]//geogname | ./child::*[not(self::c)]//subject | ./child::*[not(self::c)]//title | ./child::*[not(self::c)]//genreform">
						<xsl:call-template name="entrees"> </xsl:call-template>
					</xsl:if>
				</div>
				<!--ERM septembre 2024 réécriture avec un choose pour éviter les if-->
				<xsl:choose>
					<xsl:when test="count(child::c) = 1">
						<br/>
						<span class="txtNbEnfC">Contient 1 composant : </span>
					</xsl:when>
					<xsl:when test="count(child::c) > 1">
						<br/>
						<span class="txtNbEnfC">Contient&#x20;<xsl:value-of select="count(child::c)"/>&#x20;composants : </span>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
				<xsl:apply-templates select="c"/>
			</li>
		</ul>
	</xsl:template>
	<!-- redondances language -->
	<!-- xsl:template name="langue"match="child::*[not(self::c or self::dsc)]//language" -->
	<!-- xsl:param name="lang"/ -->
	<!-- les documents bilingues ne generent pas de redondances -->
	<!-- xsl:if test="not(preceding-sibling::language) and not(following-sibling::language)">
														<xsl:if test="ancestor::*[self::c or self::archdesc]/child::*[not(self::c) and not(self::dsc)]//language[generate-id(.) != generate-id(current()) and normalize-space(.)=normalize-space(current())]">
														<div class="controle_d" style="display:none;">
														<h4>
														<xsl:text disable-output-escaping="yes">Langue
															</xsl:text>
														</h4>
														<b>
														<xsl:value-of select="normalize-space(.)"/>
															</b>
															<xsl:text disable-output-escaping="yes"> est déjà présente dans
																</xsl:text>
															<xsl:for-each select="ancestor::*[self::c or self::archdesc]/child::*[not(self::c) and not(self::dsc)]//language[generate-id(.) != generate-id(current()) and normalize-space(.)=normalize-space(current())]">
																<xsl:call-template name="redondance"/>
																</xsl:for-each>
															<img class="carre" src="https://www.calames.abes.fr/prod/xsl/images/marron.jpg" alt="Redondance"/>
															</div>
															</xsl:if>
															</xsl:if>
															</xsl:template -->
	<!-- recuperation unitid popur constructon du lien url -->
	<xsl:template match="@id">
		<xsl:variable name="Permalien">
			<xsl:text>https://www.calames.abes.fr/pub/ms/</xsl:text>
			<xsl:value-of select="."/>
		</xsl:variable>
		<br/>
		<span class="controlC i18n_orgmResponsable">Adresse URL : <a href="{$Permalien}"
				target="_blank" name="permalien" class="permalienC"
					>https://www.calames.abes.fr/pub/ms/<xsl:value-of select="."/></a></span>

	</xsl:template>
	<!-- parties hautes -->
	<xsl:template match="repository">
		<p>
			<span class="controlC i18n_orgmResponsable" style="font-size:150%">Organisme responsable </span>
			<br/>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="corpname">
		<span class="controlC i18n_orgmResponsable" style="font-size:100%">
			<xsl:value-of select="."/>
		</span>
	</xsl:template>
	<!-- modifie Enrico Cima juin 2010 -->
	<xsl:template match="address">
		<span class="controlC i18n_orgmResponsable" style="font-size:110%">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<!-- fin modifications -->
	<xsl:template match="addressline">
		<xsl:value-of select="."/>
		<br/>
	</xsl:template>
	<!-- modif 19 janvier 08 -->
	<!-- remodifie par Enrico Cima juin 2010 -->
	<!-- ERM septembre 2024 : ajout d'un template nommé pour la mise en gras-->
	<xsl:template name="style">
		<xsl:param name="style"/>
		<xsl:param name="chaine"/>
		<xsl:choose>
			<xsl:when test="$style = 'gras'">
				<b>
					<xsl:value-of select="$chaine"/>
				</b>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$chaine"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="physloc">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Lieu de conservation : </xsl:text>
		</xsl:variable>
		<div class="physloc">
			<span class="controlC i18n_lieuConservation" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="userestrict">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Conditions d'utilisation : </xsl:text>
		</xsl:variable>
		<div class="userrestrict">
			<span class="controlC i18n_condUtilisation" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates select="p"/>
		</div>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="prefercite">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Citer sous la forme : </xsl:text>
		</xsl:variable>
		<div class="prefercite">
			<span class="controlC i18n_citerSousForme" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates select="p"/>
		</div>
	</xsl:template>
	<!-- fin modifications -->
	<xsl:template match="lb">
		<br/>
	</xsl:template>
	<!-- fin parties hautes -->
	<!-- templates balises -->
	<!-- AC: J'ai ajoute did/ aux match des cotes pr la transformation des cotes en javascript-->
	<xsl:template match="did/unitid[@type = 'cote_actuelle' or @type = 'cote']">
		<i>
			<!-- ERM <div class="cote_actuelle">-->
			<br/>
			<span class="controlC i18n_cote" style="font-size:110%">Cote :
				<xsl:apply-templates/></span>
			<!-- ERM </div>-->
		</i>
	</xsl:template>
	<!-- modification Enrico juin 2010 -->
	<!-- a voir avec javascript -->
	<xsl:template match="did/unitid[@type = 'division']">
		<i>
			<!-- ERM <div class="cote_actuelle">-->
			<br/>
			<span class="controlC i18n_cote" style="font-size:110%">Cote : <xsl:value-of
					select="concat(ancestor::*[self::c or self::archdesc][./did/unitid[@type = 'cote_actuelle' or @type = 'cote']][1]/did/unitid, ' / ', .)"
				/></span>
			<!-- ERM </div>-->
		</i>
	</xsl:template>
	<!-- fin modifications -->
	<!-- Ajouts Olga. L'appel des cote_unique, i.e. des cotes reconstruites Cote + Division(s), ne peut  PAS fonctionner : cela supposerait de faire appel à calames.js -->
	<!--  <xsl:template match="did/unitid[@type='cote_unique']">
			<div class="cote_actuelle">
			<span id="coteUnique" class="controlC i18n_cote">Cote
			</span> :
			<span class="cote_unique" property="dc:identifier" about="{$msurl}">
			<xsl:attribute name="typeof">
			<xsl:text>frbrabes:singletonManifestation
			</xsl:text>
			</xsl:attribute>
			<xsl:apply-templates/>
			</span>
				</div>
			</xsl:template>-->
	<xsl:template match="did/unitid[@type = 'ancienne_cote']">
		<i>
			<div class="ancienne_cote">
				<span class="controlC i18n_coteAncienne" style="font-size:110%">Ancienne cote :
					<xsl:apply-templates/></span>
			</div>
		</i>
	</xsl:template>
	<!-- modifie par Enrico juillet 2010 -->
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="accessrestrict">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Conditions d'accès : </xsl:text>
		</xsl:variable>
		<div class="c_accessrestrict">
			<span class="controlC i18n_condAcces" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates select="p"/>
		</div>
	</xsl:template>
	<!-- fin modifications -->
	<xsl:template match="note[@type = 'absence']">
		<p class="important">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="scopecontent">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Description : </xsl:text>
		</xsl:variable>
		<div class="scopecontent">
			<span class="controlC i18n_description" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates select="p"/>
		</div>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="physdesc">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Description physique : </xsl:text>
		</xsl:variable>
		<div class="physdesc">
			<span class="controlC i18n_descPhysique" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:if test="text()">
				<span>
					<xsl:apply-templates
						select="text() | physfacet | extent | dimensions | .//genreform"/>
				</span>
			</xsl:if>
			<xsl:if test="not(./text())">
				<xsl:for-each select="node()">
					<span>
						<xsl:apply-templates/>
						<xsl:text>. </xsl:text>
						<xsl:if test="position() != last()">
							<xsl:text/>
						</xsl:if>
					</span>
				</xsl:for-each>
			</xsl:if>
		</div>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="altformavail">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Autre support : </xsl:text>
		</xsl:variable>
		<div class="altformavail">
			<span class="controlC i18n_autreSupport" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="unitdate" mode="bloc">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Date : </xsl:text>
		</xsl:variable>
		<div class="unitdate">
			<span class="controlC i18n_date" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="langmaterial[.//text()]">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Langue : </xsl:text>
		</xsl:variable>
		<div class="langmaterial">
			<span class="controlC i18n_langue" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<span class="lang">
				<xsl:apply-templates/>
			</span>
		</div>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="note[@type = 'provenance']">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Provenance : </xsl:text>
		</xsl:variable>
		<div class="provenance">
			<span class="controlC i18n_provenance" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="bioghist">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Biographie ou histoire : </xsl:text>
		</xsl:variable>
		<div class="bioghist">
			<span class="controlC i18n_biographie" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="arrangement">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Classement : </xsl:text>
		</xsl:variable>
		<div class="arrangement">
			<span class="controlC i18n_classement" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="processinfo">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Informations sur le traitement : </xsl:text>
		</xsl:variable>
		<div class="processinfo">
			<span class="controlC i18n_infoTraitement" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="custodhist">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Provenance : </xsl:text>
		</xsl:variable>
		<div class="custodhist">
			<span class="controlC i18n_provenance" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="acqinfo">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Modalités 
				d'entrée dans la collection : </xsl:text>
		</xsl:variable>
		<div class="acqinfo">
			<span class="controlC i18n_modalEntrCollection" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="origination">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Producteur du fonds ou collectionneur : </xsl:text>
		</xsl:variable>
		<div class="origination">
			<span class="controlC i18n_producteurFondsCollect" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="relatedmaterial">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Documents en relation : </xsl:text>
		</xsl:variable>
		<div class="relatedmaterial">
			<span class="controlC i18n_docEnRelation" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="originalsloc">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Localisation des originaux : </xsl:text>
		</xsl:variable>
		<div class="originalsloc">
			<span class="controlC i18n_locOriginaux" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="otherfindaid">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Autre instrument de recherche : </xsl:text>
		</xsl:variable>
		<div class="otherfindaid">
			<span class="controlC i18n_autreInstrRech" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- modifie par Enrico juin 2010-->
	<!--<xsl:template match="bibliography">
		<div class="bibliography">
			<span class="controlC i18n_bibliographie">
				<xsl:text>Bibliographie 
																						</xsl:text>
			</span>
			<span>
				<xsl:for-each select="head">
					<xsl:text>- 
																							</xsl:text>
					<xsl:value-of select="."/>
					<xsl:text/>
				</xsl:for-each>
				<xsl:text>:
																							</xsl:text>
			</span>
			<xsl:apply-templates select="p | bibref"/>
			<!-\- xsl:apply-templates select="bibref"/ -\->
		</div>
	</xsl:template>-->
	<!-- fin modifications -->
	<!--
	<xsl:template match="separatedmaterial">
		<div class="separatedmaterial">
			<span class="controlC i18n_docSepares">Documents separes </span> :
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-\- modifie Enrico juin 2010 -\->
	<xsl:template match="p/bibref">
		<xsl:choose>
			<xsl:when test="@href">
				<a href="{@href}" title="{@title}" target="_blank">
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="bibref">
		<!-\- j'ai supprime un div -\->
		<xsl:choose>
			<xsl:when test="@href">
				<a href="{@href}" title="{@title}" target="_blank">
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-\- modifie Enrico juin 2010 -\->
	<xsl:template match="archref">
		<xsl:choose>
			<xsl:when test="@href">
				<a href="{@href}" title="{@title}" target="_blank">
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-\- fin modifications -\->
	<xsl:template match="dao[@role = 'rebond']">
		<div class="rebond">
			<span class="controlC i18n_lien">Lien </span> : <a href="{@href}"
				class="i18n_infoComplReliure">Informations complementaires sur la reliure </a>
		</div>
	</xsl:template>-->
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="bibliography">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Bibliographie : </xsl:text>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="p">
				<div class="bibliography">
					<span class="controlC i18n_bibliographie" style="font-size:110%">
						<xsl:call-template name="style">
							<xsl:with-param name="style" select="$style"/>
							<xsl:with-param name="chaine" select="$chaine"/>
						</xsl:call-template>
					</span>
					<xsl:apply-templates select="p"/>
				</div>
			</xsl:when>
			<xsl:when test="head | bibref">
				<div class="bibliography">
					<span class="controlC i18n_bibliographie" style="font-size:110%">
						<xsl:call-template name="style">
							<xsl:with-param name="style" select="$style"/>
							<xsl:with-param name="chaine" select="$chaine"/>
						</xsl:call-template>
					</span>
					<span>
						<xsl:for-each select="head">
							<br/>
							<!-- pb non conservation des espaces
								<xsl:text>- </xsl:text>-->
							<xsl:value-of select="."/>
						</xsl:for-each>
						<xsl:text> : </xsl:text>
					</span>
				</div>
				<span>
					<xsl:for-each select="bibref">
						<xsl:if test="not(@href)">
							<div>
								<xsl:value-of select="."/>
							</div>
						</xsl:if>
						<xsl:if test="@href">
							<a href="{@href}" title="{@title}" target="_blank" class="lienExterne">
								<xsl:apply-templates/>
							</a>
						</xsl:if>
					</xsl:for-each>
				</span>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="bibref">
		<xsl:choose>
			<xsl:when test="@href">
				<a href="{@href}" title="{@titres}" target="_blank" class="lienExterne">
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="archref[@href]">
		<a href="{@href}" title="{@title}" target="_blank" class="lienExterne">
			<xsl:apply-templates/>
		</a>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="dao[@href]">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Version(s) numérique(s) : </xsl:text>
		</xsl:variable>
		<span class="controlC i18n_dao" style="font-size:110%">
			<xsl:call-template name="style">
				<xsl:with-param name="style" select="$style"/>
				<xsl:with-param name="chaine" select="$chaine"/>
			</xsl:call-template>
		</span>
		<xsl:if test="daodesc[not(@audience = 'internal')]/p">
			<!--<span><xsl:value-of select="daodesc/p" /></span> -  -->
			<xsl:apply-templates/>
			<xsl:text> - </xsl:text>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="@title">
				<span class="numerisation">
					<a href="{@href}" target="_blank" class="lienExterne">
						<xsl:value-of select="@title"/>
					</a>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="numerisation">
					<a href="{@href}" target="_blank" class="lienExterne">Disponible en ligne</a>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="daogrp[daoloc[@role = 'rebond' or @role = 'manifest_iiif']]">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Version(s) numérique(s) : </xsl:text>
		</xsl:variable>
		<xsl:if test="daodesc[not(@audience = 'internal')]/p">
			<xsl:apply-templates/>
		</xsl:if>
		<xsl:for-each select="daoloc[@role = 'rebond' or @role = 'manifest_iiif']">
			<div class="rebond">
				<span class="controlC i18n_dao" style="font-size:110%">
					<xsl:call-template name="style">
						<xsl:with-param name="style" select="$style"/>
						<xsl:with-param name="chaine" select="$chaine"/>
					</xsl:call-template>
				</span>
				<xsl:if test="daodesc[not(@audience = 'internal')]/p">
					<!--<div><span><xsl:value-of select="daodesc/p" /></span> - </div>-->
					<xsl:apply-templates/>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="@title">
						<span class="numerisation">
							<a href="{@href}" target="_blank" class="lienExterne">
								<xsl:value-of select="@title"/>
							</a>
						</span>
					</xsl:when>
					<!--<xsl:when test="not(@title)">-->
					<xsl:when test="daoloc[@role = 'rebond']">
						<span class="numerisation">
							<a href="{@href}" target="_blank" class="lienExterne">Disponible en
								ligne </a>
						</span>
					</xsl:when>
				</xsl:choose>
			</div>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="entrees">
		<table class="accesstable">
			<!-- ordre modifie Enrico juin 2010 -->
			<!-- producteur -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">producteur</xsl:with-param>
				<xsl:with-param name="lib">Producteur du fonds ou collectionneur </xsl:with-param>
				<xsl:with-param name="cl">i18n_producteurFondsCollect </xsl:with-param>
			</xsl:call-template>
			<!-- 070 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">070</xsl:with-param>
				<xsl:with-param name="lib">Auteur </xsl:with-param>
				<xsl:with-param name="cl">i18n_auteur </xsl:with-param>
			</xsl:call-template>
			<!-- 330 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">330</xsl:with-param>
				<xsl:with-param name="lib">Auteur supposé </xsl:with-param>
				<xsl:with-param name="cl">i18n_auteurSupp </xsl:with-param>
			</xsl:call-template>
			<!-- fabricant màj nov 2011-->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">fabricant</xsl:with-param>
				<xsl:with-param name="lib">Fabricant </xsl:with-param>
				<xsl:with-param name="cl">i18n_fabricant </xsl:with-param>
			</xsl:call-template>
			<!-- 730 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">730 </xsl:with-param>
				<xsl:with-param name="lib">Traducteur </xsl:with-param>
				<xsl:with-param name="cl">i18n_traducteur </xsl:with-param>
			</xsl:call-template>
			<!-- 340 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">340</xsl:with-param>
				<xsl:with-param name="lib">Editeur scientifique </xsl:with-param>
				<xsl:with-param name="cl">i18n_editeurScient </xsl:with-param>
			</xsl:call-template>
			<!-- 440 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">440</xsl:with-param>
				<xsl:with-param name="lib">Illustrateur </xsl:with-param>
				<xsl:with-param name="cl">i18n_illustrateur </xsl:with-param>
			</xsl:call-template>
			<!-- 212 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">212</xsl:with-param>
				<xsl:with-param name="lib">Commentateur </xsl:with-param>
				<xsl:with-param name="cl">i18n_commentateur </xsl:with-param>
			</xsl:call-template>
			<!-- 220 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">220</xsl:with-param>
				<xsl:with-param name="lib">Compilateur </xsl:with-param>
				<xsl:with-param name="cl">i18n_compilateur </xsl:with-param>
			</xsl:call-template>
			<!-- 020 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">020</xsl:with-param>
				<xsl:with-param name="lib">Annotateur </xsl:with-param>
				<xsl:with-param name="cl">i18n_annotateur </xsl:with-param>
			</xsl:call-template>
			<!-- 100 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">100</xsl:with-param>
				<xsl:with-param name="lib">Auteur adapté </xsl:with-param>
				<xsl:with-param name="cl">i18n_auteurAdap </xsl:with-param>
			</xsl:call-template>
			<!-- Ajout ENO en septembre 2024 -->
			<!-- Commanditaire -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">commanditaire</xsl:with-param>
				<xsl:with-param name="lib">Commanditaire </xsl:with-param>
				<xsl:with-param name="cl">i18n_commanditaire </xsl:with-param>
			</xsl:call-template>
			<!-- 590 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">590</xsl:with-param>
				<xsl:with-param name="lib">Interprète </xsl:with-param>
				<xsl:with-param name="cl">i18n_interprete </xsl:with-param>
			</xsl:call-template>
			<!-- 660 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">660</xsl:with-param>
				<xsl:with-param name="lib">Destinataire de lettre </xsl:with-param>
				<xsl:with-param name="cl">i18n_destinataire </xsl:with-param>
			</xsl:call-template>
			<!-- 280 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">280</xsl:with-param>
				<xsl:with-param name="lib">Dédicataire </xsl:with-param>
				<xsl:with-param name="cl">i18n_dedicataire </xsl:with-param>
			</xsl:call-template>
			<!-- 700 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">700</xsl:with-param>
				<xsl:with-param name="lib">Copiste </xsl:with-param>
				<xsl:with-param name="cl">i18n_copiste </xsl:with-param>
			</xsl:call-template>
			<!-- Ajout ENO en septembre 2024 -->
			<!-- 723 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">723</xsl:with-param>
				<xsl:with-param name="lib">Mécène </xsl:with-param>
				<xsl:with-param name="cl">i18n_Mecene </xsl:with-param>
			</xsl:call-template>
			<!-- 610 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">610</xsl:with-param>
				<xsl:with-param name="lib">Imprimeur ou éditeur </xsl:with-param>
				<xsl:with-param name="cl">i18n_imprimeurEditeur </xsl:with-param>
			</xsl:call-template>
			<!-- Ajout ENO en septembre 2024 -->
			<!-- 650 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">650</xsl:with-param>
				<xsl:with-param name="lib">Editeur commercial </xsl:with-param>
				<xsl:with-param name="cl">i18n_Editeurcommercial </xsl:with-param>
			</xsl:call-template>
			<!-- 110 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">110</xsl:with-param>
				<xsl:with-param name="lib">Relieur </xsl:with-param>
				<xsl:with-param name="cl">i18n_relieur </xsl:with-param>
			</xsl:call-template>
			<!-- 390 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">390</xsl:with-param>
				<xsl:with-param name="lib">Propriétaire précédent </xsl:with-param>
				<xsl:with-param name="cl">i18n_proprietairePrec </xsl:with-param>
			</xsl:call-template>
			<!-- Ajout ENO en septembre 2024 -->
			<!-- 920 -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">920</xsl:with-param>
				<xsl:with-param name="lib">Propriétaire actuel </xsl:with-param>
				<xsl:with-param name="cl">i18n_proprietaireactuel </xsl:with-param>
			</xsl:call-template>
			<!-- Ajout ENO en septembre 2024 -->
			<!-- participant -->
			<xsl:call-template name="CTRLaccess">
				<xsl:with-param name="role">participant</xsl:with-param>
				<xsl:with-param name="lib">Participant </xsl:with-param>
				<xsl:with-param name="cl">i18n_participant </xsl:with-param>
			</xsl:call-template>
			<!-- Titre d'oeuvre -->
			<xsl:for-each
				select="./child::*[not(self::dsc)][not(self::c)]//title[not(@role = 'sujet')]">
				<tr>
					<xsl:call-template name="libelle">
						<xsl:with-param name="libelle">Oeuvre </xsl:with-param>
						<xsl:with-param name="classeI18N">i18n_oeuvre </xsl:with-param>
					</xsl:call-template>
					<td class="eadtitle">
						<xsl:call-template name="entreeRebond"/>
					</td>
				</tr>
			</xsl:for-each>
			<!-- Sujet -->
			<!-- Selectionner :. les Sujets hors Controlaccess ;. les Sujets entrees primaires d'un Controlaccess ;. Les Sujets Entrees secondaires quand l'entree primaire n'est pas un Sujet.-->
			<!-- ERM septembre 2024 pour construire les sujets dans les controlaccess-->
			<xsl:for-each
				select="./child::*[not(self::dsc)][not(self::c)]//*[@role = 'sujet' or local-name() = 'subject'][parent::controlaccess][1] | ./child::*[not(self::dsc)][not(self::c)]//*[@role = 'sujet' or local-name() = 'subject'][not(parent::controlaccess)]">
				<tr>
					<xsl:call-template name="libelle">
						<xsl:with-param name="libelle">Sujet </xsl:with-param>
						<xsl:with-param name="classeI18N">i18n_sujet </xsl:with-param>
					</xsl:call-template>
					<td>
						<xsl:call-template name="entreeRebond"/>
						<xsl:for-each
							select="following-sibling::*[@role = 'sujet'][parent::controlaccess]">
							<span>
								<xsl:text> - </xsl:text>
							</span>
							<xsl:call-template name="entreeRebond"/>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:for-each>
			<!-- Ajouts pour geogname ROLE "lieu de production" dans un <c> ou un <archdesc> en août 2024 par ENO, pour mise en conformité avec l'interface publique -->
			<xsl:for-each
				select="./child::*[not(self::dsc)][not(self::c)]//geogname[@role = 'lieu de production']">
				<tr>
					<xsl:call-template name="libelle">
						<xsl:with-param name="libelle">Lieu de production </xsl:with-param>
						<xsl:with-param name="classeI18N">i18n_lieuProduction</xsl:with-param>
					</xsl:call-template>
					<td class="controlC">
						<xsl:call-template name="entreeRebond"/>
					</td>
				</tr>
			</xsl:for-each>
			<!-- Genreform TDD, Techniques et GFF -->
			<xsl:for-each
				select="./child::*[not(self::dsc)][not(self::c)]//genreform[@type = 'type de document']">
				<tr>
					<xsl:call-template name="libelle">
						<xsl:with-param name="libelle">Type de document </xsl:with-param>
						<xsl:with-param name="classeI18N">i18n_technique </xsl:with-param>
					</xsl:call-template>
					<td>
						<xsl:apply-templates select="@normal"/>
					</td>
				</tr>
			</xsl:for-each>
			<xsl:for-each
				select="./child::*[not(self::dsc)][not(self::c)]//genreform[@type = 'technique']">
				<tr>
					<xsl:call-template name="libelle">
						<xsl:with-param name="libelle">Technique(s) </xsl:with-param>
						<xsl:with-param name="classeI18N">i18n_technique </xsl:with-param>
					</xsl:call-template>
					<td>
						<xsl:apply-templates select="@normal"/>
					</td>
				</tr>
			</xsl:for-each>
			<xsl:for-each
				select="./child::*[not(self::dsc)][not(self::c)]//genreform[@type = 'genre, forme et fonction']">
				<tr>
					<xsl:call-template name="libelle">
						<xsl:with-param name="libelle">Genre(s), forme(s) et fonction(s) </xsl:with-param>
						<xsl:with-param name="classeI18N">i18n_gff </xsl:with-param>
					</xsl:call-template>
					<td>
						<xsl:apply-templates select="@normal"/>
					</td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
	<!-- templates auxiliaires -->
	<!-- modifie par  Enrico Cima juin 2010 -->
	<xsl:template match="p">
		<xsl:if
			test="(position() = 1 and position() != last()) or (./parent::bibliography and position() = 1)">
			<br/>
		</xsl:if>
		<xsl:apply-templates/>
		<xsl:if test="position() != last()">
			<br/>
		</xsl:if>
	</xsl:template>
	<!-- fin modifications -->
	<xsl:template match="emph[@render = 'super']">
		<sup>
			<xsl:apply-templates/>
		</sup>
	</xsl:template>
	<xsl:template match="emph[@render = 'italic']">
		<em>
			<xsl:apply-templates/>
		</em>
	</xsl:template>
	<!-- Ajout dernier cas pour RENDER de <emph> pour mise en conformité avec affichage public par ENO en septembre 2024 -->
	<xsl:template match="emph[@render = 'sub']">
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
	<xsl:template match="genreform">
		<xsl:text/>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="extref">
		<a href="{@href}" title="{@title}" target="_blank">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<xsl:template match="extptr">
		<img
			src="https://www.calames.abes.fr/pub/imagesCGMPng/{substring-before(@href, '.tif')}.png"
			alt="Impossible d 'afficher l'image" class="imagesCgm" style="max-width: 100%"/>
	</xsl:template>
	<!-- template pour afficher une entree d'index sous forme de lien (rebond en recherche) -->
	<xsl:template name="entreeRebond">
		<a>
			<xsl:call-template name="affName"/>
		</a>
	</xsl:template>
	<!-- template pour afficher la forme normale d'une entree d'index, sinon la forme entre balises -->
	<xsl:template name="affName">
		<span>
			<xsl:choose>
				<xsl:when test="./@normal">
					<xsl:value-of select="./@normal"/>
					<xsl:if test="@authfilenumber">
						<xsl:variable name="url">
							<xsl:text>http://www.idref.fr/</xsl:text>
							<xsl:value-of select="concat(./@authfilenumber, '/id')"/>
						</xsl:variable>
						<span class="lienExterne">
							<xsl:text> [</xsl:text>
							<a href="{$url}" target="_blank" class="lienExterne">Entité IdRef</a>
							<xsl:text>]</xsl:text>
						</span>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>
	<!-- template pour afficher le libelle des entrees : pour chaque role, on affiche le libelle une seule fois -->
	<xsl:template name="libelle">
		<xsl:param name="libelle"/>
		<xsl:param name="classeI18N"/>
		<!--rajoute par olga -->
		<xsl:choose>
			<xsl:when test="position() = 1">
				<td class="controlC {$classeI18N}" width="20%"><xsl:value-of select="$libelle"/> :
				</td>
			</xsl:when>
			<xsl:otherwise>
				<td/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Template general pour afficher libelles des roles  valeurs, sauf pour geogname, sujet et title -->
	<xsl:template name="CTRLaccess">
		<xsl:param name="role"/>
		<xsl:param name="lib"/>
		<xsl:param name="cl"/>
		<!--rajoute par olga -->
		<!-- modifie Enrico juin 2010 -->
		<!-- xsl:for-each select=".//*[@role=$role]" -->
		<!--ERM sept 2024 paramètre inutilisé-->
		<!--	<xsl:param name="property"/>-->
		<xsl:for-each select="./child::*[not(self::dsc)][not(self::c)]//*[@role = $role]">
			<tr>
				<xsl:call-template name="libelle">
					<xsl:with-param name="libelle" select="$lib"/>
					<xsl:with-param name="classeI18N" select="$cl"/>
				</xsl:call-template>
				<td>
					<xsl:call-template name="entreeRebond"
						><!--ERM sept 2024 paramètre inutilisé--><!--<xsl:with-param name="property" select="$property"/>--></xsl:call-template>
				</td>
			</tr>
		</xsl:for-each>
		<!-- fin modifications -->
	</xsl:template>
	<!-- fin templates balises -->
	<!-- templates ajoutees Enrico juin 2010 -->
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="materialspec">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Particularités de certains types de documents : </xsl:text>
		</xsl:variable>
		<div class="materialspec">
			<span class="controlC i18n_particulariteDoc" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="accruals">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Accroissements : </xsl:text>
		</xsl:variable>
		<div class="accruals">
			<span class="controlC i18n_accroissement" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="phystech">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Caractéristiques matérielles et contraintes techniques : </xsl:text>
		</xsl:variable>
		<div class="phystech">
			<span class="controlC i18n_caractMaterielle" style="font-size:110%">
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
		</div>
	</xsl:template>
	<!-- ERM septembre 2024 : ajout du paramètre "style" dans le template pour la mise en forme via le template nommé "style"  -->
	<xsl:template match="appraisal">
		<xsl:param name="style"/>
		<xsl:variable name="chaine">
			<xsl:text>Evaluation et tris : </xsl:text>
		</xsl:variable>
		<div class="appraisal">
			<span class="controlC i18n_evaluationTri" style="font-size:110%">
				<xsl:apply-templates/>
				<xsl:call-template name="style">
					<xsl:with-param name="style" select="$style"/>
					<xsl:with-param name="chaine" select="$chaine"/>
				</xsl:call-template>
			</span>
		</div>
	</xsl:template>
	<!--<xsl:template match="ref">
		<xsl:if test="@href">
			<a href="{@href}" title="{@title}" target="_blank">
				<xsl:apply-templates/>
			</a>
		</xsl:if>
	</xsl:template>-->
	<xsl:template match="title">
		<em>
			<xsl:apply-templates/>
		</em>
	</xsl:template>
	<!-- fin templates ajoutees -->
</xsl:stylesheet>
