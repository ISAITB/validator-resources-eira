<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
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
    <svrl:schematron-output schemaVersion="" title="EIRA v4.1.0 - Solution Completeness Profile - Complete level">
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
<svrl:text>EIRA v4.1.0 - Solution Completeness Profile - Complete level</svrl:text>

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
    <xsl:apply-templates mode="M6" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*eira:.+[ \t]*>>.+')]" mode="M6" priority="1002">
    <svrl:fired-rule context="/a:model/a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*eira:.+[ \t]*>>.+')]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $sbbDeclaredAbbName in substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:'), $elementType in string(@xsi:type) satisfies (let $abb := document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier)] and string(a:name) = $sbbDeclaredAbbName] return not(exists($abb)) or $abb/@xsi:type = $elementType)" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $sbbDeclaredAbbName in substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:'), $elementType in string(@xsi:type) satisfies (let $abb := document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier)] and string(a:name) = $sbbDeclaredAbbName] return not(exists($abb)) or $abb/@xsi:type = $elementType)">
          <xsl:attribute name="id">EIRA-003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-003] SBB '<xsl:text />
            <xsl:value-of select="normalize-space(substring-after(string(a:name), '>>'))" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')" />
            <xsl:text />) has an invalid element type '<xsl:text />
            <xsl:value-of select="string(@xsi:type)" />
            <xsl:text />'. Expected element type '<xsl:text />
            <xsl:value-of select="let $elementName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return string(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $elementName]/@xsi:type)" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $sbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[string(a:name) = $sbbName])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $sbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[string(a:name) = $sbbName])">
          <xsl:attribute name="id">EIRA-004</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-004] SBB '<xsl:text />
            <xsl:value-of select="normalize-space(substring-after(string(a:name), '>>'))" />
            <xsl:text />' references an invalid ABB. No ABB is defined for name '<xsl:text />
            <xsl:value-of select="substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $abbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return (let $sbbAttributes := a:properties return (every $abbAttributeName in document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[(let $propId := string(@identifier) return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[string(a:name) = $abbName]/a:properties/a:property[string(@propertyDefinitionRef) = $propId]))]/a:name/string(.) satisfies (($abbAttributeName = 'ID' or $abbAttributeName = 'eira:ABB_Status' or $abbAttributeName = 'eira:synonym' or $abbAttributeName = 'eira:unit_in_DG' or $abbAttributeName = 'dct:references' or $abbAttributeName = 'eira:reuse_status' or $abbAttributeName = 'eira:specific_policy_issue' or $abbAttributeName = 'eira:operational_date' or $abbAttributeName = 'dct:description' or $abbAttributeName = 'eira:policy_area' or $abbAttributeName = 'eira:owner' or $abbAttributeName = 'eira:description' or $abbAttributeName = 'eira:reusability_score' or $abbAttributeName = 'eira:data_quality_level' or $abbAttributeName = 'eira:data_quality_score' or $abbAttributeName = 'eira:iop_level' or $abbAttributeName = 'eira:iop_score' or $abbAttributeName = 'eira:GovIS_ID' or $abbAttributeName = 'eira:IES_category' or $abbAttributeName = 'eira:importance_for_the_functioning_of_the_EU' or $abbAttributeName = 'eira:actual_use' or $abbAttributeName = 'eira:actual_reuse' or $abbAttributeName = 'eira:view') or exists($sbbAttributes/a:property[(let $ssbPropId := string(@propertyDefinitionRef) return exists(/a:model/a:propertyDefinitions/a:propertyDefinition[string(@identifier) = $ssbPropId and string(a:name) = $abbAttributeName])) and normalize-space(string(./a:value)) != '']))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $abbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return (let $sbbAttributes := a:properties return (every $abbAttributeName in document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[(let $propId := string(@identifier) return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[string(a:name) = $abbName]/a:properties/a:property[string(@propertyDefinitionRef) = $propId]))]/a:name/string(.) satisfies (($abbAttributeName = 'ID' or $abbAttributeName = 'eira:ABB_Status' or $abbAttributeName = 'eira:synonym' or $abbAttributeName = 'eira:unit_in_DG' or $abbAttributeName = 'dct:references' or $abbAttributeName = 'eira:reuse_status' or $abbAttributeName = 'eira:specific_policy_issue' or $abbAttributeName = 'eira:operational_date' or $abbAttributeName = 'dct:description' or $abbAttributeName = 'eira:policy_area' or $abbAttributeName = 'eira:owner' or $abbAttributeName = 'eira:description' or $abbAttributeName = 'eira:reusability_score' or $abbAttributeName = 'eira:data_quality_level' or $abbAttributeName = 'eira:data_quality_score' or $abbAttributeName = 'eira:iop_level' or $abbAttributeName = 'eira:iop_score' or $abbAttributeName = 'eira:GovIS_ID' or $abbAttributeName = 'eira:IES_category' or $abbAttributeName = 'eira:importance_for_the_functioning_of_the_EU' or $abbAttributeName = 'eira:actual_use' or $abbAttributeName = 'eira:actual_reuse' or $abbAttributeName = 'eira:view') or exists($sbbAttributes/a:property[(let $ssbPropId := string(@propertyDefinitionRef) return exists(/a:model/a:propertyDefinitions/a:propertyDefinition[string(@identifier) = $ssbPropId and string(a:name) = $abbAttributeName])) and normalize-space(string(./a:value)) != '']))))">
          <xsl:attribute name="id">EIRA-005</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-005] SBB '<xsl:text />
            <xsl:value-of select="normalize-space(substring-after(string(a:name), '>>'))" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')" />
            <xsl:text />) is missing required attribute(s) [<xsl:text />
            <xsl:value-of select="let $sbbProperties := a:properties return (let $sbbPropertyDefinitions := /a:model/a:propertyDefinitions return (let $abbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(./a:name), '&lt;&lt;')), '>>')), 'eira:') return (document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[not(string(./a:name) = 'ID' or string(./a:name) = 'eira:ABB_Status' or string(./a:name) = 'eira:synonym' or string(./a:name) = 'eira:unit_in_DG' or string(./a:name) = 'dct:references' or string(./a:name) = 'eira:reuse_status' or string(./a:name) = 'eira:specific_policy_issue' or string(./a:name) = 'eira:operational_date' or string(./a:name) = 'dct:description' or string(./a:name) = 'eira:policy_area' or string(./a:name) = 'eira:owner' or string(./a:name) = 'eira:description' or string(./a:name) = 'eira:reusability_score' or string(./a:name) = 'eira:data_quality_level' or string(./a:name) = 'eira:data_quality_score' or string(./a:name) = 'eira:iop_level' or string(./a:name) = 'eira:iop_score' or string(./a:name) = 'eira:GovIS_ID' or string(./a:name) = 'eira:IES_category' or string(./a:name) = 'eira:importance_for_the_functioning_of_the_EU' or string(./a:name) = 'eira:actual_use' or string(./a:name) = 'eira:actual_reuse' or string(./a:name) = 'eira:view') and (let $propId := string(./@identifier) return (let $propName := string(./a:name) return (exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[string(./a:name) = $abbName]/a:properties/a:property[string(./@propertyDefinitionRef) = $propId and not(exists($sbbPropertyDefinitions/a:propertyDefinition[(let $modelPropId := string(./@identifier) return exists($sbbProperties/a:property[string(./@propertyDefinitionRef) = $modelPropId and normalize-space(string(./a:value)) != ''])) and string(./a:name) = $propName]))]))))])))/a:name/string(.)" />
            <xsl:text />].</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $sbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return (let $abb := document('eira/EIRA.xml')/a:model/a:elements/a:element[string(a:name) = $sbbName] return (not(exists($abb)) or not(exists($abb/a:properties/a:property[string(./a:value) = 'Obsolete' and string(./@propertyDefinitionRef) = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./a:name) = 'eira:ABB_Status']/@identifier)]))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $sbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return (let $abb := document('eira/EIRA.xml')/a:model/a:elements/a:element[string(a:name) = $sbbName] return (not(exists($abb)) or not(exists($abb/a:properties/a:property[string(./a:value) = 'Obsolete' and string(./@propertyDefinitionRef) = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./a:name) = 'eira:ABB_Status']/@identifier)]))))">
          <xsl:attribute name="id">EIRA-006</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-006] SBB '<xsl:text />
            <xsl:value-of select="normalize-space(substring-after(string(a:name), '>>'))" />
            <xsl:text />' refers to obsolete ABB '<xsl:text />
            <xsl:value-of select="substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[let $name := string(a:name) return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier)] and string(a:name) = $name])]" mode="M6" priority="1001">
    <svrl:fired-rule context="/a:model/a:elements/a:element[let $name := string(a:name) return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier)] and string(a:name) = $name])]" />

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
            <xsl:value-of select="normalize-space(string(a:name))" />
            <xsl:text />') must not be defined in a solution.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $elementName in string(a:name), $elementType in string(@xsi:type) satisfies ($elementType = string(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier)] and string(a:name) = $elementName]/@xsi:type))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $elementName in string(a:name), $elementType in string(@xsi:type) satisfies ($elementType = string(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier)] and string(a:name) = $elementName]/@xsi:type))">
          <xsl:attribute name="id">EIRA-008</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-008] ABB '<xsl:text />
            <xsl:value-of select="normalize-space(string(a:name))" />
            <xsl:text />' defined with element type '<xsl:text />
            <xsl:value-of select="string(@xsi:type)" />
            <xsl:text />' that does not match the EIRA. Expected element type '<xsl:text />
            <xsl:value-of select="let $elementName := string(a:name) return string(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:name = $elementName]/@xsi:type)" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*eira:.+[ \t]*>>.+')]/a:properties/a:property[(let $propId := string(./@propertyDefinitionRef) return (let $propertyName := string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $propId]/a:name) return (let $abbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(./../../a:name), '&lt;&lt;')), '>>')), 'eira:') return (exists(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./a:name) = $propertyName and (let $abbPropId := string(./@identifier) return (exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[string(./a:name) = $abbName]/a:properties/a:property[string(./@propertyDefinitionRef) = $abbPropId])))])))))]" mode="M6" priority="1000">
    <svrl:fired-rule context="/a:model/a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*eira:.+[ \t]*>>.+')]/a:properties/a:property[(let $propId := string(./@propertyDefinitionRef) return (let $propertyName := string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $propId]/a:name) return (let $abbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(./../../a:name), '&lt;&lt;')), '>>')), 'eira:') return (exists(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./a:name) = $propertyName and (let $abbPropId := string(./@identifier) return (exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[string(./a:name) = $abbName]/a:properties/a:property[string(./@propertyDefinitionRef) = $abbPropId])))])))))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $pValue := normalize-space(string(a:value)) return (let $pIdentifier := string(@propertyDefinitionRef) return (let $propertyName := string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $pIdentifier]/a:name) return (matches($propertyName, '(ID|eira:synonym)') or (let $abbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(../../a:name), '&lt;&lt;')), '>>')), 'eira:') return (let $abbPropDefinition := (normalize-space(replace(string((document('eira/EIRA.xml')/a:model/a:elements/a:element[string(./a:name) = $abbName]/a:properties/a:property[(let $abbPropId := string(./@propertyDefinitionRef) return (exists(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $abbPropId and string(./a:name) = $propertyName])))]/a:value)[1]), '[\-\)\(]', '~'))) return (if (matches($abbPropDefinition, '\[[\w\d\s%~,\.\|]*[\w\d\s,\.%~]\]')) then let $validTokens := tokenize(substring-before(substring-after($abbPropDefinition, '['), ']'), '([ ]*\|[ ]*)|(^[ ]+)|([ ]+$)') return (index-of($validTokens, replace($pValue, '[\-\)\(]', '~')) > 0) else if ($abbPropDefinition != '') then normalize-space(replace($pValue, '[\-\)\(]', '~')) = $abbPropDefinition else true()))))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $pValue := normalize-space(string(a:value)) return (let $pIdentifier := string(@propertyDefinitionRef) return (let $propertyName := string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $pIdentifier]/a:name) return (matches($propertyName, '(ID|eira:synonym)') or (let $abbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(../../a:name), '&lt;&lt;')), '>>')), 'eira:') return (let $abbPropDefinition := (normalize-space(replace(string((document('eira/EIRA.xml')/a:model/a:elements/a:element[string(./a:name) = $abbName]/a:properties/a:property[(let $abbPropId := string(./@propertyDefinitionRef) return (exists(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $abbPropId and string(./a:name) = $propertyName])))]/a:value)[1]), '[\-\)\(]', '~'))) return (if (matches($abbPropDefinition, '\[[\w\d\s%~,\.\|]*[\w\d\s,\.%~]\]')) then let $validTokens := tokenize(substring-before(substring-after($abbPropDefinition, '['), ']'), '([ ]*\|[ ]*)|(^[ ]+)|([ ]+$)') return (index-of($validTokens, replace($pValue, '[\-\)\(]', '~')) > 0) else if ($abbPropDefinition != '') then normalize-space(replace($pValue, '[\-\)\(]', '~')) = $abbPropDefinition else true()))))))">
          <xsl:attribute name="id">EIRA-009</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-009] SBB '<xsl:text />
            <xsl:value-of select="normalize-space(substring-after(string(../../a:name), '>>'))" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="substring-after(normalize-space(substring-before(normalize-space(substring-after(string(../../a:name), '&lt;&lt;')), '>>')), 'eira:')" />
            <xsl:text />) defines invalid value '<xsl:text />
            <xsl:value-of select="string(a:value)" />
            <xsl:text />' for attribute '<xsl:text />
            <xsl:value-of select="let $propId := string(./@propertyDefinitionRef) return (string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $propId]/a:name))" />
            <xsl:text />'. Expected '<xsl:text />
            <xsl:value-of select="let $pIdentifier := string(./@propertyDefinitionRef) return (let $propertyName := string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $pIdentifier]/a:name) return (let $abbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(../../a:name), '&lt;&lt;')), '>>')), 'eira:') return (string((document('eira/EIRA.xml')/a:model/a:elements/a:element[string(./a:name) = $abbName]/a:properties/a:property[(let $abbPropId := string(./@propertyDefinitionRef) return (exists(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $abbPropId and string(./a:name) = $propertyName])))]/a:value)[1]))))" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $pElement := (./../..) return (let $pIdentifier := string(@propertyDefinitionRef) return (let $propertyName := string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $pIdentifier]/a:name) return (let $abbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(../../a:name), '&lt;&lt;')), '>>')), 'eira:') return (let $abbPropDefinition := (replace(string((document('eira/EIRA.xml')/a:model/a:elements/a:element[string(./a:name) = $abbName]/a:properties/a:property[(let $abbPropId := string(./@propertyDefinitionRef) return (exists(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $abbPropId and string(./a:name) = $propertyName])))]/a:value)[1]), '\-', '~')) return (if (matches($abbPropDefinition, '\[(([\w\d\s\|]+)|([\w\d\s]+))\]\*')) then true() else count($pElement/a:properties/a:property[string(./@propertyDefinitionRef) = $pIdentifier]) = 1)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $pElement := (./../..) return (let $pIdentifier := string(@propertyDefinitionRef) return (let $propertyName := string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $pIdentifier]/a:name) return (let $abbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(../../a:name), '&lt;&lt;')), '>>')), 'eira:') return (let $abbPropDefinition := (replace(string((document('eira/EIRA.xml')/a:model/a:elements/a:element[string(./a:name) = $abbName]/a:properties/a:property[(let $abbPropId := string(./@propertyDefinitionRef) return (exists(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $abbPropId and string(./a:name) = $propertyName])))]/a:value)[1]), '\-', '~')) return (if (matches($abbPropDefinition, '\[(([\w\d\s\|]+)|([\w\d\s]+))\]\*')) then true() else count($pElement/a:properties/a:property[string(./@propertyDefinitionRef) = $pIdentifier]) = 1)))))">
          <xsl:attribute name="id">EIRA-010</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-010] SBB '<xsl:text />
            <xsl:value-of select="normalize-space(substring-after(string(../../a:name), '>>'))" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="substring-after(normalize-space(substring-before(normalize-space(substring-after(string(../../a:name), '&lt;&lt;')), '>>')), 'eira:')" />
            <xsl:text />) must not define multiple values for attribute '<xsl:text />
            <xsl:value-of select="let $propId := string(./@propertyDefinitionRef) return (string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $propId]/a:name))" />
            <xsl:text />'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M6" priority="-1" />
  <xsl:template match="@*|node()" mode="M6" priority="-2">
    <xsl:apply-templates mode="M6" select="*" />
  </xsl:template>

<!--PATTERN MEF-Step.02-->


	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*eira:.+[ \t]*>>.+') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName and (let $abbElementId := string(@identifier) return exists(document('eira/EIRA.xml')/a:model/a:organizations//a:item[string(a:label) = 'Legal View Concepts']/a:item[string(@identifierRef) = $abbElementId]))]))]" mode="M7" priority="1006">
    <svrl:fired-rule context="/a:model/a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*eira:.+[ \t]*>>.+') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName and (let $abbElementId := string(@identifier) return exists(document('eira/EIRA.xml')/a:model/a:organizations//a:item[string(a:label) = 'Legal View Concepts']/a:item[string(@identifierRef) = $abbElementId]))]))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $elementId := string(@identifier) return exists(/a:model/a:views/a:diagrams/a:view[string(a:name) = 'Legal view']//a:node[string(@elementRef) = $elementId])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $elementId := string(@identifier) return exists(/a:model/a:views/a:diagrams/a:view[string(a:name) = 'Legal view']//a:node[string(@elementRef) = $elementId])">
          <xsl:attribute name="id">EIRA-011</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-011] SBB '<xsl:text />
            <xsl:value-of select="normalize-space(substring-after(string(a:name), '>>'))" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')" />
            <xsl:text />) is not present in the model's Legal view.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*eira:.+[ \t]*>>.+') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName and (let $abbElementId := string(@identifier) return exists(document('eira/EIRA.xml')/a:model/a:organizations//a:item[string(a:label) = 'Organisational View Concepts']/a:item[string(@identifierRef) = $abbElementId]))]))]" mode="M7" priority="1005">
    <svrl:fired-rule context="/a:model/a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*eira:.+[ \t]*>>.+') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName and (let $abbElementId := string(@identifier) return exists(document('eira/EIRA.xml')/a:model/a:organizations//a:item[string(a:label) = 'Organisational View Concepts']/a:item[string(@identifierRef) = $abbElementId]))]))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $elementId := string(@identifier) return exists(/a:model/a:views/a:diagrams/a:view[string(a:name) = 'Organisational view']//a:node[string(@elementRef) = $elementId])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $elementId := string(@identifier) return exists(/a:model/a:views/a:diagrams/a:view[string(a:name) = 'Organisational view']//a:node[string(@elementRef) = $elementId])">
          <xsl:attribute name="id">EIRA-012</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-012] SBB '<xsl:text />
            <xsl:value-of select="normalize-space(substring-after(string(a:name), '>>'))" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')" />
            <xsl:text />) is not present in the model's Organisational view.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*eira:.+[ \t]*>>.+') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName and (let $abbElementId := string(@identifier) return exists(document('eira/EIRA.xml')/a:model/a:organizations//a:item[string(a:label) = 'Semantic View Concepts']/a:item[string(@identifierRef) = $abbElementId]))]))]" mode="M7" priority="1004">
    <svrl:fired-rule context="/a:model/a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*eira:.+[ \t]*>>.+') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName and (let $abbElementId := string(@identifier) return exists(document('eira/EIRA.xml')/a:model/a:organizations//a:item[string(a:label) = 'Semantic View Concepts']/a:item[string(@identifierRef) = $abbElementId]))]))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $elementId := string(@identifier) return exists(/a:model/a:views/a:diagrams/a:view[string(a:name) = 'Semantic view']//a:node[string(@elementRef) = $elementId])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $elementId := string(@identifier) return exists(/a:model/a:views/a:diagrams/a:view[string(a:name) = 'Semantic view']//a:node[string(@elementRef) = $elementId])">
          <xsl:attribute name="id">EIRA-013</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-013] SBB '<xsl:text />
            <xsl:value-of select="normalize-space(substring-after(string(a:name), '>>'))" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')" />
            <xsl:text />) is not present in the model's Semantic view.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*eira:.+[ \t]*>>.+') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return (not($declaredAbbName = 'Technical Interoperability Specification' or $declaredAbbName = 'Technical Specification' or $declaredAbbName = 'Interoperability Specification' or $declaredAbbName = 'Solution Specification') and exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName and (let $abbElementId := string(@identifier) return exists(document('eira/EIRA.xml')/a:model/a:organizations//a:item[string(a:label) = 'Technical View Concepts' or string(a:label) = 'Technical View - Application Concepts']/a:item[string(@identifierRef) = $abbElementId]))])))]" mode="M7" priority="1003">
    <svrl:fired-rule context="/a:model/a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*eira:.+[ \t]*>>.+') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return (not($declaredAbbName = 'Technical Interoperability Specification' or $declaredAbbName = 'Technical Specification' or $declaredAbbName = 'Interoperability Specification' or $declaredAbbName = 'Solution Specification') and exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName and (let $abbElementId := string(@identifier) return exists(document('eira/EIRA.xml')/a:model/a:organizations//a:item[string(a:label) = 'Technical View Concepts' or string(a:label) = 'Technical View - Application Concepts']/a:item[string(@identifierRef) = $abbElementId]))])))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $elementId := string(@identifier) return exists(/a:model/a:views/a:diagrams/a:view[string(a:name) = 'Technical view - application']//a:node[string(@elementRef) = $elementId])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $elementId := string(@identifier) return exists(/a:model/a:views/a:diagrams/a:view[string(a:name) = 'Technical view - application']//a:node[string(@elementRef) = $elementId])">
          <xsl:attribute name="id">EIRA-014</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-014] SBB '<xsl:text />
            <xsl:value-of select="normalize-space(substring-after(string(a:name), '>>'))" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')" />
            <xsl:text />) is not present in the model's Technical view - application.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*eira:.+[ \t]*>>.+') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return (not($declaredAbbName = 'Technical Interoperability Specification' or $declaredAbbName = 'Technical Specification' or $declaredAbbName = 'Interoperability Specification' or $declaredAbbName = 'Solution Specification') and exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName and (let $abbElementId := string(@identifier) return exists(document('eira/EIRA.xml')/a:model/a:organizations//a:item[string(a:label) = 'Technical View - Infrastructure Concepts']/a:item[string(@identifierRef) = $abbElementId]))])))]" mode="M7" priority="1002">
    <svrl:fired-rule context="/a:model/a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*eira:.+[ \t]*>>.+') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return (not($declaredAbbName = 'Technical Interoperability Specification' or $declaredAbbName = 'Technical Specification' or $declaredAbbName = 'Interoperability Specification' or $declaredAbbName = 'Solution Specification') and exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName and (let $abbElementId := string(@identifier) return exists(document('eira/EIRA.xml')/a:model/a:organizations//a:item[string(a:label) = 'Technical View - Infrastructure Concepts']/a:item[string(@identifierRef) = $abbElementId]))])))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $elementId := string(@identifier) return exists(/a:model/a:views/a:diagrams/a:view[string(a:name) = 'Technical view - infrastructure']//a:node[string(@elementRef) = $elementId])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $elementId := string(@identifier) return exists(/a:model/a:views/a:diagrams/a:view[string(a:name) = 'Technical view - infrastructure']//a:node[string(@elementRef) = $elementId])">
          <xsl:attribute name="id">EIRA-015</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-015] SBB '<xsl:text />
            <xsl:value-of select="normalize-space(substring-after(string(a:name), '>>'))" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')" />
            <xsl:text />) is not present in the model's Technical view - infrastructure.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*eira:.+[ \t]*>>.+') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName and (let $abbElementId := string(@identifier) return exists(document('eira/EIRA.xml')/a:model/a:organizations//a:item[string(a:label) = 'Architectural Principles Concepts']/a:item[string(@identifierRef) = $abbElementId]))]))]" mode="M7" priority="1001">
    <svrl:fired-rule context="/a:model/a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*eira:.+[ \t]*>>.+') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName and (let $abbElementId := string(@identifier) return exists(document('eira/EIRA.xml')/a:model/a:organizations//a:item[string(a:label) = 'Architectural Principles Concepts']/a:item[string(@identifierRef) = $abbElementId]))]))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $elementId := string(@identifier) return exists(/a:model/a:views/a:diagrams/a:view[string(a:name) = 'Architectural Principles view']//a:node[string(@elementRef) = $elementId])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $elementId := string(@identifier) return exists(/a:model/a:views/a:diagrams/a:view[string(a:name) = 'Architectural Principles view']//a:node[string(@elementRef) = $elementId])">
          <xsl:attribute name="id">EIRA-016</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-016] SBB '<xsl:text />
            <xsl:value-of select="normalize-space(substring-after(string(a:name), '>>'))" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')" />
            <xsl:text />) is not present in the model's Architectural Principles view.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/a:model/a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*eira:.+[ \t]*>>.+') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return ($declaredAbbName = 'Technical Interoperability Specification' or $declaredAbbName = 'Technical Specification' or $declaredAbbName = 'Interoperability Specification' or $declaredAbbName = 'Solution Specification'))]" mode="M7" priority="1000">
    <svrl:fired-rule context="/a:model/a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*eira:.+[ \t]*>>.+') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return ($declaredAbbName = 'Technical Interoperability Specification' or $declaredAbbName = 'Technical Specification' or $declaredAbbName = 'Interoperability Specification' or $declaredAbbName = 'Solution Specification'))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="let $elementId := string(@identifier) return exists(/a:model/a:views/a:diagrams/a:view[string(a:name) = 'Technical view - application' or string(a:name) = 'Technical view - infrastructure']//a:node[string(@elementRef) = $elementId])" />
      <xsl:otherwise>
        <svrl:failed-assert test="let $elementId := string(@identifier) return exists(/a:model/a:views/a:diagrams/a:view[string(a:name) = 'Technical view - application' or string(a:name) = 'Technical view - infrastructure']//a:node[string(@elementRef) = $elementId])">
          <xsl:attribute name="id">EIRA-017</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-017] SBB '<xsl:text />
            <xsl:value-of select="normalize-space(substring-after(string(a:name), '>>'))" />
            <xsl:text />' (<xsl:text />
            <xsl:value-of select="substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')" />
            <xsl:text />) is not present in one of the model's Technical views.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M7" priority="-1" />
  <xsl:template match="@*|node()" mode="M7" priority="-2">
    <xsl:apply-templates mode="M7" select="*" />
  </xsl:template>

<!--PATTERN MEF-Step.03-->


	<!--RULE -->
<xsl:template match="/a:model" mode="M8" priority="1000">
    <svrl:fired-rule context="/a:model" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')), 'Public Policy')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')), 'Public Policy')])">
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
      <xsl:when test="exists(a:elements/a:element[matches(normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')), 'Public Service Provider')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')), 'Public Service Provider')])">
          <xsl:attribute name="id">EIRA-018-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Public Service Provider' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')), 'Public Service Consumer')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')), 'Public Service Consumer')])">
          <xsl:attribute name="id">EIRA-018-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Public Service Consumer' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')), 'Digital Public Service')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')), 'Digital Public Service')])">
          <xsl:attribute name="id">EIRA-018-04</xsl:attribute>
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
      <xsl:when test="exists(a:elements/a:element[matches(normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')), 'Digital Business Capability')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')), 'Digital Business Capability')])">
          <xsl:attribute name="id">EIRA-018-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Digital Business Capability' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')), 'Business Information')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')), 'Business Information')])">
          <xsl:attribute name="id">EIRA-018-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Business Information' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')), 'Representation')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')), 'Representation')])">
          <xsl:attribute name="id">EIRA-018-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-018] All ABBs in the high-level overview must be defined. No 'Representation' SBB is defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(a:elements/a:element[matches(normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')), '(Data Policy|Descriptive Metadata Policy|Master Data Policy|Base Registry Data Policy|Reference Data Policy|Open Data Policy|Data Portability Policy|Security Policy|Privacy Policy)')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')), '(Data Policy|Descriptive Metadata Policy|Master Data Policy|Base Registry Data Policy|Reference Data Policy|Open Data Policy|Data Portability Policy|Security Policy|Privacy Policy)')])">
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
      <xsl:when test="exists(a:elements/a:element[matches(string(@xsi:type), 'CommunicationNetwork|TechnologyService|Node') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName]))])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(@xsi:type), 'CommunicationNetwork|TechnologyService|Node') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName]))])">
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
      <xsl:when test="exists(a:elements/a:element[matches(string(@xsi:type), 'ApplicationService') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName]))])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(@xsi:type), 'ApplicationService') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName]))])">
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
      <xsl:when test="exists(a:elements/a:element[matches(string(@xsi:type), 'ApplicationComponent') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName]))])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(string(@xsi:type), 'ApplicationComponent') and (let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:') return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName]))])">
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
      <xsl:when test="exists(a:elements/a:element[matches(normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')), '(Machine to Machine Interface|Human Interface)')])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(a:elements/a:element[matches(normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '>>')), 'eira:')), '(Machine to Machine Interface|Human Interface)')])">
          <xsl:attribute name="id">EIRA-020-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[EIRA-020] All ABBs in the high-level overview must be defined. At least one SBB for ABBs ['Machine to Machine Interface', 'Human Interface'] must be defined.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M8" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M8" priority="-1" />
  <xsl:template match="@*|node()" mode="M8" priority="-2">
    <xsl:apply-templates mode="M8" select="*" />
  </xsl:template>
</xsl:stylesheet>
