<?xml version="1.0" encoding="UTF-8"?>
<!-- ===================================================================== 
	an sample XSLT stylesheet                                                  
	
	
	Release  15/01/2006                                                 
	Fabio Vitali - University of Bologna                                
	
	The present XSLT stylesheet uses DTD entities to manage variability
	and reach flexibility. This allows a single stylesheet to handle multiple
	document types and different uses for the same element types. Additional 
	XSLT stylesheets for specific document types do not need such complexity. 
	===================================================================== -->
	
<!DOCTYPE xsl:stylesheet [

<!ENTITY resolver "http://www.parliaments.info/an/resolver.php?urn=">  <!--
      The resolver entity contains the URL of the URN->URL resolver for an --> 

<!ENTITY title "t">  <!--
      The title entity control the content of the title of the document. Possible values: 
      - t:  just the ActTitle, 
      - tn: the ActTitle and then the ActNumber, 
      - nt: the ActNumber and then the ActTitle     -->
      
<!ENTITY OneCol   "an:report[.//an:item]"> 
<!ENTITY LeftPane "an:act | an:bill | an:doc | an:report | an:minutes">  <!-- 
     The layout entities control the overall layout organization of the page. 
     They contain the doc type of the document that will be shown in that layout: 
      - OneCol: A single column with all data vertically spaced
      - LeftPane: the topmost area contains the preface, a left pane contains
                  a list of links to the sections of the clauses part, and a
                  large column on the right contains the rest of the document.  -->

<!ENTITY hierarchyN-T-C    "an:section     | an:part | an:paragraph   | an:chapter | dummy"> 
<!ENTITY hierarchyNT-C     "an:article     | an:item[an:title]        | an:artigo  | dummy">
<!ENTITY hierarchyNC       "an:clause      | an:item[not(an:title)]   | dummy">
<!ENTITY hierarchyT-C      "an:subdivision | dummy">   <!--
       The hierarchy* entities control the type of layout to be given to hierarchical elements in an documents. 
       These are three of the many possible layouts: 
       - N-T-C: puts on separate lines (-) the (N)um first, then the (T)itle, then the (C)ontent of the element. 
       - NT-C:  puts on the same line the  (N)um and the (T)itle, and on a separate line the (C)ontent of the element
       - NC:    puts on the same line the  (N)um and the (C)ontent of the element. Shows no (T)itle. 
       - T-C:   puts on separate lines the  (T)itle and the (C)ontent of the element. Shows no (N)um. 
       In all cases, the full list of an:-prefixed elements must be given, separated by "|" and ended with "dummy" -->
  
  <!--  DO NOT MODIFY THE FOLLOWING ENTITIES UNLESS YOU KNOW WHAT YOU ARE DOING!!!  -->
  <!ENTITY docs              "an:act | an:bill | an:doc | an:report | an:minutes" >
  <!ENTITY hierElements      "an:hcontainer | an:section     | an:part    | an:paragraph   | an:chapter  | 
                              an:article    | an:clause      |  an:partie | an:paragraphe  | an:chapitre |  
                              an:artigo     | an:subdivision | an:item">
  <!ENTITY EndOfHierarchy    "*[local-name()!='num' and local-name()!='title'and local-name()!='subtitle']" >
  
  <!ENTITY containerElements "an:*">
  <!ENTITY blockElements     "an:block      | an:toc      | an:speech | an:question | an:answer | an:comment | an:item">
  <!ENTITY inlineElements    "an:inline     | an:ref      | an:def       ">
  <!ENTITY antitleInline     "an:ActType    | an:ActTitle | an:ActNumber | 
                              an:ActProponent | an:ActDate | an:ActPurpose ">
  <!ENTITY markerElements    "an:marker     | an:recordedTime">
  <!ENTITY htmlElements      "an:p          | an:ul       | an:ol        | an:li      | an:table   | 
                              an:tr         | an:td       | an:th        | an:span    | an:b       | 
                              an:i          | an:a        | an:img">

  
  <!ENTITY hierarchyTOC      "an:preamble   | an:section  | an:part      | 
                              an:paragraph  | an:chapter  |  an:article  | an:artigo  | 
                              an:subdivision | an:item[an:title] | dummy">
  
  <!-- The following entities allow the programmer to show debug messages when needed. 
       Because of a bug in Internet Explorer, they CAN NEVER be empty. 
       A stupid comment has been inserted instead. -->
 <!-- <!ENTITY debug  '<xsl:comment xmlns:xsl="http://www.w3.org/1999/XSL/Transform">debug message</xsl:comment>'>
 	<!ENTITY debug  '<xsl:comment xmlns:xsl="http://www.w3.org/1999/XSL/Transform">special debug message</xsl:comment>'> -->
 	
 	<!ENTITY debug  '<xsl:comment xmlns:xsl="http://www.w3.org/1999/XSL/Transform">special debug message</xsl:comment>'>
 		<!ENTITY debug  '<xsl:comment xmlns:xsl="http://www.w3.org/1999/XSL/Transform">special debug message</xsl:comment>'> 
 		
  ]>
<xsl:stylesheet version="1.0" xmlns:an="http://www.akomantoso.org/1.0"
	xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="UTF-8" indent="yes" />
	<!-- ======================================================== -->
	<!--                                                          -->
	<!--  Main Template                                           -->
	<!--                                                          -->
	<!-- ======================================================== -->
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="an:akomantoso">
		<xsl:variable name="prefix">
			<xsl:choose>
				<xsl:when test="an:act | an:bill">../../../../../..</xsl:when>
				<xsl:otherwise>../../../../..</xsl:otherwise>
			</xsl:choose>			
		</xsl:variable>
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<xsl:call-template name="title-&title;" />
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
				<link href="{$prefix}/styles/style.css" rel="stylesheet" />
			</head>
			<body>
				<xsl:apply-templates />
			</body>
		</html>
	</xsl:template>
	<xsl:template match="@*">
		<xsl:copy-of select="." />
	</xsl:template>
	<!-- ======================================================== -->
	<!--                                                          -->
	<!--  Title Templates                                         -->
	<!--                                                          -->
	<!-- ======================================================== -->
	<xsl:template name="title-t">
		<title>
			<xsl:value-of select="//an:ActTitle" />
		</title>
	</xsl:template>
	<xsl:template name="title-tn">
		<title>
			<xsl:value-of select="//an:ActTitle" />
			<xsl:if test="//an:ActNumber">
				<xsl:text> - </xsl:text>
				<xsl:value-of select="//an:ActNumber" />
			</xsl:if>
		</title>
	</xsl:template>
	<xsl:template name="title-nt">
		<title>
			<xsl:value-of select="//an:ActNumber" />
			<xsl:if test="//an:ActTitle">
				<xsl:text> - </xsl:text>
				<xsl:value-of select="//an:ActTitle" />
			</xsl:if>
		</title>
	</xsl:template>
	<!-- ======================================================== -->
	<!--                                                          -->
	<!--  Layout Templates                                        -->
	<!--                                                          -->
	<!-- ======================================================== -->
	<xsl:template match="&OneCol;"> 
		&debug; 
		<xsl:apply-templates select="an:preface" />
		<xsl:apply-templates select="an:preamble" />
		<xsl:apply-templates select="an:clauses | an:maincontent | an:debate" />
		<xsl:apply-templates select="an:conclusions" />
		<xsl:apply-templates select="an:attachments" />
		<xsl:apply-templates select="an:meta" />
	</xsl:template>
	<xsl:template match="&LeftPane;"> 
		&debug; 
		<table cellpadding="0" cellspacing="5" border="0" width="100%">
			<tr style="margin:top:30px; margin-bottom:30px;">
				<td colspan="2">
					<xsl:apply-templates select="an:preface" />
				</td>
			</tr>
			<tr valign="top">
				<xsl:if test="an:clauses | an:maincontent | an:debate | an:attachments">
					<td width="20%" style="border: thin solid #bbbbbb; background-color: #ffffcc;">
						<div class="toc-head">Table of Content</div>
						<xsl:apply-templates
							select="an:preface | an:preamble | an:clauses | an:maincontent | an:debate | an:attachments"
							mode="Link" />
						<xsl:apply-templates select="an:meta" mode="Link" />
					</td>
				</xsl:if>
				<td width="80%" style="padding-top:15px;">
					<xsl:apply-templates select="an:preamble" />
					<xsl:apply-templates select="an:clauses | an:maincontent | an:debate" />
					<xsl:apply-templates select="an:conclusions" />
					<xsl:apply-templates select="an:attachments" />
					<xsl:apply-templates select="an:meta" />
				</td>
			</tr>
		</table>
	</xsl:template>
	<!-- ======================================================== -->
	<!--                                                          -->
	<!--  individual templates                                    -->
	<!--                                                          -->
	<!-- ======================================================== -->

	<xsl:template match="an:tocitem">
		<div class="tocitem-{@level}">
			<a href="#{@idref}">
				<xsl:apply-templates />
			</a>
		</div>
	</xsl:template>
	<xsl:template match="an:noteref">
			<a class="noteref" href="#{@idref}" name="ref-{@num}" title="{//an:note[@id=current()/@idref]//*/text()}">
				<xsl:text> [</xsl:text>
				<xsl:value-of select="@num" />
				<xsl:text>]</xsl:text>
			</a>
	</xsl:template>
	<xsl:template match="an:p" priority="0.3">
		<xsl:element name="div">
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	<xsl:template match="an:ref" priority="0.3">
		<a>
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates />
		</a>
	</xsl:template>
	<xsl:template match="an:recordedTime" priority="0.3">
		<span class="time"> [<xsl:value-of select="substring(@time, 1, 5)" />] </span>
	</xsl:template>
	<xsl:template match="@href">
		<xsl:attribute name="href">
			<xsl:if test="starts-with(.,'urn:an:')">
				<xsl:text>&resolver;</xsl:text>
			</xsl:if>
			<xsl:value-of select="." />
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="an:comment" priority="0.3">
		<div class="{name()}">
			<xsl:apply-templates select="@*" /> 
			(<xsl:apply-templates />) 
		</div>
	</xsl:template>
	<xsl:template match="an:speech | an:question | an:answer" priority="0.3">
		<xsl:variable name="person" select="//an:Person[@id=current()/@by]/@showAs" />
		<xsl:variable name="role" select="//an:Role[@id=current()/@as]/@showAs" />
		<div class="{name()}">
			<xsl:apply-templates select="@*" />
			<div class="first-para">
				<span class="speech-by">
					<xsl:choose>
						<xsl:when test="$person and $role">
							<xsl:value-of select="$role" /> (<xsl:value-of select="$person" />) </xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$role" />
							<xsl:value-of select="$person" />
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>: </xsl:text>
				</span>
				<xsl:apply-templates select="*[1]" mode="first" />
			</div>
			<xsl:apply-templates select="*[position() > 1]" />
		</div>
	</xsl:template>
	<xsl:template match="@by" />
	<xsl:template match="an:span" priority="1">
		&debug;
		<!--br/--><span class="unknown">[<xsl:apply-templates/>]</span>
	</xsl:template>

	<!-- ======================================================== -->
	<!--                                                          -->
	<!--  Template for main content type patterns of an         -->
	<!--                                                          -->
	<!-- ======================================================== -->
	<xsl:template match="&containerElements;"> &debug; <div class="{name()}">
			<a name="{name()}-{count(preceding::*[name()=name(current())])+1}">
				<xsl:apply-templates />
			</a>
		</div>
	</xsl:template>
	<xsl:template match="&blockElements;" priority="0.25"> 
		&debug; 
		<div class="{name()}">
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates />
		</div>
	</xsl:template>
	<xsl:template match="*" priority="0.25" mode="first"> 
		&debug;
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="&inlineElements;" priority="0.25"> &debug; <span class="{name()}">
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates />
		</span>
	</xsl:template>
	<xsl:template match="&antitleInline;" priority="0.25"> &debug; <span class="{name()}"
			title="{name()}">
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates />
		</span>
	</xsl:template>
	<xsl:template match="&markerElements;" priority="0.25"> &debug; <span class="{name()}"
				><xsl:apply-templates select="@*" />[]</span>
	</xsl:template>
	<xsl:template match="&htmlElements;" priority="0.25">
		&debug;
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	<!-- ======================================================== -->
	<!--                                                          -->
	<!--  Template for hierarchical elements                      -->
	<!--                                                          -->
	<!-- ======================================================== -->

	<xsl:template match="&hierarchyN-T-C;" priority="0.30"> &debug; <div
			class="cont-{name()}">
			<div class="num-{name()}">
				<a name="{@id}">
					<xsl:call-template name="num" />
				</a>
			</div>
			<div class="title-{name()}">
				<xsl:apply-templates select="an:title" />
			</div>
			<xsl:apply-templates select="&hierElements; | &EndOfHierarchy;" />
		</div>
	</xsl:template>
	<xsl:template match="&hierarchyNT-C;" priority="0.30"> &debug; <xsl:variable name="num">
			<xsl:call-template name="num" />
		</xsl:variable>
		<div class="cont-{name()}">
			<div class="head-{name()}">
				<a name="{@id}">
					<xsl:value-of select="$num" />
					<xsl:if test="$num!=''">
						<xsl:text> - </xsl:text>
					</xsl:if>
					<xsl:apply-templates select="an:title" />
				</a>
			</div>
			<xsl:apply-templates select="an:subtitle" />
			<xsl:apply-templates select="&hierElements; | &EndOfHierarchy;" />
		</div>
	</xsl:template>
	<xsl:template match="&hierarchyNC;" priority="0.30"> &debug; <xsl:variable name="num">
			<xsl:call-template name="num" />
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$num!=''">
				<table class="cont-{name()}">
					<tr>
						<td class="num-{name()}">
							<div>
								<xsl:value-of select="$num" />
							</div>
						</td>
						<td>
							<xsl:apply-templates select="&hierElements; | &EndOfHierarchy;"
							 />
						</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<div class="cont-{name()}">
					<xsl:apply-templates select="&hierElements; | &EndOfHierarchy;" />
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="&hierarchyT-C;" priority="0.30"> &debug; <div class="cont-{name()}">
			<div class="title-{name()}">
				<a name="{@id}">
					<xsl:apply-templates select="an:title" />
				</a>
			</div>
			<xsl:apply-templates select="&hierElements; | &EndOfHierarchy;" />
		</div>
	</xsl:template>
	<xsl:template match="&hierElements;" priority="0.25"> &debug; <div class="cont-{name()}">
			<xsl:call-template name="num" />
			<xsl:apply-templates select="an:title" />
			<xsl:apply-templates select="&hierElements; | &EndOfHierarchy;" />
		</div>
	</xsl:template>
	<xsl:template match="an:title">
		<span class="{local-name()}">
			<xsl:apply-templates />
		</span>
	</xsl:template>
	<xsl:template name="num">
		<xsl:choose>
			<xsl:when test="an:num">
				<span class="num">
					<xsl:value-of select="an:num" />
				</span>
			</xsl:when>
			<xsl:when test="ancestor-or-self::*[@numbering='on']">
				<span class="num">
					<xsl:number />
				</span>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- ======================================================== -->
	<!--                                                          -->
	<!--  Modo Link (left pane)                                   -->
	<!--                                                          -->
	<!-- ======================================================== -->
	<xsl:template match="an:clauses | an:maincontent | an:debate" mode="Link"> &debug;
			<xsl:apply-templates mode="Link" />
	</xsl:template>
	<xsl:template match="&hierarchyTOC;" mode="Link" priority="0.25"> &debug; <div>
			<xsl:attribute name="class">
				<xsl:text>toc-</xsl:text>
				<xsl:value-of select="name()" />
				<xsl:if test="count(ancestor::*[name()=name(current())])">
					<xsl:text>-</xsl:text>
					<xsl:value-of select="count(ancestor::*[name()=name(current())])" />
				</xsl:if>
			</xsl:attribute>
			<a href="#{@id}">
				<xsl:apply-templates select="an:num | an:title" mode="Link" />
			</a>
		</div>
		<xsl:apply-templates select="&hierarchyTOC;" mode="Link" />
	</xsl:template>
	<xsl:template match="an:num" mode="Link"> &debug; <xsl:value-of select="." />
		<xsl:if test="following-sibling::an:title">
			<xsl:text> - </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="an:title" mode="Link"> &debug; <xsl:apply-templates />
	</xsl:template>
	<xsl:template match="an:preamble" mode="Link" priority="0.3">
		<div class="toc-{name()}">
			<a href="#preamble">Preamble</a>
		</div>
	</xsl:template>
	<xsl:template match="an:attachments" mode="Link"> 
		&debug; 
		<div class="toc-attachments">
			<a href="#{attachment[1]/@id}">Attachments</a>
		</div>
	</xsl:template>
	<xsl:template match="an:meta" mode="Link"> 
		&debug; 
		<hr style="margin-top:15pt;" />
		<xsl:apply-templates select="an:descriptor" mode="Link"/>
		<xsl:apply-templates select="an:notes" mode="Link"/>
	</xsl:template>
	<xsl:template match="an:descriptor" mode="Link"> 
		<div class="toc-meta">
			<a href="#meta">Information about this document</a>
		</div>
	</xsl:template>
	<xsl:template match="an:notes" mode="Link"> 
		<div class="toc-notes">
			<a href="#notes">Notes</a>
		</div>
	</xsl:template>
	<xsl:template match="*" mode="Link" />


	<!-- ======================================================== -->
	<!--                                                          -->
	<!--  metadata templates                                      -->
	<!--                                                          -->
	<!-- ======================================================== -->
	<xsl:template match="an:meta"> 
		&debug; 
		<xsl:apply-templates select="an:descriptor"/>
		<xsl:apply-templates select="an:notes"/>
	</xsl:template>
	<xsl:template match="an:notes">
		<hr style="margin-top:45pt;" />
		
		<div class="Notes">
			<table border="0" cellpadding="2" cellspacing="0" width="75%" align="center"
				style="margin-left: 15px;">
				<tr>
					<td colspan="2" class="important" style="text-align:left">
						<a name="notes">Notes</a>
					</td>
				</tr>
				<xsl:apply-templates/>
			</table>
		</div>
	</xsl:template>
	<xsl:template match="an:note">
		<xsl:variable name="refs">
		</xsl:variable>
		<tr>
			<td>
				<xsl:for-each select="//an:noteref[@idref=current()/@id]">
					<a class="noteref" name="{@idref}" href="#ref-{@num}">
						<xsl:text> [</xsl:text>
						<xsl:value-of select="@num"/>
						<xsl:text>]</xsl:text>
					</a>
					<xsl:if test="position()!=last()">, </xsl:if>
				</xsl:for-each>
			</td>
			<td><xsl:apply-templates/></td>
		</tr>
	</xsl:template>
	<xsl:template match="an:descriptor">
		<hr style="margin-top:45pt;" />
		<div class="meta">
			<table border="0" cellpadding="2" cellspacing="0" width="75%" align="center"
				style="margin-left: 15px;">
				<tr>
					<td colspan="2" class="important" style="text-align:left">
						<a name="meta">Information about this document</a>
					</td>
				</tr>
				<xsl:apply-templates/>
			</table>
		</div>
	</xsl:template>
	<xsl:template match="an:publication">
		<tr>
			<th>Publication</th>
			<td>Published on <xsl:value-of select="@date" /> as <xsl:value-of select="@showAs" /></td>
		</tr>
	</xsl:template>
	<xsl:template match="an:enactmentDate">
		<tr>
			<th>Enactment</th>
			<td>
				<xsl:value-of select="@date" />
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="an:uri">
		<tr>
			<th>URI</th>
			<td>
				<a>
					<xsl:apply-templates select="@href" />
					<xsl:value-of select="@href" />
				</a>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="an:editors">
		<tr>
			<th>Editor<xsl:if test="count(*)>1">s</xsl:if></th>
			<td>
				<xsl:apply-templates />
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="an:editor">
		<xsl:if test="position()>2">, </xsl:if>
		<xsl:value-of select="@name" />
		<xsl:text> (doing </xsl:text>
		<xsl:value-of select="@contribution" />
		<xsl:text> on </xsl:text>
		<xsl:value-of select="@date" />
		<xsl:text>)</xsl:text>
	</xsl:template>
</xsl:stylesheet>
