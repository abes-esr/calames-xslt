<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- Mapping export DC simple de l'EAD Calames vers template Artwork dans Pattypan 
            https://commons.wikimedia.org/wiki/Template:Artwork/doc                          
            creation octobre 2023 ERM-->
    <!-- Pour faire prendre en compte le codage des retours chariot via le module d'export de l'outil Calames : coder l'entité &#x9; avec au moins un autre caractère précédemment, 
        stratégie de contournement avec la présence de la chaine de caracteres {newline} en fin de chaque ligne, à remplacer par \n\r via NotePad++ /  à l'ouverture dans Excel, 
        utiliser le caractère ¤ comme délimiteur de colonne -->
    <!-- conversion de ead  dans la variable filtre de la fenêtre d'export Calames ; il y a par défaut : //c[@id='CGM-124567']. Attention les simple cote sont doublees -->
    <xsl:output encoding="UTF-8" indent="no" method="text" omit-xml-declaration="yes"/>
    <xsl:param name="filtre"/>
    <!-- Fonctionne avec tous ces types de filtre  (!! remettre double quot pour l'interface Calames) -->
    <!--<xsl:param name="filtre" select="//c[dao | daogrp]"/> -->
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="$filtre">
                <!--  BML 22/10/23: les intitulés de colonnes Wiki doivent être entièrement en minuscules pour pattypan-->
                <!--  ERM 11/10/23: les intitulés de colonnes Wiki-->
                <!-- ERM 21/02/19 pour que l'entité retour chariot, et de manière générale toute entité, puisse être prise en compte dans le module d'export de Calames,  il faut au moins un caractère devant lui => le mettre dans l'intitulé de la dernière colonne, qui doit donc être systématiquement unique, non répétable : "&#xD;-->
                <!--saut de colonne   &#x9;-->
                <xsl:text>"path"&#x9;"name"&#x9;"author"&#x9;"title"&#x9;"description"&#x9;"date"&#x9;"medium"&#x9;"dimensions"&#x9;"accession number"&#x9;"references"&#x9;"source"&#x9;"permission"&#x9;"categories"&#xD;</xsl:text>
                <xsl:for-each select="$filtre">
                    <xsl:apply-templates select="."/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <erreur xsl:exclude-result-prefixes="">Etes-vous sûr de la bonne construction de
                    l'xpath saisi dans le champ "Filtre" de la fenêtre d'export ? Avez-vous bien
                    modifié la valeur du champ "Filtre" donnée à titre d'exemple ? Ce type d'export
                    nécessite de préciser un filtre, celui que vous avez utilisé ne correspond à
                    aucun élément dans le document. Voir la documentation pour plus de précision :
                    http://documentation.abes.fr/aidecalames/manuelcorrespondant/index.html#PrincipesExports.</erreur>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="c">
        <xsl:variable name="id_export" select="@id"/>
        <!--  ERM 11/10/23 : les lignes csv Wikimedia book commencent ici -->
        <!-- 1 - Path (vide) -->
        <xsl:text>""&#x9;</xsl:text>
        <!-- 2 - Name -->
        <!--
           * unittitle [c exporté > c ascendant le plus proche]
           c/did/unittitle  (y compris text() des éléments fils)
           * unitdate [c exporté > c ascendant le plus proche > archdesc]
           c/did//untidate+
           archdesc/did//unidate+
        => NB : <unittitle> et <unitdate> peuvent ne pas appartenir au même <c>
        => NB : <unitdate> uniquement si <unittitle>
        -->
        <xsl:text>"</xsl:text>
        <xsl:variable name="title">
            <xsl:for-each select="ancestor-or-self::c[did/unittitle//text() != ''][1]/did/unittitle">
                <xsl:value-of select="normalize-space(translate(., '&quot;[]', ''))"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="normalize-space($title) != ''">
            <xsl:value-of select="normalize-space($title)"/>
            <xsl:choose>
                <xsl:when test="ancestor-or-self::c[did//unitdate[@normal]]">
                    <xsl:for-each
                        select="ancestor-or-self::c[did//unitdate[@normal]][1]/did//unitdate[@normal]">
                        <xsl:value-of select="concat(' - ', translate(@normal, '[];', ''))"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="//archdesc/did//unitdate[@normal]">
                        <xsl:value-of select="concat(' - ', translate(@normal, '[];', ''))"/>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:text>"&#x9;</xsl:text>
        <!-- 3 - Author -->
        <!--  OLD  OLD  OLD            
            NORMAL de <corpname> ou <persname> ou <famname> si ROLE="auteur" (code fonction Unimarc 070), "auteur adapté" (100), "auteur présumé" (330), "fabricant" ou "producteur".
Cas avec un seul auteur : {{cite web |author=NORMAL de <corpname> ou <persname> ou <famname> |title=(voir l'autorité IdRef) |url=url pérenne IdRef}}
Cas avec plusieurs auteurs : {{cite web |author=NORMAL de <corpname> ou <persname> ou <famname> |title=(voir l'autorité IdRef) |url=url pérenne IdRef |coauthors=Nom, prénom; Nom, prénom; Nom, prénom}}
    -->
        <!--janvier 2024 NORMAL du <corpname> ou <persname> ou <famname> [url notice IdRef (voir l'autorité IdRef)], NORMAL du <corpname> ou <persname> ou <famname> [url notice IdRef (voir l'autorité IdRef)]-->
        <!-- id du c exporté s'il contient au moins 1 author sinon id du c parent  le plus proche qui contient au moins un author, sinon on remonte à archdesc-->
        <!--OLD OLD  <xsl:variable name="id_c">
            <xsl:value-of
                select="ancestor-or-self::c[*[not(descendant-or-self::c)]/descendant-or-self::*[(@role = '070' or @role = '100' or @role = '330' or @role = 'fabricant' or @role = 'producteur') and @normal]][1]/@id"
            />
        </xsl:variable>
        <xsl:variable name="nb_authors">
            <xsl:choose>
                <xsl:when test="$id_c != ''">
                    <xsl:value-of
                        select="count(//c[@id = $id_c]/*[not(descendant-or-self::c)]/descendant-or-self::*[(@role = '070' or @role = '100' or @role = '330' or @role = 'fabricant' or @role = 'producteur') and @normal])"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                        select="count(//archdesc/*[not(c)]/descendant-or-self::*[(@role = '070' or @role = '100' or @role = '330' or @role = 'fabricant' or @role = 'producteur') and @normal])"
                    />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="nb_authors_id">
            <xsl:choose>
                <xsl:when test="$id_c != ''">
                    <xsl:value-of
                        select="count(//c[@id = $id_c]/*[not(descendant-or-self::c)]/descendant-or-self::*[(@role = '070' or @role = '100' or @role = '330' or @role = 'fabricant' or @role = 'producteur') and @normal and @authfilenumber])"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                        select="count(//archdesc/*[not(c)]/descendant-or-self::*[(@role = '070' or @role = '100' or @role = '330' or @role = 'fabricant' or @role = 'producteur') and @normal and @authfilenumber])"
                    />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable> id : <xsl:value-of select="$id_c"/> nb_author : <xsl:value-of
            select="$nb_authors"/> nb_author_id : <xsl:value-of select="$nb_authors_id"/>
                 <xsl:text>"</xsl:text>
           <xsl:if test="$nb_authors > 0">
            <xsl:text>{{cite web |author=</xsl:text>
            <xsl:choose>
                <xsl:when test="$nb_authors_id >= 1">
                    <xsl:choose>
                        <xsl:when test="$id_c != ''">
                            <xsl:call-template name="author">
                                <xsl:with-param name="auth"
                                    select="//c[@id = $id_c]/*[not(descendant-or-self::c)]/descendant-or-self::*[(@role = '070' or @role = '100' or @role = '330' or @role = 'fabricant' or @role = 'producteur') and @normal and @authfilenumber][1]"/>
                                <xsl:with-param name="type" select="'id'"/>
                                <xsl:with-param name="nb_authors" select="$nb_authors"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="author">
                                <xsl:with-param name="auth"
                                    select="//archdesc/*[not(c)]/descendant-or-self::*[(@role = '070' or @role = '100' or @role = '330' or @role = 'fabricant' or @role = 'producteur') and @normal and @authfilenumber][1]"/>
                                <xsl:with-param name="type" select="'id'"/>
                                <xsl:with-param name="nb_authors" select="$nb_authors"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$id_c != ''">
                            <xsl:call-template name="author">
                                <xsl:with-param name="auth"
                                    select="//c[@id = $id_c]/*[not(descendant-or-self::c)]/descendant-or-self::*[(@role = '070' or @role = '100' or @role = '330' or @role = 'fabricant' or @role = 'producteur') and @normal][1]"/>
                                <xsl:with-param name="mode" select="'normal'"/>
                                <xsl:with-param name="nb_authors" select="$nb_authors"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="author">
                                <xsl:with-param name="auth"
                                    select="//archdesc/*[not(c)]/descendant-or-self::*[(@role = '070' or @role = '100' or @role = '330' or @role = 'fabricant' or @role = 'producteur') and @normal][1]"/>
                                <xsl:with-param name="mode" select="'normal'"/>
                                <xsl:with-param name="nb_authors" select="$nb_authors"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>}}</xsl:text>
        </xsl:if>         
        <xsl:text>"&#x9;</xsl:text>-->
        <xsl:text>"</xsl:text>
        <xsl:choose>
            <xsl:when
                test="ancestor-or-self::c[*[not(descendant-or-self::c)]/descendant-or-self::*[(@role = '070' or @role = '100' or @role = '330' or @role = 'fabricant' or @role = 'producteur') and @normal]]">
                <xsl:apply-templates
                    select="ancestor-or-self::c/*[not(descendant-or-self::c)]/descendant-or-self::*[(@role = '070' or @role = '100' or @role = '330' or @role = 'fabricant' or @role = 'producteur') and @normal]"
                    > </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates
                    select="//archdesc/*[not(c)]/descendant-or-self::*[(@role = '070' or @role = '100' or @role = '330' or @role = 'fabricant' or @role = 'producteur') and @normal]"
                />
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>"&#x9;</xsl:text>
        <!-- 4 -Title -->
        <!--  unittitle [c excporté > c ascendant le + proche]
        c/did/unittitle (y compris text() des éléments fils)-->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="normalize-space($title)"/>
        <xsl:text>"&#x9;</xsl:text>
        <!-- 5 - Description -->
        <!--[c exporté]
        scopecontent/p+ (y compris text() éléments fils)
        Ajoute un espace entre les différents p agrégés-->
        <xsl:text>"</xsl:text>
        <xsl:for-each select="scopecontent/p">
            <xsl:value-of select="normalize-space(translate(., '&quot;', ''))"/>
            <xsl:if test="position() != last()">
                <xsl:text>&#x20;</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>"&#x9;</xsl:text>
        <!-- 6 - Date -->
        <!--
 [c excporté > c ascendant le + proche > archdesc]
c/did//untidate+
archdesc/did//unidate+-->
        <xsl:text>"</xsl:text>
        <xsl:choose>
            <xsl:when test="ancestor-or-self::c[did//unitdate[@normal]]">
                <xsl:for-each
                    select="ancestor-or-self::c[did//unitdate[@normal]][1]/did//unitdate[@normal]">
                    <xsl:value-of select="normalize-space(@normal)"/>
                    <xsl:if test="position() != last()">
                        <xsl:text> - </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="//archdesc/did//unitdate[@normal]">
                    <xsl:value-of select="normalize-space(@normal)"/>
                    <xsl:if test="position() != last()">
                        <xsl:text> - </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>"&#x9;</xsl:text>
        <!-- 7 - Medium -->
        <!--[c excporté > c ascendant > archdesc]
par ordre de priorité 
 1. c exporté > c parent le plus proche //physdesc/physfacet[@type = 'technique']+ (y compris text() éléments fils)
 2. archdesc//physdesc/physfacet[@type = 'technique']+ (y compris text() éléments fils)
 3. c exporté > c parent le plus proche  //genreform[@type = 'technique']/@normal
 4. archdesc   //genreform[@type = 'technique']/@normal
Peut-être multivalué ex: {{Technique|oil|canvas}
-->
        <xsl:text>"</xsl:text>
        <xsl:if
            test="ancestor-or-self::c[did/physdesc/physfacet[@type = 'technique'][text() != '']] or //archdesc[did/physdesc/physfacet[@type = 'technique'][text() != '']] or ancestor-or-self::c[*[not(c)]//genreform[@type = 'technique' and @normal]] or //archdesc[*[not(c)]//genreform[@type = 'technique' and @normal]]">
            <xsl:text>{{Technique|</xsl:text>
            <xsl:choose>
                <xsl:when
                    test="ancestor-or-self::c[did/physdesc/physfacet[@type = 'technique'][text() != '']]">
                    <xsl:for-each
                        select="ancestor-or-self::c[did/physdesc/physfacet[@type = 'technique'][text() != '']][1]/did/physdesc/physfacet[@type = 'technique']">
                        <xsl:if test="position() != 1">
                            <xsl:text>|</xsl:text>
                        </xsl:if>
                        <xsl:value-of select="normalize-space(translate(., '&quot;', ''))"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when
                    test="//archdesc/did/physdesc/physfacet[@type = 'technique'][text() != '']">
                    <xsl:for-each select="//archdesc/did/physdesc/physfacet[@type = 'technique']">
                        <xsl:if test="position() != 1">
                            <xsl:text>|</xsl:text>
                        </xsl:if>
                        <xsl:value-of select="normalize-space(translate(., '&quot;', ''))"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when
                    test="ancestor-or-self::c/*[not(descendant-or-self::c)]/descendant-or-self::genreform[@type = 'technique' and @normal]">
                    <xsl:for-each
                        select="ancestor-or-self::c[*[not(descendant-or-self::c)]/descendant-or-self::genreform[@type = 'technique' and @normal]][1]/*[not(descendant-or-self::c)]/descendant-or-self::genreform[@type = 'technique' and @normal]">
                        <xsl:if test="position() != 1">
                            <xsl:text>|</xsl:text>
                        </xsl:if>
                        <xsl:value-of select="normalize-space(@normal)"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each
                        select="//archdesc/*[not(descendant-or-self::c)]/descendant-or-self::genreform[@type = 'technique' and @normal]">
                        <xsl:if test="position() != 1">
                            <xsl:text>|</xsl:text>
                        </xsl:if>
                        <xsl:value-of select="normalize-space(@normal)"/>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>}}</xsl:text>
        </xsl:if>
        <xsl:text>"&#x9;</xsl:text>
        <!-- 8 - Dimensions -->
        <!--
 [c excporté > c ascendant le + proche > archdesc]
c/did/physdesc/dimensions+
archdesc/did/physdesc/dimensions+
        -->
        <xsl:text>"</xsl:text>
        <xsl:choose>
            <xsl:when test="ancestor-or-self::c[did/physdesc/dimensions[text() != '']]">
                <xsl:for-each
                    select="ancestor-or-self::c[did/physdesc/dimensions[text() != '']][1]/did/physdesc/dimensions">
                    <xsl:if test="position() != 1">
                        <xsl:text>&#x20; - ,&#x20;</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="normalize-space(translate(., '&quot;', ''))"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="//archdesc/did/physdesc/dimensions">
                    <xsl:if test="position() != 1">
                        <xsl:text>&#x20; - ,&#x20;</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="normalize-space(translate(., '&quot;', ''))"/>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>"&#x9;</xsl:text>
        <!-- 9 - Accession Number -->
        <!-- [c excporté >  c ascendant le + proche  > archdesc]
        c/did/unitid/@cote 
        archdesc/did/unitid/@cote  -->
        <xsl:text>"</xsl:text>
        <xsl:choose>
            <xsl:when test="ancestor-or-self::c[did/unitid[@type = 'cote'][text() != '']]">
                <xsl:for-each
                    select="ancestor-or-self::c[did/unitid[@type = 'cote'][text() != '']][1]/did/unitid[@type = 'cote'][text() != '']">
                    <xsl:value-of select="normalize-space(translate(., '&quot;', ''))"/>
                    <xsl:if test="position() != 1">
                        <xsl:text> - </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="//archdesc/did/unitid[@type = 'cote']">
                    <xsl:if test="position() != 1">
                        <xsl:text> - </xsl:text>
                    </xsl:if>
                    <xsl:value-of select="normalize-space(translate(., '&quot;', ''))"/>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>"&#x9;</xsl:text>
        <!-- 10 - References -->
        <!--  c exporté/@id 
attribut @title et @href du dao/daogrp [c exporté]
si @title http://www.calames.abes.fr/pub/#details?id=XXXX - dao/@title ou daogrp/daoloc[@role='rebond']/@title : dao/@href ou daogrp/daoloc[@role='rebond']/@href
sinon
http://www.calames.abes.fr/pub/#details?id=@id et numérisation disponible en ligne :  dao/@href ou daogrp/daoloc[@role='rebond']/@href
si abscence de dao/daogrp pour le c exporté
 "Description complète de ce document dans Calames : http://www.calames.abes.fr/pub/#details?id=Calames-XXXX"  -->
        <!-- BML le 29/11/2023 modificaton pour ne prendre en compte que les daoloc de role "rebond" -->
        <xsl:text>"Description complète de ce document dans Calames : http://www.calames.abes.fr/pub/#details?id=</xsl:text>
        <xsl:value-of select="./@id"/>
        <xsl:if test="dao[@href] or daogrp/daoloc[@role = 'rebond'][@href]">
            <xsl:choose>
                <xsl:when test="dao[@title] or daogrp/daoloc[@role = 'rebond'][@title]">
                    <xsl:text>&#x20; - &#x20;</xsl:text>
                    <xsl:value-of select="dao/@title | daogrp/daoloc[@role = 'rebond']/@title"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text> et numérisation disponible en ligne</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&#x20; : &#x20;</xsl:text>
            <xsl:value-of select="dao/@href | daogrp/daoloc[@role = 'rebond']/@href"/>
        </xsl:if>
        <xsl:text>"&#x9;</xsl:text>
        <!--
            ERM version qui remonte dans le c parent le plus proche voire archdesc si pas de dao/daogrp dans le c exporté
            <!-\- id du c exporté s'il contient un dao ou un daogrp sinon id du parent le plus proche qui contient au moins un dao ou un daogrp, sinon on remonte à archdesc -\->
        <xsl:variable name="id_dao">
            <xsl:value-of select="ancestor-or-self::c[dao] | ancestor-or-self::c[daogrp/daoloc]"/>
        </xsl:variable>
        <xsl:if test="$id_dao!='' or //archdesc/dao or //archdesc/daogrp/daoloc ">
        <xsl:choose>
            <xsl:when test="c[@id = $id_c][dao[@title]] or c[@id = $id_c][daogrp/daoloc[@title]]">
                <xsl:text>&#x20; - &#x20;</xsl:text>
                <xsl:value-of select="c[@id = $id_c]/dao/@title | c[@id = $id_c]/daogrp/daoloc/@title"/>
            </xsl:when>
            <xsl:when test="//archdesc[dao[@title]] or //archdesc[daogrp/daoloc[@title]]">
                <xsl:text>&#x20; - &#x20;</xsl:text>
                <xsl:value-of select="//archdesc/dao/@title | //archdesc/daogrp/daoloc/@title"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> et numérisation disponible en ligne</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#x20; : &#x20;</xsl:text>
        <xsl:value-of select="dao/@href | daogrp/daoloc/@href"/>
        </xsl:if>
        <xsl:text>"&#x9;</xsl:text>-->
        <!-- 11 - Source -->
        <xsl:text>"</xsl:text>
        <xsl:value-of select="//archdesc//repository/corpname/@normal"/>
        <xsl:text>"&#x9;</xsl:text>
        <!-- 12 - Permission -->
        <xsl:text>"{{Cc-by-sa-4.0}}"&#x9;</xsl:text>
        <!-- 13 - Categories -->
        <xsl:text>""&#xD;</xsl:text>
    </xsl:template>
    <!--ERM janvier 2024 template remplacé par xsl:template match="*[(@role = '070' or @role = '100' or @role = '330' or @role = 'fabricant' or @role = 'producteur') and @normal]"
               <xsl:template name="author">
        <xsl:param name="auth"/>
        <xsl:param name="type"/>
        <xsl:param name="nb_authors"/>
        <xsl:value-of select="$auth/@normal"/>
        <xsl:if test="$type = 'id'">
            <xsl:text>|title=(voir l'autorité IdRef) |url= https://www.idref.fr/</xsl:text>
            <xsl:value-of select="$auth/@authfilenumber"/>
        </xsl:if>
        <xsl:if test="$nb_authors > 1">
            <xsl:text> |coauthors=</xsl:text>
        </xsl:if>
        <xsl:for-each
            select="$auth/ancestor::c[1]/*[not(descendant-or-self::c)]/descendant-or-self::*[(@role = '070' or @role = '100' or @role = '330' or @role = 'fabricant' or @role = 'producteur') and @normal != $auth/@normal]">
            <xsl:value-of select="@normal"/>
            <xsl:if test="position() != last()">
                <xsl:text>; </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>-->
    <xsl:template
        match="*[(@role = '070' or @role = '100' or @role = '330' or @role = 'fabricant' or @role = 'producteur') and @normal]">
        <xsl:value-of select="@normal"/>
        <xsl:if test="@authfilenumber">
            <xsl:text>[https://www.idref.fr/</xsl:text>
            <xsl:value-of select="@authfilenumber"/>
            <xsl:text> (voir l'autorité IdRef)]</xsl:text>
        </xsl:if>
        <xsl:if test="position() != last()">
            <xsl:text>; </xsl:text>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
