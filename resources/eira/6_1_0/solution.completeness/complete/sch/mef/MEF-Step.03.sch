<pattern xmlns="http://purl.oclc.org/dsdl/schematron" is-a="Step.03" id="MEF-Step.03">
	<!-- Tests -->
	<param name="EIRA-018-01" value="exists(a:elements/a:element[matches(string(a:name), 'Public Policy')])"/>
	<param name="EIRA-018-02" value="exists(a:elements/a:element[matches(string(a:name), 'Legal Act')])"/>
	<param name="EIRA-018-03" value="exists(a:elements/a:element[matches(string(a:name), 'Digital Public Service')])"/>
	<param name="EIRA-018-04" value="exists(a:elements/a:element[matches(string(a:name), 'Digital Public Service Provider')])"/>
	<param name="EIRA-018-05" value="exists(a:elements/a:element[matches(string(a:name), 'Digital Public Service Consumer')])"/>
	<param name="EIRA-018-06" value="exists(a:elements/a:element[matches(string(a:name), 'Information')])"/>
	<param name="EIRA-018-07" value="exists(a:elements/a:element[matches(string(a:name), 'Data')])"/>
	<param name="EIRA-018-08" value="exists(a:elements/a:element[matches(string(a:name), 'Data Representation')])"/>
	<param name="EIRA-018-09" value="exists(a:elements/a:element[matches(string(a:name), 'Digital Solution')])"/>
	<param name="EIRA-018-10" value="exists(a:elements/a:element[matches(string(a:name), 'Hosting Facility')])"/>

	<param name="EIRA-019-01" value="exists(a:elements/a:element[matches(string(a:name), '(Data Policy|Descriptive Metadata Policy|Master Data Policy|Base Registry Data Policy|Reference Data Policy|Open Data Policy|Data Portability Policy|Security Policy|Privacy Policy)')])"/>
	<param name="EIRA-019-02" value="exists(a:elements/a:element[matches(string(@xsi:type), 'CommunicationNetwork|TechnologyService|Node') and (let $declaredAbbName := string(a:name) return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and string(a:name) = $declaredAbbName]))])"/>
	<param name="EIRA-019-03" value="exists(a:elements/a:element[matches(string(@xsi:type), 'ApplicationService') and (let $declaredAbbName := string(a:name) return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and string(a:name) = $declaredAbbName]))])"/>
	<param name="EIRA-019-04" value="exists(a:elements/a:element[matches(string(@xsi:type), 'ApplicationComponent') and (let $declaredAbbName := string(a:name) return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'eira:concept']/@identifier) and a:value = 'eira:ArchitectureBuildingBlock'] and string(a:name) = $declaredAbbName]))])"/>

	<param name="EIRA-020-01" value="exists(a:elements/a:element[matches(string(a:name), '(Digital Solution (Service)|Digital Solution (Component))')])"/>
	<param name="EIRA-020-02" value="exists(a:elements/a:element[matches(string(a:name), '(Machine to Machine Interface|Human Interface)')])"/>

	<!-- Contexts -->
	<param name="Model" value="/a:model"/>
</pattern>