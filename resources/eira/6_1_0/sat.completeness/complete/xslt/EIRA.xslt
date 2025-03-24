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
    <svrl:schematron-output schemaVersion="" title="EIRA v6.0.0 - SAT Completeness Profile - Complete level">
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
      <xsl:apply-templates mode="M5" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">MEF-Step.02</xsl:attribute>
        <xsl:attribute name="name">MEF-Step.02</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M6" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>EIRA v6.0.0 - SAT Completeness Profile - Complete level</svrl:text>

<!--PATTERN MEF-Step.01-->


	<!--RULE -->
<xsl:template match="/a:model" mode="M5" priority="1001">
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
      <xsl:when test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/InteroperabilityRequirementRequirement']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/InteroperabilityRequirementRequirement']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])">
          <xsl:attribute name="id">EIRA-022</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-022] At least one SBB should be defined for the 'Interoperability Requirement' ABB or one of its specialisations ('Legal', 'Organisational', 'Semantic' or 'Technical Interoperability Requirement').</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and (a:value = 'http://data.europa.eu/dr8/MachineToMachineInterfaceApplicationInterface' or a:value = 'http://data.europa.eu/dr8/HumanInterfaceApplicationInterface')]]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and (a:value = 'http://data.europa.eu/dr8/MachineToMachineInterfaceApplicationInterface' or a:value = 'http://data.europa.eu/dr8/HumanInterfaceApplicationInterface')]]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])">
          <xsl:attribute name="id">EIRA-023</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-023] At least one SBB must be defined for the 'Machine to Machine Interface' or 'Human Interface' ABBs.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/LegislationCatalogueBusinessObject']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/LegislationCatalogueBusinessObject']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])">
          <xsl:attribute name="id">EIRA-024-01</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Legislation Catalogue' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/DigitalPublicServiceCatalogueBusinessObject']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/DigitalPublicServiceCatalogueBusinessObject']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])">
          <xsl:attribute name="id">EIRA-024-02</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Digital Public Service Catalogue' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/DatasetCatalogueDataObject']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/DatasetCatalogueDataObject']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])">
          <xsl:attribute name="id">EIRA-024-03</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Dataset Catalogue' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/OntologiesCatalogueDataObject']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/OntologiesCatalogueDataObject']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])">
          <xsl:attribute name="id">EIRA-024-04</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Ontologies Catalogue' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and (a:value = 'http://data.europa.eu/dr8/ServiceRegistryDataObject' or a:value = 'http://data.europa.eu/dr8/ServiceRegistryApplicationComponent')]]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and (a:value = 'http://data.europa.eu/dr8/ServiceRegistryDataObject' or a:value = 'http://data.europa.eu/dr8/ServiceRegistryApplicationComponent')]]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])">
          <xsl:attribute name="id">EIRA-024-05</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Service Registry' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and (a:value = 'http://data.europa.eu/dr8/APICatalogueDataObject' or a:value = 'http://data.europa.eu/dr8/APICatalogueApplicationComponent')]]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and (a:value = 'http://data.europa.eu/dr8/APICatalogueDataObject' or a:value = 'http://data.europa.eu/dr8/APICatalogueApplicationComponent')]]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])">
          <xsl:attribute name="id">EIRA-024-06</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'API Catalogue' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/LegislationOnDataInformationAndKnowledgeExchangeBusinessObject']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/LegislationOnDataInformationAndKnowledgeExchangeBusinessObject']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])">
          <xsl:attribute name="id">EIRA-024-07</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Legislation on Data Information and Knowledge Exchange' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/DataMappingDataObject']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/DataMappingDataObject']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])">
          <xsl:attribute name="id">EIRA-024-09</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Data mapping' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/LegalInteroperabilityAgreementContract']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/LegalInteroperabilityAgreementContract']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])">
          <xsl:attribute name="id">EIRA-024-10</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Legal Interoperability Agreement' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/OrganisationalInteroperabilityAgreementContract']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/OrganisationalInteroperabilityAgreementContract']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])">
          <xsl:attribute name="id">EIRA-024-11</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Organisational Interoperability Agreement' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/SemanticInteroperabilityAgreementContract']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/SemanticInteroperabilityAgreementContract']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])">
          <xsl:attribute name="id">EIRA-024-12</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Semantic Interoperability Agreement' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/TechnicalInteroperabilityAgreementContract']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $abbType := /a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = 'http://data.europa.eu/dr8/TechnicalInteroperabilityAgreementContract']]/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier]/a:value return(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier and a:value = $abbType])">
          <xsl:attribute name="id">EIRA-024-13</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Technical Interoperability Agreement' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M5" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:SolutionBuildingBlock']]" mode="M5" priority="1000">
    <svrl:fired-rule context="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:SolutionBuildingBlock']]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $elementType := @xsi:type return (every $sbbPuri in a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier]/a:value satisfies (let $sbb := document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:SolutionBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = $sbbPuri]] return ($sbb/@xsi:type = $elementType or not(exists($sbb)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $elementType := @xsi:type return (every $sbbPuri in a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier]/a:value satisfies (let $sbb := document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:SolutionBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = $sbbPuri]] return ($sbb/@xsi:type = $elementType or not(exists($sbb)))))">
          <xsl:attribute name="id">EIRA-003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-003] SBB '<xsl:text />
            <xsl:value-of select="a:name" />
            <xsl:text />' (Related ABB '<xsl:text />
            <xsl:value-of select="let $relatedABB := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value return (/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier and a:value = $relatedABB]]/a:name)" />
            <xsl:text />') has an invalid element type '<xsl:text />
            <xsl:value-of select="@xsi:type" />
            <xsl:text />'. Expected element type '<xsl:text />
            <xsl:value-of select="let $sbbPuri := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier]/a:value return (document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:SolutionBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier and a:value = $sbbPuri]]/@xsi:type)" />
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
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="let $relatedABB := a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier]/a:value return (/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']][a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier and a:value = $relatedABB]]/a:name)" />
            <xsl:text />).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M5" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M5" priority="-1" />
  <xsl:template match="@*|node()" mode="M5" priority="-2">
    <xsl:apply-templates mode="M5" select="@*|*" />
  </xsl:template>

<!--PATTERN MEF-Step.02-->


	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Legal view'))]))]" mode="M6" priority="1011">
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
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Organisational view'))]))]" mode="M6" priority="1010">
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
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Semantic view'))]))]" mode="M6" priority="1009">
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
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - application'))]))]" mode="M6" priority="1008">
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
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - infrastructure'))]))]" mode="M6" priority="1007">
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
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - application' or $viewName = 'Technical view - infrastructure'))]))]" mode="M6" priority="1006">
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
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Legal view'))]))]" mode="M6" priority="1005">
    <svrl:fired-rule context="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Legal view'))]))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Legal view')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Legal view')">
          <xsl:attribute name="id">EIRA-029</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-029] ABB '<xsl:text />
            <xsl:value-of select="string(a:name)" />
            <xsl:text />' is not present in the model's Legal view.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Organisational view'))]))]" mode="M6" priority="1004">
    <svrl:fired-rule context="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Organisational view'))]))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Organisational view')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Organisational view')">
          <xsl:attribute name="id">EIRA-030</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-030] ABB '<xsl:text />
            <xsl:value-of select="string(a:name)" />
            <xsl:text />' is not present in the model's Organisational view.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Semantic view'))]))]" mode="M6" priority="1003">
    <svrl:fired-rule context="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Semantic view'))]))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Semantic view')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Semantic view')">
          <xsl:attribute name="id">EIRA-031</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-031] ABB '<xsl:text />
            <xsl:value-of select="string(a:name)" />
            <xsl:text />' is not present in the model's Semantic view.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - application'))]))]" mode="M6" priority="1002">
    <svrl:fired-rule context="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - application'))]))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - application')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - application')">
          <xsl:attribute name="id">EIRA-032</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-032] ABB '<xsl:text />
            <xsl:value-of select="string(a:name)" />
            <xsl:text />' is not present in the model's Technical view - application.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - infrastructure'))]))]" mode="M6" priority="1001">
    <svrl:fired-rule context="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - infrastructure'))]))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - infrastructure')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - infrastructure')">
          <xsl:attribute name="id">EIRA-033</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-033] ABB '<xsl:text />
            <xsl:value-of select="string(a:name)" />
            <xsl:text />' is not present in the model's Technical view - infrastructure.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - application' or $viewName = 'Technical view - infrastructure'))]))]" mode="M6" priority="1000">
    <svrl:fired-rule context="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and (let $declaredAbbName := a:name return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $declaredAbbName and (let $viewName := a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - application' or $viewName = 'Technical view - infrastructure'))]))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - application' or $viewName = 'Technical view - infrastructure')" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $viewName := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:view']/@identifier)]/a:value return exists($viewName = 'Technical view - application' or $viewName = 'Technical view - infrastructure')">
          <xsl:attribute name="id">EIRA-035</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-035] ABB '<xsl:text />
            <xsl:value-of select="string(a:name)" />
            <xsl:text />' is not present in one of the model's Technical views.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M6" priority="-1" />
  <xsl:template match="@*|node()" mode="M6" priority="-2">
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>
</xsl:stylesheet>
