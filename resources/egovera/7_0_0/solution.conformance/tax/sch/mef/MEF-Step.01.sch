<pattern xmlns="http://purl.oclc.org/dsdl/schematron" is-a="Step.01" id="MEF-Step.01">
	<!-- Tests -->
	<param name="eGovERA-009" value="let $abbPURI := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value return (let $abb := document('egovera/eGovERA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('egovera/eGovERA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock']] return $abb/a:properties/a:property[@propertyDefinitionRef = string(document('egovera/eGovERA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:PURI']/@identifier)]/a:value = $abbPURI)"/>

	<param name="eGovERA-010" value="let $sbbReferencesAbb := a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier)]/a:value return (let $abb := document('egovera/eGovERA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('egovera/eGovERA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock']] return exists($abb/a:properties/a:property[@propertyDefinitionRef = string(document('egovera/eGovERA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and a:value = $sbbReferencesAbb]))"/>

	<!-- Parameters -->
	<param name="ABBName" value="string(a:name)"/>
	<param name="SBBName" value="string(a:name)"/>
	<param name="SBBDeclaredABBName" value="a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:ABB']/@identifier)]/a:value"/>

	<!-- Contexts -->
	<param name="ArchitectureBuildingBlock" value="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock']]"/>
	<param name="SolutionBuildingBlock" value="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:SolutionBuildingBlock']]"/>
</pattern>