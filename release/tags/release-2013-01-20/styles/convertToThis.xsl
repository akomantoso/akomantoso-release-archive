<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:x="http://www.akomantoso.org/1.0" xmlns="http://www.akomantoso.org/1.0" version="1.0">
    
    <xsl:output method="xml" indent="yes" />
    
    <xsl:template match="x:uri/@href">
        <xsl:attribute name="value">
            <xsl:apply-templates/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="x:Person|x:Organization|x:Role|x:Reference">
        <xsl:element name="TLC{name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="x:Work|x:Expression|x:Manifestation|x:Item">
        <xsl:element name="FRBR{name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="x:Textual|x:Meaning|x:Scope|x:Force|x:Efficacy|x:LegalSystem">
        <xsl:element name="{name()}Mod">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="x:clauses">
        <xsl:element name="body">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="x:title">
        <xsl:element name="heading">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="x:subtitle">
        <xsl:element name="subheading">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="x:clause">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="x:title|x:subtitle|x:num|x:sidenote|x:from"/>
            <xsl:element name="content">
                <xsl:apply-templates select="*[not(contains('title|subtitle|num|sidenote|from', name()))]"/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/|*">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
