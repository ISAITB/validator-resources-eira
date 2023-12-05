<pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="true" id="Step.01">
	<rule context="$Model">
		<assert test="$EIRA-001-01" flag="warning" id="EIRA-001-01">[EIRA-001] The model must define a view named 'Legal view'.</assert>
		<assert test="$EIRA-001-02" flag="warning" id="EIRA-001-02">[EIRA-001] The model must define a view named 'Organisational view'.</assert>
		<assert test="$EIRA-001-03" flag="warning" id="EIRA-001-03">[EIRA-001] The model must define a view named 'Semantic view'.</assert>
		<assert test="$EIRA-001-04" flag="warning" id="EIRA-001-04">[EIRA-001] The model must define a view named 'Technical view - application'.</assert>
		<assert test="$EIRA-001-05" flag="warning" id="EIRA-001-05">[EIRA-001] The model must define a view named 'Technical view - infrastructure'.</assert>

	    <assert test="$EIRA-036" flag="warning" id="EIRA-36">[EIRA-036] At least one SBB should be defined for the 'Interoperability Specification' ABB or one of its specialisations ('Legal', 'Organisational', 'Semantic' or 'Technical Interoperability Specification').</assert>
	</rule>
	<rule context="$SolutionBuildingBlock">
		<assert test="$EIRA-003" flag="fatal" id="EIRA-003">[EIRA-003] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) has an invalid element type '<value-of select="$ElementType"/>'. Expected element type '<value-of select="$EIRASBBElementType"/>'.</assert>
		<assert test="$EIRA-004" flag="fatal" id="EIRA-004">[EIRA-004] SBB '<value-of select="$SBBName"/>' references an invalid ABB. No ABB is defined for name '<value-of select="$SBBDeclaredABBValue"/>'.</assert>
		<assert test="$EIRA-005" flag="warning" id="EIRA-005">[EIRA-005] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is missing required attribute(s) [<value-of select="$MissingSBBAttributeNames"/>].</assert>
		<assert test="$EIRA-006" flag="warning" id="EIRA-006">[EIRA-006] SBB '<value-of select="$SBBName"/>' refers to obsolete ABB '<value-of select="$SBBDeclaredABBName"/>'.</assert>
	</rule>
 	<rule context="$ArchitectureBuildingBlock">
		<assert test="$EIRA-008" flag="fatal" id="EIRA-008">[EIRA-008] ABB '<value-of select="$ABBName"/>' defined with element type '<value-of select="$ElementType"/>' that does not match the EIRA. Expected element type '<value-of select="$EIRAABBElementType"/>'.</assert>
		<assert test="$EIRA-037" flag="warning" id="EIRA-037">[EIRA-037] ABB '<value-of select="$ABBName"/>' does not have an association to an SBB of type 'Interoperability Specification' (or one of its specialisations).</assert>
 	</rule>
 	<rule context="$SBBPropertyDefinedInEIRA">
		<assert test="$EIRA-009" flag="warning" id="EIRA-009">[EIRA-009] SBB '<value-of select="$SBBPropertySBBName"/>' (<value-of select="$SBBPropertyDeclaredABBName"/>) defines invalid value '<value-of select="$SBBPropertyValue"/>' for attribute '<value-of select="$SBBPropertyName"/>'. Expected '<value-of select="$ABBExpectedPropertyValue"/>'.</assert>
		<assert test="$EIRA-010" flag="warning" id="EIRA-010">[EIRA-010] SBB '<value-of select="$SBBPropertySBBName"/>' (<value-of select="$SBBPropertyDeclaredABBName"/>) must not define multiple values for attribute '<value-of select="$SBBPropertyName"/>'.</assert>
		<assert test="$EIRA-028" flag="warning" id="EIRA-028">[EIRA-028] SBB '<value-of select="$SBBPropertySBBName"/>' (<value-of select="$SBBPropertyDeclaredABBName"/>) defines an invalid value '<value-of select="$SBBPropertyValue"/>' for attribute '<value-of select="$SBBPropertyName"/>'. Each defined value must match the ID attribute of another requirement.</assert>
 	</rule>
</pattern>