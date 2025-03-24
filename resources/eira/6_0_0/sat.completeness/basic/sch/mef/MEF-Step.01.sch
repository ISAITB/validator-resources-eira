<pattern xmlns="http://purl.oclc.org/dsdl/schematron" is-a="Step.01" id="MEF-Step.01">
	<!-- Tests -->
	<param name="EIRA-001-01" value="(a:views/a:diagrams/a:view[./a:name = 'Legal view'])/count(.) = 1"/>
	<param name="EIRA-001-02" value="(a:views/a:diagrams/a:view[./a:name = 'Organisational view'])/count(.) = 1"/>
	<param name="EIRA-001-03" value="(a:views/a:diagrams/a:view[./a:name = 'Semantic view'])/count(.) = 1"/>
	<param name="EIRA-001-04" value="(a:views/a:diagrams/a:view[./a:name = 'Technical view - application'])/count(.) = 1"/>
	<param name="EIRA-001-05" value="(a:views/a:diagrams/a:view[./a:name = 'Technical view - infrastructure'])/count(.) = 1"/>

	<param name="EIRA-021" value="exists(a:elements/a:element[matches(string(a:name), 'Interoperability Aspect')])"/>
	<param name="EIRA-022" value="exists(a:elements/a:element[matches(string(a:name), 'Interoperability Requirement|Legal Interoperability Requirement|Organisational Interoperability Requirement|Semantic Interoperability Requirement|Technical Interoperability Requirement')])"/>
	<param name="EIRA-023" value="exists(a:elements/a:element[matches(string(a:name), 'Machine to Machine Interface|Human Interface')])"/>
	<param name="EIRA-024-01" value="exists(a:elements/a:element[matches(string(a:name), 'Legislation Catalogue')])"/>
	<param name="EIRA-024-02" value="exists(a:elements/a:element[matches(string(a:name), 'Public Service Catalogue')])"/>
	<param name="EIRA-024-03" value="exists(a:elements/a:element[matches(string(a:name), 'Data Set Catalogue')])"/>
	<param name="EIRA-024-04" value="exists(a:elements/a:element[matches(string(a:name), 'Ontologies Catalogue')])"/>
	<param name="EIRA-024-05" value="exists(a:elements/a:element[matches(string(a:name), 'Service Registry')])"/>
	<param name="EIRA-024-06" value="exists(a:elements/a:element[matches(string(a:name), 'API Catalogue')])"/>
	<param name="EIRA-024-07" value="exists(a:elements/a:element[matches(string(a:name), 'Legislation on Data Information and Knowledge Exchange')])"/>
	<param name="EIRA-024-08" value="exists(a:elements/a:element[matches(string(a:name), 'Service Delivery Mode')])"/>
	<param name="EIRA-024-09" value="exists(a:elements/a:element[matches(string(a:name), 'Data mapping')])"/>
	<param name="EIRA-024-10" value="exists(a:elements/a:element[matches(string(a:name), 'Legal Interoperability Agreement')])"/>
	<param name="EIRA-024-11" value="exists(a:elements/a:element[matches(string(a:name), 'Organisational Interoperability Agreement')])"/>
	<param name="EIRA-024-12" value="exists(a:elements/a:element[matches(string(a:name), 'Semantic Interoperability Agreement')])"/>
	<param name="EIRA-024-13" value="exists(a:elements/a:element[matches(string(a:name), 'Technical Interoperability Agreement')])"/>
	
	<param name="EIRA-036" value="exists(a:elements/a:element[matches(string(a:name), 'Interoperability Specification|Legal Interoperability Specification|Organisational Interoperability Specification')])"/>
	
	<param name="EIRA-003" value="every $sbbPuri in a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier]/a:value satisfies (let $elementType := @xsi:type return(let $sbb := $EIRASBB[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier]/a:value = $sbbPuri] return ($sbb/@xsi:type = $elementType or not(exists($sbb)))))"/>
	<param name="EIRA-004" value="let $sbbDeclaredAbbValue := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier)]/a:value return exists($EIRAABB[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier)]/a:value = $sbbDeclaredAbbValue])"/>
	<param name="EIRA-005" value="exists(a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier)])"/>
	<param name="EIRA-006" value="let $sbbName := string(a:name) return (let $abb := document('eira/EIRA.xml')/a:model/a:elements/a:element[string(a:name) = $sbbName] return (not(exists($abb)) or not(exists($abb/a:properties/a:property[string(./a:value) = 'Obsolete' and string(./@propertyDefinitionRef) = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./a:name) = 'eira:ABB_Status']/@identifier)]))))"/>
	
	<param name="EIRA-008" value="every $abbPuri in a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value satisfies (let $elementType := @xsi:type return(let $abb := $EIRAABB[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value = $abbPuri] return ($abb/@xsi:type = $elementType or not(exists($abb)))))"/>
	<param name="EIRA-037" value="let $abbElementId := ./@identifier return ((some $relationship in (/a:model/a:relationships/a:relationship[string(./@source) = $abbElementId]) satisfies (let $otherElementId := string($relationship/@target) return (exists(/a:model/a:elements/a:element[string(./@identifier) = $otherElementId and matches(string(a:name), 'Interoperability Specification|Legal Interoperability Specification|Organisational Interoperability Specification|Semantic Interoperability Specification|Technical Interoperability Specification')])))) or (some $relationship in (/a:model/a:relationships/a:relationship[string(./@target) = $abbElementId]) satisfies (let $otherElementId := string($relationship/@source) return (exists(/a:model/a:elements/a:element[string(./@identifier) = $otherElementId and matches(string(a:name), 'Interoperability Specification|Legal Interoperability Specification|Organisational Interoperability Specification')])))))"/>
	
	
	<param name="EIRA-025" value="not(matches(string(a:name), 'Interoperability Specification|Legal Interoperability Specification|Organisational Interoperability Specification'))"/>
	<param name="EIRA-026" value="let $declaredAbbName := substring-after(normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '&gt;&gt;')), 'eira:') return matches($declaredAbbName, '(Interoperability Aspect|Interoperability Requirement|Legal Interoperability Requirement|Organisational Interoperability Requirement|Semantic Interoperability Requirement|Technical Interoperability Requirement|Machine to Machine Interface|Human Interface|Public Service Catalogue|Data Set Catalogue|Service Registry Component|Service Delivery Mode|Representation|Organisational Interoperability Agreement|Semantic Interoperability Agreement|Technical Interoperability Agreement)') or exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName and (let $abbElementId := string(@identifier) return exists(document('eira/EIRA.xml')/a:model/a:organizations//a:item[string(a:label) = 'Legal View Concepts']/a:item[string(@identifierRef) = $abbElementId]))])"/>
	<param name="EIRA-027" value="let $abbName := string(a:name) return (if (matches($abbName, 'Interoperability Requirement|Legal Interoperability Requirement|Organisational Interoperability Requirement|Semantic Interoperability Requirement|Technical Interoperability Requirement')) then (let $sbbElementId := ./@identifier return (some $relationship in (/a:model/a:relationships/a:relationship[string(./@xsi:type) = 'Aggregation' and string(./@target) = $sbbElementId]) satisfies (let $parentSbbElementId := string($relationship/@source) return (exists(/a:model/a:elements/a:element[string(./@identifier) = $parentSbbElementId and string(a:name) = 'Interoperability Aspect']))))) else (true()))"/>
	<param name="EIRA-008" value="every $abbPuri in a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value satisfies (let $elementType := @xsi:type return(let $abb := $EIRAABB[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value = $abbPuri] return ($abb/@xsi:type = $elementType or not(exists($abb)))))"/>
	<param name="EIRA-009" value="let $propertyValue := a:value return exists($propertyValue = 'eira:ArchitectureBuildingBlock' or $propertyValue = 'eira:SolutionBuildingBlock')"/>
	<param name="EIRA-010" value="let $pElement := (./../..) return (let $pIdentifier := string(@propertyDefinitionRef) return (let $propertyName := string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $pIdentifier]/a:name) return (let $abbName := string(../../a:name) return (let $abbPropDefinition := (replace(string((document('eira/EIRA.xml')/a:model/a:elements/a:element[string(./a:name) = $abbName]/a:properties/a:property[(let $abbPropId := string(./@propertyDefinitionRef) return (exists(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $abbPropId and string(./a:name) = $propertyName])))]/a:value)[1]), '\-', '~')) return (if (matches($abbPropDefinition, '\[(([\w\d\s\|]+)|([\w\d\s]+))\]\*')) then true() else count($pElement/a:properties/a:property[string(./@propertyDefinitionRef) = $pIdentifier]) = 1)))))"/>
	<param name="EIRA-028" value="let $propValue := normalize-space(string(./a:value)) return (let $propId := string(./@propertyDefinitionRef) return (let $propertyName := string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $propId]/a:name) return (not($propertyName = 'eira:dependencies' and not((lower-case($propValue) = 'none' or lower-case($propValue) = '-' or lower-case($propValue) = ''))) or (let $idPropId := string(/a:model/a:propertyDefinitions/a:propertyDefinition[./a:name = 'ID']/@identifier) return (every $propValueToken in tokenize($propValue, '[,\s]+') satisfies (exists(/a:model/a:elements/a:element[./a:properties/a:property[./@propertyDefinitionRef = $idPropId and normalize-space(./a:value) = normalize-space($propValueToken)] and (let $referencedSbbName := string(a:name) return (matches ($referencedSbbName, 'Interoperability Requirement|Legal Interoperability Requirement|Organisational Interoperability Requirement|Semantic Interoperability Requirement|Technical Interoperability Requirement')))])))))))"/>
	
	<!-- Parameters -->
	
	<!-- Returns the type of the ABB from EIRA:xml -->
	<param name="EIRAABBElementType" value="let $abbPuri := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value return ($EIRAABB[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:Puri']/@identifier)]/a:value = $abbPuri]/@xsi:type)"/>
	
	<!-- Returns the type of the SBB from EIRA:xml -->
	<param name="EIRASBBElementType" value="let $sbbPuri := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value return($EIRASBB[a:properties/a:property[@propertyDefinitionRef = /a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier]/a:value = $sbbPuri]/@xsi:type)"/>
	
	<!--  Returns ABB elements from EIRA:xml -->
	<param name="EIRAABB" value="document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock']]"/>
	
	<!-- Returns SBB elements from EIRA:xml -->
	<param name="EIRASBB" value="document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock']]"/>
	
	<!-- Returns element name -->
	<param name="ABBName" value="a:name"/>
	
	<!-- Returns element name -->
	<param name="SBBName" value="a:name"/>

	<!-- Returns the name of ABB block whose attribute dct:type is the same as eira:ABB of SBB block -->
	<param name="SBBDeclaredABBName" value="let $sbbDeclaredAbb := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier)]/a:value return($ArchitectureBuildingBlock[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier)]/a:value = $sbbDeclaredAbb]/a:name)"/>
	
	<!-- Returns the value of the property eira:ABB -->
	<param name="SBBDeclaredABBValue" value="a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier)]/a:value"/>

	<!-- Returns element Type -->
	<param name="ElementType" value="@xsi:type"/>

	<!-- Returns a list of missing attributes of an element -->
	<param name="MissingSBBAttributeNames" value="let $sbbProperties := a:properties return (let $sbbPropertyDefinitions := /a:model/a:propertyDefinitions return (let $abbName := string(./a:name) return (document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[not(string(./a:name) = 'ID' or string(./a:name) = 'eira:ABB_Status' or string(./a:name) = 'eira:synonym' or string(./a:name) = 'eira:unit_in_DG' or string(./a:name) = 'dct:references' or string(./a:name) = 'eira:reuse_status' or string(./a:name) = 'eira:specific_policy_issue' or string(./a:name) = 'eira:operational_date' or string(./a:name) = 'dct:description' or string(./a:name) = 'eira:policy_area' or string(./a:name) = 'eira:owner' or string(./a:name) = 'eira:description' or string(./a:name) = 'eira:reusability_score' or string(./a:name) = 'eira:data_quality_level' or string(./a:name) = 'eira:data_quality_score' or string(./a:name) = 'eira:iop_level' or string(./a:name) = 'eira:iop_score' or string(./a:name) = 'eira:GovIS_ID' or string(./a:name) = 'eira:IES_category' or string(./a:name) = 'eira:importance_for_the_functioning_of_the_EU' or string(./a:name) = 'eira:actual_use' or string(./a:name) = 'eira:actual_reuse' or string(./a:name) = 'eira:view') and (let $propId := string(./@identifier) return (let $propName := string(./a:name) return (exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[string(./a:name) = $abbName]/a:properties/a:property[string(./@propertyDefinitionRef) = $propId and not(exists($sbbPropertyDefinitions/a:propertyDefinition[(let $modelPropId := string(./@identifier) return exists($sbbProperties/a:property[string(./@propertyDefinitionRef) = $modelPropId and normalize-space(string(./a:value)) != ''])) and string(./a:name) = $propName]))]))))])))/a:name/string(.)"/>

	<!-- Return value property -->
	<param name="SBBPropertyValue" value="a:value"/>

	<!-- Return Returns the name two levels above (element name) -->
	<param name="SBBPropertySBBName" value="string(./../../a:name)"/>
	
	<!-- Return Returns the name two levels above (element name) -->
	<param name="SBBPropertyDeclaredABBName" value="string(./../../a:name)"/>

	<!-- Return property name -->
	<param name="SBBPropertyName" value="let $propId := string(./@propertyDefinitionRef) return (string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $propId]/a:name))"/>

	<!-- Return property name () -->
	<param name="ABBExpectedPropertyValue" value="let $pIdentifier := string(./@propertyDefinitionRef) return (let $propertyName := string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $pIdentifier]/a:name) return (let $abbName := string(./../../a:name) return (string((document('eira/EIRA.xml')/a:model/a:elements/a:element[string(./a:name) = $abbName]/a:properties/a:property[(let $abbPropId := string(./@propertyDefinitionRef) return (exists(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $abbPropId and string(./a:name) = $propertyName])))]/a:value)[1]))))"/>

	<!-- Contexts -->
	<!-- Return de model -->
	<param name="Model" value="/a:model"/>
	
	<!-- Returns elements whose eira:concept property is eira:SolutionBuildingBlock -->
	<param name="SolutionBuildingBlock" value="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock']]"/>
	
	<!-- Returns elements whose eira:concept property is eira:ArchitectureBuildingBlock -->
	<param name="ArchitectureBuildingBlock" value="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock']]"/>	
	
	<!-- Returns all the properties that are also in EIRA.xml -->
	<param name="SBBPropertyDefinedInEIRA" value="/a:model/a:elements/a:element/a:properties/a:property[(let $propId := string(./@propertyDefinitionRef) return (let $propertyName := string(/a:model/a:propertyDefinitions/a:propertyDefinition[string(./@identifier) = $propId]/a:name) return (let $abbName := string(./../../a:name) return (exists(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[string(./a:name) = $propertyName and (let $abbPropId := string(./@identifier) return (exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[string(./a:name) = $abbName]/a:properties/a:property[string(./@propertyDefinitionRef) = $abbPropId])))])))))]"/>
</pattern>
