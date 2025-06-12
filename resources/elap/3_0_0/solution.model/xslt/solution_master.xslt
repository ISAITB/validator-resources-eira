<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:a="http://www.opengroup.org/xsd/archimate/3.0/" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:local="local" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
  <xsl:function as="xs:boolean" name="local:inElementSet">
    <xsl:param name="elementIdentifier" />
    <xsl:param name="elementSet" />
    <xsl:sequence select="exists($elementSet[@identifier = $elementIdentifier])" />
  </xsl:function>
  <xsl:function as="element()*" name="local:findAllRelatedElements">
    <xsl:param name="element" />
    <xsl:param name="checkedElements" />
    <xsl:variable name="elementIdentifier" select="$element/@identifier" />
    <xsl:variable as="element()*" name="checkedElementsWithCurrent">
      <xsl:if test="exists($checkedElements)">
        <xsl:for-each select="$checkedElements">
          <xsl:copy-of select="." />
        </xsl:for-each>
      </xsl:if>
      <xsl:copy-of select="$element" />
    </xsl:variable>
    <xsl:variable name="relatedIdentifiers" select="$root/a:model/a:relationships/a:relationship[$elementIdentifier = @source and not(local:inElementSet(@target, $checkedElements))]/@target | $root/a:model/a:relationships/a:relationship[$elementIdentifier = @target and not(local:inElementSet(@source, $checkedElements))]/@source" />
    <xsl:variable name="foundElements" select="$root/a:model/a:elements/a:element[contains-token($relatedIdentifiers, @identifier)]" />
    <xsl:variable as="element()*" name="result">
      <xsl:if test="exists($foundElements)">
        <xsl:for-each select="$foundElements">
          <xsl:copy-of select="local:findAllRelatedElements(., $checkedElementsWithCurrent)" />
        </xsl:for-each>
      </xsl:if>
      <xsl:copy-of select="$element" />
    </xsl:variable>
    <xsl:copy-of select="$result" />
  </xsl:function>
  <xsl:function as="element()*" name="local:findNonHierarchicalLinkedElements">
    <xsl:param name="element" />
    <xsl:variable name="result" select="local:findAllRelatedElements($element, $root/..)[@identifier != $element/@identifier and @xsi:type != 'Principle' and @xsi:type != 'Grouping']" />
    <xsl:sequence select="$result" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="local:isArchitecturePrinciple">
    <xsl:param name="element" />
    <xsl:sequence select="exists($element[@xsi:type = 'Principle' and a:name != 'Architecture Principle' and exists(a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier])])" />
  </xsl:function>
  <xsl:function as="xs:string*" name="local:abbFromPrinciple">
    <xsl:param name="element" />
    <xsl:variable name="abb" select="$satAbb[let $satAbbIdentifier := @identifier return(let $principlePURI := $element/a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value return(let $satPrincipleIdentifier := $satPrinciples[a:properties/a:property[@propertyDefinitionRef = $satDoc/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = $principlePURI]/@identifier return(exists($satDoc/a:model/a:relationships/a:relationship[@target = $satAbbIdentifier and @source = $satPrincipleIdentifier]))))]/a:name" />
    <xsl:sequence select="string-join($abb, '; ')" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="local:findAbbRelatedToPrinciple">
    <xsl:param name="inputPrinciple" />
    <xsl:variable name="equivalentSatPrincipleIdentifier" select="$satPrinciples[let $satPrinciplePURI := a:properties/a:property[@propertyDefinitionRef = $satDoc/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value return ($inputPrinciple/a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = $satPrinciplePURI)]/@identifier" />
    <xsl:variable name="abbsRelatedToSatPrinciple" select="$satAbb[$satDoc/a:model/a:relationships/a:relationship[@source = $equivalentSatPrincipleIdentifier]/@target = @identifier]" />
    <xsl:variable name="result" select="every $abbRelatedToSatPrinciplePURI in $abbsRelatedToSatPrinciple/a:properties/a:property[@propertyDefinitionRef = $satDoc/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier]/a:value satisfies(let $equivalentAbbIdentifier := $inputAbb[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier]/a:value = $abbRelatedToSatPrinciplePURI]/@identifier return (exists($root/a:model/a:relationships/a:relationship[@target = $equivalentAbbIdentifier and @source = $inputPrinciple/@identifier]) or not(exists($abbsRelatedToSatPrinciple))))" />
    <xsl:sequence select="$result" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="local:lackOfPrincipleIsExplained">
    <xsl:param name="element" />
    <xsl:variable name="result" select="let $elementIdentifier := $element/@identifier return (let $elementNodeIdentifier := $notImplementedGroupingNode/a:node[@elementRef = $elementIdentifier]/@identifier return (let $noteNodeTarget := $root/a:model/a:views/a:diagrams/a:view/a:connection[@source = $elementNodeIdentifier]/@target return (let $noteNodeSource := $root/a:model/a:views/a:diagrams/a:view/a:connection[@target = $elementNodeIdentifier]/@source return exists($notImplementedGroupingNode/a:node[(@identifier = $noteNodeSource or @identifier = $noteNodeTarget) and @xsi:type = 'Label']))))" />
    <xsl:sequence select="$result" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="local:isObligation">
    <xsl:param name="element" />
    <xsl:variable name="result" select="let $influenceInDPSLifecycle := $element/a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:influenceInDPSLifecycle']/@identifier]/a:value return (let $influenceInDPSAttribute := $element/a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:influenceInDPSAttribute']/@identifier]/a:value return ($influenceInDPSLifecycle = 'Obligation' or $influenceInDPSAttribute = 'Obligation'))" />
    <xsl:sequence select="$result" />
  </xsl:function>
  
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
    <svrl:schematron-output schemaVersion="" title="Architecture Principle integrity validation">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
        <xsl:value-of select="$archiveNameParameter" />  
        <xsl:value-of select="$fileNameParameter" />  
        <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="a" uri="http://www.opengroup.org/xsd/archimate/3.0/" />
      <svrl:ns-prefix-in-attribute-values prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance" />
      <svrl:ns-prefix-in-attribute-values prefix="local" uri="local" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">CommonCompleteness</xsl:attribute>
        <xsl:attribute name="name">CommonCompleteness</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M26" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">Common</xsl:attribute>
        <xsl:attribute name="name">Common</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M27" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">Common</xsl:attribute>
        <xsl:attribute name="name">Common</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M28" select="/" />
    </svrl:schematron-output>
  </xsl:template>
  
  <!--SCHEMATRON PATTERNS-->
  <svrl:text>Architecture Principle integrity validation</svrl:text>
  <xsl:param name="root" select="/" />
  <xsl:param name="satDoc" select="document('eira/EIRA.xml')" />
  <xsl:param name="satPrinciples" select="$satDoc/a:model/a:elements/a:element[@xsi:type = 'Principle' and a:name != 'Architecture Principle' and exists(a:properties/a:property[@propertyDefinitionRef = $satDoc/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier])]" />
  <xsl:param name="satAbb" select="$satDoc/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $satDoc/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']]" />
  <xsl:param name="inputAbb" select="$root/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']]" />
  <xsl:param name="notImplementedGroupingIdentifier" select="$root/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier]/a:value = 'http://data.europa.eu/dr8/egovera/NotImplementedArchitecturePrinciplesCatalogueGrouping' and @xsi:type = 'Grouping']/@identifier"/>
  <xsl:param name="notImplementedPrinciples" select="$root/a:model/a:elements/a:element[let $elementIdentifier := @identifier return exists($root/a:model/a:relationships/a:relationship[@source = $notImplementedGroupingIdentifier and @target = $elementIdentifier])]"/>
  <xsl:param name="notImplementedGroupingNode" select="$root/a:model/a:views/a:diagrams/a:view/a:node[@elementRef = $notImplementedGroupingIdentifier]"/>
  <!--PATTERN CommonCompleteness-->
  
  
  <!--RULE -->
  <xsl:template match="/a:model" mode="M26" priority="1000">
    <svrl:fired-rule context="/a:model" />
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="true()">
          <xsl:attribute name="id">ELAP-000</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> XSD validation errors.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/accessibility'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/accessibility'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Accessibility' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/accountability'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/accountability'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Accountability' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/administrative-simplification'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/administrative-simplification'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Administrative simplification' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/auditability'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/auditability'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Auditability' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/best-fit-implementation-orientation'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/best-fit-implementation-orientation'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Best fit implementation orientation' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/code-of-ethics-compliance'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/code-of-ethics-compliance'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Code of ethics compliance' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/composability'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/composability'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Composability' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/confidentiality'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/confidentiality'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Confidentiality' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/conformance-chain'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/conformance-chain'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Conformance chain' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/convergence-on-public-policy-goals-attainment'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/convergence-on-public-policy-goals-attainment'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Convergence on public policy goals attainment' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/cost-efficiency'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/cost-efficiency'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Cost efficiency' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/digital-first-leave-no-one-behind'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/digital-first-leave-no-one-behind'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Digital first leave no one behind' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/digital-partnership'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/digital-partnership'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Digital partnership' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/digital-resilience'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/digital-resilience'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Digital resilience' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/environmental-sustainability'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/environmental-sustainability'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Environmental sustainability' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/eu-legislation-compliance'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/eu-legislation-compliance'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'EU legislation compliance' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/eu-localisation-framework-compliance'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/eu-localisation-framework-compliance'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'EU localisation framework compliance' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/evidence-based-public-policy'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/evidence-based-public-policy'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Evidence based public policy' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/findability'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/findability'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Findability' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/ICT-management-from-cradle-to-grave'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/ICT-management-from-cradle-to-grave'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'ICT management from cradle to grave' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/innovation'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/innovation'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Innovation' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/integrated-horizontal-user-experience'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/integrated-horizontal-user-experience'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Integrated horizontal user experience' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/integrity'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/integrity'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Integrity' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/interoperability'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/interoperability'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Interoperability' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/level-playing-field'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/level-playing-field'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Level playing field' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/loose-coupling'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/loose-coupling'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Loose coupling' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/maintainability'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/maintainability'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Maintainability' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/measurability'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/measurability'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Measurability' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/multilingualism'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/multilingualism'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Multilingualism' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/non-repudiation'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/non-repudiation'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Non repudiation' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/once-only'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/once-only'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Once only' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/openness'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/openness'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Openness' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/operational-excellence'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/operational-excellence'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Operational excellence' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/portability'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/portability'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Portability' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/preservation-of-information'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/preservation-of-information'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Preservation of information' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/privacy'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/privacy'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Privacy' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/proactiveness'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/proactiveness'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Proactiveness' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/proportionality'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/proportionality'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Proportionality' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/public-value-maximisation'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/public-value-maximisation'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Public value maximisation' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/reference-architecture'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/reference-architecture'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Reference architecture' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/reuse-before-buy-before-build'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/reuse-before-buy-before-build'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Reuse, before buy, before build' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/scalability'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/scalability'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Scalability' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/security-by-design'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/security-by-design'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Security by design' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/separation-of-concerns'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/separation-of-concerns'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Separation of concerns' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/service-orientation'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/service-orientation'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Service orientation' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/social-participation'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/social-participation'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Social Participation' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/solution-fit'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/solution-fit'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Solution fit' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/sovereignty'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/sovereignty'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Sovereignty' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/subsidiarity'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/subsidiarity'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Subsidiarity' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/technology-neutrality'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/technology-neutrality'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Technology neutrality' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/transparency'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/transparency'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Transparency' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/trust'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/trust'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Trust' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/uncertainty-management'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/uncertainty-management'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Uncertainty management' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/use-of-standards'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/use-of-standards'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'Use of standards' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/user-centricity'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $root/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'elap:PURI']/@identifier]/a:value = 'http://data.europa.eu/2sa/elap/user-centricity'])">
          <xsl:attribute name="id">ELAP-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-001] Architecture principle 'User-centricity' must be defined in the model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M26" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M26" priority="-1" />
  <xsl:template match="@*|node()" mode="M26" priority="-2">
    <xsl:apply-templates mode="M26" select="*" />
  </xsl:template>  
  
  <!--RULE -->
  <xsl:template match="/a:model/a:elements/a:element[local:isArchitecturePrinciple(.)]" mode="M27" priority="1000">
    <svrl:fired-rule context="/a:model/a:elements/a:element[local:isArchitecturePrinciple(.)]" />
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="exists(local:findNonHierarchicalLinkedElements(.)) or local:lackOfPrincipleIsExplained(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(local:findNonHierarchicalLinkedElements(.)) or local:lackOfPrincipleIsExplained(.)">
          <xsl:attribute name="id">ELAP-002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-002] '<xsl:text />
            <xsl:value-of select="./a:name" />
            <xsl:text />' must be associated with at least one element in the model, not being a 'principle'. If the principle is not used, associate it to a note (Archi “note” element).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M27" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M27" priority="-1" />
  <xsl:template match="@*|node()" mode="M27" priority="-2">
    <xsl:apply-templates mode="M27" select="*" />
  </xsl:template>
  
  <!--RULE -->
  <xsl:template match="$notImplementedPrinciples" mode="M28" priority="1000">
    <svrl:fired-rule context="$notImplementedPrinciples" />
    
    <!--ASSERT -->
    <xsl:choose>
      <xsl:when test="not(local:isObligation(.))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(local:isObligation(.))">
          <xsl:attribute name="id">ELAP-003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ELAP-003] Element '<xsl:text />
            <xsl:value-of select="./a:name" />
            <xsl:text />' must be modelled and related to an ABB, as it is an it is considered an obligation.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M28" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M28" priority="-1" />
  <xsl:template match="@*|node()" mode="M28" priority="-2">
    <xsl:apply-templates mode="M28" select="*" />
  </xsl:template>
  
</xsl:stylesheet>
