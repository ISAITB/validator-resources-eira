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
    <svrl:schematron-output schemaVersion="" title="EIRA v6.0.0 - Solution Completeness Profile - Basic level">
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
<svrl:text>EIRA v6.0.0 - Solution Completeness Profile - Basic level</svrl:text>

<!--PATTERN MEF-Step.01-->


	<!--RULE -->
<xsl:template match="/a:model" mode="M6" priority="1002">
    <svrl:fired-rule context="/a:model" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(a:views/a:diagrams/a:view[a:name = 'Legal view'])/count(.) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="(a:views/a:diagrams/a:view[a:name = 'Legal view'])/count(.) = 1">
          <xsl:attribute name="id">EIRA-001-01</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-001] The model must define a view named 'Legal view'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(a:views/a:diagrams/a:view[a:name = 'Organisational view'])/count(.) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="(a:views/a:diagrams/a:view[a:name = 'Organisational view'])/count(.) = 1">
          <xsl:attribute name="id">EIRA-001-02</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-001] The model must define a view named 'Organisational view'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(a:views/a:diagrams/a:view[a:name = 'Semantic view'])/count(.) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="(a:views/a:diagrams/a:view[a:name = 'Semantic view'])/count(.) = 1">
          <xsl:attribute name="id">EIRA-001-03</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-001] The model must define a view named 'Semantic view'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(a:views/a:diagrams/a:view[a:name = 'Technical view - application'])/count(.) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="(a:views/a:diagrams/a:view[a:name = 'Technical view - application'])/count(.) = 1">
          <xsl:attribute name="id">EIRA-001-04</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-001] The model must define a view named 'Technical view - application'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(a:views/a:diagrams/a:view[a:name = 'Technical view - infrastructure'])/count(.) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="(a:views/a:diagrams/a:view[a:name = 'Technical view - infrastructure'])/count(.) = 1">
          <xsl:attribute name="id">EIRA-001-05</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-001] The model must define a view named 'Technical view - infrastructure'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(a:views/a:diagrams/a:view[a:name = 'Highlevel viewpoint'])/count(.) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="(a:views/a:diagrams/a:view[a:name = 'Highlevel viewpoint'])/count(.) = 1">
          <xsl:attribute name="id">EIRA-001-06</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-001] The model must define a view named 'Highlevel viewpoint'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:SolutionBuildingBlock']]" mode="M6" priority="1001">
    <svrl:fired-rule context="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:SolutionBuildingBlock']]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $relatedABB in a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value, $elementType in @xsi:type satisfies (let $relatedEIRAABB := document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier and a:value = $relatedABB]] return ($relatedEIRAABB/@xsi:type = $elementType or not(exists($relatedEIRAABB))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $relatedABB in a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value, $elementType in @xsi:type satisfies (let $relatedEIRAABB := document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier and a:value = $relatedABB]] return ($relatedEIRAABB/@xsi:type = $elementType or not(exists($relatedEIRAABB))))">
          <xsl:attribute name="id">EIRA-003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-003] SBB '<xsl:text />
            <xsl:value-of select="a:name" />
            <xsl:text />' ('<xsl:text />
            <xsl:value-of select="a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value" />
            <xsl:text />') has an invalid element type '<xsl:text />
            <xsl:value-of select="@xsi:type" />
            <xsl:text />'. Expected element type '<xsl:text />
            <xsl:value-of select="a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:valueElementType" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $relatedABB := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier and a:value = $relatedABB]])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $relatedABB := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier and a:value = $relatedABB]])">
          <xsl:attribute name="id">EIRA-004</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-004] SBB '<xsl:text />
            <xsl:value-of select="a:name" />
            <xsl:text />' references an invalid ABB. No ABB is defined for name '<xsl:text />
            <xsl:value-of select="a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $relatedABB := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value return (let $relatedEIRAABB := document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value = $relatedABB] return not(exists($relatedEIRAABB/a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'adms:status']/@identifier and a:value = 'deprecated'])))" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $relatedABB := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value return (let $relatedEIRAABB := document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value = $relatedABB] return not(exists($relatedEIRAABB/a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'adms:status']/@identifier and a:value = 'deprecated'])))">
          <xsl:attribute name="id">EIRA-006</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-006] SBB '<xsl:text />
            <xsl:value-of select="a:name" />
            <xsl:text />' refers to deprecated ABB '<xsl:text />
            <xsl:value-of select="a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']]" mode="M6" priority="1000">
    <svrl:fired-rule context="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $abbPuri in a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier]/a:value, $elementType in @xsi:type satisfies (document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = $abbPuri]]/@xsi:type = $elementType)" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $abbPuri in a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier]/a:value, $elementType in @xsi:type satisfies (document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = $abbPuri]]/@xsi:type = $elementType)">
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
            <xsl:value-of select="let $abbPuri := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier]/a:value return (document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = $abbPuri]]/@xsi:type)" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M6" priority="-1" />
  <xsl:template match="@*|node()" mode="M6" priority="-2">
    <xsl:apply-templates mode="M6" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN MEF-Step.02-->


	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:SolutionBuildingBlock']]" mode="M7" priority="1000">
    <svrl:fired-rule context="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:SolutionBuildingBlock']]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $viewName := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier]/a:value return ($viewName = 'Legal view')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $viewName := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier]/a:value return ($viewName = 'Legal view')">
          <xsl:attribute name="id">EIRA-011</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-011] SBB '<xsl:text />
            <xsl:value-of select="a:name" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value" />
            <xsl:text />) is not present in the model's Legal view.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $viewName := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier]/a:value return ($viewName = 'Organisational view')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $viewName := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier]/a:value return ($viewName = 'Organisational view')">
          <xsl:attribute name="id">EIRA-012</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-012] SBB '<xsl:text />
            <xsl:value-of select="a:name" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value" />
            <xsl:text />) is not present in the model's Organisational view.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $viewName := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier]/a:value return ($viewName = 'Semantic view')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $viewName := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier]/a:value return ($viewName = 'Semantic view')">
          <xsl:attribute name="id">EIRA-013</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-013] SBB '<xsl:text />
            <xsl:value-of select="a:name" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value" />
            <xsl:text />) is not present in the model's Semantic view.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $viewName := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier]/a:value return ($viewName = 'Technical view - application')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $viewName := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier]/a:value return ($viewName = 'Technical view - application')">
          <xsl:attribute name="id">EIRA-014</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-014] SBB '<xsl:text />
            <xsl:value-of select="a:name" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value" />
            <xsl:text />) is not present in the model's Technical view - application.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $viewName := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier]/a:value return ($viewName = 'Technical view - infrastructure')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $viewName := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier]/a:value return ($viewName = 'Technical view - infrastructure')">
          <xsl:attribute name="id">EIRA-015</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-015] SBB '<xsl:text />
            <xsl:value-of select="a:name" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value" />
            <xsl:text />) is not present in the model's Technical view - infrastructure.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $viewName := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier]/a:value return ($viewName = 'Technical view - application' or $viewName = 'Technical view - infrastructure')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $viewName := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier]/a:value return ($viewName = 'Technical view - application' or $viewName = 'Technical view - infrastructure')">
          <xsl:attribute name="id">EIRA-017</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-017] SBB '<xsl:text />
            <xsl:value-of select="a:name" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value" />
            <xsl:text />) is not present in one of the model's Technical views.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M7" priority="-1" />
  <xsl:template match="@*|node()" mode="M7" priority="-2">
    <xsl:apply-templates mode="M7" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN MEF-Step.03-->


	<!--RULE -->
<xsl:template match="/a:model" mode="M8" priority="1000">
    <svrl:fired-rule context="/a:model" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:PublicPolicyCourseOfAction'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:PublicPolicyCourseOfAction'])">
          <xsl:attribute name="id">EIRA-018-01</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Public Policy' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:LegalActRequirement'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:LegalActRequirement'])">
          <xsl:attribute name="id">EIRA-018-02</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Legal Act' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:DigitalPublicServiceBusinessService'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:DigitalPublicServiceBusinessService'])">
          <xsl:attribute name="id">EIRA-018-03</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Digital Public Service' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:DigitalPublicServiceProviderBusinessRole'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:DigitalPublicServiceProviderBusinessRole'])">
          <xsl:attribute name="id">EIRA-018-04</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Digital Public Service Provider' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:DigitalPublicServiceConsumerBusinessRole'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:DigitalPublicServiceConsumerBusinessRole'])">
          <xsl:attribute name="id">EIRA-018-05</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Digital Public Service Consumer' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:InformationBusinessObject'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:InformationBusinessObject'])">
          <xsl:attribute name="id">EIRA-018-06</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Information' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:DataDataObject'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:DataDataObject'])">
          <xsl:attribute name="id">EIRA-018-07</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Data' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:DataRepresentationRepresentation'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:DataRepresentationRepresentation'])">
          <xsl:attribute name="id">EIRA-018-08</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Data Representation' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:DigitalSolutionApplicationComponent'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:DigitalSolutionApplicationComponent'])">
          <xsl:attribute name="id">EIRA-018-09</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Digital Solution' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:HostingFacilityFacility'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = 'eira:HostingFacilityFacility'])">
          <xsl:attribute name="id">EIRA-018-10</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Hosting Facility' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and (a:value = 'eira:DataPolicyBusinessObject' or a:value = 'eira:MasterDataPolicyBusinessObject' or a:value = 'eira:OpenDataPolicyBusinessObject' or a:value = 'eira:DataPortabilityPolicyBusinessObject' or a:value = 'eira:SecurityPolicyBusinessObject' or a:value = 'eira:PrivacyPolicyBusinessObject')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and (a:value = 'eira:DataPolicyBusinessObject' or a:value = 'eira:MasterDataPolicyBusinessObject' or a:value = 'eira:OpenDataPolicyBusinessObject' or a:value = 'eira:DataPortabilityPolicyBusinessObject' or a:value = 'eira:SecurityPolicyBusinessObject' or a:value = 'eira:PrivacyPolicyBusinessObject')])">
          <xsl:attribute name="id">EIRA-019-01</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-019] All ABBs in the high-level overview must be defined. No 'Data Policy' SBB (or a specialisation) is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[(@xsi:type = 'CommunicationNetwork' or @xsi:type = 'TechnologyService' or @xsi:type = 'Node') and (let $relatedABB := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier and a:value = $relatedABB]]))])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[(@xsi:type = 'CommunicationNetwork' or @xsi:type = 'TechnologyService' or @xsi:type = 'Node') and (let $relatedABB := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier and a:value = $relatedABB]]))])">
          <xsl:attribute name="id">EIRA-019-02</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-019] All ABBs in the high-level overview must be defined. No 'Computing Hosting' SBB (or a specialisation) is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[@xsi:type = 'ApplicationService' and (let $relatedABB := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier and a:value = $relatedABB]]))])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[@xsi:type = 'ApplicationService' and (let $relatedABB := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier and a:value = $relatedABB]]))])">
          <xsl:attribute name="id">EIRA-019-03</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-019] All ABBs in the high-level overview must be defined. No 'Digital Solution Service' SBB (or a specialisation) is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[@xsi:type = 'ApplicationComponent' and (let $relatedABB := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier and a:value = $relatedABB]]))])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[@xsi:type = 'ApplicationComponent' and (let $relatedABB := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier and a:value = $relatedABB]]))])">
          <xsl:attribute name="id">EIRA-019-04</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-019] All ABBs in the high-level overview must be defined. No 'Digital Solution Component' SBB (or a specialisation) is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and (a:value = 'eira:DigitalSolutionApplicationComponent' or a:value = 'DigitalSolutionApplicationService')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and (a:value = 'eira:DigitalSolutionApplicationComponent' or a:value = 'DigitalSolutionApplicationService')])">
          <xsl:attribute name="id">EIRA-020-01</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-020] All ABBs in the high-level overview must be defined. At least one SBB for ABBs ['Digital Solution (Service)', 'Digital Solution (Component)'] must be defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and (a:value = 'eira:MachineToMachineInterfaceApplicationInterface' or a:value = 'eira:HumanInterfaceApplicationInterface')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and (a:value = 'eira:MachineToMachineInterfaceApplicationInterface' or a:value = 'eira:HumanInterfaceApplicationInterface')])">
          <xsl:attribute name="id">EIRA-020-02</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-020] All ABBs in the high-level overview must be defined. At least one SBB for ABBs ['Machine to Machine Interface', 'Human Interface'] must be defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M8" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M8" priority="-1" />
  <xsl:template match="@*|node()" mode="M8" priority="-2">
    <xsl:apply-templates mode="M8" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
</xsl:stylesheet>
