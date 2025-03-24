<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:a="http://www.opengroup.org/xsd/archimate/3.0/"
    xmlns:eira="http://eira.ec.europa.eu">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:variable name="eiraDoc" select="document('eira/EIRA.xml')"/>
    <xsl:variable name="doc" select="/"/>
    <xsl:variable name="iopSpecificationAbbs" select="concat('Interoperability Specification|', eira:childrenAbbs('Interoperability Specification', '|'))"/>

    <xsl:function name="eira:abbFromStereotypedName" as="xs:string">
        <xsl:param name="stereotypedName"/>
        <xsl:value-of select="string($stereotypedName)"/>
    </xsl:function>

    <xsl:function name="eira:sbbFromStereotypedName" as="xs:string">
        <xsl:param name="stereotypedName"/>
        <xsl:value-of select="string($stereotypedName)"/>
    </xsl:function>

    <xsl:function name="eira:isAbbToIgnore" as="xs:boolean">
        <xsl:param name="abbPuri"/>
        <xsl:param name="abbName"/>
        <xsl:variable name="abb" select="eira:abbByName($abbPuri)"/>
        <!--
            Ignoring: (a) Motivation elements, (b) Conceptual elements, (c) Metamodel elements.
        -->
        <xsl:value-of select="
            matches($abb/@xsi:type, '(Principle|Goal|Requirement|Assessment|Grouping)') or
            matches($abbName, '(Interoperable European Solution|Interoperable European Solution Component|Architecture Building Block|EIF Interoperability Level|EIRA Architecture Building Block|EIRA Solution Building Block|EIRA View|EIRA Viewpoint|Key Interoperability Enabler|Public Service Component|Public Service Manifestation|Solution|Solution Building Block|Interoperability Dimension|Digital Solution|Digital Solution Service|Digital Solution Component|Digital Service Infrastructure)')
        "/>
    </xsl:function>

    <xsl:function name="eira:isSbbToIgnore" as="xs:boolean">
        <xsl:param name="sbbPuri"/>
        <xsl:param name="sbbName"/>
        <xsl:value-of select="eira:isAbbToIgnore($sbbPuri, $sbbName)"/>
    </xsl:function>

    <xsl:function name="eira:isSbb" as="xs:boolean">
        <xsl:param name="elementName"/>
        <!--<xsl:value-of select="matches(string($elementName), '&lt;&lt;[ \t]*eira:.+[ \t]*&gt;&gt;.+')"/>-->
        <xsl:value-of select="exists($eiraDoc/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string($eiraDoc/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock'] and a:name = string($elementName)])"/>
    </xsl:function>

    <xsl:function name="eira:isAbb" as="xs:boolean">
        <xsl:param name="elementName"/>
        <!--<xsl:value-of select="let $name := string($elementName) return exists($eiraDoc/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string($eiraDoc/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier)] and string(a:name) = $name])"/>-->
        <xsl:value-of select="exists($eiraDoc/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string($eiraDoc/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and a:name = string($elementName)])"/>
    </xsl:function>    

    <xsl:function name="eira:isLeafAbbInEira" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:value-of select="let $name := string($element/a:name) return exists($eiraDoc/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string($eiraDoc/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and string(a:name) = $name and (let $elementId := string(@identifier) return not(exists($eiraDoc/a:model/a:relationships/a:relationship[string(@target) = $elementId and @xsi:type = 'Specialization'])))])"/>
    </xsl:function>

    <xsl:function name="eira:getSpecialisedElements" as="element()*">
        <xsl:param name="element"/>
        <xsl:copy-of select="
        $doc/a:model/a:elements/a:element[
            (
                let $otherElementIdentifier := @identifier return (
                    $doc/a:model/a:relationships/a:relationship[
                        @source = $element/@identifier and @target = $otherElementIdentifier and (@xsi:type = 'Specialization' or @xsi:type = 'Realization')
                    ]
                )
            )
        ]
        "/>
    </xsl:function>

    <xsl:function name="eira:isSpecialisedByOtherAbb" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:value-of select="
        let $elementId := string($element/@identifier) return exists(
            $doc/a:model/a:relationships/a:relationship[
                string(@target) = $elementId and (@xsi:type = 'Specialization' or @xsi:type = 'Realization')
                and eira:isAbb(eira:elementById(string(@source))/a:name)
            ]
        )"/>
    </xsl:function>

    <xsl:function name="eira:concatenate" as="xs:string">
        <xsl:param name="elements"/>
        <xsl:param name="separator"/>
        <xsl:variable name="result">
            <xsl:for-each select="$elements">
                <xsl:value-of select="concat(string(.), $separator)"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="substring($result, 0, string-length($result) + 1 - string-length($separator))"/>
    </xsl:function>

    <xsl:function name="eira:elementById" as="element()">
        <xsl:param name="elementId"/>
        <xsl:copy-of select="$doc/a:model/a:elements/a:element[@identifier = $elementId]"/>
    </xsl:function>

    <xsl:function name="eira:abbById" as="element()">
        <xsl:param name="elementId"/>
        <xsl:copy-of select="$eiraDoc/a:model/a:elements/a:element[@identifier = $elementId]"/>
    </xsl:function>

    <xsl:function name="eira:abbByName" as="element()">
        <xsl:param name="abbPuri"/>
        <xsl:copy-of select="$eiraDoc/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string($eiraDoc/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier) and a:value = $abbPuri]]"/>
    </xsl:function>

    <xsl:function name="eira:getPuri" as="xs:string">
        <xsl:param name="element"/>
        <xsl:copy-of select="$element/a:properties/a:property[@propertyDefinitionRef = string($eiraDoc/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value"/>
    </xsl:function>

    <xsl:function name="eira:abbHasChildren" as="xs:boolean">
        <xsl:param name="abbName"/>
        <xsl:variable name="elementId" select="eira:abbIdForName($abbName)"/>
        <xsl:value-of select="exists($eiraDoc/a:model/a:relationships/a:relationship[@target = $elementId and @xsi:type = 'Specialization'])"/>
    </xsl:function>

    <xsl:function name="eira:childrenAbbs" as="xs:string">
        <xsl:param name="abbName"/>
        <xsl:param name="separator"/>
        <xsl:variable name="tempAbbString" select="eira:childrenAbbsInternal($abbName, $separator)"/>
        <!-- 
            Remove the last element from the string (this will always be the original ABB). We do this to make sure that the string 
            contains only pure child ABBs.
        -->
        <xsl:choose>
            <xsl:when test="$abbName = $tempAbbString">
                <!-- No children (only the original ABB). Return an empty string. -->
                <xsl:text/>
            </xsl:when>
            <xsl:otherwise>
                <!-- Remove the original ABB's name from the string. -->
                <xsl:value-of select="substring($tempAbbString, 0, string-length($tempAbbString)+1 - (2*string-length($separator) + string-length($abbName)))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="eira:abbIdForName" as="xs:string">
        <xsl:param name="abbName"/>
        <xsl:value-of select="$eiraDoc/a:model/a:elements/a:element[a:name = $abbName]/@identifier"/>
    </xsl:function>

    <xsl:function name="eira:childrenAbbsInternal" as="xs:string">
        <xsl:param name="abbName"/>
        <xsl:param name="separator"/>
        <xsl:variable name="elementId" select="eira:abbIdForName($abbName)"/>
        <xsl:variable name="children" select="
$eiraDoc/a:model/a:elements/a:element[
    let $currentElementId := @identifier return (
        $eiraDoc/a:model/a:relationships/a:relationship[@target = $elementId and @source = $currentElementId and @xsi:type = 'Specialization']
    )
]
        "/>
        <xsl:variable name="result">
            <xsl:if test="count($children) > 0">
                <xsl:for-each select="$children">
                    <xsl:value-of select="eira:childrenAbbsInternal(./a:name, $separator)"/>
                </xsl:for-each>
            </xsl:if>
            <xsl:value-of select="concat($abbName, $separator)"/>
        </xsl:variable>
        <xsl:value-of select="$result"/>
    </xsl:function>

    <xsl:function name="eira:abbHasEquivalents" as="xs:boolean">
        <xsl:param name="abb"/>
        <xsl:value-of select="($abb/@xsi:type = 'ApplicationComponent' and ends-with($abb/a:name, ' Component')) or ($abb/@xsi:type = 'ApplicationService' and ends-with($abb/a:name, ' Service'))"/>
    </xsl:function>

    <xsl:function name="eira:mostSpecificAbbs" as="element()*">
        <xsl:param name="element"/>
        <!-- <xsl:message>CALLED WITH [<xsl:value-of select="$element/a:name"/>]</xsl:message> -->
        <xsl:variable name="elementIdentifier" select="$element/@identifier"/>
        <xsl:variable name="foundElements" select="
$doc/a:model/a:elements/a:element[
    let $otherElementIdentifier := @identifier return (
        $doc/a:model/a:relationships/a:relationship[
            (@xsi:type = 'Specialization' and $elementIdentifier = @target and $otherElementIdentifier = @source and eira:isAbb(eira:elementById(string(@source))/a:name))
            or (@xsi:type = 'Realization' and $elementIdentifier = @target and $otherElementIdentifier = @source and eira:isAbb(eira:elementById(string(@source))/a:name))
        ]    
    )
]
        "/>
<!-- 
     It is not always certain whether an element that is composed of or aggregates other ABBs can be considered as 
     a purely grouping mechanism. As such it is safer to not follow the composition and aggregation relations.

     or (@xsi:type = 'Composition') and ($elementIdentifier = @source and $otherElementIdentifier = @target)
     or (@xsi:type = 'Aggregation') and ($elementIdentifier = @source and $otherElementIdentifier = @target) -->

        <xsl:variable name="result" as="element()*">
            <xsl:choose>
                <xsl:when test="count($foundElements) > 0">
                    <!-- <xsl:message>FOUND MANY</xsl:message> -->
                    <xsl:for-each select="$foundElements">
                        <xsl:copy-of select="eira:mostSpecificAbbs(.)"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="eira:isAbb($element/a:name)">
                            <!-- <xsl:message>IS ABB</xsl:message> -->
                            <xsl:copy-of select="$element"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- <xsl:message>OTHERWISE</xsl:message> -->
                            <xsl:if test="not(eira:isSbb($element/a:name))">
                                <!-- <xsl:message>NOT SBB</xsl:message> -->
                                <xsl:variable name="specialisedElements" select="eira:getSpecialisedElements($element)"/>
                                <xsl:for-each select="$specialisedElements">
                                    <xsl:copy-of select="eira:mostSpecificAbbs(.)"/>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:copy-of select="$result"/>
    </xsl:function>

    <xsl:function name="eira:abbsAssociatedToSpecification" as="element()*">
        <xsl:param name="specIdentifier"/>
        <xsl:variable name="abbsLinkedToSpec" select="
            $doc/a:model/a:elements/a:element[
                (
                    let $elementIdentifier := @identifier return (
                        $doc/a:model/a:relationships/a:relationship[
                            @xsi:type = 'Association' and
                            (($specIdentifier = @target and $elementIdentifier = @source) or ($specIdentifier = @source and $elementIdentifier = @target))
                        ]
                    )
                )
            ]
        "/>
        <!-- <xsl:message>      FOUND <xsl:value-of select="count($abbsLinkedToSpec)"/></xsl:message> -->
        <xsl:copy-of select="eira:mostSpecificAbbs($abbsLinkedToSpec)"/>
    </xsl:function>

    <xsl:function name="eira:relatedAbbs" as="xs:string">
        <xsl:param name="abbIdentifier"/>
        <xsl:param name="asSource"/>
        <xsl:param name="relationshipType"/>
        <xsl:param name="separator"/>
        <xsl:value-of select="
        eira:concatenate(
            $eiraDoc/a:model/a:elements/a:element[
                let $elementIdentifier := @identifier return (
                    $eiraDoc/a:model/a:relationships/a:relationship[
                        ($asSource and @source = $abbIdentifier and @target = $elementIdentifier and @xsi:type = $relationshipType) or
                        (not($asSource) and @target = $abbIdentifier and @source = $elementIdentifier and @xsi:type = $relationshipType)
                    ]
                )
            ]/a:name
            , $separator)
        "/>
    </xsl:function>

    <xsl:function name="eira:equivalentAbbs" as="xs:string">
        <xsl:param name="abbPuri"/>
        <xsl:param name="separator"/>
        <xsl:variable name="abb" select="eira:abbByName($abbPuri)"/>
        <xsl:choose>
            <xsl:when test="ends-with($abb/a:name, ' Service')">
                <xsl:value-of select="eira:relatedAbbs($abb/@identifier, false(), 'Realization', $separator)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="eira:relatedAbbs($abb/@identifier, true(), 'Realization', $separator)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>



    <xsl:function name="eira:findSpecificationElementsInHierarchy" as="element()*">
        <xsl:param name="element"/>
        <xsl:variable name="elementIdentifier" select="$element/@identifier"/>
        <xsl:variable name="foundElements" select="
$doc/a:model/a:elements/a:element[
    let $otherElementIdentifier := @identifier return (
        $doc/a:model/a:relationships/a:relationship[
            (@xsi:type = 'Specialization') and ($elementIdentifier = @source and $otherElementIdentifier = @target)
            or (@xsi:type = 'Aggregation') and ($elementIdentifier = @target and $otherElementIdentifier = @source)
            or (@xsi:type = 'Composition') and ($elementIdentifier = @target and $otherElementIdentifier = @source)
        ]    
    )
]
        "/>
        <xsl:variable name="result" as="element()*">
            <xsl:if test="count($foundElements) > 0">
                <xsl:for-each select="$foundElements">
                    <xsl:copy-of select="eira:findSpecificationElementsInHierarchy(.)"/>
                </xsl:for-each>
            </xsl:if>
            <xsl:copy-of select="$element"/>                
        </xsl:variable>
        <xsl:copy-of select="$result"/>
    </xsl:function>

    <xsl:function name="eira:distinctElements" as="element()*">
        <xsl:param name="elements"/>
        <xsl:variable name="distinctIds" select="distinct-values(string($elements/@identifier))"/>
        <xsl:copy-of select="for $i in distinct-values($elements/@identifier) return ($elements[@identifier = $i])[1]"/>
    </xsl:function>

    <xsl:function name="eira:sbbsLinkedToSpecification" as="element()*">
        <xsl:param name="element"/>
        <xsl:param name="elementsToCheck"/>
        <xsl:variable name="foundSbbs" as="element()*">
            <xsl:for-each select="$elementsToCheck">
                <xsl:variable name="elementToCheck" select="current()"/>
                <xsl:variable name="specIdentifier" select="$elementToCheck/@identifier"/>
                <xsl:copy-of select="
                $doc/a:model/a:elements/a:element[
                    (
                        let $elementIdentifier := @identifier return (
                            $doc/a:model/a:relationships/a:relationship[
                                @xsi:type = 'Association' 
                                and (($specIdentifier = @target and $elementIdentifier = @source) or ($specIdentifier = @source and $elementIdentifier = @target))
                                and (
                                    let $referedElement := eira:elementById($elementIdentifier) return (
                                        eira:isSbb($referedElement/a:name) and not(eira:isSbbToIgnore(eira:getPuri($referedElement), $referedElement/a:name))
                                    )
                                )
                            ]
                        )
                    )
                ]
                "/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:copy-of select="$foundSbbs"/>
    </xsl:function>

    <xsl:function name="eira:abbsLinkedToSpecification" as="element()*">
        <xsl:param name="element"/>
        <xsl:param name="elementsToCheck"/>
        <xsl:variable name="result" as="element()*">
            <!-- <xsl:message>START PROCESSING: [<xsl:value-of select="eira:sbbFromStereotypedName($element/a:name)"/>]</xsl:message> -->
            <xsl:variable name="foundAbbs" as="element()*">
                <xsl:for-each select="$elementsToCheck">
                    <!-- <xsl:message>   CHECKING [<xsl:value-of select="current()/a:name"/>]</xsl:message> -->
                    <xsl:variable name="elementToCheck" select="current()"/>
                    <xsl:variable name="associatedAbbs" as="element()*">
                        <xsl:for-each select="eira:abbsAssociatedToSpecification($elementToCheck/@identifier)">
                            <!-- <xsl:message>   ABB [<xsl:value-of select="current()/a:name"/>]</xsl:message> -->
                            <xsl:copy-of select="current()"/>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:copy-of select="$associatedAbbs"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="distinctAbbs" select="eira:distinctElements($foundAbbs)"/>
            <!-- <xsl:for-each select="$distinctAbbs">
                <xsl:message>   LINKED TO [<xsl:value-of select="current()/a:name"/>]</xsl:message>
            </xsl:for-each> -->
            <xsl:copy-of select="$distinctAbbs"/>
        </xsl:variable>
        <xsl:copy-of select="$result"/>
    </xsl:function>

    <xsl:function name="eira:isSpecification" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:value-of select="
            eira:isSbb($element/a:name) and matches(eira:abbFromStereotypedName($element/a:name), concat('(',$iopSpecificationAbbs, ')'))
        "/>
    </xsl:function>

    <xsl:function name="eira:isSpecificationAbb" as="xs:boolean">
        <xsl:param name="element"/>
        <xsl:value-of select="
            matches($element/a:name, concat('(',$iopSpecificationAbbs, ')'))
        "/>
    </xsl:function>

    <!-- <xsl:function name="eira:allAbbEquivalentsAndChildren" as="xs:string">
        <xsl:param name="abb"/>
        <xsl:param name="type"/>
        <xsl:param name="separator"/>
        <xsl:variable name="abbHasChildren" select="eira:abbHasChildren($abb/a:name)"/>
        <xsl:variable name="allowedAbbNames" select="
            if ($abbHasChildren) then
                tokenize(concat($abb/a:name, $separator, eira:childrenAbbs($abb/a:name, $separator)), concat('\', $separator))
            else
                $abb/a:name
        "/>
        <xsl:variable name="allowedAbbNamesWithEquivalents">
            <xsl:for-each select="$allowedAbbNames">
                <xsl:variable name="abbName" select="current()"/>
                <xsl:variable name="type" select="eira:findAbbType($abbName)"/>
                <xsl:value-of select="
                    if (eira:abbHasEquivalents(eira:abbByName($abbName, $type))) then
                        concat($abbName, $separator, eira:equivalentAbbs($abbName, $type, $separator), $separator)
                    else
                        concat($abbName, $separator)
                "/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="allowedAbbNamesWithEquivalents">
            <xsl:value-of select="if (ends-with($allowedAbbNamesWithEquivalents, $separator)) then substring($allowedAbbNamesWithEquivalents, 0, string-length($allowedAbbNamesWithEquivalents) + 1 - string-length($separator)) else $allowedAbbNamesWithEquivalents"/>
        </xsl:variable>
        <xsl:value-of select="$allowedAbbNamesWithEquivalents"/>
    </xsl:function> -->

    <xsl:function name="eira:sanitizeForQuery" as="xs:string">
        <xsl:param name="value"/>
        <xsl:value-of select="replace(normalize-space($value), '''', '''''')"/>
    </xsl:function>

    <xsl:function name="eira:tokenStringToOr" as="xs:string">
        <xsl:param name="value"/>
        <xsl:param name="separator"/>
        <xsl:param name="leftSideToken"/>
        <xsl:variable name="tokensAsOr">
            <xsl:for-each select="tokenize($value, concat('\', $separator))">
                <xsl:value-of select="concat($leftSideToken, ' = ''', replace(normalize-space(current()), '''', ''''''), ''' or ')"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="substring($tokensAsOr, 0, string-length($tokensAsOr) - 3)"/>
    </xsl:function>

    <xsl:template match="/">
        <!-- <xsl:message>RUNNING XSLT</xsl:message> -->
        <xsl:variable name="satName" select="/a:model/a:name[1]"/>
        <schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
            <title>SAT conformance for solutions</title>
            <ns prefix="a" uri="http://www.opengroup.org/xsd/archimate/3.0/"/>
            <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
            <phase id="Step.01">
                <active pattern="Step.01"/>
            </phase>
            <pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="Step.01">
                <rule context="/a:model">
                    <!-- Add an always successful assertion to avoid an invalid schematron if empty. -->
                    <assert id="EIRA-000" test="true()">Empty SAT</assert>
                    <!-- Predefined SBBs -->
                    <xsl:for-each select="/a:model/a:elements/a:element[eira:isSbb(a:name) and not(eira:isSbbToIgnore(eira:getPuri(.), a:name)) and not(eira:isSpecification(.))]">
                        <!-- <xsl:variable name="acceptedAbbs" select="eira:allAbbEquivalentsAndChildren(eira:abbByName(eira:abbFromStereotypedName(current()/a:name), current()/@xsi:type), current()/@xsi:type, '|')"/> -->
                        <xsl:variable name="sbbName" select="eira:sbbFromStereotypedName(current()/a:name)"/>
                        <xsl:variable name="sbbPuri" select="eira:getPuri(current())"/>
                        <xsl:variable name="ruleId" select="'EIRA-038'"/>
                        <!-- <assert id="{$ruleId}" test="exists(a:elements/a:element[let $abbName := string(a:name) return (let $sbbName := string(a:name) return ($sbbName = '{eira:sanitizeForQuery($sbbName)}' and ({eira:tokenStringToOr($acceptedAbbs, '|', '$abbName')})))])">[<xsl:value-of select="$ruleId"/>] [<xsl:value-of select="$satName"/>] SBB '<xsl:value-of select="eira:sbbFromStereotypedName(current()/a:name)"/>' for ABB '<xsl:value-of select="eira:abbFromStereotypedName(current()/a:name)"/>' is expected and must be included in the solution.</assert> -->
                        <assert id="{$ruleId}" test="exists(a:elements/a:element[let $abbName := string(a:name) return (let $sbbName := string(a:name) return ($sbbName = '{eira:sanitizeForQuery($sbbName)}'))])">[<xsl:value-of select="$ruleId"/>] [<xsl:value-of select="$satName"/>] SBB '<xsl:value-of select="eira:sbbFromStereotypedName(current()/a:name)"/>' for ABB '<xsl:value-of select="eira:abbFromStereotypedName(current()/a:name)"/>' is expected and must be included in the solution.</assert>
<!--
exists(
    a:elements/a:element[
        let $abbName := normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '&gt;&gt;')), 'eira:')) return (
            let $sbbName := normalize-space(substring-after(normalize-space(string(a:name)), '&gt;&gt;')) return (
                $sbbName = '{eira:sanitizeForQuery($sbbName)}'
                and ({eira:tokenStringToOr($acceptedAbbs, '|', '$abbName')})
            )
        )
    ]
)
-->                        
                    </xsl:for-each>
                    <!-- ABBs -->
                    <!-- <xsl:for-each select="/a:model/a:elements/a:element[eira:isAbb(a:name) and not(eira:isAbbToIgnore(a:name)) and not(eira:isSpecialisedByOtherAbb(.))]"> -->
                    <xsl:for-each select="/a:model/a:elements/a:element[eira:isAbb(a:name) and not(eira:isSpecialisedByOtherAbb(.))]">
                        <xsl:variable name="abbName" select="current()/a:name"/>
                        <xsl:variable name="type" select="current()/@xsi:type"/>
                        <!-- <xsl:variable name="acceptedAbbs" select="eira:allAbbEquivalentsAndChildren(eira:abbByName($abbName, $type), $type, '|')"/> -->
                        <!-- <xsl:variable name="acceptedAbbsDisplay" select="replace($acceptedAbbs, '\|', ''', ''')"/> -->
                        <!-- <xsl:variable name="hasMultipleAcceptedAbbs" select="$abbName != $acceptedAbbs"/> -->
                        <xsl:variable name="ruleId" select="'EIRA-039'"/>
                        <xsl:variable name="assertionMessage" select="concat('[', $ruleId, '] [', $satName,'] An ABB ''', $abbName, ''' is defined that is not addressed in the solution. The solution must include an SBB for this ABB.')"/>
                            <!-- <xsl:choose> -->
                                <!-- <xsl:when test="$hasMultipleAcceptedAbbs">
                                    <xsl:value-of select="concat('[', $ruleId, '] [', $satName,'] An ABB ''', $abbName, ''' is defined that is not addressed in the solution. The solution must include an SBB for an appropriate ABB (''', $acceptedAbbsDisplay, ''').')"/>
                                </xsl:when> -->
                                <!-- <xsl:otherwise>
                                    <xsl:value-of select="concat('[', $ruleId, '] [', $satName,'] An ABB ''', $abbName, ''' is defined that is not addressed in the solution. The solution must include an SBB for this ABB.')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable> -->
                        <!-- <assert id="{$ruleId}" test="exists(a:elements/a:element[let $abbName := string(a:name) return ({eira:tokenStringToOr($acceptedAbbs, '|', '$abbName')})])"><xsl:value-of select="$assertionMessage"/></assert> -->
                        <assert id="{$ruleId}" test="exists(a:elements/a:element[let $abbName := string(a:name) return ({eira:tokenStringToOr($abbName, '|', '$abbName')})])"><xsl:value-of select="$assertionMessage"/></assert>
<!--
exists(
    a:elements/a:element[
        let $abbName := normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '&gt;&gt;')), 'eira:')) return (
            {eira:tokenStringToOr($acceptedAbbs, '|', '$abbName')}
        )
    ]
)
-->                                
                    </xsl:for-each>
                    <!-- IoP specifications -->
                    <xsl:for-each select="/a:model/a:elements/a:element[eira:isSpecification(.)]">
                        <xsl:variable name="specSbb" select="current()"/>
                        <xsl:variable name="specSbbName" select="eira:sbbFromStereotypedName($specSbb/a:name)"/>
                        <xsl:variable name="specAbb" select="eira:abbByName(eira:getPuri(current()))"/>
                        <xsl:variable name="specificationElementsInHierarchy" select="eira:findSpecificationElementsInHierarchy($specSbb)"/>
                        <xsl:variable name="abbsLinkedToSpecification" select="eira:abbsLinkedToSpecification($specSbb, $specificationElementsInHierarchy)"/>
                        <xsl:variable name="sbbsLinkedToSpecification" select="eira:sbbsLinkedToSpecification($specSbb, $specificationElementsInHierarchy)"/>
                        <!-- IoP specifications linked to ABBs -->
                        <xsl:for-each select="$abbsLinkedToSpecification">
                            <xsl:variable name="abb" select="current()"/>
                            <!-- <xsl:variable name="allAcceptedAbbs" select="eira:allAbbEquivalentsAndChildren($abb, $type, '|')"/> -->
                            <!-- <xsl:variable name="allAcceptedSpecs" select="eira:allAbbEquivalentsAndChildren($specAbb, $type, '|')"/> -->
                            <!-- <xsl:variable name="multipleAcceptedSpecs" select="$specAbb/a:name != $allAcceptedSpecs"/> -->
                            <!-- <xsl:variable name="multipleAcceptedAbbs" select="$abb/a:name != $allAcceptedAbbs"/> -->
                            <!-- <xsl:variable name="allAcceptedAbbsDisplay" select="replace($allAcceptedAbbs, '\|', ''', ''')"/> -->
                            <xsl:variable name="ruleId" select="'EIRA-040'"/>
                            <xsl:variable name="assertionMessage" select="concat('[', $ruleId, '] [', $satName, '] Specification ''', $specSbbName, ''' is defined for ABB ''', $abb/a:name, ''' that is not addressed in the solution. The solution must include an SBB for ABB ''', $abb/a:name, ''' associated to this specification.')"/>
                                <!-- <xsl:choose> -->
                                    <!-- <xsl:when test="$multipleAcceptedAbbs and $multipleAcceptedSpecs">
                                        <xsl:value-of select="concat('[', $ruleId, '] [', $satName, '] Specification ''', $specSbbName, ''' is defined for ABB ''', $abb/a:name, ''' that is not addressed in the solution. The solution must include an SBB for an appropriate ABB (''', $allAcceptedAbbsDisplay, ''') associated to this specification.')"/>
                                    </xsl:when>
                                    <xsl:when test="$multipleAcceptedAbbs and not($multipleAcceptedSpecs)">
                                        <xsl:value-of select="concat('[', $ruleId, '] [', $satName, '] Specification ''', $specSbbName, ''' is defined for ABB ''', $abb/a:name, ''' that is not addressed in the solution. The solution must include an SBB for an appropriate ABB (''', $allAcceptedAbbsDisplay, ''') associated to this specification.')"/>
                                    </xsl:when>
                                    <xsl:when test="not($multipleAcceptedAbbs) and $multipleAcceptedSpecs">
                                        <xsl:value-of select="concat('[', $ruleId, '] [', $satName, '] Specification ''', $specSbbName, ''' is defined for ABB ''', $abb/a:name, ''' that is not addressed in the solution. The solution must include an SBB for ABB ''', $allAcceptedAbbsDisplay, ''' associated to this specification.')"/>
                                    </xsl:when> -->
                                    <!-- <xsl:otherwise>
                                        <xsl:value-of select="concat('[', $ruleId, '] [', $satName, '] Specification ''', $specSbbName, ''' is defined for ABB ''', $abb/a:name, ''' that is not addressed in the solution. The solution must include an SBB for ABB ''', $allAcceptedAbbsDisplay, ''' associated to this specification.')"/>
                                    </xsl:otherwise> -->
                                <!-- </xsl:choose> -->
                            <!-- </xsl:variable> -->
                            <!-- <assert id="{$ruleId}" test="exists(a:elements/a:element[let $elementIdentifier := @identifier return (let $declaredAbbName := string(a:name) return ({eira:tokenStringToOr($allAcceptedAbbs, '|', '$declaredAbbName')}) and exists(/a:model/a:relationships/a:relationship[@xsi:type = 'Association' and (@target = $elementIdentifier or @source = $elementIdentifier) and (let $associatedIdentifier := (if (@target = $elementIdentifier) then @source else @target) return (exists(/a:model/a:elements/a:element[@identifier = $associatedIdentifier and (let $specAbbName := string(a:name) return (let $specSbbName := string(a:name) return ($specSbbName = '{eira:sanitizeForQuery($specSbbName)}' and ({eira:tokenStringToOr($allAcceptedSpecs, '|', '$specAbbName')}))))])))]))])"><xsl:value-of select="$assertionMessage"/></assert> -->
                            <assert id="{$ruleId}" test="exists(a:elements/a:element[let $elementIdentifier := @identifier return (exists(/a:model/a:relationships/a:relationship[@xsi:type = 'Association' and (@target = $elementIdentifier or @source = $elementIdentifier) and (let $associatedIdentifier := (if (@target = $elementIdentifier) then @source else @target) return (exists(/a:model/a:elements/a:element[@identifier = $associatedIdentifier and (let $specAbbName := string(a:name) return (let $specSbbName := string(a:name) return ($specSbbName = '{eira:sanitizeForQuery($specSbbName)}')))])))]))])"><xsl:value-of select="$assertionMessage"/></assert>
<!--
    exists(
        a:elements/a:element[
            let $elementIdentifier := @identifier return (
                let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '&gt;&gt;')), 'eira:') return (
                    {eira:tokenStringToOr($allAcceptedAbbs, '|', '$declaredAbbName')}
                ) and
                exists(
                    /a:model/a:relationships/a:relationship[
                        @xsi:type = 'Association' 
                        and (@target = $elementIdentifier or @source = $elementIdentifier)
                        and (
                            let $associatedIdentifier := (if (@target = $elementIdentifier) then @source else @target) return (
                                exists(
                                    /a:model/a:elements/a:element[
                                        @identifier = $associatedIdentifier
                                        and (
                                            let $specAbbName := normalize-space(substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '&gt;&gt;')), 'eira:')) return (
                                                let $specSbbName := normalize-space(substring-after(normalize-space(string(a:name)), '&gt;&gt;')) return (
                                                    $specSbbName = '{eira:sanitizeForQuery($specSbbName)}'
                                                    and ({eira:tokenStringToOr($allAcceptedSpecs, '|', '$specAbbName')})
                                                )
                                            )
                                        )
                                    ]
                                )
                            )
                        )
                    ]
                )
            )
        ]
    )
-->
                        </xsl:for-each>
                        <!-- IoP specifications linked to SBBs -->
                        <xsl:for-each select="$sbbsLinkedToSpecification">
                            <xsl:variable name="sbbLinkedToSpecification" select="current()"/>
                            <xsl:variable name="expectedSbbName" select="eira:sbbFromStereotypedName(current()/a:name)"/>
                            <xsl:variable name="expectedSbbType" select="eira:abbFromStereotypedName(current()/a:name)"/>
                            <xsl:variable name="ruleId" select="'EIRA-041'"/>
                            <assert id="{$ruleId}" test="exists(a:elements/a:element[a:name = '{eira:sanitizeForQuery($sbbLinkedToSpecification/a:name)}' and (let $sbbIdentifier := @identifier return (let $specIdentifier := (/a:model/a:elements/a:element[./a:name = '{eira:sanitizeForQuery($specSbb/a:name)}']/@identifier) return (exists(/a:model/a:relationships/a:relationship[@xsi:type = 'Association' and ((@target = $sbbIdentifier or @source = $specIdentifier)or (@source = $sbbIdentifier or @target = $specIdentifier))]))))])">[<xsl:value-of select="$ruleId"/>] [<xsl:value-of select="$satName"/>] Specification '<xsl:value-of select="$specSbbName"/>' is not associated to the expected SBB '<xsl:value-of select="$expectedSbbName"/>' of type '<xsl:value-of select="$expectedSbbType"/>'.</assert>
<!--
exists(
    a:elements/a:element[
        a:name = '{eira:sanitizeForQuery($sbbLinkedToSpecification/a:name)}'
        and (
            let $sbbIdentifier := @identifier return (
                let $specIdentifier := (/a:model/a:elements/a:element[./a:name = '{eira:sanitizeForQuery($specSbb/a:name)}']/@identifier) return (
                    exists(
                        /a:model/a:relationships/a:relationship[
                            @xsi:type = 'Association' 
                            and (
                                (@target = $sbbIdentifier or @source = $specIdentifier)
                                or (@source = $sbbIdentifier or @target = $specIdentifier)
                            )
                        ]
                    )
                )
            )
        )
    ]
)
-->                             
                        </xsl:for-each>
                        <!-- IoP specifications without ABB or SBB links -->
                        <xsl:if test="not(exists($abbsLinkedToSpecification)) and not(exists($sbbsLinkedToSpecification))">
                            <!-- <xsl:variable name="acceptedAbbs" select="eira:allAbbEquivalentsAndChildren(eira:abbByName(eira:abbFromStereotypedName(current()/a:name), current()/@xsi:type), current()/@xsi:type, '|')"/> -->
                            <xsl:variable name="sbbName" select="eira:sbbFromStereotypedName(current()/a:name)"/>
                            <xsl:variable name="ruleId" select="'EIRA-042'"/>
                            <!-- <assert id="{$ruleId}" test="exists(a:elements/a:element[let $abbName := string(a:name) return (let $sbbName := string(a:name) return ($sbbName = '{eira:sanitizeForQuery($sbbName)}' and ({eira:tokenStringToOr($acceptedAbbs, '|', '$abbName')})))])">[<xsl:value-of select="$ruleId"/>] [<xsl:value-of select="$satName"/>] Specification '<xsl:value-of select="eira:sbbFromStereotypedName(current()/a:name)"/>' of type '<xsl:value-of select="eira:abbFromStereotypedName(current()/a:name)"/>' is expected and must be included in the solution.</assert> -->
                            <assert id="{$ruleId}" test="exists(a:elements/a:element[let $abbName := string(a:name) return (let $sbbName := string(a:name) return ($sbbName = '{eira:sanitizeForQuery($sbbName)}'))])">[<xsl:value-of select="$ruleId"/>] [<xsl:value-of select="$satName"/>] Specification '<xsl:value-of select="eira:sbbFromStereotypedName(current()/a:name)"/>' of type '<xsl:value-of select="eira:abbFromStereotypedName(current()/a:name)"/>' is expected and must be included in the solution.</assert>
                        </xsl:if>
                    </xsl:for-each>
                </rule>
            </pattern>
        </schema>        
    </xsl:template>
</xsl:stylesheet>