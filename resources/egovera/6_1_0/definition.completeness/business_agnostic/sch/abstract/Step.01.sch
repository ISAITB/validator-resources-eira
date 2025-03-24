<pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="true" id="Step.01">
	<rule context="$Model">
		<assert test="$eGovERA-001" flag="error" id="eGovERA-001">[eGovERA-001] Model '<value-of select="$ModelName"/>' has incorrect value in property 'eira:modelType'. The expected value is 'DetailedLevelInteroperabilityRequirementsSolutionArchitectureTemplate'.</assert>
		<assert test="$eGovERA-002-01" flag="warning" id="eGovERA-002-01">[eGovERA-002] The model must define a view named 'Legal view'.</assert>
		<assert test="$eGovERA-002-02" flag="warning" id="eGovERA-002-02">[eGovERA-002] The model must define a view named 'Organisational view'.</assert>
		<assert test="$eGovERA-002-03" flag="warning" id="eGovERA-002-03">[eGovERA-002] The model must define a view named 'Semantic view'.</assert>
		<assert test="$eGovERA-002-04" flag="warning" id="eGovERA-002-04">[eGovERA-002] The model must define a view named 'Technical view - application'.</assert>
		<assert test="$eGovERA-002-05" flag="warning" id="eGovERA-002-05">[eGovERA-002] The model must define a view named 'Technical view - infrastructure'.</assert>
	</rule>

	<rule context="$EIRAArchitectureBuildingBlock">
		<assert test="$eGovERA-003" flag="error" id="eGovERA-003">[eGovERA-003] ABB '<value-of select="$ABBName"/>' is not defined in EIRA model. No match found for PURI '<value-of select="$ABBPURI"/>'.</assert>
		<assert test="$eGovERA-004" flag="error" id="eGovERA-004">[eGovERA-004] ABB '<value-of select="$ABBName"/>' defined with element type '<value-of select="$ABBElementType"/>' that does not match the EIRA. Expected element type '<value-of select="$ABBEIRAElementType"/>'.</assert>
		<assert test="$eGovERA-005" flag="warning" id="eGovERA-005">[eGovERA-005] ABB '<value-of select="$ABBName"/>' is obsolete.</assert>
	</rule>

	<rule context="$eGovERAArchitectureBuildingBlock">
		<assert test="$eGovERA-006" flag="error" id="eGovERA-006">[eGovERA-006] ABB '<value-of select="$ABBName"/>' defined in model '<value-of select="$ModelName"/>' does not have appropiate 'dct:type'. Expected namespace is 'egovera'.</assert>
	</rule>

	<rule context="$SolutionBuildingBlock">
		<assert test="$eGovERA-007" flag="error" id="eGovERA-007">[eGovERA-007] SBB '<value-of select="$SBBName"/>' does not have value especified for property 'eira:ABB'.</assert>
		<assert test="$eGovERA-008" flag="error" id="eGovERA-008">[eGovERA-008] SBB '<value-of select="$SBBName"/>' references invalid ABB. ABB '<value-of select="$SBBDeclaredABBName"/>' is not declared in the eGovERA model.</assert>
	</rule>
</pattern>