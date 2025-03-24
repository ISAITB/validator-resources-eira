<pattern xmlns="http://purl.oclc.org/dsdl/schematron" is-a="Step.03" id="MEF-Step.03">
	<!-- Tests -->
	<param name="EIRA-025-01" value="exists(a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*Public Policy[ \t]*&gt;&gt;.*')])"/>
	<param name="EIRA-025-02" value="exists(a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*Public Service Provider[ \t]*&gt;&gt;.*')])"/>
	<param name="EIRA-025-03" value="exists(a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*Public Service Consumer[ \t]*&gt;&gt;.*')])"/>
	<param name="EIRA-025-04" value="exists(a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*Public Service[ \t]*&gt;&gt;.*')])"/>
	<param name="EIRA-025-05" value="exists(a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*Business Capability[ \t]*&gt;&gt;.*')])"/>
	<param name="EIRA-025-06" value="exists(a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*Exchange of Business Information[ \t]*&gt;&gt;.*')])"/>
	<param name="EIRA-025-07" value="exists(a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*Business Information[ \t]*&gt;&gt;.*')])"/>
	<param name="EIRA-025-08" value="exists(a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*Representation[ \t]*&gt;&gt;.*')])"/>

	<param name="EIRA-026-01" value="exists(a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*(Data|Descriptive Metadata|Transactional Data|Master Data|Open Data|Base Registry|Reference Data)[ \t]*&gt;&gt;.*')])"/>
	<param name="EIRA-026-02" value="exists(a:elements/a:element[matches(string(@xsi:type), 'CommunicationNetwork|TechnologyService|Node') and (let $declaredAbbName := normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '&gt;&gt;')) return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName]))])"/>
	<param name="EIRA-026-03" value="exists(a:elements/a:element[matches(string(@xsi:type), 'ApplicationService') and (let $declaredAbbName := normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '&gt;&gt;')) return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName]))])"/>
	<param name="EIRA-026-04" value="exists(a:elements/a:element[matches(string(@xsi:type), 'ApplicationComponent') and (let $declaredAbbName := normalize-space(substring-before(normalize-space(substring-after(string(a:name), '&lt;&lt;')), '&gt;&gt;')) return exists(document('eira/EIRA.xml')/a:model/a:elements/a:element[a:properties/a:property[@propertyDefinitionRef = string(document('eira/EIRA.xml')/a:model/a:propertyDefinitions/a:propertyDefinition[a:name = 'dct:type']/@identifier) and starts-with(string(a:value), 'eira:')] and string(a:name) = $declaredAbbName]))])"/>

	<param name="EIRA-027-01" value="exists(a:elements/a:element[matches(string(a:name), '&lt;&lt;[ \t]*(Machine to Machine Interface|Human Interface)[ \t]*&gt;&gt;.*')])"/>

	<!-- Contexts -->
	<param name="Model" value="/a:model"/>

</pattern>