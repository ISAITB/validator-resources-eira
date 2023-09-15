<pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="true" id="Step.01">
	<rule context="$Model">
	    <assert test="$EIRA-001" flag="warning" id="EIRA-001">[EIRA-001] The model must define a view named 'Legal view'.</assert>
	    <assert test="$EIRA-002" flag="warning" id="EIRA-002">[EIRA-002] The model must define a view named 'Organisational view'.</assert>
	    <assert test="$EIRA-003" flag="warning" id="EIRA-003">[EIRA-003] The model must define a view named 'Semantic view'.</assert>
	    <assert test="$EIRA-004" flag="warning" id="EIRA-004">[EIRA-004] The model must define a view named 'Technical view - application'.</assert>
	    <assert test="$EIRA-005" flag="warning" id="EIRA-005">[EIRA-005] The model must define a view named 'Technical view - infrastructure'.</assert>
	    <assert test="$EIRA-006" flag="warning" id="EIRA-006">[EIRA-006] The model must define a view named 'Highlevel viewpoint'.</assert>
	    <assert test="$EIRA-007" flag="warning" id="EIRA-007">[EIRA-007] The model is missing required attribute(s) [<value-of select="$MissingModelAttributeNames"/>].</assert>
	</rule>
 	<rule context="$SolutionBuildingBlock">
	    <assert test="$EIRA-008" flag="fatal" id="EIRA-008">[EIRA-008] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) has an invalid element type '<value-of select="$ElementType"/>'. Expected element type '<value-of select="$SBBEIRAElementType"/>'.</assert>
	    <assert test="$EIRA-009" flag="fatal" id="EIRA-009">[EIRA-009] SBB '<value-of select="$SBBName"/>' references an invalid ABB. No ABB is defined for name '<value-of select="$SBBDeclaredABBName"/>'.</assert>
	    <assert test="$EIRA-010" flag="warning" id="EIRA-010">[EIRA-010] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is missing required attribute(s) [<value-of select="$MissingSBBAttributeNames"/>].</assert>
	    <assert test="$EIRA-011" flag="warning" id="EIRA-011">[EIRA-011] SBB '<value-of select="$SBBName"/>' refers to obsolete ABB '<value-of select="$SBBDeclaredABBName"/>'.</assert>
 	</rule>
 	<rule context="$ArchitectureBuildingBlock">
	    <assert test="$EIRA-012" flag="fatal" id="EIRA-012">[EIRA-012] ABBs must not be defined in a solution.</assert>
	    <assert test="$EIRA-013" flag="fatal" id="EIRA-013">[EIRA-013] ABB defined with element type '<value-of select="$ElementType"/>' that does not match the EIRA. Expected element type '<value-of select="$EIRAElementType"/>'.</assert>
	</rule>
 	<rule context="$SBBPropertyDefinedInEIRA">
	    <assert test="$EIRA-014" flag="warning" id="EIRA-014">[EIRA-014] SBB '<value-of select="$SBBPropertySBBName"/>' (<value-of select="$SBBPropertyDeclaredABBName"/>) defines invalid value '<value-of select="$SBBPropertyValue"/>' for attribute '<value-of select="$SBBPropertyName"/>'. Expected '<value-of select="$ABBExpectedPropertyValue"/>'.</assert>
	    <assert test="$EIRA-015" flag="warning" id="EIRA-015">[EIRA-015] SBB '<value-of select="$SBBPropertySBBName"/>' (<value-of select="$SBBPropertyDeclaredABBName"/>) that is defined as reusable must define attribute 'eira:reuse_status'.</assert>
	    <assert test="$EIRA-016" flag="warning" id="EIRA-016">[EIRA-016] SBB '<value-of select="$SBBPropertySBBName"/>' (<value-of select="$SBBPropertyDeclaredABBName"/>) that is defined as not reusable must not define attribute 'eira:reuse_status'.</assert>
	    <assert test="$EIRA-017" flag="warning" id="EIRA-017">[EIRA-017] SBB '<value-of select="$SBBPropertySBBName"/>' (<value-of select="$SBBPropertyDeclaredABBName"/>) must not define multiple values for attribute '<value-of select="$SBBPropertyName"/>'.</assert>
 	</rule>
</pattern>