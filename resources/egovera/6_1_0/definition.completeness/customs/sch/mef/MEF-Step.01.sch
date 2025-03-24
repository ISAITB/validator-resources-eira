<pattern xmlns="http://purl.oclc.org/dsdl/schematron" is-a="Step.01" id="MEF-Step.01">
	<!-- Tests -->
	<param name="eGovERA-001" value="string(a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:modelType']/@identifier)]/a:value) = 'DetailedLevelInteroperabilityRequirementsSolutionArchitectureTemplate'"/>
	<param name="eGovERA-002-01" value="(a:views/a:diagrams/a:view[a:name = 'Legal view'])/count(.) = 1"/>
	<param name="eGovERA-002-02" value="(a:views/a:diagrams/a:view[a:name = 'Organisational view'])/count(.) = 1"/>
	<param name="eGovERA-002-03" value="(a:views/a:diagrams/a:view[a:name = 'Semantic view'])/count(.) = 1"/>
	<param name="eGovERA-002-04" value="(a:views/a:diagrams/a:view[a:name = 'Technical view - application'])/count(.) = 1"/>
	<param name="eGovERA-002-05" value="(a:views/a:diagrams/a:view[a:name = 'Technical view - infrastructure'])/count(.) = 1"/>

	<param name="eGovERA-003" value="let $abbPURI := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value return (let $abb := $EIRAABB return $abb/a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value = $abbPURI)"/>
	<param name="eGovERA-004" value="let $type := @xsi:type, $abbPURI := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value return (let $abb := $EIRAABB return ($abb/@xsi:type = $type and $abb/a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value = $abbPURI))"/>
	<param name="eGovERA-005" value="let $abbType := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier)]/a:value return (let $obsoleteAbb := $ObsoleteEIRAABB return not($obsoleteAbb/a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier)]/a:value = $abbType))"/>
	
	<param name="eGovERA-006" value="exists(a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(a:value, 'egovera:')])"/>

	<param name="eGovERA-007" value="exists(a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier)])"/>
	<param name="eGovERA-008" value="let $sbbReferencesAbb := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier)]/a:value return (let $abb := $ModelABB return exists($abb/a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and a:value = $sbbReferencesAbb]))"/>

	<!-- Parameters -->
	<param name="ModelName" value="string(/a:model/a:name)"/>
	<param name="ABBName" value="string(a:name)"/>
	<param name="ABBElementType" value="string(@xsi:type)"/>
	<param name="ABBPURI" value="string(a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value)"/>
	<param name="SBBName" value="string(a:name)"/>
	<param name="ABBEIRAElementType" value="let $abbPURI := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value return string(let $abb := $EIRAABB return $abb/a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier) and a:value = $abbPURI]/@xsi:type)"/>
	<param name="SBBDeclaredABBName" value="a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier)]/a:value"/>
	<param name="ModelABB" value="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock']]"/>
	<param name="EIRAABB" value="document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock']]"/>
	<param name="ObsoleteEIRAABB" value="document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB_Status']/@identifier) and a:value = 'Obsolete']]"/>

	
	<!-- Contexts -->
	<param name="Model" value="/a:model"/>
	<param name="EIRAArchitectureBuildingBlock" value="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and starts-with(a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier)]/a:value, 'eira:')]"/>
	<param name="eGovERAArchitectureBuildingBlock" value="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock']]"/>
	<param name="SolutionBuildingBlock" value="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock']]"/>
</pattern>