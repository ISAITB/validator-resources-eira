<pattern xmlns="http://purl.oclc.org/dsdl/schematron" is-a="Step.02" id="MEF-Step.02">
	<!-- Tests -->
	<param name="EIRA-011" value="let $viewName := a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:view']/@identifier]/a:value return ($viewName = 'Legal view')"/>
	<param name="EIRA-012" value="let $viewName := a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:view']/@identifier]/a:value return ($viewName = 'Organisational view')"/>
	<param name="EIRA-013" value="let $viewName := a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:view']/@identifier]/a:value return ($viewName = 'Semantic view')"/>
	<param name="EIRA-014" value="let $viewName := a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:view']/@identifier]/a:value return ($viewName = 'Technical view - application')"/>
	<param name="EIRA-015" value="let $viewName := a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:view']/@identifier]/a:value return ($viewName = 'Technical view - infrastructure')"/>
	<param name="EIRA-017" value="let $viewName := a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:view']/@identifier]/a:value return ($viewName = 'Technical view - application' or $viewName = 'Technical view - infrastructure')"/>

	<param name="SBBDeclaredABB" value="a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:ABB']/@identifier]/a:value"/>
	<!-- Contexts -->
	<param name="SBB" value="/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:concept']/@identifier and a:value = 'eira:SolutionBuildingBlock']]"/>
	
	<!-- Parameters -->
	<param name="ElementName" value="a:name"/>
	<param name="EIRAABB" value="document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $EIRAPropertyDefinitions[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']]"/>
	<param name="PropertyDefinitions" value="/a:model/a:propertyDefinitions/a:propertyDefinition"/>
	<param name="EIRAPropertyDefinitions" value="document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition"/>
</pattern>
