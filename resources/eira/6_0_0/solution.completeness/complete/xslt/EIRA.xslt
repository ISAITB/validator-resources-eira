<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:a="http://www.opengroup.org/xsd/archimate/3.0/" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->

<xsl:param name="archiveDirParameter" />
  <xsl:param name="archiveNameParameter" />
  <xsl:param name="fileNameParameter" />
  <xsl:param name="fileDirParameter" />
  <xsl:variable name="document-uri">
    <xsl:value-of select="document-uri(/)" />
  </xsl:variable>

<!--PHASES-->


<!--PROLOG-->
<xsl:output indent="yes" method="xml" omit-xml-declaration="no" standalone="yes" />

<!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="." />
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="parent::*" />
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">
        <xsl:value-of select="name()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*:</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>[namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()" />
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])" />
    <xsl:text>[</xsl:text>
    <xsl:value-of select="1+ $preceding" />
    <xsl:text>]</xsl:text>
  </xsl:template>
  <xsl:template match="@*" mode="schematron-get-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="parent::*" />
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()" />
</xsl:when>
      <xsl:otherwise>
        <xsl:text>@*[local-name()='</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>' and namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()" />
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>
<!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->

<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="parent::*">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>

<!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path" />
  <xsl:template match="text()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')" />
  </xsl:template>
  <xsl:template match="comment()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')" />
  </xsl:template>
  <xsl:template match="processing-instruction()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.@', name())" />
  </xsl:template>
  <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:text>.</xsl:text>
    <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')" />
  </xsl:template>

<!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
  <xsl:template match="*" mode="generate-id-2" priority="2">
    <xsl:text>U</xsl:text>
    <xsl:number count="*" level="multiple" />
  </xsl:template>
  <xsl:template match="node()" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>n</xsl:text>
    <xsl:number count="node()" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="string-length(local-name(.))" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="translate(name(),':','.')" />
  </xsl:template>
<!--Strip characters-->  <xsl:template match="text()" priority="-1" />

<!--SCHEMA SETUP-->
<xsl:template match="/">
    <svrl:schematron-output schemaVersion="" title="EIRA v6.0.0 - Solution Completeness Profile - Complete level">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="a" uri="http://www.opengroup.org/xsd/archimate/3.0/" />
      <svrl:ns-prefix-in-attribute-values prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">MEF-Step.01</xsl:attribute>
        <xsl:attribute name="name">MEF-Step.01</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M6" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">MEF-Step.02</xsl:attribute>
        <xsl:attribute name="name">MEF-Step.02</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M7" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">MEF-Step.03</xsl:attribute>
        <xsl:attribute name="name">MEF-Step.03</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M8" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>EIRA v6.0.0 - Solution Completeness Profile - Complete level</svrl:text>

<!--PATTERN MEF-Step.01-->


	<!--RULE -->
<xsl:template match="/a:model" mode="M6" priority="1003">
    <svrl:fired-rule context="/a:model" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(a:views/a:diagrams/a:view[./a:name = 'Legal view'])/count(.) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="(a:views/a:diagrams/a:view[./a:name = 'Legal view'])/count(.) = 1">
          <xsl:attribute name="id">EIRA-001-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-001] The model must define a view named 'Legal view'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(a:views/a:diagrams/a:view[./a:name = 'Organisational view'])/count(.) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="(a:views/a:diagrams/a:view[./a:name = 'Organisational view'])/count(.) = 1">
          <xsl:attribute name="id">EIRA-001-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-001] The model must define a view named 'Organisational view'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(a:views/a:diagrams/a:view[./a:name = 'Semantic view'])/count(.) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="(a:views/a:diagrams/a:view[./a:name = 'Semantic view'])/count(.) = 1">
          <xsl:attribute name="id">EIRA-001-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-001] The model must define a view named 'Semantic view'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(a:views/a:diagrams/a:view[./a:name = 'Technical view - application'])/count(.) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="(a:views/a:diagrams/a:view[./a:name = 'Technical view - application'])/count(.) = 1">
          <xsl:attribute name="id">EIRA-001-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-001] The model must define a view named 'Technical view - application'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(a:views/a:diagrams/a:view[./a:name = 'Technical view - infrastructure'])/count(.) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="(a:views/a:diagrams/a:view[./a:name = 'Technical view - infrastructure'])/count(.) = 1">
          <xsl:attribute name="id">EIRA-001-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-001] The model must define a view named 'Technical view - infrastructure'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(a:views/a:diagrams/a:view[./a:name = 'Highlevel viewpoint'])/count(.) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="(a:views/a:diagrams/a:view[./a:name = 'Highlevel viewpoint'])/count(.) = 1">
          <xsl:attribute name="id">EIRA-001-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-001] The model must define a view named 'Highlevel viewpoint'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $modelAttributes := (a:properties) return (every $eiraModelAttributeName in document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[(let $propId := string(@identifier) return exists(document('eira/EIRA.xml')/a:model/a:properties/a:property[string(@propertyDefinitionRef) = $propId]))]/a:name/string(.) satisfies (($eiraModelAttributeName = 'ID' or $eiraModelAttributeName = 'dct:description' or $eiraModelAttributeName = 'iop_score_governance' or $eiraModelAttributeName = 'eira:iop_score_h2m' or $eiraModelAttributeName = 'eira:iop_score_m2m' or $eiraModelAttributeName = 'eira:iop_score_overall' or $eiraModelAttributeName = 'eira:iop_score_sw_architecture' or $eiraModelAttributeName = 'dcat:landingPage' or $eiraModelAttributeName = 'eira:actual_use' or $eiraModelAttributeName = 'eira:actual_reuse') or exists($modelAttributes/a:property[(let $modelPropId := string(@propertyDefinitionRef) return exists(/a:model/a:propertyDefinitions/a:propertyDefinition[string(@identifier) = $modelPropId and string(a:name) = $eiraModelAttributeName])) and normalize-space(string(./a:value)) != ''])))" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $modelAttributes := (a:properties) return (every $eiraModelAttributeName in document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[(let $propId := string(@identifier) return exists(document('eira/EIRA.xml')/a:model/a:properties/a:property[string(@propertyDefinitionRef) = $propId]))]/a:name/string(.) satisfies (($eiraModelAttributeName = 'ID' or $eiraModelAttributeName = 'dct:description' or $eiraModelAttributeName = 'iop_score_governance' or $eiraModelAttributeName = 'eira:iop_score_h2m' or $eiraModelAttributeName = 'eira:iop_score_m2m' or $eiraModelAttributeName = 'eira:iop_score_overall' or $eiraModelAttributeName = 'eira:iop_score_sw_architecture' or $eiraModelAttributeName = 'dcat:landingPage' or $eiraModelAttributeName = 'eira:actual_use' or $eiraModelAttributeName = 'eira:actual_reuse') or exists($modelAttributes/a:property[(let $modelPropId := string(@propertyDefinitionRef) return exists(/a:model/a:propertyDefinitions/a:propertyDefinition[string(@identifier) = $modelPropId and string(a:name) = $eiraModelAttributeName])) and normalize-space(string(./a:value)) != ''])))">
          <xsl:attribute name="id">EIRA-002</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-002] The model is missing required attribute(s) [<xsl:text />
            <xsl:value-of select="let $modelProperties := a:properties return (let $modelPropertyDefinitions := /a:model/a:propertyDefinitions return (document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[not(string(./a:name) = 'ID' or string(./a:name) = 'dct:description' or string(./a:name) = 'iop_score_governance' or string(./a:name) = 'eira:iop_score_h2m' or string(./a:name) = 'eira:iop_score_m2m' or string(./a:name) = 'eira:iop_score_overall' or string(./a:name) = 'eira:iop_score_sw_architecture' or string(./a:name) = 'dcat:landingPage' or string(./a:name) = 'eira:actual_use' or string(./a:name) = 'eira:actual_reuse') and (let $propId := string(./@identifier) return (let $propName := string(./a:name) return (exists(document('eira/EIRA.xml')/a:model/a:properties/a:property[string(./@propertyDefinitionRef) = $propId and not(exists($modelPropertyDefinitions/a:propertyDefinition[(let $modelPropId := string(./@identifier) return exists($modelProperties/a:property[string(./@propertyDefinitionRef) = $modelPropId and normalize-space(string(./a:value)) != ''])) and string(./a:name) = $propName]))]))))]))/a:name/string(.)" />
            <xsl:text />].</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock']]" mode="M6" priority="1002">
    <svrl:fired-rule context="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock']]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $sbbPuri in a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier]/a:value satisfies (let $elementType := @xsi:type return(let $sbb := document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier]/a:value = $sbbPuri] return ($sbb/@xsi:type = $elementType or not(exists($sbb)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $sbbPuri in a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier]/a:value satisfies (let $elementType := @xsi:type return(let $sbb := document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier]/a:value = $sbbPuri] return ($sbb/@xsi:type = $elementType or not(exists($sbb)))))">
          <xsl:attribute name="id">EIRA-003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-003] SBB '<xsl:text />
            <xsl:value-of select="a:name" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="let $sbbDeclaredAbb := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier)]/a:value return(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier)]/a:value = $sbbDeclaredAbb]/a:name)" />
            <xsl:text />) has an invalid element type '<xsl:text />
            <xsl:value-of select="@xsi:type" />
            <xsl:text />'. Expected element type '<xsl:text />
            <xsl:value-of select="let $sbbPuri := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value return(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier]/a:value = $sbbPuri]/@xsi:type)" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $sbbDeclaredAbbValue := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier)]/a:value return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier)]/a:value = $sbbDeclaredAbbValue])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $sbbDeclaredAbbValue := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier)]/a:value return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier)]/a:value = $sbbDeclaredAbbValue])">
          <xsl:attribute name="id">EIRA-004</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-004] SBB '<xsl:text />
            <xsl:value-of select="a:name" />
            <xsl:text />' references an invalid ABB. No ABB is defined for name '<xsl:text />
            <xsl:value-of select="a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier)]/a:value" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier)])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier)])">
          <xsl:attribute name="id">EIRA-005</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-005] SBB '<xsl:text />
            <xsl:value-of select="a:name" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="let $sbbDeclaredAbb := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier)]/a:value return(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier)]/a:value = $sbbDeclaredAbb]/a:name)" />
            <xsl:text />) is missing required attribute(s) [<xsl:text />
            <xsl:value-of select="let $sbbProperties := a:properties return (let $sbbPropertyDefinitions := /a:model/a:propertyDefinitions return (let $abbName := string(./a:name) return (document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[not(string(./a:name) = 'ID' or string(./a:name) = 'eira:ABB_Status' or string(./a:name) = 'eira:synonym' or string(./a:name) = 'eira:unit_in_DG' or string(./a:name) = 'dct:references' or string(./a:name) = 'eira:reuse_status' or string(./a:name) = 'eira:specific_policy_issue' or string(./a:name) = 'eira:operational_date' or string(./a:name) = 'dct:description' or string(./a:name) = 'eira:policy_area' or string(./a:name) = 'eira:owner' or string(./a:name) = 'eira:description' or string(./a:name) = 'eira:reusability_score' or string(./a:name) = 'eira:data_quality_level' or string(./a:name) = 'eira:data_quality_score' or string(./a:name) = 'eira:iop_level' or string(./a:name) = 'eira:iop_score' or string(./a:name) = 'eira:GovIS_ID' or string(./a:name) = 'eira:IES_category' or string(./a:name) = 'eira:importance_for_the_functioning_of_the_EU' or string(./a:name) = 'eira:actual_use' or string(./a:name) = 'eira:actual_reuse' or string(./a:name) = 'eira:view') and (let $propId := string(./@identifier) return (let $propName := string(./a:name) return (exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[string(./a:name) = $abbName]/a:properties/a:property[string(./@propertyDefinitionRef) = $propId and not(exists($sbbPropertyDefinitions/a:propertyDefinition[(let $modelPropId := string(./@identifier) return exists($sbbProperties/a:property[string(./@propertyDefinitionRef) = $modelPropId and normalize-space(string(./a:value)) != ''])) and string(./a:name) = $propName]))]))))])))/a:name/string(.)" />
            <xsl:text />].</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $sbbName := string(a:name) return (let $abb := document('eira/EIRA.xml')/a:model/a:elements/a:element[string(a:name) = $sbbName] return (not(exists($abb)) or not(exists($abb/a:properties/a:property[string(./a:value) = 'Obsolete' and string(./@propertyDefinitionRef) = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./a:name) = 'eira:ABB_Status']/@identifier)]))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $sbbName := string(a:name) return (let $abb := document('eira/EIRA.xml')/a:model/a:elements/a:element[string(a:name) = $sbbName] return (not(exists($abb)) or not(exists($abb/a:properties/a:property[string(./a:value) = 'Obsolete' and string(./@propertyDefinitionRef) = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./a:name) = 'eira:ABB_Status']/@identifier)]))))">
          <xsl:attribute name="id">EIRA-006</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-006] SBB '<xsl:text />
            <xsl:value-of select="a:name" />
            <xsl:text />' refers to obsolete ABB '<xsl:text />
            <xsl:value-of select="let $sbbDeclaredAbb := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier)]/a:value return(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier)]/a:value = $sbbDeclaredAbb]/a:name)" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock']]" mode="M6" priority="1001">
    <svrl:fired-rule context="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock']]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EIRA-007</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-007] An ABB ('<xsl:text />
            <xsl:value-of select="a:name" />
            <xsl:text />') must not be defined in a solution.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $abbPuri in a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value satisfies (let $elementType := @xsi:type return(let $abb := document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value = $abbPuri] return ($abb/@xsi:type = $elementType or not(exists($abb)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $abbPuri in a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value satisfies (let $elementType := @xsi:type return(let $abb := document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value = $abbPuri] return ($abb/@xsi:type = $elementType or not(exists($abb)))))">
          <xsl:attribute name="id">EIRA-008</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-008] ABB '<xsl:text />
            <xsl:value-of select="a:name" />
            <xsl:text />' defined with element type '<xsl:text />
            <xsl:value-of select="@xsi:type" />
            <xsl:text />' that does not match the EIRA. Expected element type '<xsl:text />
            <xsl:value-of select="let $abbPuri := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value return (document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:Puri']/@identifier)]/a:value = $abbPuri]/@xsi:type)" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element/a:properties/a:property[(let $propId := string(./@propertyDefinitionRef) return (let $propertyName := string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $propId]/a:name) return (let $abbName := string(./../../a:name) return (exists(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./a:name) = $propertyName and (let $abbPropId := string(./@identifier) return (exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[string(./a:name) = $abbName]/a:properties/a:property[string(./@propertyDefinitionRef) = $abbPropId])))])))))]" mode="M6" priority="1000">
    <svrl:fired-rule context="/a:model/a:elements/a:element/a:properties/a:property[(let $propId := string(./@propertyDefinitionRef) return (let $propertyName := string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $propId]/a:name) return (let $abbName := string(./../../a:name) return (exists(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./a:name) = $propertyName and (let $abbPropId := string(./@identifier) return (exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[string(./a:name) = $abbName]/a:properties/a:property[string(./@propertyDefinitionRef) = $abbPropId])))])))))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $propertyValue := a:value return exists($propertyValue = 'eira:ArchitectureBuildingBlock' or $propertyValue = 'eira:SolutionBuildingBlock')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $propertyValue := a:value return exists($propertyValue = 'eira:ArchitectureBuildingBlock' or $propertyValue = 'eira:SolutionBuildingBlock')">
          <xsl:attribute name="id">EIRA-009</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-009] SBB '<xsl:text />
            <xsl:value-of select="string(./../../a:name)" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="string(./../../a:name)" />
            <xsl:text />) defines invalid value '<xsl:text />
            <xsl:value-of select="string(a:value)" />
            <xsl:text />' for attribute '<xsl:text />
            <xsl:value-of select="let $propId := string(./@propertyDefinitionRef) return (string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $propId]/a:name))" />
            <xsl:text />'. Expected '<xsl:text />
            <xsl:value-of select="let $pIdentifier := string(./@propertyDefinitionRef) return (let $propertyName := string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $pIdentifier]/a:name) return (let $abbName := string(./../../a:name) return (string((document('eira/EIRA.xml')/a:model/a:elements/a:element[string(./a:name) = $abbName]/a:properties/a:property[(let $abbPropId := string(./@propertyDefinitionRef) return (exists(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $abbPropId and string(./a:name) = $propertyName])))]/a:value)[1]))))" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $pElement := (./../..) return (let $pIdentifier := string(@propertyDefinitionRef) return (let $propertyName := string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $pIdentifier]/a:name) return (let $abbName := string(../../a:name) return (let $abbPropDefinition := (replace(string((document('eira/EIRA.xml')/a:model/a:elements/a:element[string(./a:name) = $abbName]/a:properties/a:property[(let $abbPropId := string(./@propertyDefinitionRef) return (exists(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $abbPropId and string(./a:name) = $propertyName])))]/a:value)[1]), '\-', '~')) return (if (matches($abbPropDefinition, '\[(([\w\d\s\|]+)|([\w\d\s]+))\]\*')) then true() else count($pElement/a:properties/a:property[string(./@propertyDefinitionRef) = $pIdentifier]) = 1)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $pElement := (./../..) return (let $pIdentifier := string(@propertyDefinitionRef) return (let $propertyName := string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $pIdentifier]/a:name) return (let $abbName := string(../../a:name) return (let $abbPropDefinition := (replace(string((document('eira/EIRA.xml')/a:model/a:elements/a:element[string(./a:name) = $abbName]/a:properties/a:property[(let $abbPropId := string(./@propertyDefinitionRef) return (exists(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $abbPropId and string(./a:name) = $propertyName])))]/a:value)[1]), '\-', '~')) return (if (matches($abbPropDefinition, '\[(([\w\d\s\|]+)|([\w\d\s]+))\]\*')) then true() else count($pElement/a:properties/a:property[string(./@propertyDefinitionRef) = $pIdentifier]) = 1)))))">
          <xsl:attribute name="id">EIRA-010</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-010] SBB '<xsl:text />
            <xsl:value-of select="string(./../../a:name)" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="string(./../../a:name)" />
            <xsl:text />) must not define multiple values for attribute '<xsl:text />
            <xsl:value-of select="let $propId := string(./@propertyDefinitionRef) return (string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $propId]/a:name))" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M6" priority="-1" />
  <xsl:template match="@*|node()" mode="M6" priority="-2">
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>

<!--PATTERN MEF-Step.02-->


	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Legal view'))]))]" mode="M7" priority="1005">
    <svrl:fired-rule context="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Legal view'))]))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Legal view')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Legal view')">
          <xsl:attribute name="id">EIRA-011</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-011] SBB '<xsl:text />
            <xsl:value-of select="string(a:name)" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="string(a:name)" />
            <xsl:text />) is not present in the model's Legal view.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Organisational view'))]))]" mode="M7" priority="1004">
    <svrl:fired-rule context="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Organisational view'))]))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Organisational view')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Organisational view')">
          <xsl:attribute name="id">EIRA-012</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-012] SBB '<xsl:text />
            <xsl:value-of select="string(a:name)" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="string(a:name)" />
            <xsl:text />) is not present in the model's Organisational view.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Semantic view'))]))]" mode="M7" priority="1003">
    <svrl:fired-rule context="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Semantic view'))]))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Semantic view')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Semantic view')">
          <xsl:attribute name="id">EIRA-013</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-013] SBB '<xsl:text />
            <xsl:value-of select="string(a:name)" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="string(a:name)" />
            <xsl:text />) is not present in the model's Semantic view.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - application'))]))]" mode="M7" priority="1002">
    <svrl:fired-rule context="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - application'))]))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - application')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - application')">
          <xsl:attribute name="id">EIRA-014</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-014] SBB '<xsl:text />
            <xsl:value-of select="string(a:name)" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="string(a:name)" />
            <xsl:text />) is not present in the model's Technical view - application.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - infrastructure'))]))]" mode="M7" priority="1001">
    <svrl:fired-rule context="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - infrastructure'))]))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - infrastructure')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - infrastructure')">
          <xsl:attribute name="id">EIRA-015</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-015] SBB '<xsl:text />
            <xsl:value-of select="string(a:name)" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="string(a:name)" />
            <xsl:text />) is not present in the model's Technical view - infrastructure.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - application' or $viewName = 'Technical view - infrastructure'))]))]" mode="M7" priority="1000">
    <svrl:fired-rule context="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - application' or $viewName = 'Technical view - infrastructure'))]))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - application' or $viewName = 'Technical view - infrastructure')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - application' or $viewName = 'Technical view - infrastructure')">
          <xsl:attribute name="id">EIRA-017</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-017] SBB '<xsl:text />
            <xsl:value-of select="string(a:name)" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="string(a:name)" />
            <xsl:text />) is not present in one of the model's Technical views.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M7" priority="-1" />
  <xsl:template match="@*|node()" mode="M7" priority="-2">
    <xsl:apply-templates mode="M7" select="@*|*" />
  </xsl:template>

<!--PATTERN MEF-Step.03-->


	<!--RULE -->
<xsl:template match="/a:model" mode="M8" priority="1000">
    <svrl:fired-rule context="/a:model" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(string(a:name), 'Public Policy')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(a:name), 'Public Policy')])">
          <xsl:attribute name="id">EIRA-018-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Public Policy' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(string(a:name), 'Legal Act')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(a:name), 'Legal Act')])">
          <xsl:attribute name="id">EIRA-018-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Legal Act' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(string(a:name), 'Digital Public Service')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(a:name), 'Digital Public Service')])">
          <xsl:attribute name="id">EIRA-018-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Digital Public Service' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(string(a:name), 'Digital Public Service Provider')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(a:name), 'Digital Public Service Provider')])">
          <xsl:attribute name="id">EIRA-018-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Digital Public Service Provider' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(string(a:name), 'Digital Public Service Consumer')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(a:name), 'Digital Public Service Consumer')])">
          <xsl:attribute name="id">EIRA-018-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Digital Public Service Consumer' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(string(a:name), 'Information')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(a:name), 'Information')])">
          <xsl:attribute name="id">EIRA-018-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Information' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(string(a:name), 'Data')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(a:name), 'Data')])">
          <xsl:attribute name="id">EIRA-018-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Data' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(string(a:name), 'Data Representation')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(a:name), 'Data Representation')])">
          <xsl:attribute name="id">EIRA-018-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Data Representation' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(string(a:name), 'Digital Solution')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(a:name), 'Digital Solution')])">
          <xsl:attribute name="id">EIRA-018-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Digital Solution' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(string(a:name), 'Hosting Facility')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(a:name), 'Hosting Facility')])">
          <xsl:attribute name="id">EIRA-018-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Hosting Facility' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(string(a:name), '(Data Policy|Descriptive Metadata Policy|Master Data Policy|Base Registry Data Policy|Reference Data Policy|Open Data Policy|Data Portability Policy|Security Policy|Privacy Policy)')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(a:name), '(Data Policy|Descriptive Metadata Policy|Master Data Policy|Base Registry Data Policy|Reference Data Policy|Open Data Policy|Data Portability Policy|Security Policy|Privacy Policy)')])">
          <xsl:attribute name="id">EIRA-019-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-019] All ABBs in the high-level overview must be defined. No 'Data Policy' SBB (or a specialisation) is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(string(@xsi:type), 'CommunicationNetwork|TechnologyService|Node') and (let $declaredAbbName := string(a:name) return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and string(a:name) = $declaredAbbName]))])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(@xsi:type), 'CommunicationNetwork|TechnologyService|Node') and (let $declaredAbbName := string(a:name) return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and string(a:name) = $declaredAbbName]))])">
          <xsl:attribute name="id">EIRA-019-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-019] All ABBs in the high-level overview must be defined. No 'Computing Hosting' SBB (or a specialisation) is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(string(@xsi:type), 'ApplicationService') and (let $declaredAbbName := string(a:name) return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and string(a:name) = $declaredAbbName]))])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(@xsi:type), 'ApplicationService') and (let $declaredAbbName := string(a:name) return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and string(a:name) = $declaredAbbName]))])">
          <xsl:attribute name="id">EIRA-019-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-019] All ABBs in the high-level overview must be defined. No 'Digital Solution Service' SBB (or a specialisation) is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(string(@xsi:type), 'ApplicationComponent') and (let $declaredAbbName := string(a:name) return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and string(a:name) = $declaredAbbName]))])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(@xsi:type), 'ApplicationComponent') and (let $declaredAbbName := string(a:name) return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and string(a:name) = $declaredAbbName]))])">
          <xsl:attribute name="id">EIRA-019-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-019] All ABBs in the high-level overview must be defined. No 'Digital Solution Component' SBB (or a specialisation) is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(string(a:name), '(Digital Solution (Service)|Digital Solution (Component))')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(a:name), '(Digital Solution (Service)|Digital Solution (Component))')])">
          <xsl:attribute name="id">EIRA-020-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-020] All ABBs in the high-level overview must be defined. At least one SBB for ABBs ['Digital Solution (Service)', 'Digital Solution (Component)'] must be defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(string(a:name), '(Machine to Machine Interface|Human Interface)')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(a:name), '(Machine to Machine Interface|Human Interface)')])">
          <xsl:attribute name="id">EIRA-020-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-020] All ABBs in the high-level overview must be defined. At least one SBB for ABBs ['Machine to Machine Interface', 'Human Interface'] must be defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M8" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M8" priority="-1" />
  <xsl:template match="@*|node()" mode="M8" priority="-2">
    <xsl:apply-templates mode="M8" select="@*|*" />
  </xsl:template>
</xsl:stylesheet>
