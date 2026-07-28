<pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="true" id="Step.01">
	<rule context="$ArchitectureBuildingBlock">
		<assert test="$eGovERA-009" flag="error" id="eGovERA-009">[eGovERA-009] ABB '<value-of select="$ABBName"/>' is not defined in the selected eGovERA model.</assert>
	</rule>

	<rule context="$SolutionBuildingBlock">
		<assert test="$eGovERA-010" flag="error" id="eGovERA-010">[eGovERA-010] SBB '<value-of select="$SBBName"/>' references invalid ABB. ABB '<value-of select="$SBBDeclaredABBName"/>' is not defined in the selected eGovERA model.</assert>
	</rule>
</pattern>