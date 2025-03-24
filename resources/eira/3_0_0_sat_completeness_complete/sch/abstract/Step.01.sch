<pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="true" id="Step.01">
	<rule context="$Model">
	    <assert test="$EIRA-001-01" flag="fatal" id="EIRA-001-01">[EIRA-001] The model must define a view named 'Legal view'.</assert>
	    <assert test="$EIRA-001-02" flag="fatal" id="EIRA-001-02">[EIRA-001] The model must define a view named 'Organisational view'.</assert>
	    <assert test="$EIRA-001-03" flag="fatal" id="EIRA-001-03">[EIRA-001] The model must define a view named 'Semantic view'.</assert>
	    <assert test="$EIRA-001-04" flag="fatal" id="EIRA-001-04">[EIRA-001] The model must define a view named 'Technical view - application'.</assert>
	    <assert test="$EIRA-001-05" flag="fatal" id="EIRA-001-05">[EIRA-001] The model must define a view named 'Technical view - infrastructure'.</assert>

        <assert test="$EIRA-021" flag="warning" id="EIRA-021">[EIRA-021] At least one SBB should be defined for the 'Interoperability Aspect' ABB.</assert>
	    <assert test="$EIRA-022" flag="warning" id="EIRA-022">[EIRA-022] At least one SBB should be defined for the 'Interoperability Requirement' ABB or one of its specialisations ('Legal', 'Organisational', 'Semantic' or 'Technical Interoperability Requirement').</assert>
		<assert test="$EIRA-023" flag="fatal" id="EIRA-023">[EIRA-023] At least one SBB must be defined for the 'Machine to Machine Interface' or 'Human Interface' ABBs.</assert>
		<assert test="$EIRA-024-01" flag="warning" id="EIRA-024-01">[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Legislation Catalogue' SBB is defined.</assert>
		<assert test="$EIRA-024-02" flag="warning" id="EIRA-024-02">[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Public Service Catalogue' SBB is defined.</assert>
		<assert test="$EIRA-024-03" flag="warning" id="EIRA-024-03">[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Data Set Catalogue' SBB is defined.</assert>
		<assert test="$EIRA-024-04" flag="warning" id="EIRA-024-04">[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Service Registry Component' SBB is defined.</assert>
		<assert test="$EIRA-024-05" flag="warning" id="EIRA-024-05">[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Public Policy Implementation Approach' SBB is defined.</assert>
		<assert test="$EIRA-024-06" flag="warning" id="EIRA-024-06">[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Service Delivery Model' SBB is defined.</assert>
		<assert test="$EIRA-024-07" flag="warning" id="EIRA-024-07">[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Representation' SBB is defined.</assert>
		<assert test="$EIRA-024-08" flag="warning" id="EIRA-024-08">[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Legal Interoperability Agreement' SBB is defined.</assert>
		<assert test="$EIRA-024-09" flag="warning" id="EIRA-024-09">[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Organisational Interoperability Agreement' SBB is defined.</assert>
		<assert test="$EIRA-024-10" flag="warning" id="EIRA-024-10">[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Semantic Interoperability Agreement' SBB is defined.</assert>
		<assert test="$EIRA-024-11" flag="warning" id="EIRA-024-11">[EIRA-024] SBBs should be defined for all key interoperability enablers. No 'Technical Interoperability Agreement' SBB is defined.</assert>
		
		<assert test="$EIRA-036" flag="warning" id="EIRA-36">[EIRA-036] At least one SBB should be defined for the 'Interoperability Specification' ABB or one of its specialisations ('Legal', 'Organisational', 'Semantic' or 'Technical Interoperability Specification').</assert>

	</rule>
	<rule context="$SolutionBuildingBlock">
		<assert test="$EIRA-003" flag="fatal" id="EIRA-003">[EIRA-003] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) has an invalid element type '<value-of select="$ElementType"/>'. Expected element type '<value-of select="$SBBEIRAElementType"/>'.</assert>
		<assert test="$EIRA-004" flag="fatal" id="EIRA-004">[EIRA-004] SBB '<value-of select="$SBBName"/>' references an invalid ABB. No ABB is defined for name '<value-of select="$SBBDeclaredABBName"/>'.</assert>
		<assert test="$EIRA-005" flag="warning" id="EIRA-005">[EIRA-005] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) is missing required attribute(s) [<value-of select="$MissingSBBAttributeNames"/>].</assert>
		<assert test="$EIRA-006" flag="warning" id="EIRA-006">[EIRA-006] SBB '<value-of select="$SBBName"/>' refers to obsolete ABB '<value-of select="$SBBDeclaredABBName"/>'.</assert>
		<assert test="$EIRA-025" flag="fatal" id="EIRA-025">[EIRA-025] SBBs for the 'Interoperability Specification' ABB or one of its specialisations ('Legal', 'Organisational', 'Semantic' or 'Technical Interoperability Specification') are not allowed. SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) must be removed.</assert>
		<assert test="$EIRA-026" flag="fatal" id="EIRA-026">[EIRA-026] Only legal view SBBs may be modeled (unless explicitly allowed). SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) must be removed.</assert>
		<assert test="$EIRA-027" flag="warning" id="EIRA-027">[EIRA-027] SBB '<value-of select="$SBBName"/>' (<value-of select="$SBBDeclaredABBName"/>) should be aggregated by an Interoperability Aspect SBB.</assert>
	</rule>
 	<rule context="$ArchitectureBuildingBlock">
		<assert test="$EIRA-008" flag="fatal" id="EIRA-008">[EIRA-008] ABB '<value-of select="$ABBName"/>' defined with element type '<value-of select="$ElementType"/>' that does not match the EIRA. Expected element type '<value-of select="$EIRAElementType"/>'.</assert>
		<assert test="$EIRA-037" flag="warning" id="EIRA-037">[EIRA-037] ABB '<value-of select="$ABBName"/>' does not have an association to an SBB of type 'Interoperability Specification' (or one of its specialisations).</assert>
 	</rule>
 	<rule context="$SBBPropertyDefinedInEIRA">
		<assert test="$EIRA-009" flag="warning" id="EIRA-009">[EIRA-009] SBB '<value-of select="$SBBPropertySBBName"/>' (<value-of select="$SBBPropertyDeclaredABBName"/>) defines invalid value '<value-of select="$SBBPropertyValue"/>' for attribute '<value-of select="$SBBPropertyName"/>'. Expected '<value-of select="$ABBExpectedPropertyValue"/>'.</assert>
		<assert test="$EIRA-010" flag="warning" id="EIRA-010">[EIRA-010] SBB '<value-of select="$SBBPropertySBBName"/>' (<value-of select="$SBBPropertyDeclaredABBName"/>) must not define multiple values for attribute '<value-of select="$SBBPropertyName"/>'.</assert>
	    <assert test="$EIRA-028" flag="warning" id="EIRA-028">[EIRA-028] SBB '<value-of select="$SBBPropertySBBName"/>' (<value-of select="$SBBPropertyDeclaredABBName"/>) defines an invalid value '<value-of select="$SBBPropertyValue"/>' for attribute '<value-of select="$SBBPropertyName"/>'. Each defined value must match the ID attribute of another requirement.</assert>
 	</rule>
</pattern>