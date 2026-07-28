<pattern xmlns="http://purl.oclc.org/dsdl/schematron" is-a="Step.03" id="MEF-Step.03">
	<!-- Tests -->
	<param name="EIRA-018-01" value="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:ABB']/@identifier and a:value = 'eira:PublicPolicyCourseOfAction'])"/>
	<param name="EIRA-018-02" value="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:ABB']/@identifier and a:value = 'eira:LegalActRequirement'])"/>
	<param name="EIRA-018-03" value="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:ABB']/@identifier and a:value = 'eira:DigitalPublicServiceBusinessService'])"/>
	<param name="EIRA-018-04" value="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:ABB']/@identifier and a:value = 'eira:DigitalPublicServiceProviderBusinessRole'])"/>
	<param name="EIRA-018-05" value="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:ABB']/@identifier and a:value = 'eira:DigitalPublicServiceConsumerBusinessRole'])"/>
	<param name="EIRA-018-06" value="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:ABB']/@identifier and a:value = 'eira:InformationBusinessObject'])"/>
	<param name="EIRA-018-07" value="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:ABB']/@identifier and a:value = 'eira:DataDataObject'])"/>
	<param name="EIRA-018-08" value="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:ABB']/@identifier and a:value = 'eira:DataRepresentationRepresentation'])"/>
	<param name="EIRA-018-09" value="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:ABB']/@identifier and a:value = 'eira:DigitalSolutionApplicationComponent'])"/>
	<param name="EIRA-018-10" value="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:ABB']/@identifier and a:value = 'eira:HostingFacilityFacility'])"/>

	<param name="EIRA-019-01" value="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:ABB']/@identifier and (a:value = 'eira:DataPolicyBusinessObject' or a:value = 'eira:MasterDataPolicyBusinessObject' or a:value = 'eira:OpenDataPolicyBusinessObject' or a:value = 'eira:DataPortabilityPolicyBusinessObject' or a:value = 'eira:SecurityPolicyBusinessObject' or a:value = 'eira:PrivacyPolicyBusinessObject')])"/>
	<param name="EIRA-019-02" value="exists(a:elements/a:element[(@xsi:type = 'CommunicationNetwork' or @xsi:type = 'TechnologyService' or @xsi:type = 'Node') and (let $relatedABB := a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:ABB']/@identifier]/a:value return exists($EIRAABB[a:properties/a:property[@propertyDefinitionRef = $EIRAPropertyDefinitions[a:name = 'dct:type']/@identifier and a:value = $relatedABB]]))])"/>
	<param name="EIRA-019-03" value="exists(a:elements/a:element[@xsi:type = 'ApplicationService' and (let $relatedABB := a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:ABB']/@identifier]/a:value return exists($EIRAABB[a:properties/a:property[@propertyDefinitionRef = $EIRAPropertyDefinitions[a:name = 'dct:type']/@identifier and a:value = $relatedABB]]))])"/>
	<param name="EIRA-019-04" value="exists(a:elements/a:element[@xsi:type = 'ApplicationComponent' and (let $relatedABB := a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:ABB']/@identifier]/a:value return exists($EIRAABB[a:properties/a:property[@propertyDefinitionRef = $EIRAPropertyDefinitions[a:name = 'dct:type']/@identifier and a:value = $relatedABB]]))])"/>

	<param name="EIRA-020-01" value="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:ABB']/@identifier and (a:value = 'eira:DigitalSolutionApplicationComponent' or a:value = 'DigitalSolutionApplicationService')])"/>
	<param name="EIRA-020-02" value="exists(a:elements/a:element/a:properties/a:property[@propertyDefinitionRef = $PropertyDefinitions[a:name = 'eira:ABB']/@identifier and (a:value = 'eira:MachineToMachineInterfaceApplicationInterface' or a:value = 'eira:HumanInterfaceApplicationInterface')])"/>
	
	<!-- Contexts -->
	<param name="Model" value="/a:model"/>

	<!-- Parameters -->
	<param name="EIRAABB" value="document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = $EIRAPropertyDefinitions[a:name = 'eira:concept']/@identifier and a:value = 'eira:ArchitectureBuildingBlock']]"/>
	<param name="PropertyDefinitions" value="/a:model/a:propertyDefinitions/a:propertyDefinition"/>
	<param name="EIRAPropertyDefinitions" value="document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition"/>
</pattern>